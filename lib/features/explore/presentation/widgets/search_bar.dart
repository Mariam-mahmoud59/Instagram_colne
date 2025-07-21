// lib/features/explore/presentation/widgets/search_bar.dart

import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.focusNode,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.height,
    this.fillColor,
    this.focusedBorderColor,
    this.borderRadius = 12.0,
    this.onTap,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _internalFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _internalFocusNode = widget.focusNode ?? FocusNode();
    
    _internalFocusNode.addListener(() {
      setState(() {
        _isFocused = _internalFocusNode.hasFocus;
      });
      
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    // Listen to controller changes to update suffix icon
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Initialize border color animation based on theme
    _borderColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.focusedBorderColor ?? const Color(0xFF0095F6),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: widget.height ?? 36,
            decoration: BoxDecoration(
              color: widget.fillColor ?? 
                     (isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _borderColorAnimation.value ?? Colors.transparent,
                width: _isFocused ? 1.5 : 0,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: (widget.focusedBorderColor ?? const Color(0xFF0095F6))
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _internalFocusNode,
              enabled: widget.enabled,
              textInputAction: widget.textInputAction ?? TextInputAction.search,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              onSubmitted: widget.onSubmitted,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: widget.prefixIcon ?? _buildPrefixIcon(isDark),
                suffixIcon: _buildSuffixIcon(isDark),
                border: InputBorder.none,
                contentPadding: widget.contentPadding ?? 
                               const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrefixIcon(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.search,
        color: _isFocused 
            ? (widget.focusedBorderColor ?? const Color(0xFF0095F6))
            : (isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E)),
        size: 20,
      ),
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    
    if (widget.controller.text.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          icon: Icon(
            Icons.cancel,
            color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
            size: 20,
          ),
          onPressed: () {
            widget.controller.clear();
            widget.onClear?.call();
            widget.onChanged('');
          },
          splashRadius: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      );
    }
    
    return null;
  }
}

// Enhanced SearchBar with additional Instagram-like features
class InstagramSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool showRecentSearches;
  final List<String>? recentSearches;
  final Function(String)? onRecentSearchTap;
  final VoidCallback? onClearRecentSearches;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;

  const InstagramSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.focusNode,
    this.showRecentSearches = false,
    this.recentSearches,
    this.onRecentSearchTap,
    this.onClearRecentSearches,
    this.enabled = true,
    this.onTap,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<InstagramSearchBar> createState() => _InstagramSearchBarState();
}

class _InstagramSearchBarState extends State<InstagramSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late FocusNode _internalFocusNode;
  bool _showRecentSearches = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _internalFocusNode = widget.focusNode ?? FocusNode();
    
    _internalFocusNode.addListener(() {
      setState(() {
        _showRecentSearches = _internalFocusNode.hasFocus && 
                             widget.showRecentSearches && 
                             widget.controller.text.isEmpty &&
                             (widget.recentSearches?.isNotEmpty ?? false);
      });
      
      if (_showRecentSearches) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    widget.controller.addListener(() {
      setState(() {
        _showRecentSearches = _internalFocusNode.hasFocus && 
                             widget.showRecentSearches && 
                             widget.controller.text.isEmpty &&
                             (widget.recentSearches?.isNotEmpty ?? false);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        SearchBar(
          controller: widget.controller,
          hintText: widget.hintText,
          onChanged: widget.onChanged,
          onClear: widget.onClear,
          focusNode: _internalFocusNode,
          enabled: widget.enabled,
          onTap: widget.onTap,
          onSubmitted: widget.onSubmitted,
        ),
        if (_showRecentSearches) _buildRecentSearches(isDark),
      ],
    );
  }

  Widget _buildRecentSearches(bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: _animationController,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262626) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF363636) : const Color(0xFFDBDBDB),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.onClearRecentSearches != null)
                          TextButton(
                            onPressed: widget.onClearRecentSearches,
                            child: Text(
                              'Clear all',
                              style: TextStyle(
                                color: const Color(0xFF0095F6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ...widget.recentSearches!.take(5).map((search) => 
                    _buildRecentSearchItem(search, isDark)
                  ).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentSearchItem(String search, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onRecentSearchTap?.call(search);
          widget.controller.text = search;
          widget.onChanged(search);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  search,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.north_west,
                color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}