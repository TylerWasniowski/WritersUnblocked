# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WritersUnblocked.Repo.insert!(%WritersUnblocked.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#                                                                  Table "public.stories"
#    Column    |            Type             |                              Modifiers                              | Storage  | Stats target | Description 
#--------------+-----------------------------+---------------------------------------------------------------------+----------+--------------+-------------
# id           | bigint                      | not null default nextval('stories_id_seq'::regclass)                | plain    |              | 
# title        | character varying(255)      |                                                                     | extended |              | 
# body         | text                        |                                                                     | extended |              | 
# finished     | boolean                     | not null default false                                              | plain    |              | 
# votes        | integer                     | not null default 0                                                  | plain    |              | 
# locked_until | timestamp without time zone | not null default '1970-01-01 00:00:00'::timestamp without time zone | plain    |              | 
#Indexes:
#    "stories_pkey" PRIMARY KEY, btree (id)


WritersUnblocked.Repo.insert!(%WritersUnblocked.Story{title: "The adventures of Bob", body: "Bob was a mighty adventurer, skilled with a sword."})
WritersUnblocked.Repo.insert!(%WritersUnblocked.Story{title: "A Polar Bear in New York", body: "\"How did I get Here?\" Jim thought."})

WritersUnblocked.Repo.insert!(%WritersUnblocked.Story{title: "Never Gonna Give You Up", body: """
We're no strangers to love
You know the rules and so do I
A full commitment's what I'm thinking of
You wouldn't get this from any other guy
I just wanna tell you how I'm feeling
Gotta make you understand
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
We've known each other for so long
Your heart's been aching but you're too shy to say it
Inside we both know what's been going on
We know the game and we're gonna play it
And if you ask me how I'm feeling
Don't tell me you're too blind to see
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give, never gonna give
(Give you up)
(Ooh) Never gonna give, never gonna give
(Give you up)
We've known each other for so long
Your heart's been aching but you're too shy to say it
Inside we both know what's been going on
We know the game and we're gonna play it
I just wanna tell you how I'm feeling
Gotta make you understand
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
""", finished: true})

WritersUnblocked.Repo.insert!(%WritersUnblocked.Story{title: "The Man that Was", body: """
Once, there was a man. He was no ordinary man, but THE man. The man with the plan.
But the plan was flawed. I don't know where I'm going with this. I'm still typing just
to make sure this to be finished story is long enough. finish_length: 300. Well, his plan was to
tempt the mighty dragon Goob McGooberstein, whos breath could incinerate any material. And then they all died, the end.
""", finished: true})

