import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyc_test/models/time_service_model.dart';
import 'package:cyc_test/utility/dialog.dart';
import 'package:cyc_test/utility/my_constant.dart';
import 'package:cyc_test/widget/process_receive.dart';
import 'package:cyc_test/widget/show_image.dart';
import 'package:cyc_test/widget/show_progress.dart';
import 'package:cyc_test/widget/show_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowTimeAndType extends StatefulWidget {
  const ShowTimeAndType({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowTimeAndType> createState() => _ShowTimeAndTypeState();
}

class _ShowTimeAndTypeState extends State<ShowTimeAndType> {
  int indexWidget = 0;
  DateTime? dateTime;
  String? dateTimeStr;

  var listTimeServices = <List<String>>[];
  TimeServiceModel? timeServiceModel;
  var listTimeServiceFireabases = <List<String>>[];

  bool load = true;

  @override
  void initState() {
    super.initState();

    dateTime = DateTime.now();
    changeDateToString();

    readOrCreateTimeService();

    listTimeServices.add(MyConstant.timeServiceMotos);
    listTimeServices.add(MyConstant.timeServiceCars);
  }

  Future<void> readOrCreateTimeService() async {
    if (listTimeServiceFireabases.isNotEmpty) {
      listTimeServiceFireabases.clear();
    }

    await FirebaseFirestore.instance
        .collection('timeService')
        .doc(dateTimeStr)
        .get()
        .then((value) async {
      if (value.data() == null) {
        var carServices = <String>[];
        for (var item in MyConstant.timeServiceCars) {
          carServices.add('');
        }

        var motoServices = <String>[];
        for (var item in MyConstant.timeServiceMotos) {
          motoServices.add('');
        }

        TimeServiceModel timeServiceModel = TimeServiceModel(
            carService: carServices,
            motoService: motoServices,
            workDate: Timestamp.fromDate(dateTime!));

        await FirebaseFirestore.instance
            .collection('timeService')
            .doc(dateTimeStr)
            .set(timeServiceModel.toMap())
            .then((value) {
          print('Add Doc $dateTimeStr Success');
        });
      } else {
        setState(() {
          timeServiceModel = TimeServiceModel.fromMap(value.data()!);
          listTimeServiceFireabases.add(timeServiceModel!.motoService);
          listTimeServiceFireabases.add(timeServiceModel!.carService);
          load = false;
          print(
              '#25mar listTimeFirebase moto ===> ${listTimeServiceFireabases}');
        });
      }
    });
  }

  void changeDateToString() {
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    dateTimeStr = dateFormat.format(dateTime!);
    print('dateTimeStr ==> $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constaraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              newTitle('?????????????????????????????????'),
              newImage(constaraints),
              newSubTitle(),
              newRadioGroup(),
              newShowDate(context),
              load ? const ShowProgress() : newChooseTimeService(),
              newReserve(constaraints),
            ],
          ),
        );
      }),
    );
  }

  Row newShowDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            print('diff ??????????????? ${dateTime!.difference(DateTime.now()).inDays}');
            if (dateTime!.difference(DateTime.now()).inDays <= 0) {
              setState(() {
                dateTime = DateTime.now();
              });
              changeDateToString();
              normalDialog(context, '??????????????????????????? ?????????????????????????????????????????????????????????');
              readOrCreateTimeService();
            } else {
              setState(() {
                dateTime = DateTime.utc(
                  dateTime!.year,
                  dateTime!.month,
                  dateTime!.day - 1,
                );
                changeDateToString();
                readOrCreateTimeService();
              });
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        newTitle(dateTimeStr!),
        IconButton(
          onPressed: () {
            print(
                'diff ???????????????????????? ${dateTime!.difference(DateTime.now()).inDays}');
            if (dateTime!.difference(DateTime.now()).inDays >= 7) {
              normalDialog(context, '??????????????????????????? ????????????????????????????????? ???????????? 7 ?????????????????? ??????');
            } else {
              setState(() {
                dateTime = DateTime.utc(
                  dateTime!.year,
                  dateTime!.month,
                  dateTime!.day + 1,
                );
                changeDateToString();
                readOrCreateTimeService();
              });
            }
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  SizedBox newReserve(BoxConstraints constaraints) {
    return SizedBox(
      width: constaraints.maxWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyConstant.darkColor),
        onPressed: () {},
        child: const Text('????????????????????????'),
      ),
    );
  }

  Widget newChooseTimeService() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: listTimeServices[indexWidget].length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 60,
        ),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            if (listTimeServiceFireabases[indexWidget][index].isEmpty) {
              // listTimeServiceFireabases[indexWidget][index] = 'aa';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcessReceive(
                    indexType: indexWidget,
                    dateTimeStr: dateTimeStr!,
                    timeWork: listTimeServices[indexWidget][index],
                    dateTime: dateTime!, index: index, strings: listTimeServiceFireabases[indexWidget],
                  ),
                ),
              ).then((value) => readOrCreateTimeService());
            } else {
              normalDialog(context, '?????????????????????????????? ???????????? ??????');
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: listTimeServiceFireabases[indexWidget][index].isEmpty
                  ? Colors.white
                  : Colors.pink,
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ShowText(
              label: listTimeServices[indexWidget][index],
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ),
      ),
    );
  }

  Row newRadioGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Radio(
            value: 0,
            groupValue: indexWidget,
            onChanged: (value) {
              setState(() {
                indexWidget = int.parse(value.toString());
              });
            }),
        Radio(
            value: 1,
            groupValue: indexWidget,
            onChanged: (value) {
              setState(() {
                indexWidget = int.parse(value.toString());
              });
            }),
      ],
    );
  }

  Row newSubTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShowText(
          label: '???????????????????????????????????????',
          textStyle: MyConstant().h2Style(),
        ),
        ShowText(
          label: '??????????????????',
          textStyle: MyConstant().h2Style(),
        ),
      ],
    );
  }

  Row newImage(BoxConstraints constaraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShowImage(
          pathImage: 'images/mo.png',
          width: constaraints.maxWidth * 0.5 - 32,
        ),
        ShowImage(
          pathImage: 'images/car.png',
          width: constaraints.maxWidth * 0.5 - 32,
        )
      ],
    );
  }

  Row newTitle(String label) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: ShowText(
            label: label,
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }
}
