<cfinclude template="prepagos-params.cfm">

<cfif isdefined('form.TJid') and form.TJid NEQ ''>
	<cfquery name="rsPrepagoConsul" datasource="#session.DSN#">
		Select pp.TJid	
			, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2) as nombreAgente
			, pp.PQcodigo
			, paq.PQnombre
			, pp.TJprecio
			, pp.TJoriginal
			, case TJestado
				when '0' then 'Cerrada'
				when '1' then 'Activa'
				when '2' then 'En Uso'
				when '3' then 'Consumida'
				when '4' then 'Vencida'
				when '5' then 'Bloqueada'
				when '6' then 'Anulada'
			end TJestado
			, convert(varchar,TJuso,103) as TJuso
			, TJvigencia
			, TJdsaldo
		from ISBprepago pp
			inner join ISBpaquete paq
				on paq.PQcodigo=pp.PQcodigo
					and paq.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			left outer join ISBpersona per
				on per.Pquien = pp.AGid
		where TJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TJid#">
	</cfquery>
</cfif>


<form action="prepagos.cfm" method="post" name="form1" id="form1" style="margin:0">
	<cfoutput>
		<input type="hidden" name="Pagina" value="<cfif isdefined('form.Pagina') and form.Pagina NEQ ''>#form.Pagina#</cfif>">	
		<input type="hidden" name="Pquien_F" value="<cfif isdefined('form.Pquien_F') and form.Pquien_F NEQ ''>#form.Pquien_F#</cfif>">
		<input type="hidden" name="TJestado_F" value="<cfif isdefined('form.TJestado_F') and form.TJestado_F NEQ ''>#form.TJestado_F#</cfif>">
		<input type="hidden" name="TJid_F" value="<cfif isdefined('form.TJid_F') and form.TJid_F NEQ ''>#form.TJid_F#</cfif>">

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td width="10%" align="right"><strong>Prepago</strong></td>
			<td width="24%">
				<cf_prepago
					form = "form1"
					sufijo = ""
					Ecodigo = "#Session.Ecodigo#"
					Conexion = "#Session.DSN#"
					id="#form.TJid#"
					readonly="true"
				>
			</td>
			<td width="10%" align="right">&nbsp;</td>
			<td width="18%">&nbsp;</td>
			<td width="11%" align="right">&nbsp;</td>
			<td width="27%">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Paquete:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					#rsPrepagoConsul.PQcodigo# - #rsPrepagoConsul.PQnombre#
				</cfif>
			</td>
			<td align="right"><strong>Estado:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					#rsPrepagoConsul.TJestado#
				</cfif>			
			</td>
			<td align="right"><strong>Agente:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif len(trim(rsPrepagoConsul.nombreAgente))>
						#rsPrepagoConsul.nombreAgente#
					<cfelse>
						No Definido
					</cfif>
				</cfif>				
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Precio:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif rsPrepagoConsul.TJprecio NEQ '' and rsPrepagoConsul.TJprecio GT 0>
						#LSCurrencyFormat(rsPrepagoConsul.TJprecio, 'none')#
				  	<cfelse>
						0.00
					</cfif>						
				</cfif>					
			</td>
			<td align="right" nowrap><strong>Fecha 1er Uso:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif len(trim(rsPrepagoConsul.TJuso))>
						#rsPrepagoConsul.TJuso#
					<cfelse>
						Sin Definir
					</cfif>
				</cfif>					
			</td>
			<td align="right" nowrap><strong>Vigencia (d&iacute;as):</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif len(trim(rsPrepagoConsul.TJvigencia))>
						#rsPrepagoConsul.TJvigencia#
					<cfelse>
						Sin Definir
					</cfif>				
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Total:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif rsPrepagoConsul.TJoriginal NEQ '' and rsPrepagoConsul.TJoriginal GT 0>
						#LSCurrencyFormat(rsPrepagoConsul.TJoriginal, 'none')#
				  	<cfelse>
						0.00
					</cfif>							
				</cfif>			
			</td>
			<td align="right"><strong>Disponible:</strong></td>
			<td>
				<cfif isdefined('rsPrepagoConsul') and rsPrepagoConsul.recordCount GT 0>
					<cfif rsPrepagoConsul.TJdsaldo NEQ '' and rsPrepagoConsul.TJdsaldo GT 0>
						#LSCurrencyFormat(rsPrepagoConsul.TJdsaldo, 'none')#						
					<cfelse>
						0.00
					</cfif>					
				</cfif>				
			</td>
			<td align="right">&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
		  	<td colspan="6">&nbsp;</td>
		  </tr>
		  <tr>
		  	<td align="center" colspan="6">
				<input name="btnRegresar" type="button" value="Regresar" onClick="javascript: regresar(); "tabindex="1">
			</td>
		  </tr>
		  <tr>
		  	<td colspan="6">&nbsp;</td>
		  </tr>
		</table>	
	</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	<cfoutput>
		function regresar(){
			var params = "";
			
			params = params + "&Pagina=" + document.form1.Pagina.value +
							"&Pquien_F=" + document.form1.Pquien_F.value +
							 "&TJestado_F=" + document.form1.TJestado_F.value +
							 "&TJid_F=" + document.form1.TJid_F.value +
							 "&btnFiltrar=btnFiltrar";
			
			location.href = "prepagos.cfm?1=1" + params;
		}
	</cfoutput>
</script>
