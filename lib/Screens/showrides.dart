import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShowRidesScreen extends StatefulWidget {
  final String from;
  final String to;

  const ShowRidesScreen({Key? key, required this.from, required this.to})
      : super(key: key);

  @override
  State<ShowRidesScreen> createState() => _ShowRidesScreenState();
}

class _ShowRidesScreenState extends State<ShowRidesScreen> {
  final _auth = FirebaseAuth.instance;
  var from;
  var to;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    from = widget.from;
    to = widget.to;
    print("------------------------------inside initstate");
    print(from);
    print(to);

    searchRide(uid, from, to);
  }

  List<Map<String, dynamic>> data = [];

  searchRide(String? uid, String from, String to) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("ShareRideInfo");

    Query query = ref.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();

    print(dataSnapshot.value);

    if (dataSnapshot.value != null) {
      (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
        var fromValue = value['from'];
        var toValue = value['to'];

        print("-------------------inside searchride");
        print(fromValue);
        print(toValue);
        print(from);
        print(to);

        if (fromValue.toString().toLowerCase().contains(from.toLowerCase()) &&
            toValue.toString().toLowerCase().contains(to.toLowerCase())) {
          print("-----------------inside if");
          data.add({
            "from": fromValue,
            "to": toValue,
            "date": value['date'],
            "time": value['time']
          });
        }
      });
    } else {
      print('No data found');
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget bottomsheet(){
      print("----------inside bottomsheet");
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile Photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed : (){
                   //
                  },
                  label : Text("Camera"),
                ),
                SizedBox(width: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  onPressed : (){
                    //
                  },
                  label : Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              //here there will be user photo
              child: Text(data[index]['from'][0]),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            title: Text(
              data[index]['to'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${data[index]['from']}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${data[index]['date']} ${data[index]['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
            ),
            onTap: () {
              // handle item tap
            },
          );
        },
      ),
    );
  }
}


// ListTile(
//             leading: Text(data[index]['from']),
//             trailing: Text(data[index]['to']),
//           );