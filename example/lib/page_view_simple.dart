import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:june_effect/june_effect.dart';

class PageViewSimple extends StatelessWidget {
  const PageViewSimple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: JunePageView.aniBuilder(
            aniItemBuilder: (BuildContext context, int index, double page, double aniValue) {
              return Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      height: 200 + 50 * aniValue,
                      color: Colors.primaries[index % 9],
                      child: Center(
                        child: Transform.scale(
                          scale: aniValue * 2,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                spreadRadius: 5,
                                blurRadius: 5,
                              )
                            ]),
                            child: Text(
                              index.toString(),
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 300,
          child: JunePageView(
            itemBuilder: (context, index) {
              return Container(
                  color: Colors.primaries[index % 9],
                  child: Center(
                      child: Text(
                    index.toString(),
                    style: const TextStyle(fontSize: 30),
                  )));
            },
          ),
        ),
      ],
    );
  }
}
