import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.infoText,
    this.press,
    required this.enabled
  }) : super(key: key);

  final String text, infoText;
  final VoidCallback? press;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          backgroundColor:  Colors.white,
        ),
        onPressed: press,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text(text),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  infoText,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Visibility(visible: enabled, child: 
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
           )
          ],
        ),
      ),
    );
  }
}
