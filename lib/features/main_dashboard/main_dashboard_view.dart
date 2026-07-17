import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/home/home_view.dart';
import 'package:mobile/features/usage/usage_recap_view.dart';
import 'main_dashboard_viewmodel.dart';

class MainDashboardView extends StackedView<MainDashboardViewModel> {
  const MainDashboardView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainDashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: const [
          HomeView(),
          UsageRecapView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: PauseColors.muted.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: PauseColors.bg,
          selectedItemColor: PauseColors.text,
          unselectedItemColor: PauseColors.muted,
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Usage',
            ),
          ],
        ),
      ),
    );
  }

  @override
  MainDashboardViewModel viewModelBuilder(BuildContext context) =>
      MainDashboardViewModel();
}
