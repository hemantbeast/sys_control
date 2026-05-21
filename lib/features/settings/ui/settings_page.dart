import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/routes/route_enum.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/settings/ui/providers/settings_categories_provider.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_icons.dart';
import 'package:sys_control/generated/l10n.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsCategoriesProvider);
    final categories = state.categories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: AppRouter.pop,
        ),
        title: Text(S.of(context).settings),
      ),
      body: state.isLoading && categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryTile(
                  icon: settingCategoryIcon(category.icon),
                  title: category.label,
                  onTap: () {
                    AppRouter.pushNamed(
                      RouteEnum.settingsCategoryScreen.name,
                      args: category,
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 22, color: context.customTheme.blackTextStyle.color),
      ),
      title: Text(
        title,
        style: context.customTheme.blackTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: context.customTheme.lightGrayTextStyle.color,
        size: 22,
      ),
      onTap: onTap,
    );
  }
}
