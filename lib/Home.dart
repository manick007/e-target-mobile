import 'dart:convert';
import 'dart:io';
import 'package:e_target/Auth/login.dart';
import 'package:e_target/models/contacts.dart';
import 'package:e_target/historique.dart';
import 'package:e_target/packSms.dart';
import 'package:e_target/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  String name, id_abonne, telephone, email, password;
  List<Contacts> showContacts;
  Map<String, bool> inputsCheck;

  Home({Key key, this.name, this.id_abonne, this.password, this.showContacts, this.inputsCheck,this.telephone, this.email}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  TextEditingController _contenuMsgController = TextEditingController();

  List<Contacts> selectedContactsList = List();
  List<Contacts> searchResultList = List();
  int currentlyIndex = 1;
  // bool tabBarSelected = false;
  bool isNotSelected = false;
  Contacts numbMsg;
//  Map<String, bool> inputsCheck = Map();

  // les variables du modèle
  String modelTitle, modelContent, updatemodelTitle,updatemodelContent;
  TextEditingController controllerSearch = TextEditingController();

  /**
   *  Controller of update model
   */

  TextEditingController _titleUpdateController = new TextEditingController();



  //Déclaration des paramètres statiques pour l'API d'envoi de SMS
  String postUrl = "https://3wymj.api.infobip.com/sms/1/text/advanced";
  String username = "SYSTEC27";
  String password = "@Xystaic!#18";
  String notifyUrl = "35";
  String notifyContentType = "12";
  String callbackData = "74t";
  String _from;



  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _contenuMsgController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  /**
   * Variable contenant les différents textes du menu du haut.
   */
  var paramIconItems = ["Historique", "Profil", "Déconnexion"];
  var ValueDropDown = "Historique";
  // var showingModelSms = [
  //   "Aucun Numéro",
  //   "Aucun Numéro 2",
  //   "Aucun Numéro 3",
  //   "Aucun Numéro 4",
  //   "Aucun Numéro 5",
  // ];
  //
  // var showingModelSms1 = [
  //   "Aucun Numéro",
  //   "Aucun Numéro 2",
  //   "Aucun Numéro 3",
  //   "Aucun Numéro 4",
  //   "Aucun Numéro 5",
  // ];
  var showingContactValue = "Aucun Numéro";
  final GlobalKey<FormState> _InstantaneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ModeleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _UpdateModeleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    /**
     *  le bigTabs permet d'afficher le menu lorsqu'on clique là-dessus.
     */
    final bigTabs = [
      Repertoire(),
      //Center(child: Text("Repertoire",textScaleFactor: 2,),),
      Message(),
      SmsModele(),
//      Center(child: Text("Modèle de SMS",textScaleFactor: 2,),)
    ];
    Size screenSize = MediaQuery
        .of(context)
        .size;
    // permet de selectionner l'icône dans le menu de navigation du bas
    bool isSelected(_currentlyIndex) {
      if (currentlyIndex == _currentlyIndex) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(

        /*
         Les boutons de navigations ou encore le Menu
       */

        backgroundColor: Colors.amber[700],
        /*
      Le grand menu
       */
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentlyIndex,
          items: [
            BottomNavigationBarItem(
//          backgroundColor: Colors.blue,
              title: Text(
                "Repertoire",
                textScaleFactor: 1.9,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
//              color: Colors.grey,
                ),
              ),
              icon: Icon(
                Icons.contact_phone,
                size: 30,
//                color: Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
//          backgroundColor: Colors.amber[700],
              title: Text(
                "Message",
                textScaleFactor: 1.9,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
//              color: Colors.grey,
                ),
              ),
              icon: Icon(
                Icons.sms,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
//          backgroundColor: Colors.amber[700],
              title: Text(
                "Modèle SMS",
                textScaleFactor: 1.9,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
//              color: Colors.grey,
                ),
              ),
              icon: Icon(
                Icons.email,
                size: 30,
//                color: isSelected ? Colors.grey : Colors.white
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              currentlyIndex = index;
//            isSelected = true;
            });
//          print(currentlyIndex);
//          print(isSelected);
          },
        ),
        /**
         * Le border proprement dit
         */
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Icône de commande et d'historique
              Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height - (screenSize.height - 30),
                  left: screenSize.width / 50,
                  right: screenSize.width / 50,
//                  right: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return PackSMS();
                          }));
                        }),
                    Stack(
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: MenuDeroulant(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Nom de l'utilisateur
              Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height - (screenSize.height - 25),
                  bottom: screenSize.height - (screenSize.height - 25),
                ),
                child: Center(
                  child: Text(
//                    "Séraphino",
                    "${widget.name}",
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
//                  top: 0,
                  bottom: screenSize.height - (screenSize.height - 10),
                  left: screenSize.width - (screenSize.width - 70),
                  right: screenSize.width - (screenSize.width - 70),
                ),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      "5 SMS disponible(s)",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: screenSize.height / 1.51,
                width: screenSize.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                child: bigTabs[currentlyIndex],
              ),
            ],
          ),
        ),
        /**
         *  Bouton Ajouter
         */
        floatingActionButton: isSelected(0)
            ? null
