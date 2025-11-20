import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMacroWidget extends StatelessWidget {
  final String title;
  final int value;
  const MyMacroWidget({
    required this.title,
    required this.value,
    super.key, required IconData icon});

  @override
  Widget build(BuildContext context) {
    return  Expanded(child: 
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:[
                              BoxShadow(
                                color: Colors.grey.shade400,
                             offset: const Offset(2, 2),
                             blurRadius: 5
                             )
                            ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,  horizontal: 4.0,
                            ),
                            child: Column(
                              children: [
                              const  Icon(CupertinoIcons.airplane,
                                color: Colors.redAccent,),
                                Text('$value $title',
                                style: const TextStyle(
                                  fontSize: 10
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        )
                        );
  }
}

