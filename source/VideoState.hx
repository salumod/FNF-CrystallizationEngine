package;

import flixel.FlxG;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
#if hxCodec
import hxcodec.VideoHandler;
#end

class VideoState extends MusicBeatState
{
	var video:Video;
	var netStream:NetStream;
	var inCutscene:Bool = false;

	private var overlay:Sprite;

	public static var seenVideo:Bool = false;

	override function create()
	{
		super.create();

		seenVideo = true;

		FlxG.save.data.seenVideo = true;
		FlxG.save.flush();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		video = new Video();
		FlxG.addChildBelowMouse(video);
        #if web
		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		// netStream.addEventListener(NetStatusEvent.NET_STATUS);
		netStream.play(Paths.file('videos/kickstarterTrailer.mp4'));

		overlay = new Sprite();
		overlay.graphics.beginFill(0, 0.5);
		overlay.graphics.drawRect(0, 0, 1280, 720);
		overlay.addEventListener(MouseEvent.MOUSE_DOWN, overlay_onMouseDown);

		overlay.buttonMode = true;
		// FlxG.stage.addChild(overlay);
        #else
		playCutscene('kickstarterTrailer.mp4');
		#end
	}

	function playCutscene(name:String)
		{
		  inCutscene = true;
		  FlxG.sound.music.stop();
		
		  var video:VideoHandler = new VideoHandler();
		  video.finishCallback = function()
		  {
			TitleState.initialized = false;
		    FlxG.switchState(new TitleState());
		  }
		  video.playVideo(Paths.video(name));
		}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			finishVid();

		super.update(elapsed);
	}

	function finishVid():Void
	{
		netStream.dispose();
		FlxG.removeChild(video);

		TitleState.initialized = false;
		FlxG.switchState(new TitleState());
	}

	private function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = video.videoWidth;
		video.height = video.videoHeight;
		// video.
	}

	private function netStream_onAsyncError(event:AsyncErrorEvent):Void
	{
		trace("Error loading video");
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == 'NetStream.Play.Complete')
		{
			finishVid();
		}

		trace(event.toString());
	}

	private function overlay_onMouseDown(event:MouseEvent):Void
	{
		netStream.soundTransform.volume = 0.2;
		netStream.soundTransform.pan = -1;
		// netStream.play(Paths.file('music/kickstarterTrailer.mp4'));

		FlxG.stage.removeChild(overlay);
	}
}
