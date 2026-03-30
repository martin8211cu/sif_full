sp_configure "enable java", 1
go

sp_configure "number of java sockets", 10
go

create function interfazToSoin
	(
		urlSoin varchar(255), 
		CESoin varchar(255), 
		ESoin varchar(255), 
		uidSoin varchar(255), 
		pwdSoin varchar(255), 
		interfaz varchar(255), 
		id varchar(255)
	)
	returns varchar(255)
	not deterministic
	language java
	parameter style java
	external name 'interfazToSoinSybase.sendToSoin(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String)'
go
