package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxGame;

class MenuStages extends FlxSpriteGroup
{
	public function new(x:Float, y:Float, weekStageName:String = 'stage')
	{
		super();

		var stage:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('stageimages/' + weekStageName));
		add(stage);
		updateHitbox();
	}
}