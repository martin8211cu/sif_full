<cfparam name="form.PageNum" default="1">

<cfset modocambio = false>
<cfoutput>
<cfif isdefined("form.RHRegimenid") and len(trim(form.RHRegimenid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	RHRegimenid,
			Ecodigo,
            RHRegimenid,
			RHRegimencodigo,
			RHRegimendescripcion,
			BMUsucodigo,
			ts_rversion,
			FechaAlta,
            null as ts
		from RHCFDI_Regimen
		where RHRegimenid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRegimenid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"/>
	<cfif rsForm.recordcount>
		<cfset modocambio = true>
	</cfif>
</cfif>
<!--- Consultas Generales --->
<form action="RegimenContratacion-SQL.cfm" method="post" name="form1">
	
	<input type="hidden" name="PageNum" value="#form.PageNum#">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right"><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
		<td><input name="RCcodigo" type="text" value="<cfif isdefined("rsform.RHRegimencodigo")>#rsform.RHRegimencodigo#</cfif>" maxlength="5"></td>
	</tr>
    <tr>
		<td align="right"><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
		<td><input name="RCdescripcion" type="text" value="<cfif isdefined("rsform.RHRegimendescripcion")>#rsform.RHRegimendescripcion#</cfif>" maxlength="40"></td>
	</tr>
	</table>
	<input type="hidden" name="RHRegimenid" value="<cfif isdefined("rsform.RHRegimenid")>#rsform.RHRegimenid#</cfif>">
	<input type="hidden" name="ts" value="<cfif isdefined("ts")>#ts#</cfif>">
	<br>
	<cf_botones modocambio = "#modocambio#" genero = "F" nameEnc = "Regimen">
	<br>
</form>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Codigo"
Default="Código"
returnvariable="MSG_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Descripcion"
Default="Descripción"
returnvariable="MSG_Descripcion"/>

<cf_qforms form="form1" objForm="objForm1">
<script language="javascript" type="text/javascript">
    objForm1.RCcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
    objForm1.RCdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function habilitarValidacion(){
		objForm1.required("RCcodigo,RCdescripcion");
	}	
	function deshabilitarValidacion(){
		objForm1.required("RCcodigo,RCdescripcion",false);
	}
</script>
            
</cfoutput>