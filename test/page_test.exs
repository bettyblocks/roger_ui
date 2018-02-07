defmodule RogerUi.PageTest do
  use ExUnit.Case
  import RogerUi.Page

  test "split list into pages" do
    page = extract(1..5000, :first_fifty, 50, 1)

    assert page.first_fifty == Enum.to_list(1..50)
    assert page.total == 5000

    page = extract(1..5000, :first_fifty, 50, 1)

    assert page.first_fifty == Enum.to_list(1..50)
    assert page.total == 5000
  end
end
