import argparse
import csv
import subprocess


parser = argparse.ArgumentParser()
parser.add_argument("--source", nargs=1, required=True)
parser.add_argument("--ref", nargs=1)
args = parser.parse_args()


with open(args.source[0], "r") as csvfile:
    rows = csv.DictReader(csvfile)
    for row in rows:
        print(f'Triggering workflow for "{row["fullname"]}"')
        try:
            subprocess.check_output([
                "gh", "workflow", "run", "generate.yml",
                "--ref", args.ref[0] if args.ref is not None else "master",
                "-f", "slug=" + row["slug"],
                "-f", "fullname=" + row["fullname"],
                "-f", "tagline=" + row["tagline"],
                "-f", "summary=" + row["summary"],
                "-f", "email=" + row["email"],
                "-f", "iconurl=" + row["iconurl"],
                "-f", "package=" + row["package"],
            ])
        except subprocess.CalledProcessError as e:
            print(
                f'Failed to triggering workflow for "{row["fullname"]}" with the following inputs:')
            print(row)
            input("Continue?")
