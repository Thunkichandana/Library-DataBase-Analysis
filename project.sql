CREATE DATABASE books_info;
USE books_info;
CREATE TABLE Publisher(PublisherName VARCHAR(40) PRIMARY KEY,PublisherAddress VARCHAR(200),PublisherPhone VARCHAR(40));
CREATE TABLE book(BookID INT AUTO_INCREMENT PRIMARY KEY,Title VARCHAR(100),publisherName VARCHAR(40), FOREIGN KEY(PublisherName) REFERENCES publisher(PublisherName) ON DELETE CASCADE);
CREATE TABLE book_authors(AuthorID INT AUTO_INCREMENT PRIMARY KEY,BookID INT,FOREIGN KEY(BookID) REFERENCES book(BookID) ON DELETE CASCADE,Author_Name VARCHAR(40));
CREATE TABLE library_branch(BranchID INT AUTO_INCREMENT PRIMARY KEY,BranchName VARCHAR(40),BranchAddress VARCHAR(60));
CREATE TABLE book_copies(CopiesID INT AUTO_INCREMENT PRIMARY KEY,BookID INT,FOREIGN KEY (BookID) REFERENCES book(BookID) ON DELETE CASCADE,BranchID INT,FOREIGN KEY (BranchID) REFERENCES library_branch(BranchID) ON DELETE CASCADE,No_Of_Copies INT);
CREATE TABLE borrower(CardNo INT PRIMARY KEY,BorrowerName VARCHAR(40),BorrowerAddress VARCHAR(100),BorrowerPhone VARCHAR(50));
CREATE TABLE book_loans(LoansID INT AUTO_INCREMENT PRIMARY KEY,BookID INT, FOREIGN KEY (BookID) REFERENCES book(BookID) ON DELETE CASCADE,BranchID INT,FOREIGN KEY (BranchID) REFERENCES library_branch(BranchID) ON DELETE CASCADE,CardNo INT,FOREIGN KEY(CardNo) REFERENCES borrower(CardNo) ON DELETE CASCADE,DateOut VARCHAR(40),DueDate VARCHAR(40));

SELECT * FROM publisher;
SELECT * FROM book;
SELECT * FROM book_authors;
SELECT * FROM library_branch;
SELECT * FROM book_copies;
SELECT * FROM borrower;
SELECT * FROM book_loans;

# Q1.
SELECT SUM(No_Of_Copies) AS TotalCopies
FROM book
JOIN book_copies ON book.BookId = book_copies.BookId
JOIN library_branch ON book_copies.BranchId = library_branch.BranchId 
WHERE book.Title = 'The Lost Tribe'
  AND library_branch.BranchName = 'Sharpstown'; 
  
# Q2.
SELECT lb.BranchName, bc.No_Of_Copies
FROM book b
JOIN book_copies bc ON b.BookID = bc.BookID
JOIN library_branch lb ON bc.BranchID = lb.BranchID
WHERE b.Title = 'The Lost Tribe';

# Q3.
SELECT BorrowerName
FROM borrower
WHERE CardNo NOT IN (
    SELECT CardNo
    FROM book_loans
);

# Q4.
SELECT b.Title, br.BorrowerName, br.BorrowerAddress
FROM book b
JOIN book_loans bl ON b.BookID = bl.BookID
JOIN borrower br ON bl.CardNo = br.CardNo
JOIN library_branch lb ON bl.BranchID = lb.BranchID
WHERE lb.BranchName = 'Sharpstown'
  AND bl.DueDate = '2/3/18';
  
# Q5.
SELECT lb.BranchName, COUNT(bl.LoansID) AS TotalLoans
FROM library_branch lb
INNER JOIN book_loans bl ON lb.BranchID = bl.BranchID
GROUP BY lb.BranchName;

# Q6.
SELECT b.BorrowerName, b.BorrowerAddress, COUNT(bl.LoansID) AS BooksCheckedOut
FROM borrower b
INNER JOIN book_loans bl ON b.CardNo = bl.CardNo
GROUP BY b.BorrowerName, b.BorrowerAddress
HAVING COUNT(bl.LoansID) > 5;

# Q7.
SELECT b.Title, SUM(bc.No_Of_Copies) AS TotalCopies
FROM book b
INNER JOIN book_copies bc ON b.BookID = bc.BookID
INNER JOIN library_branch lb ON bc.BranchID = lb.BranchID
WHERE b.Title
 IN (SELECT b2.Title
    FROM book b2
    INNER JOIN book_authors ba ON b2.BookID = ba.BookID
    WHERE ba.Author_Name = 'Stephen King')
AND lb.BranchName = 'Central'
GROUP BY b.Title;











