/*
	This script populates the stories table with
	some choice entries for demo purposes, and has information
	commented at the end about the current project database structure,
	gleaned via psql. 

	In psql, you can run this by:
		writers_unblocked_dev-# \i /path/to/demopop.sql

	Note: Before this can be run or the app can function correctly,
	a database admin with user "postgres" and password "postgres"
	must be created. Then, to actually create the database and tables,
    its best to use ecto:
		$ mix ecto.create && mix ecto.migrate
*/

INSERT INTO stories (title, body) VALUES ('The Most Interesting Man in the World', 'He was born, he lived, he died.');
INSERT INTO stories (title, body) VALUES ('A Polar Bear in New York', '"How did I get here?," Jim thought as rested his head on his paw.');

/*

jw@jw-laptop ~/WritersUnblocked $ sudo su postgres
[sudo] password for jw: 
postgres@jw-laptop /home/jw/WritersUnblocked $ psql writers_unblocked_dev
psql (9.5.12)
Type "help" for help.

writers_unblocked_dev=# \dt
               List of relations
 Schema |       Name        | Type  |  Owner   
--------+-------------------+-------+----------
 public | schema_migrations | table | postgres
 public | stories           | table | postgres
(2 rows)

writers_unblocked_dev=# \d+ stories
                                                     Table "public.stories"
 Column |          Type          |                      Modifiers                       | Storage  | Stats target | Description 
--------+------------------------+------------------------------------------------------+----------+--------------+-------------
 id     | bigint                 | not null default nextval('stories_id_seq'::regclass) | plain    |              | 
 title  | character varying(255) |                                                      | extended |              | 
 body   | character varying(255) |                                                      | extended |              | 
 locked | boolean                |                                                      | plain    |              | 
Indexes:
    "stories_pkey" PRIMARY KEY, btree (id)

writers_unblocked_dev-# \i /home/jw/WritersUnblocked/demopop.sql
INSERT 0 1
INSERT 0 1
writers_unblocked_dev-# SELECT * FROM stories;
 id |                 title                 |                               body                                | locked 
----+---------------------------------------+-------------------------------------------------------------------+--------
  1 | The Most Interesting Man in the World | He was born, he lived, he died.                                   | 
  2 | A Polar Bear in New York              | "How did I get here?," Jim thought as rested his head on his paw. | 
(2 rows)

writers_unblocked_dev=# 

*/
