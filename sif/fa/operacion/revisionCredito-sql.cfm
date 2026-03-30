<!--- Esta pantalla actualiza el límite de crédito en la tabla ClienteDetallista --->
<!--- también actualiza el tipo de venta y la observacion en la tabla VentaE.... --->
<cfparam name="form.dato" default="0">

<cfif form.dato EQ 1>
		<cfquery name="updateLimite" datasource="#session.DSN#">
			update ClienteDetallista set 
				CDlimitecredito = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CDlimitecredito,',','','all')#">
			where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">
		</cfquery>
		
		<cfquery name="updateEstado" datasource="#session.DSN#">
			update VentaE 
			set estado = 40 
			where  VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
		</cfquery>
	
<cfelseif form.dato EQ 2>
		<cfquery name="updateRechazo" datasource="#session.DSN#">
			update VentaE set 
				VPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VPid#">,
				obs_venta_perdida = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.observacion#">, 
				estado = 0
			where  VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
		</cfquery>
<cfelse>
	<cf_errorCode	code = "50379" msg = "¡Ha ocurrido un error a la hora de actualizar los datos!">
</cfif>

<cflocation url="revisionCredito-lista.cfm">


