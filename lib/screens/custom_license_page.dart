import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class Package {
  String name;
  int count;

  Package({required this.name, required this.count});
}

class CustomLicensePage extends HookWidget {
  const CustomLicensePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _selected = useState<int?>(null);
    final appBarName = useState<String?>(null);

    void _selectValue(int? val, String appbarN) {
      _selected.value = val;
      appBarName.value = appbarN;
    }

    void _clearSelected() => _selected.value = null;
    return Scaffold(
      body: aibAppBar(
        context,
        title: appBarName.value ?? "Licenses",
        showBackButton: true,
        body: FutureBuilder<List<LicenseEntry>>(
            future: LicenseRegistry.licenses.toList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: SpinKitThreeBounce(
                        color: context.textTheme.bodyText1!.color));
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

                return TwoPane(
                  showPane2: context.width < 800 && _selected.value == null
                      ? false
                      : true,
                  onClosePane2Popup: _clearSelected,
                  pane2Name: _selected.value != null
                      ? packages[_selected.value!].name
                      : null,
                  pane1: ListView.builder(
                    itemBuilder: (context, index) {
                      var isSelected = _selected.value == index;
                      return gtkSidebarItem(
                        context,
                        isSelected,
                        onSelected: () =>
                            _selectValue(index, packages[index].name),
                        labelWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              packages[index].name,
                              style: context.textTheme.bodyText1!.copyWith(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                            Text(
                              '${packages[index].count} License${packages[index].count > 1 ? "s" : ""}',
                              style: context.textTheme.bodyText2!.copyWith(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ],
                        ),
                        iconWidget: const SizedBox(),
                      );
                    },
                    itemCount: packages.length,
                  ),
                  pane2: _selected.value != null
                      ? LicenseInfoPage(
                          package: packages[_selected.value!],
                          paragraph: snapshot.data!
                              .where((element) =>
                                  element.packages.first ==
                                  packages[_selected.value!].name)
                              .toList(),
                        )
                      : const Center(child: Text('Select a License to view.')),
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
    final cParagraph =
        paragraph ?? (arguments != null ? arguments['paragraph'] : null);
    return Scaffold(
      body: ListView(
        children: List.generate(
          cParagraph!.length,
          (index) {
            var currentPara = cParagraph![index].paragraphs.toList();
            return StickyHeader(
              header: Container(
                color: context.isDark
                    ? AdwaitaDarkColors.headerBarBackgroundBottom
                    : AdwaitaLightColors.headerBarBackgroundBottom,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                alignment: Alignment.centerLeft,
                child: Text(currentPara[0].text),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: List.generate(
                    currentPara.length - 1,
                    (i) => SelectableText(
                      currentPara[i + 1].text,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
