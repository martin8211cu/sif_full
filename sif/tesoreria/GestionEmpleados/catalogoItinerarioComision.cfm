<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Titulo" default = "Catalogo de Itinerarios de Comision" 
returnvariable="LB_Titulo" xmlfile = "catalogoItinerarioComision.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CiudadOrigen" default = "Origen" 
returnvariable="LB_CiudadOrigen" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CiudadDestino" default = "Destino" 
returnvariable="LB_CiudadDestino" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_FechaSalida" default = "Salida" 
returnvariable="LB_FechaSalida" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_HoraInicio" default = "Hora Inicio" 
returnvariable="LB_HoraInicio" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_HoraFin" default = "Hora Final" 
returnvariable="LB_HoraFin" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LineaAerea" default = "Linea Aerea" 
returnvariable="LB_LineaAerea" xmlfile = "catalogoItinerarioComision.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroVuelo" default = "Vuelo" 
returnvariable="LB_NumeroVuelo" xmlfile = "catalogoItinerarioComision.xml"/>


<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>

<cfif isdefined('url.GECid') and len(trim(#url.GECid#))>
	<cfset form.GECid=url.GECid>
</cfif>

<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
                	<cf_dbfunction name="to_number" args="GECIhinicio/60" dec="0" returnvariable="LvarInicio">
                	<cfset LvarInicio = "#LvarInicio# + (GECIhinicio-#LvarInicio#*60)/100">
                	<cf_dbfunction name="to_number" args="GECIhfinal/60" dec="0" returnvariable="LvarFinal">
                	<cfset LvarFinal = "#LvarFinal# + (GECIhfinal-#LvarFinal#*60)/100">
					<cfquery name="rsSelectPlantillas" datasource="#session.dsn#">
						select 	GECIid, 
                        		GECid,
                                GECIorigen,     
                                GECIdestino,   
                                GECIhotel,
                                GECIfsalida,
                                #preserveSingleQuotes(LvarInicio)# as GECIhinicio,
                                #preserveSingleQuotes(LvarFinal)# as GECIhfinal,
                                GECIlineaAerea,
                                GECInumeroVuelo  
							   
							from GECitinerario  
								where GECid = #form.GECid#
								
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectPlantillas#" 
						conexion="#session.dsn#"
						desplegar="GECIorigen,GECIdestino,GECIhotel,GECIfsalida,GECIhinicio,GECIhfinal,GECIlineaAerea,GECInumeroVuelo "
						etiquetas="#LB_CiudadOrigen#,#LB_CiudadDestino#,Hotel,#LB_FechaSalida#,#LB_HoraInicio#,#LB_HoraFin#,#LB_LineaAerea#,#LB_NumeroVuelo#"
						formatos="S,S,S,D,M,M,S,S"
						mostrar_filtro="false"
						align="left,left,left,left,left,left,left,left"
						ajustar="N,S,S,N,N,N,S,N"
						checkboxes="N"
						ira="catalogoItinerarioComision.cfm"
						keys="GECIid"
                        maxRows="0">
					</cfinvoke>
				</td>
				<td width="30%" valign="top">
					<cfinclude template="catalogoItinerarioComision-Form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>