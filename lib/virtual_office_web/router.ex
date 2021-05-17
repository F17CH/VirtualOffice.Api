defmodule VirtualOfficeWeb.Router do
  use VirtualOfficeWeb, :router

  alias VirtualOffice.Guardian

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", VirtualOfficeWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
    post "/users/sign_up", UserController, :create
  end

  scope "/api", VirtualOfficeWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/users/current/", UserController, :current
    post "/users/current/sign_out", UserController, :sign_out

    get "/users/:user_id/", UserController, :get
    get "/users/:user_id/conversation", ConversationController, :get_individual
    post "/users/:user_id/conversation", ConversationController, :create_individual


    post "/associations/", AssociationController, :create
    get "/associations/:association_id", AssociationController, :get
    post "/associations/:association_id/join", AssociationController, :join

    get "/conversations/:conversation_id/", ConversationController, :get
    post "/conversations/", ConversationController, :create

    get "/conversations/:conversation_id/messages/", MessageController, :get_all
    post "/conversations/:conversation_id/messages/", MessageController, :create
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: VirtualOfficeWeb.Telemetry
   end
  end
end
