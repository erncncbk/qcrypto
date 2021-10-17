import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcrypto/bloc/currency_bloc.dart';
import 'package:qcrypto/bloc/currency_event.dart';
import 'package:qcrypto/bloc/currency_state.dart';
import 'package:qcrypto/constant/constant.dart';
import 'package:qcrypto/models/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChartData> data = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final itemsBloc = BlocProvider.of<CurrencyBloc>(context)
          ..add(CurrencyEventRefresh());
        return itemsBloc.repository.getCurrencies();
      },
      child: BlocBuilder<CurrencyBloc, CurrenyState>(
          buildWhen: (previous, current) => current is CurrencyLoaded,
          builder: (context, state) {
            if (state is CurrencyEmpty) {
              BlocProvider.of<CurrencyBloc>(context).add(FetchCurrency());
            }

            if (state is CurrencyStateRefresh) {
              return _cryptoWidget(state.currencies);
            }

            if (state is CurrencyError) {
              return Center(
                child: Text('failed to fetch currencies'),
              );
            }
            if (state is CurrencyLoaded) {
              return _cryptoWidget(state.currencies);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _cryptoWidget(List<dynamic> currencies) {
    return currencies.length > 0
        ? Container(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final MaterialColor color =
                    Colors.primaries[Random().nextInt(Colors.primaries.length)];
                data = [
                  ChartData(
                    currencies[index]['quote']['USD']['percent_change_60d'],
                    1440,
                  ),
                  ChartData(
                    currencies[index]['quote']['USD']['percent_change_30d'],
                    720,
                  ),
                  ChartData(
                    currencies[index]['quote']['USD']['percent_change_7d'],
                    168,
                  ),
                  ChartData(
                    currencies[index]['quote']['USD']['percent_change_24h'],
                    24,
                  ),
                  ChartData(
                    currencies[index]['quote']['USD']['percent_change_1h'],
                    1,
                  )
                ];

                return _getListItemUi(currencies[index], color);
              },
            ),
          )
        : Container();
  }

  Widget _getListItemUi(Map currency, MaterialColor color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset(2, 2))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: Image.network(
                    (Constant.coinIconUrl() + currency['symbol'] + '.png')
                        .toLowerCase(),
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.low,
                    cacheHeight: 500,
                    cacheWidth: 500,
                    scale: 0.1,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade300),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar(
                        backgroundColor: color,
                        child: Text(currency['name'][0]),
                      );
                    },
                  ),
                ),
                FittedBox(
                  child: Text(
                    currency['name'].toString().length > 14
                        ? currency['symbol']
                        : currency['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                FittedBox(
                  child: Text(
                    '\$' + currency['quote']['USD']['price'].toStringAsFixed(9),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                height: 120,
                width: double.infinity,
                child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(isVisible: false),
                    primaryYAxis: CategoryAxis(isVisible: false),
                    legend: Legend(isVisible: false),
                    tooltipBehavior: TooltipBehavior(enable: false),
                    series: <ChartSeries<ChartData, String>>[
                      LineSeries<ChartData, String>(
                          dataSource: data,
                          xValueMapper: (ChartData data, _) =>
                              data.year.toString(),
                          yValueMapper: (ChartData data, _) => data.value)
                    ])),
          ),
          Container(
            width: 60,
            height: 24,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: currency['quote']['USD']['percent_change_1h'] >= 0
                    ? Colors.green
                    : Colors.red,
                borderRadius: BorderRadius.circular(10)),
            child: FittedBox(
              child: Text(
                currency['quote']['USD']['percent_change_1h']
                        .toStringAsFixed(2) +
                    "%",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
