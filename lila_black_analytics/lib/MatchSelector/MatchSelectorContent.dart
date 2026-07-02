import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/utils/Masterpage.dart';

class MatchSelectorContent extends StatelessWidget {
  final AppSession appSession;

  const MatchSelectorContent({super.key, required this.appSession});

  @override
  Widget build(BuildContext context) {
    final DashboardController c = appSession.dashboardController;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;
    final bool isSmallMobile = screenWidth < 420;

    return Obx(
      () => Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MasterPage.wheelSelector(
                title: "Match Date",
                items: c.displayDate,
                selectedValue: c.selectedDate,
                onSelected: c.onDateSelected,
                height: isMobile ? 100 : 150,
              ),

              if (c.showRadioButtons.value) ...[
                MasterPage.spacing(isMobile ? 10 : 24),

                MasterPage.sectionTitle("Match Type"),

                MasterPage.spacing(isMobile ? 6 : 12),

                MasterPage.radioOption(
                  groupValue: c.matchSelectionMode,
                  tabs: isSmallMobile
                      ? const ["Highest", "All Matches"]
                      : const ["Highest Players", "View All Matches"],
                  onChanged: c.onMatchModeChanged,
                ),
              ],

              if (c.showAllMatchesDropdown.value) ...[
                MasterPage.spacing(isMobile ? 10 : 24),

                isMobile
                    ? Column(
                        children: [
                          MasterPage.wheelSelector(
                            title: "Map",
                            items: c.availableMaps,
                            selectedValue: c.selectedMap,
                            onSelected: c.onMapSelected,
                            height: 90,
                          ),

                          const SizedBox(height: 8),

                          MasterPage.wheelSelector(
                            title: "Match",
                            items: c.relevantMatches,
                            selectedValue: c.selectedMatch,
                            onSelected: c.onMatchSelected,
                            height: 90,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: MasterPage.wheelSelector(
                              title: "Select Map",
                              items: c.availableMaps,
                              selectedValue: c.selectedMap,
                              onSelected: c.onMapSelected,
                              height: 150,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MasterPage.wheelSelector(
                              title: "Select Match",
                              items: c.relevantMatches,
                              selectedValue: c.selectedMatch,
                              onSelected: c.onMatchSelected,
                              height: 150,
                            ),
                          ),
                        ],
                      ),
              ],

              if (c.showPlayHighestPlayersButton.value ||
                  c.showPlaySelectedMatchButton.value) ...[
                MasterPage.spacing(isMobile ? 14 : 30),

                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 46 : 54,
                  child: Obx(
                    () => MasterPage.primaryButton(
                      text: c.isPlaybackFetching.value
                          ? "Fetching playback..."
                          : "▶ Play Match",
                      onPressed: c.isPlaybackFetching.value
                          ? () {}
                          : () async {
                              if (c.showPlayHighestPlayersButton.value) {
                                await c.playHighestPlayerMatch();
                              } else {
                                await c.playSelectedMatch();
                              }

                              if (isMobile) {
                                Get.back(); // Close bottom sheet
                              }
                            },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
