# XXX: appears story apend input is no longer appended to previous body, but overwrites it.

import Ecto.Changeset

defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger
  
  
  def give_new_story(conn) do
    render conn, "index.html", title: "Untitled", body: ""
  end

  def give_continue_story(conn) do
    case (Repo |> SQL.query!("""
                    SELECT id
                    FROM stories
                    WHERE NOT locked AND NOT finished
                    ORDER BY RANDOM() LIMIT 1
                    """, [])
                |> Map.fetch(:rows)
                |> elem(1)
    ) do
    # No available story
    [] ->
      conn
      |> put_flash(:info, "No stories available to continue, you can make a new one here.")
      |> give_new_story # and return    

    # There is an available story.
    [story_query | _] ->
      story_id = List.first(story_query)
      # Locks story
      Story
      |> Repo.get(story_id)
      |> Story.changeset(%{locked: true})
      |> Repo.update()

      # lots of queries but idk how to do it otherwise now
      story = Story
      |> Repo.get(story_id)
      conn = put_session(conn, :story_id, story_id)
      render conn, "index.html", title: story.title, body: story.body
    end
  end


  def index(conn, %{"action" => action}) do

    IO.puts IO.ANSI.green <> "-- BEGIN conn inspect StoryController.index() --" <> IO.ANSI.yellow
    IO.inspect conn
    IO.puts IO.ANSI.green <> "-- END --" 

    #this probably needs to be down in other places to,
    #like the user hits their back button when editing a story?
    #idk if can have some callback,
    #but here is enough for the purposes of this assignment

    get_id_ret = get_session(conn, :story_id)
    IO.puts "inspect story_id in session before delete: #{get_id_ret}"
    conn = delete_session(conn, :story_id)
    
    if get_id_ret!=nil do
      IO.inspect(Repo |> SQL.query!("UPDATE stories SET locked=FALSE WHERE id=#{get_id_ret}"))
    end
    
    case action do
    "new" -> give_new_story(conn)
    _     -> give_continue_story(conn)
    end

  end

  def submit_entry(conn, %{"title" => title, "append-input" => content} = params) do
    Logger.debug "Params: #{inspect(params)}"

    cond do
      byte_size(content) == 0 ->
        text conn, "No form data."
      String.length(content) < 3 or String.length(content) > 240 ->
        text conn, "Expected between 3 and 240 characters. Got #{String.length(content)}."
      String.printable?(content) ->
        # Inserts/updates story.
        case get_session(conn, :story_id) do
          # No story selected? Create new story.
          nil ->
            case capitalize_title(title) do
              "" -> Repo.insert(%Story{title: "Untitled Story", body: content})
              title -> Repo.insert(%Story{title: title, body: content})
            end

          # Story selected? Append to old story.
          _ ->
            story_item =
              Story
              |> Repo.get(get_session(conn, :story_id))
            
              IO.puts IO.ANSI.green <> "-- story body... --" <> IO.ANSI.yellow
              IO.inspect story_item.body
              IO.puts IO.ANSI.green <> "-- ... --" 

            changeset =
              Story.changeset(story_item,
              %{body: "#{story_item.body}\n#{content}", locked: false})

            # New title submitted? Update title.
            changeset =
              case capitalize_title(title) do
                "" -> changeset
                title -> merge(changeset, Story.changeset(story_item, %{title: title}))
              end

            # Finished button clicked? Set finished to true.
            changeset =
              case Map.fetch(params, "finish-button") do
                :error -> changeset
                _ -> merge(changeset, Story.changeset(story_item, %{finished: true}))
              end

            Repo.update(changeset)
        end

        # Unlink story and go back to the home page
        conn
        |> delete_session(:story_id)
        |> put_flash(:info, "Your input has been recorded.")
        |> redirect(to: "/") # , # statmsg: "string var xyz") #this apparently doesnt work like render, or the html.eex was wrong
      true ->
        text conn, "Data contains non-printable chars."
    end
