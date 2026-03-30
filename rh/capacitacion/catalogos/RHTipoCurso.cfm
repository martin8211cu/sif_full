<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>

<cf_web_portlet_start titulo="Tipos de Curso" skin="#Session.Preferences.Skin#">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="2" align="center"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
  <tr>
    <td valign="top" width="50%">
		<cfquery datasource="#session.dsn#" name="lista">
			select RHTCid, RHTCdescripcion
			from RHTipoCurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="RHTCdescripcion"
			etiquetas="Descripci&oacute;n"
			formatos="S"
			align="left"
			ira="RHTipoCurso.cfm"
			form_method="get"
			keys="RHTCid"
		/>		
	</td>
    <td valign="top" width="50%">
		<cfinclude template="RHTipoCurso-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>

