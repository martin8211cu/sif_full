<cfparam name="form.PageNum" default="1">

<cfset modocambio = false>
<cfoutput>
<cfif isdefined("form.RHRiesgoid") and len(trim(form.RHRiesgoid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	RHRiesgoid,
			Ecodigo,
			RHRiesgocodigo,
			RHRiesgodescripcion,
			BMUsucodigo,
			ts_rversion,
			FechaAlta,
            null as ts
		from RHCFDI_Riesgo
		where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRiesgoid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"/>
	<cfif rsForm.recordcount>
		<cfset modocambio = true>
	</cfif>
</cfif>
<!--- Consultas Generales --->
<form action="RiesgoPuesto-SQL.cfm" method="post" name="form1">
	
	<input type="hidden" name="PageNum" value="#form.PageNum#">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right"><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
		<td><input name="RPcodigo" type="text" value="<cfif isdefined("rsform.RHRiesgocodigo")>#rsform.RHRiesgocodigo#</cfif>" maxlength="5"></td>
	</tr>
    <tr>
		<td align="right"><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
		<td><input name="RPdescripcion" type="text" value="<cfif isdefined("rsform.RHRiesgodescripcion")>#rsform.RHRiesgodescripcion#</cfif>" maxlength="40"></td>
	</tr>
	</table>
	<input type="hidden" name="RHRiesgoid" value="<cfif isdefined("rsform.RHRiesgoid")>#rsform.RHRiesgoid#</cfif>">
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
    objForm1.RPcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
    objForm1.RPdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function habilitarValidacion(){
		objForm1.required("RPcodigo,RPdescripcion");
	}	
	function deshabilitarValidacion(){
		objForm1.required("RPcodigo,RPdescripcion",false);
	}
	
</script>
            
</cfoutput>