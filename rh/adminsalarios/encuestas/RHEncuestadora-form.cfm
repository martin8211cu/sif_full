


<cfparam name="url.Ecodigo" default="">

<cfparam name="url.EEid" default="">


<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHEncuestadora
	
		where 
		Ecodigo =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#" null="#Len(url.Ecodigo) Is 0#">
	
		and 
		EEid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#" null="#Len(url.EEid) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHEncuestadora - RHEncuestadora
		
			
			
		
			
			
				// Columna: EEid Empresa Encuestadora numeric
				if (formulario.EEid.value == "") {
					error_msg += "\n - Empresa Encuestadora no puede quedar en blanco.";
					error_input = formulario.EEid;
				}
			
		
			
			
		
			
			
				// Columna: RHEdefault Es default bit
				if (formulario.RHEdefault.value == "") {
					error_msg += "\n - Es default no puede quedar en blanco.";
					error_input = formulario.RHEdefault;
				}
			
		
			
			
				// Columna: RHEinactiva Inactivar bit
				if (formulario.RHEinactiva.value == "") {
					error_msg += "\n - Inactivar no puede quedar en blanco.";
					error_input = formulario.RHEinactiva;
				}
			
		
			
			
				// Columna: RHEconfigurada Esta configurada bit
				if (formulario.RHEconfigurada.value == "") {
					error_msg += "\n - Esta configurada no puede quedar en blanco.";
					error_input = formulario.RHEconfigurada;
				}
			
		
			
			
		
			
			
		
			
			
					
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="RHEncuestadora-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	RHEncuestadora
	</td></tr>
	
	
		
		
			
		
	
		
		
		<tr><td valign="top">Empresa Encuestadora
		</td><td valign="top">
		
			<input name="EEid" id="EEid" type="text" value="#HTMLEditFormat(data.EEid)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Encuesta actual
		</td><td valign="top">
		
			<input name="Eid" id="Eid" type="text" value="#HTMLEditFormat(data.Eid)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Es default
		</td><td valign="top">
		
			<input name="RHEdefault" id="RHEdefault" type="checkbox" value="1" <cfif Len(data.RHEdefault) And data.RHEdefault>checked</cfif> >
			<label for="RHEdefault">Es default</label>
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Inactivar
		</td><td valign="top">
		
			<input name="RHEinactiva" id="RHEinactiva" type="checkbox" value="1" <cfif Len(data.RHEinactiva) And data.RHEinactiva>checked</cfif> >
			<label for="RHEinactiva">Inactivar</label>
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Esta configurada
		</td><td valign="top">
		
			<input name="RHEconfigurada" id="RHEconfigurada" type="checkbox" value="1" <cfif Len(data.RHEconfigurada) And data.RHEconfigurada>checked</cfif> >
			<label for="RHEconfigurada">Esta configurada</label>
		
		</td></tr>
		
	
		
		
			
		
	
		
		
			
		
	
		
		
			
		
	
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
	
	
		
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
		
	
		
			<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>


