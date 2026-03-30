<cfif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(form.chk)) gt 0>
	<!----Actualiza la tabla de marcas (RHControlMarcas) poner nulo el NumeroLote(es el CAMid de RHCMCalculoAcumMarcas)--->
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set numlote = null, grupomarcas = null, registroaut = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ( numlote in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="true">)
					or
				  numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="-1"><!---para poner como no procesadas las marcas que no debería porque el empleado no marca---->
				)
	</cfquery>
	<!---Eliminar registro ---->
	<cfquery datasource="#session.DSN#">
		delete from RHCMCalculoAcumMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="true">)
	</cfquery>
</cfif>
<form name="form3" action="RevMarcas-tabs.cfm" method="post" style="margin:0px;">									
	<cfinclude template="RevMarcas-ProcesarHiddens.cfm">
</form>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>