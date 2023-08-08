package;

import funkin.VideoState;
import funkin.Alphabet;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import lime.app.Application;
import lime.ui.Window;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.AsyncErrorEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import shaderslmfao.BuildingShaders.BuildingShader;
import shaderslmfao.BuildingShaders;
import shaderslmfao.ColorSwap;
import ui.PreferencesState;

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end
#if desktop
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
#end

#if polymod
import polymod.Polymod;
#end
import ui.VolumeState;

class TitleState extends MusicBeatState
{
	public static var initialized:Bool = false;
	var startedIntro:Bool;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var tweenColor:FlxTween;
	var loadBar:FlxSprite;

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;
	var lastBeat:Int = 0;
	var swagShader:ColorSwap;
	var alphaShader:BuildingShaders;
	var thingie:FlxSprite;

	var video:Video;
	var netStream:NetStream;

	public static var onlineVersion:String;
	private var overlay:Sprite;

	override public function create():Void
	{
		#if debug
		//crash
		//FlxG.log.redirectTraces = true;
		#end
		startedIntro = false;
		FlxG.mouse.visible = false;
		
		FlxG.game.focusLostFramerate = 60;

		swagShader = new ColorSwap();
		alphaShader = new BuildingShaders();

		FlxG.sound.muteKeys = [ZERO];

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		PreferencesState.initPrefs();
		PlayerSettings.init();
		Highscore.load();

		#if newgrounds
		NGio.init();
		#end

		var funkay:FlxSprite = new FlxSprite();
		funkay.loadGraphic(Paths.image('funkay'));
		funkay.setGraphicSize(Std.int(FlxG.width * 1), Std.int(FlxG.height * 1));
		funkay.updateHitbox();
		funkay.antialiasing = true;
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(Std.int(FlxG.width * 0.5), 10, 0xFFff16d2);
		loadBar.screenCenter(X);
		add(loadBar);

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		if (FlxG.save.data.seenVideo != null)
		{
			VideoState.seenVideo = FlxG.save.data.seenVideo;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif ANIMATE
		FlxG.switchState(new CutsceneAnimTestState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#elseif web
			if (!initialized)
			{

				video = new Video();
				FlxG.stage.addChild(video);

				var netConnection = new NetConnection();
				netConnection.connect(null);

				netStream = new NetStream(netConnection);
				netStream.client = {onMetaData: client_onMetaData};
				netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);
				netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
				// netStream.addEventListener(NetStatusEvent.NET_STATUS) // netStream.play(Paths.file('music/kickstarterTrailer.mp4'));

				overlay = new Sprite();
				overlay.graphics.beginFill(0, 0.5);
				overlay.graphics.drawRect(0, 0, 1280, 720);
				overlay.addEventListener(MouseEvent.MOUSE_DOWN, overlay_onMouseDown);

				overlay.buttonMode = true;
				// FlxG.stage.addChild(overlay);

			}

		// netConnection.addEventListener(MouseEvent.MOUSE_DOWN, overlay_onMouseDown);
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		#if discord_rpc
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
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
			// netStream.dispose();
			// FlxG.stage.removeChild(video);

			startIntro();
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

	var logoBl:FlxSprite;

	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxText;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, -1), {asset: diamond, width: 100, height: 100},
				new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));
		}

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

        logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');

		logoBl.updateHitbox();

		// logoBl.screenCenter();
		// logoBl.shader = swagShader.shader;
		// logoBl.shader = alphaShader.shader;
		add(logoBl);

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('characters/GF_assets', "shared");
		gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.animation.addByPrefix('cheer', 'GF Cheer', 24, true);
		gfDance.antialiasing = true;
		add(gfDance);

		gfDance.shader = swagShader.shader;

		// swagShader.colorToReplace = 0xFFF939A9;
		// swagShader.newColor = 0xFFAE00FF;

		titleText = new FlxText(100, FlxG.height * 0.8);
		titleText.text = "Press Enter to Begin";
		titleText.setFormat(Paths.font("statusplz.ttf"), 100);
		tweenColor = FlxTween.color(titleText, 1, FlxColor.CYAN, FlxColor.BLUE, {type: PINGPONG});
		titleText.alpha = 0.3;
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		// var atlasBullShit:FlxSprite = new FlxSprite();
		// atlasBullShit.frames = CoolUtil.fromAnimate(Paths.image('money'), Paths.file('images/money.json'));
		// credGroup.add(atlasBullShit);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.8).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 1.1));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;
		ngSpr.alpha = 0;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		/*
		if (FlxG.sound.music != null)
			FlxG.sound.music.onComplete = function() FlxG.switchState(new VideoState());
		*/

		startedIntro = true;
		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		loadBar.scale.x += elapsed * 1.2;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new CutsceneAnimTestState());
		#end

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				{
					pressedEnter = true;
				}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				{

					pressedEnter = true;
				}

			#if switch
			if (gamepad.justPressed.B)
				{
					pressedEnter = true;
				}
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.onComplete = null;

			gfDance.animation.play('cheer');
			// netStream.play(Paths.file('music/kickstarterTrailer.mp4'));
			//NGio.unlockMedal(60960);

			/* If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			*/

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume * 0.7);

			transitioning = true;

			titleText.color = FlxColor.WHITE;

		    FlxTween.tween(titleText, {alpha: 1}, 0.5);
			FlxTween.tween(logoBl, {y: logoBl.y - 2000}, 0.3, {ease: FlxEase.quadInOut});
			FlxTween.tween(gfDance, {x: gfDance.x - 2000}, 0.6, {ease: FlxEase.quadInOut});
			tweenColor.cancel();
			// FlxG.sound.music.stop();

			// if (!OutdatedSubState.leftState)
			// 	{
			// 		var ver = "v" + Application.current.meta.get('version');
            //         var versionHttp = "https://raw.githubusercontent.com/salumod/FNF-CrystallizationEngine/week8/onlineVersion.txt";
			// 		var http = new haxe.Http(versionHttp);

			//         http.onData = function (data:String)
			//         {
			// 	        onlineVersion = data.split('\n')[0].trim();
			// 			trace(onlineVersion);
			// 	        if(ver.trim() !=  "v" + onlineVersion) 
			// 			    FlxG.switchState(new OutdatedSubState());
			// 			else
			// 				FlxG.switchState(new MainMenuState());
			//         }

			//         http.onError = function (error) {
			// 		FlxG.switchState(new MainMenuState());
			// 	    trace('error: $error');
			//     }

			//         http.request();
			// 	}
			// else
			//    FlxG.switchState(new MainMenuState());
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
		}

		if (pressedEnter && !skippedIntro && initialized)
			skipIntro();
			#if web
			if (!initialized && controls.ACCEPT)
			{
				// netStream.dispose();
				// FlxG.stage.removeChild(video);

				startIntro();
				skipIntro();
			}
			#end

		// if (FlxG.keys.justPressed.SPACE)
		swagShader.hasOutline = true;
		
		if (controls.UI_LEFT)
			swagShader.update(-elapsed * 0.1);

		if (controls.UI_RIGHT)
			swagShader.update(elapsed * 0.1);

		if (controls.BACK)
			FlxG.switchState(new CloseGameState());
		
		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, -300, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
			FlxTween.tween(money, {y: money.y + 300}, 0.2, {ease: FlxEase.quadIn});
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 400, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
		FlxTween.tween(coolText, {y: coolText.y - 400}, 0.3, {ease: FlxEase.quadIn});
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	var isRainbow:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (!startedIntro)
			return ;

		if (skippedIntro)
		{
			logoBl.animation.play('bump', true);

			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}
		else
		{
			FlxG.log.add(curBeat);
			// if the user is draggin the window some beats will
			// be missed so this is just to compensate
			if (curBeat > lastBeat)
			{
				for (i in lastBeat...curBeat)
				{
					switch (i + 1)
					{
						case 1:
							createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
						// credTextShit.visible = true;
						case 3:
							addMoreText('present');
						// credTextShit.text += '\npresent...';
						// credTextShit.addText();
						case 4:
							deleteCoolText();
						// credTextShit.visible = false;
						// credTextShit.text = 'In association \nwith';
						// credTextShit.screenCenter();
						case 5:
							createCoolText(['In association', 'with']);
						case 7:
							addMoreText('newgrounds');
							FlxTween.tween(ngSpr, {y: ngSpr.y - 100, alpha: 1}, 0.5);
						// credTextShit.text += '\nNewgrounds';
						case 9:
							deleteCoolText();
							ngSpr.visible = false;
						// credTextShit.visible = false;

						// credTextShit.text = 'Shoutouts Tom Fulp';
						// credTextShit.screenCenter();
						case 10:
							createCoolText([curWacky[0]]);
						// credTextShit.visible = true;
						case 12:
							addMoreText(curWacky[1]);
						case 14:
							addMoreText('sounds good');
						case 16:
							deleteCoolText();
						case 17:
							createCoolText(['HA']);
						case 18:
							addMoreText('YOU ARE SO CUTE');
						case 19:
							deleteCoolText();
						case 20:
							createCoolText(['BEBOBE']);
						case 21:
							addMoreText('LET US SING A SONG');
						// credTextShit.text += '\nlmao';
						case 23:
							deleteCoolText();
						// credTextShit.visible = false;
						// credTextShit.text = "Friday";
						// credTextShit.screenCenter();
						case 24:
							createCoolText(['Friday']);
						// credTextShit.visible = true;
						case 25:
							addMoreText('Night');
						case 26:
							addMoreText('Funkin');
						case 27:
							skipIntro();
					}
				}
			}
			lastBeat = curBeat;
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
