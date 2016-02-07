#!/usr/bin/env bash
coffee --bare --compile --output target/coffeescript/ src/coffeescript/
java -jar build/compiler.jar  --js target/coffeescript/**.js --js_output_file dist/suave-charts.min.js
