
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>

<cf_templateheader title="SIF - Producción">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro Produccion'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">

<table border="1" width="100%"> 
	<form name="form1" method="post" action="SQLImportadorOT.cfm" onsubmit="return checkForm(this)">

	<table border="0" cellspacing="0" cellpadding="2" align="center">
		<br><br>
		<tr>
        	<td>
            	<input name="Pagina" type="hidden" value="1">
			<td><input name="archivo" type="file"></td>
		</tr>
        <tr><td>&nbsp;  </td></tr>
		<tr>
			<td colspan="2" align="center">
				<input name="importar" type="submit" id="importar" value="Importar">
			</td>
		</tr>
	</table>
	</form>
 
 <HR SIZE=5 WIDTH="100%" COLOR="#0066CC" ALIGN = CENTER>
    
    <table border="0" width="100%" height="350">
    	<tr><td>&nbsp;  </td></tr>
        <tr><td width="10%">&nbsp;  </td><td><b>Layout : </b></td></tr>
        <tr><td>&nbsp;  </td><td><b>
        		   Enc: E| fecha-registro| fecha-entrega| cod-cliente| num.OrdenT| descripción OT| observaciones <br />
			       &nbsp; &nbsp; &nbsp; &nbsp; P| num.secuencia-proceso| codigo-area <br />
			       &nbsp; &nbsp; &nbsp; &nbsp; M| num.secuencia-proceso| código-articulo| precio-unitario| cantidad| cod-unidad-medida <br />
				   &nbsp; &nbsp; &nbsp; &nbsp; N| código-articulo PT| precio-unitario PT| cantidad-PT
       </b></td></tr>
       <tr><td>&nbsp;  </td></tr>
       <tr><td>&nbsp;  </td></tr>
    </table>
 </table>
    
	<cf_web_portlet_end>	
<cf_templatefooter>   
 



