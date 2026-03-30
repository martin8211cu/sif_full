<cfquery name="rsMonedas" datasource="asp">
	select Mcodigo, Mnombre from Moneda
</cfquery>

<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsdataDetalle" datasource="sifpublica">
		select DLPlinea, ELPid, DLPcodigo, DLPdescripcion, 
			DLPdescalterna, DLPobservaciones, DLPcodbarras, 
			DLPgarantia, DLPplazoentrega,  DLPplazocredito, 
			DLPprecio, DLPunidad, DLPclase, Mcodigo, 
			DLPporcimpuesto, ts_rversion
		from DListaPrecios
		where DLPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLPlinea#" >
			and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#" >
	</cfquery>


</cfif>


<cfoutput>
<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center" >
	<tr>
		<td align="right" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
		<td><input type="text" name="DLPcodigo" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPcodigo#</cfif>" size="25" maxlength="25"></td>
		<td align="right" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
		<td><input type="text" name="DLPdescripcion" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPdescripcion#</cfif>" size="60" maxlength="255"></td>
		<td colspan="2" nowrap>
			<table width="30%">
				<tr>
					<td nowrap>
						<strong>
							<a href="javascript:infoDet();" title="<cfif modoD eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Descripci&oacute;n Alterna, Observaciones)">
							<cfif modoD eq 'ALTA'>Definir&nbsp;<cfelse>Ver/Modificar&nbsp;</cfif>informaci&oacute;n adicional</a>
						</strong>&nbsp;
					</td>
					<td>
						<a href="javascript:infoDet();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modoD eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Descripci&oacute;n Alterna, Observaciones)"></a>
					</td>
				</tr>
				<input name="DLPdescalterna" type="hidden" value="<cfif modoD NEQ "ALTA">#rsdataDetalle.DLPdescalterna#</cfif>" >
				<input name="DLPobservaciones" type="hidden" value="<cfif modoD NEQ "ALTA">#rsdataDetalle.DLPobservaciones#</cfif>" >
			</table>
		</td>
	</tr>

	<tr>
		<td align="right" nowrap><strong>Garant&iacute;a:</strong>&nbsp;</td>
		<td nowrap>
			<input type="text" name="DLPgarantia" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPgarantia#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onSubmit="javascript:valida();"> 
			<strong>d&iacute;as </strong>
		</td>
		<td align="right" nowrap><strong>Plazo Entrega:</strong>&nbsp;</td>
		<td nowrap>
			<input type="text" name="DLPplazoentrega" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPplazoentrega#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
			<strong>d&iacute;as </strong>
		</td>
		<td align="right" nowrap><strong>Plazo Cr&eacute;dito:</strong>&nbsp;</td>
		<td nowrap>
			<input type="text" name="DLPplazocredito" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPplazocredito#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
			<strong>d&iacute;as </strong>
		</td>
	</tr>
	
	<tr>
		<td align="right" nowrap><strong>Precio:</strong>&nbsp;</td>
		<td nowrap>
			<input type="text" name="DLPprecio" value="<cfif modoD neq 'ALTA'>#LSCurrencyFormat(rsdataDetalle.DLPprecio,'none')#<cfelse>0.00</cfif>" size="8" maxlength="8" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
			<select name="Mcodigo">
				<cfloop query="rsMonedas">
					<option value="#Mcodigo#" <cfif modoD NEQ 'ALTA' AND Mcodigo EQ rsdataDetalle.Mcodigo>selected</cfif> >#Mnombre#</option>
				</cfloop>
			</select>
		</td>
		<td align="right" nowrap><strong>Unidad:</strong>&nbsp;</td>
		<td nowrap>
			<input type="text" name="DLPunidad" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPunidad#</cfif>" size="15" maxlength="15" > 
		</td>
		<td align="right" nowrap id="td1"><strong>Porcentaje Impuesto:</strong>&nbsp;</td>
		<td nowrap id="td2">
			<input type="text" name="DLPporcimpuesto" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPporcimpuesto#<cfelse>0.00</cfif>" size="8" maxlength="8" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
		</td>
	</tr>

	<tr>
		<td align="right" nowrap><strong>Clase:</strong>&nbsp;</td>
		<td colspan="2" nowrap>
			<input type="text" name="DLPclase" value="<cfif modoD neq 'ALTA'>#rsdataDetalle.DLPclase#</cfif>" size="60" maxlength="60" > 
		</td>
		<td>
			<table width="30%">
				<tr>
					<td nowrap>
						<strong>
							<a href="javascript:infoBarras();" title="<cfif modoD eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informaci&oacute;n del c&oacute;digo de Barras (C&oacute;digo de Barras)">
							<cfif modoD eq 'ALTA'>Definir&nbsp;<cfelse>Ver/Modificar&nbsp;</cfif>
							informaci&oacute;n del c&oacute;digo de Barras </a>
						</strong>&nbsp;
					</td>
					<td>
						<a href="javascript:infoBarras();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modoD eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informaci&oacute;n del c&oacute;digo de Barras (C&oacute;digo de Barras)"></a>
					</td>
				</tr>
				<input name="DLPcodbarras" type="hidden" value="<cfif modoD NEQ "ALTA">#rsdataDetalle.DLPcodbarras#</cfif>" >
			</table>
		</td>
		<td colspan="2" nowrap align="center">&nbsp;</td>
	</tr>
	
	<tr><td colspan="6" nowrap>&nbsp;</td></tr>

	<cfif modoD neq "ALTA">
		<cfset dts = "">	
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataDetalle.ts_rversion#" returnvariable="dts">
		</cfinvoke>
		<input type="hidden" name="dts_timestamp" value="#dts#">
		<input type="hidden" name="DLPlinea" value="#form.DLPlinea#">
	</cfif>

</table>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function infoDet(){
		open('ListaPreciosDet-info.cfm', 'ListaPrecios', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}

	function infoBarras(){
		open('ListaPreciosDet-barras.cfm', 'ListaPrecios', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=140,left=250, top=350,screenX=250,screenY=200');
	}

	function valida(){
		document.form1.DLPprecio.value = qf(document.form1.DLPprecio.value);
	}
	
</script>
