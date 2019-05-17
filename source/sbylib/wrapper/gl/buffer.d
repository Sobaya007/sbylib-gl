module sbylib.wrapper.gl.buffer;

import sbylib.wrapper.gl.constants;
import sbylib.wrapper.gl.functions : GlFunction, GlUtils;

import std.algorithm : among;
import std.traits : isArray;

class Buffer(T) {

    private immutable BufferID id;

    this() {
        this.id = GlUtils().genBuffer();
    }

    void destroy() const {
        GlUtils().deleteBuffer(id);
    }

    void allocate(size_t len, BufferTarget target, BufferUsage usage = BufferUsage.Static) const {
        this.bind(target);
        GlFunction().bufferData!(T)(target, len * T.sizeof, null, usage);
    }
    
    void sendData(const T[] data, BufferTarget target, BufferUsage usage = BufferUsage.Static) const {
        this.bind(target);
        GlFunction().bufferData!(T)(target, data.length * T.sizeof, data.ptr, usage);
    }

    void sendSubData(T[] data, BufferTarget target, int offset = 0) const {
        this.bind(target);
        GlFunction().bufferSubData!(T)(target, offset, data.length * T.sizeof, data.ptr);
    }

    T* map(BufferTarget type, BufferAccess access) const {
        bind(type);
        auto res = GlFunction().mapBuffer(type, access);
        return cast(T*)res;
    }

    void unmap(BufferTarget type) const {
        bind(type);
        GlFunction().unmapBuffer(type);
    }

    void getSubData(T[] data, BufferTarget target, long offset, long size) const 
        in (offset + size <= data.length)
    {
        bind(target);
        GlFunction().getBufferSubData(target, offset, size, data.ptr);
    }

    void bind(BufferTarget target) const {
        GlFunction().bindBuffer(target, id);
    }

    void bindBase(BufferTarget target, uint bindingPoint) const {
        GlFunction().bindBufferBase(target, bindingPoint, id);
    }
}
