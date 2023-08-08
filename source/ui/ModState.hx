package ui;

import lime.app.Application;
import haxe.macro.Expr.Var;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if cpp
import polymod.Polymod;
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxSprite;
import ui.AtlasText;

class ModState extends MusicBeatState
{
	var modItem:TextMenuList;
	var enabledMods:Array<String> = [];
	var modFolders:Array<String> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	inline static var MOD_PATH = "./mods/";

	override public function create()
	{
		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, true);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;
		
		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
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
	}

	function createModItem(modName:String, callback)
	{
		modItem.createItem(120, (120 * modItem.length) + 30, modName, AtlasFont.Bold, callback);
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
			createModItem(i, function() {
				File.read(FileSystem.absolutePath(MOD_PATH + i) + '/d.txt', true);
				trace('click: ' + i);
			});
		}
	}
	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			FlxG.switchState(new OptionsState());
		}
		
		super.update(elapsed);
	}
}