<!--- Establecimiento del modoDR --->
<cfif isdefined("form.COcodigo") and form.COcodigo NEQ '' 
	and isdefined("form.TCcodigo") and form.TCcodigo NEQ ''
	and isdefined('form.CORhasta') and form.CORhasta NEQ ''>
	<cfset modoDR="CAMBIO">
<cfelse>
	<cfset modoDR="ALTA">
</cfif>

<!---   Consultas    --->
<cfif modoDR NEQ 'ALTA'>
	<cfquery name="rsFormRD" datasource="#session.DSN#">
		Select convert(varchar,COcodigo) as COcodigo
			, convert(varchar,TCcodigo) as TCcodigo
			, convert(varchar,CORhasta) as CORhasta
			, convert(varchar,CORtarifaFija) as CORtarifaFija
			, convert(varchar,CORtarifaVariable) as CORtarifaVariable			
--			, timestamp
		from ClienteContratoRangos
		where COcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COcodigo#">
			and TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
			and CORhasta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CORhasta#">
	</cfquery>
	<cfquery name="rsRangoAnterior" datasource="#session.DSN#">
		Select convert(varchar,CORhasta) as CORhastaAnterior
			, convert(varchar,CORhasta+1) as CORdesde
			, str(CORtarifaFija + CORhasta*CORtarifaVariable, 15, 2) as CORmaximaAnterior
		from ClienteContratoRangos prd
		where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
		and CORhasta = (
				select max(CORhasta) 
				from ClienteContratoRangos 
				where TCcodigo=prd.TCcodigo 
					and CORhasta < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CORhasta#">)
	</cfquery>	
</cfif>

<cfquery name="qryHastaR" datasource="#Session.DSN#">
	Select convert(varchar,CORhasta) as CORhasta
	from ClienteContratoRangos
	where COcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COcodigo#">
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
<form action="cuentaContratoTarifas_SQL.cfm" method="post" name="formCuentaContratoRangos" onSubmit="javascript: quitaFormato();">
	<cfoutput>
		  <input type="hidden" name="COcodigo" value="#form.COcodigo#">
		  <input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">		  
		  <input type="hidden" name="TCcodigo" value="#form.TCcodigo#">		

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center" class="tituloMantenimiento" nowrap>
				<cfif modoDR eq "ALTA">
					Nuevo Rango
				<cfelse>
					Modificar Rango
				</cfif>	
			</td>
		  </tr>
		  <tr>
			<td nowrap>
				<strong>
 					<cfif modoDR NEQ "ALTA" AND rsFormRD.CORhasta EQ "999999999999999">
						<cfif rsRangoAnterior.CORdesde NEQ "">
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
					<input name="CORhasta" type="hidden" id="CORhasta" value="#form.CORhasta#">
					<cfif rsFormRD.CORhasta EQ "999999999999999">
						<input name="CORRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="<cfif rsRangoAnterior.CORdesde NEQ "">mayor que #rsRangoAnterior.CORhastaAnterior#<cfelse>Tarifa Unica</cfif>">
					<cfelse>
						<input name="CORRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="desde <cfif rsRangoAnterior.CORdesde EQ "">0<cfelse>#rsRangoAnterior.CORdesde#</cfif> hasta #rsFormRD.CORhasta#">
					</cfif>
				<cfelse>
						<input name="CORhasta" 
						type="text" <cfif modoDR NEQ "ALTA">style="border:1px solid ##CCCCCC;text-align:right;"<cfelse>tabindex="11"</cfif> 
						id="CORhasta" size="15" maxlength="8" <cfif modoDR NEQ "ALTA"> readonly="true"</cfif> 
						value="<cfif modoDR NEQ "ALTA">#rsFormRD.CORhasta#</cfif>" 
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
			<td nowrap>
				<input name="CORtarifaFija" tabindex="11" style="text-align: right;" type="text" id="CORtarifaFija" size="10" maxlength="8" 
					value="<cfif modoDR NEQ "ALTA">#rsFormRD.CORtarifaFija#<cfelse>0.00</cfif>" 
					onFocus="javascript:this.value=qf(this); this.select();" 
					onBlur="javascript:fm(this,2);"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				
				<cfif modoDR NEQ 'ALTA' and rsRangoAnterior.CORdesde NEQ "">
					&nbsp;&nbsp;
					<input type="button" value="Max Anterior" 
					onclick="javascript:document.formCuentaContratoRangos.CORtarifaFija.value='#rsRangoAnterior.CORmaximaAnterior#'">
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td nowrap>
				<strong>
					Tarifa Variable
					<cfif modoDR NEQ 'ALTA' and rsRangoAnterior.CORdesde NEQ "">
						a partir de #rsRangoAnterior.CORdesde#
					</cfif>
				</strong>			
			</td>
		  </tr>
		  <tr>
			<td>
				<cfif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0 and qryConcTarifa.TCtipoCalculo EQ 'F'>
					<input name="CORtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="CORtarifaVariable" size="10" maxlength="8" 
						value="0.00" readonly="true" 
						onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">				
				<cfelse>
					<input name="CORtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="CORtarifaVariable" size="10" maxlength="8" 
						value="<cfif modoDR NEQ "ALTA">#rsFormRD.CORtarifaVariable#<cfelse>0.00</cfif>" 
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
					<cfif rsFormRD.CORhasta NEQ "999999999999999">
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
		objFormDet.CORhasta.required = false;
		objFormDet.CORtarifaFija.required = false;	
		objFormDet.CORtarifaVariable.required = false;			
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		<cfif modoDR NEQ 'CAMBIO'>objFormDet.CORhasta.required = true;</cfif>
		objFormDet.CORtarifaFija.required = true;	
		objFormDet.CORtarifaVariable.required = true;
	}
