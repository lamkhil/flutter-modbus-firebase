import 'package:flutter/material.dart';
import 'package:modbus/pages/ats.dart';
import 'package:modbus/pages/skm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I-CON Studio"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36))),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                          child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('assets/logo.png'),
                              )),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('assets/hima.png'),
                              )),
                        ],
                      )),
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(42.0),
                      child: Card(
                        color: Colors.yellow,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Ats()));
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image.asset(
                                              'assets/logo_ats.png',
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            child: Text(
                                              "Automatic Transfer Switch",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Skm()));
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image.asset(
                                              'assets/moto_logo.png',
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            child: Text(
                                              "Sistem Kendali Motor",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
