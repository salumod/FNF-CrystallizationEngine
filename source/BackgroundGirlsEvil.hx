package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundGirlsEvil extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		// BG fangirls dissuaded
		frames = Paths.getSparrowAtlas('weeb/Pixel_BG_Girls');

		animation.addByIndices('danceLeft', 'evil', CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', 'evil', CoolUtil.numberArray(30, 15), "", 24, false);

		animation.play('danceLeft');
		animation.finish();
	}

	var heyDir:Bool = false;
		public function hey():Void
	{
		heyDir = !heyDir;

			if (heyDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
