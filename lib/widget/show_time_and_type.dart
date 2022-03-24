import 'package:cyc_test/utility/dialog.dart';
import 'package:cyc_test/utility/my_constant.dart';
import 'package:cyc_test/widget/show_choose_time.dart';
import 'package:cyc_test/widget/show_image.dart';
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

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();

    changeDateToString();

    listTimeServices.add(MyConstant.timeServiceMotos);
    listTimeServices.add(MyConstant.timeServiceCars);
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
              newTitle('ประเภทของรถ'),
              newImage(constaraints),
              newSubTitle(),
              newRadioGroup(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      print(
                          'diff ลดวัน ${dateTime!.difference(DateTime.now()).inDays}');
                      if (dateTime!.difference(DateTime.now()).inDays <= 0) {
                        setState(() {
                          dateTime = DateTime.now();
                        });
                        changeDateToString();
                        normalDialog(context, 'ไม่สามารถ กลับไปหลังวันนี่ได้');
                      } else {
                        setState(() {
                          dateTime = DateTime.utc(
                            dateTime!.year,
                            dateTime!.month,
                            dateTime!.day - 1,
                          );

                          changeDateToString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  newTitle(dateTimeStr!),
                  IconButton(
                    onPressed: () {
                      print(
                          'diff เพิ่มวัน ${dateTime!.difference(DateTime.now()).inDays}');
                      if (dateTime!.difference(DateTime.now()).inDays >= 7) {
                        normalDialog(
                            context, 'ไม่สามารถ จองล่วงหน้า เกิน 7 วันได้ คะ');
                      } else {
                        setState(() {
                          dateTime = DateTime.utc(
                            dateTime!.year,
                            dateTime!.month,
                            dateTime!.day + 1,
                          );

                          changeDateToString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              newChooseTimeService(),
              newReserve(constaraints),
            ],
          ),
        );
      }),
    );
  }

  SizedBox newReserve(BoxConstraints constaraints) {
    return SizedBox(
      width: constaraints.maxWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyConstant.darkColor),
        onPressed: () {},
        child: const Text('ทำการจอง'),
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
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: Colors.pink,
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ShowText(
            label: listTimeServices[indexWidget][index],
            textStyle: MyConstant().h2Style(),
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
          label: 'รถมอเตอร์ไซด์',
          textStyle: MyConstant().h2Style(),
        ),
        ShowText(
          label: 'รถยนต์',
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
