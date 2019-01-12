part of cone.parser;

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
      (char(';') & (ref(newline).not() & any()).star()) & ref(newline);

  Parser transaction() =>
      ref(date) &
      ref(secondaryDate).optional() &
      ref(space).star() &
      ref(status).optional() &
      ref(description).optional() &
      ref(comment).optional() &
      ref(newline) &
      ref(postings);

  Parser date() => digit().repeat(2, 4).separatedBy(anyOf('/-.'));
  Parser secondaryDate() => char('=') & ref(date);
  Parser status() => anyOf('!*');
  Parser description() => noneOf(';\n').star();
  Parser comment() => char(';') & noneOf('\n').star();

  Parser postings() => ref(posting).star();
  Parser posting() =>
      ref(space).plus() &
      (ref(status) & ref(space).plus()).optional() &
      ref(account) &
      (ref(space).repeat(2, unbounded) & ref(amount)).optional() &
      ref(note).optional() &
      ref(newline);

  Parser account() =>
      ((ref(space).repeat(2, unbounded) | ref(newline) | char(';')).not() &
              any())
          .star();
  Parser amount() => noneOf(';\n').star();
  Parser note() => char(';') & noneOf('\n').star();

  Parser newline() => Token.newlineParser();
  Parser space() => newline().not() & whitespace();
}
