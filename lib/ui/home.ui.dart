import 'package:flutter/material.dart';
import 'package:self_checin/ui/scanner.ui.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../utils/station.utils.dart';

class HomeUI extends StatefulWidget {
  HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final TextEditingController _controllerStationCode = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  String? stationCode;
  String? stationName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerStationCode.addListener(onChange);
    _textFocus.addListener(onChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bg.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SimpleShadow(
                  child: Image.asset(
                    'assets/images/IndianRailway.png',
                    height: 120,
                  ),
                  color: Color(0xffc40800),
                ),

                //SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Self CheckIn Prototype',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Designed by Akash Shah (@itsalfredakku)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        'Email: akash@devstroop.com',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _controllerStationCode,
                        decoration: InputDecoration(
                            hintText: 'Station code (i.e. BJU, DEL etc)',
                            suffix: Text(
                              '${stationName ?? ''} ${stationCode != null ? "(${stationCode!}}" : ""}',
                              style: const TextStyle(color: Colors.black),
                            )),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _initialize,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              primary: const Color(0xffc40800)),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 32,
                              child: const Text(
                                'Initialize terminal',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _initialize() {
    if (stationCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops!, Station code is not valid.'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScannerUI(stationCode: stationCode!, stationName: stationName!,),
      ),
    );
  }

  void onChange() {
    String code = _controllerStationCode.text;
    String? name = StationUtils().getStationName(code);
    if (name != null) {
      setState(() {
        stationCode = code.toUpperCase().trim();
        stationName = name;
      });
    } else {
      setState(() {
        stationCode = null;
        stationName = null;
      });
    }
    /*bool hasFocus = _textFocus.hasFocus;
    //do your text transforming
    String newText = StationUtils().getStationName(text) ?? text;
    _controllerStationCode.text = newText;
    _controllerStationCode.selection = TextSelection(
        baseOffset: newText.length,
        extentOffset: newText.length
    );*/
  }
}
