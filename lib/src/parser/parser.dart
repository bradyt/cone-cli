part of cone.parser;

class LedgerParserDefinition extends LedgerGrammarDefinition {
  // start() => super.start().map((it) {
  //       List<Transaction> transactions =
  //           it.where((it) => it is Transaction).toList();
  //       return Journal(transactions);
  //     });
  Parser transaction() => super.transaction().permute([0, 1, 3, 4, 7]);
  Parser posting() => super.posting().map((it) {
        Status status = it[1] != null ? it[1][0] : Status.unmarked;
        Posting posting;
        if (it[3] != null) {
          posting = Posting(status, it[2], it[3]);
        } else {
          posting = Posting(status, it[2]);
        }
        return posting;
      });

  Parser date() => super.date().map((it) => Date(it[0], it[2], it[4]));
  Parser dateComponent() =>
      super.dateComponent().flatten().map((it) => int.parse(it));
  Parser description() => super.description().flatten().map((it) => it.trim());
  Parser account() => super.account().flatten().map((it) => it.trim());
  Parser amount() => super.amount().pick(1).flatten().map((it) => it.trim());
  Parser status() =>
      super.status().map((it) => (it == '!') ? Status.pending : Status.cleared);
}

class LedgerParser extends GrammarParser {
  LedgerParser() : super(LedgerParserDefinition());
}
