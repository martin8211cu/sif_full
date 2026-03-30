<!--- <cfdump var="#Session.Ecodigo#"> --->

<cfinvoke key="LB_Titulo" default="Metodos de pago" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cfinvoke key="LB_Concepto" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

			<cfset IRA = 'list.cfm'>


		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" width="50%">

					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEMtdoPago"
						columnas  			= "Clave, Concepto"
						desplegar			= "Clave, Concepto"
						etiquetas			= "#LB_Clave#, #LB_Nombre#"
						formatos			= "S,S"
						filtro				= "(Ecodigo is null or Ecodigo = #Session.Ecodigo#) ORDER BY
										       CASE WHEN LEFT(Clave, 1) BETWEEN '0' AND '9' THEN ' ' ELSE LEFT(Clave, 1) END,
										       CAST(STUFF(Clave, 1, CASE WHEN LEFT(Clave, 1) BETWEEN '0' AND '9' THEN 0 ELSE 1 END, '') AS int)"
						align 				= "Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "true"
						formname			= "filtro"
						navegacion			= "#navegacion#"
						mostrar_filtro		= "true"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "Clave"
						MaxRows				= "15"
						irA					= "#IRA#"
						/>

				</td>
				<td valign="top">
					<cfinclude template="form.cfm">
				</td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>