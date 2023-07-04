package ui;

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

class VolumeMenu extends ui.OptionsState.Page
{
	public static var musicVolume:Float = 100;
	public static var sfxVolume:Float = 100;
	
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

	public function new()
		{
			super();

			FlxG.mouse.visible = true;

			FlxG.save.bind("volume-save-data", "The Funkin Crew");

			volumeTextThing(-300, 130, 'master-volume');
			volumeTextThing(-300, 350, 'music-volume');
			volumeTextThing(-300, 570, 'sfx-volume');

			barThing(540, FlxG.height * 0.2, 'master-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.2), 513, Std.int(FlxG.height * 0.2) + 1.5);
			barThing(540, FlxG.height * 0.5, 'music-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.5), 513, Std.int(FlxG.height * 0.5) + 1.5) ;
			barThing(540, FlxG.height * 0.8, 'sfx-volume', Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.8), 513, Std.int(FlxG.height * 0.8) + 1.5);

			descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		    descBg.alpha = 0.4;
		    add(descBg);
		
		    desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Press C to clear", 18);
		    desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		    desctxt.borderColor = FlxColor.BLACK;
		    desctxt.borderSize = 1;
		    desctxt.borderStyle = OUTLINE;
		    desctxt.scrollFactor.set();
		    desctxt.screenCenter(X);
		    add(desctxt);
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
						volumeDownButton.loadGraphic(Paths.image('Button_Down'));
		                volumeUpButton.loadGraphic(Paths.image('Button_Up'));
				        add(volumeDownButton);
				        add(volumeUpButton);

						masterVolumeBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						masterVolumeBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						add(masterVolumeBar);
			
						masterVolumeAmountText = new FlxText(txtX, txtY, 200, (FlxG.sound.volume * 100) + "%", 30);
						masterVolumeAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						masterVolumeAmountText.borderColor = 0xff464646;
						masterVolumeAmountText.y = masterVolumeBar.y + (masterVolumeBar.height / 2) - (masterVolumeAmountText.height / 2);
						add(masterVolumeAmountText);
				    case 'music-volume':
						var volumeDownButton = new FlxButton(buttonX, buttonY, clickMusicVolumeDown);
						var volumeUpButton = new FlxButton(volumeDownButton.x + buttonHeight, volumeDownButton.y, clickMusicVolumeUp);
						volumeDownButton.loadGraphic(Paths.image('Button_Down'));
		                volumeUpButton.loadGraphic(Paths.image('Button_Up'));
				        add(volumeDownButton);
				        add(volumeUpButton);

                        musicBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						musicBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						add(musicBar);
			
						musicAmountText = new FlxText(txtX, txtY, 200, musicVolume * 100 + "%", 30);
						musicAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						musicAmountText.borderColor = 0xff464646;
						musicAmountText.y = musicBar.y + (musicBar.height / 2) - (musicAmountText.height / 2);
						add(musicAmountText);
					case 'sfx-volume':
						var volumeDownButton = new FlxButton(buttonX, buttonY, clickSFXVolumeDown);
						var volumeUpButton = new FlxButton(volumeDownButton.x + buttonHeight, volumeDownButton.y, clickSFXVolumeUp);
						volumeDownButton.loadGraphic(Paths.image('Button_Down'));
						volumeUpButton.loadGraphic(Paths.image('Button_Up'));
						add(volumeDownButton);
						add(volumeUpButton);

						sfxBar = new FlxBar(x + 4, y + 4, LEFT_TO_RIGHT, barHeight - 8, barWidth - 8);
						sfxBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE, true);
						add(sfxBar);
			
						sfxAmountText = new FlxText(txtX, txtY, 200, sfxVolume * 100 + "%", 30);
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

				musicBar.value = musicVolume;
				musicAmountText.text = Std.int(musicVolume) + "%";

				sfxBar.value = sfxVolume;
				sfxAmountText.text = Std.int(sfxVolume) + "%";
			}

			function clickVolumeDown()
				{
					FlxG.sound.volume -= 0.1;
					FlxG.save.data.volume = FlxG.sound.volume;
					updateVolume();
				}

			function clickVolumeUp()
			{
				FlxG.sound.volume += 0.1;
				FlxG.save.data.volume = FlxG.sound.volume;
				updateVolume();
			}

			function clickMusicVolumeDown()
				{
					musicVolume -= 10;
					if (musicVolume < 0)
						musicVolume = 0;
					FlxG.save.data.musicVolume = musicVolume;
					updateVolume();
				}

			function clickMusicVolumeUp()
			{
				musicVolume += 10;
				if (musicVolume > 100)
					musicVolume = 100;
				FlxG.save.data.musicVolume = musicVolume;
				updateVolume();
			}

			function clickSFXVolumeDown()
				{
					sfxVolume -= 10;
					if (sfxVolume < 0)
						sfxVolume = 0;
					FlxG.save.data.SFXVolume = sfxVolume;
					updateVolume();
				}

			function clickSFXVolumeUp()
			{
				sfxVolume += 10;
				if (sfxVolume > 100)
					sfxVolume = 100;
				FlxG.save.data.SFXVolume = sfxVolume;
				updateVolume();
			}

		function clearData()
			{
				if (FlxG.keys.pressed.C)
					{
						FlxG.save.erase();
						FlxG.sound.volume = 0.5;
						musicVolume = 100;
						sfxVolume = 100;
					}
			}

		override function update(elapsed:Float)
			{
				super.update(elapsed);
				FlxG.sound.music.volume * VolumeMenu.musicVolume * 0.1;
				updateVolume();
				clearData();
			}
}
