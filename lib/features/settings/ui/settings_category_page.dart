import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/ui/providers/settings_items_provider.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_item_tile.dart';

class SettingsCategoryPage extends ConsumerWidget {
  const SettingsCategoryPage({required this.category, super.key});

  final SettingCategoryEntity category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsItemsProvider(category.id));
    final items = state.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: AppRouter.pop,
        ),
        title: Text(category.label),
      ),
      body: state.isLoading && items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return SettingItemTile(item: items[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
    );
  }
}
