import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../views/default_page_wrapper.dart';
import '../../../game_system_view_model.dart';
import '../open_5e_collection_repository.dart';

class Open5eRaceModel {
  final String name;
  final String slug;
  final String desc;
  final String asiDesc;
  final List<AbilityScoreIncrease> asi;
  final String age;
  final String alignment;
  final String size;
  final String sizeRaw;
  final Speed speed;
  final String speedDesc;
  final String languages;
  final String vision;
  final String traits;
  final List<dynamic> subraces;
  final String documentSlug;
  final String documentTitle;
  final String documentLicenseUrl;
  final String documentUrl;

  Open5eRaceModel({
    required this.name,
    required this.slug,
    required this.desc,
    required this.asiDesc,
    required this.asi,
    required this.age,
    required this.alignment,
    required this.size,
    required this.sizeRaw,
    required this.speed,
    required this.speedDesc,
    required this.languages,
    required this.vision,
    required this.traits,
    required this.subraces,
    required this.documentSlug,
    required this.documentTitle,
    required this.documentLicenseUrl,
    required this.documentUrl,
  });

  factory Open5eRaceModel.fromMap(Map<String, dynamic> json) {
    return Open5eRaceModel(
      name: json['name'],
      slug: json['slug'],
      desc: json['desc'],
      asiDesc: json['asi_desc'],
      asi: (json['asi'] as List)
          .map((asi) => AbilityScoreIncrease.fromMap(asi))
          .toList(),
      age: json['age'],
      alignment: json['alignment'],
      size: json['size'],
      sizeRaw: json['size_raw'],
      speed: Speed.fromMap(json['speed']),
      speedDesc: json['speed_desc'],
      languages: json['languages'],
      vision: json['vision'],
      traits: json['traits'],
      subraces: List<dynamic>.from(json['subraces']),
      documentSlug: json['document__slug'],
      documentTitle: json['document__title'],
      documentLicenseUrl: json['document__license_url'],
      documentUrl: json['document__url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'desc': desc,
      'asi_desc': asiDesc,
      'asi': asi.map((asi) => asi.toMap()).toList(),
      'age': age,
      'alignment': alignment,
      'size': size,
      'size_raw': sizeRaw,
      'speed': speed.toMap(),
      'speed_desc': speedDesc,
      'languages': languages,
      'vision': vision,
      'traits': traits,
      'subraces': subraces,
      'document__slug': documentSlug,
      'document__title': documentTitle,
      'document__license_url': documentLicenseUrl,
      'document__url': documentUrl,
    };
  }
}

class AbilityScoreIncrease {
  final List<String> attributes;
  final int value;

  AbilityScoreIncrease({
    required this.attributes,
    required this.value,
  });

  factory AbilityScoreIncrease.fromMap(Map<String, dynamic> json) {
    return AbilityScoreIncrease(
      attributes: List<String>.from(json['attributes']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attributes': attributes,
      'value': value,
    };
  }
}

class Speed {
  final int walk;

  Speed({required this.walk});

  factory Speed.fromMap(Map<String, dynamic> json) {
    return Speed(
      walk: json['walk'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'walk': walk,
    };
  }
}

class Open5eRaceWidget extends StatelessWidget {
  final Open5eRaceModel race;

  const Open5eRaceWidget({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(race.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Description'),
              subtitle: Text(race.desc),
            ),
            ListTile(
              title: Text('Size'),
              subtitle: Text(race.size),
            ),
            ListTile(
              leading: Icon(GameSystemViewModel.speed.icon),
              title: Text('Speed'),
              subtitle: Text('${race.speed.walk} ft'),
            ),
            ListTile(
              title: Text('Alignment'),
              subtitle: Text(race.alignment),
            ),
            ListTile(
              title: Text('Languages'),
              subtitle: Text(race.languages),
            ),
            ListTile(
              title: Text('Traits'),
              subtitle: Text(race.traits),
            ),
            ListTile(
              title: Text('Subraces'),
              subtitle: Text(race.subraces.join(', ')),
            ),
            ListTile(
              title: Text('Document'),
              subtitle: Text('${race.documentTitle} (${race.documentSlug})'),
            ),
          ],
        ),
      ),
    );
  }
}

class Open5eRacePage extends ConsumerWidget {
  const Open5eRacePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final races = ref.watch(open5eRacesProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: Text("Races"),
      ),
      body: DefaultPageWrapper(
        future: races,
        builder: (context, data) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemBuilder: (context, index) {
            final raceModel = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(raceModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(raceModel.name),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Open5eRaceWidget(
                              race: raceModel,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
