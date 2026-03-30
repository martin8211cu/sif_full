
<cf_templateheader title="Mantenimiento de Estados de Custodia de Cheques">
	<cfset titulo = "Mantenimiento de Estados de Custodia de Cheques">
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

	<table width="100%" border="0" cellspacing="2" cellspacing="0">
	  <tr>
		<td valign="top" width="40%">
			<cfquery datasource="#session.dsn#" name="lista">
				select TESid, TESCFEid, TESCFEcodigo, TESCFEdescripcion
				  from TESCFestados
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and TESCFEimpreso=0 and TESCFEentregado=0 and TESCFEanulado=0
			</cfquery>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="TESCFEcodigo, TESCFEdescripcion"
				etiquetas="Código, Estados de Custodia"
				formatos="S,S"
				align="left,left"
				ira="estadosCustodia.cfm"
				form_method="get"
				keys="TESid,TESCFEid"
			/>		
		</td>
		<td valign="top">
			<cfinclude template="estadosCustodia_form.cfm">
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


