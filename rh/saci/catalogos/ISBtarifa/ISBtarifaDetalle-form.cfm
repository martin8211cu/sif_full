<cfparam name="url.TAtarifa" type="numeric">
<cfparam name="url.TAlinea" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBtarifaDetalle where TAtarifa =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TAtarifa#" null="#Len(url.TAtarifa) Is 0#">
	and TAlinea =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.TAlinea#" null="#Len(url.TAlinea) Is 0#">
</cfquery>

<cfquery datasource="#session.dsn#" name="ISBtarifa">
	select Miso4217, TAunidades
	from  ISBtarifa
	where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TAtarifa#" null="#Len(url.TAtarifa) Is 0#">
</cfquery>


<cfoutput>

<script type="text/javascript">
<!--
	function validarDet(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBtarifaDetalle - Detalle de tarifa 
			
				// Columna: TAlineaNombre Nombre de línea varchar(30)
				if (formulario.TAlineaNombre.value == "") {
					error_msg += "\n - Detalle de tarifa no puede quedar en blanco.";
					error_input = formulario.TAlineaNombre;
				}
			
				// Columna: TAtarifaBasica Unidades incluidas decimal(14,2)
				if (formulario.TAtarifaBasica.value == "") {
					error_msg += "\n - Unidades incluidas no puede quedar en blanco.";
					error_input = formulario.TAtarifaBasica;
				}
			
				// Columna: TAprecioBase Precio base decimal(14,2)
				if (formulario.TAprecioBase.value == "") {
					error_msg += "\n - Precio base no puede quedar en blanco.";
					error_input = formulario.TAprecioBase;
				}
			
				// Columna: TAprecioExc Unidad excedente decimal(14,2)
				if (formulario.TAprecioExc.value == "") {
					error_msg += "\n - Unidad excedente no puede quedar en blanco.";
					error_input = formulario.TAprecioExc;
				}
			
				// Columna: TAredondeoMetodo Redondeo char(1)
				if (formulario.TAredondeoMetodo.value == "") {
					error_msg += "\n - Redondeo no puede quedar en blanco.";
					error_input = formulario.TAredondeoMetodo;
				}
			
				// Columna: TAredondeoMultiplo Segundos redondeo int
				if (formulario.TAredondeoMultiplo.value == "") {
					error_msg += "\n - Segundos redondeo no puede quedar en blanco.";
					error_input = formulario.TAredondeoMultiplo;
				}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevoDet(){
		location.href = 'ISBtarifa-edit.cfm?TAtarifa=# JSStringFormat( URLEncodedFormat(url.TAtarifa)) #';
		return false;
	}
	function cambiaEtiquetaDetalle(val){
		if(val == 1){
			document.formDetTarifa.etiqueta.value = 'Segundos incluidos';
			document.formDetTarifa.etiquetaExced.value = 'Precio Segundos excedentes';
		}else if(val == 60){
			document.formDetTarifa.etiqueta.value = 'Minutos incluidos';
			document.formDetTarifa.etiquetaExced.value = 'Precio Minutos excedentes';			
		}else if(val == 3600){
			document.formDetTarifa.etiqueta.value = 'Horas incluidas';
			document.formDetTarifa.etiquetaExced.value = 'Precio Horas excedentes';			
		}
	}
//-->
</script>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	
<form action="ISBtarifaDetalle-apply.cfm" onsubmit="return validarDet(this);" enctype="multipart/form-data" method="post" name="formDetTarifa" id="formDetTarifa">
	<input name="TAtarifa" id="TAtarifa" type="hidden" value="#HTMLEditFormat(url.TAtarifa)#" >
	<input name="TAlinea" id="TAlinea" type="hidden" value="#HTMLEditFormat(data.TAlinea)#" >
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
		Detalle de tarifa
	</td></tr>
		<tr><td valign="top"><label for="TAlineaNombre">Tipo de tarifa </label></td><td valign="top">
			<input name="TAlineaNombre" id="TAlineaNombre" type="text" value="#HTMLEditFormat(data.TAlineaNombre)#" 
				maxlength="30" 
				onfocus="this.select()"
				onblur="javascript: validaBlancos(this);"
				  >
		</td></tr>
		<tr><td valign="top">	
		<label><input name="etiqueta" type="text" class="cajasinbordeb" readonly value=""></label>
		</td><td valign="top">
			<!-----<input name="TAtarifaBasica" id="TAtarifaBasica" type="text" value="#HTMLEditFormat(data.TAtarifaBasica)#" 
				maxlength="14" tabindex="1" size="10"
				onfocus="this.select()"  >--->
				
				<cf_inputNumber name="TAtarifaBasica" value="#HTMLEditFormat(data.TAtarifaBasica)#" enteros="5" codigoNumerico="yes">
				
		</td></tr>
		<tr><td valign="top"><label for="TAprecioBase">Precio base</label>
		</td><td valign="top">
			<!---------<input name="TAprecioBase" id="TAprecioBase" type="text" value="#HTMLEditFormat(data.TAprecioBase)#" 
				maxlength="14" tabindex="1" size="10"
				onfocus="this.select()"  >------->
			<cf_inputNumber name="TAprecioBase"  value="#HTMLEditFormat(data.TAprecioBase)#" enteros="5" decimales="2" negativos="false" comas="false">
			#HTMLEditFormat( ISBtarifa.Miso4217)#
		</td></tr>
		<tr><td valign="top">	
		<label><input name="etiquetaExced" readonly type="text" size="25" class="cajasinbordeb" value=""></label>
		</td><td valign="top" nowrap>
			<!-------<input name="TAprecioExc" id="TAprecioExc" type="text" value="#HTMLEditFormat(data.TAprecioExc)#" 
				maxlength="14" tabindex="1" size="10"
				onfocus="this.select()"  >----->
			<cf_inputNumber name="TAprecioExc"  value="#HTMLEditFormat(data.TAprecioExc)#" enteros="5" decimales="2" negativos="false" comas="false">
			#HTMLEditFormat( ISBtarifa.Miso4217)#
		</td></tr>
		<tr><td valign="top"><label for="TAredondeoMetodo">Redondear</label>
		</td><td valign="top" nowrap="nowrap">
			<select name="TAredondeoMetodo" id="TAredondeoMetodo" >
				<option value="F" <cfif data.TAredondeoMetodo is 'F'>selected</cfif> >
					Hacia abajo
				</option>
				<option value="C" <cfif data.TAredondeoMetodo is 'C'>selected</cfif> >
					Hacia arriba
				</option>
				<option value="R" <cfif data.TAredondeoMetodo is 'R'>selected</cfif> >
					El más cercano
				</option>
			</select>
			cada
			<!--------<input name="TAredondeoMultiplo" id="TAredondeoMultiplo" type="text" value="#HTMLEditFormat(data.TAredondeoMultiplo)#" 
				maxlength="6" tabindex="1" size="3"
				onfocus="this.select()">----->
			<cf_inputNumber name="TAredondeoMultiplo" value="#HTMLEditFormat(data.TAredondeoMultiplo)#" enteros="2" codigoNumerico="yes">
			
			<label for="label">segundo(s)</label></td>
		</tr>
		<tr>
		  <td valign="top">&nbsp;</td><td valign="top">&nbsp;</td>
		</tr>
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cfif data.TAlineaDefault EQ 1>
				<cf_botones  regresar="ISBtarifa.cfm" modo="CAMBIO" sufijo="Det" exclude="Baja">
			<cfelse>
				<cf_botones  regresar="ISBtarifa-edit.cfm" modo="CAMBIO" sufijo="Det">
			</cfif>
		<cfelse>
			<cf_botones  regresar="ISBtarifa-edit.cfm" modo="ALTA" sufijo="Det">
		</cfif>
	</td></tr>
	</table>
		<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
</form>
</cfoutput>