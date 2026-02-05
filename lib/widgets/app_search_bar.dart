// app_search_bar.dart
import 'package:cricket_highlight/widgets/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../provider/categoryprovider.dart';
import '../provider/search_provider.dart';

class AppSearchBar extends StatefulWidget {
  final int currentTabIndex;

  const AppSearchBar({super.key, required this.currentTabIndex});

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
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  void _onTextChanged() {
    final query = _controller.text;
    setState(() => _hasText = query.isNotEmpty);

    final allMovies = context.read<CategoryProvider>().movies;
    context.read<SearchProvider>().search(query, allMovies);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: Colors.redAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                final q = value.trim();
                if (q.isEmpty) return;

                final searchProvider = context.read<SearchProvider>();
                final categoryProvider = context.read<CategoryProvider>();

                // 1. search karo
                searchProvider.search(q, categoryProvider.movies);

                // 2. keyboard band
                _focusNode.unfocus();

                // 3. next screen pehle open karo
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SearchResultScreen(),
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                ).then((_) {
                  // 4. jab wapas aao tab clear karo
                  _controller.clear();
                  searchProvider.clear();
                });
              },



              focusNode: _focusNode,
              controller: _controller,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.currentTabIndex == 2
                    ? "Search News..."
                    : "Search Highlights...",
                hintStyle:
                GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                _controller.clear();
                context.read<SearchProvider>().clear();
                _focusNode.requestFocus();
              },
              child: const Icon(Icons.clear, color: Colors.redAccent, size: 22),
            ),
        ],
      ),
    );
  }
}
