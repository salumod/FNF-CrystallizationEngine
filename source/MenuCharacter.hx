package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;

		var tex = Paths.getSparrowAtlas('campaign_menu_UI_characters');
		frames = tex;

		animation.addByPrefix('bf', "none", 24);
		animation.addByPrefix('bfConfirm', 'none', 24, false);
		animation.addByPrefix('gf', "none", 24);
		animation.addByPrefix('dad', "none", 24);
		animation.addByPrefix('spooky', "none", 24);
		animation.addByPrefix('pico', "none", 24);
		animation.addByPrefix('mom', "none", 24);
		animation.addByPrefix('parents-christmas', "none", 24);
		animation.addByPrefix('senpai', "none", 24);
		animation.addByPrefix('tankman', "none", 24);
		animation.addByPrefix('none', "none", 24);
		// Parent Christmas Idle

		animation.play(character);
		updateHitbox();
	}
}
