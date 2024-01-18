import 'package:flutter/material.dart';

class bodySelect extends StatefulWidget {
  const bodySelect({Key? key}) : super(key: key);

  @override
  State<bodySelect> createState() => _bodySelect();
}

class _bodySelect extends State<bodySelect> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Body,
              Column(
                children: [
                  Body(),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 45.0),
                  //   child: Image.asset(
                  //     'assets/body.png',
                  //     height: 500,
                  //   ),
                  // )
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 60),
                  ElevatedButton(onPressed: () {}, child: Text('Shoulders')),
                  ElevatedButton(onPressed: () {}, child: Text('Chest')),
                  ElevatedButton(onPressed: () {}, child: Text('Back')),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: () {}, child: Text('Abs')),
                  ElevatedButton(onPressed: () {}, child: Text('Arms')),
                  SizedBox(height: 30,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Legs')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Body() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.fromLTRB(05,0,0,0),
            child: Image.asset(
              'assets/shoulder.png',
              height: 100,
              // fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(05,0,0,0),
            child: Image.asset(
              'assets/chest.png',
              height: 85,
              width: 190,
              // fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
              Image.asset(
                'assets/arms_left.png',
                height: 110,
                // width: 80,
                // fit: BoxFit.scaleDown,
              ),
              Image.asset(
              'assets/abs.png',
              height: 110,
              // width: 0,
              // fit: BoxFit.scaleDown,
            ),
              Image.asset(
              'assets/arms_right.png',
              height: 110,
              width: 50,
              // fit: BoxFit.scaleDown,
                ),
            ],),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5,3,0,0),
            child: Image.asset(
              'assets/legs.png',
              height: 200,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}
