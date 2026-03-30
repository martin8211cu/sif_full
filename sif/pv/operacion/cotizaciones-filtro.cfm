<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfif isdefined("url.Bid") and not isdefined("form.Bid") >
	<cfset form.Bid = url.Bid >
</cfif>
<cfif isdefined("url.FAM18DES") and not isdefined("form.FAM18DES") >
	<cfset form.FAM18DES = url.FAM18DES >
</cfif>


<cfoutput>
<form style="margin: 0" action="cotizaciones.cfm" name="fFiltroCoti" method="post">
<input type="hidden" name="tipoCoti" value="#form.tipoCoti#">	
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td width="118" align="right" nowrap><strong>Num. Cotizaci&oacute;n:</strong></td>
		<td width="90" align="left">
			<input name="NumeroCot_F" type="text" id="NumeroCot_F" <cfif isdefined('form.NumeroCot_F')> value="#form.NumeroCot_F#"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,-1);"  onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
		</td>
		<td width="79" align="right"><strong>Cliente:</strong></td>
		<td width="180" align="left">
			<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F))>
				<cf_sifClienteDetCorp CDCcodigo="CDCcodigo_F" form='fFiltroCoti' idquery="#form.CDCcodigo_F#">
			<cfelse>
				<cf_sifClienteDetCorp CDCcodigo="CDCcodigo_F" form='fFiltroCoti' >
			</cfif>				
		</td>
		<td width="55" align="right"><strong>Estatus:</strong></td>
		<td width="99">
			<select name="Estatus_F">
				<option value="-1" <cfif isdefined('form.Estatus_F') and form.Estatus_F EQ '-1'> selected</cfif>>-- Todas --</option>
				<option value="0" <cfif isdefined('form.Estatus_F') and form.Estatus_F EQ '0'> selected</cfif>>Digitada</option>
				<option value="1" <cfif isdefined('form.Estatus_F') and form.Estatus_F EQ '1'> selected</cfif>>Terminada</option>
				<option value="2" <cfif isdefined('form.Estatus_F') and form.Estatus_F EQ '2'> selected</cfif>>Anulada</option>
			</select>	
		</td>	
		<td width="16"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
    </tr>
 </table>
</form>
</cfoutput>
