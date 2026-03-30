<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_GradosAcademicos"
	Default="Grados Acad&eacute;micos"
	returnvariable="LB_GradosAcademicos"/>
	<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Orden" default="Orden" returnvariable="LB_Orden"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Grado" default="Grado" returnvariable="LB_Grado"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_web_portlet_start border="true" titulo="#LB_GradosAcademicos#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
			<cfquery datasource="#session.dsn#" name="lista">
				select GAcodigo,#LvarGAnombre# as GAnombre,GAorden
				from GradoAcademico
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by GAorden
			</cfquery>
			<table width="100%" border="0" cellspacing="6">
				<tr>
					<td valign="top" width="50%">
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="GAnombre"
					etiquetas="#LB_Grado#"
					formatos="S"
					align="left"
					ira="RHGradosAcademico.cfm"
					form_method="get"
					keys="GAcodigo"
					/>		
					</td>
					<td valign="top" width="50%">
						<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
						<cfinclude template="RHGradosAcademico-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>


