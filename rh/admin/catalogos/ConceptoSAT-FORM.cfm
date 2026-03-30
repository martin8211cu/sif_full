<cfparam name="form.PageNum" default="1">
<cfset modocambio = false>
<cfoutput>
<cfif isdefined("form.RHCSATid") and len(trim(form.RHCSATid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	RHCSATid,
			Ecodigo,
			RHCSATcodigo,
			RHCSATdescripcion,
            RHCSATtipo,
			BMUsucodigo,
			ts_rversion,
			FechaAlta,
            null as ts
		from RHCFDIConceptoSAT
		where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"/>
	<cfif rsForm.recordcount>
		<cfset modocambio = true>
	</cfif>
</cfif>
<!--- Consultas Generales --->
<form action="ConceptoSAT-SQL.cfm" method="post" name="form1" onsubmit="return valida();">
	
	<input type="hidden" name="PageNum" value="#form.PageNum#">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right"><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
		<td><input name="CScodigo" type="text" width="10" value="<cfif isdefined("rsform.RHCSATcodigo")>#rsform.RHCSATcodigo#</cfif>" maxlength="10"></td>
	</tr>
    <tr>
		<td align="right"><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
		<td><input name="CSdescripcion" type="text" width="70" value="<cfif isdefined("rsform.RHCSATdescripcion")>#rsform.RHCSATdescripcion#</cfif>" maxlength="100"></td>
	</tr>
    <tr>
		<td align="right"><strong>#LB_TIPO#&nbsp;:&nbsp;</strong></td>
		<td><input name="CStipo" type="text" value="<cfif isdefined("rsform.RHCSATtipo")>#rsform.RHCSATtipo#</cfif>" maxlength="1" 
        size="1">
        </td>
	</tr>
    
	</table>
	<input type="hidden" name="RHCSATid" value="<cfif isdefined("rsform.RHCSATid")>#rsform.RHCSATid#</cfif>">
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

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Tipo"
Default="Tipo"
returnvariable="MSG_Tipo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_TipoErr"
Default="El tipo solo puede ser (‘P’-Percepción, ‘D’-Deducción)"
returnvariable="MSG_TipoErr"/>

<cf_qforms form="form1" objForm="objForm1">
<script language="javascript" type="text/javascript">
    objForm1.CScodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
    objForm1.CSdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
    objForm1.CStipo.description="<cfoutput>#MSG_Tipo#</cfoutput>";
	
	function habilitarValidacion(){
		objForm1.required("CScodigo,CSdescripcion,CStipo");
	}	
	function deshabilitarValidacion(){
		objForm1.required("CScodigo,CSdescripcion,CStipo",false);
	}
	
	function valida()
	{
		if (document.form1.CStipo.value!='P' && document.form1.CStipo.value!='D')
		{
			alert('#MSG_TipoErr#');
			return false;   
		}
		return true;
	}
</script>
            
</cfoutput>