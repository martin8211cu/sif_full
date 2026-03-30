<!---
  --- CRCCuentas
  --- ----------
  ---
  --- author: martin
  --- date:   25/10/17
  --->
<cfcomponent output="false">

	<cffunction name="CreaLote" access="public" returntype="struct">
		<cfargument name="Cuentaid" type="integer" required="true" hint="id de cuenta a la que se asociaran los folios">
		<cfargument name="CantidadFolios" type="string" required="true" hint="Cantidad de Folios para el Lote">
		<cfargument name="dsn" type="string" required="false" default="#Session.dsn#" >
		<cfargument name="Ecodigo" type="numeric" required="false" default="#Session.Ecodigo#" >
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#" >
		<cfargument name="EstadoFolio" type="string" required="false" default="G" hint="Cantidad de Folios para el Lote">

		<cfset result = Structnew()> 

		<cfset loc.lote ="#year(now())#">
		<cfquery name="rsMaxConsecutivoLote" datasource="#arguments.dsn#">
			select right('0000' + cast(cast(right( COALESCE(max(Lote),0),4) as integer)+1 as varchar),4) as consecutivo
			from CRCControlFolio where Lote like '#loc.lote#%' and Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset loc.lote ="#loc.lote##rsMaxConsecutivoLote.consecutivo#">

		<cfset loc.prenumero ="#DateFormat(now(),'YYMM')#0">
		<cfquery name="rsMaxConsecutivoFolio" datasource="#arguments.dsn#">
			select cast(right( COALESCE(max(Numero),0),4) as integer) as consecutivo
			from CRCControlFolio where Numero like '#loc.prenumero#%' and Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfsavecontent variable="strSQL">
			<cfloop from="1" to="#arguments.CantidadFolios#" index="loc.loopCount">
				<cfset loc.numfolio = rsMaxConsecutivoFolio.consecutivo>
				<cfset loc.numfolio = loc.numfolio + loc.loopCount>
				<cfset loc.strNumero = "0000#loc.numfolio#">
				<cfset loc.numero="#loc.prenumero##right(loc.strNumero,4)#">
<cfoutput>
INSERT INTO CRCControlFolio (CRCCuentasid,Lote,Numero,Estado,Ecodigo,Usucrea,createdat)
VALUES (#arguments.Cuentaid#,'#loc.lote#','#loc.numero#','#arguments.EstadoFolio#',#arguments.Ecodigo#,#arguments.Usucodigo#,getDate());
</cfoutput>
			</cfloop>
		</cfsavecontent>
		<cftry>
		<cfquery datasource="#arguments.dsn#">
			#PreserveSingleQuotes(strSQL)#
		</cfquery>
		<cfcatch type="any">
			<cfreturn cfcatch.messge>
		</cfcatch>
		</cftry>

		<cfset loc.inicial = right("0000#rsMaxConsecutivoFolio.consecutivo+1#",4)>
		
		<cfset result.lote = "#loc.lote#">
		<cfset result.folioInicial = "#loc.prenumero##loc.inicial#">
		<cfset result.folioFinal = "#loc.numero#">
		<cfset result.message = "Creado Lote: #loc.lote#. Folio Inicial: #loc.prenumero##loc.inicial# , Folio Final: #loc.numero#">
		<cfreturn result>
	</cffunction>

	<cffunction name="CancelaLote" access="public" returntype="string">
		<cfargument name="Lote" type="string" required="false" default="" hint="Numero de Lote a cancelar">
		<cfargument name="FolioInicial" type="string" required="false" default="" hint="Numero de Folio Inicial">
		<cfargument name="FolioFinal" type="string" required="false" default="" hint="Numero de Folio Final">
		<cfset msg ="Cancelado">
		<cftry>
		<cfif trim(arguments.Lote) neq "" or trim(arguments.FolioInicial) neq "" or trim(arguments.FolioFinal) neq "">
			<cfquery datasource="#session.dsn#" name="myQuery" result="myQueryResult">
				update CRCControlFolio set Estado = 'X'
				where Ecodigo = #Session.Ecodigo#
					<cfif trim(arguments.Lote) neq "">
						and Lote = '#arguments.Lote#'
						<cfset msg ="#msg# Lote: #arguments.Lote#" >
					</cfif>
					<cfif trim(arguments.FolioInicial) neq "" and trim(arguments.FolioFinal) neq "">
						and Numero between #arguments.FolioInicial# and #arguments.FolioFinal#
						<cfset msg ="#msg# Folios: #arguments.FolioInicial# al #arguments.FolioFinal#" >
					<cfelseif trim(arguments.FolioInicial) neq "" or trim(arguments.FolioFinal) neq "">
						and Numero = <cfif trim(arguments.FolioInicial) neq "">#arguments.FolioInicial#<cfelse>#arguments.FolioFinal#</cfif>
						<cfset msg ="#msg# Folio: <cfif trim(arguments.FolioInicial) neq "">#arguments.FolioInicial#<cfelse>#arguments.FolioFinal#</cfif>" >
					</cfif>
			</cfquery>
			<cfif myQueryResult.recordcount eq 0>
			    <cfset msg ="No se encontro ningun registro">
			</cfif>
		<cfelse>
			<cfset msg ="Seleccione un criterio de cancelacion">
		</cfif>
		<cfcatch type="any">
			<cfreturn cfcatch.message>
		</cfcatch>
		</cftry>
		<cfreturn "#msg#">
	</cffunction>

	<cffunction name="ValidarNumero" access="public" return="numeric">
		<cfargument name="Num_Producto" 	required="yes" 		type="numeric">
		<cfargument name="Monto" 			default=0 			type="numeric">
		<cfargument name="DSN" 				default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 			default="#Session.Ecodigo#" type="string">

		<cfargument name="SocioNegocioID" default=''>
		<cfargument name="TipoCuenta" default=''>
		<cfargument name="TiendaID" default=''>

		<cfquery name="q_Folio" datasource="#arguments.DSN#">
			select Estado,CRCCuentasid from CRCControlFolio
				where Numero = '#arguments.Num_Producto#' and Ecodigo = #arguments.Ecodigo#;
		</cfquery>

		<cfif q_Folio.recordcount eq 1>
			<cfset q_Folio = QueryGetRow(q_Folio, 1)>
			<cfif q_Folio.Estado eq "A">
				<cfif arguments.TipoTransac eq 'D'>
					<cfreturn q_Tarjeta.CRCCuentasid>
				</cfif>
				<cfset objCuenta = createObject("component","crc.Componentes.CRCCuentas")>
				<cfset montoDisponible = objCuenta.DisponibleCuenta(CuentaID="#q_Folio.CRCCuentasid#", Monto="#arguments.Monto#",DSN = #arguments.DSN#,Ecodigo = #arguments.Ecodigo#)>

				<cfif (arguments.Monto le montoDisponible and arguments.Monto ge 0) || arguments.Monto eq 0>
					<cfreturn q_Folio.CRCCuentasid>
				<cfelse>
					<cfreturn 0>
				</cfif>
			</cfif>
		</cfif>

		<cfreturn 0>


	</cffunction>



</cfcomponent>