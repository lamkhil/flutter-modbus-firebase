import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modbus/widget/chart.dart';

class Ats extends StatefulWidget {
  const Ats({Key? key}) : super(key: key);

  @override
  State<Ats> createState() => _AtsState();
}

class _AtsState extends State<Ats> {
  bool isVisible = false;
  String status = "Otomatis";

  @override
  void initState() {
    FirebaseDatabase.instance.ref('input/register/status').get().then((value) {
      if (value.value.toString() == "Manual" ||
          value.value.toString() == "PLN" ||
          value.value.toString() == "PLTS") {
        setState(() {
          isVisible = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Automatic Transfer Switch"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref('input').onValue,
        builder: (context, snapshot) {
          bool sendingData = snapshot.hasData
              ? ((snapshot.data!.snapshot.value as Map)['register'] as Map)
                  .containsValue(1)
              : false;
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Status : ${sendingData ? "Mengirim data" : (snapshot.data!.snapshot.value as Map)['register']['status']}"),
                      const SizedBox(
                        height: 20,
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChartPLN(),
                              ChartPLTS(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (snapshot.data!.snapshot.value
                                            as Map)['register']['state']
                                        .toString()
                                        .contains('pln')
                                    ? Colors.amber
                                    : Colors.amber.shade50),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (snapshot.data!.snapshot.value
                                            as Map)['register']['state']
                                        .toString()
                                        .contains('off')
                                    ? Colors.red
                                    : Colors.red.shade50),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (snapshot.data!.snapshot.value
                                            as Map)['register']['state']
                                        .toString()
                                        .contains('plts')
                                    ? Colors.green
                                    : Colors.green.shade50),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: sendingData
                                      ? null
                                      : () {
                                          setState(() {
                                            isVisible = true;
                                            status = "Manual - OFF";
                                            setActive('i1');
                                          });
                                        },
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Card(
                                        color: ((snapshot.data!.snapshot.value
                                                        as Map)['register']
                                                    ['i1'] as int) ==
                                                1
                                            ? Colors.amber
                                            : null,
                                        child: const Center(
                                            child: Text("Manual"))),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: sendingData
                                      ? null
                                      : () {
                                          setState(() {
                                            isVisible = false;
                                            status = "Otomatis";
                                            setActive('i2');
                                          });
                                        },
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Card(
                                        color: ((snapshot.data!.snapshot.value
                                                        as Map)['register']
                                                    ['i2'] as int) ==
                                                1
                                            ? Colors.amber
                                            : null,
                                        child: const Center(
                                            child: Text("Otomatis"))),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: !isVisible ? 0 : 150,
                        child: !isVisible
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: sendingData
                                            ? null
                                            : () {
                                                setState(() {
                                                  status = "Manual - PLTS";
                                                  setActive('i4');
                                                });
                                              },
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Card(
                                              color: ((snapshot.data!.snapshot
                                                                      .value
                                                                  as Map)[
                                                              'register']['i4']
                                                          as int) ==
                                                      1
                                                  ? Colors.amber
                                                  : null,
                                              child: const Center(
                                                  child: Text("PLTS"))),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: sendingData
                                            ? null
                                            : () {
                                                setState(() {
                                                  status = "Manual - PLN";
                                                  setActive('i5');
                                                });
                                              },
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Card(
                                              color: ((snapshot.data!.snapshot
                                                                      .value
                                                                  as Map)[
                                                              'register']['i5']
                                                          as int) ==
                                                      1
                                                  ? Colors.amber
                                                  : null,
                                              child: const Center(
                                                  child: Text("PLN"))),
                                        ),
                                      ))
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: sendingData
                                  ? null
                                  : () {
                                      setState(() {
                                        status = "Manual - OFF";
                                        setActive('i3');
                                      });
                                    },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                    color: ((snapshot.data!.snapshot.value
                                                    as Map)['register']['i3']
                                                as int) ==
                                            1
                                        ? Colors.amber
                                        : null,
                                    child: const Center(child: Text("OFF"))),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  void setActive(String path) {
    FirebaseDatabase.instance.ref('input/register').child(path).set(1);
  }
}
