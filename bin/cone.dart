import 'package:cone/parser.dart';
import 'package:petitparser/petitparser.dart';
// ignore: unused_import
import 'package:petitparser/debug.dart';

// const String ledgerString = '''
// 2018-01-01 Opening balance
//   Assets:Checking  5.00 USD
//   Equity
// ''';

const String ledgerString = '''
; My ledger file

2018/01/01=2018/02/29 ! four score and seven years ago ; a comment
  ! assets:accounts receivable  USD 500
  equity

2019.02.03
  expenses  300 USD
  assets ; hello world
''';

final LedgerParser ledger = LedgerParser();

void main() {
  print(ledgerString);
  // trace(ledger).parse(ledgerString);
  Result journal = ledger.parse(ledgerString);
  // print(journal);
  print(journal.value);
  // for (var journalItem in journal.children) {
  //   print(journalItem);
  // }
}
