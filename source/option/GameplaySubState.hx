package option;

import flixel.FlxGame;
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

class GameplayMenu extends MusicBeatSubstate
{
	var items:TextMenuList;

	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

    override function create()
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
            
            add(items = new TextMenuList());
    
            createItem('Game Mechanics', function() openSubState(new SomeOption()));
            createItem('Game Mode', function() openSubState(new GameMode()));
            createItem('Adjusting', function() openSubState(new AdjustingWindow()));
            createItem('Achievements', function() openSubState(new Achievements()));
            createItem('Clear all data', function() FlxG.save.erase());

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

        private function createItem(itemName:String, callback):Void
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

class SomeOption extends MusicBeatSubstate
{
	var items:TextMenuList;
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;
    var checkboxes:Array<CheckboxThingie> = [];
    
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
    
            createItem('Image Enhancement', FlxG.save.data.ImagesEnhancement);
            createItem('Miss by Hitting', FlxG.save.data.MissbyHitting);
            createItem('downscroll', FlxG.save.data.downscroll);
            createItem('Loading Check', FlxG.save.data.CheckLoading);

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
                    switch (itemName)
                    {
                        case 'Image Enhancement':
                            FlxG.save.data.ImagesEnhancement = !FlxG.save.data.ImagesEnhancement;
                            defaultValue = FlxG.save.data.ImagesEnhancement;
                        case 'Miss by Hitting':
                            FlxG.save.data.MissbyHitting = !FlxG.save.data.MissbyHitting;
                            defaultValue = FlxG.save.data.MissbyHitting;
                        case 'downscroll':
                            FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
                            defaultValue = FlxG.save.data.downscroll;
                        case 'Loading Check':
                            FlxG.save.data.CheckLoading = !FlxG.save.data.CheckLoading;
                            defaultValue = FlxG.save.data.CheckLoading;
                    }

