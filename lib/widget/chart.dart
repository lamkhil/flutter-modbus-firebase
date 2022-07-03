import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPLN extends StatefulWidget {
  const ChartPLN({Key? key}) : super(key: key);

  @override
  _ChartPLNState createState() => _ChartPLNState();
}

class _ChartPLNState extends State<ChartPLN> {
  List<Color> gradientColors = [
    Colors.blue,
    Colors.yellow,
  ];

  double max = 0;
  double min = 0;
  List<FlSpot> spots = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('output/sensor/teganganPLN')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.snapshot.value != null) {
                        var value = (snapshot.data!.snapshot.value as Map)
                            .keys
                            .toList()
                          ..sort((a, b) => a.compareTo(b));
                        spots = List.generate(
                            (snapshot.data!.snapshot.value as Map)
                                .values
                                .length,
                            (index) => FlSpot(
                                index.toDouble(),
                                (snapshot.data!.snapshot.value
                                    as Map)[value[index]] as double));
                        for (var element in spots) {
                          if (element.y > max) {
                            max = element.y;
                          }
                          if (element.y < min) {
                            min = element.y;
                          }
                        }
                        var storeSpots = <FlSpot>[];
                        if (spots.length > 16) {
                          storeSpots = spots
                              .getRange(spots.length - 16, spots.length)
                              .toList();
                          for (var i = 0; i < 16; i++) {
                            storeSpots[i] = FlSpot(i.toDouble(), spots[i].y);
                          }
                        } else {
                          storeSpots = spots;
                        }
                        return Column(
                          children: [
                            Text(
                              "Grafik Tegangan PLN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: LineChart(
                                mainData(spots: storeSpots, max: max, min: min),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.only(left: 12),
          child: Text('Volt'),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    if (spots.last.x > 17) {
      var a =
          List.generate(17, (index) => {(17 - index): (spots.last.x - index)});

      for (var element in a) {
        if (value.toInt() == element.keys.first) {
          return Text((element[value.toInt()])!.toInt().toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    } else {
      var a = List.generate(17, (index) => index + 1);

      for (var element in a) {
        if (value.toInt() == element) {
          return Text(element.toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    }

    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    var a = List.generate(501, (index) => min.toInt() + index);
    for (var element in a) {
      if (element.toInt() % (max > 100 ? 25 : 5) == 0) {
        if (value.toInt() == element) {
          return Text(element.toInt().toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    }

    return Container();
  }

  LineChartData mainData(
      {required List<FlSpot>? spots,
      required double max,
      required double min}) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: max > 100 ? 25 : 4,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 16,
      minY: min,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}

class ChartPLTS extends StatefulWidget {
  const ChartPLTS({Key? key}) : super(key: key);

  @override
  _ChartPLTSState createState() => _ChartPLTSState();
}

class _ChartPLTSState extends State<ChartPLTS> {
  List<Color> gradientColors = [
    Colors.blue,
    Colors.yellow,
  ];

  double max = 0;
  double min = 0;
  List<FlSpot> spots = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('output/sensor/teganganPLTS')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.snapshot.value != null) {
                        var value = (snapshot.data!.snapshot.value as Map)
                            .keys
                            .toList()
                          ..sort((a, b) => a.compareTo(b));
                        spots = List.generate(
                            (snapshot.data!.snapshot.value as Map)
                                .values
                                .length,
                            (index) => FlSpot(
                                index.toDouble(),
                                (snapshot.data!.snapshot.value
                                    as Map)[value[index]] as double));
                        for (var element in spots) {
                          if (element.y > max) {
                            max = element.y;
                          }
                          if (element.y < min) {
                            min = element.y;
                          }
                        }
                        var storeSpots = <FlSpot>[];
                        if (spots.length > 16) {
                          storeSpots = spots
                              .getRange(spots.length - 16, spots.length)
                              .toList();
                          for (var i = 0; i < 16; i++) {
                            storeSpots[i] = FlSpot(i.toDouble(), spots[i].y);
                          }
                        } else {
                          storeSpots = spots;
                        }
                        return Column(
                          children: [
                            Text(
                              "Grafik Tegangan PLTS",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: LineChart(
                                mainData(spots: storeSpots, max: max, min: min),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.only(left: 12),
          child: Text('Volt'),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    if (spots.last.x > 17) {
      var a =
          List.generate(17, (index) => {(17 - index): (spots.last.x - index)});

      for (var element in a) {
        if (value.toInt() == element.keys.first) {
          return Text((element[value.toInt()])!.toInt().toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    } else {
      var a = List.generate(17, (index) => index + 1);

      for (var element in a) {
        if (value.toInt() == element) {
          return Text(element.toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    }

    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    var a = List.generate(501, (index) => min.toInt() + index);
    for (var element in a) {
      if (element.toInt() %
              (max > 100
                  ? 25
                  : max > 50
                      ? 5
                      : 3) ==
          0) {
        if (value.toInt() == element) {
          return Text(element.toInt().toString(),
              style: style, textAlign: TextAlign.left);
        }
      }
    }

    return Container();
  }

  LineChartData mainData(
      {required List<FlSpot>? spots,
      required double max,
      required double min}) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: max > 100 ? 25 : 4,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 16,
      minY: min,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
