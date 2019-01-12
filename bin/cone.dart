import 'package:petitparser/petitparser.dart';

// const String ledgerString = '''
// 2018-01-01 Opening balance
//   Assets:Checking  5.00 USD
//   Equity
// ''';

const String ledgerString =
    '2018-01-01 ! four score and seven years ago ; a comment';

class LedgerGrammar extends GrammarParser {
  LedgerGrammar() : super(const LedgerGrammarDefinition());
}

class LedgerGrammarDefinition extends GrammarDefinition {
  const LedgerGrammarDefinition();

  Parser start() => ref(journal).end();

  Parser journal() => ref(journalItem).star();
  Parser journalItem() => ref(transaction);

  Parser transaction() =>
      ref(date) &
      ref(secondaryDate).optional() &
      ref(status).optional() &
      ref(description).optional() &
      ref(comment).optional() &
      ref(postings);

  Parser date() =>
      ref(int4) & ref(dateSep) & ref(int2) & ref(dateSep) & ref(int2);
  Parser dateSep() => char('/') | char('-') | char('.');
  Parser int4() => digit().repeat(4).flatten();
  Parser int2() => digit().repeat(2).flatten();
  Parser secondaryDate() => char('=') & ref(date);

  Parser comment() =>
      (whitespace().star() & char(';') & pattern('^\n').star()).flatten();
  Parser description() =>
      (whitespace().star() & pattern('^;\n').star()).flatten().trim();
  Parser postings() => (char('\n') & ref(posting)).star();
  Parser posting() => whitespace().plus();

  Parser status() => whitespace().star() & pattern('!*');
}

final LedgerGrammar ledger = LedgerGrammar();

void main() {
  var result = ledger.parse(ledgerString);
  print(result);
}
