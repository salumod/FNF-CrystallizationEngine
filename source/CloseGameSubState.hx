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

        // transIn = FlxTransitionableState.defaultTransIn;
		// transOut = FlxTransitionableState.defaultTransOut;

		var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				gameExit();
			});
	}

    function gameExit()
		{
			#if cpp
			Sys.exit(0);
			#end
			FlxG.log.redirectTraces = true;
		}
}