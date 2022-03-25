import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyc_test/models/receive_model.dart';
import 'package:cyc_test/utility/my_constant.dart';
import 'package:cyc_test/widget/show_progress.dart';
import 'package:cyc_test/widget/show_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowListReceive extends StatefulWidget {
  const ShowListReceive({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowListReceive> createState() => _ShowListReceiveState();
}

class _ShowListReceiveState extends State<ShowListReceive> {
  bool load = true;
  bool? haveReceive; // true => haveReceive, false => no Data

  var receiveModels = <ReceiveModel>[];

  @override
  void initState() {
    super.initState();
    readReceive();
  }

  Future<void> readReceive() async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('receive').orderBy('timeService', descending: false)
        .get()
        .then((value) {
      load = false;
      if (value.docs.isEmpty) {
        haveReceive = false;
      } else {
        haveReceive = true;
        for (var item in value.docs) {
          ReceiveModel receiveModel = ReceiveModel.fromMap(item.data());
          receiveModels.add(receiveModel);
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : haveReceive!
              ? ListView.builder(
                  itemCount: receiveModels.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShowText(
                                label: receiveModels[index].carId,
                                textStyle: MyConstant().h2Style(),
                              ),
                              ShowText(label: 'Phone : ${receiveModels[index].phone}')
                            ],
                          ),
                          ShowText(
                            label: receiveModels[index].province,
                            textStyle: MyConstant().h2blueStyle(),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShowText(
                                label: changeTimeToStr(
                                    receiveModels[index].timeService),
                              ),
                              ShowText(label: receiveModels[index].status, textStyle: MyConstant().h2blueStyle(),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ShowText(
                  label: 'ไม่มี ประวัติการ จอง',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  String changeTimeToStr(Timestamp timeService) {
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
    String string = dateFormat.format(timeService.toDate());
    string = 'เวลานัดหมาย $string';
    return string;
  }
}
