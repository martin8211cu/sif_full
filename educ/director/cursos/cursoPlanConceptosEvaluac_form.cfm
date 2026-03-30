<!--- Establecimiento del modoD --->
<cfif isdefined('modoD')>
	<cfset modoD=form.modoD>
<cfelse>
	<cfif isdefined("Form.CEcodigo") and Form.CEcodigo NEQ '' and isdefined("Form.PEcodigo") and Form.PEcodigo NEQ '' and isdefined("Form.Ccodigo") and Form.Ccodigo NEQ ''>
		<cfset modoD="CAMBIO">
	<cfelse>
		<cfset modoD="ALTA">
	</cfif>  
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
 	<cfquery name="rsFormDet" datasource="#session.DSN#">
		Select 
			convert(varchar,Ccodigo) as Ccodigo
			, convert(varchar,cce.PEcodigo) as PEcodigo
			, PEnombre
			, convert(varchar,cce.CEcodigo) as CEcodigo
			, CEnombre
			, convert(varchar,CCEporcentaje) as CCEporcentaje
			, convert(varchar,CCEorden) as CCEorden
		from CursoConceptoEvaluacion  cce
			, ConceptoEvaluacion ce
			, PeriodoEvaluacion pe
		where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			and cce.PEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
			and cce.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
			and ce.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and cce.CEcodigo=ce.CEcodigo
			and ce.Ecodigo=pe.Ecodigo
			and cce.PEcodigo=pe.PEcodigo
	</cfquery> 
</cfif>

<cfquery name="rsPeriodosEvaluac" datasource="#session.DSN#">
	select convert(varchar,cp.PEcodigo) as PEcodigo
		, PEnombre
	from CursoPeriodo cp
		, Curso c
		, PeriodoEvaluacion pe
	where cp.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and cp.Ccodigo=c.Ccodigo
		and cp.PEcodigo=pe.PEcodigo
		and c.Ecodigo=pe.Ecodigo
</cfquery>

<cfquery name="rsConceptoEvaluac" datasource="#session.DSN#">
	select CEcodigo,CEnombre
	from ConceptoEvaluacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by CEorden
</cfquery> 

<cfquery datasource="#Session.DSN#" name="rsDatosAct">
	Select 
		convert(varchar,cce.Ccodigo) as Ccodigo
		, convert(varchar,cce.PEcodigo) as PEcodigo
		, convert(varchar,cce.CEcodigo) as CEcodigo
		, CEnombre
		, convert(varchar,CCEporcentaje) as CCEporcentaje
		, convert(varchar,CCEorden) as CCEorden
	from  CursoConceptoEvaluacion cce
		, Curso c
		, ConceptoEvaluacion ce
	where cce.Ccodigo=<cfqueryparam value="#form.Ccodigo#" cfsqltype="cf_sql_numeric">
		and c.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
		and cce.Ccodigo=c.Ccodigo
--		and cce.PEcodigo=c.PEcodigo
		and c.Ecodigo=ce.Ecodigo
		and cce.CEcodigo=ce.CEcodigo
	order by PEcodigo,CCEorden		
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsDisponible">
	<!--- Todos menos el seleccionado --->
	select (100 - isnull(sum(CCEporcentaje),0.00)) as SumaPorc, PEcodigo
	from CursoConceptoEvaluacion
	where Ccodigo=<cfqueryparam value="#form.Ccodigo#" cfsqltype="cf_sql_numeric">
 	<cfif modoD NEQ "ALTA">
		and CEcodigo <> <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
	</cfif>	
	group by PEcodigo
	order by PEcodigo
</cfquery>

<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js">//</script>

