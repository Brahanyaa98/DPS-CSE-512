select G.name as name, count(H.movieid) as moviecount into query1 from genres G, hasagenre H where G.genreid = H.genreid group by G.name

select G.name as name, avg(R.rating) as rating into query2 from genres G, hasagenre H, ratings R where R.movieid = H.movieid group by G.name

select M.title as title, count(R.rating) as countofratings into query3 from movies M, ratings R where R.movieid = M.movieid group by M.title having count(R.rating) >= 10

select h.movieid as movieid, m.title as title into query4 from hasagenre h, movies m, genres g where h.movieid = m.movieid and g.name = 'comedy'

select m.title as title, avg(r.rating) as average into query5 from ratings r, movies m where m.movieid = r.movieid group by m.title

select avg(r.rating) as average into query6 from ratings r, movies m, genres g where m.movieid = r.movieid and g.name = 'comedy';

select m.movieid as movieid, m.title as movie, g.genreid as genreid, g.name as genre into temp from movies m, genres g, hasagenre h where h.movieid = m.movieid and h.genreid = g.genreid
select avg(r.rating) as average into query7 from ratings r, temp t where r.movieid = t.movieid and t.genre='Comedy' and t.movieid in (select movieid from temp where genre='Romance');

select m.movieid as movieid, m.title as movie, g.genreid as genreid, g.name as genre into temp from movies m, genres g, hasagenre h where h.movieid = m.movieid and h.genreid = g.genreid
select avg(r.rating) as average into query8 from ratings r, temp t where r.movieid = t.movieid and t.genre='Comedy' and t.movieid not in (select movieid from temp where genre='Romance');

SELECT movieid as movieid, rating as rating into query9 from ratings WHERE userid = :v1;

create view averagemovierating as select movies.movieid,t2.average average
from movies join(select movieid, avg(rating) as average from ratings
group by movieid ) t2 on t2.movieid=movies.movieid;

create view similarity as
select t1.movieid movieid,t2.movieid movieid2,(1-ABS(t1.average-t2.average)/5) similarity
from averagemovierating t1, (select movieid,average from averagemovierating) t2;

create table userrating as select movieid, rating from ratings where userid = v1;

create table numerator as select movieid1 movieid,sum(ratings*similarity) num_value from userrating
join similarity on userrating.movieid=CAST(similarity.movieid2 AS integer) group by movieid1;

create table denominator as select movieid1,movieid,sum(similarity) as denom_value from similarity
where movieid2 in (select movieid from ratings where userid=:v1)
group by movieid1;

create table recommendation as select title as title from movies
where movieid in (select numerator.movieid 
from numerator join denominator on numerator.movieid=denominator.movieid
where (numerator.num_value/denominator.denom_value)>3.9;