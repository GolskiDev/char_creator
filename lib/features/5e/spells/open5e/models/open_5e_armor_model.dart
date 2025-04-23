import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../views/default_page_wrapper.dart';
import '../../../game_system_view_model.dart';
import '../open_5e_collection_repository.dart';

class Open5eArmorModel {
  final String name;
  final String slug;
  final String category;
  final String documentSlug;
  final String documentTitle;
  final String documentLicenseUrl;
  final String documentUrl;
  final int baseAc;
  final bool plusDexMod;
  final bool plusConMod;
  final bool plusWisMod;
  final int plusFlatMod;
  final int plusMax;
  final String acString;
  final int? strengthRequirement;
  final String cost;
  final String weight;
  final bool stealthDisadvantage;

  Open5eArmorModel({
    required this.name,
    required this.slug,
    required this.category,
    required this.documentSlug,
    required this.documentTitle,
    required this.documentLicenseUrl,
    required this.documentUrl,
    required this.baseAc,
    required this.plusDexMod,
    required this.plusConMod,
    required this.plusWisMod,
    required this.plusFlatMod,
    required this.plusMax,
    required this.acString,
    this.strengthRequirement,
    required this.cost,
    required this.weight,
    required this.stealthDisadvantage,
  });

  factory Open5eArmorModel.fromMap(Map<String, dynamic> json) {
    return Open5eArmorModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      category: json['category'] as String,
      documentSlug: json['document__slug'] as String,
      documentTitle: json['document__title'] as String,
      documentLicenseUrl: json['document__license_url'] as String,
      documentUrl: json['document__url'] as String,
      baseAc: json['base_ac'] as int,
      plusDexMod: json['plus_dex_mod'] as bool,
      plusConMod: json['plus_con_mod'] as bool,
      plusWisMod: json['plus_wis_mod'] as bool,
      plusFlatMod: json['plus_flat_mod'] as int,
      plusMax: json['plus_max'] as int,
      acString: json['ac_string'] as String,
      strengthRequirement: json['strength_requirement'] != null
          ? (json['strength_requirement'] as int)
          : null,
      cost: json['cost'] as String,
      weight: json['weight'] as String,
      stealthDisadvantage: json['stealth_disadvantage'] as bool,
    );
  }
}

class Open5eArmorWidget extends StatelessWidget {
  final Open5eArmorModel armor;

  const Open5eArmorWidget({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(armor.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Category'),
              subtitle: Text(armor.category),
            ),
            ListTile(
              leading: Icon(GameSystemViewModel.armorClass.icon),
              title: Text('Base AC'),
              subtitle: Text('${armor.baseAc}'),
            ),
            ListTile(
              title: Text('Modifiers'),
              subtitle: Text(
                  'Dex: ${armor.plusDexMod ? "Yes" : "No"}, Con: ${armor.plusConMod ? "Yes" : "No"}, '
                  'Wis: ${armor.plusWisMod ? "Yes" : "No"}, Flat: ${armor.plusFlatMod}, Max: ${armor.plusMax}'),
            ),
            ListTile(
              title: Text('Strength Requirement'),
              subtitle: Text(armor.strengthRequirement?.toString() ?? 'None'),
            ),
            ListTile(
              title: Text('Weight'),
              subtitle: Text(armor.weight),
            ),
            ListTile(
              title: Text('Cost'),
              subtitle: Text(armor.cost),
            ),
            ListTile(
              title: Text('Stealth Disadvantage'),
              subtitle: Text(armor.stealthDisadvantage ? 'Yes' : 'No'),
            ),
            ListTile(
              title: Text('Document'),
              subtitle: Text('${armor.documentTitle} (${armor.documentSlug})'),
            ),
          ],
        ),
      ),
    );
  }
}

class Open5eArmorPage extends ConsumerWidget {
  const Open5eArmorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armors = ref.watch(open5eArmorsProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: Text("Armors"),
      ),
      body: DefaultPageWrapper(
        future: armors,
        builder: (context, data) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemBuilder: (context, index) {
            final armorModel = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(armorModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(armorModel.name),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Open5eArmorWidget(
                              armor: armorModel,
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
