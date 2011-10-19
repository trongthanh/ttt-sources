:: COMPILATION GUIDE
:: Download Flex SDK at http://www.adobe.com/cfusion/entitlement/index.cfm?e=flex3sdk
:: extract Flex SDK to this default folder: C:\flex_sdk
:: run this batch file to compile the project
:: Note: Flex SDK requires Java Runtime Environment 6
@echo off
@SET PATH=%PATH%;C:\flex_sdk\bin
@SET BASE_OUTPUT=..\bin
@SET BASE_SRC=..\src
@SET LINK_REPORT=link_report.xml

echo :: Compiling Demo ::
mxmlc %BASE_SRC%\Demo.as -load-config+=build_config.xml -link-report=%LINK_REPORT% -o %BASE_OUTPUT%\main.swf

pause