import 'dart:convert';
import 'package:loading_animations/loading_animations.dart';
import 'package:e_target/Auth/login.dart';
import 'package:e_target/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // définition des variable
  String name;
//  String firstname;
  String email, number, password;
  var id_abonne ;
  bool _isVisible = false;
  /// Les valeurs enregistrer en sessions

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var status;
//  var token;
  /**
   *  Function for push register data
   */



  void PushData() async {
    setState(() {
      _isVisible = !_isVisible;
    });
    var url = "http://mobile.e-target-ci.com/register/users/abonnes";
    final response = await http.post(
        url,
        body: {
          "name":  name,
          "email": email,
          "number": number,
          "password": password,
        }
    );
//
    var data = json.decode(response.body);
    status = data['status'];

    // lorsque l'enregistrement fonctionne

    print("status AVANT: $status");

    if(status) // si true
    {
      print('id de l\'abonne: ${data['id_abonne']}');
      print('status : ${data['status']}');
      print('message : ${data['message']}');

      id_abonne = "${data["id_abonne"]}";
       _saveUser();

    }
    else
    {
      print('data error : ${data["message"]}');
      print('It\'s status contain error ? : ${!status}');

    }
  }

  /**
   *  TWO FUNCTIONS: Save token and read Token
   */

//  _save(String abonne_id) async{
//    final prefs = await SharedPreferences.getInstance();
//    final key = 'id_abonne';
//    final value = abonne_id;
//    prefs.setString(key, value);
//    id_abonne = prefs.getString(key);
//    print("clé d'enregistrement de id_abonne : ${id_abonne}");
////    print("clé d'enregistrement de id_abonne ${prefs.getString(key)}");
//
//  }

  void _saveUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Enregistrement des données dans la session\n");
    prefs.setString("abonne_id", id_abonne);
    prefs.setString("abonne_name", name);
    prefs.setString("abonne_number", number);
    prefs.setString("abonne_email", email);
    prefs.setString("abonne_password", password);
    print("ENVOI LES DONNEES");
    String abonneId = prefs.getString("abonne_id");
    String abonneName = prefs.getString("abonne_name");
    String abonneNumber = prefs.getString("abonne_number");
    String abonneEmail = prefs.getString("abonne_email");
    String abonnePassword = prefs.getString("abonne_password");

//    print("abonneId: $abonneId;\n abonneName: $abonneName;\n "
//        "abonneEmail: $abonneEmail;\n abonnePassword: $abonnePassword");

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              return Login(name: abonneName, email: abonneEmail, telephone: abonneNumber, password: abonnePassword,id_abonne: abonneId,);
            }
        )
    );
  }




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
//      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          /**
           * Conteneur du logo
           */
          Container(
            width: screenSize.width,
            height: screenSize.height/5,
            padding: EdgeInsets.only(
              top: 0,
            ),
//           color: Colors.red,
            child: Image.asset(
              "images/logo.png",
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          /**
           * Texte inscrivez vous
           */
          Padding(
            padding: EdgeInsets.all(0),
            child: Center(
              child: Text(
                "Inscrivez-vous",
                textScaleFactor: 2,
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding:  EdgeInsets.only(
                left: screenSize.width/12,
                right: screenSize.width/12,
              ),
              child: Column(
                children: <Widget>[
//                  _nameFieldValidate(),
//                  _firstnameFieldValidate(),

//                  _numberFieldValidete(),
//                  _passwordFieldValidete(),
                  _nameFieldValidate(),
//                  FieldValidate("Prénoms", firstname),
                  _emailFieldValidate(),
                  _numberFieldValidate(),
                  _passwordFieldValidete(),
                  SizedBox(
                    height: 10,
                  ),
                  Builder(builder: (context)=> RaisedButton(
                    onPressed: () async{
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      var url = "http://mobile.e-target-ci.com/register/users/abonnes";
                      final response = await http.post(
                          url,
                          body: {
                            "name":  name,
                            "email": email,
                            "number": number,
                            "password": password,
                          }
                      );
//
                      var data = json.decode(response.body);
                      status = data['status'];

                      // lorsque l'enregistrement fonctionne

                      print("status AVANT: $status");

                      if(status) // si true
                          {
                        print('id de l\'abonne: ${data['id_abonne']}');
                        print('status : ${data['status']}');
                        print('message : ${data['message']}');

                        id_abonne = "${data["id_abonne"]}";
                        _saveUser();

                      }
                      else
                      {
                        print('data error : ${data["message"]}');
                        print('It\'s status contain error ? : ${!status}');

                        final snackBar = SnackBar(
                          duration: Duration(milliseconds: 2500),
                          content: Container(
                            height: MediaQuery.of(context).size.height/12,
                            decoration: BoxDecoration(
//                              gradient: LinearGradient(
//                                  colors: [
//                                    Colors.grey[400],
//                                    Colors.white30,
//                                  ]
//                              )
                            ),
                            child: Text(
                              "${data["message"]}" ,
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          backgroundColor: Colors.grey[600],
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                      child: Text(
                        "S'inscrire",
                        textScaleFactor: 2,
                        style: TextStyle(color: Colors.amber[700]),
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:  screenSize.height/18),
                    child: Center(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context){
                                    return Login();
                                  }
                              )
                          );
                        },
                        child: Text(
                          "j'ai déjà un compte",
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
                  SizedBox(height: 25,),
                  // showSn(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget MessageReturn(){
//    Builder(
//      builder: (context)=>SnackBar(
//          duration: Duration(milliseconds: 2000),
//          content: Container(
//            height: 30,
//            child: Text('aaaaa', textScaleFactor: 2, style: TextStyle(color: Colors.white),),
//          )
//      ),
//    );
//    return Scaffold.of(context).showSnackBar(SnackBar);
  }


  /**
   * Les Widgets de validation des champs du formulaire
   */

  //Nom
  Widget _nameFieldValidate() {
    return TextFormField(
      maxLength: 15,
      onSaved: (String value){
        name = value;
      },
      validator: (String value) {
        if (value.isEmpty) {
          return "Cette valeur est obligatoire";
        }
      },
      decoration: InputDecoration(
        labelText: "Nom",
      ),

    );
  }

  // Numéro
  Widget _numberFieldValidate() {
    return TextFormField(
      maxLength: 8,
      onSaved: (String value){
        number = value;
      },

      validator: (String value) {
        if (value.isEmpty) {
          return "Cette valeur est obligatoire";
        }
      },
      decoration: InputDecoration(
        labelText: "Numéro",
      ),
      keyboardType: TextInputType.number,

    );
  }

  // email
  Widget _emailFieldValidate() {
    return TextFormField(
      onSaved: (String value){
        email = value;
      },
      validator: (String value) {
        if (value.isEmpty) {
          return "Cette valeur est obligatoire";
        }
//
      },
      decoration: InputDecoration(
        labelText: "Email",
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Password
  Widget _passwordFieldValidete() {
    return TextFormField(
      onSaved: (String value){
        password = value;
      },
      validator: (String value) {
        if (value.isEmpty) {
          return "Cette valeur est obligatoire";
        }
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
      ),
      obscureText: true,
    );
  }


//  Widget showSn(context){
//    final snackBar = SnackBar(
//        duration: Duration(milliseconds: 2000),
//        content: Container(
//          height: 30,
//          child: Text('aaaaa', style: TextStyle(color: Colors.white),),
//        )
//    );
//    Scaffold.of(context).showSnackBar(snackBar);
//
//  }
}


