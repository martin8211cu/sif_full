sp_configure "enable java", 1
go

sp_configure "number of java sockets", 10
go

print 'create function interfazToSoin'
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
	external name 'com.soin.interfaces.interfazToSoinSybase.sendToSoin(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String)'
go

print 'create function interfazToSoinXML'
go

create function interfazToSoinXML
	(
		urlSoin varchar(255), 
		CESoin varchar(255), 
		ESoin varchar(255), 
		uidSoin varchar(255), 
		pwdSoin varchar(255), 
		interfaz varchar(255), 
		xml_ie varchar(16384),
		xml_id varchar(16384),
		xml_is varchar(16384),
                xml_output bit
	)
	returns varchar(16384)
	not deterministic
	language java
	parameter style java
	external name 'com.soin.interfaces.interfazToSoinSybase.sendToSoinXML(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,boolean)'
go

print 'create function interfazFromXML'
go

create function interfazFromXML
	(
		response varchar(255), 
		xml      varchar(16384)
	)
	returns varchar(16384)
	not deterministic
	language java
	parameter style java
	external name 'com.soin.interfaces.interfazToSoinSybase.responseFromXML (java.lang.String,java.lang.String)'
go

print 'create function interfazToSoinSQL'
go

create function interfazToSoinSQL
	(
		urlSoin varchar(255), 
		CESoin varchar(255), 
		ESoin varchar(255), 
		uidSoin varchar(255), 
		pwdSoin varchar(255), 
		interfaz varchar(255), 
		sql_ie varchar(16384),
		sql_id varchar(16384),
		sql_is varchar(16384),
                xml_output bit
	)
	returns varchar(16384)
	not deterministic
	language java
	parameter style java
	external name 'com.soin.interfaces.interfazToSoinSybase.sendToSoinSQL(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,boolean)'
go

