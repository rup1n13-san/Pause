import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:stacked/stacked.dart';
import 'app_interception_viewmodel.dart';

class AppInterceptionView extends StackedView<AppInterceptionViewModel> {
  const AppInterceptionView({super.key});

  @override
  void onViewModelReady(AppInterceptionViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    AppInterceptionViewModel viewModel,
    Widget? child,
  ) {
    // Basic theme colors to match the app's dark vibe (PauseColors)
    final bgColor = PauseColors.bg;
    final surfaceColor = PauseColors.panel;
    final textColor = PauseColors.text;
    final primaryColor = PauseColors.amber;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: BackButton(color: textColor),
        title: Text(
          'App Interception',
          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : !viewModel.hasAccess
              ? _buildAccessDenied(context, viewModel, textColor, surfaceColor, primaryColor)
              : _buildContent(context, viewModel, textColor, surfaceColor, primaryColor),
    );
  }

  Widget _buildAccessDenied(
    BuildContext context,
    AppInterceptionViewModel viewModel,
    Color textColor,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.security, size: 64, color: textColor.withValues(alpha: 0.7)),
          const SizedBox(height: 16),
          Text(
            'Usage Access Required',
            style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'To intercept distracting apps, Pause needs permission to see which app is currently open.',
            style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await viewModel.openSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: PauseColors.bg,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Grant Access in Settings'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: viewModel.checkAccess,
            style: TextButton.styleFrom(foregroundColor: textColor),
            child: const Text('I have granted access (Refresh)'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppInterceptionViewModel viewModel,
    Color textColor,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Enable Interception', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500)),
          subtitle: Text(
            'Pause will notify you when you open selected apps.',
            style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 14),
          ),
          value: viewModel.isEnabled,
          onChanged: viewModel.toggleEnabled,
          activeTrackColor: primaryColor,
        ),
        Divider(color: surfaceColor),
        if (!viewModel.isEnabled)
          Expanded(
            child: Center(
              child: Text(
                'Interception is disabled.',
                style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 16),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.installedApps.length,
              itemBuilder: (context, index) {
                final app = viewModel.installedApps[index];
                final isIntercepted =
                    viewModel.interceptedApps.contains(app.packageName);

                return CheckboxListTile(
                  title: Text(app.name, style: TextStyle(color: textColor)),
                  subtitle: Text(
                    app.packageName,
                    style: TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 12),
                  ),
                  value: isIntercepted,
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.toggleAppInterception(app.packageName, value);
                    }
                  },
                  secondary: app.icon != null
                      ? Image.memory(app.icon!, width: 40, height: 40)
                      : Icon(Icons.android, color: textColor),
                  activeColor: primaryColor,
                  checkColor: PauseColors.bg,
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  AppInterceptionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppInterceptionViewModel();
}
