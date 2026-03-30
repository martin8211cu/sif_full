
<cf_templateheader title="Mantenimiento de Lugares de Custodia de Cheques">
	<cfset titulo = "Mantenimiento de Lugares de Custodia de Cheques">
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
		<td valign="top" width="50%">
        <cfinclude template="../../Utiles/sifConcat.cfm">
			<cf_dbfunction name="sPart" args="TESCFLUdescripcion;1;40" returnvariable="TESCFLUdescripcion2" delimiters=";">
			<cfquery datasource="#session.dsn#" name="lista">
				select TESid, TESCFLUid, TESCFLUcodigo,
					#TESCFLUdescripcion2# #_Cat# ' ' #_Cat# case TESCFLUdescripcion when 'len(TESCFLUdescripcion) > 40' then '...' else '' end as  TESCFLUdescripcion
				  from TESCFlugares
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			</cfquery>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="TESCFLUcodigo, TESCFLUdescripcion"
				etiquetas="Código, Lugar de Custodia"
				formatos="S,S"
				align="left,left"
				ira="lugaresCustodia.cfm"
				form_method="get"
				keys="TESid,TESCFLUid"
			/>		
		</td>
		<td valign="top">
			<cfinclude template="lugaresCustodia_form.cfm">
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


