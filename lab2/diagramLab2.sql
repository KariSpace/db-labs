CREATE TABLE "Clients" (
  "id" SERIAL PRIMARY KEY,
  "first_name" varchar(50),
  "last_name" varchar(50),
  "phone" varchar(12),
  "gender" varchar(10),
  "age" int,
  "favorite_genre" varchar(50),
  "subscription" bool,
  "subscription_expiration" datetime
);

CREATE TABLE "Books" (
  "id" SERIAL PRIMARY KEY,
  "genre" varchar(50),
  "autor" varchar(50),
  "library_id" INT
);

CREATE TABLE "Librarys" (
  "id" SERIAL PRIMARY KEY,
  "city" varchar(50),
  "address" varchar(100)
);

CREATE TABLE "LibraryBooks" (
  "id" SERIAL PRIMARY KEY,
  "book_id" varchar(50),
  "library_id" varchar(100)
);

CREATE TABLE "ReservedBooks" (
  "id" SERIAL PRIMARY KEY,
  "client_id" varchar(50),
  "book_id" varchar(100),
  "reservation_date" datetime
);

ALTER TABLE "Books" ADD FOREIGN KEY ("genre") REFERENCES "Clients" ("favorite_genre");

ALTER TABLE "Librarys" ADD FOREIGN KEY ("id") REFERENCES "Books" ("library_id");

ALTER TABLE "LibraryBooks" ADD FOREIGN KEY ("book_id") REFERENCES "Books" ("id");

ALTER TABLE "LibraryBooks" ADD FOREIGN KEY ("library_id") REFERENCES "Librarys" ("id");

ALTER TABLE "ReservedBooks" ADD FOREIGN KEY ("client_id") REFERENCES "Clients" ("id");

ALTER TABLE "ReservedBooks" ADD FOREIGN KEY ("book_id") REFERENCES "Books" ("id");
