import sys
import subprocess

with open('code.ex', 'w+') as fh:
    for line in sys.stdin.read().split("\\n"):
        fh.write(line+"\n")

p = subprocess.Popen(["elixir", "code.ex"], stdout=sys.stdout, stderr=sys.stdout)
p.wait()
