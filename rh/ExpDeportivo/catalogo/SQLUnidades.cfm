<cfparam name="action" default="Unidades.cfm">
<!---<cfparam name="modo" default="ALTA">--->

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
		
		<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EDUnidad
		where EDUcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDUcodigo#"> or
		EDUdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDUdescripcion#">
	
		</cfquery>
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaUnidaddeMedidaYaExiste"
				Default="La Unidad de Medida ya existe"
				returnvariable="MSG_LaUnidaddeMedidaYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_LaUnidaddeMedidaYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
		
			<cfquery name="rs" datasource="#session.DSN#">
				insert into EDUnidad (EDUcodigo, EDUdescripcion, BMfechaalta, BMUsucodigo)
				values ( <cfqueryparam value="#form.EDUcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#form.EDUdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_date">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">)
	
	<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rs">
	
		<cfelseif isdefined("form.Cambio")>
			<cfquery name="EDUcupUpdate" datasource="#session.DSN#">
				update EDUnidad
				set EDUdescripcion = <cfqueryparam value="#form.EDUdescripcion#"    cfsqltype="cf_sql_varchar">,
				EDUcodigo = <cfqueryparam value="#form.EDUcodigo#"    cfsqltype="cf_sql_char">
				where EDUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDUid#">
			</cfquery>  
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="EDUcupDelete" datasource="#session.DSN#">
				delete EDUnidad
				where EDUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDUid#">
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif isdefined("form.popup") and form.popup eq "s">
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('EDUid');
obj.options[obj.length] = new Option("#form.EDUcodigo# - #form.EDUdescripcion#", "#rs.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="Unidades.cfm">


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>﻿

</cfif>