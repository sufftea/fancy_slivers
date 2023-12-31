#version 460 core

#include <flutter/runtime_effect.glsl>

#define PI 3.1415926535

precision mediump float;

uniform vec2 res;
uniform float waveHeight; // from 0 to 1
uniform float waveLength;
uniform float waveAmplitude;
uniform float opacity;
uniform float angle;
uniform float offset;
uniform vec3 color;

out vec4 fragColor;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float wave(float x) {
  return sin(x / waveLength + 2 * PI * offset) * waveAmplitude + (1 - waveHeight) * res.y;
}

vec4 shade() {
  vec2 pos = FlutterFragCoord().xy;

  // Rotate coordinates
  mat2x2 rot = mat2x2(cos(angle), -sin(angle),
  sin(angle), cos(angle));

  pos *= rot;

  // Basic sine wave
  float waveStart = wave(pos.x);
  if (pos.y < waveStart) {
    float s = clamp(map(pos.y, waveStart - 1, waveStart, 0, 1), 0, 1);

    return vec4(color.r, color.g, color.b, 1) * s * opacity;
  }

  return vec4(color.r, color.g, color.b, 1) * opacity;
}


void main() {
  fragColor = shade();
}