import 'package:self_checin/models/passenger.dart';

class Ticket {
  String? pnr;
  String? txnId;
  String? quota;
  List<Passenger>? passengers;
  String? trainNo;
  String? trainName;
  String? scheduledDeparture;
  String? dateOfJourney;
  String? boardingStation;
  String? coach;
  String? from;
  String? to;
  String? fare;
  String? irctcFee;

  Ticket(
      {this.pnr,
      this.txnId,
      this.quota,
      this.passengers,
      this.trainNo,
      this.trainName,
      this.scheduledDeparture,
      this.dateOfJourney,
      this.boardingStation,
      this.coach,
      this.from,
      this.to,
      this.fare,
      this.irctcFee});

  Ticket.fromMap(Map<String, dynamic> map)
      : pnr = map['pnr'],
        txnId = map['txnId'],
        quota = map['quota'],
        passengers = map['passengers'],
        trainNo = map['trainNo'],
        trainName = map['trainName'],
        scheduledDeparture = map['scheduledDeparture'],
        dateOfJourney = map['dateOfJourney'],
        boardingStation = map['boardingStation'],
        coach = map['reservationClass'],
        from = map['from'],
        to = map['to'],
        fare = map['fare'],
        irctcFee = map['irctcFee'];

  Map<String, dynamic> toMap() {
    return {
      'pnr': pnr,
      'txnId': txnId,
      'quota': quota,
      'passengers': passengers,
      'trainNo': trainNo,
      'trainName': trainName,
      'scheduledDeparture': scheduledDeparture,
      'dateOfJourney': dateOfJourney,
      'boardingStation': boardingStation,
      'reservationClass': coach,
      'from': from,
      'to': to,
      'fare': fare,
      'irctcFee': irctcFee,
    };
  }

  Ticket fromData(String data) {
    List<String> lines = data.split(',\n');

    return Ticket(
        pnr: lines
            .singleWhere((element) => element.trim().startsWith('PNR No.'))
            .split(':')
            .last,
        txnId: lines
            .singleWhere((element) => element.trim().startsWith('TXN ID'))
            .split(':')
            .last,
        passengers: [
          for (var each in lines
              .where((element) =>
                  element.startsWith('Passenger') || element.startsWith('		'))
              .toList()
              .join('\n')
              .split('Passenger'))
            if(each.trim().isNotEmpty && each.contains(':'))
              Passenger().fromData(each)
        ],
        quota: lines
            .singleWhere((element) => element.trim().startsWith('Quota'))
            .split(':')
            .last,
        trainNo: lines
            .singleWhere((element) => element.trim().startsWith('Train No.'))
            .split(':')
            .last,
        trainName: lines
            .singleWhere((element) => element.trim().startsWith('Train Name'))
            .split(':')
            .last,
        scheduledDeparture: '${lines
            .singleWhere((element) => element.trim().startsWith('Scheduled Departure'))
            .split(':')[1]}:${lines
            .singleWhere((element) => element.trim().startsWith('Scheduled Departure'))
            .split(':')[2]}' ,
        dateOfJourney: lines
            .singleWhere((element) => element.trim().startsWith('Date Of Journey'))
            .split(':')
            .last,
        boardingStation: lines
            .singleWhere((element) => element.trim().startsWith('Boarding Station'))
            .split(':')
            .last,
        coach: lines
            .singleWhere((element) => element.trim().startsWith('Class'))
            .split(':')
            .last,
        from: lines
            .singleWhere((element) => element.trim().startsWith('From'))
            .split(':')
            .last,
        to: lines
            .singleWhere((element) => element.trim().startsWith('To'))
            .split(':')
            .last,
        fare: lines
            .singleWhere((element) => element.trim().startsWith('Ticket Fare'))
            .split(':')
            .last,
        irctcFee: lines
            .singleWhere((element) => element.trim().startsWith('IRCTC C Fee'))
            .split(':')
            .last);
  }
}
