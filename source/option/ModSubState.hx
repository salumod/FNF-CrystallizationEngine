package option;

import hscript.Expr.Error;
import flixel.tweens.FlxTween;
import lime.app.Application;
import haxe.macro.Expr.Var;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if cpp
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxSprite;
import ui.AtlasText;

class ModMenu extends MusicBeatSubstate
{
	var modItem:TextMenuList;
	var enabledMods:Array<String> = [];
	var modFolders:Array<String> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
    var desctxt:FlxText;
    var txt:String;
    var descs:Array<String> = [];

	inline static var MOD_PATH = "./mods/";

	override public function create()
	{
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
		
        add(modItem = new TextMenuList());
		
		modADD(modFolders, MOD_PATH);
		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (modItem != null)
			camFollow.y = modItem.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;

		modItem.onChange.add(function(selected)
		{
			camFollow.y = selected.y;
		});
		super.create();

		var descBg:FlxSprite = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.scrollFactor.set();
		descBg.alpha = 0.4;
		add(descBg);
	
		desctxt = new FlxText(descBg.x, descBg.y + 4, FlxG.width, txt, 18);
		desctxt.setFormat(Paths.font("Funkin/Funkin.ttf"), 24, FlxColor.WHITE, CENTER);
		desctxt.borderColor = FlxColor.BLACK;
		desctxt.borderSize = 1;
		desctxt.borderStyle = OUTLINE;
		desctxt.scrollFactor.set();
		desctxt.screenCenter(X);
		add(desctxt);
	}

	function createItem(name:String, callback:Void->Void, fireInstantly = false)
		{
			var item = modItem.createItem(0, 100 + modItem.length * 100, name, Bold, callback);
			item.fireInstantly = fireInstantly;
			item.screenCenter(X);
			return item;
		}

    function modADD(folders:Array<String>, MOD_PATH)
	{
		for (modName in FileSystem.readDirectory(MOD_PATH))
		{
			if (FileSystem.isDirectory(MOD_PATH + modName))
				folders.push(modName);
		}

		for (i in folders)
		{
			var descs_mod = sys.io.File.getContent(MOD_PATH + i + '/describe.txt');
			descs.push(descs_mod);
			createItem(i, function() {
                trace(descs_mod);
				// var describe:String = sys.io.File.getContent(MOD_PATH + i + '/describe.txt');
				// desctxt.text = describe;
				// FileSystem.deleteDirectory(MOD_PATH + i);
			});
		}
	}
	
	override function update(elapsed:Float)
	{
		modItem.forEach(function(daItem:TextMenuItem)
			{
				if (modItem.selectedItem == daItem) 
					desctxt.text = descs[modItem.selectedIndex];
			});

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			close();
		}
		
		super.update(elapsed);
	}
}