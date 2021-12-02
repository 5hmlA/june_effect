import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:june_effect/june_effect.dart';

class DigitalSimple extends StatelessWidget {
  const DigitalSimple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DigitalsFlop(
          start: 0,
          indexBuilder: (BuildContext context, int index) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.redAccent,
              child: Center(child: Text(index.toString(), style: const TextStyle(fontSize: 80))),
            );
          },
          end: 10,
        ),
        const SizedBox(
          height: 30,
        ),
        DigitalFlop(
          currentBuilder: (BuildContext context) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.redAccent,
              child: const Center(child: Text("1", style: TextStyle(fontSize: 80))),
            );
          },
          nextBuilder: (BuildContext context) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.redAccent,
              child: const Center(child: Text("2", style: TextStyle(fontSize: 80))),
            );
          },
        )
      ],
    );
  }
}
