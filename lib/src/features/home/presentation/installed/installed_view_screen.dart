import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/features/home/presentation/installed/installed_view_state.dart';
import 'package:gap/gap.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  @override
  Widget build(context) {
    InstalledViewState installedViewState =
        ref.watch(installedViewStateProvider);

    return AdwClamp(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.installed,
                  style: context.textTheme.titleMedium,
                ),
                const Spacer(),
                AdwButton(
                  child: Text(AppLocalizations.of(context)!.loadAppImage),
                  onPressed: () => installedViewState.loadAppImage(),
                ),
              ],
            ),
          ),
          installedViewState.listInstalled.isNotEmpty
              ? SingleChildScrollView(
                  controller: ScrollController(),
                  child: Center(
                    child: AdwPreferencesGroup.builder(
                      itemCount: installedViewState.listInstalled.length,
                      itemBuilder: (_, index) {
                        final i = installedViewState.listInstalled[index];

                        final integratedIndex =
                            installedViewState.integratedIndex(i.path);
                        bool isIntegrated = integratedIndex >= 0;

                        return ListTile(
                          title: Text(
                            path.basenameWithoutExtension(i.path),
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLarge,
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
                                  index: integratedIndex,
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
                          onTap: () =>
                              ref.read(programUtilsProvider).runProgram(
                                    location: path.dirname(i.path),
                                    program: path.basename(i.path),
                                  ),
                        );
                      },
                    ),
                  ),
                )
              : Consumer(builder: (context, ref, _) {
                  final downloadPath = ref.watch(downloadPathProvider);
                  return Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.noAppImageInThisRelease} $downloadPath',
                    ),
                  );
                }),
        ],
      ),
    );
  }
}
