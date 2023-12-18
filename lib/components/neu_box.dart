import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final child;
  final double padds;
  const NeuBox({super.key, required this.child, required this.padds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padds),
      child: Center(child: child),
      decoration: BoxDecoration(
          color: Color.fromRGBO(236, 227, 206, 1.0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            //darker shadow
            BoxShadow(
              color: Color.fromRGBO(190, 190, 180, 1.0),
              blurRadius: 15,
              offset: Offset(5,5),
            ),
            BoxShadow(
              color:Colors.white,
              blurRadius: 15,
              offset: Offset(-5,-5),
            )
          ]
      ),
    );
  }
}
