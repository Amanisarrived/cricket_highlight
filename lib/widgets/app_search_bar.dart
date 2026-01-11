import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool readOnly;
  final Color backgroundColor;
  final Color hintColor;
  final Color iconColor;
  final double borderRadius;

  /// 0 = Highlights, 1 = News
  final int currentTabIndex;

  const AppSearchBar({
    super.key,
    this.onChanged,
    this.onTap,
    this.controller,
    this.readOnly = false,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.redAccent,
    this.borderRadius = 14,
    required this.currentTabIndex,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// 🔥 Animated hint (NO focus issues)
  Widget _animatedHint() {
    final text = widget.currentTabIndex == 0
        ? "Search Highlights..."
        : "Search News...";

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        text,
        key: ValueKey(text),
        style: GoogleFonts.poppins(
          color: widget.hintColor,
          fontSize: 16,
        ),
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.search,
            color: widget.iconColor,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (!_hasText)
                  IgnorePointer(
                    child: _animatedHint(),
                  ),
                TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  readOnly: widget.readOnly,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.2,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ],
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
                _focusNode.requestFocus(); // 🔥 keep focus
              },
              child: Icon(
                Icons.clear,
                color: widget.iconColor,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
