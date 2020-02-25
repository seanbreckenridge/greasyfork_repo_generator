# Greasyfork Repo Generator

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Archives a users Greasyfork account and creates a Github repo which contains each script/metadata as the `README`. See [here](https://github.com/seanbreckenridge/greasyfork) for example output.

```
Archives a users Greasyfork account and creates a Github repo 0.1.0
Sean Breckenridge github.com/seanbreckenridge

USAGE:
    greasyfork_repo_generator --json INPUT_JSON_FILE [--ignore-ids IGNORE_SCRIPT_IDS] [--output-dir OUTPUT_DIR]
    greasyfork_repo_generator --version
    greasyfork_repo_generator --help

OPTIONS:

    -j, --json              Output JSON file from greasyfork_archive
    -i, --ignore-ids        A comma separated list of script IDs to ignore (default:[])
    -o, --output-dir        The directory to output the generated repo to
```

## Installation & Run

Requires: `elixir`, `python3`

```
pip3 install --user greasyfork_archive
git clone https://github.com/seanbreckenridge/greasyfork_repo_generator
cd greasyfork_repo_generator
greasyfork_archive <YOUR_GREASYFORK_USER_ID> --output-file scraped_data.json
mix deps.get
mix escript.build
# the built escript binary can be copied onto your path, if you so desire
./greasyfork_repo_generator --json scraped_data.json --ignore-ids "37826,368355"
```
