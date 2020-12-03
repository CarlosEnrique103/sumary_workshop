# Leer csv
# Para cada uno de las fila debo insertalas en la db
require "csv"
require "pg"
filename = ARGV.shift
DB = PG.connect(dbname: "booking")

def create(data, table)
	# INSERT INTO authors(data.keys.join(', ')) VALUES (
	#	data.values.join(', ')
	#RETURNING *;
	data.transform_value! { |value| "'#{value.gsub("'", "''")}'"}
	res = DB.exec("INSERT INTO #{table} (#{data.keys.join(', ')}) VALUES (#{data.values.join(', ').to_s}) RETURNING *;	")
	res.first
end

def find(column, value, table)

	value = "'#{value.gsub("'", "''")}'"
	# SELECT column FROM  authors name = value
	DB.exec("SELECT * FROM  #{table} #{column} = #{value} ;")
	res.first 
end

def find_or_create(table, data, column)
	find(table, column, data[column.to_sym]) || create(data, table)
end

CSV.foreach(FILE.read(filename), headers: true) do |row|
	author_data = { 
		name: row["author_name"],
		nationality: row["author_nationality"],
		birthdate: row["author_birthdate"]
	}

	author = find_or_create("authors", author_data, "name")
	pp author
	# Insertar author en la data
	genre_data = { 
		name: row["genre"],
	}
	genre = find_or_create("genres", genre_data, "name")
	pp genre
	# Insertar genre en la db

	publisher_data = { 
		name: row["publisher_name"],
		anual_revenue: row["publisher_annual_revenue"],
		founded_year: row["publisher_founded_year"]
	}
	publisher = find_or_create("publishers", publisher_data, "name")
	pp publisher

	book_date = { 
		title: row["title"],
		pages: row["pages"],
		author: author["id"],
		publisher: publisher["id"] 
	}
	movie = find_or_create("books", book_date, "title")

	books_genres_data = {
		book_id: book["id"],
		genre_id: genre["id"]
	}

	create(books_genres_data, "books_genres")
end