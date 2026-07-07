DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-----------------------------------------------------------------------------------------------------------

--Easy Level

--Retrieve the names of all tracks that have more than 1 billion streams.
--List all albums along with their respective artists.
--Get the total number of comments for tracks where licensed = TRUE.
--Find all tracks that belong to the album type single.
--Count the total number of tracks by each artist.

--Q.1 Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE stream>100000000;

--Q.2 List all albums along with their respective artists.

SELECT DISTINCT album,artist FROM spotify
ORDER BY 1;

--Q.3 Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed='true';

--Q.4 Find all tracks that belong to the album type single.

SELECT * FROM spotify
WHERE album_type='single';

--Q.5 Count the total number of tracks by each artist.

SELECT artist,COUNT(*) AS total_songs FROM spotify
GROUP BY artist
ORDER BY 2;

--------------------------------------------------------------------------------------------------------------------------------

--Medium Level

--Calculate the average danceability of tracks in each album.
--Find the top 5 tracks with the highest energy values.
--List all tracks along with their views and likes where official_video = TRUE.
--For each album, calculate the total views of all associated tracks.
--Retrieve the track names that have been streamed on Spotify more than YouTube.


--Q.1 Calculate the average danceability of tracks in each album.

SELECT album,avg(danceability) as avg_danceablity FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Q.2 Find the top 5 tracks with the highest energy values.

SELECT track,MAX(energy) FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q.3 List all tracks along with their views and likes where official_video = TRUE.

SELECT track,SUM(views) AS total_views,SUM(likes) AS total_likes FROM spotify
WHERE official_video='true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q.4 For each album, calculate the total views of all associated tracks.
SELECT album,track,sum(viewS) FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

--Q.5 Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT track,
	sum(CASE WHEN most_played_on='Youtube' THEN stream END) as streamed_on_yt,
	sum(CASE WHEN most_played_on='Spotify' THEN stream END)as streamed_on_spotify ,
	most_played_on FROM spotify	
	GROUP BY 1;


-------------------------------------------------------------------------------------------------------------------------------------
--Advanced Level

--Find the top 3 most-viewed tracks for each artist using window functions.
--Write a query to find tracks where the liveness score is above the average.
--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


--Q.1 Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist
AS
(SELECT 
		artist,
		track,
		sum(views) as total_view,
		DENSE_RANK()OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
		FROM spotify
		GROUP BY 1,2
		ORDER BY 1,3 DESC)
SELECT * FROM ranking_artist
WHERE rank<=3;



--Q.2 Write a query to find tracks where the liveness score is above the average.

SELECT
	track,
	artist,
	liveness
FROM spotify
WHERE liveness>(SELECT AVG(liveness) FROM spotify);

--Q.3 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC;