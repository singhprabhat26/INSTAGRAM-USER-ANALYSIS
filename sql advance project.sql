/*1. Task: how many times does average user posts .*/
select (select count(id) from photos) as Total_Num_Post,
       (select count(id) from users) as Total_Num_Users,
       ((select count(id) from photos)/(select count(id) from users)) as Average_User_Post;

/*2. Task: Find the top 5 most used hashtags */

select most_used_hashtags from (
select tag_id,tag_name as most_used_hashtags,count(*) as hashtags_count from tags t
join photo_tags pt on t.id=pt.tag_id
group by tag_id order by hashtags_count desc limit 5)a ;

-- or
SELECT tag_name AS most_used_hashtags, COUNT(*) AS hashtags_count
FROM tags
INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY hashtags_count DESC
LIMIT 5;

/*3. Task : Find users who have liked every single photo on the site.*/

select user_id,username,count(users.id) as total_likes from users
join likes on users.id = likes.user_id
group by users.id
having total_likes = (select count(*) from photos);

/*4. Task : Retrieve a list of users along with their usernames and the rank of their account creation, 
ordered by the creation date in ascending order.*/

SELECT username, 
       RANK() OVER (ORDER BY created_at ASC) AS account_creation_rank
FROM users
ORDER BY created_at ASC;

/*5. Task : List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments
 Include the comment count for each photo. */

SELECT
    p.image_url, c.comment_text,u.username, p.id,
    COUNT(c.id) AS comment_count
FROM photos p
INNER JOIN comments c ON p.id = c.photo_id
INNER JOIN users u ON c.user_id = u.id
GROUP BY
    p.image_url, c.comment_text, u.username, p.id
ORDER BY
    p.id, comment_count DESC;
    
/*6 Task. For each tag, show the tag name and the number of photos associated with that tag. 
Rank the tags by the number of photos in descending order.*/

SELECT
    t.tag_name,
    COUNT(pt.photo_id) AS photo_count,
    Row_number() OVER (ORDER BY COUNT(pt.photo_id) DESC) AS tag_rank
FROM tags t
LEFT JOIN 
photo_tags pt ON t.id = pt.tag_id
GROUP BY
    t.tag_name
ORDER BY
    tag_rank desc;
    
/* 7. task : List the usernames of users who have posted photos along with the count of photos they have posted. 
Rank them by the number of photos in descending order.*/

SELECT username, photo_count, Row_number() OVER (ORDER BY photo_count DESC) AS ranking
FROM 
(SELECT u.username, COUNT(p.id) AS photo_count
    FROM users u
   Left JOIN photos p ON u.id = p.user_id
    GROUP BY u.username ) AS photo_counts
ORDER BY ranking DESC;

/*8. Task :	Display the username of each user along with the creation date of their first posted photo and the 
creation date of their next posted photo.*/

SELECT u.username,
       Min(p1.created_at) AS first_posted_photo,
       Min(p2.created_at) AS next_posted_photo
FROM users u
left join photos p1 ON u.id = p1.user_id
left join photos p2 ON u.id = p2.user_id AND p2.created_at > p1.created_at
GROUP BY u.username;

/* 9. Task : For each comment, show the comment text, the username of the commenter,
 and the comment text of the previous comment made on the same photo.*/
 
SELECT c.comment_text, u.username, LAG(c.comment_text) OVER (PARTITION BY c.photo_id ORDER BY c.created_at) 
AS prev_comment_text 
FROM comments c Join users u on c.id = u.id 
ORDER BY c.photo_id, c.created_at;

/* 10 Task : Show the username of each user along with the number of photos they have posted and the number of photos posted by the user 
before them and after them, based on the creation date.*/

SELECT 
  username,
  COUNT(*) AS num_photos,
  LAG(COUNT(*)) OVER (ORDER BY MIN(photos.created_at)) AS num_photos_before, 
  LEAD(COUNT(*)) OVER (ORDER BY MIN(photos.created_at)) AS num_photos_after
FROM photos
JOIN users ON photos.user_id = users.id
GROUP BY users.id
ORDER BY MIN(photos.created_at);











