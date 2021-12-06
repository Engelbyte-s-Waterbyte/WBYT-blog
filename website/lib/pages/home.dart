import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/idol-sketch.png"),
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }
}
