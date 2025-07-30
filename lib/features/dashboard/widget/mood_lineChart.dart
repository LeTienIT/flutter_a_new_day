import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/dashboard.dart';

class MoodLineChart extends StatelessWidget {
  final List<MoodEnergyPoint> data;

  const MoodLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Không có dữ liệu tâm trạng"));
    }

    final spots = List.generate(
      data.length,
          (index) => FlSpot(index.toDouble(), data[index].nangLuong.toDouble()),
    );

    return AspectRatio(
      aspectRatio: 1.8,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.orange,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return ImageDotPainter(
                      imagePath: data[index].emojiPath,
                      size: 18,
                    );
                  },
                ),
              )
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 30,
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= data.length) return const SizedBox.shrink();
                    final date = data[index].date;
                    return Text(DateFormat('dd/MM').format(date), style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(
              show: true,
              border: const Border.symmetric(
                vertical: BorderSide(),
                horizontal: BorderSide(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageDotPainter extends FlDotPainter {
  final String imagePath;
  final double size;

  ImageDotPainter({
    required this.imagePath,
    this.size = 4,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final image = AssetImage(imagePath);
    final imageStream = image.resolve(ImageConfiguration.empty);

    imageStream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      final paint = Paint();
      final srcSize = Size(info.image.width.toDouble(), info.image.height.toDouble());
      final dstSize = Size(size, size);

      // Calculate the rectangle to draw the image
      final src = Rect.fromLTWH(0, 0, srcSize.width, srcSize.height);
      final dst = Rect.fromCenter(
        center: offsetInCanvas,
        width: dstSize.width,
        height: dstSize.height,
      );

      // Draw the image
      canvas.drawImageRect(info.image, src, dst, paint);
    }));
  }

  @override
  Size getSize(FlSpot spot) => Size(size, size);

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  // TODO: implement mainColor
  Color get mainColor => throw UnimplementedError();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}