//              tooltip: 'Increment',
            : isSelected(2)
                ? FloatingActionButton(
                    onPressed: () {
                      MessageModle(context);
                      print("Clique Sur le add Modèle");
                    },
                    //              tooltip: 'Increment',
                    child: Icon(Icons.add_comment),
                  )
                : null);
  }

  /**
   * Les WIdgets du MENU du bas.
   *
   *  @ le Menu Message
   */

  Widget Message() {
    Size taille = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Envoi de SMS",
            textScaleFactor: 2,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
        Container(
          // Hauteur et Largeur du contenu de Instantané et Groupé
          height: taille.height / 1.69,
          width: taille.width / 1.1,
          child: SendMessageForm(),
//            Scaffold(
//              backgroundColor:
//              Colors.grey[400], // la couleur du titre instantané et groupé
//              extendBody: true,
//              /**
//               *  TabBarView utilisant un FloatingActionButton
//               */
//              floatingActionButton: Padding(
//                padding: EdgeInsets.only(
//                  top: 0.0,
//                  bottom: taille.height /
//                      2, // cela permet de fixer la position des boutons instanné et groupé
//                ),
//                child: Container(
//                  width: taille.width / 1.25,
//                  decoration: BoxDecoration(
//                    color: Colors.grey[400],
//                    borderRadius: BorderRadius.all(Radius.circular(25)),
//                  ),
//                  child: TabBar(
//                    indicator: BoxDecoration(
//                      borderRadius: tabBarSelected
//                          ? BorderRadius.only(
//                          topRight: Radius.circular(25),
//                          bottomRight: Radius.circular(25))
//                          : BorderRadius.only(
//                          topLeft: Radius.circular(25),
//                          bottomLeft: Radius.circular(25)),
//                      color: Colors.blue[700],
//                    ),
//                    onTap: (int value) {
////                      print("On clique sur le tab: $value");
////                      print("La valeur du tabBarSelected: $tabBarSelected");
//
//                      setState(() {
//                        value == 1
//                            ? tabBarSelected = true
//                            : tabBarSelected = false;
//                      });
//                    },
//                    tabs: [
//                      /**
//                       * Bouton Instantané
//                       */
//                      Padding(
//                        padding: EdgeInsets.only(
//                          left: 30,
//                        ),
//                        // la table permettant d'identifier les messages instantanés
//                        child: Tab(
//                          child: Container(
//                              decoration: BoxDecoration(
////                            color:  Colors.grey[400] ,
//                                borderRadius: BorderRadius.only(
//                                    topLeft: Radius.circular(25),
//                                    bottomLeft: Radius.circular(25)),
//                              ),
//                              child: Center(
//                                  child: Text(
//                                    "Instantané",
//                                    textScaleFactor: 2,
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 12,
//                                        fontStyle: FontStyle.italic),
//                                  ))),
//                        ),
//                      ),
//                      /**
//                       * Bouton groupé
//                       */
//                      Padding(
//                        padding: EdgeInsets.only(right: 30),
//                        // la tab Permettant d'identifier les message groupés
//                        child: Tab(
//                          child: Container(
//                            decoration: BoxDecoration(
////                          color: Colors.grey[400],
//                              borderRadius: BorderRadius.only(
//                                topRight: Radius.circular(25),
//                                bottomRight: Radius.circular(25),
//                              ),
//                            ),
//                            child: Center(
//                                child: Text(
//                                  "Groupé",
//                                  textScaleFactor: 2,
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontSize: 12,
//                                      fontStyle: FontStyle.italic),
//                                )),
//                          ),
//                        ),
//                      ),
//                    ],
//                    labelPadding: EdgeInsets.all(0.0),
//                    indicatorColor: Colors.white,
//                  ),
//                ),
//              ),
//
//              body: TabBarView(children: [
//                /**
//                 * Appel des Widgets permettant d'afficher les contenues des button instantanée
//                 */
//                TabBarViewInstantaneBody(),
//                TabBarViewGroupeBody(),
//              ]),
//
        ),
//        Container(
//          margin: EdgeInsets.all(10),
//          width: taille.width,
//          height: 2,
//          color: Colors.grey[350],
//        ),
        /**
         * Appel des champs de saisis
         */
      ],
    );
  }

  /**
  * Nouvelle interface pour le formulaire d'envoi de SMS
  * */
  Widget SendMessageForm() {
    Size taille = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        body: Builder(builder:(BuildContext context){
          return ListView(
        children: <Widget>[
          Form(
             key: _InstantaneFormKey,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Selection du contact
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Text(
                    "Choisir Contacts : ",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                /*SizedBox(
                  height: 65,
                  width: 322,
                  child:*/
                //Affichage de la liste des contacts selectionnés
                Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 6.5, top: 5),
                      width: taille.width / 1.4,
                      height: taille.height / 12,
                      decoration: BoxDecoration(
//                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border:
                              Border.all(width: 2, color: Colors.grey[300])),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          Contacts contact = selectedContactsList?.elementAt(index);
                            return Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8,top: 5),
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
//                          color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(width: 2, color: Colors.grey[600], style: BorderStyle.none)
                                    ),
                                    child:
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.clear),
                                            color: Colors.red,
                                            onPressed: (){
                                              setState(() {
                                                selectedContactsList.removeAt(index);
                                                widget.inputsCheck.update(contact.name, (value) => false);
                                              });
                                            },
                                          ),
                                          Text("${contact.name}")
                                        ],
                                      ),
                                  ),
                                  SizedBox(width: 5,)
                                ]);
                            },
                        itemCount: selectedContactsList.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        onTap: (() => alertD(context)),
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            height: taille.height / 12,
                            width: taille.width / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x80000000),
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 3.2),
                                  ),
                                ],
                                color: Color(0xFFFFBF00)
                            ),
                            child: Center(
                              child: Icon(Icons.person_add),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Enregistrement du numéro
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
//                  child: Text(
//                    "Choisir Modèle",
//                    textScaleFactor: 1.3,
//                    style: TextStyle(color: Colors.grey[700]),
//                  ),
                ),
                // Selection du Modèle
