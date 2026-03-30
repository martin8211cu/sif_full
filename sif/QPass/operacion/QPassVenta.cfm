<cfif isdefined("url.QPvtaTagid") and not isdefined("form.QPvtaTagid") and len(trim(url.QPvtaTagid))>
	<cfset form.QPvtaTagid = url.QPvtaTagid>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Venta de Tags'>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="100%">
            	<cfflush interval="16">

                <cf_navegacion name="QPTPAN" 		default="" 	navegacion="navegacion">
                <cf_navegacion name="QPvtaTagPlaca" default="" 	navegacion="navegacion">
                <cf_navegacion name="QPvtaTagFecha" default="" 	navegacion="navegacion">
                <cf_navegacion name="sucursal" 		default=""  navegacion="navegacion">
                <cf_navegacion name="QPcteNombre" 	default=""  navegacion="navegacion">
                
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                 returnvariable="pLista">
                    <cfinvokeargument name="tabla" 				value=" QPventaTags a
                                                                        inner join QPassTag b
                                                                           on b.QPTidTag = a.QPTidTag
                                                                        inner join Oficinas c
                                                                           on c.Ecodigo = a.Ecodigo
                                                                          and c.Ocodigo = a.Ocodigo
                                                                        inner join QPcliente d
																		   on d.QPcteid = a.QPcteid "/>
                    <cfinvokeargument name="columnas" 			value=" a.QPvtaTagid, b.QPTPAN, a.QPvtaTagPlaca, rtrim(c.Oficodigo) #_Cat# ' ' #_Cat# c.Odescripcion as sucursal, d.QPcteNombre, a.QPvtaTagFecha"/>
                    <cfinvokeargument name="filtro" 			value="a.Ecodigo = #session.Ecodigo#
                                                                       and exists(
                                                                             select 1
                                                                             from QPassUsuarioOficina f
                                                                             where f.Usucodigo = #session.Usucodigo#
                                                                             and  f.Ecodigo = #session.Ecodigo#
                                                                             and f.Ecodigo = a.Ecodigo
                                                                             and f.Ocodigo = a.Ocodigo) "/>
                    <cfinvokeargument name="desplegar" 			value="QPTPAN, QPvtaTagPlaca, sucursal, QPcteNombre, QPvtaTagFecha"/>
                    <cfinvokeargument name="usaAJAX" 			value="no"/>
                    <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                    <cfinvokeargument name="etiquetas" 			value="Tag, Placa, Sucursal, Cliente, Fecha Venta "/>
                    <cfinvokeargument name="formatos" 			value="S,S,S,S,D"/>
                    <cfinvokeargument name="align" 				value="left,left,left,left,left"/>
                    <cfinvokeargument name="ajustar" 			value="S"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="irA" 				value="QPassVenta_form.cfm"/>
                    <cfinvokeargument name="debug" 				value="N"/>
                    <cfinvokeargument name="botones" 			value="Nuevo"/>
                    <cfinvokeargument name="Keys" 				value="QPvtaTagid"/>
                    <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                    <cfinvokeargument name="filtrar_automatico" value="True"/> 
                    <cfinvokeargument name="filtrar_por" 		value=" b.QPTPAN,
                                                                        a.QPvtaTagPlaca,
                                                                        rtrim(c.Oficodigo) #_Cat# ' ' #_Cat# c.Odescripcion,
                                                                        d.QPcteNombre,
                                                                        a.QPvtaTagFecha"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="MaxRows" 			value="30"/>
                    <cfinvokeargument name="TabIndex" 			value="1"/>
                </cfinvoke>	
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>