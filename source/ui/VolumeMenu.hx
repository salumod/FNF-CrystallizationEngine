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

	// var titleText:FlxText;
	var volumeBar:FlxBar;
	var volumeText:FlxText;
	var volumeAmountText:FlxText;

	// var blurb:Array<String> = [
	// 	"Volume"
	// ];

	var headers = new FlxTypedGroup<AtlasText>();
	
	public function new()
		{
			super();
	
			var tex = Paths.getSparrowAtlas('option/');
	
			var option:FlxSprite = new FlxSprite(100, 100);
			option.frames = Paths.getSparrowAtlas('option');
			option.animation.addByPrefix('loop', "option!", 24);
			option.animation.play('loop');
			option.updateHitbox();
			option.screenCenter(X);
			add(option);
			option.antialiasing = true;

			add(headers);

			headers.add(new BoldText(0, 0.4, "Volume")).screenCenter(X);

			var barBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('Music Slider Bar'));
			barBG.screenCenter(X);
			barBG.scrollFactor.set();
			// add(barBG);

			// var textGroup:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
		    // add(textGroup);

		    // for (i in 0...blurb.length)
		    // {
			//     var money:Alphabet = new Alphabet(10, 10, blurb[i], true, false);
			//     money.screenCenter(X);
			//     money.y += (i * 20) + 30;
			//     textGroup.add(money);
		    // }

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
