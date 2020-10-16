@ECHO OFF

set "CURRENT_DIR=%cd%"
if not "%FSHARECHAT_PUSH_API_HOME%" == "" goto gotHome
set "FSHARECHAT_PUSH_API_HOME=%CURRENT_DIR%"
if exist "%FSHARECHAT_PUSH_API_HOME%\push-api.bat" goto okHome
cd ..
set "FSHARECHAT_PUSH_API_HOME=%cd%"
cd "%CURRENT_DIR%"
:gotHome
if exist "%FSHARECHAT_PUSH_API_HOME%\push-api.bat" goto okHome
    echo The FSHARECHAT_PUSH_API_HOME environment variable is not defined correctly
    echo This environment variable is needed to run this program
goto end
:okHome

rem Set JavaHome if it exists
if exist { "%JAVA_HOME%\bin\java" } (
    set "JAVA="%JAVA_HOME%\bin\java""
) else (
    set "JAVA="java""
)

echo Using JAVA_HOME:       "%JAVA_HOME%"
echo Using FSHARECHAT_PUSH_API_HOME:   "%FSHARECHAT_PUSH_API_HOME%"

rem  set LOG_CONSOLE_LEVEL=info
rem  set LOG_FILE_LEVEL=fine
set JAVA_OPTS=
set JAVA_OPTS_SCRIPT=-XX:+HeapDumpOnOutOfMemoryError -Djava.awt.headless=true
set FSHARECHAT_PUSH_API_PATH=%FSHARECHAT_PUSH_API_HOME%
set LOG_FILE=%FSHARECHAT_PUSH_API_HOME%\config\logback.xml
set CONFI_DIR = %FSHARECHAT_PUSH_API_HOME%\config\

for /F %%i in ('dir %FSHARECHAT_PUSH_API_HOME%\lib\ /B') do ( set JAR_NAME=%%i)
echo Push-API JAR_NAME: "%JAR_NAME%"
rem Use the Hotspot garbage-first collector.
set JAVA_OPTS=%JAVA_OPTS%  -XX:+UseG1GC

rem Have the JVM do less remembered set work during STW, instead
rem preferring concurrent GC. Reduces p99.9 latency.
set JAVA_OPTS=%JAVA_OPTS%  -XX:G1RSetUpdatingPauseTimePercent=5

rem Main G1GC tunable: lowering the pause target will lower throughput and vise versa.
rem 200ms is the JVM default and lowest viable setting
rem 1000ms increases throughput. Keep it smaller than the timeouts.
set JAVA_OPTS=%JAVA_OPTS%  -XX:MaxGCPauseMillis=500


rem rem GC logging options -- uncomment to enable

rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintGCDetails
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintGCDateStamps
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintHeapAtGC
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintTenuringDistribution
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintGCApplicationStoppedTime
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintPromotionFailure
rem set JAVA_OPTS=%JAVA_OPTS% -XX:PrintFLSStatistics=1
rem set JAVA_OPTS=%JAVA_OPTS% -XX:+UseGCLogFileRotation
rem set JAVA_OPTS=%JAVA_OPTS% -XX:NumberOfGCLogFiles=10
rem set JAVA_OPTS=%JAVA_OPTS% -XX:GCLogFileSize=10M"

start javaw -server %JAVA_OPTS% %JAVA_OPTS_SCRIPT% -jar %FSHARECHAT_PUSH_API_HOME%\lib\%JAR_NAME% --spring.config.additional-location=file:.\config\ 
rem > %FSHARECHAT_PUSH_API_HOME%\logs\push-api.log 2<&1
