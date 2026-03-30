<cfprocessingdirective pageEncoding="utf-8">

<!--- TRADUCCIONES --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_AdmonRep		= t.Translate('LB_AdmonRep','Administración de Reportes', 'MenuAdministracionReportes.xml')>
<cfset LB_CatOriDatos	= t.Translate('LB_CatOriDatos','Categoría Origenes de Datos', 'MenuAdministracionReportes.xml')>
<cfset LB_OriDatos		= t.Translate('LB_OriDatos','Origenes de Datos', 'MenuAdministracionReportes.xml')>
<cfset LB_GestRep		= t.Translate('LB_GestRep','Gestión de Reportes', 'MenuAdministracionReportes.xml')>

<cfoutput>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_AdmonRep#">
	<ul>
		<!---Categoría Origenes de Datos◄◄--->
		<cfif acceso_uri("/commons/GeneraReportes/CategoriaOrigenDatos.cfm")>
			<li>
				<a href="/cfmx/commons/GeneraReportes/CategoriaOrigenDatos.cfm">#LB_CatOriDatos#</a>
			</li>
		</cfif>
		<!---►►Origenes de Datos◄◄--->
		<cfif acceso_uri("/commons/GeneraReportes/OrigenDatos.cfm")>
			<li>
				<a href="/cfmx/commons/GeneraReportes/OrigenDatos.cfm">#LB_OriDatos#</a>
			</li>
		</cfif>
		<!---►►Gestión de Reportes◄◄--->
		<cfif acceso_uri("/commons/GeneraReportes/GestionReportes/GestionReportes.cfm")>
			<li>
				<a href="/cfmx/commons/GeneraReportes/GestionReportes/GestionReportes.cfm">#LB_GestRep#</a>
			</li>
		</cfif>
	</ul>
<cf_web_portlet_end>
</cfoutput>