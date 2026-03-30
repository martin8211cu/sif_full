<cfif isdefined("url.QPTid") and not isdefined("form.QPTid") and len(trim(url.QPTid))>
	<cfset form.QPTid = url.QPTid>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recepción de Tags'>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="100%">
            	<cfflush interval="16">

                <cf_navegacion name="Oficodigoori" 	default="" 	navegacion="navegacion">
                <cf_navegacion name="OficodigoDest" default="" 	navegacion="navegacion">
                <cf_navegacion name="codigo" 		default="" 	navegacion="navegacion">
                <cf_navegacion name="descripcion" 	default=""  navegacion="navegacion">
                
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                 returnvariable="pLista">
                   <cfinvokeargument name="tabla" 				value="QPassTraslado a
                                                                        inner join Oficinas b
                                                                            on b.Ecodigo = a.Ecodigo
                                                                          and b.Ocodigo = a.OcodigoOri
                                                                        inner join Oficinas c
                                                                            on c.Ecodigo = a.Ecodigo
                                                                          and c.Ocodigo = a.OcodigoDest
                                                                        inner join Usuario d
                                                                        on d.Usucodigo = a.Usucodigo "/>
                    <cfinvokeargument name="columnas" 			value="a.QPTid,
                                                                        rtrim(b.Oficodigo) #_Cat# ' ' #_Cat# b.Odescripcion  as Oficodigoori,
                                                                        rtrim(c.Oficodigo) #_Cat# ' ' #_Cat# c.Odescripcion as OficodigoDest,
                                                                        a.QPTtrasDocumento as codigo,
                                                                        a.QPTtrasDescripcion as descripcion"/>
                    <cfinvokeargument name="filtro" 			value="a.Ecodigo = #session.Ecodigo#
                                                                      	and a.QPTtrasEstado in (1,2)
                                                                    	and exists(
                                                                            select 1
                                                                            from QPassUsuarioOficina f
                                                                            where f.Usucodigo = #session.Usucodigo#
                                                                            and  f.Ecodigo = #session.Ecodigo#
                                                                            and f.Ecodigo = c.Ecodigo
                                                                            and f.Ocodigo = c.Ocodigo
                                                                            )"/>
                    <cfinvokeargument name="desplegar" 			value="codigo, descripcion, Oficodigoori, OficodigoDest"/>
                    <cfinvokeargument name="usaAJAX" 			value="no"/>
                    <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                    <cfinvokeargument name="etiquetas" 			value="Documento, Descripción, Sucursal Origen, Sucursal Destino"/>
                    <cfinvokeargument name="formatos" 			value="S,S,S,S"/>
                    <cfinvokeargument name="align" 				value="left,left,left,left"/>
                    <cfinvokeargument name="ajustar" 			value="S"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="irA" 				value="QPassRecepcion_form.cfm"/>
                    <cfinvokeargument name="debug" 				value="N"/>
                    <cfinvokeargument name="Keys" 				value="QPTid"/>
                    <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                    <cfinvokeargument name="filtrar_automatico" value="True"/> 
                    <cfinvokeargument name="filtrar_por" 		value=" a.QPTtrasDocumento,
                                                                        a.QPTtrasDescripcion,
                                                                        rtrim(b.Oficodigo) #_Cat# ' ' #_Cat# b.Odescripcion,
                                                                        rtrim(c.Oficodigo) #_Cat# ' ' #_Cat# c.Odescripcion"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="MaxRows" 			value="30"/>
                    <cfinvokeargument name="TabIndex" 			value="1"/>
                </cfinvoke>	
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>