<cfparam name="form.PageNum" default="1">

<cfset modocambio = false>
<cfoutput>
<cfif isdefined("form.RHIncapid") and len(trim(form.RHIncapid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	RHIncapid,
			Ecodigo,
			RHIncapcodigo,
			RHIncapdescripcion,
			BMUsucodigo,
			ts_rversion,
			FechaAlta,
            null as ts
		from RHCFDIIncapacidad
		where RHIncapid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIncapid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"/>
	<cfif rsForm.recordcount>
		<cfset modocambio = true>
	</cfif>
</cfif>
<!--- Consultas Generales --->
<form action="TipoIncapacidad-SQL.cfm" method="post" name="form1">
	
	<input type="hidden" name="PageNum" value="#form.PageNum#">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right"><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
		<td><input name="TIcodigo" type="text" value="<cfif isdefined("rsform.RHIncapcodigo")>#rsform.RHIncapcodigo#</cfif>" maxlength="5"></td>
	</tr>
    <tr>
		<td align="right"><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
		<td><input name="TIdescripcion" type="text" value="<cfif isdefined("rsform.RHIncapdescripcion")>#rsform.RHIncapdescripcion#</cfif>" maxlength="40"></td>
	</tr>
	</table>
	<input type="hidden" name="RHIncapid" value="<cfif isdefined("rsform.RHIncapid")>#rsform.RHIncapid#</cfif>">
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
    objForm1.TIcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
    objForm1.TIdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function habilitarValidacion(){
		objForm1.required("TIcodigo,TIdescripcion");
	}	
	function deshabilitarValidacion(){
		objForm1.required("TIcodigo,TIdescripcion",false);
	}
</script>
            
</cfoutput>