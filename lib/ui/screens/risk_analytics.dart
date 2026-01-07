import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/category_box.dart';
import 'package:everyday_risk_analyzer/ui/widgets/default_appbar.dart';
import 'package:everyday_risk_analyzer/ui/widgets/pie_chart_painter.dart';
import 'package:flutter/material.dart';

class RiskOverviewScreen extends StatefulWidget {
  final List<RiskEntry> risks;

  const RiskOverviewScreen({super.key, required this.risks});

  @override
  State<RiskOverviewScreen> createState() => _RiskOverviewScreenState();
}

class _RiskOverviewScreenState extends State<RiskOverviewScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final monthlyRisk = RiskLogicEngine.filterByMonth(
      widget.risks,
      selectedMonth,
      selectedYear,
    );

    String overallRisk = RiskLogicEngine.calculateOverallRisk(monthlyRisk);

    var healthCat = RiskLogicEngine.calculateCategorySummary(
      monthlyRisk,
      'Health',
    );
    var safetyCat = RiskLogicEngine.calculateCategorySummary(
      monthlyRisk,
      'Safety',
    );
    var financeCat = RiskLogicEngine.calculateCategorySummary(
      monthlyRisk,
      'Finance',
    );

    int healthTotal =
        (healthCat['high'] ?? 0) +
        (healthCat['medium'] ?? 0) +
        (healthCat['low'] ?? 0);
    int safetyTotal =
        (safetyCat['high'] ?? 0) +
        (safetyCat['medium'] ?? 0) +
        (safetyCat['low'] ?? 0);
    int financeTotal =
        (financeCat['high'] ?? 0) +
        (financeCat['medium'] ?? 0) +
        (financeCat['low'] ?? 0);

    double healthPercent =
        (healthTotal / (healthTotal + safetyTotal + financeTotal + 0.001)) *
        100;
    double safetyPercent =
        (safetyTotal / (healthTotal + safetyTotal + financeTotal + 0.001)) *
        100;
    double financePercent =
        (financeTotal / (healthTotal + safetyTotal + financeTotal + 0.001)) *
        100;

    Color overallColor = overallRisk == 'High'
        ? AppTheme.highRiskColor
        : overallRisk == 'Medium'
        ? AppTheme.mediumRiskColor
        : AppTheme.lowRiskColor;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 5),
          Text(
            'Risk Analytics',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 20),
          _buildMonthSelector(),
          SizedBox(height: 20),
          // Overall Risk Score Card
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1a2332)
                  : Color(0xFFe3f2fd),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: overallColor.withValues(alpha: .5)),
            ),
            child: Column(
              children: [
                Text(
                  'Overall Risk Score',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 30),
                // Pie Chart
                CustomPaint(
                  size: Size(200, 200),
                  painter: PieChartPainter(
                    healthPercent: healthPercent,
                    safetyPercent: safetyPercent,
                    financePercent: financePercent,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Total Risks: ${healthTotal + safetyTotal + financeTotal}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                SizedBox(height: 12),
                _buildLegend(healthPercent, safetyPercent, financePercent),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Category Boxes
          CategoryBox(
            title: 'Health',
            data: healthCat,
            color: AppTheme.healthColor,
            risks: monthlyRisk,
            onRefresh: () {
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          CategoryBox(
            title: 'Safety',
            data: safetyCat,
            color: AppTheme.safetyColor,
            risks: monthlyRisk,
            onRefresh: () {
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          CategoryBox(
            title: 'Finance',
            data: financeCat,
            color: AppTheme.financeColor, 
            risks: monthlyRisk,
            onRefresh: () {
              setState(() {});
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLegend(
    double healthPercent,
    double safetyPercent,
    double financePercent,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Health', healthPercent, AppTheme.healthColor),
        _buildLegendItem('Safety', safetyPercent, AppTheme.safetyColor),
        _buildLegendItem('Finance', financePercent, AppTheme.financeColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, double percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 6),
        Text('$label (${percentage.toStringAsFixed(1)}%)', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          final isSelected = selectedMonth == index + 1;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = index + 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    months[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2,
                    width: isSelected ? 20 : 0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}