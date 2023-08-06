package ui;

import ui.OptionsState.OptionsMenu;
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

class VolumeState extends MusicBeatState
{
	public static var musicVolume:Float = 1;
	public static var sfxVolume:Float = 1;
	
	var masterVolumeBar:FlxBar;
	var masterVolumeAmountText:FlxText;

	var musicBar:FlxBar;
	var musicText:FlxText;
	var musicAmountText:FlxText;

	var sfxBar:FlxBar;
	var sfxText:FlxText;
	var sfxAmountText:FlxText;

	var volumeNameText:FlxText;

	var descBg:FlxSprite;
	var desctxt:FlxText;

	override function create()
		{
			var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
            menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
            menuBG.updateHitbox();
            menuBG.screenCenter();
            menuBG.scrollFactor.set(0, 0);
            add(menuBG);
			
			super.create();

			FlxG.save.bind("volume-save-data", "The-Funkin-Crew");

			volumeTextThing(-300, 130, 'master-volume');
			volumeTextThing(-300, 350, 'music-volume');
			volumeTextThing(-300, 570, 'sfx-volume');

			barThing(540, FlxG.height * 0.2, 'master-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.2), 513, Std.int(FlxG.height * 0.2) + 1.5);
			barThing(540, FlxG.height * 0.5, 'music-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.5), 513, Std.int(FlxG.height * 0.5) + 1.5) ;
			barThing(540, FlxG.height * 0.8, 'sfx-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.8), 513, Std.int(FlxG.height * 0.8) + 1.5);

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

			trace('Master-Volume: ' + FlxG.save.data.volume);
			trace('Music-Volume: ' + FlxG.save.data.musicVolume);
			trace('SFX-Volume: ' + FlxG.save.data.SFXVolume);
		}
	
		public function volumeTextThing(x:Float, y:Float, volumeName:String)
		{
			volumeNameText = new FlxText(x, y, 800, '', 30);
			volumeNameText.setFormat(Paths.font("Font.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			switch (volumeName)
			{
				case 'master-volume':
					volumeNameText.text = 'Master Volume';
				case 'music-volume':
					volumeNameText.text = 'Music Volume';
				case 'sfx-volume':
					volumeNameText.text = 'SFX volume';
			}
			volumeNameText.text = volumeNameText.text.toUpperCase();
			volumeNameText.scrollFactor.set();
			add(volumeNameText);
		}

		public function barThing(x:Float, y:Float, volumeName:String, txtX:Float, txtY:Float, buttonX:Float, buttonY:Float)
			{
				var barWidth = 33;
			    var barHeight = 705;
                var buttonHeight = 730;

				var barBG:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('Music Slider Bar'));
			    barBG.scrollFactor.set();
                add(barBG);

				switch (volumeName)
				{
					case 'master-volume':
						var volumeDownButton = new FlxButton(buttonX, buttonY, clickVolumeDown);
						var volumeUpButton = new FlxButton(volumeDownButton.x + buttonHeight, volumeDownButton.y, clickVolumeUp);
						volumeDownButton.loadGraphic(Paths.imageUI('Button_Down'));
		                volumeUpButton.loadGraphic(Paths.imageUI('Button_Up'));
						volumeDownButton.scrollFactor.set();
						volumeUpButton.scrollFactor.set();
				        add(volumeDownButton);
				        add(volumeUpButton);

						masterVolumeBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						masterVolumeBar.scrollFactor.set();
						masterVolumeBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						add(masterVolumeBar);
			
						masterVolumeAmountText = new FlxText(txtX, txtY, 200, (FlxG.sound.volume * 100) + "%", 30);
						masterVolumeAmountText.scrollFactor.set();
						masterVolumeAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						masterVolumeAmountText.borderColor = 0xff464646;
						masterVolumeAmountText.y = masterVolumeBar.y + (masterVolumeBar.height / 2) - (masterVolumeAmountText.height / 2);
						add(masterVolumeAmountText);
				    case 'music-volume':
						var volumeDownButton = new FlxButton(buttonX, buttonY, clickMusicVolumeDown);
						var volumeUpButton = new FlxButton(volumeDownButton.x + buttonHeight, volumeDownButton.y, clickMusicVolumeUp);
						volumeDownButton.loadGraphic(Paths.imageUI('Button_Down'));
		                volumeUpButton.loadGraphic(Paths.imageUI('Button_Up'));
						volumeDownButton.scrollFactor.set();
						volumeUpButton.scrollFactor.set();
				        add(volumeDownButton);
				        add(volumeUpButton);

                        musicBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						musicBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						musicBar.scrollFactor.set();
						add(musicBar);
			
						musicAmountText = new FlxText(txtX, txtY, 200, musicVolume * 100 + "%", 30);
						musicAmountText.scrollFactor.set();
						musicAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						musicAmountText.borderColor = 0xff464646;
						musicAmountText.y = musicBar.y + (musicBar.height / 2) - (musicAmountText.height / 2);
						add(musicAmountText);
					case 'sfx-volume':
						var volumeDownButton = new FlxButton(buttonX, buttonY, clickSFXVolumeDown);
						var volumeUpButton = new FlxButton(volumeDownButton.x + buttonHeight, volumeDownButton.y, clickSFXVolumeUp);
						volumeDownButton.loadGraphic(Paths.imageUI('Button_Down'));
						volumeUpButton.loadGraphic(Paths.imageUI('Button_Up'));
						volumeDownButton.scrollFactor.set();
						volumeUpButton.scrollFactor.set();
						add(volumeDownButton);
						add(volumeUpButton);

						sfxBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						sfxBar.scrollFactor.set();
						sfxBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						add(sfxBar);
			
						sfxAmountText = new FlxText(txtX, txtY, 200, sfxVolume * 100 + "%", 30);
						sfxAmountText.scrollFactor.set();
						sfxAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						sfxAmountText.borderColor = 0xff464646;
						sfxAmountText.y = sfxBar.y + (sfxBar.height / 2) - (sfxAmountText.height / 2);
						add(sfxAmountText);
					default:
						trace('You think that things will come?');
				}
			}

		function updateVolume()
			{
				var volume = Math.round(FlxG.sound.volume * 100);
				masterVolumeBar.value = volume;
				masterVolumeAmountText.text = volume + "%";

				musicBar.value = Math.round(musicVolume * 100);
				musicAmountText.text = Std.int(musicVolume * 100) + "%";

				sfxBar.value = Math.round(sfxVolume * 100);
				sfxAmountText.text = Std.int(sfxVolume * 100) + "%";
			}

			function clickVolumeDown()
				{
					FlxG.sound.volume -= 0.1;
					updateVolume();
				}

			function clickVolumeUp()
			{
				FlxG.sound.volume += 0.1;
				updateVolume();
			}

			function clickMusicVolumeDown()
				{
					musicVolume -= 0.1;
					if (musicVolume < 0)
						musicVolume = 0;
					updateVolume();
				}

			function clickMusicVolumeUp()
			{
				musicVolume += 0.1;
				if (musicVolume > 1)
					musicVolume = 1;
				updateVolume();
			}

			function clickSFXVolumeDown()
				{
					sfxVolume -= 0.1;
					if (sfxVolume < 0)
						sfxVolume = 0;
					updateVolume();
				}

			function clickSFXVolumeUp()
			{
				sfxVolume += 0.1;
				if (sfxVolume > 1)
					sfxVolume = 1;
				updateVolume();
			}

		override function update(elapsed:Float)
			{
				FlxG.sound.music.volume = FlxG.save.data.volume * FlxG.save.data.musicVolume;
				
				super.update(elapsed);
				
				if (FlxG.save.data.volume = null)
						FlxG.sound.volume = 0.5;
						// FlxG.save.data.volume = 0.5;
				else
					FlxG.save.data.volume = FlxG.sound.volume;

				if (FlxG.save.data.musicVolume = null)
					FlxG.save.data.musicVolume = 1;
				else
					FlxG.save.data.musicVolume = musicVolume;

				if (FlxG.save.data.SFXVolume = null)
					FlxG.save.data.SFXVolume = 1;
				else
					FlxG.save.data.SFXVolume = sfxVolume;

				FlxG.save.flush();
				updateVolume();

				if (controls.RESET)
					{
						FlxG.save.erase();
						FlxG.sound.volume = 0.5;
						musicVolume = 1;
						sfxVolume = 1;
					}

				if (controls.BACK)
					FlxG.switchState(new OptionsState());
			}
}
