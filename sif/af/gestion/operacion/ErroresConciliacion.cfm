<cfinclude template="ErroresConciliacion-ver.cfm">
<cfset paramPeriodo = ObtienePeriodoActual(session.dsn, session.Ecodigo)>
<cfset paramMes = ObtieneMesActual(session.dsn, session.Ecodigo)>	
<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_VerErrores"
		Default="Verificacion de Errores"
		returnvariable="LB_VerErrores"/>
		<cfoutput>#LB_VerErrores#</cfoutput>
</title>
<cfif fnDocumentoNoConciliado(session.dsn, session.ecodigo, url.GATperiodo, url.GATmes, url.Cconcepto, url.Edocumento)>
	<cf_templatecss>
	<cf_web_portlet_start titulo="#LB_VerErrores#">
		<table align="center" border="0">
			<tr>
				<td align="center"><font color="navy"><strong>El documento no se encuentra conciliado.</strong></font></td>
			</tr>
			<tr>
				<td align="center"><font color="navy"><strong>Es necesario conciliar el documento para poder verificar los errores</strong></font></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>	
			<tr>
				<td align="center"><input type="button" name="btncerrar" value="-- Cerrar --" onClick="javascript:window.close();"></td>
			</tr>		
		</table>
	<cf_web_portlet_end>
	<cfabort>
</cfif>
<cfset AsientosAjuste = fnVerificaAsientoAjuste(session.dsn, session.ecodigo, url.GATperiodo, url.GATmes, url.Cconcepto, url.Edocumento)>
<cfset rsERR          = fnVerificaConciliacion(session.dsn, session.ecodigo, url.GATperiodo, url.GATmes, url.Cconcepto, url.Edocumento)>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_VerErrores#">
	<table border="0" align="center" width="100%">
	<tr>
		<td colspan="2" align="center"><strong>Listado de Errores</strong></td>
	</tr>
	<tr>
		<td colspan="2">
		
			<table border="0" align="center">
			<tr>
				<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#URL.Cconcepto#</cfoutput></td>
				<td><strong>Periodo:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#URL.GATperiodo#</cfoutput></td>
			</tr>			
			<tr>
				<td width="10%"><strong>Documento:&nbsp;&nbsp;</strong></td>
				<td width="90%"><cfoutput>#URL.Edocumento#</cfoutput></td>
				<td><strong>Mes:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#URL.GATmes#</cfoutput></td>
			</tr>
			</table>
	
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td colspan="2">
		<cfif rsErr.recordcount gt 0>
			<table align="center" width="100%">
			<tr>
				<td bgcolor="silver"><strong>Mensaje de Error</strong></td>
				<td bgcolor="silver"><strong>Valor</strong></td>
			</tr>
			<cfloop query="rsErr">
				<tr>
					<td><cfoutput>#rsErr.MsgError#</cfoutput></td>
					<td><cfoutput>#rsErr.Valor#</cfoutput></td>
				</tr>
			</cfloop>				
			</table>
		<cfelse>
			<!--- Si es necesario un asiento de ajuste, lo va a mostrar --->
			<center>
			<strong>El documento puede ser aplicado sin problemas porque no presenta errores.</strong>
			</center>
			<cfif AsientosAjuste>
				<br>
				<font color="red"><p align="justify">
				<strong>Nota:</strong> Para este consecutivo, el sistema le solicitará realizar un asiento de ajuste al aplicarlo, ya que existen
				diferencias entre la oficina del asiento contable y la oficina del activo. Si responde afirmativamente, el asiento se genera de 
				forma automática, al aplicar.</p></font>
			</cfif>
		</cfif>
		</td>
	</tr>	
	<tr>
		<td colspan="2"><hr></td>
	</tr>	
	<cfif (paramMes neq URL.GATmes) or (paramPeriodo neq URL.GATperiodo)>
	<tr>
		<td colspan="2" bgcolor="red" align="center">
			<strong>
			<font color="white">
			ADVETENCIA: Relacion en un periodo-mes diferente al periodo-mes del auxiliar.<br />
			Cuando la relacion se aplique, los activos se adquiren bajo el periodo-mes actual de auxiliares
			</font>
			</strong>
		</td>
	</tr>	
	</cfif>	
	<tr>
		<td colspan="2"><hr></td>
	</tr>	
	<tr>
		<td colspan="2" align="center"><input type="button" name="btnclose" value="-- Cerrar --" onClick="javascript:window.close();"></td>
	</tr>			
	</table>
<cf_web_portlet_end>
