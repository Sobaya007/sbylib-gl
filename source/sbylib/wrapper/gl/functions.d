module sbylib.wrapper.gl.functions;

import derelict.opengl;
import sbylib.wrapper.gl.constants;
import std.traits : isBasicType;

struct GlFunction {

    ~this() {
        import std.conv : to;
        const error = getError();
        assert(error == ErrorType.NoError, error.to!string);
    }

    void enable(Capability cap) {
        glEnable(cap);
    }

    void disable(Capability cap) {
        glDisable(cap);
    }

    void clear(ClearMode[] mode...) {
        import std.algorithm : reduce;
        glClear(reduce!((a,b)=>a|b)(mode));
    }

    void clearColor(float r, float g, float b, float a) {
        glClearColor(r, g, b, a);
    }

    void clearDepth(double depth) {
        glClearDepth(depth);
    }

    void clearStencil(int stencil) {
        glClearStencil(stencil);
    }

    void colorMask(bool r, bool g, bool b, bool a) {
        glColorMask(r, g, b, a);
    }

    void depthMask(bool mask) {
        glDepthMask(mask);
    }

    void stencilMask(uint mask) {
        glStencilMask(mask);
    }

    void blendFunc(BlendFactor src, BlendFactor dst)  {
        glBlendFunc(src, dst);
    }

    void blendEquation(BlendEquation eq) {
        glBlendEquation(eq);
    }

    void depthFunc(TestFunc func) {
        enable(Capability.DepthTest);
        glDepthFunc(func);
    }

    void stencilFunc(TestFunc test, uint reffer, uint mask) {
        glStencilFunc(test, reffer, mask);
    }

    void stencilOp(StencilWrite sfail, StencilWrite dpfail, StencilWrite pass) {
        glStencilOp(sfail, dpfail, pass);
    }

    void cullFace(FaceMode face) {
        glCullFace(face);
    }

    void polygonMode(FaceMode face, PolygonMode polygon) {
        glPolygonMode(face, polygon);
    }

    void setPixelPackAlign(int alignment)
        in( alignment == 1
        || alignment == 2
        || alignment == 4
        || alignment == 8)
    {
        glPixelStorei(PixelAlignType.Pack, alignment);
    }

    void setPixelUnpackAlign(int alignment)
        in( alignment == 1
        || alignment == 2
        || alignment == 4
        || alignment == 8)
    {
        glPixelStorei(PixelAlignType.Unpack, alignment);
    }

    void genBuffers(uint num, uint* ptr) {
        glGenBuffers(num, ptr);
    }

    void deleteBuffers(uint num, uint* ptr) {
        glDeleteBuffers(num, ptr);
    }

    void bindBuffer(BufferTarget target, BufferID id) {
        glBindBuffer(target, id);
    }

    void bufferData(Type)(BufferTarget target, size_t size, const Type* data, BufferUsage usage) {
        glBufferData(target, size, data, usage);
    }

    void bufferSubData(Type)(BufferTarget target, size_t offset, size_t size, const Type* data) {
        glBufferSubData(target, offset, size, data);
    }

    void getBufferSubData(Type)(BufferTarget target, long offset, long size, Type* data) {
        glGetBufferSubData(target, offset, size, data);
    }

    void* mapBuffer(BufferTarget target, BufferAccess access) {
        auto res = glMapBuffer(target, access);
        return res;
    }

    void unmapBuffer(BufferTarget target) {
        glUnmapBuffer(target);
    }

    void genFramebuffers(uint num, FramebufferID* ptr) {
        glGenFramebuffers(num, ptr);
    }

    void deleteFramebuffers(uint num, FramebufferID* ptr) {
        glDeleteFramebuffers(num, ptr);
    }

    void bindFramebuffer(FramebufferBindType target, FramebufferID id) {
        glBindFramebuffer(target, id);
    }

    void framebufferRenderbuffer(FramebufferBindType bindType, FramebufferAttachType attachType, RenderbufferID renderbufferID) {
        glFramebufferRenderbuffer(bindType, attachType, RenderbufferBindType.Both, renderbufferID);
    }

