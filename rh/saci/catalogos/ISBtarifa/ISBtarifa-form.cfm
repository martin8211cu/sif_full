<cfparam name="url.TAtarifa" default="">
<cfquery datasource="#session.dsn#" name="monedas">
	select Miso4217 , Mnombre from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Miso4217
</cfquery>
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBtarifa where TAtarifa =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TAtarifa#" null="#Len(url.TAtarifa) Is 0#">
	</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBtarifa - Tarifas 
				// Columna: Miso4217 Moneda char(3)
				if (formulario.Miso4217.value == "") {
					error_msg += "\n - Moneda no puede quedar en blanco.";
					error_input = formulario.Miso4217;
				}
			
				// Columna: TAnombreTarifa Nombre de tarifa varchar(30)
				if (formulario.TAnombreTarifa.value == "") {
					error_msg += "\n - Nombre de tarifa no puede quedar en blanco.";
					error_input = formulario.TAnombreTarifa;
				}
			
				// Columna: TAunidades Unidades (segundos) int
				if (formulario.TAunidades.value == "") {
					error_msg += "\n - Unidades (segundos) no puede quedar en blanco.";
					error_input = formulario.TAunidades;
				}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevo(){
		location.href = 'ISBtarifa-edit.cfm';
		return false;
	}
	function cambioUnidad(val){
		//	Funcion para cambiar la etiqueta de la unidad de cobro en Detalle de Tarifa
		if (window.cambiaEtiquetaDetalle) 
			return cambiaEtiquetaDetalle(val);					
	}	
//-->
</script>
<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
<form action="ISBtarifa-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	
		<tr><td valign="top"><label for="Miso4217">Moneda</label>
		</td><td valign="top">
		<select name="Miso4217" id="Miso4217" tabindex="1">
		<cfloop query="monedas">
		<option value="#HTMLEditFormat(monedas.Miso4217)#"  <cfif monedas.Miso4217 is data.Miso4217>selected</cfif>>
		#HTMLEditFormat(monedas.Miso4217)# #HTMLEditFormat(monedas.Mnombre)#
		</option>
		</cfloop>
		</select>
		
		</td></tr>
		
		<tr><td valign="top"><label for="TAnombreTarifa">Nombre de tarifa</label>
		</td><td valign="top">
		
			<input name="TAnombreTarifa" id="TAnombreTarifa" type="text" value="#HTMLEditFormat(data.TAnombreTarifa)#" 
				maxlength="30" tabindex="1"
				onfocus="this.select()"  
				onblur="javascript: validaBlancos(this);"
				>
		
		</td></tr>
		
		<tr><td valign="top"><label for="TAunidades">Unidad de cobro</label>
		</td><td valign="top">
			<select name="TAunidades" onChange="javascript: cambioUnidad(this.value);" tabindex="1">
			<option value="1" <cfif data.TAunidades is 1>selected</cfif>>segundo</option>
			<option value="60" <cfif data.TAunidades is 60>selected</cfif>>minuto</option>
			<option value="3600" <cfif data.TAunidades is 3600>selected</cfif>>hora</option>
			<cfif Len(data.TAunidades) And Not ListFind('1,60,3600', data.TAunidades)>
				<option value="#data.TAunidades#" selected>#data.TAunidades# s</option>
			</cfif>
			</select>
		
		</td></tr>
		
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones  regresar="ISBtarifa.cfm" modo="CAMBIO" tabindex="1">
		<cfelse>
			<cf_botones  regresar="ISBtarifa.cfm" modo="ALTA" tabindex="1">
		</cfif>
	</td></tr>
	</table>
	
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
	<input type="hidden" name="TAtarifa" value="#HTMLEditFormat(data.TAtarifa)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>

</cfoutput>