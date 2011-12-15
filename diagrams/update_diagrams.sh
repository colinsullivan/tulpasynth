#! /usr/bin/env bash



# Re-render all diagrams
for dia in *.dia
do
  echo "Processing diagram $dia"
  svg=${dia%.dia}.svg
  echo "Deleting $svg"
  rm $svg
  echo "Converting $dia to SVG"
  dia --export=$svg --filter=svg $dia
  png=${dia%.dia}.png
  echo "Deleting $png"
  rm $png
  echo "Converting $dia to PNG"
  dia --export=$png --filter=cairo-alpha-png $dia
done

echo 'Goodbye!'
