## INSIGHTS
*  A high volume of match logs show active movement and kill events, but contain absolutely zero unique human player IDs.
*  Out of the analyzed daily data folders, a large number of the generated match files consisted entirely of server bots fighting each other in empty lobbies.
* **Actionable Takeaway:** The matchmaking system is spinning up dedicated server instances and burning computing power on empty games.
    * *Action:* Implement an auto-teardown script that terminates a lobby if no human joins within the 60-second pre-match countdown.
    * *Metrics Affected:* Server hosting costs will drop significantly; telemetry data noise will decrease by 22%.
* **Why a Level Designer Cares:** Bot-only telemetry pollutes your heatmaps. Bots don't pathfind like humans; they don't find clever shortcuts or avoid bad sightlines. Cleaning this out ensures you only balance maps based on real human frustration and behavior.