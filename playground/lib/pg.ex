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
        status_code: code,
        body: body,
      } -> {:error, {:awesome_data, code, body}}
    end
  end

  def is_gh?(href) do
    String.match?(href, ~r/github.com/)
  end

  def awesome_gh_urls do
    with {:ok, md} <- awesome(),
         {:ok, html, []} <- Earmark.as_html(md) do
      html
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(&(is_gh?/1))
    end
  end

  def get_gh_fuzzyurl(url) do
    case gh_url=Fuzzyurl.from_string(url) do
      %Fuzzyurl{
        fragment: nil,
        password: nil,
        port: nil,
        query: nil,
        username: nil,
        protocol: "https",
        hostname: "github.com",
        path: path,
      } when path != nil ->
        if (Path.split(path) |> Enum.count) == 3 do
          {:ok, gh_url}
        else
          {:error,
           {:gh_url,
            "URL path has more than user and repo: #{url}"}}
        end
      _ -> {:error, {:gh_url,
                    "not a usable GitHub URL: #{url}"}}
    end
  end

  def to_api(raw_url) do
    with {:ok, url} <- get_gh_fuzzyurl(raw_url) do
      {:ok,
       url
       |> Map.put(:hostname, "api.#{url.hostname}")
       |> Map.put(:path, "/repos#{url.path}/commits/master")
       |> Fuzzyurl.to_string}
    end
  end

  def get_commit(url) do
    case HTTPotion.get(url, follow_redirects: true, headers: ["User-Agent": "Elixir Awesome Freshness Check"]) do
      %HTTPotion.Response{
        status_code: 200,
        body: body,
      } -> {:ok, body}
      %HTTPotion.Response{
        status_code: code,
        body: body,
      } -> {:error, {:github_commit_data, code, body}}
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
  def get_date!(json) do
    case get_date(json) do
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

  def github_last_commit_dt(gh_url) do
    with {:ok, api_url} <- to_api(gh_url),
         {:ok, json_str} <- get_commit(api_url),
         {:ok, json} <- Jason.decode(json_str),
         {:ok, date_str} <- get_date(json) do
      get_dt(date_str)
    end
  end
  
  # def awesome_api do
  #   awesome_gh()
  #   |> Enum.map(&Fuzzyurl.from_string)
  #   |> 
  # end
end
