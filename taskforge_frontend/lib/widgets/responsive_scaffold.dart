import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';
import '../screens/dashboard_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/create_project_screen.dart';

class ResponsiveScaffold extends StatelessWidget {
  final int selectedIndex;
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? topBarActions;
  final Widget? floatingActionButton;
  final bool showSearch;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onRefresh;

  const ResponsiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.title,
    this.subtitle,
    required this.body,
    this.topBarActions,
    this.floatingActionButton,
    this.showSearch = false,
    this.onSearch,
    this.onRefresh,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const DashboardScreen();
        break;
      case 1:
        targetScreen = const ProjectsScreen();
        break;
      case 2:
        targetScreen = const TasksScreen();
        break;
      case 3:
      case 4:
        targetScreen = const SettingsScreen();
        break;
      default:
        targetScreen = const DashboardScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => targetScreen,
        transitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (context, anim1, anim2, child) {
          return FadeTransition(opacity: anim1, child: child);
        },
      ),
    );
  }

  void _openAddTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (result == true && onRefresh != null) {
      onRefresh!();
    }
  }

  void _openCreateProject(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
    );
    if (result != null && onRefresh != null) {
      onRefresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Row(
          children: [
            // Left persistent SaaS sidebar
            AppSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) => _handleNavigation(context, index),
              onQuickAddTask: () => _openAddTask(context),
              onQuickAddProject: () => _openCreateProject(context),
            ),
            // Main content area
            Expanded(
              child: Column(
                children: [
                  AppTopBar(
                    title: title,
                    subtitle: subtitle,
                    showSearch: showSearch,
                    onSearch: onSearch,
                    onQuickCreate: () => _openAddTask(context),
                    actions: topBarActions,
                  ),
                  Expanded(
                    child: body,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final mobileIndex = (selectedIndex == 4 ? 3 : selectedIndex).clamp(0, 3);

    // Mobile / Tablet layout
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppTopBar(
        title: title,
        subtitle: subtitle,
        showSearch: showSearch,
        onSearch: onSearch,
        actions: topBarActions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 1)),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              height: 60,
              backgroundColor: AppTheme.surface,
              elevation: 0,
              indicatorColor: AppTheme.primaryLight,
              indicatorShape: RoundedRectangleBorder(borderRadius: AppTheme.radiusSm),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final isSelected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  letterSpacing: -0.1,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final isSelected = states.contains(WidgetState.selected);
                return IconThemeData(
                  size: 20,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: mobileIndex,
              onDestinationSelected: (idx) => _handleNavigation(context, idx),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder_rounded),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  selectedIcon: Icon(Icons.task_alt_rounded),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
