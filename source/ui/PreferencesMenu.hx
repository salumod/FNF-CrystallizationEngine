package ui;

import openfl.Lib;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import haxe.ds.StringMap;

class PreferencesMenu extends Page
{
	public static var preferences:StringMap<Dynamic> = new StringMap<Dynamic>();

	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var items:TextMenuList;
	var camFollow:FlxObject;

	override public function new()
	{
		super();
		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = FlxColor.TRANSPARENT;
		camera = menuCamera;
		add(items = new TextMenuList());
		createPrefItem('naughtyness', 'censor-naughty', true);
		createPrefItem('downscroll', 'downscroll', false);
		createPrefItem('flashing menu', 'flashing-menu', true);
		createPrefItem('Camera Zooming on Beat', 'camera-zoom', true);
		createPrefItem('FPS Counter', 'fps-counter', true);
		createPrefItem('Auto Pause', 'auto-pause', false);
		createPrefItem('Mirror', 'mirror-mode', false);
		createPrefItem('Game console mode', 'game-console-mode', false);
		createPrefItem('Pixel Shader', 'pixel-shader', true);

		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
		{
			camFollow.y = items.members[items.selectedIndex].y;
		}
		menuCamera.follow(camFollow, null, 0.06);
		menuCamera.deadzone.set(0, 160, menuCamera.width, 40);
		menuCamera.minScrollY = 0;
		items.onChange.add(function(item:TextMenuItem)
		{
			camFollow.y = item.y;
		});
	}

	public static function getPref(pref:String)
	{
		return preferences.get(pref);
	}

	public static function initPrefs()
	{
		if(FlxG.save.data.censorNaughty != null)
		{
			preferenceCheck('censor-naughty', FlxG.save.data.censorNaughty);
		}
		else
		{
			preferenceCheck('censor-naughty', true);
		}

		if(FlxG.save.data.downscroll != null)
		{
			preferenceCheck('downscroll', FlxG.save.data.downscroll);
		}
		else
		{
			preferenceCheck('downscroll', false);
		}

		if(FlxG.save.data.flashingMenu != null)
		{
			preferenceCheck('flashing-menu', FlxG.save.data.flashingMenu);
		}
		else
		{
			preferenceCheck('flashing-menu', true);
		}

		if(FlxG.save.data.cameraZoom != null)
		{
			preferenceCheck('camera-zoom', FlxG.save.data.cameraZoom);
		}
		else
		{
			preferenceCheck('camera-zoom', true);
		}

		if(FlxG.save.data.fpsCounter != null)
		{
			preferenceCheck('fps-counter', FlxG.save.data.fpsCounter);
		}
		else
		{
			preferenceCheck('fps-counter', true);
		}

		if(FlxG.save.data.fpsCounter != null)
			{
				preferenceCheck('fps-counter', FlxG.save.data.fpsCounter);
			}
			else
			{
				preferenceCheck('fps-counter', true);
			}

		if(FlxG.save.data.autoPause != null)
		{
			preferenceCheck('auto-pause', FlxG.save.data.autoPause);
		}
		else
		{
			preferenceCheck('auto-pause', false);
		}

		if(FlxG.save.data.mirrorMode != null)
			{
				preferenceCheck('mirror-mode', FlxG.save.data.mirrorMode);
			}
			else
			{
				preferenceCheck('mirror-mode', false);
			}

		if(FlxG.save.data.gameConsoleMmode != null)
			{
				preferenceCheck('game-console-mode', FlxG.save.data.gameConsoleMmode);
			}
			else
			{
				preferenceCheck('game-console-mode', false);
			}

		if(FlxG.save.data.pixelShader != null)
			{
				preferenceCheck('pixel-shader', FlxG.save.data.pixelShader);
			}
			else
			{
				preferenceCheck('pixel-shader', true);
			}

		if (!getPref('fps-counter'))
		{
			Lib.current.stage.removeChild(Main.fpsCounter);
		}

		FlxG.autoPause = getPref('auto-pause');
	}

	public static function preferenceCheck(identifier:String, defaultValue:Dynamic)
	{
		if (preferences.get(identifier) == null)
		{
			preferences.set(identifier, defaultValue);
			trace('set preference!');
		}
		else
		{
			trace('found preference: ' + Std.string(preferences.get(identifier)));
		}
	}

	public function createPrefItem(label:String, identifier:String, value:Dynamic)
	{
		items.createItem(120, 120 * items.length + 30, label, Bold, function()
		{
			preferenceCheck(identifier, value);
			if (Type.typeof(value) == TBool)
			{
				prefToggle(identifier);
			}
			else
			{
				trace('swag');
			}
		});
		if (Type.typeof(value) == TBool)
		{
			createCheckbox(identifier);
		}
		else
		{
			trace('swag');
		}
		trace(Type.typeof(value));
	}

	public function createCheckbox(identifier:String)
	{
		var box:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), preferences.get(identifier));
		checkboxes.push(box);
		add(box);
	}

	public function prefToggle(identifier:String)
	{
		var value:Bool = preferences.get(identifier);
		value = !value;
		preferences.set(identifier, value);
		checkboxes[items.selectedIndex].daValue = value;

		FlxG.save.data.censorNaughty = getPref('censor-naughty');
		FlxG.save.data.downscroll = getPref('downscroll');
		FlxG.save.data.flashingMenu = getPref('flashing-menu');
		FlxG.save.data.cameraZoom = getPref('camera-zoom');
		FlxG.save.data.fpsCounter = getPref('fps-counter');
		FlxG.save.data.autoPause = getPref('auto-pause');
		FlxG.save.data.pixelShader = getPref('pixel-shader');
		FlxG.save.data.mirrorMode = getPref('mirror-mode');
		FlxG.save.data.gameConsoleMmode = getPref('game-console-mode');
		FlxG.save.flush();

		trace('toggled? ' + Std.string(preferences.get(identifier)));
		switch (identifier)
		{
			case 'auto-pause':
				FlxG.autoPause = getPref('auto-pause');
			case 'fps-counter':
				if (!getPref('fps-counter'))
				{
					Lib.current.stage.removeChild(Main.fpsCounter);
				}
				else
				{
					Lib.current.stage.addChild(Main.fpsCounter);
				}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		menuCamera.followLerp = CoolUtil.camLerpShit(0.02);
		items.forEach(function(item:MenuItem)
		{
			if (item == items.members[items.selectedIndex])
				item.x = 150;
			else
				item.x = 120;
		});
	}
}