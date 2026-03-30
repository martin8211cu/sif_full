<cfif dmodo neq 'ALTA'>
	<cfquery name="rsDForm" datasource="#session.DSN#">
		select a.CRMEDid as CRMEDid, a.CRMDDid as CRMDDid, a.CRMDDdescripcion,a.CRMEid as CRMEid, CRMDDtipopago, a.CRMDmonto as CRMDmonto, CRMEnombre, coalesce(CRMEapellido1,'') as CRMEapellido1, coalesce(CRMEapellido2,'') as CRMEapellido2, a.ts_rversion 
		from CRMDDonacion a
			inner join CRMEntidad b
				on a.CRMEid=b.CRMEid
		where a.Ecodigo= #session.Ecodigo#
		and a.CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
		and a.CRMDDid =  <cfqueryparam value="#form.CRMDDid#"     cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfoutput>
<table width="80%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td align="right" width="15%">Descripci&oacute;n:&nbsp;</td>
		<td width="25%"><input name="CRMDDdescripcion" size="60" maxlength="255" value="<cfif dmodo neq 'ALTA'>#rsDForm.CRMDDdescripcion#</cfif>" onfocus="javascript:this.select();"></td>
		<td align="right" width="15%">Donante:&nbsp;</td>
		<td width="25%">
			<cfif dmodo neq 'ALTA'>
				<cf_crmEntidad conexion="crm" query="#rsDForm#" size="60" CRMEid="CRMEid2" CRMnombre="CRMnombre2">
			<cfelse>
				<cf_crmEntidad conexion="crm" size="60" CRMEid="CRMEid2" CRMnombre="CRMnombre2">
			</cfif>
		</td>
	</tr>			
	<tr>
		<td align="right">TipoPago:&nbsp;</td>
		<td>
			<select name="CRMDDtipopago">
				<option value="C" <cfif dmodo neq 'ALTA' and rsDForm.CRMDDtipopago eq 'C' >selected</cfif> >Cheque</option>
				<option value="D" <cfif dmodo neq 'ALTA' and rsDForm.CRMDDtipopago eq 'D' >selected</cfif> >Dep&oacute;sito</option>
				<option value="E" <cfif dmodo neq 'ALTA' and rsDForm.CRMDDtipopago eq 'E' >selected</cfif> >Efectivo</option>
				<option value="T" <cfif dmodo neq 'ALTA' and rsDForm.CRMDDtipopago eq 'T' >selected</cfif> >Tarjeta</option>
			</select>
		</td>
		<td align="right">Monto:&nbsp;</td>
		<td><input type="text" name="CRMDmonto" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsDForm.CRMDmonto,'none')#</cfoutput><cfelse>0.00</cfif>"  size="15" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Monto" ></td>
	</tr>
</table>
</cfoutput>