//                Container(
//                  padding: EdgeInsets.only(left: 10, right: 10),
//                  width: taille.width / 1.2,
//                  height: taille.height / 18,
//                  decoration: BoxDecoration(
////                          color: Colors.blueAccent,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                      border: Border.all(width: 2, color: Colors.grey[300])),
//                  child: DropdownButtonHideUnderline(
//                    child: DropdownButton(
//                      items: showingModelSms.map((String _items) {
//                        return DropdownMenuItem<String>(
//                          value: _items,
//                          child: Text(
//                            _items,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.grey[500],
//                                fontSize: 20,
//                                fontWeight: FontWeight.w500),
//                          ),
//                        );
//                      }).toList(),
//                      onChanged: (String gettingvalue) {
//                        setState(() {
//                          this.showingContactValue = gettingvalue;
//                        });
//                      },
//                      icon: Icon(
//                        Icons.expand_more,
//                        size: 35,
//                        color: Colors.grey[500],
//                      ),
//                      isExpanded: true,
//                      value: showingContactValue,
//                    ),
//                  ),
//                ),
                SizedBox(
                  height: 5,
                ),
                // Message à envoyer
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, top: 5.0),
                  child: Text(
                    "Contenu du message",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: taille.width / 1.2,
                  height: taille.height / 10,
                  decoration: BoxDecoration(
//                          color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 2, color: Colors.grey[300])),
                  child: TextFormField(

                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(border: InputBorder.none),
//                    keyboardType: TextInputType.text,
                    controller: _contenuMsgController,
                    minLines: 1,
                    maxLines: 3,
                    validator: (String val){
                      if(val.isEmpty){
                        return "veillez entrer un contenu";
                      }
                    },
//                    onSaved: (String value){
//                      _contenuMsgController.text = value;
//                    },
                  ),
                ),
                // Selection du contact
                InkWell(child: Container(
                  margin: EdgeInsets.only(top: 35, bottom: 10),
                  height: taille.height / 18,
                  width: taille.width / 1.2,
                  decoration: BoxDecoration(
//                              color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.amber[700],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20))),
                          child: Center(
                            child: Text(
                              "Valider",
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: taille.height,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20))),
                            child: Icon(
                              Icons.send,
                              size: 30,
                              color: Colors.amber[700],
                            ),
                          )),
                    ],
                  ),
                ),
                  onTap: (){

                    selectedContactsList.forEach((element) {
                      String dest = element.numb.replaceAll(RegExp(r"\s+"), "");
                      if(dest.contains("+225")){
                        dest = dest.substring(1);
                        debugPrint(dest);
                        sendMessage(dest);
                      }else{
                        dest = "225" + dest ;
                        debugPrint(dest);
                        sendMessage(dest);
                      }
                    });
                    if (!_InstantaneFormKey.currentState.validate()) {
                      return;
                    }
                    _InstantaneFormKey.currentState.save();

                    //  Rafraîchissement des champs de saisie
                    setState(() {
                      _contenuMsgController.clear();
                      selectedContactsList = List();
                    });

                    // Afficahge d'un widget pour l'interaction avec l'utilisateur
                    final snackBar = SnackBar(
                      duration: Duration(milliseconds: 2000),
                        content: Container(
                          height: 30,
                            child: Text('Campagne Réussie !',style: TextStyle(color: Colors.white),),
                        )
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }));
  }

  /**
   *  Le conteneur des TabBarViews
   *  @ Message Instantané
   */
