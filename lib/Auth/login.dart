import 'dart:convert';

import 'package:e_target/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contacts_service/contacts_service.dart';     // Bibliothèque de gestion de contacts
import 'package:permission_handler/permission_handler.dart'; // Bibliothèque de gestion des permissions
import 'Register.dart';
import 'package:e_target/models/contacts.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {

  String name, telephone, email, password, id_abonne;

  Login({this.name, this.email, this.password,this.id_abonne, this.telephone});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _numero;
  String _password;
  Map<String, String> _inputs = Map();
  List<Contacts> showingContact = List();
  List<String> showContactName = List();
  Map<String, bool> inputsCheck = Map();
  bool _isVisible = false;

  var status =false ;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Iterable<Contact> _contacts;

  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  _getContacts() async {
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
        Contact ctc;
        Contacts _ctc;
        for (int i=0; i < _contacts.length; i++){
          ctc = _contacts.elementAt(i);
          if (ctc.phones.isNotEmpty){
            _ctc = Contacts(ctc.displayName, ctc.phones.elementAt(0).value);
            showingContact.add(Contacts(_ctc.name, _ctc.numb));
            inputsCheck.putIfAbsent(_ctc.name, () => false);
          }
        }

      });
    } else {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to contacts data denied',
        details: null,
      );
    }
  }

  //Fonction de lescture de permissons contacts
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      print("si permission: $permission");
      // getContacts();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      print("si pas permission: $permission");
      return permission;
    }
  }


  /**
   * Function to authentificated client
   */

  void Auth() async{

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final clientToken = prefs.get(key) ?? 0;

    var url = "http://mobile.e-target-ci.com/register/users/login";
    final response = await http.post(
        url,
        body: {
          'number' : _numero,
          'password' : _password
        }
    );
    print('numero: $_numero');
    print('numero: $_password');
    var data = json.decode(response.body);

    print("Affichage du token");
    if(data['status'])
    {
      print("\nToken: ${data["data"]["token"]}");
      _save(data["data"]["token"]);

      // passez à une autre page
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context)
          {
//          return Home(name: widget.name,);
            return Home(name: "${data["data"]["name"]}", id_abonne: "${data["data"]["id_abonne"]}",  showContacts: showingContact, inputsCheck: inputsCheck, telephone: "${data["data"]["number"]}", email: "${data["data"]["email"]}", password: "${data["data"]["password"]}",);

          }
          )
      );
    }
    else
      {
        status = false;
      }

  }

  /**
   *  TWO FUNCTIONS: Save token and read Token
   */

  _save(String token) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  /**
   *  Definition d'un semblant d'authentification
   */

