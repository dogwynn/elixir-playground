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
       } -> IO.puts("The content length is #{length}")
    end
  end

  def csv do
    @csvdata |> CSV.decode
  end

  def awesome do
    case HTTPotion.get("https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md") do
      %HTTPotion.Response{
        status_code: 200,
        body: body,
      } -> {:ok, body}
      %HTTPotion.Response{
        status_code: 404,
      } -> {:error, :not_found}
      %HTTPotion.Response{
        status_code: code,
        body: body,
      } -> {:error, {:unhandled, code, body}}
    end
  end
  def awesome!() do
    case awesome() do
      {:ok, body} -> body
      {:error, error} -> throw(error)
    end
  end
  def is_gh?(href) do
    String.match?(href, ~r/github.com/)
  end
  def awesome_gh do
    awesome!()
    |> String.split("\n")
    |> Earmark.as_html!
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.filter(&(is_gh?/1))
  end
  def to_api(url) do
    %Fuzzyurl{hostname: name, path: path} = url
    url
    |> Map.put(:hostname, "api.#{name}")
    |> Map.put(:path, "/repos#{path}/commits/master")
    |> Fuzzyurl.to_string
  end
  def get_commit(url) do
    case HTTPotion.get(url, follow_redirects: true, headers: ["User-Agent": "Elixir Awesome Freshness Check"]) do
      %HTTPotion.Response{
        status_code: 200,
        body: body,
      } -> {:ok, body}
      %HTTPotion.Response{
        status_code: 404,
      } -> {:error, :not_found}
      %HTTPotion.Response{
        status_code: code,
        body: body,
      } -> {:error, {:unhandled, code, body}}
    end
  end
  def get_commit!(url) do
    case get_commit(url) do
      {:ok, body} -> body
      {:error, error} -> throw(error)
    end
  end
  def get_date(json) do
    case json do
      %{"commit" => %{"author" => %{"date" => date}}} -> {:ok, date}
      _ -> {:error, "could not find date"}
    end
  end
  def get_date!(date) do
    case get_date(date) do
      {:ok, date} -> date
      {:error, reason} -> throw(reason)
    end
  end

  def get_dt(date) do
    case DateTimeParser.parse_datetime(date) do
      {:ok, dt} -> {:ok, dt}
      {:error, reason} -> {:error, "could not get dt: #{reason}"}
    end
  end
  def get_dt!(date) do
    case get_dt(date) do
      {:ok, dt} -> dt
      {:error, reason} -> throw(reason)
    end
  end
  # def awesome_api do
  #   awesome_gh()
  #   |> Enum.map(&Fuzzyurl.from_string)
  #   |> 
  # end
end
