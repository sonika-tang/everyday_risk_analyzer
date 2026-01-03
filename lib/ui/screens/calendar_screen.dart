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

enum CalendarView { month, week }

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime currentMonth;
  late List<DateTime> datesWithRisks;
  CalendarView currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    datesWithRisks = RiskLogicEngine.getDatesWithRisks(widget.risks);
  }

  @override
  Widget build(BuildContext context) {
    List<RiskEntry> monthRisks = widget.risks
        .where(
          (r) =>
              r.date.year == currentMonth.year &&
              r.date.month == currentMonth.month,
        )
        .toList();

    DateTime startOfWeek = currentMonth.subtract(Duration(days: currentMonth.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weekRisks = widget.risks.where((r) {
      return r.date.isAtSameMomentAs(startOfWeek) ||
            r.date.isAtSameMomentAs(endOfWeek) ||
            (r.date.isAfter(startOfWeek) && r.date.isBefore(endOfWeek));
    }).toList();

    final displayedRisks = currentView == CalendarView.month ? monthRisks : weekRisks;

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
                onPressed: () => setState(() {
                  if (currentView == CalendarView.month) {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                  } else {
                    currentMonth = currentMonth.subtract(const Duration(days: 7));
                  }
                }),
              ),
              Text(
                currentView == CalendarView.month
                    ? '${_monthName(currentMonth.month)} ${currentMonth.year}'
                    : '${_monthName(startOfWeek.month)} ${startOfWeek.day} – '
                      '${_monthName(endOfWeek.month)} ${endOfWeek.day}, ${endOfWeek.year}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => setState(() {
                  if (currentView == CalendarView.month) {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                  } else {
                    currentMonth = currentMonth.add(const Duration(days: 7));
                  }
                }),
              ),
            ],
          ),
          SizedBox(height: 12,),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _viewButton('Week', CalendarView.week),
                _viewButton('Month', CalendarView.month),
              ],
            ),
          ),
          SizedBox(height: 16),
          currentView == CalendarView.month ? _buildCalendar() : _buildWeekView(),
          SizedBox(height: 30),
          Text(
            currentView == CalendarView.month
                ? "Risks for ${_monthName(currentMonth.month)} (${monthRisks.length})"
                : "Risks for ${_monthName(startOfWeek.month)} ${startOfWeek.day} – "
                  "${_monthName(endOfWeek.month)} ${endOfWeek.day} (${weekRisks.length})",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          if (displayedRisks.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No risks for this month',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
          ...displayedRisks.map(
            (risk) => RiskCard(
              risk: risk,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RiskDetailScreen(risk: risk, onRiskDeleted: () {}),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    int firstDay = DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    int daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;

    List<Widget> dayWidgets = [];
    for (int i = 1; i < firstDay; i++) {
      dayWidgets.add(SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      bool hasRisks = datesWithRisks.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      int riskCountForDay = widget.risks
          .where(
            (r) =>
                r.date.year == date.year &&
                r.date.month == date.month &&
                r.date.day == date.day,
          )
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
                color: hasRisks
                    ? AppTheme.accentColor.withValues(alpha: .5)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][index],
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
                //const SizedBox(height: 6),
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
                  Text(
                    '$riskCountForDay',
                    style: TextStyle(fontSize: 10, color: AppTheme.accentColor),
                  ),
                ],
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
    List<RiskEntry> dayRisks = RiskLogicEngine.getRisksForDate(
      widget.risks,
      date,
    );
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
                    .map(
                      (risk) => RiskCard(
                        risk: risk,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RiskDetailScreen(
                              risk: risk,
                              onRiskDeleted: () {},
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewButton(String label, CalendarView view) {
    final isSelected = currentView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentView = view),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    final now = DateTime(currentMonth.year, currentMonth.month, currentMonth.day);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<Widget> days = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));

      final dayRisks = widget.risks.where((r) =>
          r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day).toList();

      return GestureDetector(
        onTap: dayRisks.isNotEmpty
            ? () => _showDayRisks(context, date)
            : null,
        child: Container(
          decoration: BoxDecoration(
              color: dayRisks.isNotEmpty
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF1a2332)
                        : Color(0xFFe3f2fd))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: dayRisks.isNotEmpty
                    ? AppTheme.accentColor.withValues(alpha: .5)
                    : Colors.transparent,
              ),
            ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][index],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                '${date.day}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: dayRisks.isNotEmpty
                      ? AppTheme.accentColor
                      : Colors.grey,
                ),
              ),
              if (dayRisks.isNotEmpty)
                Text(
                  '${dayRisks.length} risks',
                  style: TextStyle(fontSize: 10, color: AppTheme.accentColor),
                ),
            ],
          ),
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) => Expanded(child: d)).toList(),
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
      'December',
    ];
    return months[month - 1];
  }
}
