import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/body_select.dart';
import 'package:seizure_deck/Views/taichi.dart';
import 'package:seizure_deck/Views/yoga.dart';

class generate_exercise_plan_new extends StatefulWidget {
  const generate_exercise_plan_new({super.key});

  @override
  State<generate_exercise_plan_new> createState() => _generate_exercise_plan();
}

class _generate_exercise_plan extends State<generate_exercise_plan_new> {

  @override
  Widget build(BuildContext context) {
    double widthButton = MediaQuery.of(context).size.width/1.2;
    double heightButton = MediaQuery.of(context).size.height/3.8;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF454587),
          centerTitle: true,
          title: const Text("Exercises Catalogue",style: TextStyle(color: Colors.white),),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: Container(
                      width: widthButton,
                      height: heightButton,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image:const AssetImage("assets/dumbbells.jpg"),
                              fit:BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                          ), 
                      ),
                      child: const Center(child: Text(
                        'Cardio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      )
                  ),
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const bodySelect()));
                print("you clicked me");
              }
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Container(
                      width: widthButton,
                      height: heightButton,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image:const AssetImage("assets/martialarts.jpg"),
                            fit:BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                        ), 
                      ),
                      child: const Center(child: Text(
                        'Tai Chi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      )
                  ),
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Taichi()));
                  }
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Container(
                      width: widthButton,
                      height: heightButton,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image:const AssetImage("assets/yoga.jpg"),
                            fit:BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                        ), 
                      ),
                      child: const Center(child: Text(
                        'Yoga',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      )
                  ),
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Yoga()));
                  }
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
