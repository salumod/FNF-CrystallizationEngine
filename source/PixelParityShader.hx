package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
/**
 * ...
 * @author aeveis
 */

class PixelParityShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
			precision mediump float;
		#endif
		
		uniform vec2 size;
		uniform vec2 stageSize;
	
		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec2 uv1 = openfl_TextureCoordv;
			
			uv.x = ceil(uv.x * size.x) / size.x;
			uv.y = ceil(uv.y * size.y) / size.y;
			
			gl_FragColor = texture2D(bitmap, uv);
		}
	')
	public function new(p_width:Float, p_height:Float)
	{
		super();
	
		size.value = [p_width - 1, p_height - 1];
	}
}