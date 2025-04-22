import 'package:flutter/material.dart';

class Open5eMagicItem {
  final String slug;
  final String name;
  final String type;
  final String desc;
  final String rarity;
  final String requiresAttunement;
  final String documentSlug;
  final String documentTitle;
  final String documentUrl;

  Open5eMagicItem({
    required this.slug,
    required this.name,
    required this.type,
    required this.desc,
    required this.rarity,
    required this.requiresAttunement,
    required this.documentSlug,
    required this.documentTitle,
    required this.documentUrl,
  });

  factory Open5eMagicItem.fromJson(Map<String, dynamic> json) {
    return Open5eMagicItem(
      slug: json['slug'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      desc: json['desc'] as String,
      rarity: json['rarity'] as String,
      requiresAttunement: json['requires_attunement'] as String,
      documentSlug: json['document__slug'] as String,
      documentTitle: json['document__title'] as String,
      documentUrl: json['document__url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'type': type,
      'desc': desc,
      'rarity': rarity,
      'requires_attunement': requiresAttunement,
      'document__slug': documentSlug,
      'document__title': documentTitle,
      'document__url': documentUrl,
    };
  }
}

class Open5eMagicItemWidget extends StatelessWidget {
  final Open5eMagicItem magicItem;

  const Open5eMagicItemWidget({Key? key, required this.magicItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(magicItem.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Type'),
              subtitle: Text(magicItem.type),
            ),
            ListTile(
              title: Text('Rarity'),
              subtitle: Text(magicItem.rarity),
            ),
            ListTile(
              title: Text('Requires Attunement'),
              subtitle: Text(magicItem.requiresAttunement),
            ),
            ListTile(
              title: Text('Description'),
              subtitle: Text(magicItem.desc),
            ),
            ListTile(
              title: Text('Document'),
              subtitle: Text(
                  '${magicItem.documentTitle} (${magicItem.documentSlug})'),
            ),
          ],
        ),
      ),
    );
  }
}
