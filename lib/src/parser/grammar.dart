part of cone.parser;

class LedgerGrammarDefinition extends GrammarDefinition {
  const LedgerGrammarDefinition();

  Parser start() => ref(journal).end();

  Parser journal() => ref(journalItem).star();
  Parser journalItem() => ref(journalItemWhitespace) | ref(transaction);

  Parser journalItemWhitespace() => ref(newline) | ref(comment) & ref(newline);

  Parser transaction() =>
      ref(date) &
      (char('=') & ref(date)).optional() &
      whitespace().star() &
      ref(status).optional() &
      ref(description).optional() &
      ref(note).optional() &
      ref(newline) &
      ref(postings);

  Parser date() => ref(dateComponent).separatedBy(ref(dateSep));
  Parser dateComponent() => digit().plus();
  Parser dateSep() => anyOf('/-.');
  Parser status() => anyOf('!*');
  Parser description() => any().starLazy(char(';') | ref(newline));
  Parser note() => ref(comment);

  Parser postings() => ref(posting).star();
  Parser posting() =>
      whitespace().plus() &
      (ref(status) & whitespace().plus()).optional() &
      ref(account) &
      (whitespace().repeat(2, unbounded) & ref(amount)).optional() &
      ref(note).optional() &
      ref(newline);

  Parser account() => any()
      .starLazy(whitespace().repeat(2, unbounded) | char(';') | ref(newline));
  Parser amount() => any().starLazy(char(';') | ref(newline));

  Parser whitespace() => pattern(' \t');
  Parser newline() => Token.newlineParser();
  Parser comment() => char(';') & any().starLazy(ref(newline));
}

class LedgerGrammar extends GrammarParser {
  LedgerGrammar() : super(const LedgerGrammarDefinition());
}
