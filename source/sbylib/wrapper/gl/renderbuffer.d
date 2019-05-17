module sbylib.wrapper.gl.renderbuffer; 

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;

class Renderbuffer {

    package immutable int id;

    this() {
        this.id = GlUtils().genRenderbuffer();
    }

    this(uint width, uint height, TextureInternalFormat format) {
        this();
        this.allocate(width, height, format);
    }

    void destroy() {
        GlUtils().deleteRenderbuffer(id);
    }

    void bind() {
        GlFunction().bindRenderbuffer(this.id);
    }

    void allocate(uint width, uint height, TextureInternalFormat format) {
        bind();
        GlFunction().renderbufferStorage(width, height, format);
    }

    void attachFramebuffer(FramebufferBindType bindType, FramebufferAttachType attachType) {
        bind();
        GlFunction().framebufferRenderbuffer(bindType, attachType, this.id);
    }

    void detachFramebuffer(FramebufferBindType bindType, FramebufferAttachType attachType) {
        bind();
        GlFunction().framebufferRenderbuffer(bindType, attachType, 0);
    }
}
