<!--- 	<cfdump var="#form#"> --->

	<cfif isdefined("Form.CEVcodigo") and Len(Trim(Form.CEVcodigo)) NEQ 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>

	<!--- Tablas de Evaluaciones --->
	<cfquery datasource="#Session.DSN#" name="rsTablaEvaluacion">
		select 	convert(varchar,TEcodigo) as TEcodigo,
				TEnombre, TEtipo
		from TablaEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	
	<!--- Averiguar si hay evaluaciones Automáticas --->
	<cfquery name="rsCantidad" datasource="#Session.DSN#">
		select 1
		from CursoEvaluacion
		where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
		and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and CEVtipoPeso = 'A'
		<cfif modo EQ 'CAMBIO'>
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">		
			and CEVcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVcodigo#">
		</cfif>
	</cfquery>

	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select a.CEcodigo, b.CEnombre, a.CCEporcentaje
		from CursoConceptoEvaluacion a, ConceptoEvaluacion b
		where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
		and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and a.CEcodigo = b.CEcodigo
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by a.CCEorden
	</cfquery> 	

	<cfquery name="rsManuales" datasource="#Session.DSN#">
		select isnull(sum(CEVpeso), 0) as peso
		from CursoEvaluacion
		where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
		and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and CEVtipoPeso = 'M'
		<cfif modo EQ 'CAMBIO'>
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">		
			and CEVcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVcodigo#">
		</cfif>
	</cfquery>
	
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsEvaluacion" datasource="#Session.DSN#">
			Select 
				ce.CEcodigo,CEnombre,CEVcodigo, CEVnombre, CEVdescripcion, CEVpeso, CEVtipoPeso, CEVtipoCalificacion, CEVpuntosMax, CEVunidadMin, CEVredondeo, TEcodigo, 
				convert(varchar, CEVfechaPlan, 103) as FechaPlaneada, convert(varchar, CEVfechaReal, 103) as FechaReal, CEVleccion, CEVorden, CEVestado
			from CursoEvaluacion ce
				, CursoConceptoEvaluacion cce
				, ConceptoEvaluacion cev
			where	CEVcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVcodigo#">
				and ce.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and ce.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ce.CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and ce.Ccodigo=cce.Ccodigo
				and ce.PEcodigo=cce.PEcodigo
				and ce.CEcodigo=cce.CEcodigo
				and cce.CEcodigo=cev.CEcodigo
		</cfquery>
	</cfif>

	<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
	<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/JavaScript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		<cfoutput>
		function irLista() {
			document.frmAlta.Ccodigo.value = '#Form.Ccodigo#';
			document.frmAlta.PEcodigo.value = '#Form.PEcodigo#';
			document.frmAlta.CEcodigo.value = '#Form.CEcodigo#';
			document.frmAlta.submit();
		}
		</cfoutput>
		
	</script>

	<cfoutput>
		<form name="frmEvaluacion" method="post" action="planificacion-sql.cfm" onSubmit="javascript: return valida(this);">
			<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
				<input type="hidden" name="Ccodigo" value="#Form.Ccodigo#">
			</cfif>
			<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
				<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
			</cfif>
			<cfif isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>
				
			</cfif>
			<cfif modo EQ 'CAMBIO'>
				<input type="hidden" name="CEVcodigo" value="#rsEvaluacion.CEVcodigo#">
			</cfif>
			<input type="hidden" name="peso" value="#rsManuales.peso#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td class="etiqueta" align="right" width="20%" nowrap>Concepto de Evaluaci&oacute;n: </td>
				<td nowrap>
					<cfif modo EQ 'ALTA'>
						<select name="CEcodigo" id="CEcodigo">
							<cfloop query="rsConceptos">
								<option value="#rsConceptos.CEcodigo#" <cfif modo EQ 'CAMBIO' and rsConceptos.CEcodigo EQ rsEvaluacion.CEcodigo> selected</cfif>>#rsConceptos.CEnombre# (#rsConceptos.CCEporcentaje# %)</option>
							</cfloop>
						</select>			
					<cfelse>
						<input type="hidden" name="CEcodigo" value="#rsEvaluacion.CEcodigo#">
						#rsEvaluacion.CEnombre#
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" width="20%" nowrap>Nombre: </td>
				<td nowrap>
					<input name="CEVnombre" type="text" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsEvaluacion.CEVnombre#</cfif>" style="width: 100%;">
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" valign="top" align="right" nowrap>Descripci&oacute;n: </td>
				<td nowrap>
					<textarea name="CEVdescripcion" style="width: 100%" rows="4"><cfif modo EQ 'CAMBIO'>#rsEvaluacion.CEVdescripcion#</cfif></textarea>
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" nowrap>Peso: </td>
				<td nowrap>
					<select name="CEVtipoPeso" onChange="javascript: habilitarPeso(this);">
					  <option value="A"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVtipoPeso EQ 'A'> selected</cfif>>Autom&aacute;tica</option>
					  <!--- Solo se muestra si ya hay evaluaciones guardadas --->
					  <cfif rsCantidad.recordCount GT 0>
					  <option value="M"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVtipoPeso EQ 'M'> selected</cfif>>Manual</option>
					  </cfif>
					</select>
					<input name="CEVpeso" type="text" id="CEVpeso" size="6" maxlength="6"  value="<cfif modo EQ 'CAMBIO'>#rsEvaluacion.CEVpeso#</cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" nowrap>Tipo de Calificaci&oacute;n: </td>
				<td nowrap>
					<select name="CEVtipoCalificacion" id="CEVtipoCalificacion" onChange="javascript: cambioTipoCalificacion(this);"
						<cfif modo NEQ 'ALTA' and rsEvaluacion.CEVestado EQ 2>
							disabled						
						</cfif>
					>
						<option value="1"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVtipoCalificacion EQ '1'> selected<cfelseif modo EQ 'ALTA' and rsCurso.CtipoCalificacion EQ 1> selected</cfif>>Porcentaje</option>
						<option value="2"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVtipoCalificacion EQ '2'> selected<cfelseif modo EQ 'ALTA' and rsCurso.CtipoCalificacion EQ 2> selected</cfif>>Puntaje</option>
						<option value="T"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVtipoCalificacion EQ 'T'> selected<cfelseif modo EQ 'ALTA' and rsCurso.CtipoCalificacion EQ 'T'> selected</cfif>>Tabla de Evaluación</option>
				  	</select>
				</td>
			  </tr>
			  <tr>
				<td nowrap>&nbsp;</td>
				<td height="25" nowrap>
					<div style="margin: 0;" id="verTipoCalifica">
						Puntaje M&aacute;ximo 
						<input name="CEVpuntosMax" type="text" id="CEVpuntosMax" size="6" maxlength="6"  value="<cfif modo EQ 'CAMBIO'>#rsEvaluacion.CEVpuntosMax#<cfelse>#rsCurso.CpuntosMax#</cfif>" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
						Unidad M&iacute;nima 
						<input name="CEVunidadMin" type="text" id="CEVunidadMin" size="6" maxlength="6"  value="<cfif modo EQ 'CAMBIO'>#rsEvaluacion.CEVunidadMin#<cfelse>#rsCurso.CunidadMin#</cfif>" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
						Redondeo 
						<select name="CEVredondeo" id="CEVredondeo">
							<option value="0"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVredondeo EQ 0> selected<cfelseif modo EQ 'ALTA' and rsCurso.Credondeo EQ 0> selected</cfif>>Al más cercano</option>
							<option value="0.499"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVredondeo EQ 0.499> selected<cfelseif modo EQ 'ALTA' and rsCurso.Credondeo EQ 0.499> selected</cfif>>Hacia arriba</option>
							<option value="-0.499"<cfif modo EQ 'CAMBIO' and rsEvaluacion.CEVredondeo EQ -0.499> selected<cfelseif modo EQ 'ALTA' and rsCurso.Credondeo EQ -0.499> selected</cfif>>Hacia abajo</option>
						</select>
					</div>
					<div style="margin: 0;" id="verTablaEval"> Tabla de Evaluaci&oacute;n 
						<select name="TEcodigo">
							<cfloop query="rsTablaEvaluacion"> 
							<option value="#rsTablaEvaluacion.TEcodigo#"<cfif modo EQ 'CAMBIO' and rsEvaluacion.TEcodigo EQ rsTablaEvaluacion.TEcodigo><cfelseif modo EQ 'ALTA' and rsTablaEvaluacion.TEcodigo EQ rsCurso.TEcodigo> selected</cfif>>#rsTablaEvaluacion.TEnombre#</option>
							</cfloop> 
						</select>
					</div>
			  	</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" nowrap>Fecha Planeada: </td>
				<td nowrap>
					<cfif modo EQ "CAMBIO">
						<cfset FPlaneada = rsEvaluacion.FechaPlaneada>
					<cfelse>
						<cfset FPlaneada = "">
					</cfif>
					<cf_sifcalendario form="frmEvaluacion" name="CEVfechaPlan" value="#FPlaneada#">
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" nowrap>Fecha Real: </td>
				<td nowrap>
					<cfif modo EQ "CAMBIO">
						<cfset FReal = rsEvaluacion.FechaReal>
					<cfelse>
						<cfset FReal = "">
					</cfif>
					<cf_sifcalendario form="frmEvaluacion" name="CEVfechaReal" value="#FReal#">
				</td>
			  </tr>
			  <tr>
				<td class="etiqueta" align="right" nowrap>Estado: </td>
				<td nowrap>
					<cfif modo EQ 'ALTA'>
						<select name="CEVestado" id="CEVestado">
						  <option value="1">Activo</option>						
						  <option value="0">Inactivo</option>
						</select>
					<cfelse>
						<cfif rsEvaluacion.CEVestado EQ 2>
							Cerrado
							<input type="hidden" name="CEVestado" value="2">
						<cfelse>
							<select name="CEVestado" id="CEVestado">
							  <option value="1"<cfif rsEvaluacion.CEVestado EQ 1> selected</cfif>>Activo</option>						
							  <option value="0"<cfif rsEvaluacion.CEVestado EQ 0> selected</cfif>>Inactivo</option>
							</select>					
						</cfif>
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center" nowrap>&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center" nowrap>
					<cfset mensajeDelete = "¿Está seguro de que desea eliminar la evaluación?">
					<cfinclude template="/educ/portlets/pBotones.cfm">
					<input type="button" name="btnLista" value="Lista de Evaluaciones" onClick="javascript: irLista();">
				</td>
			  </tr>
			</table>
		</form>
		<form name="frmAlta" method="post" style="margin: 0; " action="#GetFileFromPath(GetTemplatePath())#">
			<input type="hidden" name="Ccodigo" value="">
			<input type="hidden" name="PEcodigo" value="">
			<input type="hidden" name="CEcodigo" value="">
		</form>
	</cfoutput>

	<script language="javascript" type="text/javascript">
		<cfoutput>
			function valida(f) {
				if(btnSelected('Baja', document.frmEvaluacion)){
					if (#rsCantidad.recordCount# == 0 && #rsManuales.peso# > 0) { 
						alert('No se puede eliminar. Debe haber al menos una evaluación con peso automático');
						return false;
					}
				}
				
				if(document.frmEvaluacion.CEVtipoCalificacion.disabled)
					document.frmEvaluacion.CEVtipoCalificacion.disabled = false;
				
				return true;			
			}
		</cfoutput>
	
		function habilitarPeso(obj) {
			if (obj.value == 'M') {
				objForm.CEVpeso.required = true;
				obj.form.CEVpeso.readonly = false;
			}
			else {
				objForm.CEVpeso.required = false;
				obj.form.CEVpeso.value = "";
				obj.form.CEVpeso.readonly = true;
			}
		}
		
		function habilitarTipoCalificacion(obj) {
			if (obj.value == '1') {
				objForm.CEVpuntosMax.required = false;
				objForm.CEVunidadMin.required = false;
				objForm.CEVredondeo.required = false;
				objForm.TEcodigo.required = false;
			} else if (obj.value == '2') {
				objForm.CEVpuntosMax.required = true;
				objForm.CEVunidadMin.required = true;
				objForm.CEVredondeo.required = true;
				objForm.TEcodigo.required = false;
			} else if (obj.value == 'T') {
				objForm.CEVpuntosMax.required = false;
				objForm.CEVunidadMin.required = false;
				objForm.CEVredondeo.required = false;
				objForm.TEcodigo.required = true;
			}
		}
	
		function cambioTipoCalificacion(obj) {
			var connverTipoCalifica = document.getElementById("verTipoCalifica");
			var connverTablaEval = document.getElementById("verTablaEval");
			
			if (obj.value == '1') {
				obj.form.CEVpuntosMax.value = "100";
				obj.form.CEVunidadMin.value = "0.01";
				obj.form.CEVredondeo.value = "0";
			}
			if (obj.value == '2')
				connverTipoCalifica.style.display = "";
			else
				connverTipoCalifica.style.display = "none";
			if (obj.value == 'T')
				connverTablaEval.style.display = "";
			else
				connverTablaEval.style.display = "none";
			habilitarTipoCalificacion(obj);
		}
		
		function __isPeso() {
			// Valida que el peso sea mayor a 0 y menor o igual que 100
			if (new Number(qf(this.value)) <= 0 || new Number(qf(this.value)) > 100) {
				this.error = "El Peso no puede ser menor o igual que cero ni mayor a cien";
			}
			// Valida que el peso de una evaluacion de peso manual + suma de evaluaciones de peso manual
			// no sea mayor o igual a 100
			if (this.obj.form.CEVtipoPeso.value == 'M' && (parseInt(qf(this.value), 10)+parseInt(this.obj.form.peso.value)) >= 100) {
				this.error = "Cuando el Peso de las evaluaciones es de tipo Manual, éste no debe superar ni ser igual a 100";
			}
		}

		qFormAPI.errorColor = "#FFFFCC";
		_addValidator("isPeso", __isPeso);
		objForm = new qForm("frmEvaluacion");
		
		objForm.CEVnombre.required = true;
		objForm.CEVnombre.description = "Nombre";
		objForm.CEVpeso.required = true;
		objForm.CEVpeso.description = "Peso";
		objForm.CEVpeso.validatePeso();
		objForm.CEVfechaPlan.required = true;
		objForm.CEVfechaPlan.description = "Fecha Planeada";

		objForm.CEVpuntosMax.description = "Puntaje Máximo";
		objForm.CEVunidadMin.description = "Unidad Mínima";
		objForm.CEVredondeo.description = "Redondeo";
		objForm.TEcodigo.description = "Tabla de Evaluación";

		cambioTipoCalificacion(document.frmEvaluacion.CEVtipoCalificacion);
		habilitarPeso(document.frmEvaluacion.CEVtipoPeso);
	</script>
	
