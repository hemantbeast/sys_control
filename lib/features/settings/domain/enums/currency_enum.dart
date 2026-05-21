enum CurrencyEnum {
  usd(r'$', 'USD'),
  eur('€', 'EUR'),
  gbp('£', 'GBP'),
  jpy('¥', 'JPY'),
  inr('₹', 'INR');

  const CurrencyEnum(this.symbol, this.code);

  final String symbol;
  final String code;

  static CurrencyEnum fromSymbol(String symbol) {
    return values.firstWhere(
      (e) => e.symbol == symbol,
      orElse: () => CurrencyEnum.usd,
    );
  }
}