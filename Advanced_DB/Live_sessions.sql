create database live_session_advanced_sql;

use live_session_advanced_sql;

select * from oscar_nominees;

select distinct year from oscar_nominees;

-- WAQ to return all the winners in the 'actor in a leading role' and 'actress in a leading role'
-- category of the year is 1980

select * from oscar_nominees 
where category in ('actor in a leading role' , 'actress in a supporting role');

-- WAQ to return all the records where the movie was released in 2005 and the movie name
 -- does not start with 'a' and 'c' and nominee was a winner
 
SELECT year
        ,category
        ,nominee
        ,movie
        ,winner
        ,id
FROM oscar_nominees
WHERE year = 2005
        AND lower(movie) NOT LIKE 'a%'
        AND lower(movie) NOT LIKE 'c%' AND 
 winner = 'true';
 
 
 SELECT * FROM kag_conversion_data;
 
 
-- WAQ to show the fb_campaign_id and total interest per fb_campaign_id.
-- Only show the campaign which has more than 300 interests.
select fb_campaign_id,
sum(interest) as total_interest
from kag_conversion_data
group by fb_campaign_id
having sum(interest) > 300
order by sum(interest) desc;



select * from college_football_players;
select * from college_football_teams;

-- WAQ to find the total number of players playing in each conference.
-- Order the output in the descending order of the number of players.
select teams.conference,
	   count(players.player_name) as num_players
from college_football_players as players
join college_football_teams as teams
on players.school_name = teams.school_name
group by teams.conference
order by num_players desc;


-- WAQ to return to the conference where average weight is more than 210.
-- Order the output in the descending order of average weight.
-- Hints: avg, join, group by, having, order by
select t.conference, avg(p.weight) as avg_weight
from college_football_teams t
join college_football_players p 
on t.school_name = p.school_name
group by t.conference
having avg_weight > 210
order by avg_weight desc;


select * from sat_scores;
-- https://www.sqlshack.com/wp-content/uploads/2017/06/word-image-94.png
-- WAQ to add column - avg_sat_writing. Each row in this column should include
-- average marks in thw writing section of the student per school.
select *,
	   avg(sat_writing) over(partition by school) as avg_sat_writing
from sat_scores;

-- In the above question add an additional column - count_per_school.
-- Each row of this column should include number of students per school.
select *,
	   avg(sat_writing) over(partition by school) as avg_sat_writing,
       count(student_id) over(partition by school) as count_per_school
from sat_scores;

-- WAQ to rank the students per school on the basis of scores in verbal.
-- Use both rank and dense_rank function. Students with highest mark should get rank 1.
-- https://www.sqlshack.com/wp-content/uploads/2019/07/difference-between-rank-and-dense_rank.png
select *,
	   rank() over (partition by school order by sat_verbal desc) as score_verbal_rank,
       dense_rank() over (partition by school order by sat_verbal desc) as score_verbal_dense_rank
from sat_scores;

-- WAQ to find the top 5 students per teacher who spent maximum hours studying.
select teacher, student_id
from
	(
		select *,
        row_number()over(partition by teacher order by hrs_studied desc) as rank_num
        from sat_scores
    ) a
where rank_num<6;


    

