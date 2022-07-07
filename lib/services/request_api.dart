import 'package:http/http.dart' as http;
import '../Model/model.dart';
import '../Model/gat_value.dart';

class Request {
// https://nawikurdi.com/
//API: https://nawikurdi.com/api

  Future apiCall() async {
    Uri url = Uri(
      scheme: 'https',
      host: 'nawikurdi.com',
      path: 'api',
      //query paramaeter are used for get request.
      queryParameters: {
        'limit': Value.limits,
        'gender': Value.gender,
        "sort": Value.sort,
        'offset': '0',
      },
    );

    http.Response _response = await http.get(Uri.parse(url.toString()));
    if (_response.statusCode == 200) {
      return LoadData.fromJson(_response.body);
    } else {
      throw Exception('Falid to load date');
    }
  }
}
