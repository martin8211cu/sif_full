<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" 
xmlfile="TipoMapeoCuentas.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" 
xmlfile="TipoMapeoCuentas.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" 
xmlfile="TipoMapeoCuentas.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("LvarInfo")>
			<cfset IRA = 'TipoMapeoCuentasINFO.cfm'>
		<cfelse>
			<cfset IRA = 'TipoMapeoCuentas.cfm'>
		</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" width="50%">
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CGIC_Mapeo"
						columnas  			= "CGICMid, CGICMcodigo, CGICMnombre, '' as truco"
						desplegar			= "CGICMcodigo, CGICMnombre, truco"
						etiquetas			= "#LB_Codigo#, #LB_Nombre#, "
						formatos			= "S,S,U"
						filtro				= " "
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
						keys				= "CGICMid"
						MaxRows				= "15"
						irA					= "#IRA#"
						/>
				</td>
				<td valign="top">
					<cfinclude template="formTipoMapeoCuentas.cfm">
				</td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>