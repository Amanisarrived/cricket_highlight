import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 55,
    this.width = double.infinity,
    this.color = Colors.redAccent,
    this.textColor = Colors.white,
    this.borderRadius = 14,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.bebasNeue(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
