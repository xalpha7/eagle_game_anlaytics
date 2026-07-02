import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterPage {
  const MasterPage._();

  // ==========================================================
  // APPLE DESIGN TOKENS (INTEGRATED DIRECTLY)
  // ==========================================================
  static const Color backgroundPrimary = Color(0xFF0B0B0F);
  static const Color backgroundSecondary = Color(0xFF12141A);
  static const Color surface = Color(0xFF18181B);
  static const Color elevatedSurface = Color(0xFF1E1F25);

  static const Color textPrimary = Color.fromRGBO(255, 255, 255, 0.95);
  static const Color textSecondary = Color.fromRGBO(255, 255, 255, 0.65);
  static const Color textDisabled = Color.fromRGBO(255, 255, 255, 0.35);

  static const Color accentBlue = Color(0xFF0A84FF);

  static const double radius = 24;
  static const double sectionSpacing = 16; // Optimized compact spacing

  // ==========================================================
  // GLASS SURFACE DESIGN PIPELINE
  // ==========================================================
  static Widget _glassSurface({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
    BorderRadius? borderRadius,
  }) {
    final radiusValue = borderRadius ?? BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: radiusValue,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radiusValue,
            color: const Color(0xFF18181B).withOpacity(0.70),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ==========================================================
  // SPACING (8-POINT GRID SYSTEM)
  // ==========================================================
  static Widget spacing([double height = sectionSpacing]) {
    return SizedBox(height: height);
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================
  static Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w500, // Minimalist medium weight
          color: textPrimary,
          letterSpacing: -0.3,
          height: 1.3,
        ),
      ),
    );
  }

  // ==========================================================
  // PRIMARY BUTTON (PILL SHAPE & COMPACT)
  // ==========================================================
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    double height = 50,
    bool isDisabled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isDisabled ? Colors.transparent : accentBlue,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // Clean pill-shape
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // APPLE TAB SELECTOR
  // ==========================================================
  static Widget radioOption({
    required RxInt groupValue,
    required List<String> tabs,
    required Function(int) onChanged,
  }) {
    return Obx(
      () => _glassSurface(
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(999), // Ultra-smooth pill capsule
        child: SizedBox(
          height: 40, // Compact height matching iOS 26 segment standards
          child: Row(
            children: List.generate(tabs.length, (index) {
              final int value = index + 1;
              final bool isSelected = groupValue.value == value;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: isSelected
                          ? Colors.white.withOpacity(
                              0.12,
                            ) // Premium subtle visionOS selection
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: isSelected ? textPrimary : textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  static Widget wheelSelector({
    required String title,
    required List items,
    required Rx selectedValue,
    required Function(dynamic) onSelected,
    double height = 150,
  }) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(title),
          _glassSurface(
            child: SizedBox(
              height: height,
              child: const Center(
                child: Text(
                  "Fetching...",
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    color: textDisabled,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Obx(() {
      int currentIndex = items.indexOf(selectedValue.value);

      // Fix: If the initial state value is unselected, invalid, or null on first load,
      // programmatically sync state and fallback to treating the first item as selected.
      if (currentIndex < 0) {
        currentIndex = 0;
        final firstItem = items[0];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectedValue.value != firstItem) {
            selectedValue.value = firstItem;
            onSelected(
              firstItem,
            ); // Triggers business logic sync for first-time render
          }
        });
      }

      final dynamic selectedItem = items[currentIndex];

      final bool hasPrev = currentIndex > 0;
      final bool hasNext = currentIndex < items.length - 1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(title),
          _glassSurface(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ======================================
                  // ARROW UP
                  // ======================================
                  IconButton(
                    iconSize: 28,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: hasPrev
                          ? textSecondary
                          : textDisabled.withOpacity(0.1),
                    ),
                    onPressed: hasPrev
                        ? () => onSelected(items[currentIndex - 1])
                        : null,
                  ),
                  const SizedBox(height: 6),

                  // ======================================
                  // PREVIOUS ITEM PLACEHOLDER (Anti-UI-Shift)
                  // ======================================
                  Opacity(
                    opacity: hasPrev ? 0.40 : 0.0,
                    child: Text(
                      hasPrev
                          ? items[currentIndex - 1].toString().replaceAll(
                              '_',
                              ' ',
                            )
                          : "Placeholder", // Rigid layout anchor
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                      ),
                    ),
                  ),

                  // ======================================
                  // CURRENT SELECTED ITEM
                  // ======================================
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Container(
                      key: ValueKey(selectedItem.toString()),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        selectedItem.toString().replaceAll('_', ' '),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: '.SF Pro Display',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ),

                  // ======================================
                  // NEXT ITEM PLACEHOLDER (Anti-UI-Shift)
                  // ======================================
                  Opacity(
                    opacity: hasNext ? 0.40 : 0.0,
                    child: Text(
                      hasNext
                          ? items[currentIndex + 1].toString().replaceAll(
                              '_',
                              ' ',
                            )
                          : "Placeholder", // Rigid layout anchor
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ======================================
                  // ARROW DOWN
                  // ======================================
                  IconButton(
                    iconSize: 28,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: hasNext
                          ? textSecondary
                          : textDisabled.withOpacity(0.1),
                    ),
                    onPressed: hasNext
                        ? () => onSelected(items[currentIndex + 1])
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
