
<!--- Establecimiento del modoD --->
<cfif isdefined("form.TCcodigo") and form.TCcodigo NEQ '' and isdefined('form.TRDhasta') and form.TRDhasta NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<cfquery name="qryConcTarifa" datasource="#Session.DSN#">
	Select TCcodigo
		,TCtipoCalculo
		, TCnombre
	from TarifaCalculoIndicador
	where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
</cfquery>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		Select convert(varchar,TCcodigo) as TCcodigo
			, convert(varchar,TRDhasta) as TRDhasta
			, convert(varchar,TRDtarifaFija) as TRDtarifaFija
			, convert(varchar,TRDtarifaVariable) as TRDtarifaVariable			
			, timestamp
		from TarifaRangosDefaults
		where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
			and TRDhasta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TRDhasta#">
	</cfquery>
	<cfquery name="rsRangoAnterior" datasource="#session.DSN#">
		Select convert(varchar,TRDhasta) as TRDhastaAnterior
			, convert(varchar,TRDhasta+1) as TRDdesde
			, str(TRDtarifaFija + TRDhasta*TRDtarifaVariable, 15, 2) as TRDmaximaAnterior
		from TarifaRangosDefaults trd
		where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
		and TRDhasta = (select max(TRDhasta) from TarifaRangosDefaults where TCcodigo=trd.TCcodigo AND TRDhasta < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TRDhasta#">)
	</cfquery>
</cfif>

<cfquery name="qryHasta" datasource="#Session.DSN#">
	Select convert(varchar,TRDhasta) as TRDhasta
	from TarifaRangosDefaults
	where TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="TarifaCalculo_SQL.cfm" method="post" name="formTarifaCalculoRangos" onSubmit="javascript: quitaFormato();">
	<cfoutput>
		<input type="hidden" name="TCcodigo" value="#form.TCcodigo#">
		
		<cfif modoD NEQ 'ALTA' and isdefined('rsFormD') and rsFormD.recordCount GT 0>
			<cfset ts = "">	
			<cfinvoke component="aspAdmin.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsFormD.timestamp#"/>
			</cfinvoke>
			<input type="hidden" name="timestamp" value="#ts#" size="32">			
		</cfif>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center" class="tituloMantenimiento">
				<cfif modoD eq "ALTA">
					Nuevo Rango
					  <cfelse>
					Modificar Rango
				</cfif>			
			</td>
	      </tr>
		  <tr>
			<td>&nbsp;</td>
	      </tr>		  
		  <tr>
			<td nowrap><strong>
				<cfif modoD NEQ "ALTA" AND rsFormD.TRDhasta EQ "999999999999999">
					<cfif rsRangoAnterior.TRDdesde NEQ "">
					#qryConcTarifa.TCnombre#
					</cfif>
				<cfelseif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0>
					#qryConcTarifa.TCnombre# <cfif modoD EQ "ALTA">Hasta</cfif>
				<cfelse>
					Hasta
				</cfif>			
				</strong></td>
	      </tr>
		  <tr>
			<td>
				<cfif modoD NEQ "ALTA"> 
					<input name="TRDhasta" type="hidden" id="TRDhasta2" value="#form.TRDhasta#">
					<cfif rsFormD.TRDhasta EQ "999999999999999">
						<input name="TRDRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="<cfif rsRangoAnterior.TRDdesde NEQ "">mayor que #rsRangoAnterior.TRDhastaAnterior#<cfelse>Tarifa Unica</cfif>">
					<cfelse>
						<input name="TRDRango" type="text" style="width=100%;border:1px solid ##CCCCCC;text-align:center;" readonly="true" value="desde <cfif rsRangoAnterior.TRDdesde EQ "">0<cfelse>#rsRangoAnterior.TRDdesde#</cfif> hasta #rsFormD.TRDhasta#">
					</cfif>
				<cfelse>
					<input name="TRDhasta" type="text" <cfif modoD NEQ "ALTA">style="border:1px solid ##CCCCCC;text-align:right;"<cfelse>tabindex="11"</cfif> id="TRDhasta2" size="15" maxlength="8" <cfif modoD NEQ "ALTA"> readonly="true"</cfif> value="<cfif modoD NEQ "ALTA">#rsFormD.TRDhasta#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				</cfif>			
			</td>
	      </tr>
		  <tr>
			<td><strong>Tarifa Fija o M&iacute;nimo</strong></td>
	      </tr>
		  <tr>
			<td nowrap>
				<input name="TRDtarifaFija" tabindex="11" style="text-align: right;" type="text" id="TRDtarifaFija" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.TRDtarifaFija#<cfelse>0.00</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				<cfif modoD NEQ 'ALTA' and rsRangoAnterior.TRDdesde NEQ "">&nbsp;&nbsp;<input type="button" value="Max Anterior" onclick="javascript:document.formTarifaCalculoRangos.TRDtarifaFija.value='#rsRangoAnterior.TRDmaximaAnterior#'"></cfif>
			</td>
	      </tr>
		  <tr>
			<td><strong>Tarifa Variable<cfif modoD NEQ 'ALTA' and rsRangoAnterior.TRDdesde NEQ ""> a partir de #rsRangoAnterior.TRDdesde#</cfif></strong><td>
	      </tr>		  
		  <tr>
			<td>
				<cfif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0 and qryConcTarifa.TCtipoCalculo EQ 'F'>
					<input name="TRDtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="TRDtarifaVariable" size="10" maxlength="8" value="0.00" readonly="true" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">				
				<cfelse>
					<input name="TRDtarifaVariable" tabindex="11" style="text-align: right;" type="text" id="TRDtarifaVariable2" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.TRDtarifaVariable#<cfelse>0.00</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">				
				</cfif>			
			</td>
	      </tr>
		  <tr>
			<td>&nbsp;</td>
	      </tr>		  
		  <tr>
			<td align="center">
				<cfif not isdefined('modoD')>
				  <cfset modoD = "ALTA">
				</cfif>
				
				<input type="hidden" name="botonSel" value="">
				
				<cfif modoD EQ "ALTA">
					<input type="submit" name="AltaD" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="LimpiarD" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="CambioD" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD(); ">
					<cfif rsFormD.TRDhasta NEQ "999999999999999">
							<input type="submit" name="BajaD" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
					</cfif>
					<cfif isdefined('qryConcTarifa') and qryConcTarifa.recordCount GT 0 and qryConcTarifa.TCtipoCalculo NEQ 'F'>
						<input type="submit" name="NuevoD" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
					</cfif>									
				</cfif>			
			</td>
	      </tr>		  		  		  
		</table>
	</cfoutput>		
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionD() {
		objFormDet.TRDhasta.required = false;
		objFormDet.TRDtarifaFija.required = false;	
		objFormDet.TRDtarifaVariable.required = false;			
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		<cfif modoD NEQ 'CAMBIO'>objFormDet.TRDhasta.required = true;</cfif>
		objFormDet.TRDtarifaFija.required = true;	
		objFormDet.TRDtarifaVariable.required = true;
	}		
//---------------------------------------------------------------------------------------		
	function quitaFormato() {
		var f = document.formTarifaCalculoRangos;
		<cfif modoD NEQ "ALTA">
			f.TRDRango.value = qf(f.TRDRango);
		</cfif>
		f.TRDhasta.value = qf(f.TRDhasta);
		f.TRDtarifaFija.value = qf(f.TRDtarifaFija);
		f.TRDtarifaVariable.value = qf(f.TRDtarifaVariable);		
	}			
//---------------------------------------------------------------------------------------	
	function formatea(){
		var f = document.formTarifaCalculoRangos;
		
		if(f.TRDhasta.value != '')	fm(f.TRDhasta,2);
		if(f.TRDtarifaFija.value != '')	fm(f.TRDtarifaFija,2);
		if(f.TRDtarifaVariable.value != '')	fm(f.TRDtarifaVariable,2);
	}	
//---------------------------------------------------------------------------------------
	// Se aplica al codigo del idioma 
	function __isValidaHasta() {		
		if(btnSelected("AltaD", this.obj.form)) {		
			if(this.value != '') {
				<cfif isdefined('qryHasta') and qryHasta.recordCount GT 0>
					var existeHasta = false;
		
					var ordenList = "<cfoutput>#ValueList(qryHasta.TRDhasta,'~')#</cfoutput>"
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
	objFormDet = new qForm("formTarifaCalculoRangos");
//---------------------------------------------------------------------------------------
	<cfif modoD NEQ 'CAMBIO'>
		objFormDet.TRDhasta.required = true;
		objFormDet.TRDhasta.description = "Hasta";		
		objFormDet.TRDhasta.validateValidaHasta();		
	</cfif>
			
	objFormDet.TRDtarifaFija.required = true;
	objFormDet.TRDtarifaFija.description = "Tarifa Fija";
	objFormDet.TRDtarifaVariable.required = true;
	objFormDet.TRDtarifaVariable.description = "Tarifa Variable";
	
	<cfif modoD NEQ 'ALTA'>
		formatea();	
	</cfif>	
</script>
