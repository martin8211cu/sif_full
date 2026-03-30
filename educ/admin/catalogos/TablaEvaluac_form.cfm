<cfif isdefined("Form.Valor")>
	<cfset Form.TEVvalor = Form.Valor>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.btnNuevo")>
	<cfset modo="ALTA">
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("Form.TEVvalor")>
	<cfset modo="CAMBIO">
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.TEVvalor")>
		<cfset modoDet="ALTA">
	<cfelseif Form.modoDet EQ "CAMBIO">
		<cfset modoDet="CAMBIO">
	<cfelse>
		<cfset modoDet="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->

<!--- 1. Form --->
<cfquery datasource="#Session.DSN#" name="rsForm">
	select TEnombre, TEtipo, TEmas100, ts_rversion
	from TablaEvaluacion	
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	<cfif isdefined("Form.TEcodigo") AND #Form.TEcodigo# NEQ "" >
		and TEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEcodigo#">
	</cfif>
</cfquery>

<cfif isdefined("Form.TEcodigo") AND #Form.TEcodigo# NEQ "" >
	<cfquery datasource="#Session.DSN#" name="rsCual_Valor">
		Select rtrim(TEVvalor) as TEVvalor, TEVdescripcion, str(TEVequivalente,5,2) as TEVequivalente
		from TablaEvaluacionValor
		where TEcodigo= <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
		<cfif isdefined("Form.TEVvalor") and Form.TEVvalor NEQ "">
			and TEVvalor !=<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfquery>
</cfif>
<!--- Seccion del detalle --->
<cfif modo NEQ 'ALTA'>
	<cfif isdefined("Form.TEcodigo") and Form.TEcodigo NEQ "" and isdefined("Form.TEVvalor") and Form.TEVvalor NEQ "" >
		<!--- 1. Form --->	
		<cfquery datasource="#Session.DSN#" name="rsFormDetalle">
			Select convert(varchar, TEcodigo) as TEcodigo, rtrim(ltrim(TEVvalor)) as TEVvalor, rtrim(ltrim(TEVnombre)) as TEVnombre, 
			TEVdescripcion, str(TEVequivalente,5,2) as TEVequivalente,  ts_rversion
			from TablaEvaluacionValor
			where TEcodigo= <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			and TEVvalor=<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cfif>
</cfif>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function irALista() {
		location.href="tablaEvaluac.cfm";
	}

	function TraeEquiv(dato1, TEcodigo,dato2) {
		if (dato1!="") {
			//document.all["FrEquiv"].src="validaequiv.cfm?TEcodigo="+TEcodigo+"&TEVequivalente="+dato+"&modo="+'<cfoutput>#modoDet#</cfoutput>';
			document.all["FrEquiv"].src="validaequiv.cfm?TEcodigo="+TEcodigo+"&TEVequivalente="+dato1+"&TEVvalor="+dato2+"&modo="+'<cfoutput>#modoDet#</cfoutput>';		
		}
		return;
	}

	function valValorEquiv(dato1, dato2, dato3) {
		if (dato!="") {
			document.all["FrEquiv"].src="validaequiv.cfm?TEcodigo="+dato3+"&TEVequivalente="+dato1+"&TEVvalor="+dato2+"&modo="+'<cfoutput>#modoDet#</cfoutput>';
		}
		return;
	}

</script>
<script language="JavaScript" type="text/javascript">
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
</script>

