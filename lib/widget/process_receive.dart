// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cyc_test/models/receive_model.dart';
import 'package:cyc_test/utility/dialog.dart';
import 'package:cyc_test/utility/my_constant.dart';
import 'package:cyc_test/widget/show_form.dart';
import 'package:cyc_test/widget/show_text.dart';

class ProcessReceive extends StatefulWidget {
  final int indexType;
  final String dateTimeStr;
  final String timeWork;
  final DateTime dateTime;
  final int index;
  final List<String> strings;
  const ProcessReceive({
    Key? key,
    required this.indexType,
    required this.dateTimeStr,
    required this.timeWork,
    required this.dateTime,
    required this.index,
    required this.strings,
  }) : super(key: key);

  @override
  State<ProcessReceive> createState() => _ProcessReceiveState();
}

class _ProcessReceiveState extends State<ProcessReceive> {
  int? indexType;
  String? dateTimeStr, timeWork;
  var nameTypes = <String>[
    'รถมอเตอร์โซด์',
    'รถยนต์',
  ];

  String? phone, carId, province;
  DateTime? dateTime;

  int? index;
  List<String>? listString;

  @override
  void initState() {
    super.initState();
    indexType = widget.indexType;
    dateTimeStr = widget.dateTimeStr;
    timeWork = widget.timeWork;
    dateTime = widget.dateTime;
    index = widget.index;
    listString = widget.strings;

    var strings = timeWork!.split(':');
    int hour = int.parse(strings[0]);
    int minus = int.parse(strings[1]);
    dateTime =
        DateTime(dateTime!.year, dateTime!.month, dateTime!.day, hour, minus);

    print(
        '#25mar indexType => $indexType, dateTimeStr => $dateTimeStr, timeWork => $timeWork, dateTime ==> $dateTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.darkColor,
        title: const Text('Process ของการ จอง'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            newTitle(head: 'ประเภทของรถ : ', detail: nameTypes[indexType!]),
            newTitle(head: 'วันที่ เข้าใช้บริการ : ', detail: dateTimeStr!),
            newTitle(head: 'เวลา เข้่าใช้บริการ : ', detail: timeWork!),
            ShowForm(
              label: 'เบอร์ติดต่อ : ',
              changeFunc: (String string) => phone = string.trim(),
              textInputType: TextInputType.phone,
            ),
            ShowForm(
              label: 'ทะเบียนรถ :',
              changeFunc: (String string) => carId = string.trim(),
            ),
            ShowForm(
              label: 'จังหวัด',
              changeFunc: (String string) => province = string.trim(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  if ((phone?.isEmpty ?? true) ||
                      (carId?.isEmpty ?? true) ||
                      (province?.isEmpty ?? true)) {
                    normalDialog(
                        context, 'มีช่องว่าง ? กรุณาใสข้อมูล ให้ครบทุกช่อง คะ');
                  } else {
                    processSaveReceive();
                  }
                },
                child: const Text('Receive'),
                style: ElevatedButton.styleFrom(primary: MyConstant.darkColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row newTitle({required String head, required String detail}) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        ShowText(
          label: head,
          textStyle: MyConstant().h2Style(),
        ),
        const SizedBox(
          width: 16,
        ),
        ShowText(
          label: detail,
          textStyle: MyConstant().h2blueStyle(),
        )
      ],
    );
  }

  Future<void> processSaveReceive() async {
    var user = FirebaseAuth.instance.currentUser;

    listString![index!] = user!.uid;
    Map<String, dynamic> map = {};

    if (indexType == 0) {
      map['motoService'] = listString;
    } else {
      map['carService'] = listString;
    }

    ReceiveModel receiveModel = ReceiveModel(
        carId: carId!,
        phone: phone!,
        province: province!,
        status: 'wait',
        timeService: Timestamp.fromDate(dateTime!));

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .collection('receive')
        .doc()
        .set(receiveModel.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('timeService')
          .doc(dateTimeStr)
          .update(map)
          .then((value) => Navigator.pop(context));
    });
  }
}
