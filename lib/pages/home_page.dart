import 'package:flutter/material.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/cube_grid.dart';
import '../controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  final UserController userController;

  HomePage({required this.userController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool userExists = false;
  String userName = '';
  bool isLoading = false; // Pour afficher un indicateur de chargement lors de la création d'un utilisateur

  @override
  void initState() {
    super.initState();
    _checkUserExists();
  }

  // Vérifier si un utilisateur existe
  Future<void> _checkUserExists() async {
    await widget.userController.openBox();
    setState(() {
      userExists = widget.userController.isUserAlreadyExists();
      if (userExists) {
        userName = widget.userController.getUserName(); // Récupérer le nom de l'utilisateur si disponible
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment(-0.8, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Performance-Day',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(height: 200, child: LineChartWidget(userController: widget.userController)),
                Container(child: CubeGrid()),
              ],
            ),
          ),
          // Si l'utilisateur existe, afficher son nom dans un box
          if (userExists)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.blue,  // Fond du box
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Nom de l'utilisateur: $userName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Si l'utilisateur n'existe pas, afficher le bouton pour créer un utilisateur
          if (!userExists && !isLoading)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ButtonTheme.fromButtonThemeData(
                    data: ButtonTheme.of(context).copyWith(
                      buttonColor: Colors.blue,
                      textTheme: ButtonTextTheme.primary,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        createLog(context);
                      },
                      child: Text('Créer un utilisateur'),
                    ),
                  ),
                ),
              ),
            ),
          // Afficher un indicateur de chargement pendant la création de l'utilisateur
          if (isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  // Afficher un dialogue pour saisir un nom d'utilisateur
  void createLog(BuildContext context) {
    String title = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Écrivez votre nom'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(hintText: 'Votre nom'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (title.isNotEmpty) {
                              setState(() {
                                isLoading = true; // Afficher un indicateur de chargement
                              });
                              try {
                                await widget.userController.createUser(title);
                                // Attendre la création avant de fermer la fenêtre de dialogue
                                await _checkUserExists();  // Recharger les informations sur l'utilisateur
                                Navigator.pop(context);
                                setState(() {
                                  userExists = true; // L'utilisateur est créé
                                  userName = title;  // Mettre à jour le nom de l'utilisateur
                                  isLoading = false; // Cacher l'indicateur de chargement
                                });
                              } catch (e) {
                                // Gérer une erreur éventuelle
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de la création de l'utilisateur")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Veuillez entrer un nom")),
                              );
                            }
                          },
                          child: Text('Créer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