<form action="Curso_SQL.cfm" method="post" name="formDetPlanEvaluacCurso">
	<cfoutput>
		<cfset listaPorcentajes = "">
		<cfif isdefined('rsDisponible') and rsDisponible.recordCount GT 0>
			<cfloop query="rsDisponible">
				<cfif listaPorcentajes NEQ ''>
					<cfset listaPorcentajes = listaPorcentajes & "," & rsDisponible.SumaPorc & "~" & rsDisponible.PEcodigo>				
				<cfelse>
					<cfset listaPorcentajes = listaPorcentajes & rsDisponible.SumaPorc & "~" & rsDisponible.PEcodigo>
				</cfif>
			</cfloop>
		</cfif>
	
		<input type="hidden" name="Disponible" value="<cfif isdefined('listaPorcentajes') and listaPorcentajes NEQ "">#listaPorcentajes#</cfif>">
		<input type="hidden" name="Ccodigo" value="<cfif isdefined('form.Ccodigo')>#form.Ccodigo#</cfif>">
		<input type="hidden" name="modoD" value="#modoD#">			
		<cfif isdefined("form.CILtipoCicloDuracion")>
			<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
			<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
			<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
			<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
			<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
			<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
			<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
			<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
			<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
		</cfif>		
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" class="tituloMantenimiento">
		<cfif modoD EQ "ALTA">Nuevo <cfelse>Modificar </cfif> Concepto</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Per&iacute;odo:</strong> </td>
		<td>&nbsp;</td>
		<td><input name="PEnombre" type="text" id="PEnombre" readonly="true" class="cajasinbordeb" value="<cfif modoD NEQ 'ALTA'>#rsFormDet.PEnombre#</cfif>"></td>		
	  </tr> 	   
	  <tr>
		<td width="36%" nowrap align="right"> <strong>Conceptos de Evaluaci&oacute;n:</strong></td>
		<td width="2%">&nbsp;</td>
		<td width="62%">
			<cfset quitarPeriodos = "">
			<cfif isdefined('rsDatosAct') and rsDatosAct.recordCount GT 0>
				<cfset sumaPorcen = 0>	
				<cfset periodoAux = "">			

				<cfloop query="rsDatosAct">
					<cfif periodoAux NEQ rsDatosAct.PEcodigo>
						<cfset sumaPorcen = 0>			
						<cfset periodoAux = rsDatosAct.PEcodigo>
					</cfif>
					
					<cfset sumaPorcen = sumaPorcen + rsDatosAct.CCEporcentaje>

					<cfif sumaPorcen GE 100>
						<cfif quitarPeriodos NEQ ''>
							<cfset quitarPeriodos = quitarPeriodos & ',' & periodoAux>
						<cfelse>
							<cfset quitarPeriodos = periodoAux>
						</cfif>					
						
						<cfset sumaPorcen = 0>									
					</cfif>
				</cfloop>
			</cfif>

			<cfquery dbtype="query" name="qryPeriodos">
				select PEcodigo,PEnombre
				from rsPeriodosEvaluac
				<cfif isdefined('quitarPeriodos') and quitarPeriodos NEQ ''>
					where PEcodigo not in ('#quitarPeriodos#')						
				</cfif>
				order by PEcodigo
			</cfquery>

			<cfset sumaConcep = 0>	
			<cfset periodoAux = "">

			<cfloop query="qryPeriodos">
				<cfif periodoAux NEQ qryPeriodos.PEcodigo>
					<cfif sumaConcep EQ rsPeriodosEvaluac.recordCount>
						<cfset quitarPeriodos = quitarPeriodos & periodoAux & ','>
					</cfif>
					
					<cfset sumaConcep = 0>			
					<cfset periodoAux = qryPeriodos.PEcodigo>
				</cfif>
				
				<cfset sumaConcep = sumaConcep + 1>			
			</cfloop>

			<cfquery dbtype="query" name="qryPeriodos_OK">
				select PEcodigo,PEnombre
				from qryPeriodos
				<cfif isdefined('quitarPeriodos') and quitarPeriodos NEQ ''>
					where PEcodigo not in ('#quitarPeriodos#')		
				</cfif>				
			</cfquery>
			
			<cfif modoD NEQ "ALTA">
				#rsFormDet.CEnombre#
				<input type="hidden" name="CEcodigo" id="CEcodigo" value="#rsFormDet.CEcodigo#">
				<input type="hidden" name="PEcodigo" id="PEcodigo" value="#rsFormDet.PEcodigo#">			
			<cfelse>
				<cfset CodPeriodo = "">
				<cfset DescrPeriodo = "">
				<input type="hidden" name="CEcodigo" id="CEcodigo" value="">
				<input type="hidden" name="PEcodigo" id="PEcodigo" value="">			
				
			  <select name="cb_CEcodigo" id="cb_CEcodigo" onChange="javascript: cambioPerConc(this);">
				<cfloop query="qryPeriodos_OK">
					<cfset CodPeriodo = qryPeriodos_OK.PEcodigo>
					<cfset DescrPeriodo = qryPeriodos_OK.PEnombre>					
					<optgroup label="#qryPeriodos_OK.PEnombre#">
						<cfif isdefined('rsDatosAct') and rsDatosAct.recordCount GT 0>
							<cfquery dbtype="query" name="qryConcep">
								Select CEcodigo, CEnombre
								from rsDatosAct
								where PEcodigo = <cfqueryparam value="#CodPeriodo#" cfsqltype="cf_sql_varchar">
							</cfquery>
							
							<cfif isdefined('qryConcep') and qryConcep.recordCount GT 0>
								<cfquery dbtype="query" name="qryConcep_Add">
									Select CEcodigo, CEnombre
									from rsConceptoEvaluac
									where CEcodigo not in (#ValueList(qryConcep.CEcodigo)#)
								</cfquery>
												
								<cfif isdefined('qryConcep_Add') and qryConcep_Add.recordCount GT 0>
									<cfloop query="qryConcep_Add">
										<option value="#CodPeriodo#~#DescrPeriodo#~#qryConcep_Add.CEcodigo#">#qryConcep_Add.CEnombre#</option>
									</cfloop>
								</cfif>
							<cfelse>					
								<cfloop query="rsConceptoEvaluac">
									<option value="#CodPeriodo#~#DescrPeriodo#~#rsConceptoEvaluac.CEcodigo#">#rsConceptoEvaluac.CEnombre#</option>
								</cfloop>					
							</cfif>
						<cfelse>
							<cfloop query="rsConceptoEvaluac">
								<option value="#CodPeriodo#~#DescrPeriodo#~#rsConceptoEvaluac.CEcodigo#">#rsConceptoEvaluac.CEnombre#</option>
							</cfloop>					
						</cfif>
					</optgroup>
				</cfloop> 		  
			  </select>
		  </cfif>
		</td>
	  </tr>	  
	  <tr>
		<td width="36%" align="right"><strong>Porcentaje:</strong></td>
		<td width="2%">&nbsp;</td>
		<td width="62%">
			<input name="CCEporcentaje" type="text" id="CCEporcentaje" style="text-align: right;" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2) "  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoD NEQ "ALTA"><cfoutput>#rsFormDet.CCEporcentaje#</cfoutput></cfif>" size="10" maxlength="6" tabindex="4" > % 
		</td>
	  </tr>	  
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr> 	  
	  <tr>
		<td colspan="3" align="center">
			<cfif not isdefined('modoD')>
				<cfset modoD = "ALTA">
			</cfif>
			<input type="hidden" name="botonSel" value="">			
			
			<cfif modoD EQ "ALTA">
				<input tabindex="6" type="submit" name="AltaD" value="Agregar" onClick="javascript: document.formDetPlanEvaluacCurso.botonSel.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet();">
			<cfelse>	
				<input tabindex="6" type="submit" name="CambioD" value="Modificar" onClick="javascript: document.formDetPlanEvaluacCurso.botonSel.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet(); ">
				<input tabindex="7" type="submit" name="BajaD" value="Eliminar" onclick="javascript: document.formDetPlanEvaluacCurso.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Concepto?') ){ if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); return true; }else{ return false;}">
				<input tabindex="8" type="submit" name="NuevoD" value="Nuevo" onClick="javascript: document.formDetPlanEvaluacCurso.botonSel.value = this.name; if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); ">
			</cfif>			
		</td>
	  </tr>  	  
	</table>
