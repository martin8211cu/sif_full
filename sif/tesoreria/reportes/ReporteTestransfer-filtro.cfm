	<form name="formFiltro" method="post" onsubmit="function validar()" action="ReporteTestransfer-form.cfm" style="margin: '0' ">
		<table width="100%"  border="0" cellpadding="1" cellspacing="1">
			<tr><td>&nbsp;</td></tr>
			  <tr>
				<td nowrap align="right">
					<strong>Trabajar con Tesorería:</strong>&nbsp;
				</td>
				<td>
					<cf_cboTESid onchange="this.form.submit();" tabindex="1">
				</td>
			  </tr>	
			  <tr>
				    <td align="right" nowrap><strong>Cuenta Bancaria de Pago:</strong></td>
					<td nowrap valign="middle">
						<cf_cboTESCBid Dcompleja="true" Dcompuesto="yes" cboTESMPcodigo="TESMPcodigo" tabindex="1">
					</td>	
					<td>&nbsp;</td>						
			 </tr>
             <tr>
			   <td align="right" nowrap><strong>Fecha Desde:</strong></td>
			     <td><cf_sifcalendario form="formFiltro" value="" name="TESOTransf_FI" tabindex="1"></td>
			</tr>			
			<tr>
			      <td align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
			      <td><cf_sifcalendario form="formFiltro" value="" name="TESOTransf_FF" tabindex="1"></td>  					  
			 </tr>			 
			  <tr>
				<td align="right" nowrap><strong>Num.Lote:</strong></td>
				<td>
				    <cf_inputNumber name="LoteNum"  enteros="6" decimales="0" negativos="false" comas="no">
			<!---	<input name="LoteNum" type="text" tabindex="1" size="22">--->
				</td>							
			  </tr>
			  <tr>		 
			 <tr>
				 <td colspan="2">&nbsp;</td>			      
			  </tr>
			  <td align="center" colspan="4"><cf_botones values="Consultar,Limpiar" tabindex="1"></td>
			  </tr>
			</table>	
</form>