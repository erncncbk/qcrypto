import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcrypto/bloc/currency_bloc.dart';
import 'package:qcrypto/pages/home_page.dart';
import 'package:qcrypto/repositories/currency_api_client.dart';
import 'package:qcrypto/repositories/currency_reposityory.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

Future main() async {
  Bloc.observer = SimpleBlocObserver();

  await dotenv.load(fileName: ".env");

  final CurrencyRepository repository =
      CurrencyRepository(currencyApiClient: CurrencyApiClient());

  runApp(MyApp(repository));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final CurrencyRepository repository;
  MyApp(this.repository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Q Cyrpto',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: defaultTargetPlatform == TargetPlatform.iOS
              ? Colors.white
              : null),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: new Text("New Cyrptocurrencies"),
          elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
        ),
        body: BlocProvider(
          create: (context) => CurrencyBloc(repository: repository),
          child: HomePage(),
        ),
      ),
    );
  }
}
