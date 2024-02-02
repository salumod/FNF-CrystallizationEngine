package option;

import funkin.NoteSplash;
import funkin.Note;
import openfl.display.Bitmap;
import openfl.display.LoaderInfo;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import funkin.GameUI.GameMouse;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUISubState;
import flixel.FlxG;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import ui.AtlasText;
import flixel.FlxSprite;
import openfl.filters.ShaderFilter;
import shaderslmfao.InvertShader;
import flixel.FlxCamera;
import flixel.FlxObject;
import ui.TextMenuList;
import flixel.FlxSubState;
import option.OptionsState;

class ColorsMenu extends MusicBeatSubstate
{
    var items:TextMenuList;
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

	override function create()
	{
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
		creatColorItem('Note Colors', function() openSubState(new NoteColor()));
		creatColorItem('Fps Colors', function() openSubState(new FPScolor()));
		creatColorItem('Mouse Colors', function() openSubState(new MouseChoose()));
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

		super.create();
	}

	function creatColorItem(optionName:String, callback):Void 
	{
		items.createItem(120, (120 * items.length) + 30, optionName, AtlasFont.Bold, callback);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			close();
		}

		super.update(elapsed);
	}
}

class NoteColor extends MusicBeatSubstate
{
	var curSelected:Int = 0;

	var grpNotes:FlxTypedGroup<Note>;

	public function new() 
	{
		super();
	}

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.scrollFactor.set();
		bg.alpha = 0.8;
		add(bg);

		grpNotes = new FlxTypedGroup<Note>();
		add(grpNotes);

		for (i in 0...4)
		{
			var note:Note = new Note(0, i);
			note.x = 400;
			note.x += (130 * i) + i;
			note.screenCenter(Y);
			note.scrollFactor.set();

			grpNotes.add(note);
		}
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_RIGHT_P)
			{
				curSelected += 1;
			}

		if (controls.UI_LEFT_P)
			{
				curSelected -= 1;
			}

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

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			close();
		}
		
		super.update(elapsed);
	}
}

class CameraShaderMenu extends MusicBeatSubstate
{
	//can't use now!
	var grpNotes:FlxTypedGroup<Note>;
	var invertShader:InvertShader;
	var items:TextMenuList;
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

	public function new() 
	{
		super();
	}

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.scrollFactor.set();
		bg.alpha = 0.8;
		add(bg);

		add(items = new TextMenuList());
		createShaderItem('Invert Color', invertColor);
		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y;
		});
		super.create();
	}

	function createShaderItem(shaderName:String, callback):Void 
	{
		items.createItem(120, (120 * items.length) + 30, shaderName, AtlasFont.Bold, callback);
	}

	function invertColor() 
	{
		FlxG.camera.setFilters([new ShaderFilter(invertShader)]);
	}

	override function update(elapsed:Float)
	{
		items.forEach(function(daItem:TextMenuItem)
		{
			if (items.selectedItem == daItem)
				daItem.x = 150;
			else
				daItem.x = 120;
		});

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			close();
		}

		super.update(elapsed);
	}
}

class FPScolor extends MusicBeatSubstate
{
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var items:TextMenuList;

	public function new() 
		{
			super();
		}
	
