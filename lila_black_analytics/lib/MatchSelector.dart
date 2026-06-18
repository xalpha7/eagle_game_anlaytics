import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/Masterpage.dart';

class MatchSelector extends StatelessWidget {
  final AppSession appSession;

  const MatchSelector({super.key, required this.appSession});

  @override
  Widget build(BuildContext context) {
    final DashboardController c = appSession.dashboardController;

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MasterPage.wheelSelector(
                title: "Select Match Date",
                items: c.displayDate,
                selectedValue: c.selectedDate,
                onSelected: c.onDateSelected,
              ),

              if (c.showRadioButtons.value) ...[
                MasterPage.spacing(24),

                MasterPage.sectionTitle("Match Selection"),

                MasterPage.spacing(12),

                MasterPage.radioOption(
                  groupValue: c.matchSelectionMode,
                  tabs: const ["Highest Players", "View All Matches"],
                  onChanged: c.onMatchModeChanged,
                ),
              ],

              if (c.showAllMatchesDropdown.value) ...[
                MasterPage.spacing(24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MasterPage.wheelSelector(
                        title: "Select Map",
                        items: c.availableMaps,
                        selectedValue: c.selectedMap,
                        onSelected: c.onMapSelected,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: MasterPage.wheelSelector(
                        title: "Select Match",
                        items: c.relevantMatches,
                        selectedValue: c.selectedMatch,
                        onSelected: c.onMatchSelected,
                      ),
                    ),
                  ],
                ),
              ],

              if (c.showPlayHighestPlayersButton.value ||
                  c.showPlaySelectedMatchButton.value) ...[
                MasterPage.spacing(30),

                MasterPage.primaryButton(
                  text: "Play Match",
                  onPressed: c.showPlayHighestPlayersButton.value
                      ? c.playHighestPlayerMatch
                      : c.playSelectedMatch,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
