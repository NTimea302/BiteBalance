import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
   const InputField({
    Key? key,
    required this.controller,
    required this.text,
    required this.infoText,
    required this.obscureText,
    required this.icon,
    this.isNumeric = false,
    bool? doubleRow,
  })  : doubleRow = doubleRow ?? false,
        super(key: key);

  final TextEditingController controller;
  final String text, infoText;
  final Icon icon;
  final bool obscureText;
  final bool doubleRow;
  final bool isNumeric;

  @override
  Widget build(BuildContext context) {
    print(doubleRow);
    return Padding(
      padding: !doubleRow
      ? const EdgeInsets.symmetric(horizontal: 20, vertical: 5)
      : const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(fontSize: 16),
            hintText: infoText,
            hintStyle: TextStyle(color: Colors.black54, fontSize: 14, letterSpacing: 0.4),
            prefixIcon: Icon(icon.icon, color: Color.fromARGB(255, 0, 0, 0), size: 20),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
            ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        obscureText: obscureText,
        keyboardType: isNumeric ? TextInputType.number : null, // Add this line
        inputFormatters: isNumeric ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null, // Add this line
    
      ),
    );
  }
}
