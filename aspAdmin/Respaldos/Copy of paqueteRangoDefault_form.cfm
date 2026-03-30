
<!--- Establecimiento del modoDR --->
<cfif isdefined("form.PAcodigo") and form.PAcodigo NEQ '' 
	and isdefined("form.TCcodigo") and form.TCcodigo NEQ ''
	and isdefined('form.PRDhasta') and form.PRDhasta NEQ ''>
	<cfset modoDR="CAMBIO">
<cfelse>
	<cfset modoDR="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modoDR NEQ 'ALTA'>
	<cfquery name="rsFormRD" datasource="#session.DSN#">
		Select convert(varchar,PAcodigo) as PAcodigo
			, convert(varchar,TCcodigo) as TCcodigo
			, convert(varchar,PRDhasta) as PRDhasta
			, convert(varchar,PRDtarifaFija) as PRDtarifaFija
			, convert(varchar,PRDtarifaVariable) as PRDtarifaVariable			
--			, timestamp
		from PaqueteRangoDefault
		where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
			and TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
			and PRDhasta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRDhasta#">
	</cfquery>
</cfif>

<cfquery name="qryHastaR" datasource="#Session.DSN#">
	Select convert(varchar,PRDhasta) as PRDhasta
	from PaqueteRangoDefault
	where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
		and TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
</cfquery>	

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="paqueteTarifas_SQL.cfm" method="post" name="formPaquetesRangoDefault">
	<cfoutput>
		<input type="hidden" name="PAcodigo" value="#form.PAcodigo#">
		<input type="hidden" name="TCcodigo" value="#form.TCcodigo#">		
		
<!--- 		<cfif modoDR NEQ 'ALTA' and isdefined('rsFormRD') and rsFormRD.recordCount GT 0>
			<cfset ts = "">	
			<cfinvoke component="aspAdmin.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsFormRD.timestamp#"/>
			</cfinvoke>
			<input type="hidden" name="timestamp" value="#ts#" size="32">			
		</cfif> --->
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">
				<cfif modoDR eq "ALTA">
					Nuevo Rango
					  <cfelse>
					Modificar Rango
				</cfif>	
			</td>
			</tr>
		  <tr>
			<td><strong>Hasta</strong></td>
			<td><strong>Tarifa Fija</strong></td>
			<td><strong>Tarifa Variable</strong></td>
		  </tr>
		  <tr>
			<td>
			<cfif modoDR NEQ "ALTA" AND rsFormRD.PRDhasta EQ "999999999999999">
				<input name="PRDhasta" type="hidden" id="PRDhasta" value="999999999999999">
				<input style="border:1px solid ##CCCCCC;" name="PRDhastaDespl" type="text" readonly><script language="JavaScript">document.formPaquetesRangoDefault.PRDhastaDespl.value=(document.Ultimo) ? 'más de '+document.Ultimo : 'Tarifa';</script>
			<cfelse>
				<input name="PRDhasta" tabindex="11" <cfif modoDR NEQ "ALTA">style="border:1px solid ##CCCCCC;"</cfif> type="text" id="PRDhasta" size="15" maxlength="8" <cfif modoDR NEQ "ALTA"> readonly="true"</cfif> value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDhasta#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</cfif>
			</td>
			<td><input name="PRDtarifaFija" tabindex="11" style="text-align: right;" type="text" id="PRDtarifaFija" size="10" maxlength="8" value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDtarifaFija#<cfelse>0.00</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
			<td><input name="PRDtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="PRDtarifaVariable" size="10" maxlength="8" value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDtarifaVariable#<cfelse>0.00</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<cfif not isdefined('modoDR')>
				  <cfset modoDR = "ALTA">
				</cfif>
				
				<input type="hidden" name="botonSel" value="">
				
				<cfif modoDR EQ "ALTA">
					<input type="submit" name="AltaDR" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="LimpiarDR" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="CambioDR" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD(); ">
			<cfif rsFormRD.PRDhasta NEQ "999999999999999">
					<input type="submit" name="BajaDR" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
			</cfif>
					<input type="submit" name="NuevoDR" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
				</cfif>	
			</td>
		  </tr>  
		</table>
	</cfoutput>		
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionD() {
		objFormDet.PRDhasta.required = false;
		objFormDet.PRDtarifaFija.required = false;	
		objFormDet.PRDtarifaVariable.required = false;			
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		<cfif modoDR NEQ 'CAMBIO'>objFormDet.PRDhasta.required = true;</cfif>
		objFormDet.PRDtarifaFija.required = true;	
		objFormDet.PRDtarifaVariable.required = true;
	}		
//---------------------------------------------------------------------------------------
	// Se aplica al codigo del idioma 
	function __isValidaHasta() {		
		if(btnSelected("AltaDR", this.obj.form)) {		
			if(this.value != '') {
				<cfif isdefined('qryHastaR') and qryHastaR.recordCount GT 0>
					var existeHasta = false;
		
					var ordenList = "<cfoutput>#ValueList(qryHastaR.PRDhasta,'~')#</cfoutput>"
					var ordenArray = ordenList.split("~");
					for (var i=0; i<ordenArray.length; i++) {
						if (ordenArray[i] == this.value) {
							existeHasta = true;
							break;
						}
					}
					
					if (existeHasta){
						this.error = "El valor de Hasta ya existe, favor digitar uno diferente";				
						this.focus();
					}
				</cfif>
			}		
		}
	}	
//---------------------------------------------------------------------------------------		
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaHasta", __isValidaHasta);
	objFormDet = new qForm("formPaquetesRangoDefault");
//---------------------------------------------------------------------------------------
	<cfif modoDR NEQ 'CAMBIO'>
		objFormDet.PRDhasta.required = true;
		objFormDet.PRDhasta.description = "Hasta";		
		objFormDet.PRDhasta.validateValidaHasta();		
	</cfif>
			
	objFormDet.PRDtarifaFija.required = true;
	objFormDet.PRDtarifaFija.description = "Tarifa Fija";
	objFormDet.PRDtarifaVariable.required = true;
	objFormDet.PRDtarifaVariable.description = "Tarifa Variable";	
</script>
