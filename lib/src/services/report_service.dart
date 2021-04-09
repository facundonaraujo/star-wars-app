import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/report_model.dart';

class ReportService {
  String _url = 'jsonplaceholder.typicode.com';

  Future<Map<String, dynamic>> getCharacterDetails(Report report) async {
    final url = Uri.https(_url, 'posts');
    final resp = await http.post(url, body: json.encode(report));

    final decodedData = json.decode(resp.body);

    print('decodedData: $decodedData');

    if (decodedData.containsKey('id')) {
      return {'ok': true, 'id': decodedData['id']};
    } else {
      return {
        'ok': false,
        'message': 'Report could not be made, please try again'
      };
    }
  }
}
