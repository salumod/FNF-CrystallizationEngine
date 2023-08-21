package;

import funkin.GameUI.GameMouse;
import flixel.input.mouse.FlxMouse;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;

class CloseGameState extends MusicBeatState
{
	var buttonYes:FlxButton;
	var buttonNo:FlxButton;
	var yes:FlxText;
	var no:FlxText;
    var mouse:GameMouse;
    var curSelected:Int;

	override public function create()
	{
		TitleState.showReading = false;
		
		var bg:FlxSprite = new FlxSprite(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.17;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		
		var txt = new FlxText(0, 0, 0, "Do you want to EXIT?", 20);
		txt.setFormat(Paths.font("Funkin/Funkin.ttf"), 70, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();

		buttonYes = new FlxButton(200, 470, gameExit);
		buttonYes.loadGraphic(Paths.imageUI('Normal_Button'));
		buttonYes.setGraphicSize(Std.int(bg.width * 0.2));
		buttonYes.updateHitbox();

		yes = new FlxText(270, 480, 0, "YES", 20);
		yes.setFormat(Paths.font("Funkin/Funkin.ttf"), 70, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		buttonNo = new FlxButton(800, 470, exitState);
		buttonNo.loadGraphic(Paths.imageUI('Normal_Button'));
		buttonNo.setGraphicSize(Std.int(bg.width * 0.2));
		buttonNo.updateHitbox();

		no = new FlxText(890, 480, 0, "NO", 20);
		no.setFormat(Paths.font("Funkin/Funkin.ttf"), 70, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		yesSelect();
		
		gamePrompt();
		add(buttonYes);
		add(buttonNo);
		add(txt);
        add(yes);
		add(no);

		super.create();
	}

	function gamePrompt(?promptAni:String = 'normal')
		{
			var prompt:FlxSprite = new FlxSprite();

			var farme = Paths.getSparrowAtlas('prompt-ng_login');
		    prompt.frames = farme;

		    prompt.animation.addByPrefix('normal', 'back', 24, false);

		    prompt.scrollFactor.set();
		    prompt.updateHitbox();
		    prompt.screenCenter();

            add(prompt);

			prompt.animation.play('normal');
		}

	function yesSelect() 
	{
		no.color = FlxColor.WHITE;
		no.alpha = 0.6;
		yes.alpha = 1;
		yes.color = FlxColor.YELLOW;
	}

	function noSelect() 
	{
		yes.color = FlxColor.WHITE;
		yes.alpha = 0.6;
		no.alpha = 1;
		no.color = FlxColor.YELLOW;
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected <= 0)
			yesSelect();
		if (curSelected >= 1)
			noSelect();
		if (curSelected < 0)
			curSelected = 0;
		if (curSelected > 1)
			curSelected = 1;
	}

	function gameExit()
		{
			FlxTween.tween(no, {alpha: 0}, 0.4, 
				{
					onComplete: function(twn:FlxTween)
					{
                        remove(no);
						#if cpp
			            Sys.exit(0);
			            #end
					}
				});

			FlxTween.tween(buttonNo, {alpha: 0}, 0.4, 
				{
					onComplete: function(twn:FlxTween)
					{
						remove(buttonNo);
					}
				});
				FlxG.log.redirectTraces = true;
		}

	function exitState() 
	{

		FlxTween.tween(yes, {alpha: 0}, 0.4, 
		{
			onComplete: function(twn:FlxTween)
			{
				remove(yes);
				FlxG.switchState(new TitleState());
			}
		});

		FlxTween.tween(buttonYes, {alpha: 0}, 0.4, 
		{
			onComplete: function(twn:FlxTween)
			{
				remove(buttonYes);
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (controls.UI_LEFT)
		{
			changeSelection(-1);
		}
		if (controls.UI_RIGHT)
		{
			changeSelection(1);
		}
        if (controls.ACCEPT && curSelected == 0)
			gameExit();
		if (controls.ACCEPT && curSelected == 1)
			exitState();

		super.update(elapsed);
	}
}