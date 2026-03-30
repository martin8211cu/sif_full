<!---
	Creado por Gustavo Fonseca H.
		Fecha: 9-12-2005.
		Motivo: Permitir imprimir un reporte donde haga constatar que el socio de negocios tiene saldo cero.
--->
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("SNcodigo")>
	<cfset SNcodigo = url.SNcodigo>
</cfif>

<cf_templateheader title="SIF - Cuentas por Cobrar">
		<table width="100%" cellpadding="4">
			<tr><td>
				<cfoutput>
				<form method="get" style="margin:0;" action="analisisSocio.cfm">
				<input type="hidden" name="SNcodigo" value="#url.SNcodigo#" />
				<input type="hidden" name="Ocodigo_F" value="<cfif isdefined('url.Ocodigo_F')>#url.Ocodigo_F#<cfelse>-1</cfif>" />
				<cfset params = ''>
				<cfif isdefined('url.Ocodigo_F')>
					<cfset params = params & '&Ocodigo_F=#url.Ocodigo_F#'>
				</cfif>
				
				<cfif isdefined("url.CatSoc")><input type="hidden" name="CatSoc" value="1" /></cfif>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td align="center"><input class="btnAnterior" type="submit" name="regresar" value="Regresar" /></td></tr>
				</table>
				</form>
				</cfoutput>
			</td></tr>	
			<tr><td><iframe name="reporte" id="reporte"  width="100%" height="600" frameborder="0" src="ImpresionSaldoCliente-reporte.cfm?SNcodigo=<cfoutput>#url.SNcodigo##params#</cfoutput>"></iframe></td></tr>	
		</table>
	<cf_templatefooter>