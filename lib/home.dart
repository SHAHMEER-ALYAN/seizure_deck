import 'package:flutter/material.dart';
import 'package:seizure_deck/seizure.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  double buttonWidth = 175.0;
  double buttonHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),

              ],
            ),
      ) ?? false; //if showDialouge had returned null, then return false
    }

    SizedBox seizureDiaryButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Seizure()));
          },
          // style: ElevatedButton.styleFrom(
          //   padding: EdgeInsets.all(35.0)
          // ),
          child: Column(
            children: [
              Icon(Icons.book, size: 40, color: Color(0xFF00C8DD)),
              SizedBox(height: 5),
              Text("Seizure Diary")
            ],
          ),
        ),
      );
    }


    return MaterialApp(
      theme: ThemeData(
          iconTheme: const IconThemeData(
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF454587),
                  padding: EdgeInsets.all(35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ))),
      home: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF454587),
            // backgroundColor:  Color(0xFF00C8DD),
            centerTitle: true,
            title: Text("Homepage"),
          ),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset(
                      'assets/slogo.png',
                      height: 170,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      seizureDiaryButton(),
                      medicationButton(),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      exerciseButton(),
                      communityButton()
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      popularHospitalButton(),
                      firstAidButton()
                    ],
                  ),
                ],
              )),
        ),
      ),
    );

  }



    SizedBox medicationButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(35.0)
            // ),
            child: Column(
              children: [
                Icon(Icons.medication, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Medication")
              ],
            )),
      );
    }

    SizedBox exerciseButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(35.0)
            // ),
            child: Column(
              children: [
                Icon(Icons.fitness_center, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Exercise")
              ],
            )),
      );
    }

    SizedBox communityButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(35.0)
            // ),
            child: Column(
              children: [
                Icon(Icons.chat_bubble, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Community")
              ],
            )),
      );
    }

    SizedBox popularHospitalButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(35.0)
            // ),
            child: Column(
              children: [
                Icon(Icons.local_hospital, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Popular Hospitals", textAlign: TextAlign.center,)
              ],
            )),
      );
    }

    SizedBox firstAidButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(35.0)
            // ),
            child: Column(
              children: [
                Icon(Icons.medical_information, size: 40,
                  color: Color(0xFF00C8DD),),
                SizedBox(height: 5),
                Text("Popular Hospitals", textAlign: TextAlign.center,)
              ],
            )),
      );
    }

}


