<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cfif Len(url.modificado)>
	<cfquery datasource="sifinterfaces">
		<cfloop list="#url.modificado#" index="modif">
			<cfset ID          = ListGetAt(modif, 1, '/')>
			<cfset Consecutivo = ListGetAt(modif, 2, '/')>
			<cfif ListLen(modif, '/') ge 3>
				<cfset Factor      = ListGetAt(modif, 3, '/')>
			<cfelse>
				<cfset Factor      = 1>
			</cfif>
			
			update PMIINT_ID10
			<cfif factor neq 1>
			set factor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#factor#" scale="4">,
			    calculado = round (<cfqueryparam cfsqltype="cf_sql_numeric" value="#factor#" scale="4"> * PrecioTotal, 2)
			<cfelse>
			set factor = null,
			    calculado = null
			</cfif>
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#">
			  and Consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Consecutivo#">
			
		</cfloop>
	</cfquery>
	
	url.modificado: <cfoutput># HTMLEditFormat(url.modificado) #</cfoutput>
	
	<cfinclude template="lista-query.cfm">
	
	
<script type="text/javascript">
	window.parent.document.datos = {
		<cfoutput query="rsProductos" startrow="#StartRow#" maxrows="#PageSize#">
		r#CurrentRow#:{
			factor:'#NumberFormat(factor, ',0.0000')#',
			ID:'#NumberFormat(ID, '0')#',
			Consecutivo:'#NumberFormat(Consecutivo, '0')#'
			},
		</cfoutput>
		fin:0
	};
	<cfoutput query="rsProductos" startrow="#StartRow#" maxrows="#PageSize#">
	window.parent.document.lista.factor#CurrentRow#.value = '#NumberFormat(factor, ',0.0000')#';
	</cfoutput>
</script>

<cfelse>
	len=0<!--- Mensaje de debug --->
</cfif>


</body>
</html>
