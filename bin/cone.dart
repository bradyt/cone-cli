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

2018-01-01 ! four score and seven years ago ; a comment
  assets  500 USD
  equity

2019-02-03
  expenses  300 USD
  assets
''';

class LedgerGrammar extends GrammarParser {
  LedgerGrammar() : super(const LedgerGrammarDefinition());
}

class LedgerGrammarDefinition extends GrammarDefinition {
  const LedgerGrammarDefinition();

  Parser start() => ref(journal).end();

  Parser journal() => ref(journalItem).star();
  Parser journalItem() => ref(journalItemWhitespace) | ref(transaction);

  Parser journalItemWhitespace() =>
      ref(newline) |
      char(';') & (ref(newline).not() & any()).star().flatten() & ref(newline);

  Parser transaction() =>
      ref(date) &
      ref(secondaryDate).optional() &
      ref(space).star() &
      ref(status).optional() &
      ref(description).optional() &
      ref(comment).optional() &
      ref(newline) &
      ref(postings);

  Parser date() => digit().repeat(2, 4).flatten().separatedBy(ref(dateSep));
  Parser secondaryDate() => char('=') & ref(date);
  Parser status() => pattern('!*');
  Parser description() => pattern('^;\n').star().flatten();
  Parser comment() => char(';') & pattern('^\n').star().flatten();

  Parser postings() => ref(posting).star();
  Parser posting() =>
      ref(space).plus() &
      (ref(status) & ref(space).plus()).optional() &
      ref(account) &
      (ref(space).repeat(2, unbounded) & ref(amount)).optional() &
      ref(newline);

  Parser account() => letter().star().flatten();
  Parser amount() =>
      (ref(number) & ref(space).star() & ref(currency)) |
      (ref(currency) & ref(space).star() & ref(number));

  Parser int4() => digit().repeat(4).flatten();
  Parser int2() => digit().repeat(2).flatten();
  Parser dateSep() => char('/') | char('-') | char('.');

  Parser number() => digit().star().flatten();
  Parser currency() => letter().star().flatten();

  Parser newline() => Token.newlineParser();
  Parser space() => newline().not() & whitespace();
}

final LedgerGrammar ledger = LedgerGrammar();

void main() {
  // print(ledgerString);
  // trace(ledger).parse(ledgerString);
  var result = ledger.parse(ledgerString);
  print(result);
}
