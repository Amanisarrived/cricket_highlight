import 'package:flutter/material.dart';
import 'package:cricket_highlight/widgets/apptext.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    this.imageUrl,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.96);
  void _onTapUp(TapUpDetails _) =>
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _scale = 1.0);
      });
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (widget.imageUrl != null) {
      if (widget.imageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(widget.imageUrl!);
      } else if (widget.imageUrl!.startsWith('assets/')) {
        imageProvider = AssetImage(widget.imageUrl!);
      }
    }

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.redAccent.withAlpha(90),
        highlightColor: Colors.redAccent.withAlpha(10),
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Ink(
          height: 115,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent, width: 1),
            color: Colors.redAccent.withAlpha(10),
            image: imageProvider != null
                ? DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withAlpha(90),
                      BlendMode.darken,
                    ),
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withAlpha(5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageProvider == null)
                Icon(widget.icon, color: Colors.redAccent, size: 32),
              const SizedBox(height: 8),
              AppText(
                widget.title,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
