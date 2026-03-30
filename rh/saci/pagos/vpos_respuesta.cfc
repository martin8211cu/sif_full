<cfcomponent output="false">
<!---
Parametrización default desarrollo:
	Miso4217n		188: CRC ; 840: USD
	PAidioma		SP-Español, EN-Inglés
	PAlugar		Origen/Lugar de compra

insert into ISBpagoAutorizador (
	PAautoriza, PAdescripcion, Miso4217a, Miso4217n,
	PApubCifrado, PAprvCifrado, PApubFirma, PAprvFirma,
	PAvector, PAurl, PAadquiriente, PAmall,
	PAcomercio, PAterminal, PAidioma, PAlugar,BMUsucodigo)
values (
	'01', 'VISA Banco Uno', 'CRC', '188',
	'/WEB-INF/saci/keys/ALIGNET.TESTING.PHP.CRYPTO.PUBLIC.TXT', '/WEB-INF/saci/keys/cifrado.prv.txt', '/WEB-INF/saci/keys/ALIGNET.TESTING.PHP.SIGNATURE.PUBLIC.TXT', '/WEB-INF/saci/keys/firma.prv.txt',
	'4f928a5f4b3c772a', 'https://servicios.alignet.com/VPOS/MM/transactionStart.do', '2', '0',
	'1900', '00000000', 'SP', 'web',0)


insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'VS', '/cfmx/saci/faltadefiniradonde.cfm', 'Pruebas del SACI', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AUAG', '/cfmx/saci/cliente/gestion/gestion-servicios-apply.cfm?pagoenlinea=', 'Agregar servicio por autogestión', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AUCP', '/cfmx/saci/cliente/gestion/gestion-paquetes-apply.cfm?pagoenlinea=', 'Cambio de paquete por autogestión', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AURP', '/cfmx/saci/cliente/gestion/gestion-recarga-apply.cfm?pagoenlinea=', 'Recarga de prepago por autogestión', 0)

--->


<cffunction name="respuesta" output="false" access="remote" returntype="string">
	<cfargument name="PTid" type="numeric" required="yes">
		
		<!--- Validar que la operación PTid exista --->
	<cfquery datasource="#session.dsn#" name="validar">
		select p.PTdireccionIP, p.PTrespuesta, o.POurl, o.POorigen,
				p.PAautoriza, p.POtran, p.PTmonto, p.PTfechaTransaccion,
				p.PTautorizado, p.PTestado, p.PTcodAutorizacion, p.PTcodError,
				p.PTmsgError, p.PTrespuesta, p.PTfechaRespuesta, p.PTdireccionIP,
				p.PTdescripcion, p.PTusado, p.PTnombre, p.PTcuenta, p.PTcorreo
		from ISBpago p
			join ISBpagoOrigen o
				on p.PAautoriza = o.PAautoriza
				and p.POorigen = o.POorigen
				and p.POtran = o.POtran
		where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PTid#">
	</cfquery>

	<cfif validar.RecordCount is 0>
		<cfthrow message="La operación no existe.  El codigo de operación no ha sido registrado.">
	</cfif>
<!---
	<cfif validar.PTdireccionIP neq session.sitio.IP>
		<cfthrow message="La operación se había iniciado en otra dirección IP. La suya es #session.sitio.ip#">
	</cfif>	
--->	

	<cfinvoke component="saci.comp.generadorXML" method="respuestadepago" returnvariable="PagoXML">
		<cfinvokeargument name="monto" value="#validar.PTmonto#">
		<cfinvokeargument name="origen" value="#validar.POorigen#">
		<cfinvokeargument name="tipoTransaccion" value="#validar.POtran#">
		<cfinvokeargument name="descripcion" value="#validar.PTdescripcion#">
		<cfinvokeargument name="nombre" value="#validar.PTnombre#">
		<cfinvokeargument name="cuenta" value="#validar.PTcuenta#">
		<cfinvokeargument name="correo" value="#validar.PTcorreo#">
	</cfinvoke>	

	<cf_dump var=#PagoXML#>

	<cfreturn PagoXML>
</cffunction>



</cfcomponent>