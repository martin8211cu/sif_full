<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpersona">

<cffunction name="CambioPaquete" output="false" returntype="string" access="remote">
	<cfargument name="cambioPQ" type="struct" required="Yes"  displayname="Paquete en Session">
	<cfargument name="cuentaid" type="string" required="Yes"  displayname="ID de la cuenta">
	
	<!--- convertimos las listas  de parametros a arreglos para facilitar la creacion de la extrucyura XML--->
	<cfset arrLogB = ListToArray(Arguments.cambioPQ.logBorrar.login,",")>
	<cfset arrSerB = ListToArray(Arguments.cambioPQ.logBorrar.servicios,",")>
	
	<cfset arrTel = ListToArray(Arguments.cambioPQ.logConservar.telefono,",")>
	<cfset arrLogC = ListToArray(Arguments.cambioPQ.logConservar.login,",")>
	<cfset arrSerC = ListToArray(Arguments.cambioPQ.logConservar.servicios,",")>
	
	<cfset arrPqPA = ListToArray(Arguments.cambioPQ.pqAdicional.cod,",")>
	<cfset arrLogPA = ListToArray(Arguments.cambioPQ.pqAdicional.logMover.login,",")>
	<cfset arrSerPA = ListToArray(Arguments.cambioPQ.pqAdicional.logMover.servicios,",")>
	
	<!---conseguimos los nombres de los paquetes y logines del paquete actual--->
	<cfquery name="rsPQAnterior" datasource="#session.DSN#">
		select PQnombre from ISBpaquete where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.cambioPQ.PQanterior#">
	</cfquery>
	<cfquery name="rsPQAntlog" datasource="#session.DSN#">
		select b.LGnumero, b.LGlogin, c.TScodigo
		from ISBproducto a
			inner join ISBlogin b
				on b.Contratoid=a.Contratoid
				and b.Habilitado=1
			inner join ISBserviciosLogin c
				on c.LGnumero=b.LGnumero
				and c.PQcodigo=a.PQcodigo
				and c.Habilitado=1
				and c.PQcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.cambioPQ.PQanterior#">
				and c.TScodigo in(select x.TScodigo from ISBservicioTipo x 
									where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
									and x.Habilitado =1)
		where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuentaid#">
			and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cambioPQ.contrato#">
			and a.PQcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.cambioPQ.PQanterior#">
	</cfquery>
	
	<cfquery name="rsPQNuevo" datasource="#session.DSN#">
		select PQnombre from ISBpaquete where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.cambioPQ.PQnuevo#">
	</cfquery>
	
	<cfset nomPQs="">
	<cfloop index="cont" from="1" to="#ArrayLen(arrPqPA)#">
		<cfquery name="rsNuevo" datasource="#session.DSN#">
			select PQnombre from ISBpaquete where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#arrPqPA[cont]#">
		</cfquery>
		<cfset nomPQs = nomPQs & ',' & rsNuevo.PQnombre >		
	</cfloop>
	<cfset arrPqNomPA = ListToArray(nomPQs,",")>
	
	<!---........................................................--->
	<!---<cfset act2="">
	<cfloop index="cont2" from = "1" to = "#ArrayLen(arrLogPA)#">
		<cfif act2 NEQ arrLogPA[cont2]>
			<cfif act2 NEQ ""></login></cfif>
			<cfset act2 = arrLogPA[cont2]>
			<login login="#act2#">
		</cfif>
		<servicio>#arrSerPA[cont2]#</servicio>
	</cfloop>
	<cfif ArrayLen(arrLogPA)></login></cfif>	--->
						
	<cfsavecontent variable="PaqueteXML"><cfoutput>#
			''
			#<?xml version="1.0" encoding="UTF-8"?>
			<cambioPaquete xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cambioPaquete.xsd">
				<Contratoid>#Arguments.cambioPQ.contrato#</Contratoid>
				<!---Paquete Anterior--->
				<paqueteAnterior>
					<codigoPaquete>#Arguments.cambioPQ.PQanterior#</codigoPaquete>
					<nombrePaquete>#rsPQAnterior.PQnombre#</nombrePaquete>
					<cfset act="">
					<cfloop query="rsPQAntlog">
						<cfif act NEQ rsPQAntlog.LGlogin>
							<cfif act NEQ ""></login></cfif>
							<cfset act = rsPQAntlog.LGlogin>
							<login login="#act#">
						</cfif>
						<servicio>#rsPQAntlog.TScodigo#</servicio>
					</cfloop>
					</login>
				</paqueteAnterior>
				<!---Paquete Nuevo--->
				<paqueteNuevo>
					<codigoPaquete>#Arguments.cambioPQ.PQnuevo#</codigoPaquete>
					<nombrePaquete>#rsPQNuevo.PQnombre#</nombrePaquete>
					<cfif len(trim(Arguments.cambioPQ.CNsuscriptor))>
						<CNsuscriptor>#Arguments.cambioPQ.CNsuscriptor#</CNsuscriptor>
						<CNnumero>#Arguments.cambioPQ.CNnumero#</CNnumero>
					</cfif>
				</paqueteNuevo>
				<!--- Servicios por Borrar --->
				<cfset act="">
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogB)#">
					<cfif act NEQ arrLogB[cont]>
						<cfif len(trim(act)) NEQ 0></loginPorBorrar></cfif>
						<cfset act = arrLogB[cont]>
						<loginPorBorrar login="#act#">
					</cfif>
					<servicio>#arrSerB[cont]#</servicio>
				</cfloop>
				<cfif ArrayLen(arrLogB)></loginPorBorrar></cfif>
				<!--- Servicios por Conservar --->
				<cfset act="">
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogC)#">
					<cfif act NEQ arrLogC[cont]>
						<cfif act NEQ ""></loginPorConservar></cfif>
						<cfset act = arrLogC[cont]>
						<loginPorConservar login="#act#">
						<cfif ArrayLen(arrTel)><telefono>#arrTel[cont]#</telefono></cfif>
					</cfif>
					<servicio>#arrSerC[cont]#</servicio>
				</cfloop>
				<cfif ArrayLen(arrLogC)></loginPorConservar></cfif>
				<!--- Paquetes Adicionales --->
				<cfset act="">
				<cfset act2="">
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrPqPA)#">
					<cfif act NEQ arrPqPA[cont]>
						<cfif act NEQ ""><cfif ArrayLen(arrLogPA)></login> <cfset act2=""> </cfif></paqueteAdicional></cfif>
						<cfset act = arrPqPA[cont]>
						<paqueteAdicional>
						<codigoPaquete>#act#</codigoPaquete>
						<nombrePaquete>#arrPqNomPA[cont]#</nombrePaquete>
					</cfif>
					<cfif act2 NEQ arrLogPA[cont]>
						<cfif act2 NEQ ""></login></cfif>
						<cfset act2 = arrLogPA[cont]>
						<login login="#act2#">
					</cfif>
					<servicio>#arrSerPA[cont]#</servicio>
				</cfloop>
				<cfif  ArrayLen(arrPqPA) and ArrayLen(arrLogPA)></login></cfif>
				<cfif ArrayLen(arrPqPA)></paqueteAdicional></cfif>			
			</cambioPaquete>
		</cfoutput>
	</cfsavecontent>
	<cfreturn #PaqueteXML#>
