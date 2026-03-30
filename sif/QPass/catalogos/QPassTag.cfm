<cfif isdefined("LvarTagVendidos") and LvarTagVendidos>
	<cfset LvarEstados = "(4)">
<cfelse>
	<cfset LvarTagVendidos = false>
	<cfset LvarEstados = "(1, 2, 7, 9)">
</cfif>
<cfif isdefined("url.QPTidTag") and not isdefined("form.QPTidTag") and len(trim(url.QPTidTag))>
	<cfset form.QPTidTag = url.QPTidTag>
</cfif>
<cfquery name="rsOficinasUsuario" datasource="#session.dsn#">
	select Ocodigo
    from QPassUsuarioOficina
    where Usucodigo = #session.Usucodigo#
</cfquery>

<cfif rsOficinasUsuario.recordcount eq 0>
	<table width="100%" style="vertical-align:middle" border="0">
    	<tr>
	        <td>&nbsp;</td>
        </tr>
        <tr>
	        <td>&nbsp;</td>
        </tr>
        <tr>
	        <td>&nbsp;</td>
        </tr>
    	<tr>
        	<td align="center"><cfoutput>***Usuario (#session.Usulogin#) no tiene Sucursales Definidas*** </cfoutput></td>
        </tr>
    </table>
	
    <cfabort>
</cfif>

<cfset LvarFiltroOficinas = Valuelist(rsOficinasUsuario.Ocodigo, ",")>

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Tags'>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="50%">
            	<cfflush interval="16">
                
                <cf_navegacion name="QPTPAN" 		default="" 	navegacion="navegacion">
                <cf_navegacion name="QPTNumSerie" 	default=""  navegacion="navegacion">
                <cf_navegacion name="Oficodigo" 	default=""  navegacion="navegacion">

                <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                 returnvariable="pLista">
                   <cfinvokeargument name="tabla" 				value="QPassTag a
                                                                    inner join Oficinas b
                                                                    on b.Ecodigo = a.Ecodigo
                                                                    and b.Ocodigo = a.Ocodigo"/>
                    <cfinvokeargument name="columnas" 			value="a.QPTidTag, a.QPTPAN, a.QPTNumSerie, b.Oficodigo"/>
                    <cfinvokeargument name="filtro" 			value="a.Ecodigo = #session.Ecodigo#
                                                             		and a.Ocodigo in (#LvarFiltroOficinas#)
                                                              		and a.QPTEstadoActivacion in #LvarEstados#"/> <!--- Solamente los que estan en poder del banco --->
                    <cfinvokeargument name="desplegar" 			value="QPTPAN, Oficodigo"/>
                    <cfinvokeargument name="usaAJAX" 			value="no"/>
                    <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                    <cfinvokeargument name="etiquetas" 			value="TAG,Sucursal"/>
                    <cfinvokeargument name="formatos" 			value="V,V"/>
                    <cfinvokeargument name="align" 				value="left,left"/>
                    <cfinvokeargument name="ajustar" 			value="n"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="irA" 				value=""/>
                    <cfinvokeargument name="debug" 				value="N"/>
                    <cfinvokeargument name="Keys" 				value="QPTidTag"/>
                    <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                     <cfinvokeargument name="filtrar_automatico" value="True"/> 
                    <cfinvokeargument name="filtrar_por" 		value="QPTPAN, Oficodigo"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="MaxRows" 			value="30"/>
                </cfinvoke>	
            </td>
            <td style="vertical-align:top" width="50%">
				<cfif isdefined("LvarTagVendidos") and LvarTagVendidos and isdefined("form.QPTidTag")>
	            	<cfinclude template="QPassTag_form.cfm">
				<cfelseif isdefined("LvarTagVendidos") and not LvarTagVendidos>
					<cfinclude template="QPassTag_form.cfm">
				</cfif>
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>