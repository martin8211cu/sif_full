<cfif isdefined("url.QPUOid") and not isdefined("form.QPUOid") and len(trim(url.QPUOid))>
	<cfset form.QPUOid = url.QPUOid>
</cfif>

<cfquery name="rsOficinasUsuario" datasource="#session.dsn#">
	select Ocodigo
    from QPassUsuarioOficina
    where Usucodigo = #session.Usucodigo#
</cfquery>

<cfset LvarFiltroOficinas = Valuelist(rsOficinasUsuario.Ocodigo, ",")>

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Usuarios por Sucursal'>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="100%">
            	<cfflush interval="16">
                

                <cf_navegacion name="Usulogin" 		default="" 	navegacion="navegacion">
                <cf_navegacion name="Pid" 			default="" 	navegacion="navegacion">
                <cf_navegacion name="Pnombre" 		default="" 	navegacion="navegacion">
                <cf_navegacion name="Papellido1" 	default=""  navegacion="navegacion">
                <cf_navegacion name="Oficodigo" 	default=""  navegacion="navegacion">
                
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                 returnvariable="pLista">
                   <cfinvokeargument name="tabla" 				value="Usuario u 
                                                                       inner join DatosPersonales p 
                                                                            on p.datos_personales = u.datos_personales 
                                                                       inner join QPassUsuarioOficina o
                                                                            on o.Usucodigo = u.Usucodigo
                                                                       inner join Oficinas b
                                                                       		on b.Ecodigo = o.Ecodigo
                                                                            and b.Ocodigo = o.Ocodigo   "/>
                    <cfinvokeargument name="columnas" 			value="o.QPUOid, u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2, b.Oficodigo"/>
                    <cfinvokeargument name="filtro" 			value="u.CEcodigo = #session.CEcodigo# and u.Uestado = 1"/>
                    <cfinvokeargument name="desplegar" 			value="Usulogin, Pid, Pnombre, Papellido1, Papellido2, Oficodigo"/>
                    <cfinvokeargument name="usaAJAX" 			value="no"/>
                    <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                    <cfinvokeargument name="etiquetas" 			value="Login, Identificacion, Nombre, Apellido1, Apellido2, Sucursal"/>
                    <cfinvokeargument name="formatos" 			value="S,S,S,S,S,S"/>
                    <cfinvokeargument name="align" 				value="left,left,left,left,left,left"/>
                    <cfinvokeargument name="ajustar" 			value="S"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="irA" 				value="QPassUsuxOfi.cfm"/>
                    <cfinvokeargument name="debug" 				value="N"/>
                    <cfinvokeargument name="Keys" 				value="QPUOid"/>
                    <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                     <cfinvokeargument name="filtrar_automatico" value="True"/> 
                    <cfinvokeargument name="filtrar_por" 		value="Usulogin, Pid, Pnombre, Papellido1, Papellido2, Oficodigo"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="MaxRows" 			value="30"/>
                    <cfinvokeargument name="TabIndex" 			value="1"/>
                </cfinvoke>	
            </td>
            <td style="vertical-align:top">
            	<cfinclude template="QPassUsuxOfi_form.cfm">
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>