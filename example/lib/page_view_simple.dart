import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:june_effect/june_effect.dart';
import 'package:june_effect_example/sample_widget_provider.dart';

class PageViewSimple extends StatelessWidget {
  const PageViewSimple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 300,
          child: JunePageView.aniBuilder(
            aniItemBuilder: pageviewAniItem,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 300,
          child: ColoredBox(
            color: Colors.yellowAccent,
            child: JunePageView(
              modifier: const Modifier(viewportFraction: .73,padEnds: false,scrollDirection: Axis
                  .vertical),
              transform: StackTransform(),
              itemBuilder: pageViewItem,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 300,
          child: JunePageView(
            transform: CubeTransform(),
            itemBuilder: pageViewItem,
          ),
        ),
      ],
    );
  }
}
