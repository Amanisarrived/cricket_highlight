import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool readOnly;
  final Color backgroundColor;
  final Color hintColor;
  final Color iconColor;
  final double borderRadius;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onTap,
    this.controller,
    this.readOnly = false,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.redAccent,
    this.borderRadius = 14,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if(mounted){
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.search, color: widget.iconColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              readOnly: widget.readOnly,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.poppins(
                  color: widget.hintColor,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
              child: Icon(Icons.clear, color: widget.iconColor, size: 24),
            ),
        ],
      ),
    );
  }
}
