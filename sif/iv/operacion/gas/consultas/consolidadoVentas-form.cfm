<script language="javascript" type="text/javascript">
	function valida(f){
		if(f.f_Ocodigo.value == ''){
			alert('Error, primero debe seleccionar una estación');		
			
			return false;
		}
		if(f.SPfecha.value == ''){
			alert('Error, la fecha es requerida');
			f.SPfecha.focus();
			return false;
		}		
		return true;
	}
</script>

<cf_templatecss>
<form name="form_fSalidas" method="post" action="consolidadoVentas-SQL.cfm" onSubmit="javascript: return valida(this);">
  <table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		  <td width="11%" align="right">
			<strong>Estaci&oacute;n</strong>:</td>
		  <td width="24%">
		  	<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo" id="#form.f_Ocodigo#">
			<cfelse>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo">
			</cfif>		  </td>
		  <td colspan="2" rowspan="3" align="center" valign="middle">
			<table width="50%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<fieldset><legend><strong>Datos Posteados</strong></legend>
						<table width="74%" align="center" border="0">
						  <tr>
						    <td nowrap="nowrap"><label>
							  <input name="rdPosteada" type="radio" value="0" <cfif isdefined("form.rdPosteada") and len(trim(form.rdPosteada)) and form.rdPosteada EQ 0> checked="checked"<cfelse> checked="checked"</cfif>/>
							NO</label></td>
							<td nowrap="nowrap"><label>
							  <input name="rdPosteada" type="radio" value="1" <cfif isdefined("form.rdPosteada") and len(trim(form.rdPosteada)) and form.rdPosteada EQ 1> checked="checked"</cfif>/>
							SI</label></td>
						  </tr>
						</table>
					</fieldset>					
				</td>
			  </tr>
			</table>
		  </td>
		  <td width="20%" rowspan="2" align="center" valign="middle">
		  	<input type="submit" align="middle" name="btnConsultar" value="Consultar">		  </td>
	</tr>
		<tr>
		  <td align="right"><strong>Fecha</strong>:</td>
		  <td>
			<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))>
				<cf_sifcalendario form="form_fSalidas" name="SPfecha" value="#form.SPfecha#">
			<cfelse>
				<cf_sifcalendario form="form_fSalidas" name="SPfecha">
			</cfif>		  </td>
      </tr>
		<tr>
		  <td align="right"><strong>Formato</strong></td>
		  <td><select name="formato">
            <option value="FlashPaper">FlashPaper</option>
            <option value="pdf">Adobe PDF</option>
            <option value="Excel">Microsoft Excel</option>
          </select></td>
		  <td>&nbsp;</td>
	  </tr>	  
	  
		<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
		  <tr>
			  <td colspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			  <td colspan="5"><hr></td>
		  </tr>
		</cfif>
  </table>
</form>