		override function create()
		{
			menuCamera = new SwagCamera();
			FlxG.cameras.add(menuCamera, false);
			menuCamera.bgColor = 0x0;
			camera = menuCamera;

			//choose some color or make some color
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			bg.scrollFactor.set();
			bg.alpha = 0.8;
			add(bg);

			add(items = new TextMenuList());
			creatFPSColorItem('Red', function() Main.fps.textColor = FlxColor.RED);
			creatFPSColorItem('Blue', function() Main.fps.textColor = FlxColor.BLUE);
			creatFPSColorItem('Green', function() Main.fps.textColor = FlxColor.GREEN);
			creatFPSColorItem('Yellow', function() Main.fps.textColor = FlxColor.YELLOW);
			creatFPSColorItem('Orange', function() Main.fps.textColor = FlxColor.ORANGE);
			creatFPSColorItem('Pink', function() Main.fps.textColor = FlxColor.PINK);
			creatFPSColorItem('Purple', function() Main.fps.textColor = FlxColor.PURPLE);
			creatFPSColorItem('Brown', function() Main.fps.textColor = FlxColor.BROWN);
			creatFPSColorItem('Gray', function() Main.fps.textColor = FlxColor.GRAY);
			creatFPSColorItem('Lime', function() Main.fps.textColor = FlxColor.LIME);
			creatFPSColorItem('Magenta', function() Main.fps.textColor = FlxColor.MAGENTA);
			creatFPSColorItem('Transparent', function() Main.fps.textColor = FlxColor.TRANSPARENT);
			creatFPSColorItem('Black', function() Main.fps.textColor = FlxColor.BLACK);
			creatFPSColorItem('White', function() Main.fps.textColor = FlxColor.WHITE);
			creatFPSColorItem('Transparent(invisible)', function() Main.fps.visible = !Main.fps.visible);
			
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

			super.create();
		}
	
		function creatFPSColorItem(colorName:String, callback):Void 
		{
			items.createItem(120, (120 * items.length) + 30, colorName, AtlasFont.Bold, callback);
		}

		override function update(elapsed:Float)
		{
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
				close();
			}
	
			super.update(elapsed);
		}
}

class MouseChoose extends MusicBeatSubstate
{
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var items:TextMenuList;
    var mouse:GameMouse;

	public function new() 
		{
			super();
		}
	
		override function create()
		{
			menuCamera = new SwagCamera();
			FlxG.cameras.add(menuCamera, false);
			menuCamera.bgColor = 0x0;
			camera = menuCamera;

			//choose some color or make some color
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			bg.scrollFactor.set();
			bg.alpha = 0.8;
			add(bg);

			add(items = new TextMenuList());
			creatMouseItem('Default', function() 
			{
				FlxG.save.data.MouseColor = null;
				mouse = new GameMouse();
				mouse.quicklyADD();
				add(mouse);
				FlxG.save.flush();
			});
			creatMouseItem('White', function() 
			{
				FlxG.save.data.MouseColor = 0;
				mouse = new GameMouse();
				mouse.quicklyADD();
				add(mouse);
				FlxG.save.flush();
			});
			creatMouseItem('what', function() 
			{
				FlxG.save.data.MouseColor = 1;
				mouse = new GameMouse();
				mouse.quicklyADD();
				add(mouse);
				FlxG.save.flush();
			});
			creatMouseItem('custom', function() 
			{
				// FlxG.mouse.load(Paths.imageUI('MOUSE_WHITE'), 2); FlxG.save.data.MouseColor = null;
				var imagesFilter = new FileFilter("Images", "*.png");
				var mouseImgReference = new FileReference();
				mouseImgReference.browse([imagesFilter]);
				mouseImgReference.addEventListener(Event.SELECT, _onSelect, false, 0, true);
			});

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

			super.create();
		}
	
		function creatMouseItem(colorName:String, callback):Void 
		{
			items.createItem(120, (120 * items.length) + 30, colorName, AtlasFont.Bold, callback);
		}

		function _onSelect(E:Event):Void
			{
				var fr:FileReference = cast(E.target, FileReference);
				fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
				fr.load();
			}
		
		function _onLoad(E:Event):Void
			{
				var fr:FileReference = cast E.target;
				fr.removeEventListener(Event.COMPLETE, _onLoad);
		
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImgLoad);
				loader.loadBytes(fr.data);
			}
		
		function _onImgLoad(E:Event):Void
			{
				var loaderInfo:LoaderInfo = cast E.target;
				loaderInfo.removeEventListener(Event.COMPLETE, _onImgLoad);
				var bmp:Bitmap = cast(loaderInfo.content, Bitmap);

				mouse = new GameMouse();
				mouse.loadBpm(bmp.bitmapData);
				add(mouse);
			}

		override function update(elapsed:Float)
		{
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
				close();
			}
	
			super.update(elapsed);
		}
}
