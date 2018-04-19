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
    get "/story", StoryController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WritersUnblockedWeb do
  #   pipe_through :api
  # end
end
