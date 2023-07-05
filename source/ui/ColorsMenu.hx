package ui;

import flixel.FlxG;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import ui.AtlasText;
import flixel.FlxSprite;
import openfl.filters.ShaderFilter;
import shaderslmfao.InvertShader;

class ColorsMenu extends ui.OptionsState.Page
{
	var curSelected:Int = 0;

	var grpNotes:FlxTypedGroup<Note>;
	var invertShader:InvertShader;

	public function new()
	{
		super();

		grpNotes = new FlxTypedGroup<Note>();
		add(grpNotes);


		for (i in 0...4)
		{
			var note:Note = new Note(0, i);

			note.x = (130 * i) + i;
			note.screenCenter(Y);

			var _effectSpr:FlxEffectSprite = new FlxEffectSprite(note, [new FlxOutlineEffect(FlxOutlineMode.FAST, FlxColor.WHITE, 4, 1)]);
			add(_effectSpr);//this is note list 1

			_effectSpr.y = 100;
			_effectSpr.x = i * 130;
			_effectSpr.antialiasing = true;
			_effectSpr.scale.x = _effectSpr.scale.y = 0.7;
			_effectSpr.setGraphicSize();
			_effectSpr.height = note.height;
			_effectSpr.width = note.width;

			_effectSpr.updateHitbox();

			grpNotes.add(note);
		}
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_RIGHT_P)
			curSelected += 1;
		if (controls.UI_LEFT_P)
			curSelected -= 1;

		if (curSelected < 0)
			curSelected = grpNotes.members.length - 1;
		if (curSelected >= grpNotes.members.length)
			curSelected = 0;

		if (controls.UI_UP)
		{
			grpNotes.members[curSelected].colorSwap.update(elapsed * 0.3);
			Note.arrowColors[curSelected] += elapsed * 0.3;
			NoteSplash.colors[curSelected] += elapsed * 0.3;
		}

		if (controls.UI_DOWN)
		{
			grpNotes.members[curSelected].colorSwap.update(-elapsed * 0.3);
			Note.arrowColors[curSelected] += -elapsed * 0.3;
			NoteSplash.colors[curSelected] += -elapsed * 0.3;
		}

		if (FlxG.keys.pressed.I)
			{
				FlxG.camera.setFilters([new ShaderFilter(invertShader)]);
			}

		super.update(elapsed);
	}
}