    void blitFramebuffer(uint srcX0, uint srcY0, uint srcX1, uint srcY1, uint dstX0, uint dstY0, uint dstX1, uint dstY1, TextureFilter filter, BufferBit[] bit...) {
        import std.algorithm : reduce;
        glBlitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, bit.reduce!((a,b)=>a|b), filter);
    }

    void genRenderbuffers(uint num, RenderbufferID* ptr) {
        glGenRenderbuffers(num, ptr);
    }

    void deleteRenderbuffers(uint num, RenderbufferID* ptr) {
        glDeleteRenderbuffers(num, ptr);
    }

    void bindRenderbuffer(RenderbufferID id) {
        glBindRenderbuffer(RenderbufferBindType.Both, id);
    }

    void renderbufferStorage(uint width, uint height, TextureInternalFormat format) {
        glRenderbufferStorage(RenderbufferBindType.Both, format, width, height);
    }

    void genTextures(uint num, TextureID *ptr) {
        glGenTextures(num, ptr);
    }

    void deleteTextures(uint num, TextureID *ptr) {
        glDeleteTextures(num, ptr);
    }

    void bindTexture(TextureTarget target, TextureID id) {
        glBindTexture(target, id);
    }

    void activeTexture(TextureUnit unit) {
        glActiveTexture(GL_TEXTURE0 + unit);
    }

    void texImage2D(Type)(TextureTarget target, uint mipmapLevel, TextureInternalFormat iformat, uint width, uint height, uint border, TextureFormat format, Type *data) {
        glTexImage2D(target, mipmapLevel, iformat, width, height, border, format, GlUtils.getTypeEnum!Type, data);
    }

    void texSubImage2D(Type)(TextureTarget target, uint mipmapLevel, uint offsetX, uint offsetY, uint width, uint height, TextureFormat format, Type *data) {
        glTexSubImage2D(target, mipmapLevel, offsetX, offsetY, width, height, format, GlUtils.getTypeEnum!Type, data);
    }

    void bindImageTexture(TextureUnit unit, TextureID id, uint level, bool layered, uint layer, BufferAccess access, TextureInternalFormat format)
        in(unit < GL_MAX_IMAGE_UNITS)
    do {
        glBindImageTexture(unit, id, level, layered, layer, access, format);
    }

    void framebufferTexture2D(FramebufferBindType bindType, FramebufferAttachType attachType, TextureTarget target, TextureID id, uint level) {
        glFramebufferTexture2D(bindType, attachType, target, id, level);
    }

    void getTexImage(Type)(TextureTarget target, uint level, TextureFormat format, Type* ptr) {
        glGetTexImage(target, level, format, GlUtils.getTypeEnum!(Type), ptr);
    }

    void readPixel(Type)(int x, int y, int width, int height, TextureFormat format, Type* ptr) {
        glReadPixels(x, y, width, height, format, GlUtils.getTypeEnum!(Type), ptr);
    }

    void genVertexArrays(uint num, VertexArrayID *ptr) {
        glGenVertexArrays(num, ptr);
    }

    void deleteVertexArray(uint num, VertexArrayID *ptr) {
        glDeleteVertexArrays(num, ptr);
    }

    void bindVertexArray(VertexArrayID id) {
        glBindVertexArray(id);
    }

    void drawArrays(Primitive prim, uint offset, uint count) {
        glDrawArrays(prim, offset, count);
    }

    void drawElements(IndexType)(Primitive prim, uint length, IndexType* indices = null) 
        if (is(IndexType == ubyte) || is(IndexType == ushort) || is(IndexType == uint))
    {
        glDrawElements(prim, length, GlUtils.getTypeEnum!(IndexType), cast(void*)indices);
    }

    void setViewport(uint x, uint y, uint w, uint h) {
        glViewport(x,y,w,h);
    }

    void scissor(uint x, uint y, uint width, uint height) {
        enable(Capability.ScissorTest);
        glScissor(x, y, width, height);
    }

    ProgramID createProgram() {
        auto id = glCreateProgram();
        return id;
    }

    void deleteProgram(ProgramID id) {
        glDeleteProgram(id);
    }

    void useProgram(ProgramID id) {
        glUseProgram(id);
    }

    void linkProgram(ProgramID id) {
        glLinkProgram(id);
    }

    void getProgramInfoLog(ProgramID id, int maxLength, int *length, char *infoLog) {
        glGetProgramInfoLog(id, maxLength, length, infoLog);
    }

    void getProgramInterface(ProgramID id, ProgramInterface programInterface,
            ProgramInterfaceParamName pname, int* params) {
        glGetProgramInterfaceiv(id, programInterface, pname, params);
    }

    void getProgramResourceName(ProgramID id, ProgramInterface programInterface,
            uint index, int bufSize, int* length, char* name) {
        glGetProgramResourceName(id, programInterface, index, bufSize, length, name);
    }

    int getProgramResourceIndex(ProgramID id, ProgramInterface programInterface, string name) {
        import std.string : toStringz;
        return glGetProgramResourceIndex(id, programInterface, name.toStringz);
    }

    void getProgramResource(ProgramID id, ProgramInterface programInterface,
            uint index, int propCount, const ProgramInterfaceProperty* props,
            int bufSize, int* length, int* params) {
        glGetProgramResourceiv(id, programInterface, index, propCount,
                cast(const(uint)*)props, bufSize, length, params);
    }

    void attachShader(ProgramID programID, ShaderID shaderID) {
        glAttachShader(programID, shaderID);
    }

    AttribLoc getAttribLocation(ProgramID programID, string name) {
        import std.string : toStringz;
        auto loc = glGetAttribLocation(programID, name.toStringz);
        return loc;
    }

    UniformLoc getUniformLocation(ProgramID programID, string name) {
        import std.string : toStringz;
        auto loc = glGetUniformLocation(programID, name.toStringz);
        return loc;
    }

    ShaderID createShader(ShaderType type) {
        auto id = glCreateShader(type);
        return id;
    }

    void deleteShader(ShaderID id) {
        glDeleteShader(id);
    }

    void shaderSource(ShaderID id, uint num, char** sourceList, int* lengthList) {
        glShaderSource(id, num, sourceList, lengthList);
    }

    void compileShader(ShaderID id) {
        glCompileShader(id);
    }

    void getShaderInfoLog(ShaderID id, int maxLength, int *length, char *infoLog) {
        glGetShaderInfoLog(id, maxLength, length, infoLog);
    }

    void enableVertexAttribArray(AttribLoc loc) {
        glEnableVertexAttribArray(loc);
    }

    void disableVertexAttribArray(AttribLoc loc) {
        glDisableVertexAttribArray(loc);
    }

    void vertexAttribPointer(VertexType, OffsetType)(AttribLoc loc, uint size, bool normalized, uint stride, OffsetType ptr) {
        glVertexAttribPointer(loc, size, GlUtils.getTypeEnum!(VertexType), normalized, stride, cast(void*)ptr);
    }

    void dispatchCompute(uint groupNumX, uint groupNumY, uint groupNumZ) {
        glDispatchCompute(groupNumX, groupNumY, groupNumZ);
    }

    void uniformBlockBinding(ProgramID programID, uint loc, uint uniformBlockPoint) {
        glUniformBlockBinding(programID, loc, uniformBlockPoint);
    }

    void bindBufferBase(BufferTarget target, uint blockPoint, BufferID id) {
        glBindBufferBase(target, blockPoint, id);
    }

    UniformLoc getUniformBlockIndex(ProgramID programID, string name) {
        import std.string : toStringz;
        int loc = glGetUniformBlockIndex(programID, name.toStringz);
        return loc;
    }

    void readBuffer(FramebufferAttachType type) {
        glReadBuffer(type);
    }

    void drawBuffer(FramebufferAttachType type) {
        glDrawBuffer(type);
    }

    void drawBuffers(FramebufferAttachType[] types) {
        glDrawBuffers(cast(int)types.length, cast(uint*)types.ptr);
    }

    ErrorType getError() {
        import std.conv : to;
        return glGetError().to!ErrorType;
    }

    FramebufferStatus checkFramebufferStatus(FramebufferBindType type) {
        import std.conv : to;
        return glCheckFramebufferStatus(type).to!FramebufferStatus;
    }

    auto get(T, size_t N)(ParamName param) {
        T[N] data;
        getFunction!T(param, data.ptr);
        return data;
    }

    private template getFunction(T) {
        static if (is(T == int)) {
            alias getFunction = glGetIntegerv;
        } else static if (is(T == float)) {
            alias getFunction = glGetFloatv;
        } else static if (is(T == bool)) {
            alias getFunction = glGetBooleanv;
        } else {
            static assert(false);
        }
    }

    auto getProgram(T, size_t N)(ProgramID programID, ProgramParamName param) {
        T[N] data;
        getProgramFunction!T(programID, param, data.ptr);
        return data;
    }

    private template getProgramFunction(T) {
        static if (is(T == int)) {
            alias getProgramFunction = glGetProgramiv;
        } else static if (is(T == float)) {
            alias getProgramFunction = glGetProgramfv;
        } else {
            static assert(false);
        }
    }

    auto getShader(T, size_t N)(ShaderID shaderID, ShaderParamName param) {
        T[N] data;
        getShaderFunction!T(shaderID, param, data.ptr);
        return data;
    }

    private template getShaderFunction(T) {
        static if (is(T == int)) {
            alias getShaderFunction = glGetShaderiv;
        } else static if (is(T == float)) {
            alias getShaderFunction = glGetShaderfv;
        } else {
            static assert(false);
        }
    }

    void setTexParameter(T)(TextureTarget target, TextureParamName pname, T value) {
        setTexParamFunction!(T)(target, pname, value);
    }

    private template setTexParamFunction(T) {
        static if (is(T == int))
            alias setTexParamFunction = glTexParameteri;
        else static if (is(T == float))
            alias setTexParamFunction = glTexParameterf;
    }

    T[N] getTexParameter(T,size_t N)(TextureTarget target, TextureParamName pname) {
        T[N] data;
        getTexParamFunction!(T)(target, pname, data.ptr);
        return data;
    }

    private template getTexParamFunction(T) {
        static if (is(T == int))
            alias getTexParamFunction = glGetTexParameteriv;
        else static if (is(T == float))
            alias getTexParamFunction = glGetTexParameterfv;
    }

    T[N] getTexLevelParameter(T,size_t N)(TextureTarget target, int level, TextureLevelParamName pname) {
        T[N] data;
        getTexLevelParamFunction!(T)(target, level, pname, data.ptr);
        return data;
    }

    private template getTexLevelParamFunction(T) {
        static if (is(T == int))
            alias getTexLevelParamFunction = glGetTexLevelParameteriv;
        else static if (is(T == float))
            alias getTexLevelParamFunction = glGetTexLevelParameterfv;
    }

    void setPatchParameter(PatchParamName param, int value) {
        glPatchParameteri(param, value);
    }

    void setPatchParameter(size_t N)(PatchParamName param, float[N] value) {
        glPatchParameterfv(param, value.ptr);
    }

    void uniform(T, size_t N)(UniformLoc loc, uint num, T* ptr) 
        if (1 <= N && N <= 4)
    {
        import std.format;
        mixin(format!"glUniform%d%sv"(N, getUniformTypeCharacter!(T)))(loc, num, ptr);
    }

    void uniformMatrix(T, size_t N)(UniformLoc loc, uint num, T* ptr) 
        if (1 <= N && N <= 4)
    {
        import std.format;
        mixin(format!"glUniformMatrix%d%sv"(N, getUniformTypeCharacter!(T)))(loc, num, false, ptr);
    }

    import std.traits : Unqual;
    private template getUniformTypeCharacter(T, S = Unqual!T) 
        if (is(S == bool) || is(S == uint) || is(S == int) || is(S == float))
    {
        static if (is(S == bool)) {
            enum getUniformTypeCharacter = "i";
        } else static if (is(S == int)) {
            enum getUniformTypeCharacter = "i";
        } else static if (is(S == uint)) {
            enum getUniformTypeCharacter = "ui";
        } else static if (is(S == float)) {
            enum getUniformTypeCharacter = "f";
        } else {
            static assert(false);
        }
    }
}

