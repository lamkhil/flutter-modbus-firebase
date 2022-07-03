import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Skm extends StatefulWidget {
  const Skm({Key? key}) : super(key: key);

  @override
  State<Skm> createState() => _SkmState();
}

class _SkmState extends State<Skm> {
  @override
  void initState() {
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
                          "Status : ${sendingData ? "Mengirim data" : (snapshot.data!.snapshot.value as Map)['register']['status2']}"),
                      const SizedBox(
                        height: 20,
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
                                            setActive('i6');
                                          });
                                        },
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Card(
                                        color: ((snapshot.data!.snapshot.value
                                                        as Map)['register']
                                                    ['i6'] as int) ==
                                                1
                                            ? Colors.amber
                                            : null,
                                        child: const Center(
                                            child: Text(
                                          "Forward\n6mm",
                                          textAlign: TextAlign.center,
                                        ))),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: sendingData
                                      ? null
                                      : () {
                                          setState(() {
                                            setActive('i8');
                                          });
                                        },
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Card(
                                        color: ((snapshot.data!.snapshot.value
                                                        as Map)['register']
                                                    ['i8'] as int) ==
                                                1
                                            ? Colors.amber
                                            : null,
                                        child: const Center(
                                            child: Text("Reverse\n3mm",
                                                textAlign: TextAlign.center))),
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
                                        setActive('i7');
                                      });
                                    },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                    color: ((snapshot.data!.snapshot.value
                                                    as Map)['register']['i7']
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
