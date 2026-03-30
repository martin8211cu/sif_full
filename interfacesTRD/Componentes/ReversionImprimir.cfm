<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>

<cfquery name="rsReversion" datasource="sifinterfaces">
	select distinct a.Modulo, a.Documento, a.CodigoTransaccion, b.SNcodigoext, a.Producto, a.TipoReversa 
	from DocumentoReversion a 
			inner join #minisifdb#..SNegocios b
			on a.SNcodigo = b.SNcodigo and a.Ecodigo = b.Ecodigo					
	where a.Ecodigo = #session.Ecodigo#
	and a.Procesado = 'N'
	order by a.Modulo,a.Documento,a.CodigoTransaccion, b.SNcodigoext
</cfquery>

<cfif isdefined("rsReversion") and rsReversion.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Reversión Documentos NoFACT de Producto" 
			filename="Reversion NoFact Producto-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/Componentes/#url.Regresa#">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"PMI"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Reversión NoFact de Productos</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Módulo</strong></td>
						<td nowrap><strong>Documento</strong></td>
						<td nowrap align="left"><strong>Tipo Trans.</strong></td>
						<td nowrap align="left"><strong>Socio</strong></td>
						<td nowrap align="left"><strong>Producto</strong></td>
						<td nowrap align="left"><strong>Tipo Reversion</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsReversion">
						<tr>
							<td nowrap >#rsReversion.Modulo#</td>
							<td nowrap >#rsReversion.Documento#</td>
							<td nowrap >#rsReversion.CodigoTransaccion#</td>
							<td nowrap >#rsReversion.SNcodigoext#</td>
							<td nowrap >#rsReversion.Producto#</td>
							<td nowrap >#rsReversion.TipoReversa#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


