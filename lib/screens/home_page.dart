import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/storage_page.dart';
import 'package:whats_in_my_fridge/screens/redirect_page.dart';
import 'package:whats_in_my_fridge/screens/recipe_view.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';
import 'package:whats_in_my_fridge/widgets/bottom_navbar.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe_model.dart';
import '../widgets/navigation_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_in_my_fridge/utilities/food_logic.dart';
import 'package:whats_in_my_fridge/widgets/expiration_date_message.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _currentUser;

  List<RecipeModel> recipes = <RecipeModel>[];

  late String ingridents;
  bool _loading = false;

  ///input from recipe-search
  String query = "";
  TextEditingController recipeSearchController = new TextEditingController();

//  String applicationId = "fe4d49fb";
//  String applicationKey = "a69ae39077969bd8cf29bc34ce2d6816";

  getRecipes(String query) async {
    ///Clears recipe list
    recipes.clear();

    String url =
        "https://api.edamam.com/search?q=$query&app_id=fe4d49fb&app_key=a69ae39077969bd8cf29bc34ce2d6816";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    ///Checks every recipe that contains the key words
    jsonData["hits"].forEach((element) {
      //print(element.toString());

      RecipeModel recipeModel =
          new RecipeModel(url: '', source: '', image: '', label: '');
      recipeModel = RecipeModel.fromMap(element["recipe"]);

      ///Adds recipe to list
      recipes.add(recipeModel);
    });

    ///Sets the state and reloads the page
    setState(() {});

    print("${recipes.toString()}");
  }

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  Future<String?> getID() async {
    String? userID = await FireAuth.getCurrentUserID();
    return userID;
  }

  String id = "";

  void getIDAsString() async {
    id = (await getID())!;
  }

  @override
  Widget build(BuildContext context) {
    var _foodItems;
    return LayoutBuilder(
        builder: (context, boxConstraints) {
          double titleFontSize = 30.0;
          double headerSize = 26.0;
          double textSize = 18.0;
          double expTextSize = 14.0;

          if (boxConstraints.maxWidth < 400) {
            titleFontSize = 28.0;
            headerSize = 24.0;
            textSize = 16.0;
            expTextSize = 12.0;
          }


          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: Text(
                'Whats in my fridge',
                style: GoogleFonts.pacifico(fontSize: titleFontSize),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          'Welcome back',
                          style: GoogleFonts.openSans(
                              fontSize: headerSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.green),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${_currentUser.displayName}',
                          style: GoogleFonts.openSans(
                            fontSize: headerSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Here are some of your available food items that expire soon",
                      style: GoogleFonts.openSans(fontSize: textSize),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Section displaying stored foods on homepage.
                    Container(
                      height: 250,
                      // decoration: BoxDecoration(
                      //     border: Border(left: BorderSide(color: Colors.black))
                      // ),
                      child: StreamBuilder(
                          stream: foodItems
                              .orderBy(CurrentStringSortSelected)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            getIDAsString();
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount: streamSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];

                                    return Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: (documentSnapshot["User ID"] ==
                                          _currentUser.uid &&
                                          FoodLogic.expirationDifferenceInSeconds(documentSnapshot) < 60*60*24*7)
                                          ? Card(
                                        child: InkWell(
                                          onTap: () => {
                                            getRecipes(documentSnapshot["Product Name"]),
                                          },
                                          child: ListTile(
                                            title: Stack(
                                              children: [
                                                Text(
                                                  documentSnapshot['Product Name'],
                                                  style: TextStyle(fontSize: textSize),
                                                ),
                                                Align(alignment: Alignment.centerRight, child:
                                                ExpirationDateMessage(documentSnapshot: documentSnapshot, fontSize: expTextSize,))
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                    );
                                  });
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Enter your ingredients or click the items above and we will show the best recipes for you',
                        style: GoogleFonts.openSans(fontSize: textSize)),
                    SizedBox(
                      height: 20,
                    ),

                    /// Searchfield for recipe-searches
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: recipeSearchController,
                              decoration: InputDecoration(
                                hintText: 'Enter Ingridients',
                                hintStyle: TextStyle(fontSize: 18),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: GoogleFonts.openSans(),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),

                          /// onTap trigger Recipe-search based on the content of the textfield
                          InkWell(
                            onTap: () async {
                              if (recipeSearchController.text.isNotEmpty) {
                                getRecipes(recipeSearchController.text);
                                print("Just do it");
                              } else {
                                print("Just dont do it");
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.search,
                                size: 40,
                                color: Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    /// Section for recipes from API-search shown in a grid.
                    Container(
                      child: GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                              child: RecipeTile(
                                title: recipes[index].label,
                                imgUrl: recipes[index].image,
                                desc: recipes[index].source,
                                url: recipes[index].url,
                              ));
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String url, desc, title, imgUrl;

  RecipeTile(
      {required this.url,
      required this.desc,
      required this.title,
      required this.imgUrl});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    if (kDebugMode) {
      print(url);
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///onTap push navigator to webpage url showing original recipe from API.
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 180,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {required this.topColor,
      required this.bottomColor,
      required this.topColorCode,
      required this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
