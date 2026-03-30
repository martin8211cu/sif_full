<cfquery name="rsMotor" datasource="sifinterfaces">
	select spFinal
	  from InterfazMotor
	 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery name="rsQuery" datasource="sifinterfaces">
	select NumeroInterfaz, Descripcion, OrigenInterfaz, TipoProcesamiento,
		Componente, Activa, MinutosRetardo, FechaActivacion, FechaActividad, 
		NumeroEjecuciones, Ejecutando
		, case Activa when 1 then 'Activa' else 'Inactiva' end as ActivaDescripcion
		, case OrigenInterfaz when 'S' then 'SOIN' else '#Ucase(Request.CEnombre)#' end as OrigenInterfazDescripcion
		, case TipoProcesamiento when 'S' then 'Sincrónico' else 'Asincrónico' end as TipoProcesamientoDescripcion
		, ejecutarSpFinal
	from Interfaz
	where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#">
</cfquery>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form action="parametros.cfm" method="post" name="frmParams">
<cfoutput query="rsQuery">
	<input id="NumeroInterfaz" name="NumeroInterfaz" type="hidden" value="#NumeroInterfaz#" />
	<table width="100%" border="0" cellpadding="2" cellspacing="2">
	<tr>
	<td valign="middle" align="right" nowrap>
	<strong>N&uacute;mero Interfaz:&nbsp;&nbsp;</strong>
	</td><td valign="middle" align="left" nowrap>
	<strong>#NumeroInterfaz#</strong>
	</td>
	</tr>
	<tr>
	<td valign="middle" align="right" nowrap>
	<strong>Descripci&oacute;n:&nbsp;&nbsp;</strong>
	</td><td valign="middle" align="left">
	<strong>#Descripcion#</strong>
	</td>
	</tr>
	<tr>
	<td valign="middle" align="right" nowrap>
	<strong>Origen Interfaz:&nbsp;&nbsp;</strong>
	</td><td valign="middle" align="left">
	<strong>#OrigenInterfazDescripcion#</strong>
	</td>
	</tr>
	<tr>
	<td valign="middle" align="right" nowrap>
	<strong>Tipo Procesamiento:&nbsp;&nbsp;</strong>
	</td><td valign="middle" align="left" nowrap>
	<strong>#TipoProcesamientoDescripcion#</strong>
	</td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	<td valign="middle" align="left" nowrap>
	<input id="Activa" name="Activa" 
		type="checkbox" 
		label="Activa"
		<cfif Activa>checked</cfif>
		value="#Activa#" />	
	<label for="MinutosRetardo" title="Minutos Retardo"><strong>Activa</strong></label>	 
	</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="MinutosRetardo" title="Minutos Retardo"><strong>Minutos Retardo:&nbsp;&nbsp;</strong></label>
		</td>
		<td valign="middle" align="left" nowrap>
			<input id="MinutosRetardo" name="MinutosRetardo" 
				size="10" maxlength="10" type="text" 
				label="Minutos Retardo"
				onKeyPress="return acceptNum(event)"
				<cfif TipoProcesamiento EQ 'S'>readonly tabindex="999"</cfif>
				value="#MinutosRetardo#" />		 
		</td>
	</tr>
	<cfif trim(rsMotor.spFinal) NEQ "">
	<tr>
		<td valign="middle" align="right" nowrap>&nbsp;
			
		</td>
		<td valign="middle" align="left" nowrap>
			<input type="checkbox" id="ejecutarSpFinal" name="ejecutarSpFinal"
				<cfif ejecutarSpFinal EQ "S">checked</cfif>
			/>		 <strong>Ejecutar spFinal</strong>
		</td>
	</tr>
	</cfif>
	<tr>
	<td valign="middle" align="right" nowrap>
	<label for="Componente" title="Componente"><strong>Componente:&nbsp;&nbsp;</strong></label>
	</td><td valign="middle" align="left" nowrap>
	<input id="Componente" name="Componente" 
		size="40" maxlength="80" type="text" 
		label="Componente"
		value="#Componente#" />		
	</td>
	</tr>
	<tr>
	<td valign="middle" align="center" nowrap colspan="2">
		<input id="doit" name="doit" 
			value="Actualizar" type="submit" />			
		<input id="cmdEstructura" name="cmdEstructura" 
			value="Estructura Tablas" type="submit" />			
		<input id="Limpiar" title="Limpiar" name="Limpiar" 
			value="Limpiar" type="reset" />
	</td>
	<!--- </tr>
	<td colspan="2">
	<table width="120" align="center">
	<tr>
    <td>
	<fieldset><legend>Estado Interfaz</legend>
	<span style = "color: ##<cfif Activa EQ 0>FF0000<cfelse>0000FF</cfif>"><cfif Activa EQ 0>Inactiva<cfelse>Activa</cfif></span>
	<input id="<cfif Activa NEQ 0>Un</cfif>doInterfaz" name="<cfif Activa NEQ 0>Un</cfif>doInterfaz" 
		value="<cfif Activa NEQ 0>Ina<cfelse>A</cfif>ctivar" type="submit" />			
	</fieldset>
	</td>
	</tr>
	</table>
	</td>
	</tr> --->
	</table>
</cfoutput>
</form>
<script language="javascript" type="text/javascript">
	<!--//
		document.frmParams.Activa.focus();
	//-->
</script>