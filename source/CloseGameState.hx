package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;

class CloseGameState extends MusicBeatState
{
	override public function create()
	{
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

		var txt2 = new FlxText(490, 470, 0, "Y: yes      N: no", 20);
		txt2.setFormat(Paths.font("Funkin/Funkin.ttf"), 50, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		gamePrompt('normal');

		add(txt);
		add(txt2);

		super.create();
	}

	function gamePrompt(promptAni:String = 'normal')
		{
			var prompt:FlxSprite = new FlxSprite();

			var farme = Paths.getSparrowAtlas('prompt-ng_login');
		    prompt.frames = farme;

		    prompt.animation.addByPrefix('normal', 'back', 24, false);

		    prompt.scrollFactor.set();
		    prompt.updateHitbox();
		    prompt.screenCenter();

            add(prompt);

			prompt.animation.play('normal');
		}

	function gameExit()
		{
			#if cpp
			Sys.exit(0);
			#end
			FlxG.log.redirectTraces = true;
		}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.Y)
			gameExit();

		if (FlxG.keys.justPressed.N)
			FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}
}