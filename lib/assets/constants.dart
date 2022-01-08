class FeedConstants {
  static const String iconName = 'favicon.ico';
  static const String RSS = 'rss';
  static const String Atom = 'atom';
}

class DatabaseConstants {
  static const String database = "fluent_rss.db";
  static const int version = 1;
}

class TableNameConstants {
  static const String category = "category";
  static const String article = "article";
  static const String articleStatus = "articleStatus";
  static const String channel = "channel";
  static const String channelStatus = "channelStatus";
}

class TableDefinitionConstants {
  static const String categoryTable = """ create table if not exists category(
            id integer primary key autoincrement,
            name text
            ) """;
  static const String channelTable = """create table if not exists channel(
            link text primary key,
            title text,
            description text,
            type text,
            version text,
            iconUrl text,
            channelStatusId integer,
            categoryId integer ,
            foreign key (categoryId) references category (id) 
            ON DELETE CASCADE
          ) """;
  static const String channelStatusTable =
      """ create table if not exists channelStatus(
          channelLink text prikary key,
          lastCheck integer,
          unreadCount integer,
          totalCount integer,
          foreign key (channelLink) references channel (link) 
          ON DELETE CASCADE
          )
      """;
  static const String articleTable = """create table if not exists article(
        uuid text primary key not null,
        link text ,
        channel text ,
        title text,
        subtitle text,
        published integer,
        foreign key (channel) references channel (link)
        ON DELETE CASCADE
      )  """;
  static const String articleStatusTable =
      """create table if not exists articleStatus(
        articleId text primary key,
        read integer ,
        starred integer,
        foreign key (articleId) references article (uuid)
        ON DELETE CASCADE
      )  """;
}