//  Widget TabBarViewInstantaneBody() {
//    Size taille = MediaQuery
//        .of(context)
//        .size;
//    return Container(
//      color: Colors.white,
//      height: taille.height,
//      child: ListView(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.only(top: 25, bottom: 10),
//            child: Container(
//              height: 15,
//              width: taille.width,
//            ),
//          ),
//          Form(
//            key: _InstantaneFormKey,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                // Selection du contact
//                Padding(
//                  padding: const EdgeInsets.only(bottom: 2.0),
//                  child: Text(
//                    "Choisir Contacts",
//                    textScaleFactor: 1.3,
//                    style: TextStyle(color: Colors.grey[700]),
//                  ),
//                ),
//
//                /*SizedBox(
//                  height: 65,
//                  width: 322,
//                  child:*/
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      padding: EdgeInsets.only(left: 10, right: 10),
//                      width: taille.width / 1.4,
//                      height: taille.height / 8,
//                      decoration: BoxDecoration(
////                          color: Colors.blueAccent,
//                          borderRadius: BorderRadius.all(Radius.circular(10)),
//                          border: Border.all(width: 2, color: Colors.grey[300])),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(left: 8, top: 12),
//                      child: GestureDetector(
//                        onTapDown: _onTapDown,
//                        onTapUp: _onTapUp,
//                        onTap: (() => alertD(context)),
//                        child: Transform.scale(
//                          scale: _scale,
//                          child: Container(
//                            height: taille.height / 12,
//                            width: taille.width / 6,
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(100),
//                                boxShadow: [
//                                  BoxShadow(
//                                    color: Color(0x80000000),
//                                    blurRadius: 5.0,
//                                    offset: Offset(0.0, 3.2),
//                                  ),
//                                ],
//                                color: Color(0xFFFFBF00)
//                            ),
//                            child: Center(
//                              child: Icon(Icons.person_add),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                /*                FindDropdown<Contacts> (
//                  selectedItem: numbMsg,
//                  items: widget.showContact,
//                  onChanged: (str){
//                    print(widget.inputs[(str)].replaceAll(RegExp(r"\s+"), ""));
//                  },
//                  showSearchBox: true,
//                  labelStyle: TextStyle(color: Colors.white),
//                  backgroundColor: Colors.white,
//                  titleStyle:TextStyle(color: Colors.cyanAccent),
//                  searchBoxDecoration: InputDecoration(
//                    hintText: "Rechercher...",
//                    border: OutlineInputBorder(),
//                  ),
//                  dropdownBuilder: (BuildContext context, Contacts item) {
//                    return ;
//                  },
//                  dropdownItemBuilder:
//                      (BuildContext context, Contacts item, bool isNotSelected) {
//                    return Container(
//                      decoration: !isNotSelected
//                          ? null : BoxDecoration(
//                        border:
//                        Border.all(color: Theme.of(context).primaryColor),
//                        borderRadius: BorderRadius.circular(5),
//                        color: Colors.white,
//                      ),
//                      child: CheckboxListTile(
//                        selected: isNotSelected,
//                        title: Text(item.name),
//                        subtitle: Text(item.numb),
//                      ),
//                    );},
//                ),
//*/
//                // Enregistrement du numéro
//                Padding(
//                  padding: const EdgeInsets.only(bottom: 2.0),
////                  child: Text(
////                    "Choisir Modèle",
////                    textScaleFactor: 1.3,
////                    style: TextStyle(color: Colors.grey[700]),
////                  ),
//                ),
//                // Selection du Modèle
////                Container(
////                  padding: EdgeInsets.only(left: 10, right: 10),
////                  width: taille.width / 1.2,
////                  height: taille.height / 18,
////                  decoration: BoxDecoration(
//////                          color: Colors.blueAccent,
////                      borderRadius: BorderRadius.all(Radius.circular(10)),
////                      border: Border.all(width: 2, color: Colors.grey[300])),
////                  child: DropdownButtonHideUnderline(
////                    child: DropdownButton(
////                      items: showingModelSms.map((String _items) {
////                        return DropdownMenuItem<String>(
////                          value: _items,
////                          child: Text(
////                            _items,
////                            textAlign: TextAlign.center,
////                            style: TextStyle(
////                                color: Colors.grey[500],
////                                fontSize: 20,
////                                fontWeight: FontWeight.w500),
////                          ),
////                        );
////                      }).toList(),
////                      onChanged: (String gettingvalue) {
////                        setState(() {
////                          this.showingContactValue = gettingvalue;
////                        });
////                      },
////                      icon: Icon(
////                        Icons.expand_more,
////                        size: 35,
////                        color: Colors.grey[500],
////                      ),
////                      isExpanded: true,
////                      value: showingContactValue,
////                    ),
////                  ),
////                ),
//                SizedBox(
//                  height: 5,
//                ),
//                // Message à envoyer
//                Padding(
//                  padding: const EdgeInsets.only(bottom: 2.0, top: 5.0),
//                  child: Text(
//                    "Contenu du message",
//                    textScaleFactor: 1.3,
//                    style: TextStyle(color: Colors.grey[700]),
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.only(left: 10, right: 10),
//                  width: taille.width / 1.2,
//                  height: taille.height / 10,
//                  decoration: BoxDecoration(
////                          color: Colors.blueAccent,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                      border: Border.all(width: 2, color: Colors.grey[300])),
//                  child: TextFormField(
//                    textAlign: TextAlign.start,
//                    style: TextStyle(
//                      color: Colors.grey[600],
//                      fontSize: 18,
//                    ),
//                    decoration: InputDecoration(border: InputBorder.none),
//                    keyboardType: TextInputType.text,
//                    minLines: 1,
//                    maxLines: 3,
//                  ),
//                ),
//                // Selection du contact
//                Container(
//                  margin: EdgeInsets.only(top: 35, bottom: 10),
//                  height: taille.height / 18,
//                  width: taille.width / 1.2,
//                  decoration: BoxDecoration(
////                              color: Colors.green,
//                      borderRadius: BorderRadius.all(Radius.circular(20))),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 5,
//                        child: Container(
//                          decoration: BoxDecoration(
//                              color: Colors.amber[700],
//                              borderRadius: BorderRadius.only(
//                                  bottomLeft: Radius.circular(20))),
//                          child: Center(
//                            child: Text(
//                              "Valider",
//                              textScaleFactor: 1.5,
//                              style: TextStyle(
//                                  fontSize: 18,
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w700),
//                            ),
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                          flex: 1,
//                          child: Container(
//                            height: taille.height,
//                            decoration: BoxDecoration(
//                                color: Colors.grey[300],
//                                borderRadius: BorderRadius.only(
//                                    topRight: Radius.circular(20))),
//                            child: Icon(
//                              Icons.send,
//                              size: 30,
//                              color: Colors.amber[700],
//                            ),
//                          )),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  /**
   * @ Message Groupé
   */