//  void _Auth() {
//
//
//    if(!(widget.numero).isEmpty && (widget.password).isNotEmpty )
//    {
//
//      if(widget.password == _password)
//      {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (BuildContext context)
//            {
//              return Home(
//                name: widget.name,
//                id_abonne: widget.id_abonne,
//                showContacts: showingContact,
//                inputsCheck: inputsCheck,
//              );
//            }
//            )
//        );
//      }
//    }
//
//  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
//      appBar: AppBar(title: Text("E-target",textScaleFactor: 2,),),
      body: ListView(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility (
            visible: _isVisible,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
            ),
          ),

          Container(
            width: screenSize.width,
//           height: ,
            padding: EdgeInsets.only(
                top: screenSize.height - screenSize.height / 1.12),
//           color: Colors.red,
            child: Image.asset(
              "images/logo.png",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Connectez-vous",
                textScaleFactor: 2,
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(
                left: screenSize.width/12,
                right:  screenSize.width/12,
              ),
              child: Column(
                children: <Widget>[
                  _numberField(),
                  _passwordField(),
                  SizedBox(
                    height: 25,
                  ),
                  Builder(
                      builder: (context)=>RaisedButton(

                        onPressed:
                            () async {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                          if(!_formKey.currentState.validate())
                          {
                            return ;

                          }
                          _formKey.currentState.save();


                            final prefs = await SharedPreferences.getInstance();
                            final key = 'token';
                            final clientToken = prefs.get(key) ?? 0;

                            var url = "http://mobile.e-target-ci.com/register/users/login";
                            final response = await http.post(
                                url,
                                body: {
                                  'number' : _numero,
                                  'password' : _password
                                }
                            );
                            print('numero: $_numero');
                            print('numero: $_password');
                            var data = json.decode(response.body);
                          print('status: ${data['status']}');

                            if(data['status'])
                            {
                              print("\nToken: ${data["data"]["token"]}");
                              print("\nNuméro: ${data["data"]["password"].toString()}");
                              _save(data["data"]["token"]);
                              // passez à une autre page 47513690
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context)
                                  {
//          return Home(name: widget.name,);
                                   return Home(name: "${data["data"]["name"]}", id_abonne: "${data["data"]["id_abonne"]}", showContacts: showingContact, inputsCheck: inputsCheck, telephone: "${data["data"]["numero"]}", email: "${data["data"]["email"]}", password: "${data["data"]["password"]}",);

                                  }
                                  )
                              );
                            }
                            else
                            {
                              final _snackbar = SnackBar(
                                duration: Duration(milliseconds: 2500),
                                content: Container(
                                  height: MediaQuery.of(context).size.height/12,
                                  decoration: BoxDecoration(
                                  ),
                                  child: Text(
                                    "${data["message"]}" ,
                                    textScaleFactor: 1.5,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                backgroundColor: Colors.grey[600],
                              );
                              Scaffold.of(context).showSnackBar(_snackbar);
                          }

                        },
                        child: Text(
                          "Valider",
                          textScaleFactor: 1.5,
                          style: TextStyle(fontSize: 17,color: Colors.amber[700]),
                        ),

                      )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
//           Center(
//             child: Text(
//               "mot de passe oublié ??",
//               textScaleFactor: 1.5,
//               style: TextStyle(
// //              color: Color.fromRGBO(23, 179, 224, 0),
//                   color: Colors.blue[700],
//                   decoration: TextDecoration.underline
//               ),
//             ),
//           ),
          Padding(
            padding: EdgeInsets.only(top:  screenSize.height/14),
            child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context){
                            return Register();
                          }
                      )
                  );
                },
                child: Text(
                  "créer un nouveau compte",
                  textScaleFactor: 1.7,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
//                    color: Color.fromRGBO(23, 179, 224, 0),
                  ),
                ),
              ),
            ),
          ),
//          RaisedButton(
//
//            onPressed: (){
//              _navigateToHome(context);
//            },
//            child: Text(
//              "Passer",
//              textScaleFactor: 1.5,
//              style: TextStyle(fontSize: 17,color: Colors.amber[700]),
//            ),
//
//          ),

        ],
      ),
    );
  }

  /**
   * Widget des champs de saisis
   */
  // TextFormFile of user number
  Widget _numberField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Numéro de téléphone",
      ),
      keyboardType: TextInputType.number,
      validator: (String value)
      {
        if(value.isEmpty)
        {
          return "le numéro est obligatoire";
        }
      },
      onSaved: (String value){
        _numero = value;
        widget.telephone = value;
      },
    );
  }

  // TextFormFile of user password
  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Mot de passe",

      ),
      obscureText: true,
      validator: (String value){
        if(value.isEmpty)
        {
          return "le mot de passe est obligatoire";
        }
//        else if(widget.password != value)
//        {
//          return "Votre mot de passe est incorrect";
//        }
//        else
//        {
//          return null;
//        }
      },
      onSaved: (String value){
        _password = value;
        widget.password = value;
      },
    );
  }

  // _navigateToHome(BuildContext context) async {
  //   Map results = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Home(
  //       showContacts: showingContact,
  //       inputsCheck: inputsCheck,
  //       id_abonne: "234",
  //       name: "SYSTEC",
  //     )),
  //   );
  // }

}

