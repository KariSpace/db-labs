
CREATE TABLE IF NOT EXISTS LibraryBooks (
  "book_id" varchar(50),
  "library_id" varchar(100)
);





CREATE TABLE IF NOT EXISTS Librarys (
  "id" varchar(100),
  "city" varchar(50),
  "address" varchar(1000)
);


CREATE TABLE IF NOT EXISTS Books (
  "id" varchar(150),
  "author" varchar(50),
  "genre" varchar(50)
);

CREATE TABLE IF NOT EXISTS Clients (
  "id" varchar(100),
  "first_name" varchar(50),
  "last_name" varchar(50),
    "email" varchar(50),
    "gender" varchar(100),
  "favorite_genre" varchar(50)

);
