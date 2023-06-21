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

		// var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// background.alpha = 0.5;
		// add(background);

		var bg:FlxSprite = new FlxSprite(Paths.image('menuDesat'));
		bg.color = 0xFF161616;
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.17;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		
		var txt = new FlxText(0, 0, 0, "Do you want to EXIT GAME?", 20);
		txt.setFormat(Paths.font("Funkin/Funkin.ttf"), 70, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();
		add(txt);

		var txt2 = new FlxText(490, 470, 0, "Y: yes      N: no", 20);
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