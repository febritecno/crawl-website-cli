class SQLITE
  db_path = './db/logs.db'
  def connect
    begin
      db = SQLite3::Database.open db_path
      db.execute "CREATE TABLE IF NOT EXISTS result_crawler(id INTEGER constraint result_crawler_pk primary key autoincrement, name varchar, price varchar, details varchar, timestamp DATETIME default CURRENT_TIMESTAMP, insert_id INTEGER not null)"
    rescue SQLite3::Exception => e
      puts 'Exception occurred'
      puts e
    ensure
      return db
    end
  end
end
