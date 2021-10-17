import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcrypto/bloc/currency_event.dart';
import 'package:qcrypto/bloc/currency_state.dart';
import 'package:qcrypto/repositories/currency_reposityory.dart';

class CurrencyBloc extends Bloc<CurrenyEvent, CurrenyState> {
  final CurrencyRepository repository;
  CurrencyBloc({required this.repository}) : super(CurrencyEmpty());

  @override
  CurrenyState get initialState => CurrencyEmpty();

  @override
  Stream<CurrenyState> mapEventToState(CurrenyEvent event) async* {
    if (event is FetchCurrency) {
      yield CurrencyLoading();
      try {
        final currencies = await repository.getCurrencies();
        yield CurrencyLoaded(currencies: currencies);
      } catch (_) {
        yield CurrencyError();
      }
    }
    if (event is CurrencyEventRefresh) {
      final currencies = await repository.getCurrencies();

      yield CurrencyStateRefresh(currencies: currencies);
      try {
        yield CurrencyLoaded(currencies: currencies);
      } catch (_) {
        yield CurrencyError();
      }
    }
  }
}
