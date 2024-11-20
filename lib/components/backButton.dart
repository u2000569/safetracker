import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static Widget backButton(BuildContext context, double left, double height,
      {Function? popFunc}) {
    return Positioned(
      left: left,
      top: MediaQuery.of(context).size.height / height,
      child: GestureDetector(
        onTap: () {
          if (popFunc == null) {
            Navigator.pop(context, true);
            // Clipboard.setData(const ClipboardData());
            HapticFeedback.mediumImpact();
            Feedback.forTap(context);
          } else {
            popFunc();
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          height: 30,
          width: 30,
          child: Container(
            height: 20,
            width: 15,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  // alignment: Alignment.topLeft,
                  image: AssetImage('assets/image/back_button.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}