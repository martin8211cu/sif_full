@echo off
echo DEBE PRIMERO SUSTITUIR EN ESTE COMPILAR.BAT:
echo    1. EL PATH DEL JDK/BIN: [UNIDAD SERVIDOR]:\[RUTA SERVIDOR]\Sybase\Shared\jdk1.2.2_10\bin
echo    2. QUITAR EL "GOTO FINAL"
GOTO FINAL


set Path=%path%;[UNIDAD SERVIDOR]:\[RUTA SERVIDOR]\Sybase\Shared\jdk1.2.2_10\bin

del AplicarMascara.class
del AplicarMascara.jar

javac AplicarMascara.java
jar cvf0 AplicarMascara.jar AplicarMascara.class

copy AplicarMascara.jar _sybase /y

:FINAL
pause
