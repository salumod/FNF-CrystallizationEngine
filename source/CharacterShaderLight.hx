package;

import flixel.system.FlxAssets.FlxShader;
class WiggleShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		sdfsd
		void main()
		{
			vec2 uv = sineWave(openfl_TextureCoordv);
			gl_FragColor = texture2D(bitmap, uv);
		}')
	public function new()
	{
		super();
	}
}
