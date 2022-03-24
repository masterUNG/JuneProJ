// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cyc_test/utility/my_constant.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String pathImage;
  final double? width;
  const ShowImage({
    Key? key,
    required this.pathImage,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: MyConstant.bgCololor,
      ),
      width: width ?? 200,
      child: Image.asset(pathImage),
    );
  }
}
