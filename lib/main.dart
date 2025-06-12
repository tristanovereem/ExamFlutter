import 'package:flutter/material.dart';
import 'uitkomst.dart';
import 'settings.dart';

void main() {
  // Start de app met de widget AppRoot
  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Variabelen voor invoerwaarde en eenheden
  double _inputValue = 0;
  String _fromUnit = 'kg';
  String _toUnit = 'g';

  // Thema (donker/licht)
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // TabController voor 3 tabbladen aanmaken
    _tabController = TabController(length: 3, vsync: this);
  }

  // Functie om conversiegegevens te updaten en naar het resultaat tabblad te gaan
  void _updateConversion(double inputValue, String fromUnit, String toUnit) {
    setState(() {
      _inputValue = inputValue;
      _fromUnit = fromUnit;
      _toUnit = toUnit;
    });

    _tabController.animateTo(1); // Ga naar het tweede tabblad (uitkomst)
  }

  // Functie om thema te toggelen
  void _toggleTheme(bool newValue) {
    setState(() {
      _isDarkMode = newValue;
    });
  }

  // Kies icoon afhankelijk van gewicht
  IconData getIconForWeight(double weight) {
    if (weight < 10) return Icons.eco;
    if (weight < 100) return Icons.fitness_center;
    if (weight < 1000) return Icons.scale;
    return Icons.local_shipping;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Verberg debug banner
      title: 'Converter App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Converter App'), // Titel bovenaan
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: _isDarkMode ? Colors.white : Colors.black,
            labelColor: _isDarkMode ? Colors.white : Colors.black,
            tabs: const [
              Tab(icon: Icon(Icons.compare_arrows_sharp)), // Tab 1: Converter
              Tab(icon: Icon(Icons.call_to_action)),        // Tab 2: Uitkomst
              Tab(icon: Icon(Icons.settings)),               // Tab 3: Instellingen
            ],
          ),
        ),
        body: Container(
          // Achtergrond afbeelding voor de hele body
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/examenbackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(24),
                  // Transparante grijze achtergrond met afgeronde hoeken
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ConverterTab(
                    onConvert: _updateConversion,
                    getIconForWeight: getIconForWeight,
                  ),
                ),
              ),

              // Uitkomst tab met grijze achtergrond en rand
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black45, width: 2),
                  ),
                  child: Uitkomst(
                    inputValue: _inputValue,
                    fromUnit: _fromUnit,
                    toUnit: _toUnit,
                  ),
                ),
              ),

              // Instellingen tab
              Settings(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConverterTab extends StatefulWidget {
  final void Function(double, String, String) onConvert;
  final IconData Function(double) getIconForWeight;

  const ConverterTab({required this.onConvert, required this.getIconForWeight, Key? key}) : super(key: key);

  @override
  State<ConverterTab> createState() => _ConverterTabState();
}

class _ConverterTabState extends State<ConverterTab> {
  final TextEditingController _ctrl = TextEditingController();
  String? _errorText;

  final List<String> _units = ['kg', 'g', 'lb', 'oz']; // Beschikbare eenheden
  String _fromUnit = 'kg';
  String _toUnit = 'g';

  double _inputValue = 0;

  // Actie bij drukken op de knop
  void _onPressed() {
    final inputText = _ctrl.text.replaceAll(',', '.');
    final value = double.tryParse(inputText);

    if (value == null) {
      setState(() {
        _errorText = 'Voer een geldig getal in'; // Foutmelding voor ongeldige invoer
      });
      return;
    }

    if (value > 100000) {
      setState(() {
        _errorText = 'Maximum is 100.000'; // Max limiet melding
      });
      return;
    }

    if (_fromUnit == _toUnit) {
      setState(() {
        _errorText = 'Eenheden mogen niet hetzelfde zijn'; // Waarschuw als dezelfde eenheid gekozen is
      });
      return;
    }

    // Geen fouten, update invoerwaarde en roep conversie aan
    setState(() {
      _errorText = null;
      _inputValue = value;
    });

    widget.onConvert(value, _fromUnit, _toUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icoon dat verandert met de invoerwaarde
            Icon(widget.getIconForWeight(_inputValue), size: 30),
            const SizedBox(width: 12),

            // Tekstveld voor invoer
            SizedBox(
              width: 150,
              child: TextField(
                controller: _ctrl,
                decoration: InputDecoration(
                  labelText: 'Waarde',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                onChanged: (text) {
                  // Update icoon als de waarde verandert
                  final val = double.tryParse(text.replaceAll(',', '.')) ?? 0;
                  setState(() => _inputValue = val);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Dropdowns voor van-en naar-eenheden
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Van:'),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _fromUnit,
              onChanged: (value) => setState(() => _fromUnit = value!),
              items: _units
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                  .toList(),
            ),
            const SizedBox(width: 20),
            const Text('Naar:'),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _toUnit,
              onChanged: (value) => setState(() => _toUnit = value!),
              items: _units
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Knop om resultaat te tonen
        ElevatedButton(
          onPressed: _onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('Uitkomst', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
