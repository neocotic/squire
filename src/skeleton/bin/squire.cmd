@echo off

setLocal enableDelayedExpansion

node "%~dp0\..\node_modules\squire\node_modules\coffee-script\bin\coffee" "%~dp0\..\node_modules\squire\bin\squire" %*

endLocal&exit /b