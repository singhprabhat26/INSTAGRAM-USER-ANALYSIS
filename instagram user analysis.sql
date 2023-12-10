-- Task -1 - identify the top 5 oldest instagram users.

select * from users
order by created_at asc limit 5;

/*2.Task: Find the users who have never posted a single photo on Instagram*/

select 
	id,
    username 
from 
	users
where 
	id not in(select distinct(user_id) from photos);
    
-- Task - 3- Identify the winner of the contest and provide their details to the team*/

with most_likes as (
select photo_id,count(*) as Total_likes from likes
group by photo_id order by Total_likes desc limit 1)
select user_id as User_id,us.username as Name, 
p.id as Photo_id,
ml.Total_likes as Likes from photos p 
join most_likes as ml on p.id = ml.photo_id
join users us on p.user_id=us.id;
    
    
    
    /*5. Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign*/

select DAYNAME(created_at) as DAYS,count(DAYNAME(created_at)) as NUM_OF_USERS_REG from users
group by DAYS order by NUM_OF_USERS_REG DESC;

/*6. Task: Provide how many times does average user posts on Instagram. Also, provide the total number of 
photos on Instagram/total number of users*/

select (select count(id) from photos) as Total_Num_Post,
       (select count(id) from users) as Total_Num_Users,
       ((select count(id) from photos)/(select count(id) from users)) as Average_User_Post;
   /*7.Task: Bots & Fake Accounts*/

with bots as 
(select user_id,count(photo_id) as count from likes
group by user_id having count = (select count(id) from photos) )
select b.user_id,u.username from users u
join bots b on u.id=b.user_id;    
       
       
       
       
       
       
       
       
       
       
       
       
       
       























    
    
    
    
    
    
    
    