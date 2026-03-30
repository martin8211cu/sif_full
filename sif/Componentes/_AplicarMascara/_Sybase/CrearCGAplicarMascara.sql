print 'Creando CGAplicarMascara'
go
create function CGAplicarMascara ( cuenta varchar(100), valor varchar(100) )  returns varchar (100)  deterministic language java  parameter style java external name  'AplicarMascara.aplicar(java.lang.String,java.lang.String)'
go
print 'Creando CGAplicarMascara2'
go
create function CGAplicarMascara2( cuenta varchar(100), valor varchar(100), cual varchar(1) )  returns varchar (100)  deterministic language java  parameter style java external name  'AplicarMascara.aplicar_mascara(java.lang.String,java.lang.String, java.lang.String )'
go
print 'Creando CGExtraerNivelesP'
go
create function CGExtraerNivelesP( CFformato varchar(100), nivelesP varchar(100) )  returns varchar (100)  deterministic language java  parameter style java external name  'AplicarMascara.extraerNivelesP(java.lang.String,java.lang.String)'
go
