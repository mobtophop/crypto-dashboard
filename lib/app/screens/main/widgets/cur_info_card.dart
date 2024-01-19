import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';
import 'package:crypto_screen/misc/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum _CurInfoCardType {
  row,
  square,
}

class CurInfoCard extends StatelessWidget {
  const CurInfoCard.row({
    super.key,
    required this.curInfo,
  }) : _type = _CurInfoCardType.row;

  const CurInfoCard.square({
    super.key,
    required this.curInfo,
  }) : _type = _CurInfoCardType.square;

  final EntityCurInfo? curInfo;
  final _CurInfoCardType _type;

  @override
  Widget build(BuildContext context) {
    if (curInfo == null) {
      switch (_type) {
        case _CurInfoCardType.row:
          return _buildPlaceholderRowType(context);
        case _CurInfoCardType.square:
          return _buildPlaceholderSquareType(context);
      }
    }

    switch (_type) {
      case _CurInfoCardType.row:
        return _buildCardRowType(context);
      case _CurInfoCardType.square:
        return _buildCardSquareType(context);
    }
  }

  Widget _buildPlaceholderRowType(BuildContext context) {
    return _buildCardBg(
      context,
      child: _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholderSquareType(BuildContext context) {
    return _buildCardBg(
      context,
      child: AspectRatio(
        aspectRatio: 1,
        child: _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.placeholder,
      highlightColor: Colors.white54,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.placeholder,
              shape: BoxShape.circle,
            ),
            width: 38.0,
            height: 38.0,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.placeholder,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  width: 100.0,
                  height: 14.0,
                ),
                const SizedBox(height: 7.0),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.placeholder,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  width: 50.0,
                  height: 14.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardRowType(BuildContext context) {
    return _buildCardBg(
      context,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: _titleBlockWidgets(context),
            ),
          ),
          const SizedBox(height: 14.0),
          _buildGraph(context),
          const SizedBox(height: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _price(context),
                _delta(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSquareType(BuildContext context) {
    return _buildCardBg(
      context,
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: _titleBlockWidgets(context),
            ),
            const SizedBox(height: 14.0),
            _buildGraph(context),
            const SizedBox(height: 14.0),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: _price(context)),
                  const SizedBox(width: 7.0),
                  _delta(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBg(
    BuildContext context, {
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: child,
      ),
    );
  }

  List<Widget> _titleBlockWidgets(BuildContext context) {
    return [
      Image.network(
        curInfo!.iconUrl,
        width: 38.0,
        height: 38.0,
        errorBuilder: (_, __, ___) => Container(
          width: 38.0,
          height: 38.0,
          decoration: const BoxDecoration(
            color: AppColors.placeholder,
            shape: BoxShape.circle,
          ),
        ),
      ),
      const SizedBox(width: 14.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              curInfo!.name,
              style: const TextStyle(
                color: AppColors.fgGreyDark,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              curInfo!.shortName,
              style: const TextStyle(
                color: AppColors.fgGrey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildGraph(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 5 / 2,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      curInfo!.graph.length,
                      (x) => FlSpot(
                        x.toDouble(),
                        curInfo!.graph.reversed.elementAt(x),
                      ),
                    ),
                    dotData: const FlDotData(show: false),
                    color: curInfo!.delta < 0
                        ? AppColors.fgNegativeDelta
                        : AppColors.fgPositiveDelta,
                    barWidth: 2.0,
                  ),
                ],
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      List<LineTooltipItem> titles = [];

                      for (LineBarSpot spot in spots) {
                        titles.add(
                          LineTooltipItem(
                            spot.y.toStringAsFixed(2),
                            TextStyle(
                              color: curInfo!.delta < 0
                                  ? AppColors.bgNegativeDelta
                                  : AppColors.bgPositiveDelta,
                            ),
                          ),
                        );
                      }

                      return titles;
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _price(BuildContext context) {
    if (curInfo!.name.isEmpty) return const SizedBox.shrink();

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "\$${curInfo!.price.toStringAsFixed(2)}",
          style: const TextStyle(
            color: AppColors.fgGreyDark,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _delta(BuildContext context) {
    if (curInfo!.name.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: _type == _CurInfoCardType.square
          ? BoxDecoration(
              color: curInfo!.delta < 0
                  ? AppColors.bgNegativeDelta
                  : AppColors.bgPositiveDelta,
              borderRadius: BorderRadius.circular(9999),
            )
          : null,
      child: Padding(
        padding: _type == _CurInfoCardType.square
            ? const EdgeInsets.all(8.0)
            : EdgeInsets.zero,
        child: Text(
          "${curInfo!.delta < 0 ? "" : "+"}${curInfo!.delta.toStringAsFixed(2)}",
          style: TextStyle(
            color: curInfo!.delta < 0
                ? AppColors.fgNegativeDelta
                : AppColors.fgPositiveDelta,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