<form name="form1" method="post" action="TablaEvaluac_sql.cfm">
  <input type="hidden" id="TEcodigo" name="TEcodigo" value="<cfif isdefined('form.TEcodigo') and form.TEcodigo NEQ ''><cfoutput>#Form.TEcodigo#</cfoutput></cfif>">
  <input type="hidden" id="ExisteTEVvalor" name="ExisteTEVvalor" value="">
    <input type="hidden" id="ExisteTEVequivalente" name="ExisteTEVequivalente" value="">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td <cfif modo NEQ "ALTA">colspan="2" </cfif>class="tituloMantenimiento"><cfif modo EQ "ALTA">Nueva <cfelse>Modificar </cfif>Tabla de Evaluaci&oacute;n</td>
    </tr>
    <tr> 
		<td <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top">
			<table width="100%" cellpadding="2" cellspacing="2" border="0">
				<tr>
				  <td align="right" nowrap>Descripci&oacute;n</td>
				  <td nowrap><input name="TEnombre" type="text" id="TEnombre" size="40" tabindex="1" maxlength="80" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.TEnombre#</cfoutput></cfif>"></td>
				</tr>
				<tr>
				  <td align="right" nowrap>Tipo de Redondeo</td>
				  <td>
					<select name="TEtipo" id="TEtipo" tabindex="1">
					  <option value="0" <cfif modo NEQ 'ALTA' and #rsForm.TEtipo# EQ 0>selected</cfif>>El m&aacute;s cercano</option>
					  <option value="1" <cfif modo NEQ 'ALTA' and #rsForm.TEtipo# EQ 1>selected</cfif>>Hacia arriba</option>
					  <option value="2" <cfif modo NEQ 'ALTA' and #rsForm.TEtipo# EQ 2>selected</cfif>>Hacia abajo</option>
					</select>&nbsp;&nbsp;&nbsp;
					Acepta más del 100%&nbsp;<input name="TEmas100" type="checkbox" id="TEmas100" value="1" <cfif modo NEQ 'ALTA' AND rsForm.TEmas100 EQ 1>checked</cfif>>
				  </td>
				  <td align="right">
						<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">				  
				  </td>
				</tr>
			</table>
		</td>
	</tr>
    <tr> 
   	  <td nowrap <cfif modo NEQ "ALTA">colspan="2" </cfif>align="center"> 
			<cfif modo EQ "ALTA">
				<input type="submit" name="btnAgregarE" tabindex="1" value="Agregar" onClick="javascript: setBtn(this); " > 
			<cfelseif modo NEQ "ALTA">
				<input type="submit" name="btnCambiarE" tabindex="1" value="Modificar Tabla" onClick="javascript: setBtn(this); deshabilitarDetalle(); habilitarValidacion(); " >
				<input type="submit" name="btnBorrarE" tabindex="1" value="Borrar Tabla" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('¿Esta seguro(a) que desea borrar esta tabla de evaluación ?')" > 
				<input type="submit" name="btnNuevoE" tabindex="1" value="Nueva Tabla" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle();">

				<cfset ts2 = "">	
				<cfinvoke 
					component="educ.componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts2">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
				</cfinvoke>
			<input type="hidden" name="timestampE" value="<cfoutput>#ts2#</cfoutput>">


			</cfif>
            <input type="button" name="btnLista"  tabindex="1" value="Lista de Tablas de Evaluación" onClick="javascript: irALista();">
		</td>
    </tr>
	<cfif modo NEQ "ALTA">
	<tr>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td width="50%" valign="top">
