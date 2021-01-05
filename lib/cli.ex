defmodule GreasyforkRepoGenerator.CLI do
  alias GreasyforkRepoGenerator.UserScript
  alias GreasyforkRepoGenerator.Template

  def parse_args(args) do
    Optimus.new!(
      name: "greasyfork_repo_generator",
      description: "Archives a users Greasyfork account and creates a git repo",
      author: "Sean Breckenridge github.com/seanbreckenridge",
      version: "0.1.0",
      allow_unknown_args: false,
      parse_double_dash: true,
      options: [
        json: [
          value_name: "INPUT_JSON_FILE",
          short: "-j",
          long: "--json",
          help: "Output JSON file from greasyfork_archive",
          required: true,
          parser: fn fp ->
            case File.exists?(fp) do
              true -> {:ok, fp}
              false -> {:error, fp}
            end
          end
        ],
        ignore_ids: [
          value_name: "IGNORE_SCRIPT_IDS",
          short: "-i",
          long: "--ignore-ids",
          help: "A comma separated list of script IDs to ignore",
          required: false,
          default: [],
          parser: fn id_str ->
            id_list =
              id_str
              |> String.split(",")
              |> Stream.map(&String.trim(&1))
              |> Stream.map(&String.to_integer(&1))
              |> Enum.to_list()

            {:ok, id_list}
          end
        ],
        output_dir: [
          value_name: "OUTPUT_DIR",
          short: "-o",
          long: "--output-dir",
          help: "The directory to output the generated repo to",
          required: false,
          default: Path.absname("greasyfork"),
          parser: fn fp -> {:ok, Path.absname(fp)} end
        ]
      ]
    )
    |> Optimus.parse!(args)
  end

  def main(args \\ []) do
    # parse args
    args = parse_args(args)

    # parse and filter userscripts
    userscripts =
      args.options.json
      |> GreasyforkRepoGenerator.parse_json_file()
      |> Enum.map(&UserScript.is_valid(&1, args.options.ignore_ids))
      |> Enum.filter(fn us -> us != :error end)

    # make sure directory exists
    if File.exists?(args.options.output_dir) do
      unless File.dir?(args.options.output_dir) do
        IO.puts(
          :stderr,
          "#{args.options.output_dir |> Path.expand()} already exists but isn't a directory"
        )

        exit(1)
      end
    else
      File.mkdir!(args.options.output_dir)
      IO.puts("Created directory #{args.options.output_dir |> Path.expand()}")
    end

    # create README
    readme_contents = Template.readme(userscripts)

    Path.join(args.options.output_dir, "README.md")
    |> File.write!(readme_contents)

    # write to README/script files
    userscripts
    |> Enum.map(&Template.create_script(&1, args.options.output_dir))

    IO.puts(
      "Created #{userscripts |> length()} userscript files at #{
        args.options.output_dir |> Path.expand()
      }"
    )
  end
end
