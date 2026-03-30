<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&Aacute;reas de Programas'>
	<table width="100%" border="0" cellspacing="0">
	  <tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
	  <tr>
		<td valign="top">		
			<cfquery datasource="#session.dsn#" name="lista">
				select RHAGMid, RHAGMnombre
				from RHAreaGrupoMat
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by RHAGMnombre
			</cfquery>
				
			<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="RHAGMnombre"
				etiquetas="Descripci&oacute;n"
				formatos="V,V"
				align="left"
				ira="RHAreaGrupoMat.cfm"
				keys="RHAGMid"
				showEmptyListMsg="true"
			/>		
		</td>
		<td valign="top"  width="55%">
			<cfinclude template="RHAreaGrupoMat-form.cfm">
		</td>
	  </tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>

