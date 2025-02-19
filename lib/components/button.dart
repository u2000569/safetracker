import "package:flutter/material.dart";

class Button extends StatelessWidget {

  final Function()? onTap;
  final String text;
  const Button({
    super.key,
    required this.onTap, 
    required this.text
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(9, 31, 91, 1),
          borderRadius: BorderRadius.circular(10),
          ),
        child: Center(
          child:Text(
            text,
            style:const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              ),
            ),
          ),
      ),
    );
  }
}