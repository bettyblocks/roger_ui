[:cowboy, :plug, :mox]
|> Enum.each(&Application.ensure_all_started/1)

Mox.defmock(RogerUI.RogerApi.Mock, for: RogerUI.Roger)

ExUnit.start(exclude: [:slow])
