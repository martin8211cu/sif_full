dump tran oscar with no_log
go
drop procedure sp_CreaCuentaFinanciera
go
create procedure sp_CreaCuentaFinanciera
(
	@Empresa 	int,
	@Formato 	varchar(100),
	@Modo 		char(1)	= 'G',
	@Oficina 	int	  	= -1,
	@Fecha 		datetime = null,
	@MSG		varchar(255) 	output,
	@CFcuenta 	numeric			output
) as
BEGIN
	select @MSG = null, @CFcuenta = null
	if @Fecha = null select @Fecha = getdate()
	declare @Parametros varchar(255)
	declare @Response varchar(16000)
	select @Parametros = @Formato || ',' || convert(varchar,@Oficina) || ',' || convert(varchar,@Fecha,111) || ',' || @Modo
	select @Response = interfazToSoinXML (
    		'http://10.7.7.39:8300/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm',
	    	'soin', convert(varchar,@Empresa), 'marcel', 'sup3rman', 
		'17', 
		@Parametros, '', '',
		1)
	select @MSG = interfazFromXML('MSG',@Response)
	select @Response = interfazFromXML('XML_OE',@Response)
	if @Response <> ""
		select @CFcuenta = convert(numeric,@Response)
END

go

declare @MSG varchar(255)
declare @CFcuenta numeric

execute sp_CreaCuentaFinanciera 
  @Empresa 	= 2
, @Formato 	= '0011-03-02'
, @Modo 	= 'V'
, @Oficina 	= 0
, @Fecha 	= '20050101'
, @MSG 		= @MSG out 
, @CFcuenta	= @CFcuenta out

execute sp_CreaCuentaFinanciera 
  @Empresa 	= 2
, @Formato 	= '0011-03'
, @MSG 		= @MSG out 
, @CFcuenta	= @CFcuenta out
go



