defmodule Pg do
  @moduledoc """
  Documentation for Pg.
  """

  @csvdata """
  a0,b1,c0
  a1,b2,c1
  """

  @doc """
  Hello world.

  ## Examples

      iex> Pg.hello()
      :world

  """
  def hello do
    :world
  end

  def httpotion do
    case HTTPotion.get("https://google.com") do
      %HTTPotion.Response{
          headers: %HTTPotion.Headers{
            hdrs: %{
              "content-length" => length
            }
          }
       } -> length.puts("The content length is #{length}")
    end
  end

  def csv do
    @csvdata |> CSV.decode
  end
end
