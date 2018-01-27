use Mix.Config

config :roger, Roger.AMQPClient,
  host: "localhost",
  port: 5672

config :roger_ui, server: false
