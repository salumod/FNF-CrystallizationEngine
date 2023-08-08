package ui;

import flixel.text.FlxText;
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
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.ui.FlxButton;

class GameplayState extends MusicBeatState
{
	var items:TextMenuList;

	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;

    override function create()
        {
            var menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
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
    
            createGameplayItem('Game Mechanics', function() openSubState(new SomeOption()));
            createGameplayItem('Adjusting', function() openSubState(new AdjustingWindow()));

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

        private function createGameplayItem(itemName:String, callback):Void
        {
            items.createItem(120, (120 * items.length) + 30, itemName, AtlasFont.Bold, callback);
        }

        override function update(elapsed:Float)
        {
            super.update(elapsed);
            
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
                    FlxG.switchState(new OptionsState());
                }
        }
}

class SomeOption extends MusicBeatSubstate
{
    public static var gameoption:Map<String, Dynamic> = new Map();

	var items:TextMenuList;

	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;

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

            menuCamera = new SwagCamera();
            FlxG.cameras.add(menuCamera, true);
            menuCamera.bgColor = 0x0;
            camera = menuCamera;
    
            add(items = new TextMenuList());
    
            createItem('Miss by Hitting', 'press-any-notemiss', false);
            createItem('Loading Check', 'show-loading-state', false);

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

    public static function getGameoption(option:String):Dynamic
        {
            return gameoption.get(option);
        }
        
    public static function setGameoption(option:String, value:Dynamic):Void
        {
            gameoption.set(option, value);
        }

    public static function initGameplay():Void
        {
            gameplayCheck('press-any-notemiss', false);
            gameplayCheck('show-loading-state', false);
        }

    private function createItem(itemName:String, itemString:String, itemValue:Dynamic):Void
        {
            items.createItem(120, (120 * items.length) + 30, itemName, AtlasFont.Bold, function()
            {
                gameplayCheck(itemString, itemValue);
    
                switch (Type.typeof(itemValue).getName())
                {
                    case 'TBool':
                        gameoptionToggle(itemString);
    
                    default:
                        trace('swag');
                }
            });
    
            switch (Type.typeof(itemValue).getName())
            {
                case 'TBool':
                    createCheckbox(itemString);
    
                default:
                    trace('swag');
            }
    
            trace(Type.typeof(itemValue).getName());
        }
    
        function createCheckbox(itemString:String)
        {
            var checkbox:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), gameoption.get(itemString));
            checkboxes.push(checkbox);
            add(checkbox);
        }
    
        /**
         * Assumes that the option has already been checked/set?
         */
        private function gameoptionToggle(itemName:String)
        {
            var daSwap:Bool = gameoption.get(itemName);
            daSwap = !daSwap;
            gameoption.set(itemName, daSwap);
            checkboxes[items.selectedIndex].daValue = daSwap;
            trace('toggled? ' + gameoption.get(itemName));
        }

        private static function gameplayCheck(itemString:String, itemValue:Dynamic):Void
            {
                if (gameoption.get(itemString) == null)
                {
                    gameoption.set(itemString, itemValue);
                    trace('set game option!');
                }
                else
                {
                    trace('found game option: ' + gameoption.get(itemString));
                }
            }

        override function update(elapsed:Float)
            {
                super.update(elapsed);
            
                // menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
            
                if (controls.BACK)
                    {
                        FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
                        close();
                    }
            }
}

class AdjustingWindow extends MusicBeatSubstate
{
    var items:TextMenuList;

	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;

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

            menuCamera = new SwagCamera();
            FlxG.cameras.add(menuCamera, true);
            menuCamera.bgColor = 0x0;
            camera = menuCamera;

            camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
            add(items = new TextMenuList());
            createAdjustingItem('Full screen', function() FlxG.fullscreen = !FlxG.fullscreen);
            createAdjustingItem('FillScaleMode', function() FlxG.scaleMode = new FillScaleMode());
            createAdjustingItem('FixedScaleMode', function() FlxG.scaleMode = new FixedScaleMode());
            createAdjustingItem('RatioScaleMode', function() FlxG.scaleMode = new RatioScaleMode());
            createAdjustingItem('RelativeScaleMode', function() FlxG.scaleMode = new RelativeScaleMode(0.75, 0.75));

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
    
        private function createAdjustingItem(itemName:String, callback):Void
            {
                items.createItem(120, (120 * items.length) + 30, itemName, AtlasFont.Bold, callback);
            }

        override function update(elapsed:Float)
            {
                super.update(elapsed);
            
                if (controls.BACK)
                    {
                        FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
                        close();
                    }
            }
}