CREATE DATABASE booking;

CREATE TABLE  publishers(
    id SERIAL,
    name varchar(50),
    annual_revenues int NOT NULL DEFAULT 0,
    founded_year int NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE  authors(
    id serial,
    name varchar(50),
    nationality varchar(20),
    birthdate date,
    PRIMARY KEY (id)
);

CREATE TABLE genres (
    id serial,
    name varchar(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE books(
    id serial,
    title varchar(50) NOT NULL,
    pages int,
    author_id int NOT NULL,
    publisher_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (author_id) REFERENCES publishers(id),
);


CREATE TABLE books_genres(
    id serial,
    book_id int NOT NULL,
    genre_id int NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
);

