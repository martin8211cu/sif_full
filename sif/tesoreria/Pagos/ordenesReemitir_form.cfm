<cfparam name="form.TESid" default="">

<!--- <cfdump var="#url#">
<cfdump var="#form#"> --->

<cfif isdefined('form.TESid') and len(trim(form.TESid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  Tesoreria
		where 	TESid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsEmpresas">
		Select e.Ecodigo,e.Edescripcion,esdc.CEcodigo,te.TESid
		from Empresas e
			inner join Empresa esdc
				on esdc.Ecodigo=e.EcodigoSDC
			
			left outer join TESempresas te
				on te.Ecodigo=e.Ecodigo
		
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	
	<!--- <cfdump var="#rsEmpresas#"> --->
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario)	{
			if (!btnSelected('Nuevo',document.form1)){
				var error_input;
				var error_msg = '';
				// Validando tabla: Tesoreria - Tesorería
		
				// Columna: TESdescripcion Descripcion Tesoreria varchar(40)
				if (formulario.TESdescripcion.value == "") {
					error_msg += "\n - Descripcion Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESdescripcion;
				}
	
				// Columna: EcodigoAdm Código Empresa Administradora int
				if (formulario.TEScodigo.value == "") {
					error_msg += "\n - Código de la Tesoreria no puede quedar en blanco.";
					error_input = formulario.TEScodigo;
				}
		
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					error_input.focus();
					return false;
				}
			}

			return true;
		}
	//-->
	</script>
	
	<form action="Tesoreria_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
		<table summary="Tabla de entrada">
			<tr>
			  <td valign="top" align="right"><strong>C&oacute;digo:</strong></td>
			  <td valign="top">
				<input name="TEScodigo" id="TEScodigo" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TEScodigo)#</cfif>" 
					maxlength="4"
					size="4"
					onfocus="this.select()"  >
			</td></tr>
			<tr>
			  <td valign="top" align="right"><strong>Descripcion:</strong></td>
			  <td valign="top">
			
				<input name="TESdescripcion" id="TESdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESdescripcion)#</cfif>" 
					maxlength="40"
					size="40"
					onfocus="this.select()"  >
			
			</td></tr>
		<tr><td colspan="2" class="formButtons">
			<cfif modo NEQ 'ALTA'>
				<cf_botones modo='CAMBIO'>
			<cfelse>
				<cf_botones modo='ALTA'>
			</cfif>
		</td></tr>
		</table>
		<cfif modo NEQ 'ALTA'>
			<input type="hidden" name="TESid" value="#HTMLEditFormat(data.TESid)#">
			<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
</cfoutput>