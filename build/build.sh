#!/usr/bin/env bash
coffee --bare --compile --output target/coffeescript/ src/coffeescript/
java \
  -jar build/compiler.jar \
  --js target/coffeescript/**.js \
  --js_output_file dist/suave-charts.min.js \
  --entry_point target/coffeescript/suave_charts \
  --process_common_js_modules \
  --output_wrapper "(function(){%output%})();"
