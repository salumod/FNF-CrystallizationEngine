package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class MenuStages extends FlxSpriteGroup
{
	public var stage:FlxSprite;
	public var weekStageName:String;

	public function new(x:Float, y:Float, weekStageName:String = 'stage')
	{
		super();

        this.weekStageName = weekStageName;
		stage = new FlxSprite(x, y).loadGraphic(Paths.image('stageimages/' + weekStageName));
		add(stage);

		updateHitbox();
	}

	private var isFlashing:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		super.destroy();
	}
}

