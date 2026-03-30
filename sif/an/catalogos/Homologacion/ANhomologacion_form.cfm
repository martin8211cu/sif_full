<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="Codigo" 
returnvariable="LB_Codigo" xmlfile="ANhomologacion_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TipoH" 	default="Tipo de Homologaci&oacute;n" 
returnvariable="LB_TipoH" xmlfile="ANhomologacion_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Homologar" 	default="Homologar" 
returnvariable="BTN_Homologar" xmlfile="ANhomologacion_form.xml"/>
<cfif isdefined ('url.ANHid') and not isdefined('form.ANHid')>
	<cfset form.ANHid=#url.ANHid#>
</cfif>

<cfif isdefined ('form.ANHid')>
	<cfset modo='CAMBIO'>
	<cfquery name="rsSQL" datasource="#session.dsn#">
			select 
			ANHid,
			Ecodigo, 
			ANHcodigo,
			ANHdescripcion,
			BMUsucodigo 
		from
			ANhomologacion
		where Ecodigo=#session.Ecodigo#
		and ANHid=#form.ANHid#
	</cfquery>
<cfelse>
	<cfset modo='ALTA'>
</cfif>
<cfquery name="rsHomo" datasource="#session.dsn#">
	select 
		ANHid,
		Ecodigo, 
		ANHcodigo,
		ANHdescripcion,
		BMUsucodigo 
	from
		ANhomologacion
	where Ecodigo=#session.Ecodigo#
</cfquery>
<cfparam name="ANHid" default="">

<table width="50%" align="left">
	<tr><!---	navegacion="&ANHid=#form.ANHid#"--->
		<td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsHomo#"
				columnas="ANHid,ANHcodigo,ANHdescripcion"
				desplegar="ANHcodigo,ANHdescripcion"
				etiquetas="#LB_Codigo#, #LB_TipoH#"
				formatos="S,S"
				align="left,left"
				ira="ANhomologacion.cfm"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="ANHid"
				incluyeForm="yes"
				formName="form2"
				PageIndex="2"
				MaxRows="8"
			/>
		</td>
		</tr>
</table>
<form name="formH" action="ANhomologacion_sql.cfm" method="post" onSubmit="return validar(this);">
<cfif modo eq 'CAMBIO'>
	<cfoutput><input type="hidden" name="ANHid" value="#rsSQL.ANHid#"></cfoutput>
</cfif>
<table width="50%" align="right">
<cfoutput>
	<tr>
		<td align="right">
			<strong>#LB_Codigo#:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="cod" size="12" maxlength="10">
			<cfelse>
				<input type="text" name="cod" size="12" maxlength="10" value="#rsSQL.ANHcodigo#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>#LB_TipoH#:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="tipo" size="50" maxlength="50">
			<cfelse>
				<input type="text" name="tipo" size="50" maxlength="50" value="#rsSQL.ANHdescripcion#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" colspan="4">
		<!---<cf_botones modo='#modo#'>--->
		<cfif modo eq 'ALTA'>
					<cf_botones modo='ALTA'>
			<cfelse>
					<cf_botones modo='CAMBIO'>
					<cf_botones values='#BTN_Homologar#' name='Cuentas'>
			</cfif>
		</td>
	</tr>
</cfoutput>
</table>
</form>
<script type="text/javascript">
function validar(formulario)	{	
	if (!btnSelected('Nuevo',document.formH) && !btnSelected('Baja',document.formH)){
		var error_input;
		var error_msg = '';
	
	if (formulario.cod.value == "") {
	error_msg += "\n - El código no puede quedar en blanco.";
	error_input = formulario.cod;
	}
	
	if (formulario.tipo.value == "") {
	error_msg += "\n - El tipo no puede quedar en blanco.";
	error_input = formulario.tipo;
	}		
	
	if (error_msg.length != "") {
	alert("Por favor revise los siguiente datos:"+error_msg);
	return false;
	}
	}
	}
</script>
