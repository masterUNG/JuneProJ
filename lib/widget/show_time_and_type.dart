import 'package:cyc_test/utility/my_constant.dart';
import 'package:cyc_test/widget/show_image.dart';
import 'package:cyc_test/widget/show_text.dart';
import 'package:flutter/material.dart';

class ShowTimeAndType extends StatelessWidget {
  const ShowTimeAndType({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ShowText(
            label: 'ประเภทของรถ',
            textStyle: MyConstant().h2Style(),
          ),ShowImage(pathImage: 'images/mo.png',)
        ],
      ),
    );
  }
}
