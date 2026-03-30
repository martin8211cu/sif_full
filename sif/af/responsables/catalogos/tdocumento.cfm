<!---  --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<!--- Consultas --->
<cfset checked = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cfset tabla = "CRTipoDocumento">					
<cfset columnas = "Ecodigo, CRTDid, CRTDcodigo, CRTDdescripcion, 
					case when CRTDdefault = 1 
						then '#checked#'
						else '#unchecked#' 
					end as CRTDdefault">
<cfset filtro = "Ecodigo = #session.Ecodigo# Order By CRTDcodigo">

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
								desplegar="CRTDcodigo,CRTDdescripcion,CRTDdefault"
								etiquetas="C&oacute;digo,Descripci&oacute;n,Default"
								formatos="S,S,U"
								filtro="#filtro#"
								align="left,left,center"
								ajustar="N,N,S"
								checkboxes="N"
								keys="CRTDid"
								MaxRows="10"
								filtrar_automatico="true"							
								filtrar_por="CRTDcodigo,CRTDdescripcion,''"
								irA="tdocumento.cfm"
								showEmptyListMsg="true"		
								mostrar_filtro="true"
							   />						

					</td>
					<td width="70%" valign="top">
						<cfinclude template="tdocumento-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>