package ui;

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

class GameplayMenu extends ui.OptionsState.Page
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
    
            menuCamera = new SwagCamera();
            FlxG.cameras.add(menuCamera, false);
            menuCamera.bgColor = 0x0;
            camera = menuCamera;
    
            add(items = new TextMenuList());
    
            createItem('Full screen', 'full-screen', false);
            createItem('Press Any Note miss', 'press-any-notemiss', false);
            createItem('Watermark', 'watermark', false);
            createItem('Loading State', 'show-loading-state', false);

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
            gameplayCheck('full-screen', false);
            gameplayCheck('press-any-notemiss', false);
            gameplayCheck('watermark', false);
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
            
                items.forEach(function(daItem:TextMenuItem)
                {
                    if (items.selectedItem == daItem)
                        daItem.x = 150;
                    else
                        daItem.x = 120;
                });

                if (GameplayMenu.getGameoption('full-screen'))
                    {
                        FlxG.fullscreen = true;
		                FlxG.save.data.fullscreen = FlxG.fullscreen;
                    }
                else
                    FlxG.fullscreen = false;
            }

}