struct GlUtils {

    template getTypeEnum(T) {
        static if (is(T == ubyte)) enum GLType getTypeEnum = GLType.Ubyte;
        else static if (is(T == byte)) enum GLType getTypeEnum = GLType.Byte;
        else static if (is(T == ushort)) enum GLType getTypeEnum = GLType.Ushort;
        else static if (is(T == short)) enum GLType getTypeEnum = GLType.Short;
        else static if (is(T == uint)) enum GLType getTypeEnum = GLType.Uint;
        else static if (is(T == int)) enum GLType getTypeEnum = GLType.Int;
        else static if (is(T == float)) enum GLType getTypeEnum = GLType.Float;
        else static if (is(T == double)) enum GLType getTypeEnum = GLType.Double;
        else static assert(false, T.stringof ~ " is an invalid type.");
    }

    void clear(BufferBit[] mode...) {
        import std.algorithm : canFind;

        if (mode.canFind(ClearMode.Color)) colorWrite(true);  //cannot clear without it
        if (mode.canFind(ClearMode.Depth)) depthWrite(true); 
        if (mode.canFind(ClearMode.Stencil)) stencilWrite(true); 

        GlFunction().clear(mode);
    }

    void clearColor(float[4] color) {
        GlFunction().clearColor(color[0], color[1], color[2], color[3]);
    }

