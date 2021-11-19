import argparse
import csv
import io
import os
import subprocess
from typing import List, Dict


class App:
    params: Dict

    def __init__(self, **kwargs) -> None:
        self.params = kwargs

    def generate_web_pages(self):
        subprocess.check_output(
            ["./generate.sh"], env=os.environ.update(self.params),
        )

    def generate_dsr(self):
        subprocess.check_output(
            ["./generate_dsr.sh"],
            env=os.environ.update({"slug": self.params['slug']}),
        )


parser = argparse.ArgumentParser()
parser.add_argument("--csv", nargs=1)
args = parser.parse_args()

apps: List[App] = []
if args.csv is not None:
    with io.StringIO(args.csv[0]) as csvio:
        rows = csv.DictReader(csvio)
        for row in rows:
            apps.append(App(
                slug=row["slug"],
                fullname=row["fullname"],
                tagline=row["tagline"],
                summary=row["summary"],
                email=row["slug"],
                iconurl=row["iconurl"],
                package=row["package"],
            ))
else:
    apps.append(App(
        slug=os.environ["slug"],
        fullname=os.environ["fullname"],
        tagline=os.environ["tagline"],
        summary=os.environ["summary"],
        email=os.environ["slug"],
        iconurl=os.environ["iconurl"],
        package=os.environ["package"],
    ))

failed = False
for app in apps:
    print(f'Generating web pages for "{app.params["fullname"]}"')
    try:
        app.generate_web_pages()
    except subprocess.CalledProcessError as e:
        failed = True
        print(
            f'Failed to generate web pages for "{app.params["fullname"]}"',
        )

    print(f'Generating DSR for "{app.params["fullname"]}"')
    try:
        app.generate_dsr()
    except subprocess.CalledProcessError as e:
        failed = True
        print(
            f'Failed to generate DSR for "{app.params["fullname"]}"',
        )

if failed:
    exit(1)
