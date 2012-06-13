@echo off

setLocal enableDelayedExpansion

pushd "%~dp0\.."
	node .\node_modules\squire\node_modules\coffee-script\bin\coffee .\node_modules\squire\bin\squire %*
popd

endLocal&exit /b