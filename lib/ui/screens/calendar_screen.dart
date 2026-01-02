import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_detail_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/default_appbar.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_card.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final List<RiskEntry> risks;

  const CalendarScreen({super.key, required this.risks});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime currentMonth;
  late List<DateTime> datesWithRisks;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    datesWithRisks = RiskLogicEngine.getDatesWithRisks(widget.risks);
  }

  @override
  Widget build(BuildContext context) {
    List<RiskEntry> monthRisks = widget.risks
        .where((r) =>
            r.date.year == currentMonth.year &&
            r.date.month == currentMonth.month)
        .toList();

    return Scaffold(
      appBar: DefaultAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => setState(() =>
                    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1)),
              ),
              Text(
                '${_monthName(currentMonth.month)} ${currentMonth.year}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => setState(() =>
                    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1)),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildCalendar(),
          SizedBox(height: 30),
          Text(
            "Risks for ${_monthName(currentMonth.month)} (${monthRisks.length})",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          if (monthRisks.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('No risks for this month',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            )
          else
            ...monthRisks.map((risk) => RiskCard(
                  risk: risk,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RiskDetailScreen(risk: risk, onRiskDeleted: () {  },),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    int firstDay = DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    List<Widget> dayWidgets = [];
    for (int i = 1; i < firstDay; i++) {
      dayWidgets.add(SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      bool hasRisks = datesWithRisks.any((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
      int riskCountForDay = widget.risks
          .where((r) =>
              r.date.year == date.year &&
              r.date.month == date.month &&
              r.date.day == date.day)
          .length;

      dayWidgets.add(
        GestureDetector(
          onTap: hasRisks ? () => _showDayRisks(context, date) : null,
          child: Container(
            decoration: BoxDecoration(
              color: hasRisks
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFF1a2332)
                      : Color(0xFFe3f2fd))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasRisks ? AppTheme.accentColor.withValues(alpha: .5) : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: hasRisks ? AppTheme.accentColor : Colors.grey,
                  ),
                ),
                if (hasRisks) ...[
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  Text('$riskCountForDay',
                      style:
                          TextStyle(fontSize: 10, color: AppTheme.accentColor)),
                ]
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: dayWidgets,
    );
  }

  void _showDayRisks(BuildContext context, DateTime date) {
    List<RiskEntry> dayRisks = RiskLogicEngine.getRisksForDate(widget.risks, date);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risks on ${date.day}/${date.month}/${date.year}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: dayRisks
                    .map((risk) => RiskCard(
                          risk: risk,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RiskDetailScreen(risk: risk, onRiskDeleted: () {  },),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}