package option;

import funkin.VideoState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

class OptionsState extends MusicBeatState
{
	var items:TextMenuList;
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

	override function create()
	{
		super.create();
		
		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set(0, 0);
		add(menuBG);

		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, true);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		add(items = new TextMenuList());
		createItem('preferences', function() openSubState(new PreferencesMenu()));
		createItem('gameplay', function() openSubState(new GameplayMenu()));
		createItem("controls", function() openSubState(new ControlsMenu()));
		createItem('latency', function() openSubState(new LatencyMenu()));
		createItem('volume', function() openSubState(new VolumeMenu()));
		createItem('color', function() openSubState(new ColorsMenu()));
		createItem('mods', function() openSubState(new ModMenu()));
        // createItem('reset game', function() FlxG.resetGame());
		// if (NGio.isLoggedIn)
		// 	createItem("logout", selectLogout);
		// else
		// 	createItem("login", selectLogin);
		
		camFollow = new FlxObject(FlxG.width / 2, 0, 70, 70);
		if (items != null)
			camFollow.y = items.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 70);
		menuCamera.minScrollY = 0;

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y;
		});

		#if web
		if (NGio.isLoggedIn)
			createItem("logout", selectLogout);
		else
			createItem("login", selectLogin);
		#end
		createItem("exit", exit);
	}

	function createItem(name:String, callback:Void->Void, fireInstantly = false)
	{
		var item = items.createItem(0, 100 + items.length * 100, name, Bold, callback);
		item.fireInstantly = fireInstantly;
		item.screenCenter(X);
		return item;
	}

	public function exit() 
	{
		FlxG.switchState(new MainMenuState());
	}

	public function set_enabled(value:Bool)
	{
		items.enabled = value;
		return set_enabled(value);
	}

	/**
	 * True if this page has multiple options, excluding the exit option.
	 * If false, there's no reason to ever show this page.
	 */
	public function hasMultipleOptions():Bool
	{
		return items.length > 2;
	}

	#if CAN_OPEN_LINKS
	function selectDonate()
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
		#else
		FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
		#end
	}
	#end

	override function update(elapsed:Float) 
	{
		if (controls.BACK)
			exit();
		super.update(elapsed);
	}
}