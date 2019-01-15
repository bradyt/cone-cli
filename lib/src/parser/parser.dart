part of cone.parser;

class LedgerParserDefinition extends LedgerGrammarDefinition {
  Parser transaction() =>
      super.transaction().permute([0, 1, 3, 4, 7]).map((it) {
        print(it[4].runtimeType);
      });
  // Parser transaction() => super.transaction().map((it) {
  //       Date effectiveDate = it[1] != null ? it[1][1] : null;
  //       Status status = it[3] != null ? it[3] : Status.unmarked;
  //       return PlainTransaction(it[0], effectiveDate, status, it[4], it[7]);
  //     });

  Parser postings() => super.postings().map((it) {
        print('postings');
        for (var posting in it) {
          print(posting.runtimeType);
        }
        print(it);
        return it;
      });
  @override
  Parser<Posting> posting() => super.posting().map((it) {
        Status status = it[1] != null ? it[1] : Status.unmarked;
        return it[3] != null
            ? Posting(status, it[2], it[3])
            : Posting(status, it[2]);
      });

  Parser date() => super.date().map((it) => Date(it[0], it[2], it[4]));
  Parser dateComponent() =>
      super.dateComponent().flatten().map((it) => int.parse(it));
  Parser description() => super.description().flatten().map((it) => it.trim());
  Parser account() => super.account().flatten().map((it) => it.trim());
  Parser values() => super.values().pick(1).flatten().map((it) => it.trim());

  Parser status() => super.status().map((it) {
        return (it == '!') ? Status.pending : Status.cleared;
      });

  // Status parseStatus(it) {
  //   Status status;
  //   if (it == null) {
  //     status = Status.unmarked;
  //   } else {
  //     status = it;
  //   }
  //   return status;
  // }

  // // start() => super.start().map((it) {
  // //       List<Transaction> transactions =
  // //           it.where((it) => it is Transaction).toList();
  // //       return Journal(transactions);
  // //     });
  // Parser status() => super.status().flatten().trim();
  // Parser description() => super.description().flatten().map((it) => it.trim());
  // Parser description() => super.description().flatten().trim();
}

class LedgerParser extends GrammarParser {
  LedgerParser() : super(LedgerParserDefinition());
}
