<!----================= TRADUCCION ===================---->
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

<cfif isdefined("url.Gid") and len(trim(url.Gid)) and not isdefined("form.Gid")>
	<cfset form.Gid = url.Gid>
</cfif>
<cfset modo="ALTA">
<cfif isdefined("form.Gid") and len(trim(form.Gid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select Gid,Gcodigo,Gdescripcion,ts_rversion
		from RHCMGrupos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
	</cfquery>
</cfif>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<form name="formGrupos" action="Supervisores-Grupos-sql.cfm" method="post">
		<input type="hidden" name="Gid" value="<cfif modo NEQ 'ALTA'>#form.Gid#</cfif>">
		<tr>
			<td align="right"><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
			<td><input type="text" name="Gcodigo" value="<cfif modo NEQ 'ALTA'>#rsform.Gcodigo#</cfif>" maxlength="20" size="20"></td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
			<td><input type="text" name="Gdescripcion" value="<cfif modo NEQ 'ALTA'>#rsform.Gdescripcion#</cfif>" maxlength="255" size="40"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
		<cfset ts = "">
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
			  <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
	</form>
</table>
</cfoutput>

<cf_qforms form="formGrupos">
<script type="text/javascript" language="javascript1.2">
	objForm.Gcodigo.required = true;
	objForm.Gcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.Gdescripcion.required = true;
	objForm.Gdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function habilitarValidacion() {
		objForm.Gcodigo.required = true;
		objForm.Gdescripcion.required = true;
	}
	
	function deshabilitarValidacion() {
		objForm.Gcodigo.required = false;
		objForm.Gdescripcion.required = false;
	}
</script>
