--1. Create a Database with any name
create database task
use task

--2. Import all the data in sql server with respective names
select * from links
select * from ratings
select * from movies
select * from tags

--3. Check whether there are any null values in all the dataset

select * from links where COALESCE (movieid, imdbid, tmdbid) is null
select * from ratings where COALESCE (userid,movieid, rating, timestamp) is null
select * from movies where COALESCE (movieid, title, genres) is null
select * from tags where COALESCE (userid,movieid, tag, timestamp) is null

--Observation (there is no null values in tables)

--4. Show top rated movies with movieid and movie name (number of rating for certain movie should be greater than 200, print it in decreasing order)

create view vtopmovie as
select m.movieid, m.title, r.rating from movies m, ratings r
where m.movieid=r.movieid

drop view vtopmovie
select * from vtopmovie

select movieid, title, sum(rating) as "Total Rating" from vtopmovie
group by movieid, title
having sum(rating)>200
order by sum(rating) desc 


--5. Show the top 10 movies only from above conditions
select top(10) movieid as "Movie ID", title as "Movie Title", sum(rating) as "Total Rating" from vtopmovie
group by movieid, title
having sum(rating)>200
order by sum(rating) desc 


--6. Show the top 10 users who have rated most number of movies (minimum number of rating should be 1000,Show the top 10 data only in descending order)

select top(10)userid as "User ID", sum(rating) "Total Rating by User" from ratings
group by userid, rating
having sum(rating)>1000
order by sum(rating) desc
--Create a Table Value Function in which if we pass the username it will return us a table in which we can see rated movies by user with all details
create function Enter_User_Name
(
@id int
)
returns table
as
return
(select ratings.userId, ratings.movieId, ratings.rating,ratings.timestamp from  dbo.ratings
 where userId = @id);
 select * from dbo.Enter_User_Name (5);

--8 Create a popularity based recommendation system which will recommend nearly 18 movies with following rules

--Most Rated movies their title name
--○ There total average rating
--○ Order them in descending order
--○ Also add movieid column
--○ Create whole code of the above question in a procedure with any name

Create procedure Top_18
as
begin
select top (18) movieid as "Movie ID", title as "Movie Title", avg(rating) as "Average Rating", count(rating) as "Number of Rating User" from vtopmovie
group by movieid, title
order by sum(rating) desc, count(rating) desc
end

exec Top_18