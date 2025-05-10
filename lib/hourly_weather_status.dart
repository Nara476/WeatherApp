import 'package:flutter/material.dart';

class HourlyWeatherStatus extends StatelessWidget {
  final String time;
  final Icon icon;
  final String temprature;
  const HourlyWeatherStatus(
    {super.key,
    required this.time,
    required this.icon,
    required this.temprature
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
                color: const Color.fromARGB(255, 42, 41, 41),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(174, 9, 9, 9),
                    blurRadius: 15
                  )
                ],
                borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                    icon,
                    Text(
                      temprature,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )
                      
                ],
                            ),
              ),
          );
  }
}