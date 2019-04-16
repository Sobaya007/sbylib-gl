module sbylib.wrapper.gl.framebuffer;

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;

public import sbylib.wrapper.gl.texture : Texture;
public import sbylib.wrapper.gl.renderbuffer : Renderbuffer;

auto DefaultFramebuffer() {
    static Framebuffer fb;
    if (fb is null) fb= new Framebuffer(true);
    return fb;
}

class Framebuffer {

    immutable int id;

    private this(bool b) {
        this.id = 0;
    }

    this() {
        this.id = GlUtils.genFramebuffer();
    }

    void destroy() const {
        GlUtils.deleteFramebuffer(id);
    }

    void bind(FramebufferBindType type) const {
        GlFunction.bindFramebuffer(type, id);
    }

    void unbind(FramebufferBindType type) const {
        GlFunction.bindFramebuffer(type, 0);
    }

    void setReadBuffer(FramebufferAttachType type) const {
        bind(FramebufferBindType.Read);
        scope (exit) unbind(FramebufferBindType.Read);
        GlFunction.readBuffer(type);
    }

    void setDrawBuffer(FramebufferAttachType type) const {
        bind(FramebufferBindType.Write);
        scope (exit) unbind(FramebufferBindType.Write);
        GlFunction.drawBuffer(type);
    }

    void attach(Texture texture, uint level, FramebufferAttachType attachType) 
        in (texture !is null)
    {
        this.bind(FramebufferBindType.Both);
        scope (exit) unbind(FramebufferBindType.Both);
        texture.bind();
        GlFunction.framebufferTexture2D(FramebufferBindType.Both, attachType, texture.target, texture.id, level);
    }

    void attach(Renderbuffer renderbuffer, FramebufferAttachType attachType) {
        this.bind(FramebufferBindType.Both);
        scope (exit) unbind(FramebufferBindType.Both);
        renderbuffer.bind();
        GlFunction.framebufferRenderbuffer(FramebufferBindType.Both, attachType, renderbuffer.id);
    }

    void blitsTo(const Framebuffer dst,
            int srcX0, int srcY0, int srcX1, int srcY1, 
            int dstX0, int dstY0, int dstX1, int dstY1,
            TextureFilter filter, BufferBit[] bit...) const
    in {
        import std.algorithm : canFind;
        if (bit.canFind(BufferBit.Depth) || bit.canFind(BufferBit.Stencil)) {
            assert(filter == TextureFilter.Nearest);
        }
    }
    do {
        this.bind(FramebufferBindType.Write);
        scope (exit) this.unbind(FramebufferBindType.Write);
        dst.bind(FramebufferBindType.Read);
        scope (exit) dst.unbind(FramebufferBindType.Read);
        GlFunction.blitFramebuffer(
                srcX0, srcY0, srcX1, srcY1,
                dstX0, dstY0, dstX1, dstY1,
                filter, bit);
    }
}
