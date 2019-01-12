import 'package:cone/parser.dart';
// ignore: unused_import
import 'package:petitparser/debug.dart';

// const String ledgerString = '''
// 2018-01-01 Opening balance
//   Assets:Checking  5.00 USD
//   Equity
// ''';

const String ledgerString = '''
; My ledger file

2018-01-01 ! four score and seven years ago ; a comment
  assets:accounts receivable  USD 500
  equity

2019-02-03
  expenses  300 USD
  assets ; hello world
''';

final LedgerGrammar ledger = LedgerGrammar();

void main() {
  print(ledgerString);
  // trace(ledger).parse(ledgerString);
  var result = ledger.parse(ledgerString);
  print(result);
}
