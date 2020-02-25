defmodule GreasyforkRepoGenerator.Template do
  @moduledoc """
  Related to generating templates/files for final output directory.
  """

  alias GreasyforkRepoGenerator.UserScript

  @doc """
  Generate the README contents
  """
  def readme(userscripts) do
    userscript_table_rows_str =
      userscripts
      |> Enum.sort(fn us1, us2 ->
        Map.get(us1, "total_installs") >= Map.get(us2, "total_installs")
      end)
      |> Stream.map(fn us ->
        [
          "[#{Map.get(us, "script_name")}](./#{UserScript.filename(us)})",
          "#{Map.get(us, "description") |> String.trim_trailing(".")}",
          "#{Map.get(us, "total_installs")}",
          "[link](#{Map.get(us, "url")})"
        ]
        |> Enum.join(" | ")
      end)
      |> Enum.join("\n")

    """
    # Greasyfork

    [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

    An archive of my greasyfork scripts.

    | Script | Description | Total Installs | URL |
    | --- | --- | --- | --- |
    #{userscript_table_rows_str}

    ###### Created with [greasyfork_repo_generator](https://github.com/seanbreckenridge/greasyfork_repo_generator)
    """
  end

  def create_script(userscript, output_dir) do
    Path.join(output_dir, UserScript.filename(userscript))
    |> File.write!(Map.get(userscript, "code"))
  end
end
