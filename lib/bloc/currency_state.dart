abstract class CurrenyState {
  const CurrenyState();
}

class CurrencyEmpty extends CurrenyState {}

class CurrencyLoading extends CurrenyState {}

class CurrencyLoaded extends CurrenyState {
  final List<dynamic> currencies;
  const CurrencyLoaded({required this.currencies});
}

class CurrencyError extends CurrenyState {}

class CurrencyStateRefresh extends CurrenyState {
  final List<dynamic> currencies;
  const CurrencyStateRefresh({required this.currencies});
}
