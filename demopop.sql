/*
	This script populates the stories table with
	some choice entries for demo purposes, and has information
	commented at the end about the current project database structure,
	gleaned via psql. 

	In psql, you can run this by:
		\i /path/to/demopop.sql


	Note: Before this can be run or the app can function correctly,
	a database admin with user "postgres" and password "postgres"
	must be created.
 	
	After that, to actually create the database and tables:
		$ mix ecto.create && mix ecto.migrate
*/

INSERT INTO stories (title, body) VALUES ('The Most Interesting Man in the World', 'He was born, he lived, he died.');
INSERT INTO stories (title, body) VALUES ('A Polar Bear in New York', '"How did I get here?," Jim thought as rested his head on his paw.');

/*
writers_unblocked_dev=# \i /home/jw/WritersUnblocked/demopop.sql
INSERT 0 1
INSERT 0 1
writers_unblocked_dev=# SELECT * FROM stories;
 id |                 title                 |                               body                                | session 
----+---------------------------------------+-------------------------------------------------------------------+---------
  1 | The Most Interesting Man in the World | He was born, he lived, he died.                                   |        
  2 | A Polar Bear in New York              | "How did I get here?," Jim thought as rested his head on his paw. |        
(2 rows)

*/


/*********************
 *** database info ***
 ********************/


/*

jw@jw-laptop ~/WritersUnblocked/writers_unblocked $ sudo su postgres
[sudo] password for jw: 

writers_unblocked_dev=# \dt
               List of relations
 Schema |       Name        | Type  |  Owner   
--------+-------------------+-------+----------
 public | schema_migrations | table | postgres
 public | sessions          | table | postgres
 public | stories           | table | postgres
(3 rows)


writers_unblocked_dev=# \d+ stories

                                                     Table "public.stories"
 Column  |          Type          |                      Modifiers                       | Storage  | Stats target | Description 
---------+------------------------+------------------------------------------------------+----------+--------------+-------------
 id      | bigint                 | not null default nextval('stories_id_seq'::regclass) | plain    |              | 
 title   | character varying(255) |                                                      | extended |              | 
 body    | character varying(255) |                                                      | extended |              | 
 session | bigint                 |                                                      | plain    |              | 
Indexes:
    "stories_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "stories_session_fkey" FOREIGN KEY (session) REFERENCES sessions(id)
*/
