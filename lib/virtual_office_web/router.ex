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

    get "/my_user", UserController, :show
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: VirtualOfficeWeb.Telemetry
    end
  end
end
