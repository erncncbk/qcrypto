abstract class CurrenyEvent {
  const CurrenyEvent();
}

class FetchCurrency extends CurrenyEvent {
  const FetchCurrency();
}

class CurrencyEventRefresh extends CurrenyEvent {}