end

  def submit_entry_doesnt_append_but_overwrites_maybe(conn, %{"title" => title, "append-input" => content} = params) do

    IO.puts IO.ANSI.green <> "-- BEGIN inspect params submit_entry() --" <> IO.ANSI.yellow
    IO.inspect params
    IO.puts IO.ANSI.green <> "-- END --"    
    
    get_id_ret = get_session(conn, :story_id) # save before it is deletd from session. must be deleted from all exit paths of this function
    IO.puts "inspect story_id in session before delete: #{get_id_ret}"
    conn = delete_session(conn, :story_id)

    if get_id_ret!=nil do
      IO.inspect(Repo |> SQL.query!("UPDATE stories SET locked=FALSE WHERE id=#{get_id_ret}"))
    end

    cond do
      byte_size(content) == 0 ->
        text conn, "No form data."
      String.length(content) < 3 or String.length(content) > 240 ->
        text conn, "Expected between 3 and 240 characters. Got #{String.length(content)}."
      String.printable?(content) ->
        # Inserts/updates story.
        case get_id_ret do
          # No story selected? Create new story.
          nil ->
            case capitalize_title(title) do
              "" -> Repo.insert(%Story{title: "Untitled Story", body: content, locked: false})
              title -> Repo.insert(%Story{title: title, body: content, locked: false})
            end

          # Story selected? Append to old story.
          _ ->
            story_item =
              Story
              |> Repo.get(get_id_ret)

            changeset =
              Story.changeset(story_item,
              %{body: "#{story_item.body}\n#{content}", locked: false})

            # New title submitted? Update title.
            changeset =
              case capitalize_title(title) do
                "" -> changeset
                title -> merge(changeset, Story.changeset(story_item, %{title: title, locked: false}))
              end

            # Finished button clicked? Set finished to true.
            changeset =
              case Map.fetch(params, "finish-button") do
                :error -> changeset
                _ -> merge(changeset, Story.changeset(story_item, %{finished: true}))
              end

            Repo.update(changeset)
        end

        # Unlink story and go back to the home page
        conn
        # already down at start|> delete_session(:story_id)
        |> put_flash(:info, "Your input has been recorded.")
        |> redirect(to: "/") # , statmsg: "string var xyz") #this apparently doesnt work like render
      true ->
        text conn, "Data contains non-printable chars."
    end
  end

  # Automatically capitalize title (made by Jon)
  @nocapset MapSet.new(["a", "an", "the", "of", "and", "on", "or", "to", "by"])
  def capitalize_title(instr) do
    case String.split(instr, " ", trim: true) do
      [] ->
        ""
      [head|rest] ->
        head = String.capitalize(head)
        if Enum.empty?(rest) do
          head
        else
          head <> " " <> (
          Enum.map(rest, fn(s) ->  if MapSet.member?(@nocapset, s), do: s, else: String.capitalize(s) end) |> Enum.join(" ") )
        end
      end
  end


  def old_index(conn, %{"action" => action}) do
    conn =
      case get_session(conn, :story_id) do
        nil ->
          case action do
            # Continuing story? Assign story if available.
            "continue" ->
              case (
                # Select random story id from database.
                Repo
                |> SQL.query!("""
                    SELECT id
                    FROM stories
                    WHERE NOT locked AND NOT finished
                    ORDER BY RANDOM() LIMIT 1
                    """, [])
                |> Map.fetch(:rows)
                |> elem(1)
              ) do
                # No available stories? Don't assign story.
                [] -> conn
                # There is an available story.
                [story_query | _] ->
                  story_id = List.first(story_query)
                  # Locks story
                  Story
                  |> Repo.get(story_id)
                  |> Story.changeset(%{locked: true})
                  |> Repo.update()

                  put_session(conn, :story_id, story_id)
              end

            # New story? Don't assign story.
            _ -> conn
          end
          # Story already assigned.
          _ -> conn
      end

    Logger.debug "Story id: #{get_session(conn, :story_id)}"

    case get_session(conn, :story_id) do
      # New story? Previous story empty.
      nil -> render conn, "index.html", title: "New Story", body: ""
      # Continuing existing story? Get story from database.
      story_id ->
        story = Story
        |> Repo.get(story_id)
        render conn, "index.html", title: story.title, body: story.body
    end
  end

end


    #qres = Repo |> SQL.query!("""
    #     SELECT id, title, body FROM stories
    #     WHERE NOT locked AND NOT finished
    #     ORDER BY RANDOM() LIMIT 1
    #     """) |> Map.fetch(:rows) |> elem(1)
