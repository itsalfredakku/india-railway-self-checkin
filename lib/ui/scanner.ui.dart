import 'dart:async';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:self_checin/models/ticket.dart';
import 'package:self_checin/ui/home.ui.dart';
import 'package:sn_progress_dialog/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:wakelock/wakelock.dart';

class ScannerUI extends StatefulWidget {
  ScannerUI({Key? key, required this.stationCode, required this.stationName}) : super(key: key);
  final String stationCode;
  final String stationName;

  @override
  State<ScannerUI> createState() => _ScannerUIState();
}

class _ScannerUIState extends State<ScannerUI> {
  final MobileScannerController _scannerController =
      MobileScannerController(facing: CameraFacing.front);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AiBarcodeScanner(
            canPop: false,
            controller: _scannerController,
            hintText: 'Welcome to ${widget.stationName}',
            validateText: 'PNR',
            validateType: ValidateType.startsWith,
            onScan: _onScan,
            onDetect: _onDetect,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 96),
                      width: 120,
                      child: Image.asset('assets/images/IndianRailway.png')),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 86,
              left: 105,
              right: 105,
              child:
                  Lottie.asset('assets/lottie/117923-namaste-indiajson.json'))
        ],
      ),
    );
  }
  ProgressDialog? _progressDialog;
  final Completed _completed = Completed(
    completedMsg: 'Done'
  );
  bool busy = false;
  void _onScan(String data) async {
    if(busy) return;
    busy = true;
    if(_progressDialog != null &&  _progressDialog!.isOpen()) _progressDialog!.close();
    _progressDialog = ProgressDialog(context: context);

    _progressDialog!.show(max: 100, msg: 'Hold on', completed: _completed);

    Ticket? ticket;
    try {
      ticket = Ticket().fromData(data);
      print(ticket.toMap());
    } catch (exception) {
      print(exception);
      ticket = null;
    }

    _progressDialog!.update(
        value: 50,
        msg: 'Verifying PNR ${ticket!.pnr}');
    await Future.delayed(const Duration(milliseconds: 500));
    if(_progressDialog != null &&  _progressDialog!.isOpen()) _progressDialog!.close();

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 6), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: const Text('Ticket details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('PNR'),
                  Text('${ticket!.pnr}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('DOJ'),
                  Text('${ticket.dateOfJourney}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('Departure'),
                  Text('${ticket.scheduledDeparture}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('Passengers'),
                  Text('${ticket.passengers!.length}'),
                ],),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(var passenger in ticket.passengers!)
                      Text('${passenger.name} ${passenger.gender} ${passenger.age} (${passenger.status})', style: TextStyle(fontSize: 11 ,fontStyle: FontStyle.italic),),
                  ],),
                const SizedBox(height: 8.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('Train'),
                  Text('${ticket.trainName} (${ticket.trainNo})'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('Coach'),
                  Text('${ticket.coach}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('Quota'),
                  Text('${ticket.quota}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('From'),
                  Text('${ticket.from}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('To'),
                  Text('${ticket.to}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Text('CheckIn Station'),
                  Text(widget.stationCode),
                ],),
                const SizedBox(height: 8.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                  Text('*Note: All above data could be submitted to an api', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red),),
                  Text('This is just a prototype', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red),),
                ],),

              ],
            ),
          );
        });

    busy = false;
  }

  _onDetect(Barcode barcode, MobileScannerArguments? args) {}
}
