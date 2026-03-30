@echo off
echo DEBE PRIMERO SUSTITUIR EN ESTE INSTALAR.BAT:
echo    1. EL PATH DEL JDK/BIN: [UNIDAD SERVIDOR]:\[RUTA SERVIDOR]\Sybase\Shared\jdk1.2.2_10\bin
echo    2. TRES VECES "-U<UID> -P<PWD> -S<SERVER> -D<DATABASE>" POR LOS VALORES CORRESPONDIENTES
echo    3. QUITAR EL "GOTO FINAL"
GOTO FINAL

set Path=%path%;[UNIDAD SERVIDOR]:\[RUTA SERVIDOR]\Sybase\Shared\jdk1.2.2_10\bin

isql -U<uid> -P<pwd> -S<server> -D<database> -iinterfazToSoinSybaseDrop.sql
instjava -finterfazToSoinSybase.jar -jinterfazToSoinSybase -U<uid> -P<pwd> -S<server> -D<database>
isql -U<uid> -P<pwd> -S<server> -D<database> -iinterfazToSoinSybase.sql

:final
pause