    void colorWrite(bool write) {
        GlFunction().colorMask(write, write, write, write);
    }

    void depthWrite(bool write) {
        GlFunction().depthMask(write);
    }

    void stencilWrite(bool write) {
        GlFunction().stencilMask(write ? uint.max : 0);
    }

    void depthTest(bool depthTest) {
        if (depthTest) {
            GlFunction().enable(Capability.DepthTest);
        } else {
            GlFunction().disable(Capability.DepthTest);
        }
    }

    void blend(bool blend) {
        if (blend) {
            GlFunction().enable(Capability.Blend);
        } else {
            GlFunction().disable(Capability.Blend);
        }
    }

    void faceSetting(PolygonMode polygon, FaceMode face = FaceMode.FrontBack) {
        if (polygon == PolygonMode.None) {
            assert(face == FaceMode.FrontBack);
            GlFunction().enable(Capability.CullFace);
            GlFunction().cullFace(FaceMode.FrontBack);
        } else {
            final switch (face) {
            case FaceMode.FrontBack:
                //glDisable(Capability.CullFace);
                GlFunction().polygonMode(FaceMode.FrontBack, polygon);
                break;
            case FaceMode.Front:
                GlFunction().enable(Capability.CullFace);
                GlFunction().cullFace(FaceMode.Back);
                GlFunction().polygonMode(FaceMode.FrontBack, polygon);
                break;
            case FaceMode.Back:
                GlFunction().enable(Capability.CullFace);
                GlFunction().cullFace(FaceMode.Front);
                GlFunction().polygonMode(FaceMode.FrontBack, polygon);
                break;
            }
        }
    }


