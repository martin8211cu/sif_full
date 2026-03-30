set nocount on
go
declare @sec int,@time varchar(10)
select @sec = datepart(ss,getdate())
if @sec <= 30
select @time=convert(varchar,datepart(hh,getdate())) + ':' + convert(varchar,datepart(mi,getdate())+1) + ':00'
else
select @time=convert(varchar,datepart(hh,getdate())) + ':' + convert(varchar,datepart(mi,getdate())+1) + ':00'
waitfor time @time

	declare @Parametros varchar(255)
	declare @MSG varchar(16000)
	declare @Response varchar(16000)

	select @MSG = null
	select @Parametros = '0020-01-01-0000000002,1,16/01/2006,V'

--	select @Response = xf ('hola')
	select @Response = interfazToSoinXML (
    		'http://localhost:8300/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm',
	    	'soin', convert(varchar,2), 'obonilla66', 'sup3rman', 
		'17', 
		@Parametros, '', '',
		1)
	select @MSG = interfazFromXML('MSG',@Response)
	select @Response = interfazFromXML('XML_OE',@Response)
	print @Response 
	print @MSG
go
exec sp_configure 'total logical memory'
exec sp_configure 'size of global fixed heap'
exec sp_configure 'size of process object heap'
exec sp_configure 'size of shared class heap'
exec sp_configure 'stack size'
exec sp_configure 'number of java sockets'


exec sp_monitorconfig 'size of global fixed heap'
exec sp_monitorconfig 'size of process object heap'
exec sp_monitorconfig 'size of shared class heap'
exec sp_monitorconfig 'number of java sockets'
go