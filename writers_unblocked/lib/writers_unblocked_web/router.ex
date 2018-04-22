defmodule WritersUnblockedWeb.Router do
  use WritersUnblockedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WritersUnblockedWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/new-story",      StoryController, :on_new
    get "/continue-story", StoryController, :on_continue

    get "/create-story", PostController, :on_create
    get "/update-story", PostController, :on_update

    get "/view-id",      PostController, :on_view_id
  end

  # Other scopes may use custom stacks.
  # scope "/api", WritersUnblockedWeb do
  #   pipe_through :api
  # end
end
