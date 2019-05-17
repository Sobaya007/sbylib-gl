module sbylib.wrapper.gl.program;

import derelict.opengl;
import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;
import std.conv : to;
public import sbylib.wrapper.gl.shader : Shader;

class Program {

    private immutable ProgramID id;

    this() {
        this.id = GlFunction().createProgram();
    }

    void destroy() {
        GlFunction().deleteProgram(id);
    }

    void attach(Shader shader) {
        GlFunction().attachShader(id, shader.id);
    }

    void link() {
        GlFunction().linkProgram(id);
        assert(linkSuccess, getLogString());
    }

    void use() {
        GlFunction().useProgram(id);
    }

    AttribLoc getAttribLocation(string name) {
        return GlFunction().getAttribLocation(id, name);
    }

    UniformLoc getUniformLocation(string name) {
        return GlFunction().getUniformLocation(id, name);
    }

    int getProgramProperty(ProgramInterface programInterface, ProgramInterfaceProperty prop, string name) {
        import std.format : format;

        auto props = [prop];
        const index = this.getResourceIndex(programInterface, name);
        assert(index >= 0, format!"Invalid variable name: %s"(name));
        return getResource(programInterface, index, props);
    }

    private bool linkSuccess() const {
        return getInfo(ProgramParamName.LinkStatus) == GL_TRUE;
    }

    private string getLogString() const {
        return "GLSL Link Error\n" ~ getInfoLog;
    }

    private string getInfoLog() const {
        auto logLength = this.getLogLength;
        char[] log = new char[logLength];
        GlFunction().getProgramInfoLog(this.id, logLength, &logLength, &log[0]);

        return log.to!string;
    }

    private int getLogLength() const {
        return getInfo(ProgramParamName.InfoLogLength);
    }

    private int getInfo(ProgramParamName name) const {
        return GlFunction().getProgram!(int, 1)(this.id, name)[0];
    }

    private int getInterface(ProgramInterface programInterface, ProgramInterfaceParamName pname) const {
        int result;
        GlFunction().getProgramInterface(this.id, programInterface, pname, &result);
        return result;
    }

    int getResourceIndex(ProgramInterface programInterface, string name) {
        return GlFunction().getProgramResourceIndex(this.id, programInterface, name);
    }
    
    string getResourceName(ProgramInterface programInterface, int index) {
        import std.conv : to;

        char[256] name;
        int len;
        GlFunction().getProgramResourceName(this.id, programInterface, index, name.length, &len, name.ptr);
        return name[0..len].to!string;
    }

    private int getResource(ProgramInterface programInterface, int index, const ProgramInterfaceProperty[] props) 
        in (index >= 0)
    {
        int result;
        GlFunction().getProgramResource(this.id, programInterface, index,
            cast(int)props.length, props.ptr, 1, null, &result);
        return result;
    }
}

