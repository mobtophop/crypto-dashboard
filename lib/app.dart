import 'package:crypto_screen/app/screens/main/screen_main.dart';
import 'package:crypto_screen/data/repositories_impl/cur_data/impl_repository_coinlayer.dart';
import 'package:crypto_screen/data/repositories_impl/cur_data/impl_repository_mobula.dart';
import 'package:crypto_screen/domain/entities/cur_info/converter_coinlayer.dart';
import 'package:crypto_screen/domain/entities/cur_info/converter_mobula.dart';
import 'package:crypto_screen/domain/providers/provider_cur_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: MultiProvider(
          providers: [
            Provider(
              create: (_) => ProviderCurData(
                repository: ImplRepositoryMobula(),
                convert: ConverterMobula.c,
              ),
            ),
          ],
          child: const ScreenMain(),
        ),
      ),
    );
  }
}
