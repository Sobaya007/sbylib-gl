module sbylib.wrapper.gl.vertexarray;

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions;

class VertexArray {

    private immutable VertexArrayID id;

    this() {
        this.id = GlUtils().genVertexArray();
    }

    void destroy() {
        GlUtils().deleteVertexArray(id);
    }

    void enable(AttribLoc location) {
        bind();
        GlFunction().enableVertexAttribArray(location);
    }

    void disable(AttribLoc location) {
        bind();
        GlFunction().disableVertexAttribArray(location);
    }

    void bind() const {
        GlFunction().bindVertexArray(id);
    }
}
