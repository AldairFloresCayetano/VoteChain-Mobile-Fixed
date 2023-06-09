import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:primer_proyecto/modules/user-management/models/archivo.dart';
import 'package:primer_proyecto/modules/vote-management/vote.service.dart';
import '../../../themes/color.dart';
import '../user-views/vote-if-not.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:primer_proyecto/modules/user-management/models/archivo.dart';
import 'package:primer_proyecto/modules/vote-management/vote.service.dart';
import '../../../themes/color.dart';
import '../user-views/vote-if-not.dart';

import 'package:http/http.dart' as http;
import 'dart:async';


class VoteView extends StatefulWidget {
  @override
  _VoteViewState createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  late ListVoteService listPublicationesService= ListVoteService();

  List users = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }
  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('http://192.168.1.8:3000/schools/1/master-political-parties');
    var response = await http.get(url);
    if(response.statusCode == 200){
      var items = json.decode(response.body);
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      users = [];
      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LISTA DE PARTIDOS POLITICOS"),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    if(users.contains(null) || users.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primary),));
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return getCard(users[index]);
        });
  }
  Widget getCard(item) {
    var fullName = item['name'];
    var email = item['description'];
    var masterPoliticalPartyId = item['id'];

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: <Widget>[
                  /*Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(60 / 2),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profileUrl),
                      ),
                    ),
                  ),*/
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          fullName,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        email.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                //boton
                child: ElevatedButton(
                  onPressed: () {
                    print("vamos a relaizar el voto");
                    print(masterPoliticalPartyId);
                    listPublicationesService.postVote(2,masterPoliticalPartyId);
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VoteIfNotView()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3F468F),
                  ),
                  child: Text('VOTE', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class ListMasterPoliticalParties extends StatefulWidget {

  const ListMasterPoliticalParties({Key? key}) : super(key: key);
  @override
  State<ListMasterPoliticalParties> createState() => _ListMasterPoliticalPartiesState();
}

class _ListMasterPoliticalPartiesState extends State<ListMasterPoliticalParties> {
  late ListVoteService listVotesService =
  ListVoteService();
  int userId=0;
  late http.Response temp;
  List<MasterPoliticalParty> masterPoliticalParties = [];
  List<MasterPoliticalParty> allMasterPoliticalParties = [];
  List users = [];
  bool isLoading = false;

  Future<int> retrieveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt('userId') ?? 0;
    return counter;
  }

  Future<void> loadData() async {
    int userId = await retrieveUser();
    http.Response allMasterPolitical= await listVotesService.getMasterPoliticalPartiesInfo();

    setState(() {
      masterPoliticalParties = [];
      allMasterPoliticalParties = [];


      String body = utf8.decode(allMasterPolitical.bodyBytes);
      for (var element in jsonDecode(body)) {
        allMasterPoliticalParties.add(MasterPoliticalParty(
          element["id"],
          element["name"],
          element["description"],
          element["proposes"],
          element["schoolId"],
      ));
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    //this.fetchUser();
  }
  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('http://192.168.1.8:3000/schools/1/master-political-parties');
    var response = await http.get(url);
    if(response.statusCode == 200){
      var items = json.decode(response.body);
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      users = [];
      isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LISTA DE PARTIDOS POLITICOS"),
      ),
    );
  }

  Widget getCard(item) {
    var fullName = item['name'];
    var email = item['description'];
   // var profileUrl = item['proposes'];

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: <Widget>[
                  /*Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(60 / 2),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profileUrl),
                      ),
                    ),
                  ),*/
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          fullName,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        email.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
                          width: double.infinity,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            //boton
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VoteIfNotView()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3F468F),
                              ),
                              child: Text('VOTE', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
          ],
        ),
      ),
    );
  }
}