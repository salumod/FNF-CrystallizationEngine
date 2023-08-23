package option;

import flixel.util.FlxSave;
import flixel.system.frontEnds.ConsoleFrontEnd;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import ui.AtlasText.AtlasFont;
import ui.TextMenuList.TextMenuItem;
import ui.CheckboxThingie;

class PreferencesMenu extends MusicBeatSubstate
{
	var items:TextMenuList;
	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;
    
	override public function create()
	{
		super.create();
		
		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, true);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set(0, 0);
		add(menuBG);
	
		add(items = new TextMenuList());

		createItem('flashing menu', FlxG.save.data.flashingMenu);
		createItem('naughtyness', FlxG.save.data.naughtyness);
		createItem('Beat Zooming', FlxG.save.data.zoomOn);
		createItem('Auto Pause', FlxG.save.data.autoPause);
		createItem('NoteSplash', FlxG.save.data.noteSplash);
		createItem('Time Bar', FlxG.save.data.timeBar);

		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
			camFollow.y = items.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y;
		});
	}

	private function createItem(itemName:String, defaultValue:Bool):Void
	{
		items.createItem(50, (120 * items.length) + 30, itemName, AtlasFont.Bold, function()
		{
			// value = !value;
			switch (itemName)
			{
				case 'flashing menu':
					FlxG.save.data.flashingMenu = !FlxG.save.data.flashingMenu;
					defaultValue = FlxG.save.data.flashingMenu;
				case 'naughtyness':
					FlxG.save.data.naughtyness = !FlxG.save.data.naughtyness;
					defaultValue = FlxG.save.data.naughtyness;
				case 'Beat Zooming':
					FlxG.save.data.zoomOn = !FlxG.save.data.zoomOn;
					defaultValue = FlxG.save.data.zoomOn;
				case 'Auto Pause':
					FlxG.save.data.autoPause = !FlxG.save.data.autoPause;
					defaultValue = FlxG.save.data.autoPause;
				case 'Note Splash':
					FlxG.save.data.noteSplash = !FlxG.save.data.noteSplash;
					defaultValue = FlxG.save.data.noteSplash;
				case 'Time Bar':
					FlxG.save.data.timeBar = !FlxG.save.data.timeBar;
					defaultValue = FlxG.save.data.timeBar;
			}
			trace('CLICKED!: ' + defaultValue);
			checkboxes[items.selectedIndex].daValue = defaultValue;//swag checkbox
			trace(itemName + ' value: ' + defaultValue);
		});

		createCheckbox(defaultValue);
	}

	function createCheckbox(value:Bool)
	{
		var checkbox:CheckboxThingie = new CheckboxThingie(900, 120 * (items.length - 1), value);
		checkboxes.push(checkbox);
		add(checkbox);
	}

	static public function defaultValueInit()
	{
		if (FlxG.save.data.naughtyness == null)
			{
				FlxG.save.data.naughtyness = true;
				
			}
		if (FlxG.save.data.flashingMenu == null)
			{
				FlxG.save.data.flashingMenu = true;
				
			}
		if (FlxG.save.data.zoomOn == null)
			{
				FlxG.save.data.zoomOn = true;
				
			}
		if (FlxG.save.data.autoPause == null)
			{
				FlxG.save.data.autoPause = false;
				
			}
        else if (FlxG.save.data.autoPause = true)
			{
				FlxG.autoPause = true;
				trace('autoPause: ' + FlxG.autoPause);
			}

		if (FlxG.save.data.noteSplash == null)
			{
				FlxG.save.data.noteSplash = true;
			}

		if (FlxG.save.data.timeBar == null)
			{
				FlxG.save.data.timeBar = true;
			}

		traceOption();
		trace('checked option!');
	}

	static public function traceOption()
	{
		trace('flashingMenu: ' + FlxG.save.data.flashingMenu);
		trace('naughtyness: ' + FlxG.save.data.naughtyness);
		trace('zoomOn: ' + FlxG.save.data.zoomOn);
		trace('autoPause: ' + FlxG.save.data.autoPause);
		trace('note splash: ' + FlxG.save.data.noteSplash);
		trace('timeBar: ' + FlxG.save.data.timeBar);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.save.flush();

		if (controls.BACK)
		{
			// traceOption();
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			close();
		}
	}
}