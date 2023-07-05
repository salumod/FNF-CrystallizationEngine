package shaderslmfao;

import flixel.system.FlxAssets.FlxShader;

class InvertShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a,   color.a);
        }'
    )

    public function new()
    {
        super();
    }
}