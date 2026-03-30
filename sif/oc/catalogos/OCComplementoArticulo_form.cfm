<cfset modo = 'ALTA'>
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfquery datasource="#session.dsn#" name="rsArticulos">
		select Acodigo, Adescripcion
		from Articulos  
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		and Aid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#"> 
	</cfquery>
	
	<cfif isdefined("form.TieneComplemento") and len(trim(form.TieneComplemento)) and form.TieneComplemento eq 'S'>
		<cfset modo = 'CAMBIO'>
		<cfquery datasource="#session.dsn#" name="rsdatos">
			select CFcomplementoTransito ,CFcomplementoCostoVenta,CFcomplementoIngreso
			from OCcomplementoArticulo  
			where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#"> 
		</cfquery>
	</cfif>
</cfif>
	
<cfoutput>
<form name="form1" id="form1" method="post" action="OCComplementoArticulo_sql.cfm">
	<table  width="100%" summary="Tabla de entrada"  cellpadding="2">
		<tr>
			<td colspan="4" class="subTitulo">
				Complemento Art&iacute;culos
			</td>
		</tr>
		<tr>
			<td width="20%" valign="top" align="right">
				<strong>Art&iacute;culo</strong>			
			</td>
			<td width="80%" valign="top">
				#rsArticulos.Adescripcion#
		  </td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>C&oacute;digo</strong>
			</td>
			<td valign="top">
				#rsArticulos.Acodigo#
			</td>
		</tr>	
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Tr&aacute;nsito&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoTransito" type="text" onchange="javascript:sugerir(this.value)" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoTransito#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>
		</tr>			
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Costo de Ventas&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoCostoVenta" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoCostoVenta#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>	
		</tr>	
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Complemento Financiero&nbsp;<BR>para Máscara de Ingreso&nbsp;</strong>
			</td>
			<td valign="top">
				<input name="CFcomplementoIngreso" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoIngreso#</cfif>" size="20" maxlength="100"  onfocus="this.select();">
			</td>	
		</tr>		
		<tr>		
			<td colspan="4" class="formButtons">
			<cfif modo  EQ "ALTA">
				<cf_botones values="Agrega,Limpiar" names="Alta,Limpiar"  regresar='OCComplementoArticulo.cfm' tabindex="1">

			<cfelse>
				<cf_botones values="Cambio" names="Cambio" regresar='OCComplementoArticulo.cfm'  tabindex="1">

			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Aid"              value="#HTMLEditFormat(form.Aid)#">
	<input type="hidden" name="TieneComplemento"  value="#HTMLEditFormat(form.TieneComplemento)#">
</form>
<!--- *******************************************************************************--->

<cf_qforms form="form1" objForm="LobjQForm">
	<cf_qformsRequiredField args="Aid, Socio de Negocios">
	<cf_qformsRequiredField args="CFcomplementoTransito, Complemento Transito">
	<cf_qformsRequiredField args="CFcomplementoCostoVenta,Complemento venta ">
	<cf_qformsRequiredField args="CFcomplementoIngreso,Complemento Ingreso ">
</cf_qforms> 
</cfoutput>
<script type="text/javascript">
	document.form1.CFcomplementoTransito.focus();
	function sugerir(valor){
			if (document.form1.CFcomplementoCostoVenta.value == "") document.form1.CFcomplementoCostoVenta.value = valor;
			if (document.form1.CFcomplementoIngreso.value == "") document.form1.CFcomplementoIngreso.value = valor;
	} 
</script>

