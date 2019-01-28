import sbylib.wrapper.gl;
import sbylib.wrapper.glfw;
import std.file : readText;

void main() {
    auto window = initialize();

    auto vert = new Shader(ShaderType.Vertex);
    scope(exit) vert.destroy();
    auto frag = new Shader(ShaderType.Fragment);
    scope(exit) frag.destroy();

    vert.source = readText("test.vert");
    frag.source = readText("test.frag");


    auto program = new Program();
    scope(exit) program.destroy();

    program.attach(vert);
    program.attach(frag);
    program.link();


    auto vbo = new Buffer!float;
    scope(exit) vbo.destroy();

    vbo.sendData([
        -1f, -1f,
        -1f, +1f,
        +1f, -1f,
        +1f, +1f
    ], BufferTarget.Array);


    auto ibo = new Buffer!ubyte;
    scope(exit) ibo.destroy();

    ibo.sendData([
        0,1,2,
        1,2,3
    ], BufferTarget.ElementArray);


    auto vao = new VertexArray;
    scope(exit) vao.destroy();

    vao.bind();
    vao.enable(program.getAttribLocation("pos"));
    vbo.useAsAttribute(program.getAttribLocation("pos"), 2);
    ibo.useAsIndex();


    alias render = {
        GlFunction.clearColor(0,0.1,0,1);
        GlFunction.clear(ClearMode.Color);

        program.use();
        vao.bind();
        GlFunction.drawElements!ubyte(Prim.Triangle, 6, null);
    };

    mainLoop!render(window);


    finalize(window);
}

private Window initialize() {
    GLFW.initialize();

    with (WindowBuilder) {
        width = 800;
        height = 600;
        title = "po";
        resizable = false;
        contextVersionMajor = 4;
        contextVersionMinor = 4;
    }

    auto window = WindowBuilder.buildWindow();

    with (window) {
        setKeyCallback!(keyCallback);
        makeCurrent();
    }

    GL.initialize();
    return window;
}

private void mainLoop(alias render)(Window window) {
    while (!window.shouldClose()) {

        render();
        window.swapBuffers();
        GLFW.pollEvents();
    }
}

private void finalize(Window window) {
    window.destroy();
    GLFW.terminate();
}

void keyCallback(Window window, KeyButton button, int,
        ButtonState state, BitFlags!ModKeyButton) nothrow {
    try {
        if (state != ButtonState.Press) return;

        if (button == KeyButton.Escape) window.shouldClose = true;
    } catch (Throwable e) {
        assert(false, e.toString);
    }
}