                    trace('CLICKED!: ' + defaultValue);
                    checkboxes[items.selectedIndex].daValue = defaultValue;
                    trace(itemName + ' value: ' + defaultValue);
                });
        
                createCheckbox(defaultValue);
            }

        private function createCheckbox(daValue:Bool)
        {
            var checkbox:CheckboxThingie = new CheckboxThingie(900, 120 * (items.length - 1), daValue);
            checkboxes.push(checkbox);
            add(checkbox);
        }

        override function update(elapsed:Float)
            {
                super.update(elapsed);

                if (controls.BACK)
                    {
                        FlxG.save.flush();
                        FlxG.sound.play(Paths.sound('cancelMenu'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
                        close();
                    }
            }

        static public function defaultValueInit()
                {
                    if (FlxG.save.data.ImagesEnhancement == null)
                        {
                            FlxG.save.data.ImagesEnhancement = false;
                        }
                    else
                        {
                           trace('found option save date!');
                        }
            
                    if (FlxG.save.data.MissbyHitting == null)
                        {
                            FlxG.save.data.MissbyHitting = false;
                        }
                    else
                        {
                            trace('found option save date!');
                        }
            
                    if (FlxG.save.data.downscroll == null)
                        {
                            FlxG.save.data.downscroll = false;
                            
                        }
                    else
                        {
                            trace('found option save date!');
                        }
            
                    if (FlxG.save.data.CheckLoading == null)
                        {
                            FlxG.save.data.CheckLoading = true;
                        }
                    else
                        {
                            trace('found option save date!');
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
            createItem('Full screen', function() FlxG.fullscreen = !FlxG.fullscreen);
            createItem('FillScaleMode', function() FlxG.scaleMode = new FillScaleMode());
            createItem('FixedScaleMode', function() FlxG.scaleMode = new FixedScaleMode());
            createItem('RatioScaleMode', function() FlxG.scaleMode = new RatioScaleMode());
            createItem('RelativeScaleMode', function() FlxG.scaleMode = new RelativeScaleMode(0.75, 0.75));

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
    
        private function createItem(itemName:String, callback):Void
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

class GameMode extends MusicBeatSubstate
{
    var checkboxes:Array<CheckboxThingie> = [];
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

            createItem('extreme mode', FlxG.save.data.extremeMode);
            createItem('practice mode', FlxG.save.data.practiceMode);
            createItem('mirror mode', FlxG.save.data.mirrorMode);
            #if debug
            createItem('challenge mode', FlxG.save.data.challengeMode);
            #end
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
                items.createItem(120, (120 * items.length) + 30, itemName, AtlasFont.Bold, function()
                {
                            switch (itemName)
                            {
                                case 'extreme mode':
                                    FlxG.save.data.extremeMode = !FlxG.save.data.extremeMode;
                                    defaultValue = FlxG.save.data.extremeMode;
                                case 'practice mode':
                                    FlxG.save.data.practiceMode = !FlxG.save.data.practiceMode;
                                    defaultValue = FlxG.save.data.practiceMode;
                                case 'mirror mode':
                                    FlxG.save.data.mirrorMode = !FlxG.save.data.mirrorMode;
                                    defaultValue = FlxG.save.data.mirrorMode;
                                case 'challenge mode':
                                    FlxG.save.data.challengeMode = !FlxG.save.data.challengeMode;
                                    defaultValue = FlxG.save.data.challengeMode;
                            }
        
                            trace('CLICKED!: ' + defaultValue);
                            checkboxes[items.selectedIndex].daValue = defaultValue;
                            trace(itemName + ' value: ' + defaultValue);
                });
                
                createCheckbox(defaultValue);
            }

        private function createCheckbox(daValue:Bool)
        {
            var checkbox:CheckboxThingie = new CheckboxThingie(900, 120 * (items.length - 1), daValue);
            checkboxes.push(checkbox);
            add(checkbox);
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
            static public function defaultValueInit()
                {
                    if (FlxG.save.data.extremeMode == null)
                        {
                            FlxG.save.data.extremeMode = false;
                        }
                    else
                        {
                           trace('found game mode: Extreme Mode');
                        }
                    if (FlxG.save.data.practiceMode == null)
                        {
                            FlxG.save.data.practiceMode = false;
                        }
                    else
                        {
                            trace('found game mode: Practice Mode');
                        }
                    if (FlxG.save.data.mirrorMode == null)
                        {
                            FlxG.save.data.mirrorMode = false;
                        }
                    else
                        {
                            trace('found game mode: Mirror Mode');
                        }
            
                    if (FlxG.save.data.challengeMode == null)
                        {
                            FlxG.save.data.challengeMode = false;
                        }
                    else
                        {
                            trace('found game mode: Challenge Mode');
                        }
                }
}

class Achievements extends MusicBeatSubstate
{
    var menuCamera:FlxCamera;
    var selected:Int;
    var achievementsName:Array<String> = ['perfect', 'FC', 'beat!'];
    var someIcon:FlxSprite;

    public function new() 
    {
        super();    
    }

    override function create() 
    {
        menuCamera = new SwagCamera();
        FlxG.cameras.add(menuCamera, true);
        menuCamera.bgColor = 0x0;
        camera = menuCamera;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.scrollFactor.set();
        bg.alpha = 0.8;
        add(bg);

        for (i in 0 ... achievementsName.length)
        {
            addAchievements(300 * i, 0, achievementsName[i]);
        }

        menuCamera.follow(someIcon, null, 0.06);

        super.create();
    }

    public function addAchievements(x:Float, y:Float, someAchievements:String) 
    {
        someIcon = new FlxSprite(x, y);
		someIcon.frames = Paths.getSparrowAtlas('achievements/' + someAchievements);
		someIcon.scrollFactor.set();
		someIcon.animation.addByPrefix('begin', 'begin', 24, false);
		someIcon.updateHitbox();
		add(someIcon);
        someIcon.animation.play('begin');

        switch(someAchievements)
        {
            case 'perfect':
                if (!FlxG.save.data.achievements_perfect)
                    someIcon.color = FlxColor.BLACK;
            case 'FC':
                if (!FlxG.save.data.achievements_FC)
                    someIcon.color = FlxColor.BLACK;
            case 'beat!':
                if (!FlxG.save.data.beatDad)
                    someIcon.color = FlxColor.BLACK;
        }
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