import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final Icon icon;
  final String label;
  final String value;
  const AdditionalInfo(
    {super.key,
    required this.icon,
    required this.label,
    required this.value
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
                alignment: Alignment(0, 0),
                width: 120,
                height: 100,
                margin: EdgeInsets.only(
                left: 10,
                top: 20,
                right: 10
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 35, 35),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(174, 9, 9, 9),
                    blurRadius: 15
                  )
                ],
                borderRadius: BorderRadius.circular(30)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  icon,
                  Text(
                    label
                    ,style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                    ),
                  Text(
                    value.toString(),
            
                  )
                    
              ],
            ),
          );
  }
}