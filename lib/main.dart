import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> notificationList = [];
  final ctrl = TextEditingController();
  ScrollController _controller1 = ScrollController();


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ListView.builder(
                  controller: _controller1,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white38,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Name Of Branch :',
                                style: TextStyle(
                                    color: Colors.orange
                                ),
                              ),
                              Text(notificationList[index]['Name'],
                                style: TextStyle(
                                  color: Colors.black
                              ),
                              ),


                            ],
                          ),
                          Row(
                            children: [
                              Text('Type Of Branch :',
                                style: TextStyle(
                                    color: Colors.orange
                                ),
                              ),
                              Text(notificationList[index]['BranchType'],style: TextStyle(
                                  color: Colors.deepPurple
                              ),),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('City',style: TextStyle(
                                  color: Colors.red
                              ),),
                              Text(notificationList[index]['District'],style: TextStyle(
                                  color: Colors.green
                              ),),
                              Text(notificationList[index]['State'],style: TextStyle(
                                  color: Colors.red
                              ),),
                              Text(notificationList[index]['Country'],style: TextStyle(
                                  color: Colors.grey
                              ),),

                            ],
                          ),

                        ],
                      ),
                    );
                  },
                ),
                TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Enter Name',
                      hintText: 'Enter Your Name'
                  ),
                ),
                 SizedBox(height: 30,),
                 InkWell(
                     onTap: (){
                       setState(() {
                         onNotificationLoad();
                       });
                     },
                     child: Container(
                       alignment: Alignment.center,
                     height: 50,
                     width: 100,
                     color: Colors.green,
                     child: Text('submit'))),


              ],
            ),
          )
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  onNotificationLoad() async {

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var statuss = prefs.getString('vendor_status');
    // var id = prefs.getString('id');
    // var token = prefs.getString('token');

     {

      var response =
      await http.get(Uri.parse('http://www.postalpincode.in/api/pincode/'+ctrl.text),
          headers: {
            'Accept': 'application/json',
          }
      );
      print(response);
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body) as Map;
        print(decode.toString());
        if (decode['Status'] == 'Success') {
          print(decode.toString());
          print("Get Data:" + decode['PostOffice'].toString());
          notificationList.clear();
          for (int i = 0; i < decode['PostOffice'].length; i++) {
            setState(() {
              notificationList.add(decode['PostOffice'][i]);
              print('list length is --------->${decode['PostOffice'][i]}');
            });
          }

        } else {
          print(decode.toString());


        }

        return;
      }
    }
  }
}