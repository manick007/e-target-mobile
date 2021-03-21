import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PackSMS extends StatefulWidget {
  @override
  _PackSMSState createState() => _PackSMSState();
}

class _PackSMSState extends State<PackSMS> {
  Future<List> getPack() async {
    final packUrl = "https://mobile.e-target-ci.com/register/users/packsms";
//    final packUrl = "http://localhost/e-target-mobile/register/Users/packsms";
//    final packUrl = "https://mohotel.e-target-ci.com/foodPhone";
    var response = await http.get(packUrl);
    print(response.body);
    return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Forfaits de SMS",
          textScaleFactor: 1.3,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: FutureBuilder<List>(
              future: getPack(),
              builder: (context, getData) {
                switch (getData.connectionState) {
                  case ConnectionState.none:
                    return Text(
                      """Veillez activer votre connextion internet""",
                      textScaleFactor: 1.9,
                    );
                    break;
                  case ConnectionState.waiting:
                    return Center(child: RefreshProgressIndicator());
                    break;
                  case ConnectionState.done:
                    return getData.hasData
                        ? ItemModelData(
                            list: getData.data,
                          )
//                        ? Text(
//                            """${getData.hasData} \n çà marche""",
//                            textScaleFactor: 1.9,
//                         )
                          : Text(
                            """Problème de connexion au serveur""",
                            textScaleFactor: 1.9,
                          );
                    break;
                  default:
                    return Text(
                      """Erreur !!!""",
                      textScaleFactor: 1.9,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemModelData extends StatelessWidget {
  List list;
  ItemModelData({this.list});

  @override
  Widget build(BuildContext context) {
    Size taille = MediaQuery.of(context).size;
    return Container(
      height: taille.height,
      child: ListView.builder(
          itemCount: list == null ? 0 : list.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 9.5,
              child: ListTile(
                title: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                      color: Color.fromRGBO(243, 156, 42, 1),
                  ),
                  child: Text(
                    // LE titre du parks ou nom du parks de SMS
                    "${list[index]["libelle_pack"]}",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      "${list[index]["nbre_sms"]} SMS",
                      textScaleFactor: 1.25,
                      style: TextStyle(fontSize: 12),
                    ),
                    Container(
                      width: 3,
                      height: 25,
                      color: Color.fromRGBO(243, 156, 42, 1),
                      margin: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
                    ),
                    Text(
                      "${list[index]["prix_sms"]} fr",
                      textScaleFactor: 1.25,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: OutlineButton.icon(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(243, 156, 42, 1),
                      width: 2,
                  ),
                    onPressed: (){
                        print('Vous avez appuyer sur le bouton commander : ${list[index]["title"]}');
                    },
                    icon: Icon(Icons.shopping_cart,color: Colors.grey[700],),
                    label: Text("Acheter",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey[700]),),
                ),
              ),
            );
          }),
    );
  }
}
