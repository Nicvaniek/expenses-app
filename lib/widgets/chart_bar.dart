import 'package:flutter/material.dart';

/* All stateless widgets are immutable (since all fields are final) so we can 
create a const constructor so build() does't run again for this widget
*/
class ChartBar extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  final double percentage;

  const ChartBar({this.topLabel, this.bottomLabel, this.percentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              children: <Widget>[
                Container(
                    height: constraints.maxHeight * 0.15,
                    child: FittedBox(child: Text(topLabel))),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                  width: 10,
                  height: constraints.maxHeight * 0.6,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(2),
                            color: Color.fromRGBO(220, 220, 220, 1)),
                      ),
                      FractionallySizedBox(
                        heightFactor: percentage,
                        child: Container(
                          width: 10,
                          height: 60,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(2),
                              color: Theme.of(context).accentColor),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                    height: constraints.maxHeight * 0.15,
                    child: FittedBox(child: Text(bottomLabel)))
              ],
            ));
  }
}
