@echo off
@SET PATH=%PATH%;C:\flex_sdk\bin
@SET BASE_OUTPUT=..\bin
@SET BASE_SRC=..\src
@SET LINK_REPORT=link_report.xml

echo :: Compiling Demo ::
mxmlc %BASE_SRC%\Preloader.as -load-config+=build_config.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\main.swf