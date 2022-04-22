#!/usr/bin/env python3
from os import path, chdir, symlink, remove
import sys
import json
import shutil

from pathlib import Path
import subprocess as sp

try:
    from colorama import Fore, Back, Style
except ImportError:
    class EmptyStrings:
        def __getattr__(self, x):
            return ""
    Fore = EmptyStrings()
    Back = EmptyStrings()
    Style = EmptyStrings()


def has_changes(path):
    cmd = ['git', 'diff-files', '--quiet', '--', path]
    res = sp.run(cmd, stdout=sp.DEVNULL, stderr=sp.PIPE)
    if res.returncode not in [0, 1]:
        raise sp.CalledProcessError(res.returncode, cmd, stderr=res.stderr)
    return res.returncode == 1

def is_untracked(path):
    cmd = ['git', 'ls-files', '--error-unmatch', '--', path]
    res = sp.run(cmd, stdout=sp.DEVNULL, stderr=sp.PIPE)
    if res.returncode not in [0, 1]:
        raise sp.CalledProcessError(res.returncode, cmd, stderr=res.stderr)
    return res.returncode == 1

def main():
    filedir = path.dirname(__file__)
    chdir(filedir)

    with open(path.join(filedir, 'config.json'), 'r') as f:
        cfg = json.load(f)

    installed, skipped = 0, 0
    for element in cfg:
        repo_path = element['repo']
        host_path = Path(element['host']).expanduser()
        if is_untracked(repo_path):
            print(f'{Fore.YELLOW}skipping {repo_path} as it is {Style.BRIGHT}untracked{Style.RESET_ALL}')
            skipped += 1
            continue
        if has_changes(repo_path):
            print(f'{Fore.YELLOW}skipping {repo_path} as it has {Style.BRIGHT}changes{Style.RESET_ALL}')
            skipped += 1
            continue
        if path.islink(host_path):
            print(f'{Fore.GREEN}skipping {repo_path} as it is {Style.BRIGHT}already installed{Style.RESET_ALL}')
            skipped += 1
            continue


        print(f'{Fore.GREEN}installing {repo_path}{Style.RESET_ALL}')
        if path.isdir(repo_path) and path.exists(host_path):
            shutil.rmtree(repo_path)
            shutil.copytree(host_path, repo_path)
            shutil.rmtree(host_path)
        elif path.isfile(repo_path) and path.exists(host_path):
            remove(repo_path)
            shutil.copy2(host_path, repo_path)
            remove(host_path)

        symlink(Path(repo_path).absolute(), host_path)
        installed += 1




if __name__ == '__main__':
    sys.exit(main() or 0)
