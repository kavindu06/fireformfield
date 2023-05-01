
import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';


void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
  home: MyApp(),
),);}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late String studentName;
  late String studentID;
  late String studyProgramID;
  late double studentGPA;

  var studentElement;

  getStudentName(name){
    studentName = name;
  }

  getStudentID(id){
    studentID = id;
  }

  getStudyProgramID(programmeID){
    studyProgramID=programmeID;
  }
  getStudentgpa(gpa){
    studentGPA = double.parse(gpa);
  }


  createData(){
    print('created');
    
    DocumentReference documentReference= FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students ={
      "studentName": studentName,
      "studentID":studentID,
      "studyProgramID":studyProgramID,
      "studentGPA":studentGPA

    };
    
    documentReference.set(students).whenComplete(() { print('$studentName created');});
  }

  updateData(){
    DocumentReference documentReference= FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students ={
      "studentName": studentName,
      "studentID":studentID,
      "studyProgramID":studyProgramID,
      "studentGPA":studentGPA

    };

    documentReference.set(students).whenComplete(() { print('$studentName created');});
  }
  readData()  {

    // final CollectionReference usersCollection = FirebaseFirestore.instance.collection('MyStudents');

// Retrieve a specific field from a document in the collection
// Future<String> getUserEmail(String studentName) async {
//   final DocumentSnapshot snapshot = await usersCollection.doc(studentName).get();
//   final String userEmail = snapshot.get('studentName');
//   return userEmail;
// }

      
    CollectionReference newCollection = FirebaseFirestore.instance.collection("MyStudents");
    final studentGPA = newCollection.where('studentGPA',isEqualTo:3.5).get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((element) { 
        // print(element.data());

        dynamic studentElement = element.data();

        // print(studentElement);
        
        Map<String, dynamic> student = studentElement;

          String studentName = student['studentName'];
          String studentID = student['studentID'];

          print(studentName);
          print(studentID);

        


      });
    });

    // dynamic elementData = getData();

  

    // String name = elementData['studentName'];

    // print(name);
    



  }
  // Future getData() async {


  //   CollectionReference newCollection = FirebaseFirestore.instance.collection("MyStudents");
  //   final studentGPA = newCollection.where('studentGPA',isEqualTo:2.6).get().then((QuerySnapshot snapshot){
  //     snapshot.docs.forEach((element) { 
  //       // print(element.data());

  //       dynamic studentElement = element.data();

  //       print(studentElement);

        



  //     });
  //   });
    
  //        dynamic elementData = jsonDecode(studentElement);

  //       String name = elementData['studentName'];

  //       print(name);
    
    

      
    
    
  // }




  deleteData(){
    print('deleted');
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.delete().whenComplete(() { print('$studentName deleted');});
  }

  

  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flutter College'),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:Colors.blue ,
                  width:2.0,
                ),
              ) ,
            ),            
            onChanged: (String name){             
               getStudentName(name);

            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Student ID",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:Colors.blue ,
                  width:2.0,
                ),
              ) ,
            ),
            onChanged: (String id){
              getStudentID(id);

            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Study Programme ID",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:Colors.blue ,
                  width:2.0,
                ),
              ) ,
            ),
            onChanged: (String programmeID){
              getStudyProgramID(programmeID);

            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "GPA",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:Colors.blue ,
                  width:2.0,
                ),
              ) ,
            ),
            onChanged: (String gpa){
              getStudentgpa(gpa);

            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: (){
                  createData();
                  },
                  child: const Text('Create'),),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                onPressed: (){
                  // getData();
                  readData();
                  
                  
                },
                child: const Text('Read'),),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[800]),
                onPressed: (){
                  updateData();
                },
                child: const Text('Update'),),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: (){
                  deleteData();
                },
                child: const Text('Delete'),),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("MyStudents").snapshots(),
            builder: (context,snapshot) {

              if (snapshot.hasData) {
                return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,

                        itemBuilder: (context,index){
                        DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                        return Row(
                          children: [
                            Expanded(
                                child: Text(documentSnapshot["studentName"]),
                            ),
                            Expanded(
                              child: Text(documentSnapshot["studentID"]),
                            ),
                            Expanded(
                              child: Text(documentSnapshot["studyProgramID"]),
                            ),
                            Expanded(
                              child: Text(documentSnapshot["studentGPA"].toString()),
                            ),
                          ],
                        );

                        });
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 24.0),
                );
              } else {
                return CircularProgressIndicator();
              }

              },)
        ],
      ),
    );
  }
}
