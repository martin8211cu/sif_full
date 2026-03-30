<cfinvoke key="LB_Titulo" default="Excluir cuentas de Mapeo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Formato" default="Formato" returnvariable="LB_Formato" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

			<cfset IRA = 'CatalogoCuentasInactivasCE.cfm'>


		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
			 	<td valign="top" style="padding-top:10px">
					<cfinclude template="formCatalogoCuentasInactivasCE.cfm">
				</td>
			</tr>
			<tr>
				<td valign="top" width="50%">
					<br>
					<br>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEInactivas"
						columnas  			= "Ccuenta,Cformato, Cdescripcion"
						desplegar			= "Cformato, Cdescripcion"
						etiquetas			= "#LB_Formato#, #LB_Descripcion# "
						formatos			= "S,S"
						filtro				= "Ecodigo = #Session.Ecodigo#"
						align 				= "Left, Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "true"
						formname			= "filtro"
						navegacion			= "#navegacion#"
						mostrar_filtro		= "true"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "Cformato"
						MaxRows				= "15"
						irA					= "#IRA#"
						/>
				</td>

		 	</tr>

		</table>
	<cf_web_portlet_end>
<cf_templatefooter>