//---------------------------------------------------------------------------------------		
	function quitaFormato() {
		var f = document.formCuentaContratoRangos;
		<cfif modoDR NEQ "ALTA">
			f.CORRango.value = qf(f.CORRango);
		</cfif>
		f.CORhasta.value = qf(f.CORhasta);
		f.CORtarifaFija.value = qf(f.CORtarifaFija);
		f.CORtarifaVariable.value = qf(f.CORtarifaVariable);		
	}			
//---------------------------------------------------------------------------------------	
	function formatea(){
		var f = document.formCuentaContratoRangos;
		
		if(f.CORhasta.value != '')	fm(f.CORhasta,2);
		if(f.CORtarifaFija.value != '')	fm(f.CORtarifaFija,2);
		if(f.CORtarifaVariable.value != '')	fm(f.CORtarifaVariable,2);
	}
//---------------------------------------------------------------------------------------
	// Se aplica al codigo del idioma 
	function __isValidaHasta() {		
		if(btnSelected("AltaDR", this.obj.form)) {		
			if(this.value != '') {
				<cfif isdefined('qryHastaR') and qryHastaR.recordCount GT 0>
					var existeHasta = false;
					
					var ordenList = "<cfoutput>#ValueList(qryHastaR.CORhasta,'~')#</cfoutput>"
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
	objFormDet = new qForm("formCuentaContratoRangos");
//---------------------------------------------------------------------------------------
	<cfif modoDR NEQ 'CAMBIO'>
		objFormDet.CORhasta.required = true;
		objFormDet.CORhasta.description = "Hasta";		
		objFormDet.CORhasta.validateValidaHasta();		
	</cfif>
			
	objFormDet.CORtarifaFija.required = true;
	objFormDet.CORtarifaFija.description = "Tarifa Fija";
	objFormDet.CORtarifaVariable.required = true;
	objFormDet.CORtarifaVariable.description = "Tarifa Variable";
	
	<cfif modoDR NEQ 'ALTA'>
		formatea();	
	</cfif>	
</script>
