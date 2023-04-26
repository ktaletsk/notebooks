import sys
import os
import re


def main():
    if len(sys.argv) < 3:
        print('Specify 2 arguments (input and output directories)')
        exit()

    dirs = list(filter(get_only_proper_dirs, [
                x[0] for x in os.walk(sys.argv[1])]))
    for dir in dirs:
        new_file = ""

        if os.path.isfile(sys.argv[2] + '/' + dir.split('/')[-1] + '.R'):
            continue

        if os.path.isfile(dir + '/Readme.md'):
            with open(dir + '/Readme.md', 'r') as f:
                new_file = re.sub(r'^', '# ', f.read(), flags=re.MULTILINE)
                new_file += '\n\n'

        if os.path.isfile(dir + '/app.R'):
            with open(dir + '/app.R', 'r') as f:
                for line in f:
                    new_file += line
                new_file += '\n\n'

        if os.path.isfile(dir + '/server.R'):
            with open(dir + '/server.R', 'r') as f:
                for line in f:
                    new_file += line
                new_file += '\n\n'

        if os.path.isfile(dir + '/ui.R'):
            with open(dir + '/ui.R', 'r') as f:
                for line in f:
                    new_file += line
                new_file += '\n\n'

        with open(sys.argv[2] + '/' + dir.split('/')[-1] + '.R', 'w') as f:
            f.write(new_file)


def get_only_proper_dirs(val):
    subdir_name = val.split('/')[-1]
    if (bool(re.search(r'\d\d\d', subdir_name))):
        return True
    else:
        return False


main()
