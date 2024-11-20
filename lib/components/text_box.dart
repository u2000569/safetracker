import "package:flutter/material.dart";

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key, 
    required this.text, 
    required this.sectionName, 
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15.0, 
        bottom: 20.0
        ),
      margin: const EdgeInsets.only(
        left: 20.0, 
        right: 20.0, 
        top: 20.0
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // sectionName
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
                ),

              //edit button
              IconButton(
                onPressed: onPressed, 
                icon: const Icon(Icons.settings),)
            ],
          ),
          //text
          Text(text),
        ],
      ),
    );
  }
}