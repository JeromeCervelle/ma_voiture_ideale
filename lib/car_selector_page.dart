import 'package:flutter/material.dart';

class CarSelectorPage extends StatefulWidget {
  const CarSelectorPage({super.key});

  @override
  State<CarSelectorPage> createState() {
    return _CarSelectorPageState();
  }
}

class _CarSelectorPageState extends State<CarSelectorPage> {

  String _result = "";
  String _firstName = "";
  double _kms = 0;
  bool _electric = true;
  final List<int> _places = [2, 4, 5, 7];
  int _placesSelected = 2;
  final Map<String, bool> _options = {
    "GPS": false,
    "Caméra de recul": false,
    "Clim par zone": false,
    "Régulateur de vitesse": false,
    "Toit ouvrant": false,
    'Siège chauffant': false,
    "Roue de secours": false,
    "Jantes alu": false
  };

  Car? _carSelected;

  final List<Car> _cars= [
    Car(name: "MG cyberster", url: "MG", places: 2, isElectric: true),
    Car(name: "R5 électrique", url: "R5", places: 4, isElectric: true),
    Car(name: "Tesla", url: "tesla", places: 5, isElectric: true),
    Car(name: "Van VW", url: "Van", places: 7, isElectric: true),
    Car(name: "Alpine", url: "Alpine", places: 2, isElectric: false),
    Car(name: "Fiat 500", url: "Fiat 500", places: 4, isElectric: false),
    Car(name: "Peugeot 3008", url: "P3008", places: 5, isElectric: false),
    Car(name: "Dacia Jogger", url: "Jogger", places: 7, isElectric: false),
  ];

  String? _image;

  Padding _interactiveWidget({required List<Widget> childen, bool isRow = false}) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            (isRow)
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: childen,
            )
            : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: childen,
            ),
            const Divider()
          ],
        ),
    );
  }

  void _updateFirstName(String newValue) {
    setState(() {
      _firstName = newValue;
    });
  }

  void _updateKms(double newValue) {
    setState(() {
      _kms = newValue;
    });
  }

  void _updateEngine(bool newValue) {
    setState(() {
      _electric = newValue;
    });
  }

  void _updatePlace(int? newValue) {
    setState(() {
      _placesSelected = newValue ?? 2;
    });
  }

  void _updateOption(bool? newBool, String key) {
    setState(() {
      _options[key] = newBool ?? false;
    });
  }

  void _handleResult() {
    setState(() {
      _result = isGoodChoice();
      _carSelected = _cars.firstWhere((car) => car.isElectric == _electric && car.places == _placesSelected);
    });
  }

  String isGoodChoice() {
    if (_kms > 15000 && _electric) {
      return "Vous devriez pensez à un moteur thermique compte tenu du nombre de kilomètres";
    } else if (_kms < 5000 && !_electric) {
      return "Vous faites peu de kilmoètres, pensez à regarder les voitures électriques";
    } else {
      return "Voici la voiture faite pour vous";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurateur de voiture"),
        actions: [
          ElevatedButton(
              onPressed: _handleResult,
              child: const Text("Je valide")
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
                "Bienvenue: $_firstName",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(_result),
                    (_carSelected == null)
                        ? const SizedBox(height: 0)
                        :Image.asset(_carSelected!.urlString, fit: BoxFit.contain),
                    Text(_carSelected?.name ?? "Oui Oui mobile")
                  ],
                ),
              ),
            ),
            _interactiveWidget(
                childen: [
                  TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Entrez votre nom"
                    ),
                    onSubmitted: _updateFirstName,
                  )
                ]
            ),
            _interactiveWidget(
                childen: [
                  Text("Nombre de kilomètres annuel: ${_kms.toInt()}"),
                  Slider(
                      min: 0,
                      max: 25000,
                      value: _kms,
                      onChanged: _updateKms
                  )
                ]
            ),
            _interactiveWidget(
              isRow: true,
                childen: [
                  Text(_electric ? "Moteur électrique": "Moteur thermique"),
                  Switch(value: _electric, onChanged: _updateEngine)
                ]
            ),
            _interactiveWidget(
                childen: [
                  Text('Nombre de places: $_placesSelected'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: _places.map((place) {
                      return Column(
                        children: [
                          Radio(
                              value: place,
                              groupValue: _placesSelected,
                              onChanged: _updatePlace
                          )
                        ],
                      );
                    }).toList(),
                  )
                ]
            ),
            _interactiveWidget(
                childen: [
                  const Text("Options du véhicule"),
                  Column(
                    children: _options.keys.map((key) {
                      return CheckboxListTile(
                          title: Text(key),
                          value: _options[key],
                          onChanged: ((b) => _updateOption(b, key))
                      );
                    }).toList()
                  )
                ]
            )
          ],
        ),
      ),
    );
  }
}

class Car {
  String name;
  String url;
  int places;
  bool isElectric;

  Car({required this.name, required this.url, required this.places, required this.isElectric});

  String get urlString => "assets/$url.jpg";
}