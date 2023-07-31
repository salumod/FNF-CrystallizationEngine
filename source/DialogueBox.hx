package;

import haxe.Timer;
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
    var pixelsong:Array<String> = ['senpai', 'roses', 'thorns'];
	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	public var finishThing:Void->Void;

	var pixelPortraitLeft:FlxSprite;
	var pixelPortraitRight:FlxSprite;
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	// var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var pixelCharactershit:String = 'weeb/dialogue/portrait/';

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
	if (PlayState.isStoryMode)
    {
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
			case 'tutorial': 
			    FlxG.sound.playMusic(Paths.music('breakfast'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
			case 'bopeebo' |'fresh':
				FlxG.sound.playMusic(Paths.music('dailogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8 * FlxG.save.data.volume * FlxG.save.data.musicVolume);
		}
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

		pixelPortraitLeft = new FlxSprite(-20, 40);
		pixelPortraitLeft.frames = Paths.getSparrowAtlas(pixelCharactershit + 'senpaiPortrait');
		pixelPortraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		pixelPortraitLeft.setGraphicSize(Std.int(pixelPortraitLeft.width * 6 * 0.9));
		pixelPortraitLeft.updateHitbox();
		pixelPortraitLeft.scrollFactor.set();
		add(pixelPortraitLeft);
		pixelPortraitLeft.visible = false;

		pixelPortraitRight = new FlxSprite(0, 40);
		pixelPortraitRight.frames = Paths.getSparrowAtlas(pixelCharactershit + 'bfPortrait');
		pixelPortraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		pixelPortraitRight.setGraphicSize(Std.int(pixelPortraitRight.width * 6 * 0.9));
		pixelPortraitRight.updateHitbox();
		pixelPortraitRight.scrollFactor.set();
		add(pixelPortraitRight);
		pixelPortraitRight.visible = false;

		portraitLeft = new FlxSprite(0, 0);
		portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad');
		portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 1));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 0);
		portraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 1));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		var hasDialog = false;

		box = new FlxSprite(-20, 410);
		box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('continued', 'speech bubble normal', 24, true);
		box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24, false);
		box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
        // add(box);

		switch (PlayState.SONG.song.toLowerCase())
		{		
			case 'senpai' | 'roses':
				hasDialog = true;
				box = new FlxSprite(-20, 45);
				// box.frames = Paths.getSparrowAtlas(pixelBoxshit + 'dialogueBox-pixel');
				// box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				// box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.frames = Paths.getSparrowAtlas('weeb/dialogue/Text_Boxes');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.animation.addByPrefix('click', 'Text Box CLICK', 24, false);
				box.animation.addByPrefix('dialogue-end', 'Text Box Sentence End', 24, false);
				box.animation.addByPrefix('wait', 'Text Box wait to click', 24, false);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);
			case 'thorns':
				hasDialog = true;
				box = new FlxSprite(-20, 45);
				box.frames = Paths.getSparrowAtlas('weeb/dialogue/Text_Boxes_Evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				box.animation.addByPrefix('click', 'Spirit Text Box Click', 24, false);
				box.animation.addByPrefix('dialogue-end', 'Spirit Text Box Sentence Complete', 24, false);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			default:
			    hasDialog = true;
		}

		switch (PlayState.SONG.song.toLowerCase())
				{
					case 'score' | 'two-hot' | 'senpai' | 'roses' |'thorns':
					box.flipX = false;
			        default:
					box.flipX = true;
				}	

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		switch (PlayState.SONG.song.toLowerCase())
		{
		    case 'senpai' | 'roses' | 'thorns':
		    box.animation.play('normalOpen');
		    box.setGraphicSize(Std.int(box.width * 6 * 0.9));
		    box.updateHitbox();
		    add(box);

		    default:
		    box.animation.play('normalOpen');
		    box.setGraphicSize(Std.int(box.width * 0.9));
		    box.updateHitbox();
		    add(box);
		}

		box.screenCenter(X);
		pixelPortraitLeft.screenCenter(X);
		portraitLeft.screenCenter(X);

		// if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		// {
		//     handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		// 	handSelect.setGraphicSize(Std.int(handSelect.width * 6 * 0.9));
		// 	handSelect.updateHitbox();
		// 	handSelect.visible = false;
		// 	add(handSelect);
		// }
		// else
		// {
		// 	handSelect = new FlxSprite(960, 610).loadGraphic(Paths.image('dialogue/hand_textbox'));
		// 	handSelect.setGraphicSize(Std.int(handSelect.width));
		// 	handSelect.updateHitbox();
		// 	handSelect.visible = false;
		// 	add(handSelect);
		// }

		talkingRight = !talkingRight;

		var pixelFont:String = 'Pixel Arial 11 Bold';
		var funkinFont:String = 'PhantomMuff 1.5';

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = pixelFont;
			swagDialogue.color = 0xFF3F2021;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), FlxG.save.data.volume * FlxG.save.data.SFXVolume)];

			swagDialogue.borderStyle = SHADOW;
		    swagDialogue.borderColor = 0xFFD89494;
		    swagDialogue.borderSize = 2;
		}
		else
		{
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 40);
			swagDialogue.font = funkinFont;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('text'), FlxG.save.data.volume * FlxG.save.data.SFXVolume)];
			swagDialogue.color = 0xFF000000;

			swagDialogue.borderStyle = SHADOW;
		    swagDialogue.borderColor = 0xFFD8D8D8;
		    swagDialogue.borderSize = 2;
		}

		add(swagDialogue);
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
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			pixelPortraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			swagDialogue.borderColor = FlxColor.BLACK;
		}

    switch (PlayState.SONG.song.toLowerCase())
	{
		case 'senpai' | 'roses' | 'thorns':
			if (box.animation.curAnim != null)
				{
					if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
						{
							box.animation.play('normal');
							dialogueOpened = true;
						}
				}
		default:
			if (box.animation.curAnim != null)
				{
					if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
						{
							box.animation.play('continued');
							dialogueOpened = true;
						}
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
				
			FlxG.sound.play(Paths.sound('clickText'), FlxG.save.data.volume * FlxG.save.data.SFXVolume);

			if (box.animation.curAnim != null)
				{
					box.animation.play('click');
					trace('clicked');
				}

			// if (box.animation.curAnim.name == 'click' && box.animation.curAnim.finished)
			// 	box.animation.play('normal');

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
						pixelPortraitLeft.visible = false;
						pixelPortraitRight.visible = false;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						// handSelect.alpha -= 1 / 5;
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
			swagDialogue.skip();
		
		if (FlxG.keys.justPressed.BACKSPACE)
			dialogueEnded = true;
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function waitDialogue()
	{
		if (box.animation.curAnim.name == 'dialogue-end' && box.animation.curAnim.finished)
		{
			box.animation.play('wait');
			trace('waitDialogue');
		}
		else
			box.animation.play('normal');
	}

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04);

		new FlxTimer().start(6, function(tmr:FlxTimer)
		{
		    waitDialogue();
			return;
	    });

		swagDialogue.completeCallback = function()
		{
			trace("dialogue finish");
			// handSelect.visible = true;
			dialogueOpened = true;

			if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
				{
					if (box.animation.curAnim != null)
						box.animation.play('dialogue-end');
				}

			dialogueEnded = true;
		};

		// handSelect.visible = false;

		dialogueEnded = false;

		if (box.animation.curAnim != null)
			{
			    box.animation.play('normal');
				trace('play Anim: normal');
			}

		switch (curCharacter)
		{
			case 'dad':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 0;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}

			case 'bf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.x = 800;
					portraitRight.y = 200;
					portraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf');
		            portraitRight.animation.addByPrefix('enter', 'enter', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
					box.flipX = false;
				}
			case 'gf':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/gf');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'spooky':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/spooky');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'pico':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/pico');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'pico-player':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 800;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('characters/picoo');
					portraitLeft.animation.addByPrefix('enter', 'idle', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = false;
				}
			case 'darnell':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('characters/darnboy');
					portraitLeft.animation.addByPrefix('enter', 'idle', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'nene':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('characters/nene');
		            portraitLeft.animation.addByPrefix('enter', 'hey', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'mom-hair-blowing':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 60;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/mom-hair-blowing');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'bf-hair-blowing':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.x = 800;
					portraitRight.y = 200;
					portraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf-hair-blowing');
		            portraitRight.animation.addByPrefix('enter', 'enter', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
					box.flipX = false;
				}
			case 'bf-c':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.x = 800;
					portraitRight.y = 200;
					portraitRight.frames = Paths.getSparrowAtlas('dialogue/Portrait/bf-c');
		            portraitRight.animation.addByPrefix('enter', 'enter', 24, false);
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
					box.flipX = false;
				}
			case 'mom-c':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 100;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/mom_dad');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}
			case 'dad-c':
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 100;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad_mom');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}

			//pixel art here!
			case 'bf-pixel':
		        pixelPortraitRight.visible = false;
				pixelPortraitLeft.visible = false;
				if (!pixelPortraitRight.visible)
				{
					pixelPortraitRight.frames = Paths.getSparrowAtlas(pixelCharactershit + 'bfPortrait');
		            pixelPortraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
					pixelPortraitRight.visible = true;
					pixelPortraitRight.animation.play('enter');
					// box.flipX = false;
				}

            case 'bf-pixel-angry':
				pixelPortraitRight.visible = false;
				pixelPortraitLeft.visible = false;
				if (!pixelPortraitRight.visible)
				{
					pixelPortraitRight.frames = Paths.getSparrowAtlas(pixelCharactershit + 'angry');
		            pixelPortraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					pixelPortraitRight.visible = true;
					pixelPortraitRight.animation.play('enter');
					// box.flipX = false;
				}

		    case 'bf-pixel-unkown':
		        pixelPortraitRight.visible = false;
		        pixelPortraitLeft.visible = false;
				if (!pixelPortraitRight.visible)
				{
					pixelPortraitRight.frames = Paths.getSparrowAtlas(pixelCharactershit + 'bf-unkown');
					pixelPortraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					pixelPortraitRight.visible = true;
					pixelPortraitRight.animation.play('enter');
					// box.flipX = false;
				}
            case 'bf-pixel-no':
				pixelPortraitRight.visible = false;
		        pixelPortraitLeft.visible = false;
				if (!pixelPortraitRight.visible)
				{
					pixelPortraitRight.frames = Paths.getSparrowAtlas(pixelCharactershit + 'no');
					pixelPortraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
					pixelPortraitRight.visible = true;
					pixelPortraitRight.animation.play('enter');
					// box.flipX = false;
				}
		    case 'senpai-love':
		        pixelPortraitLeft.visible = false;
		        pixelPortraitRight.visible = false;
				if (!pixelPortraitLeft.visible)
				{
					pixelPortraitLeft.frames = Paths.getSparrowAtlas(pixelCharactershit + 'senpai-love');
		            pixelPortraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
					pixelPortraitLeft.visible = true;
					pixelPortraitLeft.animation.play('enter');
					// box.flipX = true;
				}

			case 'senpai':
		        pixelPortraitLeft.visible = false;
		        pixelPortraitRight.visible = false;
				if (!pixelPortraitLeft.visible)
				{
					pixelPortraitLeft.frames = Paths.getSparrowAtlas(pixelCharactershit + 'senpaiPortrait');
		            pixelPortraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
					pixelPortraitLeft.visible = true;
					pixelPortraitLeft.animation.play('enter');
					// box.flipX = true;
				}

			case 'senpai-angry':
		        pixelPortraitLeft.visible = false;
		        pixelPortraitRight.visible = false;
				if (!pixelPortraitLeft.visible)
				{
					pixelPortraitLeft.frames = Paths.getSparrowAtlas(pixelCharactershit + 'senpai-angry');
		            pixelPortraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					pixelPortraitLeft.visible = true;
					pixelPortraitLeft.animation.play('enter');
					trace('Sprirt:LET ME OUT!');
					// box.flipX = true;
				}

			default:
				portraitLeft.visible = false;
		        portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.x = 0;
					portraitLeft.y = 120;
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Portrait/dad');
		            portraitLeft.animation.addByPrefix('enter', 'enter', 24, false);
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
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