</cffunction>

<cffunction name="cambioFormaCobro" output="false" returntype="string" access="remote">
	<cfargument name="Contratoid" 		type="string" required="No"  displayname="Contratoid">
	<cfargument name="CTcobro" 			type="string" required="Yes">
	<cfargument name="CTtipoCtaBco" 	type="string" required="No">
	<cfargument name="CTbcoRef" 		type="string" required="No" >
	<cfargument name="CTmesVencimiento" type="string" required="No" >
	<cfargument name="CTanoVencimiento" type="string" required="No" >
	<cfargument name="EFid" 			type="string" required="No" >
	<cfargument name="MTid" 			type="string" required="Yes" >
	<cfargument name="PpaisTH" 			type="string" required="No" >
	<cfargument name="CTcedulaTH" 		type="string" required="No" >
	<cfargument name="CTnombreTH" 		type="string" required="No" >
	<cfargument name="CTapellido1TH" 	type="string" required="No" >
	<cfargument name="CTapellido2TH" 	type="string" required="No" >

	<cfsavecontent variable="cobroXML"><cfoutput>#
			''
			#<?xml version="1.0" encoding="UTF-8"?>
			<cambioFormaCobro xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cambioFormaCobro.xsd">
				<Contratoid>#Arguments.Contratoid#</Contratoid>
				<datosFormaCobro CTcobro="#Arguments.CTcobro#"
						CTtipoCtaBco="#Arguments.CTtipoCtaBco#"
						CTbcoRef="#Arguments.CTbcoRef#"
						CTmesVencimiento="#Arguments.CTmesVencimiento#"
						CTanoVencimiento="#Arguments.CTanoVencimiento#"
						EFid="#Arguments.EFid#"
						MTid="#Arguments.MTid#"
						PpaisTH="#Arguments.PpaisTH#"
						CTcedulaTH="#Arguments.CTcedulaTH#"
						CTnombreTH="#Arguments.CTnombreTH#"
						CTapellido1TH="#Arguments.CTapellido1TH#"
						CTapellido2TH="#Arguments.CTapellido2TH#"></datosFormaCobro>
			</cambioFormaCobro>
		</cfoutput>
	</cfsavecontent>
	<cfreturn #cobroXML#>
</cffunction>

