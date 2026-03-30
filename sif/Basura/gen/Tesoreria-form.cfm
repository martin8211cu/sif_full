


<cfparam name="url.TESid" default="">


<cfquery datasource="#session.dsn#" name="data">
	select *
	from  Tesoreria
	
		where 
		TESid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#" null="#Len(url.TESid) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: Tesoreria - Tesorería
		
			
			
		
			
			
				// Columna: TESdescripcion Descripcion Tesoreria varchar(40)
				if (formulario.TESdescripcion.value == "") {
					error_msg += "\n - Descripcion Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESdescripcion;
				}
			
		
			
			
		
			
			
				// Columna: EcodigoAdm Código Empresa Administradora int
				if (formulario.EcodigoAdm.value == "") {
					error_msg += "\n - Código Empresa Administradora no puede quedar en blanco.";
					error_input = formulario.EcodigoAdm;
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

<form action="Tesoreria-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Tesorería
	</td></tr>
	
	
		
		
			
		
	
		
		
		<tr><td valign="top">Descripcion Tesoreria
		</td><td valign="top">
		
			<input name="TESdescripcion" id="TESdescripcion" type="text" value="#HTMLEditFormat(data.TESdescripcion)#" 
				maxlength="40"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
			
		
	
		
		
		<tr><td valign="top">Código Empresa Administradora
		</td><td valign="top">
		
			<input name="EcodigoAdm" id="EcodigoAdm" type="text" value="#HTMLEditFormat(data.EcodigoAdm)#" 
				maxlength="11"
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
	
	
		
			<input type="hidden" name="TESid" value="#HTMLEditFormat(data.TESid)#">
		
	
		
			<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>


