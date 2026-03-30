


<cfparam name="url.PBtabla" default="">

<cfparam name="url.Ecodigo" default="">


<cfquery datasource="#session.dsn#" name="data">
	select *
	from  PBitacoraEmp
	
		where 
		PBtabla =
		<cfqueryparam cfsqltype="cf_sql_char" value="#url.PBtabla#" null="#Len(url.PBtabla) Is 0#">
	
		and 
		Ecodigo =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#" null="#Len(url.Ecodigo) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: PBitacoraEmp - Parámetros de Bitácora por empresa
		
			
			
				// Columna: PBtabla Tabla varchar(30)
				if (formulario.PBtabla.value == "") {
					error_msg += "\n - Tabla no puede quedar en blanco.";
					error_input = formulario.PBtabla;
				}
			
		
			
			
		
			
			
				// Columna: PBinactivo Inactivo bit
				if (formulario.PBinactivo.value == "") {
					error_msg += "\n - Inactivo no puede quedar en blanco.";
					error_input = formulario.PBinactivo;
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

<form action="PBitacoraEmp-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Parámetros de Bitácora por empresa
	</td></tr>
	
	
		
		
		<tr><td valign="top">Tabla
		</td><td valign="top">
		
			<input name="PBtabla" id="PBtabla" type="text" value="#HTMLEditFormat(data.PBtabla)#" 
				maxlength="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
			
		
	
		
		
		<tr><td valign="top">Inactivo
		</td><td valign="top">
		
			<input name="PBinactivo" id="PBinactivo" type="checkbox" value="1" <cfif Len(data.PBinactivo) And data.PBinactivo>checked</cfif> >
			<label for="PBinactivo">Inactivo</label>
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Empresa SDC
		</td><td valign="top">
		
			<input name="EcodigoSDC" id="EcodigoSDC" type="text" value="#HTMLEditFormat(data.EcodigoSDC)#" 
				maxlength=""
				onfocus="this.select()"  >
		
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
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>


