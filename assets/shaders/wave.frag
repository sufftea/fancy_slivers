#version 460 core

#include <flutter/runtime_effect.glsl>

// #define PI 3.1415926535

precision mediump float;

uniform vec2 res;
uniform float waveHeight; // from 0 to 1
// uniform float waveTilt; // from -1 to 1
uniform float time;
uniform vec3 color;

out vec4 fragColor;

const float waveLength = 20;
const float waveAmplitude = 15;

vec4 shade() {
  vec2 pos = FlutterFragCoord().xy;

  float blue = sin(pos.x / waveLength + time) * waveAmplitude + (1 - waveHeight) * res.y;

  if (pos.y > blue) {
    return vec4(color.r, color.g, color.b, 1);
  }

  return vec4(0,0,0,0);
}


void main() {
  fragColor = shade();
}