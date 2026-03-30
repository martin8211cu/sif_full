<!--- <cfdump var="#form#"> --->
<cfset modo = "ALTA">

<cfif isdefined("url.GSNid") and (url.GSNid gt 0) and not isdefined("form.GSNid")>
	<cfset form.GSNid = url.GSNid>
</cfif>

<cfif isdefined("form.ESNid")and (form.ESNid) GT 0>
	<cfset modo="CAMBIO">
</cfif>

<cfif isDefined("Form.GSNid") and len(trim(#Form.GSNid#)) NEQ 0>
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		Select GSNcodigo, GSNdescripcion, ts_rversion
		from GrupoSNegocios
		where GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
	</cfquery>
	<cfif rsConsulta.recordcount GT 0>
		<cfset modo = "CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form name="form1" method="post" action="GrupoSocios-SQL.cfm">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_GSNcodigo" type="hidden" tabindex="-1" value="<cfif isdefined('form.filtro_GSNcodigo')>#form.filtro_GSNcodigo#</cfif>">
	<input name="filtro_GSNdescripcion" type="hidden" tabindex="-1" value="<cfif isdefined('form.filtro_GSNdescripcion')>#form.filtro_GSNdescripcion#</cfif>">

	<table border="0" cellpadding="2" cellspacing="0" width="95%" align="center">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td align="left"><input name="GSNcodigo" tabindex="1" id="GSNcodigo" value="<cfif modo NEQ 'ALTA'>#rsConsulta.GSNcodigo#</cfif>" type="text" maxlength="4" size="5"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td align="left"><input name="GSNdescripcion" tabindex="1" id="GSNdescripcion" value="<cfif modo NEQ 'ALTA'>#rsConsulta.GSNdescripcion#</cfif>" type="text" maxlength="80" size="45"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cf_botones modo=#modo#  tabindex="1"></td></tr>
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsConsulta.ts_rversion#"/>
			</cfinvoke>
		</cfif>  
		<input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">	
	</table> 
	<input name="GSNid"  tabindex="-1" type="hidden" value="<cfif isdefined("form.GSNid")>#form.GSNid#</cfif>">
</form>
</cfoutput>



<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">
	
	function deshabilitarValidacion(){
		objForm.GSNcodigo.required = false;
		objForm.GSNdescripcion.required = false;
	}
	function habilitarValidacion(){
		objForm.GSNcodigo.required = true;
		objForm.GSNdescripcion.required = true;
	}

	objForm.GSNcodigo.required = true;
	objForm.GSNcodigo.description="Código";
	objForm.GSNdescripcion.required = true;
	objForm.GSNdescripcion.description="Descripción";
	
	document.form1.GSNcodigo.focus();
</SCRIPT>
 