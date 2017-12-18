package gecko.render;

import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.Shaders;
import gecko.Gecko;


class BlendMode {
    //static public var Normal:BlendMode = BlendMode.Create(BlendingFactor.SourceAlpha, BlendingFactor.InverseSourceAlpha);
    static public var Add:BlendMode = BlendMode.Create(BlendingFactor.BlendOne, BlendingFactor.BlendOne);
    static public var Multiply:BlendMode = BlendMode.Create(BlendingFactor.DestinationColor, BlendingFactor.InverseSourceAlpha);
    static public var Screen:BlendMode = BlendMode.Create(BlendingFactor.BlendOne, BlendingFactor.InverseSourceColor);
    static public var Subtract:BlendMode = BlendMode.Create(BlendingFactor.BlendZero, BlendingFactor.InverseSourceColor);
    static public var Lighten:BlendMode = BlendMode.Create(BlendingFactor.BlendOne, BlendingFactor.BlendOne, BlendingOperation.Max);

    static public function Create(source:BlendingFactor, destination:BlendingFactor, ?operation:BlendingOperation) : BlendMode {
        return new BlendMode(source, destination, operation != null ? operation : BlendingOperation.Add);
    }

    static public function compileAll() {
        var toCompile = [
            //BlendMode.Normal,
            BlendMode.Add,
            BlendMode.Multiply,
            BlendMode.Screen,
            BlendMode.Subtract,
            BlendMode.Lighten
        ];

        for(b in toCompile){
            b.compile();
        }
    }

    public var source:BlendingFactor;
    public var destination:BlendingFactor;
    public var operation:BlendingOperation;

    private var _blendPipeline:PipelineState;
    private var _compiled:Bool = false;

    private function new(source:BlendingFactor, destination:BlendingFactor, operation:BlendingOperation){
        this.source = source;
        this.destination = destination;
        this.operation = operation;

        compile();
    };

    public function getPipeline() : PipelineState {
        return _blendPipeline;
    }
    public function compile() {
        if(_compiled || !Gecko.initiated)return;

        _blendPipeline = new PipelineState();

        var structure = new VertexStructure();
        structure.add("vertexPosition", VertexData.Float3);
        structure.add("texPosition", VertexData.Float2);
        structure.add("vertexColor", VertexData.Float4);
        _blendPipeline.inputLayout = [structure];

        _blendPipeline.fragmentShader = Shaders.painter_image_frag;
        _blendPipeline.vertexShader = Shaders.painter_image_vert;

        _blendPipeline.blendSource = source;
        _blendPipeline.blendDestination = destination;
        _blendPipeline.blendOperation = operation;
        _blendPipeline.compile();

        _compiled = true;
    }
}