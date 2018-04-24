defmodule ShortStory.UserView do
  use ShortStory.Web, :view
  alias ShortStory.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
