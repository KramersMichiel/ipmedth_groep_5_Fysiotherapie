import 'package:flutter/material.dart';

class Color_button extends StatelessWidget {
  final Color lineColor;
  final ValueChanged<Color> onPressed;

  const Color_button({
    super.key,
    required this.lineColor,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(lineColor);
        
      },
      child: const Text("Color"),
      style: ElevatedButton.styleFrom(
       backgroundColor: lineColor,
      ),

    );
  }

}