import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aplication/controllers/stats.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final StatsController _statsController = StatsController();
  Map<String, Map<String, int>> _accessStats = {};
  int? _touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    Map<String, Map<String, int>> stats =
        await _statsController.getAccessStats();
    setState(() {
      _accessStats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body:
          _accessStats.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _generateBarGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final dates = _accessStats.keys.toList();
                            if (index < 0 || index >= dates.length) {
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                dates[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          },
                          reservedSize: 32,
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (_touchedGroupIndex != groupIndex) return null;

                          String date = _accessStats.keys.elementAt(groupIndex);
                          String username = _accessStats[date]!.keys.elementAt(
                            rodIndex,
                          );
                          return BarTooltipItem(
                            "$username\n${rod.toY.toInt()} accesos",
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            _touchedGroupIndex = null;
                          } else {
                            _touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> groups = [];
    List<String> dates = _accessStats.keys.toList();

    for (int i = 0; i < dates.length; i++) {
      String date = dates[i];
      Map<String, int> users = _accessStats[date]!;

      List<BarChartRodData> bars = [];
      int j = 0;
      for (var entry in users.entries) {
        bars.add(
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.primaries[j % Colors.primaries.length],
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        );
        j++;
      }

      groups.add(BarChartGroupData(x: i, barRods: bars));
    }

    return groups;
  }
}
