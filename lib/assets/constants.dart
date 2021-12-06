class TableNameConstants {
  static const article = "article";
  static const history = "history";
  static const favorite = "favorite";
  static const channel = "channel";
}

class TableDefinitionConstants {
  static const articleTable = """create table if not exists article(
        uuid text primary key,
        link text ,
        channel text ,
        title text,
        subtitle text,
        published integer
      )  """;
  static const historyTable = """ create table if not exists history(
        uuid text primary key,
        link text ,
        channel text ,
        title text,
        subtitle text,
        published integer
      ) """;
  static const favoriteTable = """create table if not exists favorite(
        uuid text primary key,
        link text ,
        channel text ,
        title text,
        subtitle text,
        published integer
      )  """;
  static const channelTable = """create table if not exists channel(
            link text primary key,
            title text,
            description text,
            type text,
            version text,
            icon text
          ) """;
}
