function CleanupDir {
    param([string] $directoryPath);

    if (Test-Path $directoryPath) {
        Remove-Item -Force -Recurse $directoryPath;
    }
}

CleanupDir "node_modules"
CleanupDir "scripts/node_modules"
CleanupDir "json"
CleanupDir "yaml"

mkdir json
mkdir yaml

npm install

Push-Location scripts
npm install
npm run build
node preprocessor.js
Pop-Location

Push-Location api-extractor-inputs-excel
../node_modules/.bin/api-extractor run
Pop-Location

./node_modules/.bin/api-documenter yaml --input-folder ./json/excel --output-folder ./yaml/excel --office

Push-Location scripts
node postprocessor.js
Pop-Location

Push-Location tools
npm install
npm run build
node coverage-tester.js
Pop-Location

# wait