copy ..\..\_fuentes\interfazToSoinSybase.jar /y
isql -Usa -P -Sconectividad -Doscar -iinterfazToSoinSybaseDrop.sql
instjava -finterfazToSoinSybase.jar -jinterfazToSoinSybase -Usa -P -Sconectividad -Doscar
isql -Usa -P -Sconectividad -Doscar -iinterfazToSoinSybase.sql
pause