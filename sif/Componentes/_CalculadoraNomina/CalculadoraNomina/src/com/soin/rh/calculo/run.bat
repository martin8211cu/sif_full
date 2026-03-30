@echo off
setlocal

del Calculator.java
del CalculatorConstants.java
del CalculatorTokenManager.java
del ParseException.java
del SimpleCharStream.java
del Token.java
del TokenMgrError.java


set java_home=C:\sybase\Shared\jdk1.4.2\
set path=%java_home%\bin;%path%
call f:\sdc\rh\ExprCalculo\javacc-3.0\bin\javacc.bat CalculadoraNomina.jj

echo Listo.

endlocal
pause