//  Widget TabBarViewGroupeBody() {
//    return Container(
//      color: Colors.redAccent,
//      height: MediaQuery
//          .of(context)
//          .size
//          .height,
//      child: Center(
//        child: Text(
//          "Messages groupés",
//          textScaleFactor: 1.5,
//          style: TextStyle(color: Colors.green),
//        ),
//      ),
//    );
//  }

  /**
   * @ le Menu Repertoire
   */
  Widget Repertoire() {
    Size taille = MediaQuery
        .of(context)
        .size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            "Repertoire",
            textScaleFactor: 2,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  /**
   * @ Le Menu Modèle de SMS
   */
  Widget SmsModele() {
    Size taille = MediaQuery
        .of(context)
        .size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            "Modèle de sms",
            textScaleFactor: 2,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ),
        /**
         * Appel des champs de saisis
         */
        FutureBuilder<List>(
          future: GetModel(),
          builder: (context, _list) {
            switch (_list.connectionState) {
              case ConnectionState.waiting:
                return RefreshProgressIndicator();
                break;
              case ConnectionState.done:

                return _list.hasData

//                    ? Text("hasData : ${_list.data[_list.data.length]["id_abonne"]}",textScaleFactor: 1.5,)
                    ? _list.data.isEmpty
                            ? Padding(
                              padding: EdgeInsets.only(top: taille.height/4),
                              child: Text("Aucun SMS enregistrer", textScaleFactor: 1.3,style: TextStyle(fontSize: 20,color: Colors.grey[400],fontStyle: FontStyle.italic,fontWeight: FontWeight.w800),textAlign: TextAlign.center,),
                            )
                            : ModelView(modelList: _list.data)
                    : Padding(
                    padding: EdgeInsets.only(top: taille.height/4),
                     child: Text(
                        "Vous n'êtes pas connecté au serveur",
                        textScaleFactor: 1.4,
                        style: TextStyle(color: Colors.red),
                      ));

                break;
              default:
                return null;
                break;
            }
          },
        ),

//        FutureBuilder(
//            future: GetModel(),
//            builder: (context, ListModel)
//            {
//              return ListTile(
//                title: Card(
//                  elevation: 10.25,
//                  child: Container(
//                      padding: EdgeInsets.all(5),
//                      height: taille.height / 10,
//                      width: taille.width / 1.05,
//                      child: Center(
//                          child: Text(
//                            "Information du modèle",
//                            textScaleFactor: 1.5,
//                          ))),
//                ),
//              );
//            }
//        ),

//        Card(
//          elevation: 10.25,
//          child: Container(
//              padding: EdgeInsets.all(5),
//              height: taille.height / 10,
//              width: taille.width / 1.05,
//              child: Center(
//                  child: Text(
//                "Information sur le modèle",
//                textScaleFactor: 1.5,
//              ))),
//        ),
//                    InformationMenu()
      ],
    );
  }

  /**
   * Widget du menu Déroulant
   */

  Widget MenuDeroulant() {
    return DropdownButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 25,
        ),
        items: paramIconItems.map((String dropDownItem) {
          return DropdownMenuItem<String>(
            value: dropDownItem,
            child: InkWell(
                onTap: () {
                  if (dropDownItem == "Historique") {
                     Navigator.push(context,
                         MaterialPageRoute(builder: (BuildContext context) {
                           return MyStatefulWidget();
                         })
                     );
                  } else if (dropDownItem == "Profil") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Profile(id_abonne: widget.id_abonne, name: widget.name, telephone: widget.telephone, email: widget.email, password: widget.password);
                        })
                    );
                  } else if (dropDownItem == "Déconnexion") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Login();
                        })
                    );
                  }
                },
                child: Text(dropDownItem)),
          );
        }).toList(),
        onChanged: (String newValueDropDown) {
          this.ValueDropDown = newValueDropDown;
        });
  }

  /**
   *  Widget des flatteButton
   *
   *  @ Bouton d'appel du modèle
   */

  void MessageModle(BuildContext context) {
    Size taille = MediaQuery
        .of(context)
        .size;

    var alertDialog = AlertDialog(
      title: Text(
        "Création du Modèle",
        textScaleFactor: 1.2,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            key: _ModeleFormKey,
            child: Container(
              height: taille.height / 2.33,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      labelText: "Titre Modèle",
                    ),
                    validator: (String val){
                      if(val.isEmpty){
                        return "veillez entrer un titre";
                      }
                    },
                    onSaved: (String value){
                      modelTitle = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:15, bottom: 10),
                    child: TextFormField(
                      //                      enableSuggestions: true,
                      decoration: InputDecoration(
                        labelText: "Corps Modèle",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (String val){
                        if(val.isEmpty){
                          return "veillez entrer un message";
                        }
                      },
                      onSaved: (String value){
                        modelContent = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
//            _saveModel();
                          Navigator.of(context).pop();
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
                      // Boutton pour Enregistrer
                      FlatButton(
                        onPressed: () {
                          if (!_ModeleFormKey.currentState.validate()) {
                            return;
                          }
                          _ModeleFormKey.currentState.save();

                          PushModel();
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
            )
          ),
        ),
    );

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

//  void buttonModalModèle(){
//
//  }

//Create Contact class

  /**
   *  Method: Insert model in data
   */

  void PushModel() async{
    var ModelUrl = "https://mobile.e-target-ci.com/register/users/typesms";


    final response = await http.post(
        ModelUrl,
        body: {
          'title' : modelTitle,
          'contenu' : modelContent,
          'id_abonne' : widget.id_abonne
        }
    );

    var data = json.decode(response.body);
    print(
        " Abonne_id: " +
        widget.id_abonne +
        "\n Model title: " +
        modelTitle +
        "\nModel content: " +
        modelContent
    );

    print("\n\n" + data["message"]);

    if (data["status"] == true) {
      Navigator.of(context).pop();
    }
  }

  /**
   *  Method: Select model in data
   */

  Future<List> GetModel() async {
    var getUrl =
        'http://mobile.e-target-ci.com/register/users/modelsms/${widget.id_abonne}';

    final response = await http.get(getUrl);
    final data = response.body;

    return json.decode(data);
  }

  /**
   * Methode to update model
   */

  void UpdateModel($id_model, $id_abonne, $title, $contenu) async {
    var url = "https://mobile.e-target-ci.com/register/users/modelupdate";
    final response = await http.post(url, body: {
      "id": $id_model,
      "id_abonne": $id_abonne,
      "title": $title,
      "contenu": $contenu
    });

    final donnees = json.decode(response.body);
    print("update data: $donnees");
    var leStatus = donnees['status'];
    if(leStatus)
      {
        Navigator.pop(context);
      }
  }

  /**
   *  Methode de suppression de modèle
   */

  void DeleteModel(String id_model) async {
    var deleteUrl ="http://mobile.e-target-ci.com/register/users/modeldelete/${widget.id_abonne}/${id_model}";
    final response = await http.get(deleteUrl);
    var data =  response.body;

    print("Data de suppression: " + data);
    var message = json.decode(data);
    var leStatus = message["status"];
    print("status: $leStatus");
    
    if(leStatus)
    {
      Navigator.pop(context);
    }
  }

  /**
  * Méthode d'envoi de message
  * */

//  _makePostRequest() async {
//    // set up POST request arguments
//    String url = 'https://jsonplaceholder.typicode.com/posts';
//    Map<String, String> headers = {"Content-type": "application/json"};
//    String json = '{"title": "Hello", "body": "body text", "userId": 1}';
//    // make POST request
//    Response response = await post(url, headers: headers, body: json);
//    // check the status code for the result
//    int statusCode = response.statusCode;
//    // this API passes back the id of the new item added to the body
//    String body = response.body;
//    // {
//    //   "title": "Hello",
//    //   "body": "body text",
//    //   "userId": 1,
//    //   "id": 101
//    // }
//  }

  void sendMessage(String dest) async{
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    _from = widget.name;


    final response = await http.post(
        postUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth,
        },
        body: json.encode({
          "messages": [
            {
              'from': _from,
              'destinations': [
                {"messageId": "${widget.id_abonne}", "to": "$dest"}
              ],
              'text': _contenuMsgController.text,
              'notifyUrl': notifyUrl,
              'notifyContentType': notifyContentType,
              'callbackData': callbackData,
            }
          ]
        })
    );

    int retour = json.decode(response.body);
    debugPrint("");
    // debugPrint("voilà le way : ${retour.s}");

  }

  void alertD(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return WillPopScope(
                  // ignore: missing_return
                  onWillPop: (){
                    setState(() {
                      Navigator.pop(context, selectedContactsList);
                    });
                  },
                    child: AlertDialog(
                  title: ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      controller: controllerSearch,
                      decoration: InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: (String val) {
                        setState(() {
                          onSearchTextChanged(val);
                        });
                      },
                    ),

                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        controllerSearch.clear();
                        onSearchTextChanged('');
                        setState(() {
                          searchResultList = widget.showContacts;
                        });
                      },
                    ),
                  ),
                  content: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: 300,
                      child: searchResultList.length != 0 ||
                          controllerSearch.text.isNotEmpty
                          ? ListView.builder(
                        itemBuilder: (context, int index) {
                          Contacts contact = searchResultList?.elementAt(index);
                          return CheckboxListTile(
                            //                key: Key(contact.name),
                            //const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                            title: Text(contact.name ?? ''),
                            //This can be further expanded to showing contacts detail
                            subtitle: Text('${contact.numb}'),
                            value: widget.inputsCheck[contact.name],
                            onChanged: (bool val) {
                              setState(() {
                                widget.inputsCheck[contact.name] = val;
                                debugPrint('${val}');
                                if (val) {
                                  selectedContactsList.add(
                                      searchResultList.elementAt(index));
                                } else {
                                  selectedContactsList.remove(
                                      searchResultList.elementAt(index));
                                }
                                debugPrint('${selectedContactsList}');
                              });
                            },

                          );
                        },
                        itemCount: searchResultList.length,
                      )
                          : ListView.builder(
                        itemBuilder: (context, int index) {
                          Contacts contact = widget.showContacts?.elementAt(
                              index);
                          return CheckboxListTile(
                            //                key: Key(contact.name),
                            //const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                            title: Text(contact.name ?? ''),
                            //This can be further expanded to showing contacts detail
                            subtitle: Text('${contact.numb}'),
                            value: widget.inputsCheck[contact.name],
                            onChanged: (bool val) {
                              setState(() {
                                widget.inputsCheck[contact.name] = val;
                                debugPrint('${val}');
                                if (val) {
                                  selectedContactsList.add(
                                      widget.showContacts.elementAt(index));
                                } else {
                                  selectedContactsList.remove(
                                      widget.showContacts.elementAt(index));
                                }
                                debugPrint('${selectedContactsList}');
                              });
                            },

                          );
                        },
                        itemCount: widget.showContacts.length,
                      )
                  ),
                  actions: <Widget>[
//                    FlatButton(
//                      onPressed: () {
//                        //            _saveModel();
//                        setState(() {
//                          Navigator.pop(context);
//                        });
//                      },
//                      child: Text('Annuler',
//                        textScaleFactor: 1.5,
//                        style: TextStyle(
//                          fontSize: 15,
//                          fontWeight: FontWeight.bold,
//                        ),),
//                      padding: EdgeInsets.only(right: 62),
//                      textColor: Colors.red,
//                    ),
                    // Boutton pour Enregistrer
                    FlatButton(
                      onPressed: (){
                        setState(() {
                          Navigator.pop(context, selectedContactsList);
                        });
                      },
                      child: Text('Enregistrer',
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textColor: Colors.blue,
                      padding: EdgeInsets.only(right: 10),
                    ),
                  ],
                ));
              }
          );
        }
    ).then((val) {
      setState(() {
        selectedContactsList = val;
      });
    });
  }

  onSearchTextChanged(String text) async {
    searchResultList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.showContacts.forEach((userDetail) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase()))
        searchResultList.add(userDetail);
    });

    setState(() {});
  }

