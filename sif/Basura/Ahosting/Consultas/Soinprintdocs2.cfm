<!---
voy...
1. Definir tipo de formato.  Incluir campo de control NUMERODOC.
2. Definir formato de impresión, incluyendo el diseño y la imagen
  2a. Si tiene lineas de detalle, ocupa lineas de posdetalle
3. Seleccionar formato, usando 'FACT'
---->
<cf_templateheader title="Estado del SoinPrintDocs">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estatus del Sistema'>

<cfoutput>
<form name="Principal" action="/cfmx/sif/basura/ahosting/menuah.cfm">
<table>
	<tr>
    	<td>
        	<strong>Navegador:</strong>
        </td>
        <td>
            <cfif isdefined("url.Browser") and len(url.Browser)>
                #url.Browser#
            <cfelse>
            	Desconocido
            </cfif>
        </td>
        <td>
        	<strong>Versión:</strong>
        </td>
        <td>
            <cfif isdefined("url.Version") and len(url.Version)>
                #url.Version#
            <cfelse>
            	Desconocido
            </cfif>
        </td>
        <td>
        	<strong>Sistema:</strong>
        </td>
        <td>
            <cfif isdefined("url.OS") and len(url.OS)>
                #url.OS#
            <cfelse>
            	Desconocido
            </cfif>
        </td>
    </tr>
	<tr>
    	<td>
        	<strong>Error:</strong>
        </td>

    	<td colspan="5">
            <cfif isdefined("url.Error") and len(url.Error)>
                <strong> #url.Error# </strong>
            </cfif>
		</td>            
    </tr>
    <tr>
    	<td>
        	<strong>Estatus:</strong>
        </td>

    	<td colspan="5">
            <cfif isdefined("url.Estatus") and len(url.Estatus)>
                <strong> #url.Estatus# </strong>
            </cfif>
		</td>            
    </tr>
    <tr>
    	<td colspan="6" align="center">
        	<input type="submit" name="Regresar" value="Regresar" />
        </td>

    </tr>
</table>
</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>