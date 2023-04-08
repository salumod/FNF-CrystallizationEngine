package;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import shaderslmfao.BuildingShaders.BuildingShader;
import shaderslmfao.BuildingShaders;
import shaderslmfao.ColorSwap;
import ui.PreferencesMenu;
#if hxCodec
import hxcodec.VideoHandler;
#end

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class Events extends MusicBeatState
{
    static public function cameraFade(colornoun:String, time:Int)
    {
        trace("Event:cameraFade");
        var color:Int = 0x0;

    switch (colornoun)
    {
        case 'red':
            color = 0xFFFF0000;
        case 'blue':
            color = 0xFF0000FF;
        case 'yellow':
            color = 0xFFFFFF00;
        case 'green':
            color = 0xFF008000;
        case 'white':
            color = 0xFFFFFFFF;
        case 'cray':
            color = 0xFF808080;
        case 'brown':
            color = 0xFF8B4513;
        case 'pink':
            color = 0xFFFFC0CB;
        case 'purple':
            color = 0xFF800080;
        case 'black':
            color = 0xFF000000;
        default:
            {
                color = 0x0;
                trace("error!");
            }
    }

    FlxG.camera.fade(color, time, true);
    }

    static public function playSound(sound:String)
    {
        FlxG.sound.play(Paths.sound(sound));
        trace("Event:playSound");
    }

    static public function playMusic(music:String)
    {
        FlxG.sound.playMusic(Paths.music(music), 0);
        trace("Event:playMusic");
    }

    static public function playAnim(character:Character, anim:String)
    {
        character.playAnim(anim, true);
        trace("Event:playAnim");
    }
}