// Widget d'afficharge des différents modèles
  Widget  ModelView({List modelList}) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: ListView.builder(
        itemCount: modelList == null  ? 0 : modelList.length,
        itemBuilder: (context, i) {
          return modelList[i]["id_abonne"] == widget.id_abonne
              ? Card(
               color: Colors.grey[200],
//              elevation: 10.25,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    //                    height: MediaQuery.of(context).size.height / 10,
                    //                    width: MediaQuery.of(context).size.width / 1.05,
                    child: ListTile(
                      title: Padding(
                        padding:  EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            "${modelList[i]['title']}",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey[600],
                              ),
                              onTap: (){
                                ShowModle("${modelList[i]['title']}","${modelList[i]['contenu']}");
                                print("Vous voulez voir ${modelList[i]['title']} ?");
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Icon(
                                Icons.mode_edit,
                                color: Colors.blue,
                              ),
                              onTap: () {
                                print("Vous voulez modifier ${modelList[i]['title']} ?");
                                UpdateModle(modelList[i]['id_abonne'],modelList[i]['id'], modelList[i]['title'],modelList[i]['contenu']);
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[400],
                              ),
                              onTap: () {
                                print("Vous voulez supprimer ${modelList[i]['title']} ?");
                                 AskedDeleteModle(modelList[i]['id']);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : null;
        },
      ),
    );
  }

  /**
   * @ SimpleDialog for showing model data
   */
  Future<Null> ShowModle(String title, String des) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
                child: new Text(
              title,
              textScaleFactor: 0.9,
              style: TextStyle(
                color: Colors.amber[700],
                  fontWeight: FontWeight.w800,
                  fontSize: 23,
                  fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline
                ),

              )
            ),
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              Text(
                  des,
                  textScaleFactor: 1.2,
                ),
              SizedBox(height: 10,),
              RaisedButton(
                  child: Text('fermer',textScaleFactor: 1.5,),
                  textColor: Colors.white,
                  color: Colors.amber[700],
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        }
     );
  }

  /**
   * @ SimpleDialog for asking if he want really delete model
   */
  Future<Null> AskedDeleteModle(String id_model) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              Text(
                "voulez vous rééllement supprimer ce model ?",
                textScaleFactor: 1.2,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      child: Text('annuler',textScaleFactor: 1.3,),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: (){
                       Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('supprimer',textScaleFactor: 1.3,),
                    textColor: Colors.white,
                    color: Colors.amber[700],
                    onPressed: (){
                      DeleteModel(id_model);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }
  /**
   * @ methode to update data
   *
   *    recrutement1@weflyagri.com
   */
  void UpdateModle(String id_abonne, String id_model, String titleUpdate, String contentUpdate) {
    Size taille = MediaQuery.of(context).size;

    var alertDialog = AlertDialog(
      title: Text(
        "Modifier le Modèle",
        textScaleFactor: 1.2,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            key: _UpdateModeleFormKey,
            child: Container(
              height: taille.height / 2.33,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: """$titleUpdate""",
                    decoration: InputDecoration(
                      labelText: "titre Modèle",
                    ),
                    enableSuggestions: true,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return "veillez entrer un titre";
                      }
                    },
                    onSaved: (String value) {
                      updatemodelTitle = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: TextFormField(
                      // enableSuggestions: true,
                      initialValue: """$contentUpdate""",
//                      controller: _titleUpdateController,
                      decoration: InputDecoration(
                        labelText: "Corps Modèle",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (String val) {
                        if (val.isEmpty) {
                          return "veillez entrer un message";
                        }
                      },
                      onSaved: (String value) {
                        updatemodelContent = value;
                      },

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                          if (!_UpdateModeleFormKey.currentState.validate()) {
                            return;
                          }
                          _UpdateModeleFormKey.currentState.save();
                           UpdateModel(id_model, id_abonne, updatemodelTitle, updatemodelContent);
                           print("id_model: $id_model\nid_abonne: $id_abonne\ntitleUpdate: $updatemodelTitle\ncontentUpdate: $updatemodelContent");

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
          context: context,
          builder: (BuildContext context) {
            return alertDialog;
          }
       );
  }

}
