import flixel.system.FlxAssets.FlxShader;

class PixelScaleShader extends FlxShader
{
	@:glFragmentSource("
	#pragma header

	uniform float scale;

	void main()
	{
		// this is a modified version of the code described on this page https://csantosbh.wordpress.com/2014/01/25/manual-texture-filtering-for-pixelated-games-in-webgl/
		// the main difference is that in the following line we get the scaled texture position first, then apply the alpha filtering to it
		
		vec2 vUv = (openfl_TextureCoordv/scale) * openfl_TextureSize;
		vec2 alpha = vec2(0.001, 0.001);
		vec2 x = fract(vUv);
		vec2 x_ = clamp(0.5 / alpha * x, 0.0, 0.5)  + clamp(0.5 / alpha * (x - 1.0) + 0.5, 0.0, 0.5);
		vec2 tCoord = (floor(vUv) + x_) / vec2(openfl_TextureSize.x, openfl_TextureSize.y);
		gl_FragColor = texture2D(bitmap, tCoord);
	}
    ")
	public function new(scale:Int = 4)
	{
		super();
		setScale(scale);
	}

	public function setScale(scale:Int)
	{
		if (scale % 2 == 0)
		{
			this.scale.value = [scale * 1.0];
		}
		else
		{
			throw "Scale factor must be an even number.";
		}
	}
}
