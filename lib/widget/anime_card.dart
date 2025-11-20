import 'package:flutter/material.dart';

class AnimeCard extends StatefulWidget {
  final Map<String, String> anime;
  const AnimeCard({super.key, required this.anime});

  @override
  State<AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;

  // non-late, nullable controller & animation to be safe
  AnimationController? _fadeController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // create controller and animation here
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    // make sure animation is created from the controller
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _removeOverlay(immediate: true);
    _fadeController?.dispose();
    super.dispose();
  }

  void _showOverlay() {
    // prevent multiple inserts
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    // if (overlayState == null) return;
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        // position the overlay slightly above the card center
        final left = offset.dx;
        final top = offset.dy - 8.0; // just above the card
        return Positioned(
          left: left,
          top: top,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              // safe access to _fadeAnimation
              opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
                      ],
                    ),
                    child: Text(
                      widget.anime['title'] ?? '',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);

    // start fade-in if controller exists
    _fadeController?.forward();
  }

  /// remove overlay. if [immediate] true -> remove without animation.
  void _removeOverlay({bool immediate = false}) {
    if (_overlayEntry == null) return;
    if (immediate) {
      try {
        _overlayEntry?.remove();
      } catch (_) {}
      _overlayEntry = null;
      return;
    }

    // reverse animation then remove
    if (_fadeController != null) {
      _fadeController!.reverse().then((_) {
        if (_overlayEntry != null) {
          try {
            _overlayEntry?.remove();
          } catch (_) {}
          _overlayEntry = null;
        }
      }).catchError((_) {
        try {
          _overlayEntry?.remove();
        } catch (_) {}
        _overlayEntry = null;
      });
    } else {
      try {
        _overlayEntry?.remove();
      } catch (_) {}
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _showOverlay();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _removeOverlay();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        transform: _isHovered
            ? Matrix4.translationValues(0, -12, 0)
            : Matrix4.translationValues(0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color(0xFFE9D5FF),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.purple.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              )
            else
              const BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar anime tetap stabil (tidak ikut mempengaruhi layout teks)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.anime['image']!,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
                errorBuilder: (c, e, s) => Container(
                  height: 92,
                  width: 92,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Judul tetap dipotong pada kartu, overlay menampilkan keseluruhan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.anime['title'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? Colors.purple.shade900 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
