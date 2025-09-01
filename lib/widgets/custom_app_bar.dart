import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar for healthcare application
/// Implements Contemporary Medical Minimalism with Clinical Precision Palette
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showSettingsAction;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showSettingsAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: leading ??
          (canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null),
      actions: [
        ...?actions,
        if (showSettingsAction)
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            onPressed: () => Navigator.pushNamed(context, '/settings-screen'),
            tooltip: 'Settings',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Variant of CustomAppBar with search functionality
class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String hintText;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final TextEditingController? searchController;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomSearchAppBar({
    super.key,
    required this.title,
    this.hintText = 'Search...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchController,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    widget.onSearchChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              style: theme.textTheme.bodyLarge,
              onChanged: widget.onSearchChanged,
              onSubmitted: (_) => widget.onSearchSubmitted?.call(),
            )
          : Text(
              widget.title,
              style: theme.appBarTheme.titleTextStyle,
            ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: canPop && widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed:
                  widget.onBackPressed ?? () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : null,
      actions: [
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: _stopSearch,
            tooltip: 'Close search',
          )
        else
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            onPressed: _startSearch,
            tooltip: 'Search',
          ),
      ],
    );
  }
}

/// Variant of CustomAppBar for emergency situations
class CustomEmergencyAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onEmergencyPressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomEmergencyAppBar({
    super.key,
    required this.title,
    this.onEmergencyPressed,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: canPop && showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : null,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: ElevatedButton.icon(
            onPressed: onEmergencyPressed ??
                () {
                  // Default emergency action - could open emergency contacts
                  Navigator.pushNamed(context, '/emergency-directory-screen');
                },
            icon: const Icon(Icons.emergency, size: 18),
            label: const Text('SOS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
