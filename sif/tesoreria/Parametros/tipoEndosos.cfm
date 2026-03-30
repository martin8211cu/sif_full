<cf_templateheader title="Mantenimiento de Tipos de Endosos">
	<cfset titulo = "Mantenimiento de Tipos de Endosos">
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

	<style type="text/css">
	<!--
	.style1 {
		color: #FF0000;
		font-weight: bold;
	}
	-->
	</style>

	<form name="frmTES" style="margin:0;" method="post">
	<table width="100%" border="0" cellspacing="6">
		<tr>
			<td colspan="2">
				<strong>Tesorería:</strong>
				<cf_cboTESid tipo="" onChange="document.frmTES.submit();" tabindex="1">
			</td>
		</tr>
	</table>
	</form>

	<table width="100%" border="0" cellspacing="6">
	  <tr>
		<td valign="top">
			<cfquery datasource="#session.dsn#" name="lista">
				select TESid,TESEcodigo, TESEdescripcion, case when TESEdefault = 1 then '<font color="##003399">(Default)</font>' end as TESEdefault
				  from TESendoso
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			</cfquery>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="TESEcodigo, TESEdescripcion, TESEdefault"
				etiquetas="Tipo Endoso, Descripcion, "
				formatos="S,S, S"
				align="left,left,left"
				ira="tipoEndosos.cfm"
				form_method="get"
				keys="TESid,TESEcodigo"
			/>		
		</td>
		<td valign="top">
			<cfinclude template="tipoEndosos_form.cfm">
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


