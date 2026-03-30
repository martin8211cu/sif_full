@echo off
setlocal
del *.java
del *.class
set java_home=C:\sybase\Shared\jdk1.4.2\
set path=%java_home%\bin;%path%
call ..\bin\javacc.bat Simple1.jj
javac *.java

echo Listo.
java -cp %classpath%;. Calculator
endlocal
pause
