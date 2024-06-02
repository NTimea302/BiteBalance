import 'package:flutter/material.dart';

class ButtonData {
  final String text;
  final Function(bool)? onPressed;

  ButtonData({
    required this.text,
    this.onPressed,
  });
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<ButtonData> buttons;

  const CustomDialog({
    required this.title,
    required this.message,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                SizedBox(height: 8.0),
                Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                ),
                SizedBox(height: 20.0),
              Text(
                message,
                textAlign: TextAlign.justify,

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons.map((buttonData) {
                  return TextButton(
                    child: Text(buttonData.text),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (buttonData.onPressed != null) {
                        buttonData.onPressed!(true);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
