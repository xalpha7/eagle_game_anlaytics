import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/MatchSelector/MatchSelectorContent.dart';
import 'package:lila_black_analytics/utils/Masterpage.dart';

class MatchSelector extends StatelessWidget {
  final AppSession appSession;
  DashboardController controller;
  MatchSelector({
    super.key,
    required this.appSession,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    String getButtonText() {
      if (controller.isPlaying.value) {
        return "Playing match...";
      }
      if (controller.isPlaybackFetching.value) {
        return "Fetching Match...";
      }
      return "Select Match";
    }

    // Mobile -> Show button that opens bottom sheet
    if (isMobile) {
      return Obx(() {
        return SizedBox(
          width: double.infinity,
          child: MasterPage.primaryButton(
            isDisabled:
                controller.isPlaying.value ||
                controller.isPlaybackFetching.value,
            text: getButtonText(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => DraggableScrollableSheet(
                  initialChildSize: 0.85,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (_, scrollController) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),

                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Select Match",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: MatchSelectorContent(appSession: appSession),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      });
    }

    // Tablet and Desktop -> Existing behavior
    return MatchSelectorContent(appSession: appSession);
  }
}
