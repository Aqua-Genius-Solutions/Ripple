import 'dart:math';
import 'package:flutter/material.dart';

class WaterWavePainter extends CustomPainter {
  final double waveAmplitude;
  final double waveFrequency;
  final double wavePhase;
  final Color waveColor;

  WaterWavePainter({
    required this.waveAmplitude,
    required this.waveFrequency,
    required this.wavePhase,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    Path wavePath = Path();

    wavePath.moveTo(0, size.height * 0.23);
    for (int x = 0; x < size.width; x++) {
      wavePath.lineTo(
        x.toDouble(),
        size.height * 0.5 +
            waveAmplitude *
                sin((x * waveFrequency) + (wavePhase * pi)),
      );
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(WaterWavePainter oldDelegate) => oldDelegate.wavePhase != wavePhase;
}