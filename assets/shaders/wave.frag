#version 460 core

#include <flutter/runtime_effect.glsl>

#define PI 3.1415926535

precision mediump float;

uniform vec2 res;
uniform float waveHeight; // from 0 to 1
uniform float waveLength;
uniform float waveAmplitude;
uniform float quirk; // 0 to 1
uniform float flickersSpacing;
uniform vec3 color;
uniform vec3 flickerColor;

out vec4 fragColor;

float wave(float x) {
  return sin(x / waveLength + 1000 * quirk) * waveAmplitude + (1 - waveHeight) * res.y;
}

vec4 shade() {
  vec2 pos = FlutterFragCoord().xy;

  // Rotate coordinates
  float angle = PI * 0.01 * sin(quirk * 1000);
  mat2x2 rot = mat2x2(cos(angle), -sin(angle),
  sin(angle), cos(angle));

  pos *= rot;

  // Basic sine wave
  float blue = wave(pos.x);
  if (pos.y < blue) {
    return vec4(0,0,0,0);
  }
  float flicker = mod(pos.y - blue, flickersSpacing);
  if (flicker < 1) {
    return vec4(flickerColor.r, flickerColor.g, flickerColor.b, 1);
  }
  return vec4(color.r, color.g, color.b, 1);
}


void main() {
  fragColor = shade();
}