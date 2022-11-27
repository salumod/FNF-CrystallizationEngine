package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var fportraitLeft:FlxSprite;
	var fportraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'bopeebo':
				FlxG.sound.playMusic(Paths.music('breakfast'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/dialogue/senpai/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/dialogue/bf-pixel/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		fportraitLeft = new FlxSprite(0, 0);
		fportraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad');
		fportraitLeft.animation.addByPrefix('enter', '元件', 24, false);
		fportraitLeft.setGraphicSize(Std.int(fportraitLeft.width * PlayState.defaultCamZoom));
		fportraitLeft.updateHitbox();
		fportraitLeft.scrollFactor.set();
		add(fportraitLeft);
		fportraitLeft.visible = false;

		fportraitRight = new FlxSprite(0, 0);
		fportraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf');
		fportraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		fportraitRight.setGraphicSize(Std.int(fportraitRight.width * PlayState.defaultCamZoom));
		fportraitRight.updateHitbox();
		fportraitRight.scrollFactor.set();
		add(fportraitRight);
		fportraitRight.visible = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'senpai' | 'roses' | 'thorns':
		box = new FlxSprite(-20, 45);
		default:
		box = new FlxSprite(-20, 410);
		}
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{		
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH instance', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);

		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'senpai' | 'roses' | 'thorns':
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);
		default:
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.defaultCamZoom));
		box.updateHitbox();
		add(box);
		
		}
		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		fportraitLeft.screenCenter(X);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'senpai' | 'roses':
		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/dialogue/handSelect/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);
		case 'thorns':
		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/dialogue/handSelect/hand_red'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);	
		default:
		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('dialogue/handSelect/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);
		}


		talkingRight = !talkingRight;

		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'senpai' | 'roses' | 'thorns':
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);
		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		default:
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFF000000;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		swagDialogue.color = 0xFFA5A5A5;
		add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueEnded)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						fportraitLeft.visible = false;
						fportraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						handSelect.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		else if (FlxG.keys.justPressed.ENTER && dialogueStarted)
		{
			swagDialogue.skip();
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function()
		{
			trace('dialogue finish');
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;

		switch (curCharacter)
		{
			case 'dad':
				fportraitLeft.visible = false;
		        fportraitRight.visible = false;
				if (!fportraitLeft.visible)
				{
					fportraitLeft.x = 0;
					fportraitLeft.y = 120;
					fportraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad');
		            fportraitLeft.animation.addByPrefix('enter', '元件', 24, false);
					fportraitLeft.visible = true;
					fportraitLeft.animation.play('enter');
					box.flipX = true;
				}

			case 'bf':
				fportraitRight.visible = false;
				fportraitLeft.visible = false;
				if (!fportraitRight.visible)
				{
					fportraitRight.x = 800;
					fportraitRight.y = 200;
					fportraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf');
		            fportraitRight.animation.addByPrefix('enter', '元件', 24, false);
					fportraitRight.visible = true;
					fportraitRight.animation.play('enter');
					box.flipX = false;
				}
			case 'gf':
				fportraitLeft.visible = false;
		        fportraitRight.visible = false;
				if (!fportraitLeft.visible)
				{
					fportraitLeft.x = 60;
					fportraitLeft.y = 120;
					fportraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/gf');
		            fportraitLeft.animation.addByPrefix('enter', '元件', 24, false);
					fportraitLeft.visible = true;
					fportraitLeft.animation.play('enter');
					box.flipX = true;
				}
				//pixel art
			case 'bf-pixel':
		        portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('weeb/dialogue/bf-pixel/bfPortrait');
		            portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}

            case 'bf-pixel-angry':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('weeb/dialogue/bf-pixel/angry');
		            portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}

		    case 'bf-pixel-unkown':
		        portraitRight.visible = false;
		        portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('weeb/dialogue/bf-pixel/bf-unkown');
					portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
            case 'bf-pixel-no':
				portraitRight.visible = false;
		        portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('weeb/dialogue/bf-pixel/no');
					portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		    case 'senpai-love':
		        portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/dialogue/senpai/senpai-love');
		            portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}

			case 'senpai':
		        portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/dialogue/senpai/senpaiPortrait');
		            portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}

			case 'senpai-angry':
		        portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/dialogue/senpai/senpai-angry');
		            portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
