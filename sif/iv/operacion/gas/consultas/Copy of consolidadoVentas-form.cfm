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
<form name="form_fSalidas" method="post" action="" onSubmit="javascript: return valida(this);">
  <table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		  <td width="10%" align="right">
			<strong>Estaci&oacute;n</strong>:</td>
		  <td width="35%">
		  	<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo" id="#form.f_Ocodigo#">
			<cfelse>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo">
			</cfif>
		  </td>
		  <td width="17%" rowspan="2" align="center" valign="middle">
		  	<input type="submit" align="middle" name="btnConsultar" value="Consultar">			
		  </td>
	</tr>
		<tr>
		  <td align="right"><strong>Fecha</strong>:</td>
		  <td>
			<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))>
				<cf_sifcalendario form="form_fSalidas" name="SPfecha" value="#form.SPfecha#">
			<cfelse>
				<cf_sifcalendario form="form_fSalidas" name="SPfecha">
			</cfif>			  
		  </td>
	  </tr>
		<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
		  <tr>
			  <td colspan="3">&nbsp;</td>
		  </tr>
		  <tr>
			  <td colspan="3"><hr></td>
		  </tr>
		</cfif>
  </table>
</form>
<cfset parametros = "">
<cfif isdefined('form.btnConsultar')>
	<cfif isdefined("form.f_Ocodigo") and len(trim(form.f_Ocodigo))>
		<cfset parametros = parametros & "&f_Ocodigo=" & form.f_Ocodigo >
	</cfif>				
	<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))>
		<cfset parametros = parametros & "&SPfecha=" & form.SPfecha >
	</cfif>

	<table width="100%" border="0">
	  <tr>
		<td>
			<cf_rhimprime datos="/sif/iv/operacion/gas/repConsolidado.cfm" paramsuri="#parametros#"> 		
		</td>
	  </tr>
	  <tr><td><hr></td></tr>	  
	  <tr>
		<td>
			<cfinclude template="repConsolidado.cfm">		
		</td>
	  </tr>
	</table>
</cfif>


