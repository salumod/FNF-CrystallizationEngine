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

class OptionMenu extends ui.OptionsState.Page
{
    public function new()
    {
        super();

        var tex = Paths.getSparrowAtlas('option/Background Loop');

        var background:FlxSprite = new FlxSprite(0, 0);
		background.frames = tex;
		background.animation.addByPrefix('loop', "Background Loop", 24);
        background.animation.play('loop');
        background.updateHitbox();
		background.screenCenter(X);
        add(background);
        background.antialiasing = true;
    }

    override function update(elapsed:Float)
        {
            super.update(elapsed);
        }

}