package;

import cpp.Random;
import flixel.util.FlxSave;
import haxe.io.StringInput;
import flixel.addons.ui.FlxUILine;
import cpp.StdString;
import cpp.Function;
import lime.ui.KeyCode;
import haxe.DynamicAccess;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.misc.NumTween;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;                                                                                                                                                                                                                                                                                                                                         
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import lime.app.Application;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import shaderslmfao.BuildingShaders.BuildingShader;
import shaderslmfao.BuildingShaders;
import shaderslmfao.ColorSwap;
#if hxCodec
import hxcodec.VideoHandler;
#end

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;
	private var vocalsFinished:Bool = false;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public  var opponentStrums:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var amCombo:FlxSprite;
	private var numCombo:FlxSprite;
	private var comboScore:Int = 0;
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var timeBG:FlxSprite;
	private var songNameTxt:FlxText;
	private var songInTime:Float;
	private var timeBar:FlxBar;
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var select_score:Int = 0;
	private var must_score:Int = 0;
	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var rtxHUD:FlxCamera;
	private var camGame:FlxCamera;

	private var accuracy:Float = 0.00;
	private var totalPlayed:Int = 0;
	private var totalNotesHit:Float = 0;
	private var s_Rank:Bool = true;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	public static var seenCutscene:Bool = false;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	
	var foregroundSprites:FlxTypedGroup<BGSprite>;
	var fgFlxSprites:FlxTypedGroup<FlxSprite>;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	// var effectSpritebg:FlxEffectSprite;
	// var effectSpritefg:FlxEffectSprite;
	var wiggleShitBg:WiggleEffect = new WiggleEffect();

	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var gfCutsceneLayer:FlxGroup;
	var bfTankCutsceneLayer:FlxGroup;
	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;

	var talking:Bool = true;
	var songScore:Int = 0;
	var misses:Int = 0;
	var perfect:Int = 0;
	var sick:Int = 0;
	var good:Int = 0;
	var bad:Int = 0;
	var shit:Int = 0;
	var comboBreak:Int = 0;
	var rankTxt:FlxText;
	var rankTxtTween:FlxTween;
	var healthTweenObj:FlxTween;

	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public static var campaignScore:Int = 0;
	public static var campaignAccuracy:Float = 0.00;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if discord_rpc
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var camPos:FlxPoint;
	var lightFadeShader:BuildingShaders;
    var dialogueLoad:String = "dialogue/";

	// shader shit
    var pixelShader:MosaicShader;
    var tvShader:VHSShader;

	override public function create()
	{
		FlxG.mouse.visible = false;
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.cache(Paths.inst(PlayState.SONG.song));
		FlxG.sound.cache(Paths.voices(PlayState.SONG.song));

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new SwagCamera();
		camHUD = new FlxCamera();
		rtxHUD = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		rtxHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(rtxHUD, false);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		healthTweenObj = FlxTween.tween(this, {}, 0);

		foregroundSprites = new FlxTypedGroup<BGSprite>();
		fgFlxSprites = new FlxTypedGroup<FlxSprite>();

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'tutorialDialogue'));
			case 'bopeebo':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'bopeeboDialogue'));
			case 'fresh':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'freshDialogue'));
			case 'dadbattle':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'dadbattleDialogue'));
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'thornsDialogue'));
			case 'score':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'scoreDialogue'));
			case '2hot':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + '2hotDialogue'));
			case 'lit-up':
				dialogue = CoolUtil.coolTextFile(Paths.txt(dialogueLoad + 'lit-upDialogue'));
		}

		#if discord_rpc
		initDiscord();
		#end

		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':
				curStage = "spooky";
				defaultCamZoom = 0.9;
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg');

				halloweenBG = new FlxSprite(-500, -300);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'shader');
				halloweenBG.animation.addByPrefix('lightning', 'flash', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				halloweenBG.setGraphicSize(Std.int(halloweenBG.width * 1.5));
				halloweenBG.updateHitbox();
				add(halloweenBG);

				isHalloween = true;
			case 'pico' | 'blammed' | 'philly-nice':
				curStage = 'philly';
				defaultCamZoom = 0.8;
				
				var bg:FlxSprite = new FlxSprite(-270, -100).loadGraphic(Paths.image('philly/sky'));
				bg.setGraphicSize(Std.int(bg.width * 1.4), Std.int(bg.height * 1.4));
				bg.updateHitbox();
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				lightFadeShader = new BuildingShaders();
				phillyCityLights = new FlxTypedGroup<FlxSprite>();

				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					light.shader = lightFadeShader.shader;
					phillyCityLights.add(light);
				}

				// var phillyParticle = new FlxEmitter();
				// phillyParticle.makeParticles(2, 2, FlxColor.RED, 200);
				// phillyParticle.acceleration.set(0, 0, 0, 0, 200, 200, 400, 400);
				// phillyParticle.alpha.set(1, 1, 0, 0);
				// add(phillyParticle);
				// phillyParticle.visible = false;

				var streetBehind:FlxSprite = new FlxSprite(-240, 50).loadGraphic(Paths.image('philly/behindTrain'));
				add(streetBehind);

				phillyTrain = new FlxSprite(3000, 360).loadGraphic(Paths.image('philly/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(streetBehind.x, streetBehind.y).loadGraphic(Paths.image('philly/street'));
				add(street);
			case "milf" | 'satin-panties' | 'high':
				curStage = 'limo';
				defaultCamZoom = 0.70;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
				skyBG.setGraphicSize(Std.int(skyBG.width * 1.3));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var load:FlxSprite = new FlxSprite(-700, 400).loadGraphic(Paths.image('limo/load'));
				load.scrollFactor.set(0.1, 0.1);
				add(load);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
				// overlayShit.shader = shaderBullshit;

				// var invertShader = new InvertShader();
				// FlxG.camera.setFilters([new ShaderFilter(invertShader)]);

				limo = new FlxSprite(-120, 550);
				limo.frames = Paths.getSparrowAtlas('limo/limoDrive');
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
			// add(limo);
			case "cocoa" | 'eggnog':
				curStage = 'mall';

				defaultCamZoom = 0.70;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-900, 700).loadGraphic(Paths.image('christmas/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);

				// var bgrtx:FlxSprite = new FlxSprite(-1700, -400).loadGraphic(Paths.image('christmas/christmasWall'));
				// bgrtx.alpha = 0.7;
				// add(bgrtx);
				// bgrtx.cameras = [rtxHUD];

			case 'winter-horrorland':
				curStage = 'mallEvil';
				defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-500, 700).loadGraphic(Paths.image("christmas/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);

				// var bgrtx:FlxSprite = new FlxSprite(-1700, -400).loadGraphic(Paths.image('christmas/christmasWall'));
				// bgrtx.alpha = 0.1;
				// add(bgrtx);
				// bgrtx.cameras = [rtxHUD];

			case 'senpai' | 'roses':
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);
				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (SONG.song.toLowerCase() == 'roses')
				{
					bgGirls.getScared();
				}
                else
				{
					var lights:FlxSprite = new FlxSprite(0, 0);
					lights.frames = Paths.getSparrowAtlas('weeb/lights');
					lights.animation.addByPrefix('fly', 'lights', 24, true);
					lights.animation.play('fly');
					lights.scrollFactor.set(0.85, 0.85);
					lights.screenCenter();
					add(lights);
					lights.setGraphicSize(widShit);
					lights.updateHitbox();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);

				treeLeaves.color = 0xffb4b4b4;
				fgTrees.color = 0xff8d8d8d;
				bgTrees.color = 0xff8d8d8d;
				bgGirls.color = 0xffb4b4b4;

			case 'thorns':
				curStage = 'schoolEvil';

				var posX = 500;
				var posY = 450;

				wiggleShitBg.effectType = WiggleEffectType.PIXEL_WAVY;
				wiggleShitBg.waveAmplitude = 0.03;
				wiggleShitBg.waveSpeed = 0.4;
				wiggleShitBg.waveFrequency = 2;

				wiggleShit.effectType = WiggleEffectType.PIXEL_DREAMY;
				wiggleShit.waveAmplitude = wiggleShitBg.waveAmplitude;
				wiggleShit.waveSpeed = wiggleShitBg.waveSpeed;
				wiggleShit.waveFrequency = wiggleShitBg.waveFrequency;


				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				bg.setGraphicSize(Std.int(bg.width * daPixelZoom));
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				fg.setGraphicSize(Std.int(fg.width * daPixelZoom));
				add(fg);

                bg.shader = wiggleShitBg.shader;
				fg.shader = wiggleShit.shader;
			case 'guns' | 'stress' | 'ugh':
				defaultCamZoom = 0.90;
				curStage = 'tank';

				var bg:BGSprite = new BGSprite('tankSky', -400, -400, 0, 0);
				bg.setGraphicSize(Std.int(bg.width * 1.1));
				add(bg);

				var tankSky:BGSprite = new BGSprite('tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
				tankSky.active = true;
				tankSky.velocity.x = FlxG.random.float(5, 15);
				add(tankSky);

				var tankMountains:BGSprite = new BGSprite('tankMountains', -300, -20, 0.2, 0.2);
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.2));
				tankMountains.updateHitbox();
				add(tankMountains);

				var tankBuildings:BGSprite = new BGSprite('tankBuildings', -200, 0, 0.30, 0.30);
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
				tankBuildings.updateHitbox();
				add(tankBuildings);

				var tankRuins:BGSprite = new BGSprite('tankRuins', -200, 0, 0.35, 0.35);
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
				tankRuins.updateHitbox();
				add(tankRuins);

				var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
				add(smokeLeft);

				var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
				add(smokeRight);

				// tankGround.

				tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
				add(tankWatchtower);

				tankGround = new BGSprite('tankRolling', 300, 300, 0.5, 0.5, ['BG tank w lighting'], true);
				add(tankGround);
				// tankGround.active = false;

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var tankGround:BGSprite = new BGSprite('tankGround', -420, -150);
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
				tankGround.updateHitbox();
				add(tankGround);

				moveTank();

				// smokeLeft.screenCenter();

				var fgTank0:BGSprite = new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg']);
				foregroundSprites.add(fgTank0);

				var fgTank1:BGSprite = new BGSprite('tank1', -300, 750, 2, 0.2, ['fg']);
				foregroundSprites.add(fgTank1);

				// just called 'foreground' just cuz small inconsistency no bbiggei
				var fgTank2:BGSprite = new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground']);
				foregroundSprites.add(fgTank2);

				var fgTank4:BGSprite = new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg']);
				foregroundSprites.add(fgTank4);

				var fgTank5:BGSprite = new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg']);
				foregroundSprites.add(fgTank5);

				var fgTank3:BGSprite = new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg']);
				foregroundSprites.add(fgTank3);

			case 'score' | 'lit-up' | '2hot':
					    defaultCamZoom = 0.8;
						curStage = 'news';

						var bg:FlxSprite = new FlxSprite(-1600, -300).loadGraphic(Paths.image('town/bg'));
		                bg.scrollFactor.set(0.9, 0.9);
		                add(bg);

						if (SONG.song.toLowerCase() == '2hot')
						{
							var hot:FlxSprite = new FlxSprite(-1000, -1000);
		                    hot.frames = Paths.getSparrowAtlas('town/hot');
		                    hot.animation.addByPrefix('fire', 'fa', 24);
		                    hot.animation.play('fire');
							hot.scrollFactor.set(0.9, 0.9);
							hot.alpha = 0.6;
		                    add(hot);

							var hotrtx:FlxSprite = new FlxSprite(-1700, -400).loadGraphic(Paths.image('town/rtx/hotrtx'));
								hotrtx.alpha = 0.9;
								add(hotrtx);
								hotrtx.cameras = [rtxHUD];
						}

						var fg:FlxSprite = new FlxSprite(-1600, -300).loadGraphic(Paths.image('town/fg'));
		                fg.scrollFactor.set(0.9, 0.9);
		                add(fg);

						var g:FlxSprite = new FlxSprite(-1600, -300).loadGraphic(Paths.image('town/lright'));
		                g.scrollFactor.set(0.9, 0.9);
		                add(g);

						var news:FlxSprite = new FlxSprite(-1600, -300).loadGraphic(Paths.image('town/news'));
		                news.scrollFactor.set(0.9, 0.9);
		                add(news);

						var boxes:FlxSprite = new FlxSprite(-1600, -300).loadGraphic(Paths.image('town/april_for'));
		                boxes.scrollFactor.set(0.9, 0.9);
		                add(boxes);

						fgFlxSprites.add(boxes);

			default:
				defaultCamZoom = 0.6;
				curStage = 'stage';

				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-680, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school' | 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				gfVersion = 'gf-tankmen';
			case 'news':
				gfVersion = 'nene';
		}

		if (SONG.song.toLowerCase() == 'stress')
			gfVersion = 'pico-speaker';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		switch (gfVersion)
		{
			case 'pico-speaker':
				gf.x -= 50;
				gf.y -= 200;

				var tempTankman:TankmenBG = new TankmenBG(20, 500, true);
				tempTankman.strumTime = 10;
				tempTankman.resetShit(20, 600, true);
				tankmanRun.add(tempTankman);

				for (i in 0...TankmenBG.animationNotes.length)
				{
					if (FlxG.random.bool(16))
					{
						var tankman:TankmenBG = tankmanRun.recycle(TankmenBG);
						// new TankmenBG(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
						tankman.strumTime = TankmenBG.animationNotes[i][0];
						tankman.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
						tankmanRun.add(tankman);
					}
				}
		}

		dad = new Character(100, 100, SONG.player2);

		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai' | 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.y += 180;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);
			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case "tank":
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				boyfriend.y += 0;
				dad.y += 60;
				dad.x -= 80;

				if (gfVersion != 'pico-speaker')
				{
					gf.x -= 170;
					gf.y -= 75;
				}
			case 'news':
				gf.y += 0;
				boyfriend.y += 0;
				dad.y += 290;
		}

		add(gf);

		gfCutsceneLayer = new FlxGroup();
		add(gfCutsceneLayer);

		bfTankCutsceneLayer = new FlxGroup();
		add(bfTankCutsceneLayer);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		add(foregroundSprites);
        add(fgFlxSprites);

		if (FlxG.save.data.ImagesEnhancement)
			{
				switch (curStage)
				{
					case 'stage':
						rtxHUD.bgColor = 0x07FFFFFF;
					case 'spooky':
                        rtxHUD.bgColor = 0x2A2802FF;
					// 	dad.color = gf.color = boyfriend.color = 0x41FF4FBB;
					// 	dad.color.alpha = gf.color.alpha = boyfriend.color.alpha = 0;
					case 'phlliy':
						rtxHUD.bgColor = 0x2AF702FF;
					case 'limo':
						var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
						overlayShit.color = 0x54FF9191;
						overlayShit.alpha = 0.5;
						add(overlayShit);
						
						overlayShit.cameras = [rtxHUD];
					case 'mall':
						rtxHUD.bgColor = 0x1F8DDADF;
					case 'mallEvil':
						rtxHUD.bgColor = 0x2FFF379B;
					case 'tank':
						rtxHUD.bgColor = 0x23FFD102;
					case 'school':
						rtxHUD.bgColor = 0x13CA57FF;
					case 'schoolEvil':
						rtxHUD.bgColor = 0x13360069;
						pixelShader = new MosaicShader();
						pixelShader.data.uBlocksize.value = [5, 5];
						FlxG.camera.setFilters([new ShaderFilter(pixelShader)]);
						// FlxG.camera.setFilters([new ShaderFilter(tvShader)]);
					case 'news':
						rtxHUD.bgColor = 0x4D3E0E5A;
				}
			}
			
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 200; // 150 just random ass number lol

		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		// fake notesplash cache type deal so that it loads in the graphic?

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var noteSplash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(noteSplash);
		noteSplash.alpha = 0.1;

		add(grpNoteSplashes);

		opponentStrums = new FlxTypedGroup<FlxSprite>();
		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong();

		#if debug
		    add(strumLine);
        #end

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		timeBG = new FlxSprite(0, FlxG.height * 0.03).loadGraphic(Paths.image('timeBG'));
		timeBG.screenCenter(X);
		timeBG.scrollFactor.set();

		timeBar = new FlxBar(0, FlxG.height * 0.03, LEFT_TO_RIGHT, Std.int(timeBG.width - 2), Std.int(timeBG.height - 2),this,
			'songInTime', 0, 1);
		timeBar.screenCenter(X);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);

		songNameTxt = new FlxText(timeBG.width * 2, FlxG.height * 0.03, "", 20);
		songNameTxt.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		songNameTxt.scrollFactor.set();

		if (FlxG.save.data.downscroll)
		{
			songNameTxt.y = FlxG.height * 0.95;
			timeBar.y = FlxG.height * 0.95;
			timeBG.y = FlxG.height * 0.95;
		}

		add(timeBar);
		add(timeBG);
        add(songNameTxt);

		if (!(FlxG.save.data.timeBar))
			{
				timeBG.visible = false;
				timeBar.visible = false;
				songNameTxt.visible = false;
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (FlxG.save.data.downscroll)
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'', 0, 2);

		if (FlxG.save.data.mirrorMode)
		{
			healthBar.createFilledBar(FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]),
			FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
			healthBar.fillDirection = LEFT_TO_RIGHT;
			healthBar.updateBar();
		}
		else
		{
			healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
					FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			healthBar.updateBar();
		}

		healthBar.scrollFactor.set();

		add(healthBar);
		add(healthBarBG);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		rankTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 180, healthBarBG.y + 30, 0, "", 20);
		rankTxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		rankTxt.alignment = CENTER;
		rankTxt.scrollFactor.set();
		rankTxt.alpha = 0;
		add(rankTxt);

		var version:FlxText = new FlxText(5, FlxG.height - 18, 0, "NE v0.3", 12);
		version.scrollFactor.set();
		version.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(version);

		version.visible = false;

		amCombo = new FlxSprite(FlxG.width * 0.1, FlxG.height * 0.3);
		amCombo.frames = Paths.getSparrowAtlas('AMnotecombo');
		amCombo.animation.addByPrefix('appear', 'NOTE COMBO', 24, false);
		amCombo.scrollFactor.set(0.5, 0.5);
		amCombo.setGraphicSize(Std.int(amCombo.width * 0.945));
		amCombo.updateHitbox();
		amCombo.antialiasing = true;
		add(amCombo);
		amCombo.visible = false;

		numCombo = new FlxSprite(amCombo.x + 380, amCombo.y + 10);
		numCombo.frames = Paths.getSparrowAtlas('noteComboNumbers');
		numCombo.scrollFactor.set(0.5, 0.5);
		numCombo.antialiasing = true;
		numCombo.setGraphicSize(Std.int(numCombo.width * 0.945));
		numCombo.updateHitbox();

		grpNoteSplashes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		timeBG.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		songNameTxt.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		rankTxt.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		doof.cameras = [camHUD];
        version.cameras = [camHUD];
		#if debug
		    strumLine.cameras = [camHUD];
		#end
		// amCombo.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode && !seenCutscene)
		{
			seenCutscene = true;

			switch (curSong.toLowerCase())
			{
				case 'tutorial':
					intro(doof);
				case 'bopeebo':
					intro(doof);
				case 'fresh':
					intro(doof);
				case 'dadbattle':
					intro(doof);
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case "winter-horrorland":
					horrorlandIntro();
				case 'ugh':
					ughIntro();
				case 'stress':
					stressIntro();
				case 'guns':
					gunsIntro();
				case 'score':
					scoreIntro(doof);
				case 'lit-up':
					intro(doof);
				case '2hot':
					hotIntro(doof);
				default:
					startCountdown();
			}
		}
		else
			startCountdown();

		if (FlxG.save.data.ImagesEnhancement)
		{
			if (!(curSong == 'Senpai' || curSong == 'roses'))
			{
				camGame.antialiasing = true;
				rtxHUD.antialiasing = true;
				camHUD.antialiasing = true;
			}
		}

		super.create();
	}

	#if desktop
	function playCutscene(name:String, atEndOfSong:Bool = false)
		{
		  inCutscene = true;
		  FlxG.sound.music.stop();
		
		  var video:VideoHandler = new VideoHandler();
		  video.finishCallback = function()
		  {
			if (atEndOfSong)
			{
			  if (storyPlaylist.length <= 0)
				FlxG.switchState(new StoryMenuState());
			  else
			  {
				SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
				FlxG.switchState(new PlayState());
			  }
			}
			else
				startCountdown();
		  }
		  video.playVideo(Paths.video(name));
		}
    #end
	
	function intro(?dialogueBox:DialogueBox):Void
		{
			songNameTxt.text = 'dialogue';

			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			camFollow.setPosition(camPos.x, camPos.y);
	
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.1);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
						add(dialogueBox);
					}

					else
						startCountdown();
	
				}
			});
		}

		function horrorlandIntro() 
			{
							var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
							add(blackScreen);
							blackScreen.scrollFactor.set();
							camHUD.visible = false;
		
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								remove(blackScreen);
								Events.playSound('Lights_Turn_On');
								camFollow.y = -2050;
								camFollow.x += 200;
								FlxG.camera.focusOn(camFollow.getPosition());
								FlxG.camera.zoom = 1.5;
		
								new FlxTimer().start(0.8, function(tmr:FlxTimer)
								{
									camHUD.visible = true;
									remove(blackScreen);
									FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
										ease: FlxEase.quadInOut,
										onComplete: function(twn:FlxTween)
										{
											startCountdown();
										}
									});
								});
							});
			}

	function ughIntro()
	{
		inCutscene = true;
		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);
		#if web
		var vid:FlxVideo = new FlxVideo('videos/ughCutscene.mp4');
		vid.finishCallback = function()
		{
			remove(blackShit);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		};

		FlxG.camera.zoom = defaultCamZoom * 1.2;

		camFollow.x += 100;
		camFollow.y += 100;
        #else
		FlxG.camera.zoom *= 1.2;
		camFollow.y += 100;

		camFollow.x += 800;
		camFollow.y += 100;

		camFollow.x -= 800;
		camFollow.y -= 100;

		cameraMovement();

		new FlxTimer().start(3, function(tmr:FlxTimer)
			{remove(blackShit);});
		playCutscene('ughCutscene.mp4');
		#end
	}

	function gunsIntro()
	{
		inCutscene = true;

		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);
		#if web
		var vid:FlxVideo = new FlxVideo('videos/gunsCutscene.mp4');
		vid.finishCallback = function()
		{
			remove(blackShit);

			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		};
        #else
		new FlxTimer().start(3, function(tmr:FlxTimer)
			{remove(blackShit);});
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.3}, 4, {ease: FlxEase.quadInOut});
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.4}, 0.4, {ease: FlxEase.quadOut});
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.3}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.45});
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet * 5) / 1000, {ease: FlxEase.quartIn});
		    playCutscene('gunsCutscene.mp4');
		#end
	}

	/**
	 * [
	 * 	[0, function(){blah;}],
	 * 	[4.6, function(){blah;}],
	 * 	[25.1, function(){blah;}],
	 * 	[30.7, function(){blah;}]
	 * ]
	 * SOMETHING LIKE THIS
	 */
	// var cutsceneFunctions:Array<Dynamic> = [];

	function stressIntro()
	{
		inCutscene = true;

		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);
		#if web
		var vid:FlxVideo = new FlxVideo('videos/stressCutscene.mp4');
		vid.finishCallback = function()
		{
			remove(blackShit);

			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		};
        #else
		new FlxTimer().start(3, function(tmr:FlxTimer)
			{remove(blackShit);});
		playCutscene('stressCutscene.mp4');
		#end
	}

	function scoreIntro(?dialogueBox:DialogueBox)
		{
			songNameTxt.text = 'dialogue';

			Events.cameraFade('black', 1);
			Events.playAnim(dad, 'hey');

			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			camFollow.setPosition(camPos.x, camPos.y);
	
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.1);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
						add(dialogueBox);
					}
					else
						startCountdown();
	
				}
			});
		}

	function hotIntro(?dialogueBox:DialogueBox)
		{
			songNameTxt.text = 'dialogue';

			Events.playSound('Boom');
			camHUD.alpha = 0;
			Events.cameraFade('rad', 1);
			Events.playAnim(gf, 'hey');

			FlxTween.tween(camHUD, {alpha: 10}, 3, {ease: FlxEase.backIn, onComplete: function(twe:FlxTween)
				{
					if (dialogueBox != null)
						{
							inCutscene = true;
							add(dialogueBox);
						}
						else
							startCountdown();
				}});
		}

	function initDiscord():Void
	{
		#if discord_rpc
		// storyDifficultyText = difficultyString();
		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		detailsText = isStoryMode ? "Story Mode: Week " + storyWeek : "Freeplay";
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		songNameTxt.text = 'dialogue';

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * daPixelZoom));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += senpaiEvil.width / 5;

		camFollow.setPosition(camPos.x, camPos.y);

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
			else
			    Events.playSound('ANGRY');
			// moved senpai angry noise in here to clean up cutscene switch case lol
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
				tmr.reset(0.3);
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
								swagTimer.reset();
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), FlxG.save.data.volume * FlxG.save.data.SFXVolume, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
						add(dialogueBox);
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer = new FlxTimer();
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		var startTime:Float = 0.0;

		FlxG.save.data.challenge_combo = null;
		FlxG.save.data.challenge_health = null;
		FlxG.save.data.challenge_accuracy = null;
		FlxG.save.data.challenge_Combo = null;
		FlxG.save.data.challenge_Rating_Bad = null;
		FlxG.save.data.challenge_Rating_Sick = null;

		if (FlxG.save.data.challengeMode)
		{
			var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.updateHitbox();
			bg.alpha = 0;
			add(bg);
			bg.cameras = [camHUD];
			
			FlxTween.tween(bg, {alpha: 0.3}, 1.0);

			startTime = 7.0;

			var text:FlxText = new FlxText(400, 100);
			text.scrollFactor.set();
			text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.alignment = CENTER;
			text.updateHitbox();
			text.size = 80;
			text.alpha = 0;
			add(text);
            FlxTween.tween(text, {alpha: 1}, 1.0);

			var task:FlxText = new FlxText(200, 1000);
			task.scrollFactor.set();
			task.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			task.alignment = LEFT;
			task.updateHitbox();
			task.size = 60;
			add(task); 
			FlxTween.tween(task, {y: 200}, 1.0);

			task.text = 'must complete: ';
			text.text = 'THE TASK: ';
			
			var randomTask = FlxG.random.int(1, 3);

			switch (randomTask)
			{
				case 1:
					if (FlxG.save.data.extremeMode)
						{
							FlxG.save.data.challenge_combo = false;
							task.text += '\nFull combo';
						}
					else
						{
							FlxG.save.data.challenge_combo = false;
							task.text += '\ncombo break < 3';
						}
				case 2:
					if (FlxG.save.data.extremeMode)
						{
							FlxG.save.data.challenge_health = false;
							task.text += '\nBeat opponent with full health';
						}
					else
						{
							FlxG.save.data.challenge_health = false;
							task.text += '\nBeat opponent with health(>50%)';
						}
				case 3:
					if (FlxG.save.data.extremeMode)
						{
							FlxG.save.data.challenge_accuracy = false;
							task.text += '\nRank must be greater than A+';
						}
					else
						{
							FlxG.save.data.challenge_accuracy = false;
							task.text += '\nRank must be greater than A';
						}
			}

			task.text += '\nSelective completion:';
			var randomCompletion_Task = FlxG.random.int(1, 3);
			switch (randomCompletion_Task)
			{
				case 1:
					if (!FlxG.save.data.extremeMode)
					{
						FlxG.save.data.challenge_Combo = false;
						task.text += '\nCombo < 300';
					}
					else
						randomCompletion_Task = 2;
				case 2:
					task.text += '\nbad < 10';
				FlxG.save.data.challenge_Rating_Bad = false;
				case 3:
					task.text += '\nsick < 50';
				FlxG.save.data.challenge_Rating_Sick = false;
			}

			task.cameras = [camHUD];
			text.cameras = [camHUD];

			new FlxTimer().start(7.0, function(tmr:FlxTimer)
				{
					FlxTween.tween(bg, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							bg.destroy();
						},
					});

					FlxTween.tween(text, {y: 1000}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							text.destroy();
						},
					});

					FlxTween.tween(task, {y: 1500}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							text.destroy();
						},
					});
				});
		}

		new FlxTimer().start(startTime, function(tmr:FlxTimer)
		{
			inCutscene = false;
			camHUD.visible = true;
	
			//opp
			generateStaticArrows(0);
			//player
			generateStaticArrows(1);
	
			talking = false;
			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
	
			var swagCounter:Int = 0;
	
			startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				// this just based on beatHit stuff but compact
				if (swagCounter % gfSpeed == 0)
					gf.dance();
				if (swagCounter % 2 == 0)
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
						boyfriend.dance();
					if (!dad.animation.curAnim.name.startsWith("sing"))
						dad.dance();
				}
				else if (dad.curCharacter == 'spooky' && !dad.animation.curAnim.name.startsWith("sing"))
					dad.dance();
				if (generatedMusic)
					notes.sort(sortNotes, FlxSort.DESCENDING);
	
				var introSprPaths:Array<String> = ["ready", "set", "go"];
				var altSuffix:String = "";
	
				if (curStage.startsWith("school"))
				{
					altSuffix = '-pixel';
					introSprPaths = ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel'];
				}
	
				var introSndPaths:Array<String> = ["intro3" + altSuffix, "intro2" + altSuffix,
					"intro1" + altSuffix, "introGo" + altSuffix];
	
				if (swagCounter > 0)
					readySetGo(introSprPaths[swagCounter - 1]);
				FlxG.sound.play(Paths.sound(introSndPaths[swagCounter]), FlxG.save.data.volume);
	
				swagCounter += 1;
			}, 4);
		});
	}

	function readySetGo(path:String):Void
	{
		var spr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path));
		spr.scrollFactor.set();

		if (curStage.startsWith('school'))
			spr.setGraphicSize(Std.int(spr.width * daPixelZoom));
		spr.updateHitbox();
		spr.screenCenter();
		add(spr);
		FlxTween.tween(spr, {y: spr.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				spr.destroy();
			}
		});
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;
		previousFrameTime = FlxG.game.ticks;

		songNameTxt.text = SONG.song;

		var songNameTextLength:Float = 4.75;

		songNameTxt.x -= songNameTxt.text.length * songNameTextLength;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if discord_rpc
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	private function generateSong():Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song));
		else
			vocals = new FlxSound();

		vocals.onComplete = function()
		{
			vocalsFinished = true;
		};
		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = (FlxG.save.data.mirrorMode ? !section.mustHitSection : section.mustHitSection);

				if (songNotes[1] > 3)
					gottaHitNote = (FlxG.save.data.mirrorMode ? section.mustHitSection : !section.mustHitSection);

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.altNote = songNotes[3];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (FlxG.save.data.mirrorMode)
					swagNote.x += FlxG.width / 2;

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (FlxG.save.data.mirrorMode)
						sustainNote.x += FlxG.width / 2;

					if (sustainNote.mustPress)
					{
						if (!FlxG.save.data.mirrorMode)
							sustainNote.x += FlxG.width / 2; // general offset
						else
							sustainNote.x -= FlxG.width / 2;
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					if (!FlxG.save.data.mirrorMode)
						swagNote.x += FlxG.width / 2; // general offset
					else
						swagNote.x -= FlxG.width / 2;
				}
			}
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function updateAccuracy()
		{
			totalPlayed += 1;
			accuracy = totalNotesHit / totalPlayed * 100;
			if (accuracy >= 100.00)
				{
					if (misses == 0 && comboBreak == 0 && s_Rank)
						    accuracy = 100.00;
					else
						{
						    accuracy = 99.98;
						}
				}
		}

	// Now you are probably wondering why I made 2 of these very similar functions
	// sortByShit(), and sortNotes(). sortNotes is meant to be used by both sortByShit(), and the notes FlxGroup
	// sortByShit() is meant to be used only by the unspawnNotes array.
	// and the array sorting function doesnt need that order variable thingie
	// this is good enough for now lololol HERE IS COMMENT FOR THIS SORTA DUMB DECISION LOL
	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
	}

	function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{
		return FlxSort.byValues(order, Obj1.strumTime, Obj2.strumTime);
	}

	// ^ These two sorts also look cute together ^

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			var colorswap:ColorSwap = new ColorSwap();

			babyArrow.shader = colorswap.shader;
			colorswap.update(Note.arrowColors[i]);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;

			if (!(FlxG.save.data.ImagesEnhancement))
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			else
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 0.75}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
				playerStrums.add(babyArrow);

			babyArrow.animation.play('static');
			babyArrow.x += 50;

			if (FlxG.save.data.mirrorMode)
			{
				switch (player)
				{
					case 0:
						babyArrow.x += ((FlxG.width / 2) * 1);
					case 1:
						babyArrow.x += ((FlxG.width / 2) * 0);
					default:
						babyArrow.x += ((FlxG.width / 2) * player);
				}
			}
			else
			{
				babyArrow.x += ((FlxG.width / 2) * player);
			}

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if discord_rpc
			if (startTimer.finished)
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			else
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		super.closeSubState();
	}

	#if discord_rpc
	override public function onFocus():Void
	{
		if (health > 0 && !paused && FlxG.autoPause)
		{
			if (Conductor.songPosition > 0.0)
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			else
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (health > 0 && !paused && FlxG.autoPause)
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

		super.onFocusLost();
	}
	#end

	function resyncVocals():Void
	{
		if (_exiting)
			return;

		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;

		if (vocalsFinished)
			return;

		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;

		// makes the lerp non-dependant on the framerate
		// FlxG.camera.followLerp = CoolUtil.camLerpShit(0.04);
		wiggleShit.update(elapsed);
		wiggleShitBg.update(elapsed);
		#if !debug
		perfectMode = false;
		#end

		// do this BEFORE super.update() so songPosition is accurate
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset; // 20 is THE MILLISECONDS??
			// Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}
			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				lightFadeShader.update((Conductor.crochet / 1000) * FlxG.elapsed * 1.5);
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;

			case 'tank':
				moveTank();
		}

		super.update(elapsed);

		healthBar.value = health;
		healthBar.numDivisions = 1000;

		if (perfect != 0 || sick != 0 || good != 0 || bad != 0 || shit != 0 || comboBreak !=0 || songScore != 0)
			{
				rankTxt.text = "Score: " + songScore
				    +
				    if (comboScore != 0)
					' + ' + comboScore
				    + ' | Misses: ' + misses
		            + ' | Accuracy: ' + truncateFloat(accuracy, 2) + "%";
					else
					' | Misses: ' + misses
		            + ' | Accuracy: ' + truncateFloat(accuracy, 2) + "%";

                FlxTween.tween(rankTxt, {alpha: 1}, 1);
			}

			songInTime = FlxG.sound.music.time / FlxG.sound.music.length;

		    // songNameTxt.text = '' + SONG.song;

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
			{
				var boyfriendPos = boyfriend.getScreenPosition();
				var pauseSubState = new PauseSubState(boyfriendPos.x, boyfriendPos.y);
				openSubState(pauseSubState);
				pauseSubState.camera = camHUD;
				boyfriendPos.put();
			}

			#if discord_rpc
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}	

	    if (FlxG.keys.justPressed.SEVEN)
		    {
			    FlxG.switchState(new ChartingState());

			    #if discord_rpc
			    DiscordClient.changePresence("Chart Editor", null, null, true);
			    #end
		    }

		#if debug
		if (FlxG.keys.justPressed.ONE)
			{
				endSong();
			}
        #end

		if (FlxG.keys.justPressed.EIGHT)
			{
			/* 	 8 for opponent char
				SHIFT+8 for player char
				CTRL+SHIFT+8 for gf   */
				if (FlxG.keys.pressed.SHIFT)
					if (FlxG.keys.pressed.CONTROL)
						FlxG.switchState(new AnimationDebug(gf.curCharacter));
					else 
						FlxG.switchState(new AnimationDebug(SONG.player1));
					else
						FlxG.switchState(new AnimationDebug(SONG.player2));
			}

		if (FlxG.keys.justPressed.NINE)
			iconP1.swapOldIcon();

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		// iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.75)));
		// iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.75)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if (!(FlxG.save.data.mirrorMode))
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		    iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01) - iconOffset);
		    iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (health > 2)
			health = 2;

		if (!(FlxG.save.data.mirrorMode))
		{
			if (healthBar.percent < 20)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
	
			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;
		}
		else
		{
			if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;
	
			if (healthBar.percent > 80)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
		}
		
		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

        #if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		if (FlxG.keys.justPressed.PAGEUP)
			changeSection(1);
		if (FlxG.keys.justPressed.PAGEDOWN)
			changeSection(-1);
		#end

		if (generatedMusic && SONG.notes[Std.int(curStep / 16)] != null)
		{
			cameraRightSide = SONG.notes[Std.int(curStep / 16)].mustHitSection;
			cameraMovement();
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		#if dubug
		    songNameTxt.text = 'BEAT: ' + curBeat;
        #end
		
		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		if (!inCutscene && !_exiting)
		{
			// RESET = Quick Game Over Screen
			if (controls.RESET)
			{
				health = 0;
				trace("RESET = True");
			}

			#if CAN_CHEAT // brandon's a pussy
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}
			#end

			if (health <= 0 && (!FlxG.save.data.practiceMode) || FlxG.save.data.extremeMode &&  misses >= 1)
			{
				if (!FlxG.save.data.mirrorMode)
				{
					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
	
					vocals.stop();
					FlxG.sound.music.stop();
	
					// unloadAssets();
	
					deathCounter += 1;
	
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	
					#if discord_rpc
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
					#end
				}
			}
		}

		while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 1800 / SONG.speed)
		{
			var dunceNote:Note = unspawnNotes[0];
			notes.add(dunceNote);

			var index:Int = unspawnNotes.indexOf(dunceNote);
			unspawnNotes.shift();
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if ((FlxG.save.data.downscroll && daNote.y < -daNote.height)
					|| (!FlxG.save.data.downscroll && daNote.y > FlxG.height))
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var strumLineMid = strumLine.y + Note.swagWidth / 2;
				
				if (FlxG.save.data.downscroll)
				{
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;

						if ((!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
							&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= strumLineMid)
						{
							// clipRect is applied to graphic itself so use frame Heights
							var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);

							swagRect.height = (strumLineMid - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.clipRect = swagRect;
						}
					}
				}
				else
				{
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					if (daNote.isSustainNote
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
						&& daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
					{
						var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

						swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;
						daNote.clipRect = swagRect;
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					if (daNote.altNote)
						altAnim = '-alt';

					if (FlxG.save.data.mirrorMode)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								boyfriend.playAnim('singLEFT', true);
							case 1:
								boyfriend.playAnim('singDOWN', true);
							case 2:
								boyfriend.playAnim('singUP', true);
							case 3:
								boyfriend.playAnim('singRIGHT', true);
						}
					}
					else if (!FlxG.save.data.mirrorMode)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}

					if (FlxG.save.data.mirrorMode)
						boyfriend.holdTimer = 0;
					else
					    dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = FlxG.save.data.volume * FlxG.save.data.SFXVolume;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (FlxG.save.data.downscroll)
					{
						if(daNote.y > strumLine.y)
							daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.9 * FlxMath.roundDecimal(SONG.speed, 2)));
					}
				else
				    if(daNote.y < strumLine.y)
					{
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.9 * FlxMath.roundDecimal(SONG.speed, 2)));
					}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * SONG.speed));

				// removing this so whether the note misses or not is entirely up to Note class
				// var noteMiss:Bool = daNote.y < -daNote.height;

				// if (PreferencesMenu.getPref('downscroll'))
				// 	noteMiss = daNote.y > FlxG.height;

				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					if ((!FlxG.save.data.downscroll && daNote.y < -daNote.height)
						|| (FlxG.save.data.downscroll && daNote.y > FlxG.height))
					{
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if (daNote.tooLate || daNote.wasGoodHit)
				{
					Conductor.songPosition += 100;
					if (daNote.tooLate)
					{
						vocals.volume = 0;
						killCombo();
						updateAccuracy();
						if (!(FlxG.save.data.MissbyHitting))
						    noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();
	}

	function killCombo():Void
	{
		if (combo > 5 && gf.animOffsets.exists('sad'))
		    Events.playAnim(gf, 'sad');
		if (combo != 0)
		{
			comboBreak += 1;
			combo = 0;
			displayCombo();
		}
	}

	#if debug
	function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();

		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...(Std.int(curStep / 16 + sec)))
		{
			if (SONG.notes[i].changeBPM)
			{
				daBPM = SONG.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		Conductor.songPosition = FlxG.sound.music.time = daPos;
		updateCurStep();
		resyncVocals();
	}
	#end

	function healthTween(num:Float)
	{
		healthTweenObj.cancel();
		healthTweenObj = FlxTween.num(health, health + num, 0.1, {ease: FlxEase.cubeInOut}, function(v:Float)
		{
			health = v;
		});
	}

	function checkChallenges(?done:Bool):String
	{
			if (!FlxG.save.data.challenge_health && FlxG.save.data.challenge_health != null)
			{
				if (FlxG.save.data.extremeMode)
					{
						if (health == 2)
							done = true;
						must_score = 10000;
					}
					else if (health >= 1)
					{
						done = true;
						must_score = 10000;
					}
			}
	
			if (!FlxG.save.data.challenge_combo && FlxG.save.data.challenge_combo != null)
			{
				if (FlxG.save.data.extremeMode)
					{
						if (comboBreak == 0)
							done = true;
					}
				else if (comboBreak < 3)
				{
					done = true;
					must_score = 10000;
				}
			}
	
			if (!FlxG.save.data.challenge_accuracy && FlxG.save.data.challenge_accuracy != null)
			{
				if (FlxG.save.data.extremeMode)
					{
						if (accuracy >= 97.17 && accuracy < 100)
						{
							done = true;
							must_score = 10000;
						}
					}
				else if (accuracy >= 95 && accuracy < 97.17)
				{
					done = true;
					must_score = 10000;
				}
			}

			if (!FlxG.save.data.challenge_Combo && FlxG.save.data.challenge_Combo != null)
			{
				if (combo < 300)
					select_score = 1000;
			}

			if (!FlxG.save.data.challenge_Rating_Bad && FlxG.save.data.challenge_Rating_Bad != null)
			{
				if (bad < 10)
					select_score = 1000;
			}

			if (!FlxG.save.data.challenge_Rating_Sick && FlxG.save.data.challenge_Rating_Sick != null)
			{
				if (sick < 50)
					select_score = 1000;
			}

		var task:String = '';

		if (done)
			task = 'Task completed';
		else
			task = 'Task failed';

		return task;
	}

	function endSong():Void
	{
		var lerp_Score:Float = 0.0;
		var lerp_Accurany:Float = 0.0;

		seenCutscene = false;
		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (!FlxG.save.data.challengeMode)
		{
			if (SONG.validScore)
				{
					Highscore.saveScore(SONG.song, songScore + comboScore, storyDifficulty, accuracy);
				}
		}

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.alpha = 0.3;
		add(bg);

		var win_text:FlxText = new FlxText(0, 0);
		win_text.scrollFactor.set();
		win_text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		win_text.alpha = 0;
		win_text.alignment = CENTER;
		win_text.text = 'WiN';
		win_text.updateHitbox();
		win_text.size = 60;
		add(win_text);
		FlxTween.tween(win_text, {alpha: 1}, 0.7);
		if (FlxG.save.data.challengeMode)
		{
			win_text.text = checkChallenges();
			if (checkChallenges() == 'Task failed')
			{
				songScore = 0;
				accuracy =0;
				Highscore.saveScore(SONG.song, select_score, storyDifficulty);
				win_text.color = FlxColor.RED;
			}
			else
			{
				Highscore.saveScore(SONG.song, songScore + comboScore + 10000 + select_score, storyDifficulty, accuracy);
				win_text.color = FlxColor.LIME;
			}
				
		}
		else
		{
			if (health >= 0.00001 && health < 1)
			{
				win_text.text = 'SHADE';
				win_text.color = 0xFF966666;
			}
			else if (health == 2)
			{
				win_text.text = 'Complete Victory!';
				win_text.color = FlxColor.YELLOW;
			}
			else
				win_text.text = 'WIN';
		}

		var text:FlxText = new FlxText(0, 1000);
		text.scrollFactor.set();
		text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.alignment = LEFT;
		if (!FlxG.save.data.challengeMode)
		{
			text.text = 'HERE IS YOUR RATING LIST: '+
			'\n score: ' + songScore +
			'\n combo score: ' + comboScore +
			'\n combo break: ' + comboBreak +
			'\n accuracy: ' + truncateFloat(accuracy, 2) + '%' +
			'\n ---------------------' + 
			'\n rank:';
		}
		else
		{
			text.text = 'HERE IS YOUR RATING LIST: '+
			'\n score: ' + songScore +
			'\n combo score: ' + comboScore +
			'\n task score: ' + must_score + '+' + select_score +
			'\n combo break: ' + comboBreak +
			'\n accuracy: ' + truncateFloat(accuracy, 2) + '%' +
			'\n ---------------------' + 
			'\n rank:';
		}
		text.updateHitbox();
		text.size = 35;
		add(text);
        FlxTween.tween(text, {y: 100}, 0.7, {ease: FlxEase.quadIn});

		var rank_text:FlxText = new FlxText(150, 350);
		rank_text.scrollFactor.set();
		rank_text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		if (accuracy >= 0)
			rank_text.text = 'F-';
		if (accuracy >= 30)
			rank_text.text = 'F';
		if (accuracy >= 40)
			rank_text.text = 'F+';
		if (accuracy >= 50)
			rank_text.text = 'D-';
		if (accuracy >= 55)
			rank_text.text = 'D';
		if (accuracy >= 60)
			rank_text.text = 'D+';
		if (accuracy >= 65)
			rank_text.text = 'C-';
		if (accuracy >= 70)
			rank_text.text = 'C';
		if (accuracy >= 78)
			rank_text.text = 'C+';
		if (accuracy >= 80)
			rank_text.text = 'B-';
		if (accuracy >= 85)
			rank_text.text = 'B';
		if (accuracy >= 90)
			rank_text.text = 'B+';
		if (accuracy >= 95)
			rank_text.text = 'A';
		if (accuracy >= 97.17)
			rank_text.text = 'A+';
		if (accuracy == 100)
			rank_text.text = 'SSS';

		rank_text.updateHitbox();
		rank_text.size = 100;
		rank_text.alpha = 0;
		add(rank_text);

		if (FlxG.save.data.challengeMode)
			rank_text.y + 20;

		FlxTween.tween(rank_text, {alpha: 1}, 2, {ease: FlxEase.quadIn});

		var rating:FlxText = new FlxText(-500, 500);
		rating.size = text.size;
		rating.updateHitbox();
		rating.alignment = LEFT;
		rating.font = text.font;
		rating.text = 'perfect: ' + perfect
				    +'\nsick: ' + sick 
			        + '\ngood: ' + good
			        + '\nbad: ' + bad 
					+'\nshit: ' + shit;

		add(rating);
		FlxTween.tween(rating, {x: 0}, 2, {ease: FlxEase.quadIn});

        bg.cameras = [camHUD];
		win_text.cameras = [camHUD];
		text.cameras = [camHUD];
		rank_text.cameras = [camHUD];
		rating.cameras = [camHUD];

		checkAchievements();

		new FlxTimer().start(10.0, function(tmr:FlxTimer)
			{
				if (isStoryMode)
					{
						campaignScore += songScore;
						campaignAccuracy += accuracy;
			
						storyPlaylist.remove(storyPlaylist[0]);
			
						if (storyPlaylist.length <= 0)
						{
							Events.playMusic('freakyMenu');
							transIn = FlxTransitionableState.defaultTransIn;
							transOut = FlxTransitionableState.defaultTransOut;
			
							switch (PlayState.storyWeek)
							{
								case 7:
									// FlxG.switchState(new VideoState());
									FlxG.switchState(new StoryMenuState());
								default:
									FlxG.switchState(new StoryMenuState());
							}
			
							// if ()
							StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
			
							if (SONG.validScore)
							{
								// NGio.unlockMedal(60961);
								Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty, campaignAccuracy);
							}
			
							FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
							FlxG.save.flush();
						}
						else
						{
							var difficulty:String = "";
			
							if (storyDifficulty == 0)
								difficulty = '-easy';
			
							if (storyDifficulty == 2)
								difficulty = '-hard';
			
							trace('LOADING NEXT SONG');
							trace(storyPlaylist[0].toLowerCase() + difficulty);
			
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
			
							FlxG.sound.music.stop();
							vocals.stop();
			
							if (SONG.song.toLowerCase() == 'eggnog')
							{
								var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
									-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
								blackShit.scrollFactor.set();
								add(blackShit);
								camHUD.visible = false;
								inCutscene = true;
			
								FlxG.sound.play(Paths.sound('Lights_Shut_off'), FlxG.save.data.volume * FlxG.save.data.SFXVolume, function()
								{
									// no camFollow so it centers on horror tree
									SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, storyPlaylist[0]);
									LoadingState.loadAndSwitchState(new PlayState());
								});
							}
							else
							{
								prevCamFollow = camFollow;
			
								SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, storyPlaylist[0]);
								LoadingState.loadAndSwitchState(new PlayState());
							}
						}
					}
					else
					{
						trace('WENT BACK TO FREEPLAY??');
						// unloadAssets();
						FlxG.switchState(new FreeplayState());
					}
			});
	}
	// gives score and pops up rating
	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = FlxG.save.data.volume * FlxG.save.data.SFXVolume;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "perfect";

		var isPerfect:Bool = true;

		if (noteDiff > Conductor.safeZoneOffset * 0.8)
		{
			daRating = 'shit';
			score = 50;
			shit += 1;
			isPerfect = false; // shitty copypaste on this literally just because im lazy and tired lol!
			totalNotesHit += 0.10;
			s_Rank = false;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.6)
		{
			daRating = 'bad';
			score = 100;
			bad += 1;
			isPerfect = false;
			totalNotesHit += 0.35;
			s_Rank = false;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.4)
		{
			daRating = 'good';
			score = 200;
			good += 1;
			isPerfect = false;
			totalNotesHit += 0.85;
			s_Rank = false;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'sick';
			score = 300;
			sick += 1;
			isPerfect = false;
			totalNotesHit += 0.9;
			s_Rank = false;
		}
        else
			totalNotesHit += 1;

		if (isPerfect)
		{
			perfect += 1;
			
			if(rankTxtTween != null) {
				rankTxtTween.cancel();
			}
			rankTxt.scale.x = 1.075;
			rankTxt.scale.y = 1.075;
			rankTxtTween = FlxTween.tween(rankTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					rankTxtTween = null;
				}
			});

			if (FlxG.save.data.noteSplash)
				{
					var noteSplash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
					if (FlxG.save.data.ImagesEnhancement)
						noteSplash.alpha = 0.75;
					noteSplash.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
					// new NoteSplash(daNote.x, daNote.y, daNote.noteData);
					grpNoteSplashes.add(noteSplash);
				}
		}

		// Only add the score if you're not on practice mode
		if (!FlxG.save.data.practiceMode)
			songScore += score;

		// ludum dare rating system
		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var ratingPath:String = daRating;

		if (curStage.startsWith('school'))
			ratingPath = "weeb/pixelUI/" + ratingPath + "-pixel";

		rating.loadGraphic(Paths.image(ratingPath));
		rating.x = FlxG.width * 0.55 - 40;
		// make sure rating is visible lol!
		if (rating.x < FlxG.camera.scroll.x)
			rating.x = FlxG.camera.scroll.x;
		else if (rating.x > FlxG.camera.scroll.x + FlxG.camera.width - rating.width)
			rating.x = FlxG.camera.scroll.x + FlxG.camera.width - rating.width;

		rating.y = FlxG.camera.scroll.y + FlxG.camera.height * 0.4 - 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		add(rating);

		if (curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
		}
		rating.updateHitbox();

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
		if (combo >= 10 || combo == 0)
			{
				displayCombo();
			}
	}

	function displayCombo():Void
	{
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.y = FlxG.camera.scroll.y + FlxG.camera.height * 0.4 + 80;
		comboSpr.x = FlxG.width * 0.55;
		// make sure combo is visible lol!
		// 194 fits 4 combo digits
		if (comboSpr.x < FlxG.camera.scroll.x + 194)
			comboSpr.x = FlxG.camera.scroll.x + 194;
		else if (comboSpr.x > FlxG.camera.scroll.x + FlxG.camera.width - comboSpr.width)
			comboSpr.x = FlxG.camera.scroll.x + FlxG.camera.width - comboSpr.width;

		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		add(comboSpr);

		if (curStage.startsWith('school'))
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}
		else
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		comboSpr.updateHitbox();

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		var seperatedScore:Array<Int> = [];
		var tempCombo:Int = combo;

		while (tempCombo != 0)
		{
			seperatedScore.push(tempCombo % 10);
			tempCombo = Std.int(tempCombo / 10);
		}
		while (seperatedScore.length < 3)
			seperatedScore.push(0);

		// seperatedScore.reverse();

		var daLoop:Int = 1;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.y = comboSpr.y;

			if (curStage.startsWith('school'))
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			else
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			numScore.updateHitbox();

			numScore.x = comboSpr.x - (43 * daLoop); //- 90;
			numScore.acceleration.y = FlxG.random.int(200, 300); // v
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
	}

	var cameraRightSide:Bool = false;
    function truncateFloat(number:Float, precision:Int):Float 
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}

	function cameraMovement()
	{
		if (camFollow.x != dad.getMidpoint().x + 150 && !cameraRightSide)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'mom':
					camFollow.y = dad.getMidpoint().y;
				case 'senpai' | 'senpai-angry':
					camFollow.y = dad.getMidpoint().y - 430;
					camFollow.x = dad.getMidpoint().x - 100;
			}

			if (dad.curCharacter == 'mom')
				vocals.volume = FlxG.save.data.volume * FlxG.save.data.SFXVolume;

			if (SONG.song.toLowerCase() == 'tutorial')
				tweenCamIn();
		}

		if (cameraRightSide && camFollow.x != boyfriend.getMidpoint().x - 100)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	private function keyShit():Void
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			if (FlxG.save.data.mirrorMode)
			    dad.holdTimer = 0;
			else
			    boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0)
			{
				for (shit in 0...pressArray.length)
				{ // if a direction is hit that shouldn't be
					if (pressArray[shit] && !directionList.contains(shit))
						noteMiss(shit);
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
						goodNoteHit(coolNote);
				}
			}
			else
			{
				if (FlxG.save.data.MissbyHitting)
					{
						for (shit in 0...pressArray.length)
							if (pressArray[shit])
								noteMiss(shit);
					}
			}
		}

		if (FlxG.save.data.mirrorMode)
		{
			if (dad.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
				{
					if (dad.animation.curAnim.name.startsWith('sing'))
					{
						dad.dance();
					}
				}
		}
		else
		{
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.dance();
					}
				}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		misses += 1;
		// whole function used to be encased in if (!boyfriend.stunned)
		healthTween(-0.1);
		killCombo();

		if (!FlxG.save.data.practiceMode)
			songScore -= 10;

		vocals.volume = 0;
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1 * FlxG.save.data.volume * FlxG.save.data.SFXVolume, 0.2 * FlxG.save.data.volume * FlxG.save.data.SFXVolume));

		/* boyfriend.stunned = true;

		// get stunned for 5 seconds
		new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		}); */

		if (!(FlxG.save.data.mirrorMode))
		{
			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function goodNoteHit(note:Note):Void
	{
		var altAnim:String = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				altAnim = '-alt';
		}

		if (note.altNote)
			altAnim = '-alt';

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note.strumTime, note);
			}

			if (note.noteData >= 0)
				healthTween(0.04);
			else
				healthTween(0.04);

			if (!(FlxG.save.data.mirrorMode))
			{
				switch (note.noteData)
				{
					case 0:
						boyfriend.playAnim('singLEFT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
				}
			}
			else if (FlxG.save.data.mirrorMode)
			{
				switch (note.noteData)
				{
					case 0:
						dad.playAnim('singLEFT' + altAnim, true);
					case 1:
						dad.playAnim('singDOWN' + altAnim, true);
					case 2:
						dad.playAnim('singUP' + altAnim, true);
					case 3:
						dad.playAnim('singRIGHT' + altAnim, true);
				}
			}
			
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
				updateAccuracy();
			}
		}
	}

	function aniCombo(daLoop:Int) 
	{
		if (combo >= 5)
			comboScore += 10;
		if (combo >= 20)
			comboScore += 50;
		if (combo >= 50)
			comboScore += 100;
		if (combo >= 100)
			comboScore += 200;

		amCombo.visible = true;
		amCombo.animation.play('appear', true);

		var tempCombo:Int = combo;
		var seperatedCombo:Array<Int> = [];
        var canAppear:Bool = false;

		while (tempCombo != 0)
		{
			seperatedCombo.push(tempCombo % 10);
			tempCombo = Std.int(tempCombo / 10);
		}
		// while (seperatedCombo.length < 3)
		// 	seperatedCombo.push(0);

		for (i in seperatedCombo)
			{
				numCombo = new FlxSprite(amCombo.x + 380, amCombo.y + 30);
				numCombo.frames = Paths.getSparrowAtlas('noteComboNumbers');
				numCombo.animation.addByPrefix('appear', Std.int(i) + '_appear', false);
				numCombo.animation.addByPrefix('disappear', Std.int(i) + '_disappear', false);
				numCombo.scrollFactor.set(0.5, 0.5);
				numCombo.antialiasing = true;
				numCombo.setGraphicSize(Std.int(numCombo.width * 0.945));
				numCombo.updateHitbox();

				add(numCombo);

				numCombo.x = numCombo.x - (numCombo.width * daLoop);
				numCombo.y = numCombo.y + (40 * daLoop);
				numCombo.animation.play('appear');

				// numCombo.animation.play('disappear');

				FlxTween.tween(numCombo, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numCombo.destroy();
					},
					startDelay: 0.5
				});

				daLoop++;
			}	
	}
	
	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7 * FlxG.save.data.volume * FlxG.save.data.SFXVolume);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	function moveTank():Void
	{
		if (!inCutscene)
		{
			var daAngleOffset:Float = 1;
			tankAngle += FlxG.elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;

			tankGround.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
			tankGround.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
		}
	}

	var tankResetShit:Bool = false;
	var tankMoving:Bool = false;
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX:Float = 400;

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		Events.playAnim(boyfriend, 'scared');
		Events.playAnim(gf, 'scared');

		// rtxHUD.bgColor = 0x2A2802FF;
		// dad.color.alpha = gf.color.alpha = boyfriend.color.alpha = 1;
	}

	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(sortNotes, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		//Load some events(Just One) for the song
		
		if (SONG.loadEvent)
		loadEvent(SONG.song.toLowerCase());

		// HARDCODING FOR MILF ZOOMS!

		if (FlxG.save.data.zoomOn)
		{
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
		}

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (FlxG.save.data.mirrorMode)
		{
			if (!cameraRightSide && curBeat % 18 == 17 && combo >= 5 && dad.holdTimer != 0)
				{
					aniCombo(1);
				}
		}
		else
		{
			if (cameraRightSide && curBeat % 18 == 17 && combo >= 5 && boyfriend.holdTimer != 0)
				{
					aniCombo(1);
				}
		}

		if (curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing"))
				boyfriend.dance();
			if (!dad.animation.curAnim.name.startsWith("sing"))
				dad.dance();
		}
		else if (dad.curCharacter == 'spooky')
		{
			if (!dad.animation.curAnim.name.startsWith("sing"))
				dad.dance();
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			Events.playAnim(boyfriend, 'hey');
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			Events.playAnim(boyfriend, 'hey');
			Events.playAnim(dad, 'cheer');
		}

		foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});

		function camerasIn(beaton:Int, endbeat:Int)
			{
				if (FlxG.save.data.zoomOn)
					{
						if (curBeat >= beaton && curBeat < endbeat)
						    FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			        }
			}

			function camerasOn(beaton:Int, endbeat:Int, cam:Float, zoom:Float)
				{
					if (FlxG.save.data.zoomOn)
						{
							if (curBeat >= beaton && curBeat < endbeat && camZooming && FlxG.camera.zoom < 1.35)
							{
								FlxG.camera.zoom += zoom;
								camHUD.zoom += cam;
							 }
						}
				}
				function blammedChrlight(beaton:Int, endbeat:Int)
					{
						var red = 0xFFFF7676;
						var blue = 0xFF7A7CFF;
						var purple = 0xFFE092FB;
						var orange = 0xFFFFA36D;
						var green = 0xFF62FF56;
					
					    if (curBeat >= beaton && curBeat <= endbeat)
						{
							if (curBeat % 4 == 0)
								{
									if (FlxG.random.bool(20))
									{
										dad.color = red;
										boyfriend.color = red;
									}
									else if (FlxG.random.bool(20))
									{
										dad.color = blue;
										boyfriend.color = blue;
									}
									else if (FlxG.random.bool(20))
									{
										dad.color = purple;
										boyfriend.color = purple;
									}
									else if (FlxG.random.bool(20))
									{
										dad.color = orange;
										boyfriend.color = orange;
									}
									else if (FlxG.random.bool(20))
									{
										dad.color = green;
										boyfriend.color = green;
									}
								}
						}	
					}

					function chrTrail(who:Character, length:Int, delay:Int, alpha:Float, diff:Float, trailremove:Bool, time:Int)
						{
							var trail = new FlxTrail(who, null, length, delay, alpha, diff);
							add(trail);
			
							if (trailremove)
								{
									new FlxTimer().start(time, function(tmr:FlxTimer)
										{
											remove(trail);
										});
								}
						}

				if (curSong =='Blammed')
					{
						blammedChrlight(97, 192);
						switch (curBeat)
						{
							case 97:
								Events.cameraFade('black', 1);
								gf.visible = false;
							case 192:
								Events.cameraFade('black', 1);
								gf.visible = true;
								boyfriend.color = 0x00FFFFFF;
								dad.color = 0x00FFFFFF;
						}
					}

				if (curSong == 'Thorns' && curBeat == 256)
					{
						chrTrail(dad, 4, 24, 0.3, 0.069, true, 10);
						chrTrail(gf, 4, 24, 0.3, 0.069, true, 10);
						chrTrail(boyfriend, 4, 24, 0.3, 0.069, true, 10);
					}

				if (curSong == 'Score')
					{
						if (curBeat % 15 == 0 && curSong == 'Score')
							Events.playAnim(gf, 'hey');

						camerasIn(-5, 10);
						camerasOn(165, 248, 0.015, 0.03);
						camerasIn(196, 200);
						camerasIn(248, 300);

						switch (curBeat)
						{
							case -3:
								FlxG.camera.follow(dad, 1);
						}
					}
				if (curSong == '2Hot')
					{
						camerasOn(168, 200, 0.015, 0.03);
						camerasOn(231, 264, 0.15, 0.4);
					}
					
		// boppin friends
		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					lightFadeShader.reset();

					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'tank':
				tankWatchtower.dance();
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
        else if (isHalloween)
		{
			// rtxHUD.bgColor = 0x67FFFFFF;
			// dad.color.alpha = gf.color.alpha = boyfriend.color.alpha = 0;
		}
		#if debug
		if (curBeat == 3 && curSong == 'Bopeebo')
		    achievements('perfect', 'perfect', -50, -75);
		if (curBeat == 10 && curSong == 'Bopeebo')
		    achievements('FC', 'Full combo!', -80, -105);
		if (curBeat == 17 && curSong == 'Bopeebo')
		    achievements('beat!', 'GF is MINE', -10, -40, 20);
		if (curBeat == 21 && curSong == 'Bopeebo')
		    achievements('week8', 'Week8?!', -50, -50);
		#end
	}

	function loadEvent(songName:String) 
	{
		var eventFile:Array<String> = CoolUtil.coolTextFile(Paths.file("data/" + songName + "/" + "Event.txt"));
        var if_event:String = '';
		var codeFromFile:String = '';

		for (i in eventFile)
			{
				var splitWords:Array<String> = i.split('---');
				if_event = splitWords[0];
				codeFromFile = splitWords[1];
			}

		addEvent(if_event, codeFromFile);
	}

	function addEvent(if_event:String, code)
	{
		Std.isOfType(code, Dynamic);
		Std.isOfType(if_event, Bool);

		// if(if_event = true)
		//     code;

		trace(if_event);
		return;
	}

	function checkAchievements()
	{
        if (combo == 0 && comboBreak == 0 && misses == 0 && !FlxG.save.data.achievements_FC)
			{
				achievements('FC', 'Full combo!', -80, -105);
				FlxG.save.data.achievements_FC = true;
				FlxG.save.flush();
			}

		if (accuracy == 100 && !FlxG.save.data.achievements_perfect && perfect != 0)
			{
				achievements('perfect', 'perfect', -50, -75);
				FlxG.save.data.achievements_perfect = true;
				FlxG.save.flush();
			}

		if (curSong == 'Dadbattle' && accuracy > 90 && !FlxG.save.data.mirrorMode && !FlxG.save.data.beatDad)
			{
				achievements('beat!', 'GF is MINE', -10, -40, 20);
				FlxG.save.data.beatDad = true;
				FlxG.save.flush();
			}
		if ((curSong == 'Score' || SONG.song.toLowerCase() == 'lit-up' || curSong == '2Hot') && !FlxG.save.data.week8)
			{
				achievements('week8', 'Week8?!', -50, -50);
				FlxG.save.data.week8 = true;
				FlxG.save.flush();
			}
	}

	static public function checkAchievementsValue()
	{
		if (FlxG.save.data.achievements_FC == null)
			FlxG.save.data.achievements_FC = false;
		else
			trace('Found achievements: Full Combo ' + FlxG.save.data.achievements_FC);
		if (FlxG.save.data.achievements_perfect == null)
			FlxG.save.data.achievements_perfect = false;
		else
			trace('Found achievements: Perfect ' + FlxG.save.data.achievements_perfect);
		if (FlxG.save.data.beatDad == null)
			FlxG.save.data.beatDad = false;
		else
			trace('Found achievements: GF is MINE ' + FlxG.save.data.beatDad);
		if (FlxG.save.data.week8 == null)
			FlxG.save.data.week8 = false;
		else
			trace('Found achievements: week8?! ' + FlxG.save.data.week8);
	}

	function achievements(achievements:String, ?txt:String, ?icon_off_x = 0, ?icon_off_y = 0, ?txt_size:Int = 30) 
	{
		FlxG.sound.play(Paths.sound('confirmMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);

		var box:FlxSprite = new FlxSprite(FlxG.width * 0.8, FlxG.height * 0.85 + 200);
		box.scrollFactor.set();
		box.loadGraphic(Paths.imageUI('Text_Box'));
		// box.setGraphicSize(Std.int(box.width * 2), Std.int(box.height * 2));
		box.updateHitbox();
		add(box);

		var icon:FlxSprite = new FlxSprite(box.x - box.width / 3 + icon_off_x, FlxG.height * 0.85 + icon_off_y + 200);
		icon.frames = Paths.getSparrowAtlas('achievements/' + achievements);
		icon.scrollFactor.set();
		icon.setGraphicSize(Std.int(icon.width * 0.7), Std.int(icon.height * 0.7));
		icon.animation.addByPrefix('begin', 'begin', 24, false);
		icon.updateHitbox();
		add(icon);

		var text:FlxText = new FlxText(box.x + 40, FlxG.height * 0.87 + 200, 0);
		text.scrollFactor.set();
		text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.text = txt;
		// text.setGraphicSize(Std.int(text.width * 2), Std.int(text.height * 2));
		text.updateHitbox();
		text.size = txt_size;
		add(text);

		text.cameras = [rtxHUD];
		icon.cameras = [rtxHUD];
		box.cameras = [rtxHUD];

		FlxTween.tween(box, {y: box.y - 200}, 0.7);
		FlxTween.tween(text, {y: text.y - 200}, 0.7);
		FlxTween.tween(icon, {y: icon.y -  200}, 0.7, {
			onComplete: function(tween:FlxTween){
				icon.animation.play('begin');
			}
		});

		new FlxTimer().start(5.0, function(tmr:FlxTimer)
			{
				FlxTween.tween(icon, {y: FlxG.height * 1.5}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						icon.destroy();
					}
			    });

				FlxTween.tween(text, {y: FlxG.height * 1.5}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						text.destroy();
					}
			    });

				FlxTween.tween(box, {y: FlxG.height * 1.5}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						box.destroy();
					}
			    });

			});
	}

	var curLight:Int = 0;
}
//demo version has no bin right :(