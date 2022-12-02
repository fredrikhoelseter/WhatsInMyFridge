import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/storage_page.dart';
import 'package:whats_in_my_fridge/screens/login_page.dart';
import 'package:whats_in_my_fridge/screens/recipe_view.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/widgets/bottom_navbar.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe_model.dart';
import '../widgets/navigation_buttons.dart';

class HomePage extends StatefulWidget {
  final User user;


  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  bool _isDeletingUser = false;
  bool _isResettingPassword = false;

  late User _currentUser;

  List<RecipeModel> recipes = <RecipeModel>[];

  late String ingridents;
  bool _loading = false;
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

    ///Checks every recipe that contains the key words(?)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: Text('Whats in my fridge'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${_currentUser.displayName}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text("Here are some of your available food items stored in your containers: "),
              SizedBox(
                height: 100,
                width: 400,
                child: Container(padding: EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.red),
                  child: Text("Maybe display items in storage here some way"),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                  'Just enter ingredrients you have and we will show the best recipe for you'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: recipeSearchController,
                        decoration: InputDecoration(
                            hintText: 'Enter Ingridients',
                            hintStyle: TextStyle(fontSize: 18)),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
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
                        child: Icon(Icons.search),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
      // floatingActionButton: NavigationButtons(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
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
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                     builder: (context) => RecipeView(postUrl: widget.url,))
              );
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
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 14,
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
