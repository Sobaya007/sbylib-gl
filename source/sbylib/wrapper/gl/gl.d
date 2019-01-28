module sbylib.wrapper.gl.gl;

import derelict.opengl;

class GL {

static:
    
    package GLVersion glVersion;

    void initialize() {
        DerelictGL3.load();
        glVersion = DerelictGL3.reload();
    }

    int getShaderVersion()
    in(glVersion >= GLVersion.gl20)
    {
        switch(glVersion) {
            case GLVersion.gl20:
                return 110;
            case GLVersion.gl21:
                return 120;
            case GLVersion.gl30:
                return 130;
            case GLVersion.gl31:
                return 140;
            case GLVersion.gl32:
                return 150;
            default:
                return glVersion * 10;
        }
    }
}
