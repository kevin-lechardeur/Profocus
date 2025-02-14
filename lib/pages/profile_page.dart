import 'package:flutter/material.dart';
import 'package:project/controllers/transaction_controller.dart';
import '../controllers/appcontroller.dart';
import 'history_page.dart';
import '../models/habit.dart';
class ProfilePage extends StatefulWidget {
  final AppController appController;

  ProfilePage({required this.appController});

  @override
  _ProfileStatePage createState() => _ProfileStatePage();
}

class _ProfileStatePage extends State<ProfilePage> {
  // Fonction pour générer une liste de mois, à partir du mois actuel (afficher les 4 derniers mois)
  List<String> getLastMonths() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 4; i++) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      String monthName = _getMonthName(month.month);
      months.add(monthName);
    }

    return months;
  }
  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return "Janvier";
      case 2:
        return "Février";
      case 3:
        return "Mars";
      case 4:
        return "Avril";
      case 5:
        return "Mai";
      case 6:
        return "Juin";
      case 7:
        return "Juillet";
      case 8:
        return "Août";
      case 9:
        return "Septembre";
      case 10:
        return "Octobre";
      case 11:
        return "Novembre";
      case 12:
        return "Décembre";
      default:
        return "Mois";
    }
  }
  DateTime getFirstDayOfMonth(String monthName) {
    int monthNumber = _getMonthNumber(monthName);
    DateTime now = DateTime.now();
    int year = now.year;
    if (monthNumber > now.month) {
      year = now.year - 1;
    }

    return DateTime(year, monthNumber, 1);
  }

  int _getMonthNumber(String monthName) {
    switch (monthName) {
      case "Janvier":
        return 1;
      case "Février":
        return 2;
      case "Mars":
        return 3;
      case "Avril":
        return 4;
      case "Mai":
        return 5;
      case "Juin":
        return 6;
      case "Juillet":
        return 7;
      case "Août":
        return 8;
      case "Septembre":
        return 9;
      case "Octobre":
        return 10;
      case "Novembre":
        return 11;
      case "Décembre":
        return 12;
      default:
        return 1; // Par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    Habit? habit = widget.appController.getHabitAvecLePlusDeJoursFaits();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(8.0),
          child: Text(
            'Profil \nRien',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.blue,
            child: habit == null
                ? Text("Aucune habitude n'a été ajoutée")
                : Text(
              "${widget.appController.getHabitName(habit)} - L'habitude + fait "
                  "\nMax Streak : ${widget.appController.getNombreConsecutive(habit)}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Historique Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 120,
          color: Colors.black45,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...getLastMonths().map((monthName) {
                  return InkWell(
                    onTap: () async {
                      DateTime selectedDate = getFirstDayOfMonth(monthName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage(
                            appController : widget.appController,
                            date: selectedDate)
                        ),
                      );
                    },
                    child: Container(
                      width: 150, // Largeur du rectangle
                      margin: EdgeInsets.all(8.0), // Marge entre les éléments
                      decoration: BoxDecoration(
                        color: Colors.blue, // Couleur dynamique
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(monthName, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Ajout de l'élément "Voir plus"
                InkWell(
                  onTap: () {
                    print("Voir plus cliqué");
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey, // Couleur de fond pour le bouton "Voir plus"
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Voir plus", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
