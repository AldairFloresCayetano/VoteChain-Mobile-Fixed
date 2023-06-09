import 'dart:convert';

import 'package:primer_proyecto/modules/user-management/models/archivo.dart';
import 'package:http/http.dart' as http;

class ListVoteService{

  Future<http.Response> getMasterPoliticalPartiesInfo() async{
    final response = await http.get(Uri.parse('http://192.168.1.8:3000/schools/1/master-political-parties'));
    return response;
  }

  Future<http.Response> postVote(int studentId, int solicitude) async{
    int studentId = 3;
    //student/$studentId
    final response = await http.post(Uri.parse("http://192.168.1.8:3000/student/3/politicalpartyparticipant/$solicitude"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "studentId": studentId,
          "politicalPartyId": solicitude,

        }),
        encoding: utf8
    );
    print("este es el estatuscode");
    print(response.statusCode);
    return response;
  }

}
