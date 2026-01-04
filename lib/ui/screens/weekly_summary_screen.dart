import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/add_risk_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_detail_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_card.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_comparison.dart';
import 'package:everyday_risk_analyzer/ui/widgets/summary_box.dart';
import 'package:flutter/material.dart';

class WeeklySummaryScreen extends StatefulWidget {
  final List<RiskEntry> risks;
  final VoidCallback onRefresh;

  const WeeklySummaryScreen({
    super.key,
    required this.risks,
    required this.onRefresh,
  });

  @override
  State<WeeklySummaryScreen> createState() => _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends State<WeeklySummaryScreen> {
  DateTime getWeekStart(DateTime date) {return date.subtract(Duration(days: date.weekday - 1));}
  DateTime getWeekEnd(DateTime date) {return getWeekStart(date).add(Duration(days: 6));}
  DateTime selectedWeek = DateTime.now();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  void initState() {
    super.initState();
    selectedWeek = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var recent = RiskLogicEngine.getRecentRisks(widget.risks, days: 7);
    var comparison = RiskLogicEngine.compareCategoryFrequencies(widget.risks);
    final weekStart = getWeekStart(selectedWeek);
    final weekEnd = getWeekEnd(selectedWeek);
    final summary = RiskLogicEngine.calculateWeeklySummary(widget.risks, weekStart);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text("Hello, ", style: TextStyle(color: Colors.grey.shade300)),
            Text(
              getGreeting(),
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active, color: Colors.white),
            padding: EdgeInsets.all(16),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => widget.onRefresh(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none, // allow shadow to overflow
              children: [
                // Background color behind AppBar
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),

                // Weekly Summary positioned overlapping the header
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -60, // controls how much it overlaps (tweak this)
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF1a2332)
                          : Color(0xFFe3f2fd),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentColor.withValues(alpha: .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Weekly Summary',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${formatDate(weekStart)} - ${formatDate(weekEnd)}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SummaryBox(
                              count: '${summary['Health'] ?? 0}',
                              label: 'Health',
                              color: AppTheme.healthColor,
                            ),
                            SummaryBox(
                              count: '${summary['Finance'] ?? 0}',
                              label: 'Finance',
                              color: AppTheme.financeColor,
                            ),
                            SummaryBox(
                              count: '${summary['Safety'] ?? 0}',
                              label: 'Safety',
                              color: AppTheme.safetyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 16), 
              child: RiskComparisonCard( 
                headLine: 'Weekly category comparison', 
                comparison: comparison, 
              ), 
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Risks (${recent.length})',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            SizedBox(height: 12),

            // Only RiskCards scroll
            Expanded(
              child: recent.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 50,
                              color: AppTheme.successColor,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No risks recorded!',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Great job maintaining a healthy lifestyle.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: recent.length,
                        itemBuilder: (context, index) {
                          final risk = recent[index];
                          return RiskCard(
                            risk: risk,
                            showWeeklyFrequency: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RiskDetailScreen(
                                  risk: risk,
                                  onRiskDeleted: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // FAB stays fixed bottom-right
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddRiskDialog(onRiskAdded: widget.onRefresh),
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
