import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/features/home/presentation/installed/installed_view_state.dart';
import 'package:gap/gap.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appimagepool/src/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';

class InstalledViewScreen extends ConsumerStatefulWidget {
  final ValueNotifier<String> searchedTerm;

  const InstalledViewScreen({Key? key, required this.searchedTerm})
      : super(key: key);

  @override
  ConsumerState<InstalledViewScreen> createState() => _InstalledViewState();
}

class _InstalledViewState extends ConsumerState<InstalledViewScreen> {
  late InstalledViewState installedViewState;

  @override
  void initState() {
    super.initState();
    installedViewState = ref.watch(installedViewStateProvider);
  }

  @override
  Widget build(context) {
    return installedViewState.listInstalled.isNotEmpty
        ? SingleChildScrollView(
            controller: ScrollController(),
            child: Center(
              child: AdwClamp(
                child: AdwPreferencesGroup(
                  children: List.generate(
                    installedViewState.listInstalled.length,
                    (index) {
                      final i = installedViewState.listInstalled[index];

                      bool isIntegrated =
                          installedViewState.isIntegrated(i.path);

                      return ListTile(
                        title: Text(
                          path.basenameWithoutExtension(i.path),
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyText1,
                        ),
                        subtitle: Text(i.statSync().size.getFileSize()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: isIntegrated
                                  ? AppLocalizations.of(context)!.disintegrate
                                  : AppLocalizations.of(context)!.integrate,
                              onPressed: () =>
                                  installedViewState.integrateOrRemove(
                                file: i,
                                isIntegrated: isIntegrated,
                                index: index,
                              ),
                              icon: Icon(
                                isIntegrated
                                    ? LucideIcons.x
                                    : LucideIcons.check,
                              ),
                            ),
                            const Gap(4),
                            IconButton(
                              onPressed: () => installedViewState.removeItem(
                                file: i,
                                isIntegrated: isIntegrated,
                                index: index,
                              ),
                              icon: const Icon(LucideIcons.trash),
                            ),
                          ],
                        ),
                        onTap: () => ref.read(programUtilsProvider).runProgram(
                              location: path.dirname(i.path),
                              program: path.basename(i.path),
                            ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        : Consumer(builder: (context, ref, _) {
            final downloadPath = ref.watch(downloadPathProvider);
            return Center(
              child: Text(
                '${AppLocalizations.of(context)!.noAppImageInThisRelease} ' +
                    downloadPath,
              ),
            );
          });
  }
}
