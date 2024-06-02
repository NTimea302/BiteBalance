import 'package:flutter/cupertino.dart';
import 'package:namer_app/UI/fitness_app_theme.dart';
import 'package:namer_app/main.dart';

class NutritionElement extends StatelessWidget {
  final String title;
  final int valueConsumed;
  final int valueTotal;

  const NutritionElement({
    super.key,
    required this.title,
    required this.valueConsumed,
    required this.valueTotal,
  });

  @override
  Widget build(BuildContext context) {
    Color colour = Color.fromRGBO(236, 242, 71, 1);
    double widthValue = (70 * valueConsumed / valueTotal).toDouble();
    if (valueConsumed / valueTotal > 0.2) {
      colour = Color.fromRGBO(208, 242, 71, 1);
    }
    if (valueConsumed / valueTotal > 0.4) {
      colour = Color.fromRGBO(200, 220, 119, 1);
    }   
    if (valueConsumed / valueTotal > 0.6) {
      colour = Color.fromRGBO(176, 242, 71, 1);
    }
    if (valueConsumed / valueTotal > 0.8) {
      colour = Color.fromRGBO(119, 221, 119, 1);
    }
    if (valueConsumed / valueTotal > 1.0) {
      colour = Color.fromRGBO(255, 57, 57, 1);
      widthValue = 70;
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: FitnessAppTheme.darkText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 4,
                    width: 70,
                    decoration: BoxDecoration(
                      color: HexColor('#77DD77').withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: widthValue,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colour,
                            // gradient: LinearGradient(colors: [
                            //   Color.fromRGBO(221, 214, 119, 1),
                            //   Color.fromRGBO(119, 221, 119, 1),
                            // ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '$valueConsumed/${valueTotal}g',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: FitnessAppTheme.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
