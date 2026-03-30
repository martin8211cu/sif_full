<cfoutput>
<form style="margin: 0" action="sec_doc_imp.cfm" name="formSec" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
   		<tr>
   			<td width="91%">
				<fieldset><legend><strong>Impresora</strong></legend>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20%" align="right"><strong>C&oacute;digo:</strong></td>
						<td width="5%">
					
							<input type="text" name="FAM12CODD_F" style="text-align:right" size="8" maxlength="8"  
								onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
								onFocus="javascript:this.select();" 
								value="<cfif isdefined('form.FAM12CODD_F')>#form.FAM12CODD_F#</cfif>">
						</td>
						<td width="19%" align="right"><strong>Descripci&oacute;n:</strong></td>
						<td width="56%">
							<input type="text" size="35" maxlength="50" name="FAM12DES_F" value="<cfif isdefined('form.FAM12DES_F') and form.FAM12DES_F NEQ ''>#form.FAM12DES_F#</cfif>">
						</td>
					  </tr>
					</table>
				</fieldset>			
			</td>
			<td width="9%" align="center" valign="middle"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
		</tr>		
	</table>
</form>
</cfoutput>