module sbylib.wrapper.gl.shader;

import derelict.opengl;

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;
import std.conv : to;

class Shader {

    package immutable ShaderID id;

    this(ShaderType type) {
        this.id = GlFunction().createShader(type);
    }

    void destroy() const {
        GlFunction().deleteShader(id);
    }

    string source(string source) const {
        GlUtils().shaderSource(id, source);
        GlFunction().compileShader(id);
        assert(this.compileSuccess(), getLogString(source));
        return source;
    }

    ShaderType getShaderType() const {
        return getInfo(ShaderParamName.ShaderType).to!ShaderType;
    }

    private string getLogString(string sourceCode) const {
        import std.string : splitLines;
        import std.algorithm : all, sort, canFind, map, filter, countUntil, minElement;
        import std.array : array;
        import std.regex : matchAll, ctRegex;
        import std.format : format;
        import std.conv : to;

        const log = getInfoLog;
        const lines = log.splitLines;
        int[] lineNum;
        foreach (line; lines) {
            const r = line.matchAll(ctRegex!r"(\d+):(\d+)\((\d+)\): error: .*");
            if (r.empty) continue;

            lineNum ~= r.front[2].to!int-1;
        }
        auto r = lineNum.sort();
        string result = "\nGLSL Compile Error\n";
        result ~= "==========================================\n";
        auto strs = sourceCode.splitLines;
        auto verboseSpaceCount = strs
            .map!(str => str.countUntil!(c => c != ' '))
            .filter!(c => c != -1)
            .minElement;
        strs = strs.map!(str => verboseSpaceCount < str.length ? str[verboseSpaceCount..$] : str).array;
        foreach (i, str; strs) {
            result ~= format!"%s%4d|%s\n"(
                    r.canFind(i) ? ">" : " ",
                    i+1, str);
        }
        result ~= "==========================================\n";
        result ~= log;
        result ~= "==========================================\n";
        return result;
    }

    private string getInfoLog() const {
        auto logLength = getLogLength();
        char[] log = new char[logLength];
        GlFunction().getShaderInfoLog(id, logLength, &logLength, &log[0]);

        return log.to!string;
    }

    private int getLogLength() const {
        return this.getInfo(ShaderParamName.InfoLogLength);
    }

    private bool compileSuccess() const {
        return getInfo(ShaderParamName.CompileStatus) == GL_TRUE;
    }

    private int getInfo(ShaderParamName name) const {
        return GlFunction().getShader!(int,1)(id, name)[0];
    }
}
