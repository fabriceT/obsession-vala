#!/bin/sh

# Update the pot file
xgettext -L C# --keyword=_ --from-code=utf-8 ../src/*.vala -o obsession.pot
