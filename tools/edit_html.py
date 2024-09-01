import os
import sys

args = sys.argv

BEFORE_STRING: str = "  <base href=\"/\">"
AFTER_STRING: str = "  <base href=\"/meedoc/\">"

def main():
    file_path: str = args[1]
    file_line: list[str] = list()
    with open(file_path, 'r') as file:
        file_line = file.readlines()

    for i in range(len(file_line)):
        file_line[i] = file_line[i].replace(BEFORE_STRING, AFTER_STRING)

    if os.path.exists(file_path):
        os.remove(file_path)

    with open(file_path, 'w') as file:
        for ln in file_line:
            file.write(ln)


if __name__ == "__main__":
    main()
