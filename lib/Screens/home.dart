import 'package:flutter/material.dart';
import '../Model/gat_value.dart';
import '../services/request_api.dart';
import '../Model/model.dart';

class NameList extends StatefulWidget {
  const NameList({Key? key}) : super(key: key);

  @override
  State<NameList> createState() => _NameListState();
}

class _NameListState extends State<NameList> {
  Request _namesService = Request();

  final gender = ['Both', 'Female', 'Male'];
  String defGender = 'Both';
  var limit = ["10", "20", "40", "60", "100", "250", "500"];
  String defLimit = "10";
  final sort = ['positive', 'negative'];
  String defSort = 'positive';
  bool isPositive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurdish Name'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton(
                  value: defGender,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: gender
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (nValue) {
                    setState(() {
                      if (nValue == gender[0]) {
                        Value.gender = 'O';
                        defGender = gender[0];
                      } else if (nValue == gender[1]) {
                        Value.gender = 'F';
                        defGender = gender[1];
                      } else {
                        Value.gender = 'M';
                        defGender = gender[2];
                      }
                    });
                  }),
              DropdownButton(
                  value: defSort,
                  items: sort
                      .map((item) => DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          ))
                      .toList(),
                  onChanged: (nValue) => setState(() {
                        Value.sort = nValue.toString();
                        defSort = nValue.toString();
                      })),
              DropdownButton(
                  value: defLimit,
                  items: limit
                      .map((String item) => DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          ))
                      .toList(),
                  onChanged: (nValue) => setState(() {
                        Value.limits = nValue.toString();
                        defLimit = nValue.toString();
                      })),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: FutureBuilder(
                  future: _namesService.apiCall(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.data == null) {
                      return Text("Oops! no data");
                    }
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) =>
                          ExpansionTile(
                        title: Text(
                          snapshot.data!.names[index].name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Text(
                            snapshot.data!.names[index].desc,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 20,
                      ),
                      itemCount: snapshot.data!.names.length,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
