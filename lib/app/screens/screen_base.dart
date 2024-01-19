import 'package:crypto_screen/misc/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenBase extends StatelessWidget {
  const ScreenBase({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      bottomNavigationBar: _buildBottomAppBar(
        context,
        {
          Icons.home_outlined: () {},
          Icons.notifications_outlined: () {},
          Icons.show_chart_rounded: () {},
          Icons.person_outline: () {},
        },
      ),
      body: child,
    );
  }

  Widget _buildBottomAppBar(
    BuildContext context,
    Map<IconData, Function()> icons,
  ) {
    return BottomAppBar(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Row(
        children: List.generate(
          icons.length,
          (index) => Expanded(
            child: InkWell(
              child: Center(
                child: Icon(
                  icons.keys.elementAt(index),
                  color: index == 2 ? AppColors.fgSelection : null,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}
