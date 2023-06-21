package ui;

import Controls;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import ui.AtlasText;

class VolumeMenu extends ui.OptionsState.Page
{
	public static var masterVolume:Float = 1;

	var volumeBar:FlxBar;
	var volumeText:FlxText;
	var volumeAmountText:FlxText;

	public function new()
		{
			super();

			var barBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('Music Slider Bar'));
			barBG.screenCenter(X);
			barBG.scrollFactor.set();

			volumeBar = new FlxBar(barBG.x + 4, barBG.y + 4, LEFT_TO_RIGHT, Std.int(barBG.width - 8), Std.int(barBG.height - 8));
		    volumeBar.createFilledBar(0xff464646, FlxColor.WHITE, true);
		    add(volumeBar);

			volumeAmountText = new FlxText(0, 0, 200, (FlxG.sound.volume * 100) + "%", 30);
			volumeAmountText.setFormat(Paths.font("Funkin/Funkin.ttf"), 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		    volumeAmountText.alignment = CENTER;
		    // volumeAmountText.borderStyle = FlxTextBorderStyle.OUTLINE;
		    volumeAmountText.borderColor = 0xff464646;
		    volumeAmountText.y = volumeBar.y + (volumeBar.height / 2) - (volumeAmountText.height / 2);
		    volumeAmountText.screenCenter(FlxAxes.X);
		    add(volumeAmountText);

		}
	
		function updateVolume()
			{
				var volume:Int = Math.round(FlxG.sound.volume * 100);
				volumeBar.value = volume;
				volumeAmountText.text = volume + "%";
			}

		override function update(elapsed:Float)
			{
				super.update(elapsed);

				if (FlxG.mouse.wheel != 0)
					{
						FlxG.sound.volume += (FlxG.mouse.wheel / 100);
					}

				updateVolume();
			}
}
