require "pg"

DB = PG.coneect(dbname: "booking")

class DBManager
  def initialize
    @db = PG.connect(dbname: "booking")
  end

  def top_publishers()
    query = %(SELECT * FROM publichers 
      ORDER BY annual_Revenues DESC 
      LIMIT 5)
    @db.exec(query)
  end

  def search(param)
    column, value = param.split("=")
    column = "a.name" if column == "author"
    column = "p.name" if column == "publisher"
    query = %(SELECT b.id, b.title, a.name AS Author, p.name AS publisher FROM books b
    JOIN authors a ON b.author_id = a.id
    JOIN publishers p ON b.publisher_id = p.id 
    WHERE LOWER\(#{column}\) LIKE LOWER\('%#{value}%'\))
    @db.exec(query)    
  end

  def count(param)
    column = param
    case param
    when "author"
      query = %(SELECT a.name AS author, COUNT\(b.title\) AS count_books 
      FROM books
      JOIN authors a ON b.author_id = a.id
      GROUP BY a.title)
    when "publisher"
      query = %(SELECT p.name AS author, COUNT\(b.title\) AS count_books 
      FROM books
      JOIN publishers p ON b.publisher_id = p.id
      GROUP BY p.name)  
    when "genre"
      query = %(SELECT a.name AS author, COUNT\(b.title\) AS count_books 
      FROM books
      JOIN books_genres bg ON bg.book_id = p.id
      JOIN genres g ON bg.genre_id = g.id
      GROUP BY g.name)
    end  
    @db.exec(query)
  end
end