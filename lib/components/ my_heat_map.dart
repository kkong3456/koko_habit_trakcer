import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return HeatMap(colorsets: {
      1: Colors.green.shade200,
      2: Colors.green.shade300,
      3: Colors.green.shade400,
      4: Colors.green.shade500,
      5: Colors.green.shade600,
    });
  }
}