<!---		Lista de detalle -- <cfdump var="#modo#"> -- <cfdump var="#form.TEcodigo#"> --->
			<cfinvoke 
			 component="educ.componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaTabEvalDet">
				<cfinvokeargument name="tabla" value="TablaEvaluacionValor a,TablaEvaluacion b"/>
				<cfinvokeargument name="columnas" value="TEVnombre as Nombre,TEVvalor as Valor,str(TEVequivalente,6,2)+'%' as Equivalencia, str(TEVminimo,7,3)+'%' as Minimo, str(TEVmaximo,7,3)+'%' as Maximo"/>
				<cfinvokeargument name="desplegar" value="Valor,Nombre,Minimo,Maximo,Equivalencia"/>
				<cfinvokeargument name="etiquetas" value="Valor,Nombre,De&nbsp;&nbsp;,A&nbsp;&nbsp;,Equivale&nbsp;a"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.TEcodigo=b.TEcodigo and a.TEcodigo = #form.TEcodigo# order by convert(numeric, a.TEVequivalente) desc" />
				<cfinvokeargument name="align" value="left,left,right,right,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="tablaEvaluac.cfm"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke> 	
		</td>
		<td width="50%" valign="top" style="padding-left: 10px">
			<table border="0" width="100%" cellpadding="2" cellspacing="2">
				<tr>
					<td align="right" nowrap>Valor:</td>
					<td nowrap>
						<cfoutput>
							<input name="TEVvalor" type="text" id="TEVvalor" tabindex="3" size="10" maxlength="3" <cfif modoDet NEQ 'ALTA'>readonly="true"</cfif> value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>#rsFormDetalle.TEVvalor#</cfif>">
							<input type="hidden" name="Cual_Valor"  value="#ValueList(rsCual_Valor.TEVvalor)#,">
							<input type="hidden" name="Cual_Equivalencia1"  value="#ValueList(rsCual_Valor.TEVequivalente)#,"> 
						</cfoutput>
					</td>
				</tr>
				<tr>
                  <td height="28" align="right" nowrap>Nombre:</td>
                  <td nowrap><input name="TEVnombre" type="text" id="TEVnombre" tabindex="3" size="35" maxlength="255"  onfocus="javascript:this.select();" value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0><cfoutput>#rsFormDetalle.TEVnombre#</cfoutput></cfif>">
                  </td>
			  </tr>
				<tr>
					
                <td height="28" align="right" valign="top" nowrap>Descripci&oacute;n:</td>
				<td nowrap>
					<textarea name="TEVdescripcion" tabindex="3" rows="5" onfocus="javascript:this.select();" style="width: 100%"><cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0><cfoutput>#rsFormDetalle.TEVdescripcion#</cfoutput></cfif></textarea>
				 </td>
			    </tr>
				<tr>
					<td align="right" nowrap>Equivalencia:</td>
				  <td nowrap><input name="TEVequivalente" type="text" id="TEVequivalente" tabindex="3" size="10" maxlength="6"  value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0><cfoutput>#rsFormDetalle.TEVequivalente#</cfoutput></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
					  <strong>%</strong></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<cfif modoDet EQ "ALTA">
							<input type="submit" name="btnAgregarD" tabindex="4" value="Agregar Valor" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion(); " > 
						<cfelseif modoDet NEQ "ALTA" and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>
							<cfset ts = "">	
							<cfinvoke 
								component="educ.componentes.DButils"
								method="toTimeStamp"
								returnvariable="ts">
								<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.ts_rversion#"/>
							</cfinvoke>
							<input type="hidden" name="timestampD" value="<cfif modo NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0><cfoutput>#ts#</cfoutput></cfif>">
							
							<input type="submit" name="btnCambiarD" tabindex="4" value="Modificar Valor" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion();" > 
							<input type="submit" name="btnBorrarD" tabindex="4" value="Borrar Valor" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('¿Esta seguro(a) que desea borrar este valor?')" > 
							<input type="submit" name="btnNuevoD" tabindex="4" value="Nuevo Valor" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion();" >	
						</cfif>
					</td>
				</tr>
			</table>
		</td>
    </tr>
	</cfif>
  </table>
  <!---  Este Iframe funciona, pero solo tiene la inconveniencia de que si el usuario no hace el onblur, no funciona. --->
  <iframe name="FrEquiv" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="validaequiv.cfm" ></iframe>
</form>

