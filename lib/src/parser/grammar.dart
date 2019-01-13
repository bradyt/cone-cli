part of cone.parser;

class LedgerGrammarDefinition extends GrammarDefinition {
  const LedgerGrammarDefinition();

  Parser start() => ref(journal).end();

  Parser journal() => ref(journalItem).star();
  Parser journalItem() => ref(journalItemWhitespace) | ref(transaction);

  Parser journalItemWhitespace() => ref(newline) | ref(comment) & ref(newline);

  Parser transaction() =>
      ref(date) &
      ref(secondaryDate).optional() &
      ref(space).star() &
      ref(status).optional() &
      ref(description).optional() &
      ref(note).optional() &
      ref(newline) &
      ref(postings);

  Parser date() =>
      (ref(int4) & ref(dateSep)).optional() &
      ref(int2) &
      ref(dateSep) &
      ref(int2);
  Parser int4() => digit().times(4);
  Parser int2() => digit().times(2);
  Parser dateSep() => anyOf('/-.');
  Parser secondaryDate() => char('=') & ref(date);
  Parser status() => anyOf('!*');
  Parser description() => ref(fullstring);
  Parser note() => ref(comment);

  Parser postings() => ref(posting).star();
  Parser posting() =>
      ref(spacePlus) &
      (ref(status) & ref(spacePlus)).optional() &
      ref(account) &
      (ref(atLeastTwoSpaces) & ref(amount)).optional() &
      ref(note).optional() &
      ref(newline);

  Parser spacePlus() => ref(space).plus();
  Parser account() =>
      (ref(atLeastTwoSpaces) | ref(newlineOrSemiColon)).neg().star();
  Parser atLeastTwoSpaces() => ref(space).repeat(2, unbounded);
  Parser amount() => ref(fullstring);

  Parser newline() => Token.newlineParser();
  Parser notNewline() => ref(newline).neg();
  Parser newlineOrSemiColon() => ref(newline) | char(';');
  Parser notNewlineOrSemicolon() => ref(newlineOrSemiColon).neg();
  Parser space() => pattern(' \t');
  Parser fullstring() => ref(notNewlineOrSemicolon).star();
  Parser comment() => char(';') & any().starLazy(ref(newline));
}

class LedgerGrammar extends GrammarParser {
  LedgerGrammar() : super(const LedgerGrammarDefinition());
}
