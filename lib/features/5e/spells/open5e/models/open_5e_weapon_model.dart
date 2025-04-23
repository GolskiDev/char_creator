import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../views/default_page_wrapper.dart';
import '../open_5e_collection_repository.dart';

class Open5eWeaponModel {
  final String name;
  final String slug;
  final String category;
  final String documentSlug;
  final String documentTitle;
  final String documentLicenseUrl;
  final String documentUrl;
  final String cost;
  final String damageDice;
  final String damageType;
  final String weight;
  final List<String>? properties;

  Open5eWeaponModel({
    required this.name,
    required this.slug,
    required this.category,
    required this.documentSlug,
    required this.documentTitle,
    required this.documentLicenseUrl,
    required this.documentUrl,
    required this.cost,
    required this.damageDice,
    required this.damageType,
    required this.weight,
    required this.properties,
  });

  factory Open5eWeaponModel.fromMap(Map<String, dynamic> json) {
    return Open5eWeaponModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      category: json['category'] as String,
      documentSlug: json['document__slug'] as String,
      documentTitle: json['document__title'] as String,
      documentLicenseUrl: json['document__license_url'] as String,
      documentUrl: json['document__url'] as String,
      cost: json['cost'] as String,
      damageDice: json['damage_dice'] as String,
      damageType: json['damage_type'] as String,
      weight: json['weight'] as String,
      properties: List<String>.from(json['properties'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'category': category,
      'document__slug': documentSlug,
      'document__title': documentTitle,
      'document__license_url': documentLicenseUrl,
      'document__url': documentUrl,
      'cost': cost,
      'damage_dice': damageDice,
      'damage_type': damageType,
      'weight': weight,
      'properties': properties,
    };
  }
}

class Open5eWeaponWidget extends StatelessWidget {
  final Open5eWeaponModel weapon;

  const Open5eWeaponWidget({Key? key, required this.weapon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(weapon.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Category'),
              subtitle: Text(weapon.category),
            ),
            ListTile(
              title: Text('Damage'),
              subtitle: Text('${weapon.damageDice} (${weapon.damageType})'),
            ),
            ListTile(
              title: Text('Weight'),
              subtitle: Text(weapon.weight),
            ),
            ListTile(
              title: Text('Cost'),
              subtitle: Text(weapon.cost),
            ),
            if (weapon.properties != null)
              ListTile(
                title: Text('Properties'),
                subtitle: Text(weapon.properties!.join(', ')),
              ),
            ListTile(
              title: Text('Document'),
              subtitle:
                  Text('${weapon.documentTitle} (${weapon.documentSlug})'),
            ),
          ],
        ),
      ),
    );
  }
}

class Open5eWeaponPage extends ConsumerWidget {
  const Open5eWeaponPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weapons = ref.watch(open5eWeaponsProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: Text("Weapons"),
      ),
      body: DefaultPageWrapper(
        future: weapons,
        builder: (context, data) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemBuilder: (context, index) {
            final weaponModel = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(weaponModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(weaponModel.name),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Open5eWeaponWidget(
                              weapon: weaponModel,
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
