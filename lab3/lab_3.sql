-- 1. --
-- Библиотеки на улице

SELECT *
	FROM Librarys 
	WHERE address like '%Пушкинская%';   
    ORDER BY City;


-- 2. --
--  Розподіл на користувачів більше і менше 18

SELECT clients.first_name, clients.last_name, 
	case when (age > 18) then
		'adult'
	else
		'kid'
	end as type
	FROM clients;  


-- 3. --
-- Унікальні книги по алфавіту

SELECT distinct Books.name 
	FROM Books
ORDER BY name


-- 4. --
-- Останя зарезервована книга

SELECT ReservedBooks.client_id, ReservedBooks.book_id, 
    ReservedBooks.reservation_date
	FROM ReservedBooks
	WHERE reservation_date = 
		(SELECT max(reservation_date) 
			FROM cd.members);    
            

-- 5. --
-- Список міст, де є бібліотека

SELECT distinct Librarys.city 
	FROM Librarys
ORDER BY city


-- 6. --
-- Список міст користувачів

SELECT distinct Clients.city, Clients.first_name, 
    Clients.last_name
	FROM Clients
    ORDER BY city


-- 7. --
-- Клієнти, що резервували більше 25 книг

SELECT Clients.last_name, Clients.first_name, 
        COUNT(ReservedBooks.book_id) AS Number_of_books
FROM ReservedBooks
INNER JOIN clients 
    ON ReservedBooks.client_id = clients.id
HAVING COUNT(ReservedBooks.client_id) > 25;

-- 8. --
-- Книги конкретної бібліотеки

SELECT Books.id, Books.name, LibraryBooks.library_id, 
    LibraryBooks.book_id 
FROM Books 
INNER JOIN LibraryBooks ON Books.id = LibraryBooks.book_id
ORDER BY Books.name;


-- 9. --
-- Книги конкретної бібліотеки

SELECT Clients.first_name, Clients.last_name, 
    Clients.favorite_genre, Books.genre 
FROM Books 
WHERE last_name = 'John' OR first_name = 'Jonson'
INNER JOIN Clients ON Clients.favorite_genre = Books.genre
ORDER BY Books.genre ;

-- 10. --
-- Книги конкретної бібліотеки

SELECT  Books.id,  Books.name,  Books.genre,  
    Books.autor, COUNT(ReservedBooks.book_id) AS Number_of_books
FROM Books
WHERE id = ANY
  (SELECT id FROM ReservedBooks
  WHERE Number_of_books > 99);














Table "Clients" {
  "id" INT [pk, increment]
  "first_name" varchar(50)
  "last_name" varchar(50)
  "phone" varchar(12)
  "gender" varchar(10)
  "age" int
  "favorite_genre" varchar(50) [ref: < Books.genre]
  "subscription" bool
  "subscription_expiration" datetime
}
Table "Books" {
  "id" INT [pk, increment]
 // "warehouse_id" INT [ref: > warehouses.id]
  "name" varchar(50)
  "genre" varchar(50)
  "autor" varchar(50)
  "library_id"  INT [ref: < Librarys.id]
  
}
Table "Librarys" {
  "id" INT [pk, increment]
  "city" varchar(50)
  "address" varchar(100)
}
Table "LibraryBooks" {
  "id" INT [pk, increment]
  "book_id" varchar(50) [ref: - Books.id]
  "library_id" varchar(100) [ref: - Librarys.id]
}
Table "ReservedBooks" {
  "id" INT [pk, increment]
  "client_id" varchar(50) [ref: - Clients.id]
  "book_id" varchar(100) [ref: - Books.id]
  "reservation_date" datetime
}