import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  // Hive.defaultDirectory = directory.path;
  Hive.init(directory.path);


  runApp(BeeApp());
}


class BeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bee Favorites',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: FavoriteFlowers(),
    );
  }
}

class FavoriteFlowers extends StatefulWidget {
  @override
  _FavoriteFlowersState createState() => _FavoriteFlowersState();
}



class _FavoriteFlowersState extends State<FavoriteFlowers> {
 // final Box<String> favoriteBox = Hive.openBox<String>('Favorites');
  var favoriteBox ;

  final List<String> flowers = ['Rose', 'Tulip', 'Daisy', 'Lily', 'Sunflower'];


  void getItems() async {
    favoriteBox = await Hive.openBox<String>('favorites'); // open box


  }

  @override
  void initState() {
    super.initState();

    getItems();
  }


  @override
  Widget build(BuildContext context) {
    Hive.openBox('favoriteBox');
    return Scaffold(
      appBar: AppBar(title: const Text('Bee Favorites 🐝')),
      body: ListView.builder(
        itemCount: flowers.length,
        itemBuilder: (context, index) {
          final flower = flowers[index];
          return ListTile(
            title: Text(flower),
            trailing: IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                favoriteBox.add(flower);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$flower added to favorites! 🌼')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.view_list),
        onPressed: () {
          var allKeys = favoriteBox.keys ;
          showDialog(
            context: context,
            builder: (context) {

            return  FavoritesDialog(favorites: favoriteBox.values.toList());
            },
          );
        },
      ),
    );
  }
}

class FavoritesDialog extends StatelessWidget {
  final List<String> favorites;

  const FavoritesDialog({required this.favorites});

  @override
  Widget build(BuildContext context) {
    print(favorites);
    return AlertDialog(
      title: const Text('Bee Favorites 🌼'),
      content: SizedBox(
        width: 300,
        height: 200,
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(favorites[index]!));
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
