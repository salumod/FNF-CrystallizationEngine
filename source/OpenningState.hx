package;

import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.FlxState;

class OpenningState extends MusicBeatState
{
    var textGroup:FlxGroup;
    var credGroup:FlxGroup;
    var lastBeat:Int = 0;
    private var camZooming:Bool = false;
    private var camHUD:FlxCamera;

    override public function create() 
    {
        PreferencesMenu.defaultValueInit();
		SomeOption.defaultValueInit();
		LatencyMenu.defaultValue();
		VolumeMenu.defaultValue();
		
		PlayerSettings.init();
		PlayState.checkAchievementsValue();
		Highscore.load();

        super.create();

        camHUD = new FlxCamera();
		FlxG.cameras.add(camHUD, false);
		camHUD.bgColor = 0x00ffffff;

        var menuBG = new FlxSprite().loadGraphic(Paths.image('openning'));
		menuBG.setGraphicSize(FlxG.width, FlxG.height);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set(0, 0);
		add(menuBG);

        menuBG.antialiasing = true;

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, -1), {asset: diamond, width: 100, height: 100},
				new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));

        FlxG.sound.playMusic(Paths.music('Fresh'),  FlxG.save.data.volume * FlxG.save.data.musicVolume, false);
        Conductor.changeBPM(102);
        textGroup = new FlxGroup();
        credGroup = new FlxGroup();
		add(credGroup);

        createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
    }

    function skipSongNow() 
    {
        FlxG.camera.flash(FlxColor.BLACK, 0.3, function () FlxG.switchState(new MainMenuState()));
    }

    override public function update(elapsed:Float) 
    {
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);

        if (FlxG.save.data.zoomOn)
		{
			if (FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
				{
					FlxG.camera.zoom += 0.001;
					camHUD.zoom += 0.003;
				}
		}

        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);
		}

        FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

        songWords();
        if (controls.ACCEPT || FlxG.sound.music == null)
        {
            skipSongNow();
        }
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
            money.cameras = [camHUD];
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
        coolText.cameras = [camHUD];
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

    function songWords() 
    {
			if (curBeat > lastBeat)
			{
				for (i in lastBeat...curBeat)
				{
					switch (i + 1)
					{
						case 10:
							deleteCoolText();
                            createCoolText(['Fresh boyfriend remixed']);
                        case 15:
                            deleteCoolText();
						case 17:
							createCoolText(['Don’t look complacent']);
						case 19:
                            addMoreText('wearin’ those rags');
						case 21:
							deleteCoolText();
							createCoolText(['you ain’t adjacent', 'Lookie I’m fly']);
                        case 23:
                            addMoreText('and you look basic');
						case 25:
							addMoreText('Look in her eyes and');
						case 27:
							addMoreText('I feel like taking it');
                        case 29:
                            addMoreText('for the win');
                        case 30:
                            deleteCoolText();
                            createCoolText(['her dad be evil no twin']);
                        case 33:
                            addMoreText('Skin purp like');
                        case 34:
                            addMoreText('the sprite sippin’');
                        case 36:
                            deleteCoolText();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                            createCoolText(['He open his yap and']);
                        case 38:
                            addMoreText('you wouldn’t believe');
                        case 40:
                            addMoreText('but the sound of');
                        case 42:
                            addMoreText('an angel when he spittin’');
                        case 44:
                            deleteCoolText();
                            createCoolText(['Even though he look']);
                            addMoreText('like a demon');
                        case 46:
                            addMoreText('hold my blue nuts');
                        case 48:
                            addMoreText('as I battle for the taking');
                        case 49:
                            addMoreText('of this girl');
                        case 51:
                            deleteCoolText();
                            createCoolText(['I just wanna hold her hand']);
                        case 53:
                            addMoreText('look in our DMs and');
                        case 55:
                            addMoreText('it’s like candy land');
                        case 56:
                            addMoreText('Yo');
                        case 57:
                            deleteCoolText();
                            createCoolText(['I really can’t bust']);
                        case 59:
                            addMoreText('when her evil a** dad');
                        case 61:
                            addMoreText('tryna make my a** be grass');
                        case 64:
                            addMoreText('So I got one shot');
                            addMoreText('when her evil a** dad');
                        case 65:
                            addMoreText('learned to spit real hot');
                        case 67:
                            addMoreText('and it might just go');
                        case 69:
                            addMoreText('like this');
                        case 71:
                            deleteCoolText();
                            createCoolText(['I don’t mean no disrespect']);
                        case 73:
                            addMoreText('but there’s something');
                        case 75:
                            addMoreText('about her I can’t let go');
                        case 77:
                            deleteCoolText();
                            createCoolText(['Baby you know that', 'I love you']);
                        case 79:
                            addMoreText('even though');
                        case 82:
                            addMoreText('my balls are blue');
                        case 83:
                            addMoreText('I want to spend');
                        case 85:
                            addMoreText('my life with her');
                        case 87:
                            deleteCoolText();
                            createCoolText(['even if her dad is evil']);
                        case 89:
                            addMoreText('or some sh**');
                        case 91:
                            deleteCoolText();
                            createCoolText(['Now spit it like this:']);
                        case 93:
                            addMoreText('We getting freaky');
                        case 95:
                            addMoreText('on a Friday night');
                        case 97:
                            addMoreText('yeah');
                        case 98:
                            deleteCoolText();
                            createCoolText(['I just want to', 'hold her tight']);
                        case 100:
                            addMoreText('yeah');
                        case 101:
                            addMoreText('Her hair her eyes');
                        case 103:
                            addMoreText('her thighs');
                        case 104:
                            addMoreText('yeah');
                        case 105:
                            deleteCoolText();
                            createCoolText(['If I die']);
                        case 106:
                            addMoreText('it’ll all be worth it');
                        case 107:
                            addMoreText('just to get a chance');
                        case 109:
                            addMoreText('to show she’s worth it');
                        case 111:
                            addMoreText('I just want');
                        case 113:
                            addMoreText('hold her tight');
                        case 114:
                            addMoreText('yeah');
                        case 115:
                            deleteCoolText();
                            createCoolText(['Her hair her eyes']);
                        case 116:
                            addMoreText('her thighs');
                        case 117:
                            addMoreText('yeah');
                        case 119:
                            deleteCoolText();
                            createCoolText(['If I die']);
                        case 120:
                            addMoreText('it’ll all be worth it');
                        case 122:
                            addMoreText('just to get a chance');
                        case 123:
                            addMoreText('to show she’s worth it');
                        case 125:
                            deleteCoolText();
                            createCoolText(['This title is created', 'by salumod']);
                        case 141:
                            skipSongNow();
					}
				}
			}
			lastBeat = curBeat;
    }
}