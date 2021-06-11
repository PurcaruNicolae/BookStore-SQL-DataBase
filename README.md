# BookStore-SQL-DataBase
<p>Connection to SQL was realised according with XAMPP software which allow to connect to MySQL database. </p>
<p>The project was developed according with MySQL Workbench.</p>
<p>The first think to create the BookStore DataBase was to create the database in which we want to work and also 
to create the table "book" and "author" with a relation of one to many between them as follow: </p>
<img src="Images/img1.png" width=600px>
<p>In the next step was to populate the tables with some value.</p>
<p>Author table:</p>
<img src="Images/img2.png" width=600px>
<p>Book table:</p>
<img src="Images/img3.png" width=600px>
<p>Next, some queries will be performed as follows:</p>
<ul>
  <li>Create a view which will display all the authors who have more or equal than 2 books.</li>
  <img src="Images/img4.png" width=400px>
  <li>Display all the book title of the author who wrote the book '50000 de leghe sub mari'.</li>
  <img src="Images/img5.png" width=400px>
  <li>Create a function which has as input parameter an "id" of "book" and return a single row made of "title" and
    "author".</li>
  <img src="Images/img6.png" width=400px>
  <li>Create a procedure which has an input parameter "year of the book" and "maximum price
    and display a list with all the books with the conditions to respect the input parameters"</li>
  <img src="Images/img8.png" width=400px>
  <li>Create a trigger which will be activated after insert into book table.</li>
  <img src="Images/img7.png" width=400px>
</ul>

