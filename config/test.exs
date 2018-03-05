use Mix.Config

config :roger, Roger.AMQPClient,
  host: "localhost",
  port: 5672

config :roger_ui,
  server: false,
  # Partitions will be multiplied by 8 and queues by 24
  generated_partitions_size: 10,
  # Jobs will be multiplied by 12
  generated_jobs_size: 100,
  roger_api: RogerUI.RogerApi.Mock

if node() == :nonode@nohost do
  config :roger_ui, :server, false
  config :roger, :partitions, roger_ui_test_partition: [default: 10, other: 2]
end
