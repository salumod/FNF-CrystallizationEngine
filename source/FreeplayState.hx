package;

import flixel.FlxCamera;
import funkin.Alphabet;
import funkin.GameUI;
#if discord_rpc
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;

import haxe.Json;

using StringTools;

typedef JsonSongs = {
	var init:Array<Dynamic>;
}

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	// var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var lerpAccuracy:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0.00;

	var coolColors:Array<Int> = [
		0xff9271fd,
		0xff9271fd,
		0xff223344,
		0xFF941653,
		0xFFfc96d7,
		0xFFa0d1ff,
		0xffff78bf,
		0xfff6b604,
		0xff7f49ff
	];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	private var json:JsonSongs;
	var bg:FlxSprite;
	var songWait:FlxTimer = new FlxTimer();
	var descBg:FlxSprite;
	var desctxt:FlxText;
	
	var gamePad:GamePadOn;
    var cover_Vol1:FlxSprite;
	var cover_Vol2:FlxSprite;
	var cover_Vol3:FlxSprite;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
    var CD:FlxSprite;

	override function create()
	{
		#if discord_rpcinitSonglist
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		addSong('Test', 1, 'bf-pixel');
		#end

		json = Json.parse(Assets.getText('assets/data/freeplaySonglist.json'));
		for (i in json.init)
			{
				songs.push(new SongMetadata(''+ Std.string(i[0]),i[1],''+Std.string(i[2])));
			}

		// LOAD MUSIC
		FlxG.sound.playMusic(Paths.music('Freeplay Menu'), FlxG.save.data.volume * FlxG.save.data.musicVolume, true);

		// LOAD CHARACTERS

		camGame = new SwagCamera();
		FlxG.cameras.reset(camGame);
		camHUD = new FlxCamera();
		FlxG.cameras.add(camHUD, false);
		camHUD.bgColor = 0x00ffffff;

		Conductor.changeBPM(120);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, 0);
		add(bg);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "49324858", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("Difficult.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.color = FlxColor.WHITE;
		scoreText.scrollFactor.set(0, 0);
		scoreText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4);
		// scoreText.alignment = RIGHT;
		scoreText.antialiasing = true;

		cover_Vol1 = new FlxSprite(FlxG.width * 0.77, 0).loadGraphic(Paths.image('vol_cover/Vol.1'));
		cover_Vol1.visible = false;
		cover_Vol1.screenCenter();
		cover_Vol1.setGraphicSize(630);
		cover_Vol1.antialiasing = true;
		cover_Vol1.alpha = 0.7;
		add(cover_Vol1);

		cover_Vol2 = new FlxSprite(FlxG.width * 0.77, 0).loadGraphic(Paths.image('vol_cover/Vol.2'));
		cover_Vol2.visible = false;
		cover_Vol2.screenCenter();
		cover_Vol2.setGraphicSize(630);
		cover_Vol2.antialiasing = true;
		cover_Vol2.alpha = 0.7;
		add(cover_Vol2);
		
		cover_Vol3 = new FlxSprite(FlxG.width * 0.77, 0).loadGraphic(Paths.image('vol_cover/Vol.3'));
		cover_Vol3.visible = false;
		cover_Vol3.updateHitbox();
		cover_Vol3.screenCenter();
		cover_Vol3.setGraphicSize(630);
		cover_Vol3.antialiasing = true;
		cover_Vol3.alpha = 0.7;
		add(cover_Vol3);

		CD = new FlxSprite(100, 100).loadGraphic(Paths.image('vol_CD'));
		CD.visible = true;
		// CD.setGraphicSize(1);
		CD.screenCenter();
		CD.updateHitbox();
		CD.scrollFactor.set(0, 0);
		add(CD);

		diffText = new FlxText(scoreText.x, FlxG.height * 0.925, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.scrollFactor.set(0, 0);
		diffText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4);
        diffText.antialiasing = true;
		
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		
		grpSongs.cameras = [camHUD];

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;

			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
            icon.cameras = [camHUD];
			
			songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.alpha = 0.4;
		descBg.scrollFactor.set(0, 0);
		add(descBg);

		add(scoreText);
		add(diffText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		// selector = new FlxText();

		// selector.size = 40;
		// selector.text = ">";
		// add(selector);

		gamePad = new GamePadOn("PLAY", "LISTEN", "CLEAR", "BACK");
		// add(gamePad);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		FlxG.watch.addQuick("CD.x", CD.x);
		FlxG.watch.addQuick("CD.y", CD.y);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;

		if (FlxG.save.data.zoomOn)
		{
			if (FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
				{
					FlxG.camera.zoom += 0.001;
					camHUD.zoom += 0.003;
				}
		}

		if (controls.PAUSE)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);

		if (controls.RESET)
			{
				Highscore.resetSong(songs[curSelected].songName, curDifficulty);
			}

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);
		lerpAccuracy = CoolUtil.coolLerp(lerpAccuracy, intendedRating, 0.4);
		bg.color = FlxColor.interpolate(bg.color, coolColors[songs[curSelected].week % coolColors.length], CoolUtil.camLerpShit(0.045));

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore) + "(ACCURACY: "+ Math.round(lerpAccuracy) + "%)";

		positionHighscore();

		if (songs[curSelected].week == 0 ||
			songs[curSelected].week == 1 ||
			songs[curSelected].week == 2 ||
			songs[curSelected].week == 3 ||
			songs[curSelected].week == 4)
		{
			cover_Vol1.visible = true;
			cover_Vol2.visible = false;
			cover_Vol3.visible = false;
		}
		else if (songs[curSelected].week == 5 ||
			songs[curSelected].week == 6 ||
			songs[curSelected].week == 7)
		{
			cover_Vol1.visible = false;
			cover_Vol2.visible = true;
			cover_Vol3.visible = false;
		}
		else if (songs[curSelected].week == 8)
		{
			cover_Vol1.visible = false;
			cover_Vol2.visible = false;
			cover_Vol3.visible = true;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel / 1));

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);

		PlayState.storyDifficulty = curDifficulty;

		diffText.text = "< " + CoolUtil.difficultyString() + " >";
		positionHighscore();

		diffText.alpha = 0.1;

		FlxTween.tween(diffText, {y: FlxG.height * 0.925, alpha: 1}, 0.07);
	}

	function changeSelection(change:Int = 0)
	{

		// NGio.logEvent('Fresh');
		FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;
		FlxG.sound.play(Paths.sound('scrollMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);

		// lerpScore = 0;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function positionHighscore()
	{
		scoreText.screenCenter(X);
		scoreText.y = FlxG.height * 0.875;

		diffText.screenCenter(X);
		diffText.y = FlxG.height * 0.925;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
