package funkin;

import flixel.addons.ui.FlxUIGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class GamePadButton extends FlxGroup
{
    var gamePadButton:FlxButton;
    var icons:FlxSprite;
    var textBox:UItextBox;

    public function new(buttonName:String, txt:String, buttonX:Float, buttonY:Float, ?callback)
        {
            super();

            textBox = new UItextBox(buttonX + 10, buttonY + 10);
            add(textBox);

            gamePadButton = new FlxButton(buttonX, buttonY, "", callback);
            gamePadButton.scrollFactor.set();
            gamePadButton.loadGraphic(Paths.imageUI('button'));
            add(gamePadButton);

            var text:FlxText = new FlxText(textBox.x + 100, textBox.y + 10, 0, "", 30);
            text.scrollFactor.set();
            text.setFormat(Paths.font("Funkin/Funkin.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            text.text = txt;
            add(text);

            icons = new FlxSprite(gamePadButton.x + gamePadButton.width / 2 - 20, gamePadButton.y + gamePadButton.height / 2 - 20);
            icons.frames = Paths.getSparrowAtlas('gameUI/UI');
            icons.scrollFactor.set();
            icons.animation.addByPrefix('1', 'O', 24);
            icons.animation.addByPrefix('2', '△', 24);
            icons.animation.addByPrefix('3', '□', 24);
            icons.animation.addByPrefix('4', 'X', 24);
            add(icons);

            switch (buttonName)
            {
                case 'circle' | 'c' | '1' | 'o' | 'O':
                    icons.animation.play('1');
                case 'triangular' | 't' | '2' | '^':
                    icons.animation.play('2');
                case 'square' | 's' | '3' | '|_':
                    icons.animation.play('3');
                case 'x' | '4' | 'X':
                    icons.animation.play('4');
                default:
                    trace(buttonName + "not found");
            }
        }
}

class GamePadButtonADD extends FlxGroup
{
    var padOne:GamePadButton;
	var padTwo:GamePadButton;
	var padThree:GamePadButton;
	var padFour:GamePadButton;
    var buttonThing:FlxGroup;

    public function new(?circle_txt:String = "ENTER", ?triangular_txt:String = "NONE", ?square_txt:String = "NONE", ?x_txt:String = "NONE", buttonX:Float, descBg:FlxSprite)
    {
        super();

        buttonThing = new FlxGroup(4);
		add(buttonThing);

        padOne = new GamePadButton("1", circle_txt, buttonX, descBg.y + 5);
		buttonThing.add(padOne);

		padTwo = new GamePadButton("2", triangular_txt, buttonX + FlxG.width * 0.2, descBg.y + 5);
		buttonThing.add(padTwo);

		padThree = new GamePadButton("3", square_txt, buttonX + FlxG.width * 0.4, descBg.y + 5);
		buttonThing.add(padThree);

		padFour = new GamePadButton("4", x_txt, buttonX + FlxG.width * 0.6, descBg.y + 5);
		buttonThing.add(padFour);
    }
}

class GamePadOn extends FlxGroup
{
    var gameButton:GamePadButtonADD;

    override public function new(one:String, two:String, three:String, four:String)
        {
            super();

            var descBg:FlxSprite = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
            descBg.scrollFactor.set();
            descBg.alpha = 0.4;
            add(descBg);
    
            gameButton = new GamePadButtonADD(one, two, three, four, FlxG.width * 0.1, descBg);
            add(gameButton);
        }
}

class GameMouse extends FlxGroup
{
    public function new(?mouseName:String, ?size:Float = 2)
    {
        FlxG.mouse.visible = true;
        FlxG.mouse.load(Paths.imageUI(mouseName), size);

        super();
    }

    public function loadBpm(mouseName:Dynamic, ?size:Float = 1)
    {
        FlxG.mouse.visible = true;
        FlxG.mouse.load(mouseName, size);
    }

    public function qucklyADD(?size:Float = 2) 
    {
        FlxG.mouse.visible = true;
        if (FlxG.save.data.MouseColor != null)
			FlxG.mouse.load(Paths.imageUI('MOUSE'), size)
		else
			FlxG.mouse.load(Paths.imageUI('MOUSE_WHITE'), size);
    }
}

class UIadjust extends FlxGroup
{
    var uiLEFT:FlxButton;
	var uiRIGHT:FlxButton;
    var group:FlxGroup;

    public function new(leftX:Float, leftY:Float, width:Float, ?shifting:Float, ?callback_LEFT, ?callback_RIGHT) 
    {
        super();

        group = new FlxGroup(2);
        add(group);

        uiLEFT = new FlxButton(leftX, leftY, "", callback_LEFT);
		uiLEFT.loadGraphic(Paths.imageUI("Button_UILEFT"));
		group.add(uiLEFT);

		uiRIGHT = new FlxButton(leftX + width, leftY + shifting, "", callback_RIGHT);
		uiRIGHT.loadGraphic(Paths.imageUI("Button_UILEFT"));
		uiRIGHT.flipX = true;
		group.add(uiRIGHT);
    }
}

class UItextBox extends FlxSprite
{
    var textBox:FlxSprite;

    public function new(x:Float, y:Float) 
    {
        super();
        
        textBox = new FlxSprite(x, y);
        textBox.loadGraphic(Paths.imageUI('Text_Box'));
        textBox.scrollFactor.set();
    }
}

class UIButton extends FlxGroup
{
    var botton_PLUS:FlxButton;
    var botton_MINUS:FlxButton;
    var botton_GROUP:FlxGroup;

    public function new(x:Float = 0, y:Float = 0, width:Float, ?shifting:Float, ?callback_PLUS, ?callback_MINUS) 
    {
        super();

        botton_GROUP = new FlxGroup(2);
        add(botton_GROUP);

        botton_PLUS = new FlxButton(x + width, y, "", callback_PLUS);
		botton_PLUS.loadGraphic(Paths.imageUI('Button_Up'));
        botton_PLUS.scrollFactor.set();
		botton_GROUP.add(botton_PLUS);

        botton_MINUS = new FlxButton(x, y , "", callback_MINUS);
		botton_MINUS.loadGraphic(Paths.imageUI('Button_Down'));
        botton_MINUS.scrollFactor.set();
		botton_GROUP.add(botton_MINUS);
    }
}