</cfoutput>	
</form>

<script language="JavaScript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//---------------------------------------------------------------------------------------			
	function cambioPerConc(obj){
		if(obj.value != ''){
			var cods = obj.value.split('~');
			
			document.formDetPlanEvaluacCurso.PEcodigo.value = cods[0];
			document.formDetPlanEvaluacCurso.PEnombre.value = cods[1];										
			document.formDetPlanEvaluacCurso.CEcodigo.value = cods[2];
		}else{
			document.formDetPlanEvaluacCurso.PEcodigo.value = '';
			document.formDetPlanEvaluacCurso.PEnombre.value = '';
			document.formDetPlanEvaluacCurso.CEcodigo.value = '';
		}
	}
//---------------------------------------------------------------------------------------		
	function __isPorcentaje() {
		// Valida que el porcentaje se encuentre entre el rango permitido
		if(btnSelected("AltaD",document.formDetPlanEvaluacCurso) || btnSelected("CambioD",document.formDetPlanEvaluacCurso)) {
			var arrPorcenXPer = this.obj.form.Disponible.value.split(',');
			var arrDetalle = null;
			
			for(var i=0;i < arrPorcenXPer.length ; i++){
				arrDetalle = arrPorcenXPer[i].split('~');
				
				if(arrDetalle[1] == this.obj.form.PEcodigo.value){
					if (new Number(qf(arrDetalle[0])) == 0 && new Number(qf(this.value)) > 0) {
						this.error = "El porcentaje solamente puede ser 0";
						this.obj.focus();
					} else if (new Number(qf(this.value)) < 0 || new Number(qf(this.value)) > new Number(qf(arrDetalle[0]))) {
						this.error = "El porcentaje no puede ser menor a 0 ni mayor que " + arrDetalle[0];
						this.obj.focus();
					}					
				}
			}
		}
	}	
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacionDet() {
		objFormDet.CEcodigo.required = false;
		objFormDet.CCEporcentaje.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionDet() {
		objFormDet.CEcodigo.required = true;
		objFormDet.CCEporcentaje.required = true;				
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isPorcentaje", __isPorcentaje);
	objFormDet = new qForm("formDetPlanEvaluacCurso");
//---------------------------------------------------------------------------------------
	objFormDet.CEcodigo.required = true;
	objFormDet.CEcodigo.description = "Concepto de Evaluación";
	objFormDet.CCEporcentaje.required = true;
	objFormDet.CCEporcentaje.description = "Porcentaje";
	objFormDet.CCEporcentaje.validatePorcentaje();
	<cfif modoD EQ "ALTA">
		cambioPerConc(document.formDetPlanEvaluacCurso.cb_CEcodigo)
	</cfif>
</script>
