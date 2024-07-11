import 'package:flutter/material.dart';
import 'package:study_app/data/space_data.dart';
import '../data/fish_data.dart';
import '../data/station_data.dart';
import '../data/japan_prefectures.dart';
import '../models/app_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String? selectedDataSet;
  List<AppCard>? currentData;
  String? selectedQuestionAttribute;
  String? selectedAnswerAttribute;

  final Map<String, List<AppCard>> dataSets = {
    'Fish Data': fishData,
    'Station Data': stationData,
    'Space Data': spaceData,
    'Japanese Prefectures': japanPrefecturesData
  };

  @override
  void initState() {
    super.initState();
    selectedDataSet = dataSets.entries.first.key;
    currentData = dataSets.entries.first.value;
    selectedQuestionAttribute = currentData?.first.getNonNullAttributes()[0];
    selectedAnswerAttribute = currentData?.first.getNonNullAttributes()[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: const Text('Select Data Set'),
              value: selectedDataSet,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDataSet = newValue;
                  currentData = dataSets[newValue];
                  selectedQuestionAttribute = currentData?.first.getNonNullAttributes()[0];;
                  selectedAnswerAttribute = currentData?.first.getNonNullAttributes()[1];
                });
              },
              items: dataSets.keys.map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (currentData != null) ...[
              const Text('Select Question Attribute'),
              DropdownButton<String>(
                hint: const Text('Select Question Attribute'),
                value: selectedQuestionAttribute,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedQuestionAttribute = newValue;
                  });
                },
                items: _getAvailableAttributes(currentData!)
                    .map<DropdownMenuItem<String>>((String attribute) {
                  return DropdownMenuItem<String>(
                    value: attribute,
                    child: Text(attribute),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Select Answer Attribute'),
              DropdownButton<String>(
                hint: const Text('Select Answer Attribute'),
                value: selectedAnswerAttribute,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAnswerAttribute = newValue;
                  });
                },
                items: _getAvailableAttributes(currentData!)
                    .map<DropdownMenuItem<String>>((String attribute) {
                  return DropdownMenuItem<String>(
                    value: attribute,
                    child: Text(attribute),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    {
                      'data': currentData,
                      'questionAttribute': selectedQuestionAttribute,
                      'answerAttribute': selectedAnswerAttribute,
                    },
                  );
                },
                child: const Text('Save Settings'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> _getAvailableAttributes(List<AppCard> data) {
    // Get the union of all non-null attributes across all AppCard instances
    return data.expand((card) => card.getNonNullAttributes()).toSet().toList();
  }
}
