/*Write a SQL query to find the date EURO Cup 2016 started on*/
Select 
	min(play_date)
from match_mast;

/*Write a SQL query to number of matches that were won by penalty shootout*/
Select 
	count(distinct(match_no)) 
from penalty_shootout;

/*Write a SQL query to find the match number, date, and score for matches 
in which no stoppage time was added in the 1st half.*/
Select
	match_no,
    play_date,
    score_1,
    score_2
from match_mast
where stop1_sec = 0;

/*Write a SQL query to compute a list showing the number of substitutions that
happened in various stages of play for the entire tournament.*/
Select
	count(*) as Number_of_Substitutions
from player_in_out
where in_out = 'I';

/*Write a SQL query to find the number of bookings that happened in stoppage time*/
Select
	count(*) as Booking_in_Stoppage_Time
from player_booked
where 
	(play_half = 1 and booking_time between 45 and 50)
	or 
    (play_half = 2 and booking_time between 90 and 95);
    
/*Write a SQL query to find the number of matches that were won by a single point, 
but do not include matches decided by penalty shootout.*/
Select
count(*) as Number_of_Matches_Won_By_A_Single_Point
from match_mast
where 
	results = 'WIN'
    and
    abs(score_1 - score_2) = 1;
    
/*Write a SQL query to find all the venues where matches with penalty shootouts were played*/
Select
	distinct(sv.venue_name)
from penalty_shootout ps
inner join match_mast mm
	on ps.match_no = mm.match_no
inner join soccer_venue sv
	on mm.venue_id = sv.venue_id;

/*Write a SQL query to find the match number for the game with the 
highest number of penalty shots, and which countries played that match.*/
Select
	mm.match_no,
	sc.country_name
from  (select match_no from penalty_shootout
			order by kick_no desc
            limit 1) pg
inner join match_mast mm
	on mm.match_no = pg.match_no
inner join goal_details gd
	on mm.match_no = gd.match_no
inner join soccer_country sc
	on gd.team_id = sc.country_id;

/*Write a SQL query to find the goalkeeper’s name and jersey number, playing for Germany, 
who played in Germany’s group stage matches.*/
Select
	distinct(pm.player_name),
    pm.jersey_no
from goal_details gd
inner join match_mast mm
	on mm.match_no = gd.match_no
inner join soccer_country sc
	on gd.team_id = sc.country_id
inner join player_mast pm
	on sc.country_id = pm.team_id
inner join playing_position ps
	on ps.position_id = pm.posi_to_play
where
	sc.country_name = 'Germany'
    and
    ps.position_desc = 'Goalkeepers'
    and
    mm.play_stage = 'G';
    
/*Write a SQL query to find all available information about the players under 
contract to Liverpool F.C. playing for England in EURO Cup 2016.*/    
Select 
	pm.player_name,
    ps.position_desc,
    age,
    jersey_no,
    dt_of_bir
from player_mast pm
inner join soccer_country sc
	on sc.country_id = pm.team_id
inner join playing_position ps
	on ps.position_id = pm.posi_to_play
where
	playing_club = 'Liverpool'
    and
    country_name = 'England';

/*Write a SQL query to find the players, their jersey number, and playing club who
were the goalkeepers for England in EURO Cup 2016.*/    
Select 
	pm.player_name,
	jersey_no,
    playing_club
from player_mast pm
inner join soccer_country sc
	on sc.country_id = pm.team_id
inner join playing_position ps
	on ps.position_id = pm.posi_to_play
where
	position_desc = 'Goalkeepers'
    and
    country_name = 'England';
    
/*Write a SQL query that returns the total number of goals scored by each position on 
each country’s team. Do not include positions which scored no goals*/  
Select
	country_name as Country,
    position_desc as Position,
    count(goal_id) as Number_of_goals
from goal_details gd
inner join player_mast pm
	on pm.team_id = gd.team_id
inner join soccer_country sc
	on sc.country_id = gd.team_id
inner join playing_position ps
	on ps.position_id = pm.posi_to_play
group by
	country_name,
    position_desc;

/*Write a SQL query to find all the defenders who scored a goal for their teams.*/  
Select
	player_name as Scoring_Defenders
from player_mast pm
inner join playing_position ps
	on pm.posi_to_play = ps.position_id
where 
	player_id in (select distinct(player_id) from goal_details)
    and
    position_desc = 'Defenders';
    
/*Write a SQL query to find referees and the number of bookings they made for the 
entire tournament. Sort your answer by the number of bookings in descending order.*/  
Select 
	rm.referee_name,
	count(pb.match_no) as Number_of_Bookings
from player_booked pb
inner join match_mast mm
	on pb.match_no = mm.match_no
inner join referee_mast rm
	on mm.referee_id = rm.referee_id
group by rm.referee_name
order by count(pb.match_no) desc;

/*Write a SQL query to find the referees who booked the most number of players.*/     
Select 
	rm.referee_name,
	count(pb.match_no) as Number_of_Bookings
from player_booked pb
inner join match_mast mm
	on pb.match_no = mm.match_no
inner join referee_mast rm
	on mm.referee_id = rm.referee_id
group by rm.referee_name
order by count(pb.match_no) desc
limit 1;    
    
/*Write a SQL query to find referees and the number of matches they worked in each venue*/     
Select
	referee_name,
    venue_name,
    count(city_id) number_of_matches_worked
from referee_mast rm
inner join match_mast mm
	on rm.referee_id = mm.referee_id
inner join soccer_venue sv
	on sv.venue_id = mm.venue_id
group by
	referee_name,
    venue_name
order by referee_name;
    
/*Write a SQL query to find the country where the most assistant referees come from,
and the count of the assistant referees*/ 
Select
	country_name,
	count(ass_ref_id) number_of_asst_ref
from asst_referee_mast arm
inner join soccer_country sc
	on arm.country_id = sc.country_id
group by country_name
order by count(ass_ref_id) desc
limit 1;

/*Write a SQL query to find the highest number of foul cards given in one match*/ 
Select 
	max(number_of_bookings) Highest_Number_of_Bookings 
from 
		(Select
			match_no,
			count(*) number_of_bookings
		from player_booked
		group by match_no) as bookingtable;

/*Write a SQL query to find the number of captains who were also goalkeepers.*/ 
Select
	count(position_desc) GoalKeeper_Captain
from player_mast pm
inner join playing_position ps
	on pm.posi_to_play = ps.position_id
where 
	player_id in (select distinct(player_captain) from match_captain)
    and
    position_desc = 'Goalkeepers';

/*Write a SQL query to find the substitute players who came into the field in the first
half of play, within a normal play schedule.*/    
Select
	player_name Substitute_In_Player
from player_in_out pio
inner join player_mast pm
	on pio.player_id = pm.player_id
where 
	in_out = 'O'
    and
    play_half = 1
    and
    play_schedule = 'NT'