    void stencil(TestFunc test, int reffer, uint mask, StencilWrite sfail, StencilWrite dpfail, StencilWrite pass) {
        GlFunction().enable(Capability.StencilTest);
        GlFunction().stencilFunc(test, reffer, mask);
        GlFunction().stencilOp(sfail, dpfail, pass);
    }

    int getBitPerPixel(TextureInternalFormat iformat) {
        final switch (iformat) {
            case TextureInternalFormat.R8I:
            case TextureInternalFormat.R8UI:
            case TextureInternalFormat.RG8I:
            case TextureInternalFormat.RG8UI:
            case TextureInternalFormat.RGB8I:
            case TextureInternalFormat.RGB8UI:
            case TextureInternalFormat.RGBA8I:
            case TextureInternalFormat.RGBA8UI:
                return 8;
            case TextureInternalFormat.R16I:
            case TextureInternalFormat.R16UI:
            case TextureInternalFormat.R16F:
            case TextureInternalFormat.RG16I:
            case TextureInternalFormat.RG16UI:
            case TextureInternalFormat.RG16F:
            case TextureInternalFormat.RGB16I:
            case TextureInternalFormat.RGB16UI:
            case TextureInternalFormat.RGB16F:
            case TextureInternalFormat.RGBA16I:
            case TextureInternalFormat.RGBA16UI:
            case TextureInternalFormat.RGBA16F:
                return 16;
            case TextureInternalFormat.R:
            case TextureInternalFormat.R32I:
            case TextureInternalFormat.R32UI:
            case TextureInternalFormat.R32F:
            case TextureInternalFormat.RG:
            case TextureInternalFormat.RG32I:
            case TextureInternalFormat.RG32UI:
            case TextureInternalFormat.RG32F:
            case TextureInternalFormat.RGB:
            case TextureInternalFormat.RGB32I:
            case TextureInternalFormat.RGB32UI:
            case TextureInternalFormat.RGB32F:
            case TextureInternalFormat.RGBA:
            case TextureInternalFormat.RGBA32I:
            case TextureInternalFormat.RGBA32UI:
            case TextureInternalFormat.RGBA32F:
                return 32;
            case TextureInternalFormat.Depth:
                return 24;
            case TextureInternalFormat.Stencil:
                assert(false); // I don't know \(^^)/
            case TextureInternalFormat.DepthStencil:
                assert(false); // I don't know \(^^)/
        }
        assert(false);
    }

