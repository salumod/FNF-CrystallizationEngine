package;

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
    var textBox:FlxSprite;

    public function new(buttonName:String, txt:String, buttonX:Float, buttonY:Float, ?callback)
        {
            super();

            textBox = new FlxSprite(buttonX + 10, buttonY + 10);
            textBox.loadGraphic(Paths.image('gameUI/Text_Box'));
            textBox.scrollFactor.set();
            add(textBox);

            gamePadButton = new FlxButton(buttonX, buttonY, "", callback);
            gamePadButton.scrollFactor.set();
            gamePadButton.loadGraphic(Paths.image('gameUI/button'));
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

class ButtonADD extends FlxGroup
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
    var gameButton:ButtonADD;

    override public function new(one:String, two:String, three:String, four:String)
        {
            super();

            var descBg:FlxSprite = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
            descBg.scrollFactor.set();
            descBg.alpha = 0.4;
            add(descBg);
    
            gameButton = new ButtonADD(one, two, three, four, FlxG.width * 0.1, descBg);
            add(gameButton);
        }
}

class GameMouse extends FlxGroup
{

    public function new(?mouseName:String = 'MOUSE_WHITE', ?size:Int = 2)
    {
        FlxG.mouse.visible = true;
		if (FlxG.save.data.MouseColor != null)
			FlxG.mouse.load(Paths.imageUI('MOUSE'), 2)
		else
			FlxG.mouse.load(Paths.imageUI('MOUSE_WHITE'), 2);

        super();
    }
}