<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript">
	
	function deshabilitarValidacion() {
		objForm.TEnombre.required = false;
		objForm.TEVvalor.required = false;
		objForm.TEVequivalente.required = false
	}
	
	function habilitarValidacion() {
		objForm.TEnombre.required = true;
	}	
	
	function deshabilitarDetalle() {
		objForm.TEVvalor.required = false;
		objForm.TEVnombre.required = false;
		objForm.TEVequivalente.required = false;
	}

	function habilitarDetalle() {
		objForm.TEVvalor.required = true;
		objForm.TEVnombre.required = true;
		objForm.TEVequivalente.required = true;
	}

	function __isValidaEquivalencia() {		
		if(btnSelected("btnAgregarD") || btnSelected("btnCambiarD")) {
			// Valida que la equivalencia se encuentre entre el rango permitido
			
			if(this.obj.form.TEVequivalente.value != ''){
				if (new Number(qf(this.obj.form.TEVequivalente.value)) < 0 || (!this.obj.form.TEmas100.checked && new Number(qf(this.obj.form.TEVequivalente.value)) > 100)) {
					this.error = "Equivalencia incorrecta, el rango sugerido es: mayor que cero y menor o igual que 100";
					//this.obj.form.TEVequivalente.focus();
				}
			}
		}
	}
	
	function __isValidaValor() {	
		//alert(this.obj.form.ExisteTEVvalor.value);
		if (this.obj.form.ExisteTEVvalor.value == 'S')  {
			this.error = "Valor incorrecto, Ya existe el valor en la Tabla de Evaluacion!";
			//this.obj.form.TEVvalor.focus();
		}			
 	}
	function __isValidaEquiv() {	
		//alert(this.obj.form.ExisteTEVequivalente.value);
		if (this.obj.form.ExisteTEVequivalente.value == 'S')  {
			this.error = "Valor incorrecto, Ya existe la Equivalencia en la Tabla de Evaluacion!";
			//this.obj.form.TEVequivalente.focus();
		}		
 	}
	function __isCual_Valor(){

		if(btnSelected("btnCambiarD") || btnSelected("btnAgregarD")) {
			
			var valor_digitado = this.obj.form.TEVvalor.value + ',' ;
			var valores = this.obj.form.Cual_Valor.value;
			if (new Number(valores.indexOf(valor_digitado)) == -1) {
			} else {
				this.error = "Valor incorrecto, Ya existe el valor en la Tabla de Evaluacion!";
				//this.obj.form.TEVvalor.focus();
			}
		}
	}
	
	function __isCual_Equivalencia() {
	
		if(btnSelected("btnCambiarD") || btnSelected("btnAgregarD")) {
			var equivalencia_digitada = this.obj.form.TEVequivalente.value;
			var equivalencia = this.obj.form.Cual_Equivalencia1.value;
			
			var equivArray = equivalencia.split(',');
			for (var i=0; i<equivArray.length; i++) {
				if (equivArray[i] != "" && (new Number(equivArray[i]).valueOf() == new Number(equivalencia_digitada).valueOf())) {
					this.error = "Valor incorrecto, Ya existe la equivalencia en la Tabla de Evaluacion!";
					//this.obj.form.TEVequivalente.focus();
					break;
				}
			}
		}
	}

	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isCual_Valor", __isCual_Valor);
	_addValidator("isCual_Equivalencia", __isCual_Equivalencia);	
	_addValidator("isValidaEquivalencia", __isValidaEquivalencia);
	_addValidator("isValidaEquiv", __isValidaEquiv);	
	objForm = new qForm("form1");
	
	<cfif modo EQ "ALTA">
		objForm.TEnombre.required = true;
		objForm.TEnombre.description = "Descripción";
		//objForm.TEnombre.validateValida();
	<cfelseif modo NEQ "ALTA">
		objForm.TEnombre.required = true;
		objForm.TEnombre.description = "Descripción";
		//objForm.TEnombre.validateValida();
		objForm.TEVvalor.required = true;
		objForm.TEVvalor.description = "Valor";		
		<cfif modoDet EQ "ALTA">
			objForm.TEVvalor.required = true;
			objForm.TEVvalor.description = "Valor";
			objForm.TEVnombre.required = true;
			objForm.TEVnombre.description = "nombre del valor";
			objForm.TEVequivalente.required = true;
			objForm.TEVequivalente.description = "Equivalencia";
			objForm.TEVequivalente.validateValidaEquivalencia();
			objForm.TEVequivalente.validateCual_Equivalencia();
			objForm.TEVequivalente.validateValidaEquiv();
			objForm.TEVvalor.validateCual_Valor();
			objForm.TEVequivalente.validateCual_Equivalencia();
		<cfelseif modoDet NEQ "ALTA">
			objForm.TEVequivalente.required = true;
			objForm.TEVequivalente.description = "Valor";
			objForm.TEVnombre.required = true;
			objForm.TEVnombre.description = "nombre del valor";
			//objForm.TEnombre.validateValida();
			objForm.TEVequivalente.validateValidaEquivalencia();
			objForm.TEVequivalente.validateCual_Equivalencia();
			<cfif modo NEQ "ALTA">
				//objForm.TEVequivalente.validateValidaEquiv();
			</cfif>
		</cfif>		
	</cfif>		
</script>
