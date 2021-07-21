import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class Package {
  String name;
  int count;

  Package({required this.name, required this.count});
}

class CustomLicensePage extends StatelessWidget {
  const CustomLicensePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: aibAppBar(
        context,
        title: "Licenses",
        body: FutureBuilder<List<LicenseEntry>>(
            future: LicenseRegistry.licenses.toList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Package> packages = [];
                for (var element in snapshot.data!) {
                  if (packages.firstWhereOrNull(
                          (e) => e.name == element.packages.first) ==
                      null) {
                    if (element.paragraphs.toList().length > 1) {
                      packages
                          .add(Package(name: element.packages.first, count: 1));
                    }
                  } else {
                    packages
                        .firstWhereOrNull(
                            (e) => e.name == element.packages.first)!
                        .count += 1;
                  }
                }

                return ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => LicenseInfoPage(
                              package: packages[index],
                              paragraph: snapshot.data!
                                  .where((element) =>
                                      element.packages.first ==
                                      packages[index].name)
                                  .toList(),
                            ))),
                    title: Text(
                      packages[index].name,
                      style: context.textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      '${packages[index].count} ${packages[index].count > 1 ? "Licenses." : "License."}',
                      style: context.textTheme.bodyText2,
                    ),
                  ),
                  itemCount: packages.length,
                );
              }
            }),
      ),
    );
  }
}

class LicenseInfoPage extends StatelessWidget {
  final Package? package;
  final List<LicenseEntry>? paragraph;

  const LicenseInfoPage({Key? key, this.package, this.paragraph})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final currentPackage =
        package ?? (arguments != null ? arguments['package'] : null);
    final cParagraph =
        paragraph ?? (arguments != null ? arguments['paragraph'] : null);
    return Scaffold(
      body: aibAppBar(
        context,
        title: currentPackage!.name,
        body: ListView(
          children: List.generate(
            cParagraph!.length,
            (index) => StickyHeader(
              header: Container(
                  color: context.isDark
                      ? Colors.grey[800]
                      : Colors.white.darken(4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(cParagraph![index].paragraphs.toList()[0].text)),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: List.generate(
                        cParagraph![index].paragraphs.toList().length - 1,
                        (i) => Text(cParagraph![index]
                            .paragraphs
                            .toList()[i + 1]
                            .text))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
