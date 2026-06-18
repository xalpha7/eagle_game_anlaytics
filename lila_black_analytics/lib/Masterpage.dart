import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterPage {
  const MasterPage._();

  // ==========================================================
  // SPACING
  // ==========================================================

  static Widget spacing([double height = 16]) {
    return SizedBox(height: height);
  }

  // ==========================================================
  // TITLES
  // ==========================================================

  static Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // ==========================================================
  // PRIMARY BUTTON
  // ==========================================================

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    double height = 50,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }

  // ==========================================================
  // TAB SELECTOR
  // Replaces Radio Buttons
  // ==========================================================

  static Widget radioOption({
    required RxInt groupValue,
    required List<String> tabs,
    required Function(int) onChanged,
  }) {
    return Obx(
      () => Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final int value = index + 1;

            final bool isSelected = groupValue.value == value;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  onChanged(value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? Theme.of(Get.context!).primaryColor
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ==========================================================
  // ARROW SELECTOR
  // Replaces Dropdown
  // ==========================================================

  static Widget wheelSelector({
    required String title,
    required List items,
    required Rx selectedValue,
    required Function(dynamic) onSelected,
    double height = 160,
  }) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(title),
          const SizedBox(height: 12),
          Container(
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text("No Data Available"),
          ),
        ],
      );
    }

    return Obx(() {
      int currentIndex = items.indexOf(selectedValue.value);

      if (currentIndex < 0) {
        currentIndex = 0;
      }

      final dynamic selectedItem = items[currentIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(title),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                // ======================================
                // UP BUTTON
                // ======================================
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up, size: 32),
                  onPressed: currentIndex > 0
                      ? () {
                          onSelected(items[currentIndex - 1]);
                        }
                      : null,
                ),

                // ======================================
                // PREVIOUS ITEM
                // ======================================
                if (currentIndex > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Opacity(
                      opacity: 0.45,
                      child: Text(
                        items[currentIndex - 1].toString().replaceAll('_', ' '),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                // ======================================
                // CURRENT ITEM
                // ======================================
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    key: ValueKey(selectedItem.toString()),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      selectedItem.toString().replaceAll('_', ' '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ======================================
                // NEXT ITEM
                // ======================================
                if (currentIndex < items.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Opacity(
                      opacity: 0.45,
                      child: Text(
                        items[currentIndex + 1].toString().replaceAll('_', ' '),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                // ======================================
                // DOWN BUTTON
                // ======================================
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                  onPressed: currentIndex < items.length - 1
                      ? () {
                          onSelected(items[currentIndex + 1]);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