    float[2] getAliasedLineWidthRange() {
        return GlFunction().get!(float, 2)(ParamName.AliasedLineWidthRange);
    }

    float[2] getSmoothLineWidthRange() {
        return GlFunction().get!(float, 2)(ParamName.SmoothLineWidthRange);
    }

    int[4] getViewport() {
        return GlFunction().get!(int, 4)(ParamName.Viewport);
    }

    int getMaxFramebufferWidth() {
        return GlFunction().get!(int, 1)(ParamName.MaxFramebufferWidth)[0];
    }

    int getMaxFramebufferHeight() {
        return GlFunction().get!(int, 1)(ParamName.MaxFramebufferHeight)[0];
    }

    BufferID genBuffer() {
        uint result;
        GlFunction().genBuffers(1, &result);
        return result;
    }

    void deleteBuffer(BufferID id) {
        GlFunction().deleteBuffers(1, &id);
    }

    FramebufferID genFramebuffer() {
        uint result;
        GlFunction().genFramebuffers(1, &result);
        return result;
    }

    void deleteFramebuffer(FramebufferID id) {
        GlFunction().deleteFramebuffers(1, &id);
    }

    RenderbufferID genRenderbuffer() {
        uint result;
        GlFunction().genRenderbuffers(1, &result);
        return result;
    }

    void deleteRenderbuffer(RenderbufferID id) {
        GlFunction().deleteRenderbuffers(1, &id);
    }

    TextureID genTexture() {
        uint result;
        GlFunction().genTextures(1, &result);
        return result;
    }

    void deleteTexture(TextureID id) {
        GlFunction().deleteTextures(1, &id);
    }

    VertexArrayID genVertexArray() {
        uint result;
        GlFunction().genVertexArrays(1, &result);
        return result;
    }

    void deleteVertexArray(VertexArrayID id) {
        GlFunction().deleteVertexArray(1, &id);
    }

    void shaderSource(ShaderID id, string source) {
        import std.string : toStringz;
        auto str = source.toStringz;
        GlFunction().shaderSource(id, 1, cast(char**)&str, null);
    }

    void uniform(T)(UniformLoc loc, T data) 
        if (isBasicType!T)
    {
        import std.traits : Unqual;
        static if (is(Unqual!T == bool)) {
            int d = data;
        } else {
            auto d = data;
        }
        GlFunction().uniform!(typeof(d), 1)(loc, 1, &d);
    }

    void uniform(T, size_t N)(UniformLoc loc, T[N] data) {
        GlFunction().uniform!(T, N)(loc, 1, data.ptr);
    }

    void uniformMatrix(T, size_t N, size_t M = N*N)(UniformLoc loc, T[M] data) {
        GlFunction().uniformMatrix!(T, N)(loc, 1, data.ptr);
    }

    FramebufferAttachType getFramebufferColorAttachType(size_t n) {
        final switch (n) {
            case 0: return FramebufferAttachType.Color0;
            case 1: return FramebufferAttachType.Color1;
            case 2: return FramebufferAttachType.Color2;
        }
    }

    bool isColorAttachType(FramebufferAttachType type) {
        switch (type) {
            case FramebufferAttachType.Color0:
            case FramebufferAttachType.Color1:
            case FramebufferAttachType.Color2:
                return true;
            default:
                return false;
        }
    }

    size_t getColorAttachTypeIndex(FramebufferAttachType type) 
        in(isColorAttachType(type))
    {
        switch (type) {
            case FramebufferAttachType.Color0:
                return 0;
            case FramebufferAttachType.Color1:
                return 1;
            case FramebufferAttachType.Color2:
                return 2;
            default:
                assert(false);
        }
    }

    void checkFramebufferStatus(FramebufferBindType type) {
        import std.conv : to;
        const status = GlFunction().checkFramebufferStatus(type);
        assert(status == FramebufferStatus.Complete, status.to!string);
    }
}
