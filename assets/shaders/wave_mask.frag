#version 460 core

#include <flutter/runtime_effect.glsl>

#define PI 3.1415926535

precision mediump float;

uniform vec2 res;
uniform float offset;
uniform float waveHeight; // from 0 to 1
uniform float waveLength;
uniform float waveAmplitude;
uniform float angle;
uniform float waveOffset;
uniform float negative;

out vec4 fragColor;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float wave(float x) {
  return sin(x / waveLength + 2 * PI * waveOffset) * waveAmplitude + (1 - waveHeight) * res.y;
}

vec4 shade() {
  vec2 pos = FlutterFragCoord().xy;
  pos.y -= offset;
  
  // Rotate coordinates
  mat2x2 rot = mat2x2(cos(angle), -sin(angle),
  sin(angle), cos(angle));

  pos *= rot;
  vec2 st = pos / res.xy;

  // Basic sine wave
  float waveStart = wave(pos.x);
  if (pos.y < waveStart) {
    float s = clamp(map(pos.y, waveStart - 1, waveStart, 0, 1), 0, 1);

    return vec4(1, 1, 1, 1) * s;
  }

  return vec4(1, 1, 1, 1);
}


void main() {
  vec4 result = shade();

  if (negative > 0) {
    result = vec4(1,1,1,1) - result;
  }


  fragColor = result;
}