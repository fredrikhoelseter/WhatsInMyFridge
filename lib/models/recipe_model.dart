class RecipeModel {

  String label;
  String image;
  String source;
  String url;

  RecipeModel({required this.url, required this.source, required this.image, required this.label});

  factory RecipeModel.fromMap(Map<String, dynamic> parseJson){
    return RecipeModel(
      url: parseJson["url"],
      label: parseJson["label"],
      image: parseJson["image"],
      source: parseJson["source"]
    );
  }
}