import 'package:budgets/presentation/core/stats/stats_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrailingPieChart extends StatefulWidget {
  final List<PieData> data;
  const TrailingPieChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TrailingPieChart> createState() => _TrailingPieChartState();
}

class _TrailingPieChartState extends State<TrailingPieChart>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late int touchedIndex = -1;

  double sectionAnimation = 0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCirc,
    )..addListener(() {
        setState(() {
          sectionAnimation = _animation.value;
        });
      });
    triggerAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TrailingPieChart old) {
    triggerAnimation();

    super.didUpdateWidget(old);
  }

  void triggerAnimation() {
    _animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> getSections(
      List<PieData> data,
    ) {
      return data
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            final value = PieChartSectionData(
              color: Color(data.color),
              value: data.percent,
              title: '',
              radius: 10,
            );
            return MapEntry(index, value);
          })
          .values
          .toList()
        ..add(
          PieChartSectionData(
            value: -(sectionAnimation - 1) * 1,
            title: '',
            color: Colors.transparent,
          ),
        );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 15,
        sections: getSections(widget.data),
      ),
    );
  }
}