<cffunction name="retiroServicio" output="false" returntype="string" access="remote">
	<cfargument name="Contratoid" 		type="string" required="Yes"  displayname="Codigo del producto">
	<cfargument name="PQcodigo" 		type="string" required="Yes"  displayname="Codigo de Paquete">
	<cfargument name="motivoid" 		type="string" required="Yes"  displayname="Motivo de Retiro">
	<cfargument name="fecha" 			type="date" required="Yes"  displayname="Fecha de Retiro">
	<cfargument name="devolucion" 		type="boolean" required="Yes" displayname="Devolucion del depósito">
	
	<cfquery name="rsPQ" datasource="#session.DSN#">
		select PQnombre from ISBpaquete where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#">
	</cfquery>
	<cfquery name="rsMot" datasource="#session.DSN#">
		select MRcodigo,MRnombre from ISBmotivoRetiro where MRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.motivoid#">
	</cfquery>
	
	<cfsavecontent variable="retiroXML"><cfoutput>#
			''
			#<?xml version="1.0" encoding="UTF-8"?>
			<retiroServicio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="retiroServicio.xsd">
				<Contratoid>#Arguments.Contratoid#</Contratoid>
				<paquete>
					<codigoPaquete>#Arguments.PQcodigo#</codigoPaquete>
					<nombrePaquete>#rsPQ.PQnombre#</nombrePaquete>
				</paquete>
				<motivoRetiro>
					<codigoMotivo>#Arguments.motivoid#</codigoMotivo>
					<nombreMotivo>#rsMot.MRnombre#</nombreMotivo>
				</motivoRetiro>
				<fechaSolicitadaRetiro>#LSDateFormat(Arguments.fecha, 'yyyy-mm-dd')#</fechaSolicitadaRetiro>
				<devolucionDeposito>#Iif(Arguments.devolucion, DE("true"), DE("false"))#</devolucionDeposito>
			</retiroServicio>
		</cfoutput>
	</cfsavecontent>
	<cfreturn #retiroXML#>
</cffunction>

<cffunction name="retiroLogin" output="false" returntype="string" access="remote">
	<cfargument name="Contratoid" 		type="string" required="Yes"  displayname="Codigo del producto">
	<cfargument name="PQcodigo" 		type="string" required="Yes"  displayname="Codigo de Paquete">
	<cfargument name="LGlogin" 			type="string" required="Yes"  displayname="Login">
	<cfargument name="motivoid" 		type="string" required="Yes"  displayname="Motivo de Retiro">
	<cfargument name="fecha" 			type="date" required="Yes"    displayname="Fecha de Retiro">
	<cfargument name="devolucion" 		type="boolean" required="No"  default="false" displayname="Devolucion del depósito">
	
	<cfquery name="rsPQ" datasource="#session.DSN#">
		select PQnombre from ISBpaquete where PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#">
	</cfquery>
	<cfif Len(Arguments.motivoid)>
		<cfquery name="rsMot" datasource="#session.DSN#">
			select MRcodigo,MRnombre from ISBmotivoRetiro
			where MRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.motivoid#">
		</cfquery>
	</cfif>
	
	<cfsavecontent variable="retiroXML"><cfoutput>#
			''
			#<?xml version="1.0" encoding="UTF-8"?>
			<retiroServicio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="retiroServicio.xsd">
				<Contratoid>#Arguments.Contratoid#</Contratoid>
				<paquete>
					<codigoPaquete>#Arguments.PQcodigo#</codigoPaquete>
					<nombrePaquete>#rsPQ.PQnombre#</nombrePaquete>
					<login login="#Arguments.LGlogin#">
						<servicio></servicio>
					</login>
				</paquete>
				<motivoRetiro>
					<codigoMotivo>#Arguments.motivoid#</codigoMotivo>
					<nombreMotivo><cfif Len(Arguments.motivoid)>#rsMot.MRnombre#<cfelse>No especificado</cfif></nombreMotivo>
				</motivoRetiro>
				<fechaSolicitadaRetiro>#LSDateFormat(Arguments.fecha, 'yyyy-mm-dd')#</fechaSolicitadaRetiro>
				<devolucionDeposito>#Iif(Arguments.devolucion, DE("true"), DE("false"))#</devolucionDeposito>
			</retiroServicio>
		</cfoutput>
	</cfsavecontent>
	<cfreturn #retiroXML#>
</cffunction>

<cffunction name="respuestadepago" output="false" returntype="string" access="remote">
	<cfargument name="monto" type="numeric" required="yes">
	<cfargument name="origen" type="string" required="yes">
	<cfargument name="tipoTransaccion" type="string" required="yes">
	<cfargument name="descripcion" type="string" required="yes">
	<cfargument name="nombre" type="string" required="yes">
	<cfargument name="cuenta" type="string" required="yes">
	<cfargument name="correo" type="string" required="yes">

	<cfsavecontent variable="respuestadepagoXML"><cfoutput>#
			''
			#<?xml version="1.0" encoding="UTF-8"?>
			<RespuestadePago xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="RespuestadePago.xsd">
				<TransaccionID>#Arguments.PTid#</TransaccionID>
				<datosdepago monto="#Arguments.monto#"
						origen="#Arguments.origen#"
						tipoTransaccion="#Arguments.tipoTransaccion#"
						descripcion="#Arguments.descripcion#"
						nombre="#Arguments.nombre#"
						cuenta="#Arguments.cuenta#"
						correo="#Arguments.correo#"></datosdepago>
			</RespuestadePago>
	</cfoutput>
	</cfsavecontent>
	<cfreturn #respuestadepagoXML#>
</cffunction>


</cfcomponent>

