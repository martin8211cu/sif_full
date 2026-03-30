<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Proceso de Compra SIGEPRO'>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_templatecss>
<title>Items por Proceso</title>
<cfif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>
    <cfset LvarProceso =  url.proceso> 
<cfelseif isdefined("Form.proceso") and len(trim( Form.proceso)) gt 0>
    <cfset LvarProceso =  Form.proceso>
</cfif>

<cfif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
    <cfset LvarSolicitud =  url.solicitud> 
<cfelseif isdefined("Form.solicitud") and len(trim( Form.solicitud)) gt 0>
    <cfset LvarSolicitud =  Form.solicitud>
</cfif>

<cfif isdefined("url.linea") and len(trim(url.linea)) gt 0>
    <cfset LvarLinea =  url.linea> 
<cfelseif isdefined("Form.linea") and len(trim( Form.linea)) gt 0>
    <cfset LvarLinea =  Form.linea>
</cfif>

<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left" >
	<tr>			
		<td valign="top">
		    <cfinclude template="ItemProcesoLista.cfm">
		</td>
		 <td>
		  <cfinclude template="ItemProcesoform.cfm">
		</td>   
	</tr>
</table> 

<cfoutput>
<script language="javascript" type="text/javascript">
function CMIPbaja(id, proceso, solicitud, linea)
   {
    if (confirm("¿Desea borrar la línea?"))
		{
			location.href = "ItemProcesoSQL.cfm?btnBaja&item="+id+"&proceso="+proceso+"&solicitud="+solicitud+"&linea="+linea;
		}
		return false;   
   }
</script>
</cfoutput>
<cf_web_portlet_end>
<table align="center">
    <tr>
        <td align="center"> 
         <input type="button" name="cerrar" value="Cerrar ventana" onclick="javascript:window.close();" />
	   </td>
   </tr>
</table>	   	