package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;

class CloseGameSubState extends MusicBeatSubstate
{
	public function new()
	{
		super();

		var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var txt = new FlxText(0, 0, 0, "Do you want to EXIT game?", 20);
		txt.setFormat(Paths.font("Funkin/Funkin.ttf"), 70, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();
		add(txt);

		var txt2 = new FlxText(490, 470, 0, "Y:yes      N:no", 20);
		txt2.setFormat(Paths.font("Funkin/Funkin.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(txt2);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Y)
			gameExit();

		if (FlxG.keys.justPressed.N)
			FlxG.switchState(new MainMenuState());
	}

    function gameExit()
		{
			#if cpp
			Sys.exit(0);
			#end
			FlxG.log.redirectTraces = true;
		}
}