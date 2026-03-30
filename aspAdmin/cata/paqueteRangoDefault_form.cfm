<!---<cfdump var="#form#">

 Establecimiento del modoDR --->
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
	<cfquery name="rsRangoAnterior" datasource="#session.DSN#">
		Select convert(varchar,PRDhasta) as PRDhastaAnterior
			, convert(varchar,PRDhasta+1) as PRDdesde
			, str(PRDtarifaFija + PRDhasta*PRDtarifaVariable, 15, 2) as PRDmaximaAnterior
		from PaqueteRangoDefault prd
		where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
		and PRDhasta = (
				select max(PRDhasta) 
				from PaqueteRangoDefault 
				where TCcodigo=prd.TCcodigo 
					and PRDhasta < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRDhasta#">)
	</cfquery>	
</cfif>

<cfquery name="qryHastaR" datasource="#Session.DSN#">
	Select convert(varchar,PRDhasta) as PRDhasta
	from PaqueteRangoDefault
	where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
		and TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
</cfquery>	

 <cfquery name="qryConcTarifa" datasource="#Session.DSN#">
	Select TCcodigo
		,TCtipoCalculo
		, TCnombre
	from TarifaCalculoIndicador
	where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="paqueteTarifas_SQL.cfm" method="post" name="formPaquetesRangoDefault" onSubmit="javascript: quitaFormato();">
	<cfoutput>
		  <input type="hidden" name="PAcodigo" value="#form.PAcodigo#">
		  <input type="hidden" name="TCcodigo" value="#form.TCcodigo#">		

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center" class="tituloMantenimiento">
				<cfif modoDR eq "ALTA">
					Nuevo Rango
				<cfelse>
					Modificar Rango
				</cfif>	
			</td>
		  </tr>
		  <tr>
			<td>
				<strong>
 					<cfif modoDR NEQ "ALTA" AND rsFormRD.PRDhasta EQ "999999999999999">
						<cfif rsRangoAnterior.PRDdesde NEQ "">
							#qryConcTarifa.TCnombre#
						</cfif>
					<cfelseif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0>
						#qryConcTarifa.TCnombre# <cfif modoDR EQ "ALTA">Hasta</cfif>
					<cfelse>
						Hasta
					</cfif>			
				</strong>			
			</td>
		  </tr>
		  <tr>
			<td>
				<cfif modoDR NEQ "ALTA"> 
					<input name="PRDhasta" type="hidden" id="PRDhasta" value="#form.PRDhasta#">
					<cfif rsFormRD.PRDhasta EQ "999999999999999">
						<input name="PRDRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="<cfif rsRangoAnterior.PRDdesde NEQ "">mayor que #rsRangoAnterior.PRDhastaAnterior#<cfelse>Tarifa Unica</cfif>">
					<cfelse>
						<input name="PRDRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="desde <cfif rsRangoAnterior.PRDdesde EQ "">0<cfelse>#rsRangoAnterior.PRDdesde#</cfif> hasta #rsFormRD.PRDhasta#">
					</cfif>
				<cfelse>
						<input name="PRDhasta" 
						type="text" <cfif modoDR NEQ "ALTA">style="border:1px solid ##CCCCCC;text-align:right;"<cfelse>tabindex="11"</cfif> 
						id="PRDhasta" size="15" maxlength="8" <cfif modoDR NEQ "ALTA"> readonly="true"</cfif> 
						value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDhasta#</cfif>" 
						onFocus="javascript:this.value=qf(this); this.select();" 
						onBlur="javascript:fm(this,0);"  
						onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td>
				<strong>Tarifa Fija o M&iacute;nimo</strong>
			</td>
		  </tr>
		  <tr>
			<td>
				<input name="PRDtarifaFija" tabindex="11" style="text-align: right;" type="text" id="PRDtarifaFija" size="10" maxlength="8" 
					value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDtarifaFija#<cfelse>0.00</cfif>" 
					onFocus="javascript:this.value=qf(this); this.select();" 
					onBlur="javascript:fm(this,2);"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				
				<cfif modoDR NEQ 'ALTA' and rsRangoAnterior.PRDdesde NEQ "">
					&nbsp;&nbsp;
					<input type="button" value="Max Anterior" 
					onclick="javascript:document.formPaquetesRangoDefault.PRDtarifaFija.value='#rsRangoAnterior.PRDmaximaAnterior#'">
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td>
				<strong>
					Tarifa Variable
					<cfif modoDR NEQ 'ALTA' and rsRangoAnterior.PRDdesde NEQ "">
						a partir de #rsRangoAnterior.PRDdesde#
					</cfif>
				</strong>			
			</td>
		  </tr>
		  <tr>
			<td>
				<cfif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0 and qryConcTarifa.TCtipoCalculo EQ 'F'>
					<input name="PRDtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="PRDtarifaVariable" size="10" maxlength="8" 
						value="0.00" readonly="true" 
						onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">				
				<cfelse>
					<input name="PRDtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="PRDtarifaVariable" size="10" maxlength="8" 
						value="<cfif modoDR NEQ "ALTA">#rsFormRD.PRDtarifaVariable#<cfelse>0.00</cfif>" 
						onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">				
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center">
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
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
  </cfoutput>		
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
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
	function quitaFormato() {
		var f = document.formPaquetesRangoDefault;
		<cfif modoDR NEQ "ALTA">
			f.PRDRango.value = qf(f.PRDRango);
		</cfif>
		f.PRDhasta.value = qf(f.PRDhasta);
		f.PRDtarifaFija.value = qf(f.PRDtarifaFija);
		f.PRDtarifaVariable.value = qf(f.PRDtarifaVariable);		
	}			
//---------------------------------------------------------------------------------------	
	function formatea(){
		var f = document.formPaquetesRangoDefault;
		
		if(f.PRDhasta.value != '')	fm(f.PRDhasta,2);
		if(f.PRDtarifaFija.value != '')	fm(f.PRDtarifaFija,2);
		if(f.PRDtarifaVariable.value != '')	fm(f.PRDtarifaVariable,2);
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
	
	<cfif modoDR NEQ 'ALTA'>
		formatea();	
	</cfif>		
</script>
