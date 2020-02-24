defmodule GreasyforkRepoGenerator.UserScript do
  @doc """
  A identifiable representation of this userscript
  """
  def name(userscript) do
    "#{Map.get(userscript, "script_name")}"
  end

  @doc """
  Returns true/false depending on whether or not
  this userscript has code.
  """
  def has_code?(userscript) do
    Map.has_key?(userscript, "code") and Map.get(userscript, "code") != nil
  end

  @doc """
  Create a filename for the userscript
  uses snake case
  """
  def filename(userscript) do
    filebase =
      name(userscript)
      |> String.downcase()
      |> String.split()
      |> Enum.join("_")
      |> String.replace(~r/[^A-Za-z0-9_]/, "")

    filebase <> ".#{Map.get(userscript, "language")}"
  end

  @doc """
  Makes sure that the userscript has code and isn't supposed to be ignored.
  If its meant to be ignored, return :error and report to user.
  Else, return the userscript
  """
  def is_valid(userscript, ignore_ids) do
    case has_code?(userscript) do
      # if user said to explicitly ignore this script
      true ->
        case Map.get(userscript, "script_id") in ignore_ids do
          true ->
            IO.puts(:stderr, "'#{name(userscript)}' in --ignore-list, removing...")
            :error

          false ->
            userscript
        end

      false ->
        IO.puts(:stderr, "'#{name(userscript)}' has no code, removing...")
        :error
    end
  end
end

defmodule GreasyforkRepoGenerator do
  @moduledoc """
  Generates the repository for a greasyfork user.
  """

  @doc """
  Parses the output of greasyfork_archive into a list
  of userscript to a list of Maps
  """
  def parse_json_file(json_filepath) do
    json_filepath
    |> File.read!()
    |> Poison.decode!()
    |> Map.get("greasyfork_scripts")
  end
end
