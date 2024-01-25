import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views/SeizureWith.dart';
import 'package:seizure_deck/data/seizure_data.dart';
import 'package:seizure_deck/database/seizureListDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';

class SeizureList extends StatelessWidget {
  const SeizureList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF454587),
          centerTitle: true,
          title: const Text(
            "Seizure List",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _buildSeizureList(context),
      ),
    );
  }

  Widget _buildSeizureList(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    int? uid = userProvider.uid;
    print("USER ID: $uid");
    return FutureBuilder<List<SeizureDetection>>(
      future: fetchSeizureData(uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No seizure data found for the user'));
        } else {
          print(snapshot.data);
          List<SeizureDetection> seizureData = snapshot.data!;
          return _buildSeizureListView(context, seizureData);
        }
      },
    );
  }

  Widget _buildSeizureListView(BuildContext context, List<SeizureDetection> seizureData) {
    UserProvider userProvider = Provider.of(context, listen: false);
    int? uid = userProvider.uid;
    double buttonHeight = MediaQuery.of(context).size.height / 15; // Adjust the height as needed

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Center(
            child: Column(
              children: [
                Text(
                  'User: ${seizureData.isNotEmpty ? seizureData.first.userName : ""}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColumnHeader('Sno'),
                    _buildColumnHeader('Date'),
                    _buildColumnHeader('Time'),
                    _buildColumnHeader('Latitude'),
                    _buildColumnHeader('Longitude'),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 80, // Adjust the height as needed
                  color: Colors.black, // Color of the vertical line
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5, // Adjust the height as needed
          child: ListView.builder(
            itemCount: seizureData.length,
            itemBuilder: (context, index) {
              SeizureDetection seizures = seizureData[index];
              return _buildSeizureExerciseTile(context, seizures, index + 1);
            },
          ),
        ),
        SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SeizureNewWith()));
            },
            child: const Text("Test Seizure Detection"),
          ),
        ),
      ],
    );
  }

  Widget _buildSeizureExerciseTile(BuildContext context, SeizureDetection seizures, int sno) {
    DateTime datere = seizures.dateTime;
    double width = (MediaQuery.of(context).size.width / 12);
    return Center(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(width: width,),
            _buildColumnText('$sno'),
            SizedBox(width: width,),
            _buildColumnText('${datere.day}-${datere.month}'),
            SizedBox(width: width,),
            _buildColumnText('${datere.hour}:${datere.minute}'),
            SizedBox(width: width,),
            _buildColumnText('${seizures.latitude}'),
            SizedBox(width: width,),
            _buildColumnText('${seizures.longitude}'),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildColumnText(String text) {
    return Text(text, style: TextStyle(fontSize: 12));
  }
}