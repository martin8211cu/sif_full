<cfset modo = 'ALTA'>

<cfif isdefined("form.SNid") and len(trim(form.SNid))>
	<cfquery datasource="#session.dsn#" name="rsSocio">
		select SNidentificacion,SNnombre,SNnumero, cuentac
		from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		and SNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#"> 
	</cfquery>

	<cfif isdefined("form.TieneComplemento") and len(trim(form.TieneComplemento)) and form.TieneComplemento eq 'S'>
		<cfset modo = 'CAMBIO'>
		<cfquery datasource="#session.dsn#" name="rsdatos">
			select CFcomplementoTransito ,CFcomplementoCostoVenta,CFcomplementoIngreso
			from OCcomplementoSNegocio  
			where  SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#"> 
		</cfquery>
	</cfif>
</cfif>
	
<cfoutput>
<form name="form1" id="form1" method="post" action="OCComplementoSocio_sql.cfm">
	<table  width="100%" summary="Tabla de entrada"  cellpadding="2">
		<tr>
			<td colspan="4" class="subTitulo">
				Complemento Socio de Negocios
			</td>
		</tr>
		<tr>
			<td width="20%" valign="top" align="right">
				<strong>Socio</strong>			
			</td>
			<td width="80%" valign="top">
				#rsSocio.SNnombre#
		  </td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>Identificaci&oacute;n</strong>
			</td>
			<td valign="top">
				#rsSocio.SNidentificacion#
			</td>
		</tr>		
		<tr>
			<td valign="top" align="right">
				<strong>N&uacute;mero</strong>
			</td>
			<td valign="top">
				#rsSocio.SNnumero#
			</td>
		</tr>		
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Tr&aacute;nsito&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoTransito" type="text"  onchange="javascript:sugerir(this.value)" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoTransito#<cfelse>#trim(rsSocio.cuentac)#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Costo de Ventas&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoCostoVenta" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoCostoVenta#<cfelse>#trim(rsSocio.cuentac)#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>	
		</tr>	
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Ingreso&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoIngreso" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoIngreso#<cfelse>#trim(rsSocio.cuentac)#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>	
		</tr>
		<tr>		
			<td colspan="4" class="formButtons">
			<cfif modo  EQ "ALTA">
				<cf_botones values="Agrega,Limpiar" names="Alta,Limpiar"  regresar='OCComplementoSocio.cfm' tabindex="1">

			<cfelse>
				<cf_botones values="Cambio" names="Cambio" regresar='OCComplementoSocio.cfm'  tabindex="1">

			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="SNid"              value="#HTMLEditFormat(form.SNid)#">
	<input type="hidden" name="TieneComplemento"  value="#HTMLEditFormat(form.TieneComplemento)#">
</form>
<!--- *******************************************************************************--->

<cf_qforms form="form1" objForm="LobjQForm">
	<cf_qformsRequiredField args="SNid, Socio de Negocios">
	<cf_qformsRequiredField args="CFcomplementoTransito, Complemento Transito">
	<cf_qformsRequiredField args="CFcomplementoCostoVenta,Complemento venta ">
	<cf_qformsRequiredField args="CFcomplementoIngreso,Complemento Ingreso ">
</cf_qforms> 
</cfoutput>
<script type="text/javascript">
	document.form1.CFcomplementoTransito.focus();

 	function sugerir(valor){
			document.form1.CFcomplementoCostoVenta.value = valor;
			document.form1.CFcomplementoIngreso.value = valor;
	} 
</script>

