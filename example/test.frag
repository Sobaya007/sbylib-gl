#version 400

in vec2 uv;
out vec4 color;

void main() {
    color = vec4(uv, 1, 1);
}
