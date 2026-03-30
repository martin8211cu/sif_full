<cfif isdefined("Form.btnAnular")>
	<cfset acciones = ListToArray(Form.chk, ',')>
	<cfloop from="1" to="#ArrayLen(acciones)#" index="i">
		<cfquery name="rsAnula" datasource="#Session.DSN#">
			Update FACotizacionesE
			 set Estatus = 2
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			 and NumeroCot = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
		</cfquery>  
	</cfloop>
</cfif>

<cflocation url="EliminaCotVencidas.cfm">