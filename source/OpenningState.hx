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
    var menuBG:FlxSprite;
    private var camZooming:Bool = false;
    private var camHUD:FlxCamera;

    override public function create() 
    {
        super.create();

        PreferencesMenu.defaultValueInit();
		SomeOption.defaultValueInit();
		LatencyMenu.defaultValue();
		VolumeMenu.defaultValue();
		
		PlayerSettings.init();
		PlayState.checkAchievementsValue();
		Highscore.load();

        camHUD = new FlxCamera();
		FlxG.cameras.add(camHUD, false);
		camHUD.bgColor = 0x00ffffff;
        FlxG.mouse.visible = false;

        menuBG = new FlxSprite().loadGraphic(Paths.image('openning'));
		menuBG.setGraphicSize(FlxG.width, FlxG.height);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set(0, 0);
		add(menuBG);

        menuBG.antialiasing = true;
        menuBG.alpha = 0;

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, -1), {asset: diamond, width: 100, height: 100},
				new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-500, -200, FlxG.width * 6, FlxG.height * 5));

        FlxG.sound.playMusic(Paths.music('Fresh'),  FlxG.save.data.volume * FlxG.save.data.musicVolume, false);
        Conductor.changeBPM(120);
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
			if (FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
				{
					FlxG.camera.zoom += 0.015;
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
			money.y += (i * 80) + 200;
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
		coolText.y += (textGroup.length * 80) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
		FlxTween.tween(coolText, {y: coolText.y - 400}, 0.2, {ease: FlxEase.quadIn});
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
                        case 17:
                            deleteCoolText();
						case 19:
                            FlxG.camera.flash(FlxColor.BLACK, 0.3);
                            menuBG.alpha = 1;
							createCoolText(['Don’t look complacent']);
						case 22:
                            addMoreText('wearin’ those rags');
						case 24:
							addMoreText('you ain’t adjacent');
                        case 26:
                            deleteCoolText();
                            createCoolText(['Lookie I’m fly']);
                        case 28:
                            addMoreText('and you look basic');
						case 30:
							addMoreText('Look in her eyes and');
						case 32:
							addMoreText('I feel like taking it');
                        case 34:
                            addMoreText('for the win');
                        case 36:
                            deleteCoolText();
                            createCoolText(['her dad be evil no twin']);
                        case 38:
                            addMoreText('Skin purp like');
                        case 40:
                            addMoreText('the sprite sippin’');
                        case 43:
                            deleteCoolText();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                            createCoolText(['He open his yap and']);
                        case 45:
                            addMoreText('you wouldn’t believe');
                        case 46:
                            addMoreText('but the sound of');
                        case 48:
                            addMoreText('an angel when he spittin’');
                        case 51:
                            deleteCoolText();
                            createCoolText(['Even though he look']);
                        case 52:
                            addMoreText('like a demon');
                        case 53:
                            addMoreText('hold my blue nuts');
                        case 57:
                            addMoreText('as I battle for the taking');
                        case 59:
                            addMoreText('of this girl');
                        case 61:
                            deleteCoolText();
                            createCoolText(['I just wanna hold her hand']);
                        case 62:
                            addMoreText('look in our DMs and');
                        case 64:
                            addMoreText('it’s like candy land');
                        case 66:
                            addMoreText('Yo');
                        case 68:
                            deleteCoolText();
                            createCoolText(['I really can’t bust']);
                        case 70:
                            addMoreText('when her evil a** dad');
                        case 72:
                            addMoreText('tryna make my a** be grass');
                        case 76:
                            addMoreText('So I got one shot');
                        case 77:
                            addMoreText('when her evil a** dad');
                        case 79:
                            deleteCoolText();
                            createCoolText(['learned to spit real hot']);
                        case 80:
                            addMoreText('and it might just go');
                        case 81:
                            addMoreText('like this');
                        case 83:
                            deleteCoolText();
                            createCoolText(['I don’t mean no disrespect']);
                        case 86:
                            addMoreText('but there’s something');
                        case 89:
                            addMoreText('about her I can’t let go');
                        case 92:
                            deleteCoolText();
                            createCoolText(['Baby you know that', 'I love you']);
                        case 96:
                            addMoreText('even though');
                        case 97:
                            addMoreText('my balls are blue');
                        case 100:
                            deleteCoolText();
                            createCoolText(['I want to spend']);
                        case 102:
                            addMoreText('my life with her');
                        case 103:
                            deleteCoolText();
                            createCoolText(['even if her dad is evil']);
                        case 106:
                            addMoreText('or some sh**');
                        case 108:
                            deleteCoolText();
                            createCoolText(['Now spit it like this:']);
                        case 112:
                            addMoreText('We getting freaky');
                        case 113:
                            addMoreText('on a Friday night');
                        case 114:
                            addMoreText('yeah');
                        case 116:
                            deleteCoolText();
                            createCoolText(['I just want to', 'hold her tight']);
                        case 117:
                            addMoreText('yeah');
                        case 119:
                            deleteCoolText();
                            addMoreText('Her hair her eyes');
                        case 120:
                            addMoreText('her thighs');
                        case 121:
                            addMoreText('yeah');
                        case 123:
                            deleteCoolText();
                            createCoolText(['If I die']);
                        case 124:
                            addMoreText('it’ll all be worth it');
                        case 126:
                            addMoreText('just to get a chance');
                        case 128:
                            addMoreText('to show she’s worth it');
                        case 130:
                            addMoreText('I just want');
                        case 132:
                            addMoreText('hold her tight');
                        case 133:
                            deleteCoolText();
                            createCoolText(['yeah']);
                        case 134:
                            deleteCoolText();
                            createCoolText(['Her hair her eyes']);
                        case 136:
                            addMoreText('her thighs');
                        case 138:
                            addMoreText('yeah');
                        case 140:
                            deleteCoolText();
                            createCoolText(['If I die']);
                        case 141:
                            addMoreText('it’ll all be worth it');
                        case 143:
                            addMoreText('just to get a chance');
                        case 145:
                            addMoreText('to show she’s worth it');
                        case 147:
                            FlxG.camera.flash(FlxColor.BLACK, 0.3);
                            menuBG.alpha = 0;
                            deleteCoolText();
                            createCoolText(['This title is created', 'by salumod']);
                        case 164:
                            skipSongNow();
					}
				}
			}
			lastBeat = curBeat;
    }
}