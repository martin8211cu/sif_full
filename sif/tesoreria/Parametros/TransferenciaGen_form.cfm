<cfquery name="rsForm" datasource="#session.dsn#">
	select TESTGdescripcion, TESTGcodigoTipo, TESTGtipoCtas, TESTGtipoConfirma, TESTGactivo
			, TESTGbancaria
	  from TEStransferenciaG
	 where TESTGid = #form.TESTGid#
</cfquery>
<cfoutput>	
<table border="0">
	<tr>
		<td align="center" colspan="4"><strong>#rsForm.TESTGdescripcion#</strong></td>
	</tr>
	<tr>
		<td colspan="2"><strong>Tipo de Cuentas Destino:</strong>&nbsp;</td>
		<cfif rsForm.TESTGcodigoTipo EQ 0>
			<td colspan="2" align="center">Cuentas Nacionales</td>
		<cfelseif rsForm.TESTGcodigoTipo EQ 1>
			<td colspan="2">Cuentas ABA</td>
		<cfelseif rsForm.TESTGcodigoTipo EQ 2>
			<td colspan="2">Cuentas SWIFT</td>
		<cfelseif rsForm.TESTGcodigoTipo EQ 3>
			<td colspan="2">Cuentas IBAN</td>
		<cfelse>
			<td colspan="2">Cuentas Especiales</td>
		</cfif>
	</tr>
	<cfif rsForm.TESTGcodigoTipo EQ 0>
		<tr>
			<td></td>
			<td></td>
			<td align="center">Propias</td>
			<td align="center">&nbsp;&nbsp;Interbancarias</td>
		</tr>
		<tr>
			<td colspan="2" nowrap align="right">Del mismo Banco de Pago:&nbsp;</td>
			<cfif listFind("0,1,4",rsForm.TESTGtipoCtas)>
				<td align="center">SI</td>
			<cfelse>
				<td align="center">NO</td>
			</cfif>
			<cfif listFind("0,3",rsForm.TESTGtipoCtas)>
				<td align="center">SI</td>
			<cfelse>
				<td align="center">NO</td>
			</cfif>
		</tr>
		<tr>
			<td colspan="2" nowrap align="right">De otro Banco al de Pago:&nbsp;</td>
			<td align="center">NO</td>
			<cfif listFind("0,2,3,4	",rsForm.TESTGtipoCtas)>
				<td align="center">SI</td>
			<cfelse>
				<td align="center">NO</td>
			</cfif>
		</tr>
	</cfif>
	<tr>
		<td colspan="2" nowrap><strong>Tipo Confirmación en Pagos:</strong>&nbsp;</td>
		<cfif rsForm.TESTGtipoConfirma EQ 1>
			<td colspan="2" >Una sóla confirmación por Lote de TRE</td>
		<cfelseif rsForm.TESTGtipoConfirma EQ 2>
			<td colspan="2" >Una confirmación por Orden Pago en el Lote</td>
		</cfif>
	</tr>
	<tr>
		<td colspan="4" nowrap><strong>Genera TRE Bancarias entre cuentas:</strong>&nbsp;&nbsp;&nbsp;
		<cfif rsForm.TESTGbancaria EQ 1>
			SI
		<cfelse>
			NO
		</cfif>
		</td>
	</tr>
</table>
</cfoutput>	

<cfquery name="rsParms" datasource="#session.dsn#">
	select TESTGdato, TESTGvalor, TESTGtipo
	  from TEStransferenciaG2
	 where TESTGid = #form.TESTGid#
	   and Ecodigo = #session.Ecodigo#
	 order by TESTGtipo, TESTGsec
</cfquery>
<cfif rsForm.TESTGactivo EQ "0">
<br>
&nbsp;<strong>TIPO DE GENERACION INACTIVO</strong>
<cfelseif rsParms.recordCount GT 0>
<form method="post" action="TransferenciaGen.cfm">
<cfoutput>
<input type="hidden" name="TESTGid" value="#form.TESTGid#">
</cfoutput>
<table border="0">
	<tr>
		<td colspan="4"><strong>PARAMETROS DE GENERACION:</strong>&nbsp;</td>
	</tr>

	<cfoutput query="rsParms" group="TESTGtipo">
		<tr>
			<td colspan="4"><strong>
			<cfif TESTGtipo EQ "L">
				&nbsp;&nbsp;POR LOTE DE PAGOS:
			<cfelse>
				&nbsp;&nbsp;GENERALES
			</cfif>
				</strong>&nbsp;</td>
		</tr>
		<cfoutput>
			<tr>
				<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;#TESTGdato#:&nbsp;</td>
				<td colspan="3"><input name="#TESTGdato#"  value="#TESTGvalor#" size="40"></td>
			</tr>
		</cfoutput>
	</cfoutput>
	<tr>
		<td align="center" colspan="4"><input type="submit" name="OP"  value="Modificar"></td>
	</tr>
</table>
</form>
</cfif>
