<!---  --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<!--- Consultas --->
<cfset tabla = "CRTipoCompra">					
<cfset columnas = "Ecodigo, CRTCid, CRTCcodigo, CRTCdescripcion">
<cfset filtro = "Ecodigo = #session.Ecodigo# Order By CRTCcodigo">
<cfset navegacion = "">

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="30%" valign="top">
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet"
								tabla="#tabla#"
								columnas="#columnas#"
								desplegar="CRTCcodigo,CRTCdescripcion"
								etiquetas="C&oacute;digo,Descripci&oacute;n"
								formatos="S,S"
								filtro="#filtro#"
								align="left,left"
								ajustar="N,N"
								checkboxes="N"
								keys="CRTCid"
								MaxRows="10"
								filtrar_automatico="true"
								mostrar_filtro="true"
								filtrar_por="CRTCcodigo,CRTCdescripcion"
								irA="tcompra.cfm"
								showEmptyListMsg="true" />
					</td>
					<td width="70%" valign="top">
						<cfinclude template="tcompra-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>