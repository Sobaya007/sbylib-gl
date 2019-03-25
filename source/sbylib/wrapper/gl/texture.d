module sbylib.wrapper.gl.texture;

import derelict.opengl;

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;
import std.conv : to;

struct TextureBuilder {

    TextureTarget target = TextureTarget.Tex2D;
    uint mipmapLevel = 0;
    TextureInternalFormat iformat = TextureInternalFormat.RGBA;
    TextureFormat format = TextureFormat.RGBA;
    uint width, height;
    uint unpackAlign = 4;

    Texture build(Type)(Type[] data) {
        GlFunction.setPixelUnpackAlign(unpackAlign);
        return new Texture(this.target, this.mipmapLevel, this.iformat, width, height, this.format, data.ptr);
    }

    Texture build(Type)() {
        return build((Type[]).init);
    }

    Texture build() {
        return build!ubyte;
    }
}

class Texture {

    package immutable TextureID id;
    immutable TextureTarget target;

    static void activate(uint unit) {
        GlFunction.activeTexture(unit);
    }

    this(TextureTarget target) {
        this.id = GlUtils.genTexture();
        this.target = target;
        this.magFilter = TextureFilter.Linear;
        this.minFilter = TextureFilter.Linear;
        this.wrapS = TextureWrap.Repeat;
        this.wrapT = TextureWrap.Repeat;
    }

    this(Type)(TextureTarget target, uint mipmapLevel, TextureInternalFormat iformat, uint width, uint height, TextureFormat format, Type* data) {
        this(target);
        allocate(mipmapLevel, iformat, width, height, format, data);
    }

    void destroy() {
        GlUtils.deleteTexture(id);
    }

    void allocate(Type)(uint mipmapLevel, TextureInternalFormat iformat,
            uint width, uint height, TextureFormat format, Type* data) 
    in(this.target != TextureTarget.Rect || mipmapLevel == 0)
    in(this.target != TextureTarget.ProxyRect || mipmapLevel == 0)
    {
        bind();
        GlFunction.texImage2D!(Type)(this.target, mipmapLevel, iformat, width, height, 0, format, data);
    }

    void update(Type)(uint mipmapLevel, Type *data) {
        update(mipmapLevel, 0, 0, this.width, this.height, this.format, data);
    }

    void update(Type)(uint mipmapLevel, int offsetX, int offsetY, uint width, uint height, TextureFormat format, Type *data) {
        bind();
        GlFunction.texSubImage2D!(Type)(this.target, mipmapLevel, offsetX, offsetY, width, height, format, data);
    }

    int width() {
        return getParameter!(int,1)(TextureLevelParamName.Width)[0];
    }

    int height() {
        return getParameter!(int,1)(TextureLevelParamName.Height)[0];
    }

    int depth() {
        return getParameter!(int,1)(TextureLevelParamName.Depth)[0];
    }

    TextureInternalFormat internalFormat() {
        return getParameter!(int,1)(TextureLevelParamName.InternalFormat)[0].to!(TextureInternalFormat);
    }

    TextureFilter magFilter() {
        return getParameter!(int,1)(TextureParamName.MagFilter)[0].to!(TextureFilter);
    }

    TextureFilter magFilter(TextureFilter type) {
        setParameter!(int)(TextureParamName.MagFilter, type);
        return type;
    }

    TextureFilter minFilter() {
        return getParameter!(int,1)(TextureParamName.MinFilter)[0].to!(TextureFilter);
    }

    TextureFilter minFilter(TextureFilter type) {
        setParameter!(int)(TextureParamName.MinFilter, type);
        return type;
    }

    TextureWrap wrapS() {
        return getParameter!(int,1)(TextureParamName.WrapS)[0].to!(TextureWrap);
    }

    TextureWrap wrapS(TextureWrap type) {
        setParameter!(int)(TextureParamName.WrapS, type);
        return type;
    }

    TextureWrap wrapT() {
        return getParameter!(int,1)(TextureParamName.WrapT)[0].to!(TextureWrap);
    }

    TextureWrap wrapT(TextureWrap type) {
        setParameter!(int)(TextureParamName.WrapT, type);
        return type;
    }

    TextureWrap wrapR() {
        return getParameter!(int,1)(TextureParamName.WrapR)[0].to!(TextureWrap);
    }

    TextureWrap wrapR(TextureWrap type) {
        setParameter!(int)(TextureParamName.WrapR, type);
        return type;
    }

    DepthStencilMode depthStencilMode() {
        return getParameter!(int,1)(TextureParamName.DepthStencilMode)[0].to!(DepthStencilMode);
    }

    DepthStencilMode depthStencilMode(DepthStencilMode mode) {
        setParameter!(int)(TextureParamName.DepthStencilMode, mode);
        return mode;
    }

    void blitsTo(T)(T[] result, TextureFormat format, int level = 0) {
        bind();
        GlFunction.getTexImage!(T)(target, level, format, result.ptr);
    }

    void bind() const {
        GlFunction.bindTexture(target, id);
    }

    void bindForCompute(TextureUnit unit, uint level, uint layer, BufferAccess access, TextureInternalFormat iformat) {
        GlFunction.bindImageTexture(unit, id, level, GL_FALSE, layer, access, iformat);
    }

    void bindForCompute(TextureUnit unit, uint level, BufferAccess access, TextureInternalFormat iformat) {
        GlFunction.bindImageTexture(unit, id, level, GL_TRUE, 0, access, iformat);
    }

    private T[N] getParameter(T,size_t N)(TextureLevelParamName pname) {
        bind();
        return GlFunction.getTexLevelParameter!(T,N)(target, 0, pname);
    }

    private T[N] getParameter(T,size_t N)(TextureParamName pname) {
        bind();
        return GlFunction.getTexParameter!(T,N)(target, pname);
    }

    private void setParameter(T)(TextureParamName pname, T value) {
        bind();
        GlFunction.setTexParameter!(T)(target, pname, value);
    }
}
