<cfif isDefined("Form.btnNuevo")>
	<cfset Action = "RelacionCalculoRetro.cfm">
<cfelse>
	<cfset Action = "ResultadoCalculoRetro-lista.cfm">
</cfif>
<cfif isDefined("Form.chk") and isDefined("Form.btnEliminar")>
	<cfset Action = "RelacionCalculoRetro-lista.cfm">
	<cfset vchk = ListToArray(Form.chk)>
	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<!--- Borra la tabla de Paso de incidencias entre empresas, solo para este RCNid
			La referencia al campo RCNid es la tabla de incidencias, se usa solo para el proceso de 
			paso de incidencias entre empresas, solo este proceso llena este campo, por eso se hacen estos dos 
			delete asi de sencillos
		 --->
		<cfquery datasource="#Session.DSN#">
			delete from Incidencias where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from BMovimientoIncidencias where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<!--- --->
		
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
			delete from PagosEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>	
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
			delete from IncidenciasCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
			delete from CargasCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
			delete from DeduccionesCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
			delete from SalarioEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>
		<cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
			delete from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
		</cfquery>			
	</cfloop>
</cfif>

<cfoutput>

<form action="#Action#" method="post" name="sql">
	<cfif not isDefined("Form.btnNuevo")>
		<input name="RCNid" type="hidden" value="#Form.RCNid#">
		<input name="Tcodigo" type="hidden" value="#Form.Tcodigo#">
	</cfif>
	<input type="hidden" name="dummi" value="">
</form>
</cfoutput>

<HTML>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>
