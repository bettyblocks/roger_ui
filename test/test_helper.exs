[:cowboy, :plug]
|> Enum.each(&Application.ensure_all_started/1)

ExUnit.start()
