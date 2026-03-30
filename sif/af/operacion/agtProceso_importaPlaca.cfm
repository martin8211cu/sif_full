<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 3-6-2006.
		Motivo: se pinta el botÃ³n de regresar, se agrega el importador de Cambio CategorÃ­a Clase.
 --->
 
 <cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>
<cf_templateheader title="	Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importador">
		
		<!--- pone el valor a CFid y  IDtrans q seranenviadas por session--->
		<cfif isdefined("url.IDtrans") and isdefined("url.CFid")and len(trim(url.IDtrans)) NEQ 0  and len(trim(url.CFid)) NEQ 0>
			<cfset session.IDtrans = url.IDtrans>
			<cfset session.CFid = url.CFid>
		</cfif>
		
			<center>
				<table width="100%">
						<tr>
							<td align="right" valign="top" width="60%" >
								<cf_sifFormatoArchivoImpr EIcodigo = 'AFAGRPLACAS' tabindex="1">
							</td>
							<td align="center" valign="top" width="40%" >
								<cf_sifimportar EIcodigo="AFAGRPLACAS" mode="in" tabindex="2"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"align="center" valign="top">
								<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='transfPlaca.cfm'"> <!---onclick="javascript: location.href='transfcatclas.cfm?IDtrans=6&number=1'" --->
							</td>
						</tr>					
				</table>
			</center>
	
		<cf_web_portlet_end>
	<cf_templatefooter>

