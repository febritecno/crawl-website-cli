class SQLITE
  def connect
    begin
      db = SQLite3::Database.open './db/logs.db'
      db.execute "CREATE TABLE IF NOT EXISTS logs_crawler(id INTEGER constraint logs_crawler_pk primary key autoincrement, name varchar, price varchar, details varchar, timestamp DATETIME default CURRENT_TIMESTAMP)"
    rescue SQLite3::Exception => e
      puts 'Exception occurred'
      puts e
    ensure
      return db
      db.close
    end
  end
end
