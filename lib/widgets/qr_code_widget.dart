import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;

  const QRCodeWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: QRCodePainter(data),
    );
  }
}

class QRCodePainter extends CustomPainter {
  final String data;

  QRCodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final moduleSize = size.width / 25;

    final pattern = _generateQRPattern();

    for (int i = 0; i < pattern.length; i++) {
      for (int j = 0; j < pattern[i].length; j++) {
        if (pattern[i][j]) {
          canvas.drawRect(
            Rect.fromLTWH(
              j * moduleSize,
              i * moduleSize,
              moduleSize,
              moduleSize,
            ),
            paint,
          );
        }
      }
    }
  }

  List<List<bool>> _generateQRPattern() {
    final size = 25;
    final pattern = List.generate(size, (_) => List.filled(size, false));

    _addFinderPattern(pattern, 0, 0);
    _addFinderPattern(pattern, 0, size - 7);
    _addFinderPattern(pattern, size - 7, 0);

    _addTimingPatterns(pattern, size);

    final hash = data.hashCode.abs();
    for (int i = 9; i < size - 9; i++) {
      for (int j = 9; j < size - 9; j++) {
        pattern[i][j] = ((hash >> ((i + j) % 20)) & 1) == 1;
      }
    }

    return pattern;
  }

  void _addFinderPattern(List<List<bool>> pattern, int row, int col) {
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 7; j++) {
        if (i == 0 || i == 6 || j == 0 || j == 6 || (i >= 2 && i <= 4 && j >= 2 && j <= 4)) {
          pattern[row + i][col + j] = true;
        }
      }
    }
  }

  void _addTimingPatterns(List<List<bool>> pattern, int size) {
    for (int i = 8; i < size - 8; i++) {
      pattern[6][i] = i % 2 == 0;
      pattern[i][6] = i % 2 == 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}