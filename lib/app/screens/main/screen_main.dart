import 'dart:math';

import 'package:crypto_screen/app/screens/main/cubit/cubit_main.dart';
import 'package:crypto_screen/app/screens/main/cubit/state_main.dart';
import 'package:crypto_screen/app/screens/screen_base.dart';
import 'package:crypto_screen/app/screens/main/widgets/cur_info_card.dart';
import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';
import 'package:crypto_screen/domain/providers/provider_cur_data.dart';
import 'package:crypto_screen/misc/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CubitMain(),
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _sendUpdateRequest(context),
        );
        return BlocBuilder<CubitMain, StateMain>(
          builder: (context, state) {
            CubitMain bloc = BlocProvider.of<CubitMain>(context);

            return ScreenBase(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _sendUpdateRequest(context);
                },
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9999),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.fgGreyDark,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                        const Flexible(
                          child: Text(
                            "Assets",
                            style: TextStyle(
                              color: AppColors.fgGreyDark,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9999),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.more_vert,
                                  color: AppColors.fgGreyDark,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (state.curList.isEmpty) ...[
                                const Expanded(
                                  child: CurInfoCard.square(
                                    curInfo: null,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: CurInfoCard.square(
                                    curInfo: null,
                                  ),
                                ),
                              ],
                              if (state.curList
                                  .any((e) => e.shortName == "BTC"))
                                Expanded(
                                  child: CurInfoCard.square(
                                    curInfo: state.curList.firstWhere(
                                      (e) => e.shortName == "BTC",
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 14),
                              if (state.curList
                                  .any((e) => e.shortName == "ETH"))
                                Expanded(
                                  child: CurInfoCard.square(
                                    curInfo: state.curList.firstWhere(
                                      (e) => e.shortName == "ETH",
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Market",
                              style: TextStyle(
                                color: AppColors.fgGreyDark,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              border: Border.all(
                                color: AppColors.fgGreyLight,
                              ),
                              color: Colors.white,
                            ),
                            child: TextField(
                              onChanged: bloc.changeSearchQuery,
                              decoration: const InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.only(
                                    left: 14.0,
                                    top: 16.0,
                                    bottom: 16.0,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: AppColors.fgGreyLight1,
                                  ),
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: AppColors.fgGreyLight1,
                                  fontSize: 14.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTab(
                                context,
                                isActive: true,
                                label: "USD",
                              ),
                              _buildTab(
                                context,
                                label: "12h volume",
                              ),
                              _buildTab(
                                context,
                                label: "24h volume",
                              ),
                              _buildTab(
                                context,
                                label: "Popular",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ..._buildInfoRows(context, state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  List<Widget> _buildInfoRows(BuildContext context, StateMain state) {
    if (state.curList.isEmpty) {
      return List.generate(
        10,
        (i) => const Padding(
          padding: EdgeInsets.only(bottom: 14.0),
          child: CurInfoCard.row(
            curInfo: null,
          ),
        ),
      );
    }

    List<EntityCurInfo> list = state.curList
        .where(
          (c) =>
              c.name.toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  ) ||
              c.shortName.toLowerCase().contains(
                    state.searchQuery..toLowerCase(),
                  ),
        )
        .toList();

    return List.generate(
      min(list.length, 16),
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: CurInfoCard.row(curInfo: list[index]),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    bool isActive = false,
    required String label,
  }) {
    return Material(
      color: isActive ? AppColors.fgSelection : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        overlayColor: isActive
            ? MaterialStateColor.resolveWith(
                (_) => Colors.white.withOpacity(0.5),
              )
            : null,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.fgGrey,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _sendUpdateRequest(BuildContext context) async {
    BlocProvider.of<CubitMain>(context).changeCurList(
      await context.read<ProviderCurData>().getData(),
    );
  }
}
