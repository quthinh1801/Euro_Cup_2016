/*Drop database euro_cup_2016;*/

Create database euro_cup_2016;

Use euro_cup_2016;

Create table playing_position
(
position_id varchar(2),
position_desc varchar(15),
	primary key(position_id)
);

Create table soccer_country
(
country_id numeric,
country_abbr varchar(4),
country_name varchar(40),
	primary key (country_id)
);

Create table player_mast
(
player_id numeric,
team_id numeric,
jersey_no numeric,
player_name varchar(40),
posi_to_play varchar(2),
dt_of_bir date,
age numeric,
playing_club varchar(40),
	primary key (player_id),
	foreign key (posi_to_play) references playing_position(position_id),
	foreign key (team_id) references soccer_country(country_id)
);

Create table soccer_team
(
team_id numeric,
team_group character(1),
match_played numeric,
won numeric,
draw numeric,
lost numeric,
goal_for numeric,
goal_agnst numeric,
goal_diff numeric,
points numeric,
group_position numeric,
	foreign key (team_id) references soccer_country(country_id)
);

Create table soccer_city
(
city_id numeric,
city varchar(25),
country_id numeric,
	primary key (city_id),
	foreign key (country_id) references soccer_country(country_id)
);

Create table soccer_venue
(
venue_id numeric,
venue_name varchar(30),
city_id numeric,
aud_capacity numeric,
	primary key (venue_id),
    foreign key (city_id) references soccer_city (city_id)
);

Create table referee_mast
(
referee_id numeric,
referee_name varchar(40),
country_id numeric,
	primary key (referee_id),
    foreign key (country_id) references soccer_country (country_id)
);

Create table coach_mast
(
coach_id numeric,
coach_name varchar(40),
	primary key (coach_id)
);

Create table team_coaches
(
team_id numeric,
coach_id numeric,
	foreign key (coach_id) references coach_mast (coach_id)
);

Create table asst_referee_mast
(
ass_ref_id numeric,
ass_ref_name varchar(40),
country_id numeric,
	primary key (ass_ref_id),
    foreign key (country_id) references soccer_country (country_id)
);

Create table goal_details
(
goal_id numeric,
match_no numeric,
player_id numeric,
team_id numeric,
goal_time numeric,
goal_type character(1),
play_stage character(1),
goal_schedule character(2),
goal_half numeric,
	primary key (goal_id),
    foreign key (player_id) references player_mast (player_id),
    foreign key (team_id) references soccer_country (country_id)
);

Create table player_booked
(
natch_no numeric,
team_id numeric,
player_id numeric,
booking_time varchar(40),
sent_off character(1),
play_schedule character(2),
play_half numeric,
	foreign key (team_id) references soccer_country (country_id),
    foreign key (player_id) references player_mast (player_id)
);

alter table match_mast
drop column play_date;
 
alter table match_mast
add column play_date numeric;

Create table match_mast
(
match_no numeric,
play_stage character(1),
play_date numeric,
results character(5),
decided_by character(1),
score_1 numeric,
score_2 numeric,
venue_id numeric,
referee_id numeric,
audence numeric,
plr_of_match numeric,
stop1_sec numeric,
stop2_sec numeric,
	primary key (match_no),
    foreign key (referee_id) references referee_mast (referee_id),
    foreign key (venue_id) references soccer_venue (venue_id),
    foreign key (plr_of_match) references player_mast (player_id)
);

Create table player_in_out
(
match_no numeric,
team_id numeric,
player_id numeric,
in_out character(1),
time_in_out numeric,
play_schedule character(2),
play_half numeric,
	foreign key (match_no) references match_mast (match_no),
    foreign key (team_id) references soccer_country (country_id),
    foreign key (player_id) references player_mast (player_id)
);

Create table penalty_shootout
(
kick_id numeric,
match_no numeric,
team_id numeric,
player_id numeric,
score_goal varchar(1),
kick_no numeric,
	primary key (kick_id),
    foreign key (match_no) references match_mast (match_no),
    foreign key (team_id) references soccer_country (country_id)
);

Create table penalty_gk
(
match_no numeric,
team_id numeric,
player_gk numeric,
	foreign key (match_no) references match_mast (match_no),
    foreign key (team_id) references soccer_country (country_id),
    foreign key (player_gk) references player_mast (player_id)
);

Create table match_captain
(
match_no numeric,
team_id numeric,
player_captain numeric,
	foreign key (match_no) references match_mast (match_no),
    foreign key (team_id) references soccer_country (country_id),
    foreign key (player_captain) references player_mast (player_id)
);

Create table match_details
(
match_no numeric,
play_stage varchar(1),
team_id numeric,
win_lose varchar(1),
decided_by varchar(1),
goal_score numeric,
penalty_score numeric,
ass_ref numeric,
player_gk numeric,
	foreign key (match_no) references match_mast (match_no),
    foreign key (team_id) references soccer_country (country_id),
    foreign key (ass_ref) references asst_referee_mast (ass_ref_id),
    foreign key (player_gk) references player_mast (player_id)
);



