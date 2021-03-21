import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:e_target/models/abonne.dart';

class Profile extends StatefulWidget {
  String name, email, telephone, password, id_abonne;

  Profile({Key key,this.id_abonne,  this.name, this.email, this.telephone, this.password}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  //Déclaration des variables
  String id_abonne, name, number, email, password;

  double largeur, longueur;
  TextEditingController fieldController = TextEditingController();

  String updateValue;
  GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  Icon i1 = Icon(
    Icons.person,
    color: Colors.amberAccent,
  );

  Icon i2 = Icon(
    Icons.call,
    color: Colors.amberAccent,
  );

  Icon i3 = Icon(
    Icons.email,
    color: Colors.amberAccent,
  );

  Icon i4 = Icon(
    Icons.lock,
    color: Colors.amberAccent,
  );

  String comment1 = """Ce nom s'affichera en en-tête 
  des messages lors d'une campagne""";

  String comment2 = "C'est votre numéro identifiant";
  String comment3 = "";
  String comment4 = "";

  @override
  Widget build(BuildContext context) {

    largeur = MediaQuery.of(context).size.width;

    //Instanciation des variables servant de paramètres dans la fonction de création de champ de modif
    name = widget.name;
    number = widget.telephone;
    email = widget.email;
    password = widget.password;
    id_abonne = widget.id_abonne;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
          textScaleFactor: 1.3,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
       children: <Widget>[
         Padding(padding: EdgeInsets.only(top: 30)),
         createField(i1, context, "Nom", id_abonne, "Ajouter votre send id", updateKey, name, number, email, password, fieldController, comment1),
         Divider( color: Colors.black, height: 20, indent: largeur/8, endIndent: largeur/13,),
         createField(i2, context, "Telephone", id_abonne, "Modifier le numéro identifiant", updateKey, name, number,
             email, password, fieldController, comment2, ),
         Divider( color: Colors.black, height: 20, indent: largeur/8, endIndent: largeur/13,),
         createField(i3, context, "Email", id_abonne, "Éditer l'email", updateKey, name, number, email, password, fieldController),
         Divider( color: Colors.black, height: 20,  indent: largeur/8, endIndent: largeur/13,),
         createField(i4, context, "Mot de passe", id_abonne, "Changer de mot de passe", updateKey, name, number,email,password, fieldController),
         Padding(padding: EdgeInsets.only(bottom: 85),),
         Text(
           "From SYSTEC",
           textScaleFactor: 1.5,
           style: TextStyle(
             color: Colors.black,
             fontSize: 20,
             fontWeight: FontWeight.bold,
           ),
         ),
       ],
      ),
    );
  }


//  widget text field

}

//Affichage des info utilisateur présentement enregistré
Widget createField(Icon icn,BuildContext ctx, String lib, String id, String titre, GlobalKey<FormState> updateKey,
    String name, String number, String email, String password,  TextEditingController fieldController, [String comment]){
  String val;
  double largeur = MediaQuery.of(ctx).size.width;
  double longueur = MediaQuery.of(ctx).size.height;
  switch(lib){
    case "Nom":
      val = name;
      break;
    case "Telephone":
      val = number;
      break;
    case "Email":
      val = email;
      break;
    case "Mot de passe":
      val = "********";
      break;
  }
  return InkWell(
    child:Padding(
      padding: EdgeInsets.only(left: 8),
      child: Row(
        children: <Widget>[
          icn,
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Align(
                        alignment: Alignment(-1,0),
                        child: Text("$lib")),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "$val",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(ctx).size.height/27
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Text(
                  "$comment",
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: MediaQuery.of(ctx).size.height/48,
                  ),
                ),
              ],
            )
            ,
          )
        ],
      ),
    ),
    onTap: (){
      UpdateData(id, ctx, lib, titre, updateKey, name, number, email, password, fieldController);
    },
  );
}

//Affichage de l'alertDialog pour la modification d'une info utilisateur
void UpdateData(String id_abonne, BuildContext ctx, String lib, String titre, GlobalKey<FormState> updateKey,
    String name, String number, String email, String password, TextEditingController fieldController){

  Size taille = MediaQuery.of(ctx).size;
  String va;
  if(lib == "Nom"){
    va = name;
    fieldController.text = name;
  }else if(lib == "Telephone"){
    va = number;
    fieldController.text = number;
  }else if(lib == "Email"){
    va = email;
    fieldController.text = email;
  }else if(lib == "Mot de passe"){
    va = password;
    fieldController.text = password;
  }

  var alertDialog = AlertDialog(
    title: Text(
      "$titre",
      textScaleFactor: 1.2,
      textAlign: TextAlign.center,
    ),
    content: SingleChildScrollView(
      child:
      Form(
          key: updateKey,
          child: Container(
            height: taille.height / 3.8,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: fieldController,
                  // initialValue: "$va",
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  // ignore: missing_return
                  validator: (va) {
                    if (va.isEmpty) {
                      return "Veuillez entrer un titre";
                    }

                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'Annuler',
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //          padding: EdgeInsets.only(right: 50),
                      textColor: Colors.red,
                    ),
//                      SizedBox(width: MediaQuery.of(context).size.width/20,),
                    // Boutton pour Enregistrer
                    FlatButton(
                      onPressed: () {
                        if (!updateKey.currentState.validate()) {
                          return;
                        }

                        if(lib == "Nom"){
                          name = fieldController.text;
                        }else if(lib == "Telephone"){
                          number = fieldController.text;
                        }else if(lib == "Email"){
                          email = fieldController.text;
                        }else if(lib == "Mot de passe"){
                          password = fieldController.text;
                        }

                        UpdateSending(id_abonne, ctx, name, number, email, password);
                        updateKey.currentState.save();
                        print("id_abonne: $id_abonne\nName: $name \nNuméro: $number\nAdresse email: $email "
                            "\nMot de passe: $password");
                      },
                      child: Text(
                        'Enregistrer',
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textColor: Colors.blue,
                      padding: EdgeInsets.only(right: 10),
                    ),
                  ],
                ),
              ],
            ),
          )),
    ),
  );

  showCupertinoDialog(
      context: ctx,
      builder: (BuildContext context) {
        return alertDialog;
      }
  );
}

//Requête de modification d'une information utilisateur
void UpdateSending(String id_abonne, BuildContext ctx, String name, String number, String email, String password) async {
  var url = "http://mobile.e-target-ci.com/register/users/updateabonne";
  var response;
  response = await http.post(url, body: {
    "id_abonne": id_abonne,
    "name": name,
    "email": email,
    "numero": number,
    "password": password,
  });

  final data = json.decode(response.body);
  debugPrint("Le statut de la requête: ${response.statusCode}");

  bool leStatus = data['status'];

  List user_data = [ name, number, email, password, id_abonne];
  if(leStatus)
  {
    Navigator.pop(ctx,user_data);
  }else{
    final snackBar = SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Container(
          height: 30,
          child: Text('Réesssayer svp...',style: TextStyle(color: Colors.white),),
        )
    );
    Scaffold.of(ctx).showSnackBar(snackBar);

  }
}


