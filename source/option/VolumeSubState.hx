package option;

import option.OptionsState;
import Controls;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import ui.AtlasText;

class VolumeMenu extends MusicBeatSubstate
{
	public static var musicVolume:Float;
	public static var sfxVolume:Float;
	
	var masterVolumeText:FlxText;
	var masterVolumeBar:FlxBar;
	var masterVolumeAmountText:FlxText;

	var musicVolumeText:FlxText;
	var musicBar:FlxBar;
	var musicAmountText:FlxText;

	var sfxBarVolumeText:FlxText;
	var sfxBar:FlxBar;
	var sfxAmountText:FlxText;

	var descBg:FlxSprite;
	var desctxt:FlxText;
	var curSelected:Int;

	override function create()
		{
			super.create();

			sfxVolume = FlxG.save.data.SFXVolume;
			musicVolume = FlxG.save.data.musicVolume;

			var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.scrollFactor.set(0, 0);
			add(menuBG);
			
			//some text
			masterVolumeText = new FlxText(-300, 130, 800, '', 30);
			masterVolumeText.setFormat(Paths.font("Funkin/Funkin.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			masterVolumeText.text = 'Master Volume';
			masterVolumeText.text = masterVolumeText.text.toUpperCase();
			masterVolumeText.scrollFactor.set();
			add(masterVolumeText);

			musicVolumeText = new FlxText(-300, 350, 800, '', 30);
			musicVolumeText.setFormat(Paths.font("Funkin/Funkin.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			musicVolumeText.text = 'Music Volume';
			musicVolumeText.text = musicVolumeText.text.toUpperCase();
			musicVolumeText.scrollFactor.set();
			add(musicVolumeText);

			sfxBarVolumeText = new FlxText(-300, 570, 800, '', 30);
			sfxBarVolumeText.setFormat(Paths.font("Funkin/Funkin.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			sfxBarVolumeText.text = 'SFX volume';
			sfxBarVolumeText.text = sfxBarVolumeText.text.toUpperCase();
			sfxBarVolumeText.scrollFactor.set();
			add(sfxBarVolumeText);

            //someBar
			masterVolumeBar = new FlxBar(550, FlxG.height * 0.2 + 4, LEFT_TO_RIGHT, 690, 28);
			masterVolumeBar.scrollFactor.set();
			masterVolumeBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true, FlxColor.BLACK);
			add(masterVolumeBar);

			masterVolumeAmountText = new FlxText(513, Std.int(FlxG.height * 0.2) + 1.5, 200, (FlxG.sound.volume * 100) + "%", 30);
			masterVolumeAmountText.scrollFactor.set();
			masterVolumeAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			masterVolumeAmountText.borderColor = 0xff464646;
			masterVolumeAmountText.y = masterVolumeBar.y + (masterVolumeBar.height / 2) - (masterVolumeAmountText.height / 2);
			add(masterVolumeAmountText);

			musicBar = new FlxBar(550, FlxG.height * 0.5 + 4, LEFT_TO_RIGHT, 690, 28);
			musicBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true, FlxColor.BLACK);
			musicBar.scrollFactor.set();
			add(musicBar);

			musicAmountText = new FlxText(513, Std.int(FlxG.height * 0.2) + 1.5, 200, musicVolume * 100 + "%", 30);
			musicAmountText.scrollFactor.set();
			musicAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			musicAmountText.borderColor = 0xff464646;
			musicAmountText.y = musicBar.y + (musicBar.height / 2) - (musicAmountText.height / 2);
			add(musicAmountText);

			sfxBar = new FlxBar(550, FlxG.height * 0.8 + 4, LEFT_TO_RIGHT, 690, 28);
			sfxBar.scrollFactor.set();
			sfxBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true, FlxColor.BLACK);
			add(sfxBar);

			sfxAmountText = new FlxText(513, Std.int(FlxG.height * 0.2) + 1.5, 200, sfxVolume * 100 + "%", 30);
			sfxAmountText.scrollFactor.set();
			sfxAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			sfxAmountText.borderColor = 0xff464646;
			sfxAmountText.y = sfxBar.y + (sfxBar.height / 2) - (sfxAmountText.height / 2);
			add(sfxAmountText);

			descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
			descBg.scrollFactor.set();
		    descBg.alpha = 0.4;
		    add(descBg);
		
		    desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "RESET to clear", 18);
		    desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		    desctxt.borderColor = FlxColor.BLACK;
		    desctxt.borderSize = 1;
		    desctxt.borderStyle = OUTLINE;
		    desctxt.scrollFactor.set();
		    desctxt.screenCenter(X);
		    add(desctxt);

			changeSelection(0);

			trace('Master-Volume: ' + FlxG.save.data.volume);
			trace('Music-Volume: ' + FlxG.save.data.musicVolume);
			trace('SFX-Volume: ' + FlxG.save.data.SFXVolume);
		}

		public function changeSelection(change:Int = 0)
			{
				curSelected += change;

				if (curSelected == 0)
					{
						masterVolumeText.color = FlxColor.YELLOW;
						musicVolumeText.color = FlxColor.WHITE;
						sfxBarVolumeText.color = FlxColor.WHITE;
					}
				
				if (curSelected == 1)
					{
						sfxBarVolumeText.color = FlxColor.WHITE;
						masterVolumeText.color = FlxColor.WHITE;
						musicVolumeText.color = FlxColor.YELLOW;
					}
				
				if (curSelected == 2)
					{
						sfxBarVolumeText.color = FlxColor.YELLOW;
						masterVolumeText.color = FlxColor.WHITE;
						musicVolumeText.color = FlxColor.WHITE;
					}

				if (curSelected < 0)
					{
						curSelected = 0;
					}

				if (curSelected > 2)
					{
						curSelected = 2;
					}
			}

		function updateVolume()
			{
				if (curSelected == 0)
					{
						if (controls.UI_RIGHT_P)
							FlxG.sound.volume += 0.1;
                        if (controls.UI_LEFT_P)
							FlxG.sound.volume -= 0.1;
					}
					
				if (curSelected == 1)
					{
						if (controls.UI_RIGHT_P)
							musicVolume += 0.1;
                        if (controls.UI_LEFT_P)
							musicVolume -= 0.1;

						if (musicVolume > 1)
							musicVolume = 1;

						if (musicVolume < 0)
							musicVolume = 0;
					}

                if (curSelected == 2)
					{
						if (controls.UI_RIGHT_P)
							sfxVolume += 0.1;
                        if (controls.UI_LEFT_P)
							sfxVolume -= 0.1;

						if (sfxVolume > 1)
							sfxVolume = 1;

						if (sfxVolume < 0)
							sfxVolume = 0;
					}

				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.data.SFXVolume = sfxVolume;
				FlxG.save.data.musicVolume = musicVolume;

				masterVolumeBar.value = Math.round(FlxG.sound.volume * 100);
				musicBar.value = Math.round(musicVolume * 100);
			    sfxBar.value = Math.round(sfxVolume * 100);

				masterVolumeAmountText.text = Std.int(FlxG.sound.volume * 100) + "%";
				musicAmountText.text = Std.int(musicVolume * 100) + "%";
				sfxAmountText.text = Std.int(sfxVolume * 100) + "%";

				FlxG.save.flush();
			}

		static public function defaultValue() 
		{
			if (FlxG.save.data.volume == null)
				FlxG.save.data.volume = 1;
            else
				trace('master volume: ' + FlxG.save.data.volume);

			if (FlxG.save.data.musicVolume == null)
				FlxG.save.data.musicVolume = 1;
			else
				trace('music volume: ' + FlxG.save.data.musicVolume);

			if (FlxG.save.data.SFXVolume == null)
				FlxG.save.data.SFXVolume = 1;
			else
				trace('SFX volume: ' + FlxG.save.data.SFXVolume);
		}

		override function update(elapsed:Float)
			{
				FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;
				
				if (controls.UI_UP_P)
					{
						changeSelection(-1);
					}
				if (controls.UI_DOWN_P)
					{
						changeSelection(1);
					}
				super.update(elapsed);
				updateVolume();
				if (controls.RESET)
					defaultValue();
				if (controls.BACK)
					{
						FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
						close();
					}
			}
}
