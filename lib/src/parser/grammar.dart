part of cone.parser;

class LedgerGrammarDefinition extends GrammarDefinition {
  const LedgerGrammarDefinition();

  Parser start() => ref(journal).end();

  Parser journal() => ref(journalItem).star();
  Parser journalItem() => ref(journalItemWhitespace) | ref(transaction);

  Parser journalItemWhitespace() => ref(newline) | ref(note) & ref(newline);

  Parser transaction() =>
      ref(date) &
      ref(effectiveDate).optional() &
      char(' ').star() &
      ref(status).optional() &
      ref(description).optional() &
      ref(note).optional() &
      ref(newline) &
      ref(postings);

  Parser date() => ref(dateComponent).separatedBy(ref(dateSep));
  Parser dateComponent() => digit().plus();
  Parser dateSep() => anyOf('/-.');
  Parser effectiveDate() => char('=') & ref(date);
  Parser status() => anyOf('!*');
  Parser description() => any().starLazy(char(';') | ref(newline));

  Parser postings() => ref(posting).star();
  Parser posting() =>
      char(' ').plus() &
      ref(status).optional() &
      ref(account) &
      ref(values).optional() &
      ref(note).optional() &
      ref(newline);

  Parser account() =>
      any().starLazy(char(' ').times(2) | char(';') | ref(newline));
  Parser values() =>
      char(' ').times(2) & any().starLazy(char(';') | ref(newline));

  Parser newline() => Token.newlineParser();
  Parser note() => char(';') & any().starLazy(ref(newline));
}

class LedgerGrammar extends GrammarParser {
  LedgerGrammar() : super(const LedgerGrammarDefinition());
}
