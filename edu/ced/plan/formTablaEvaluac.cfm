
<cfset modo = "ALTA">
<cfif isdefined("form.EVTcodigo") and form.EVTcodigo GT 0>
     <cfset modo="CAMBIO">
</cfif>

<!-- modo para el detalle -->
<cfparam name="mododet" default="ALTA">
<cfif isdefined("form.Valor") and len(trim(form.Valor))>
	<cfset mododet = "CAMBIO">
</cfif>

<!--- Consultas --->

<!--- 1. Form --->
<cfif modo NEQ "ALTA">
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		select EVTnombre, EVTtipo from EvaluacionValoresTabla	
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		
		<cfif isdefined("Form.EVTcodigo") AND #Form.EVTcodigo# NEQ "" >
			and EVTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EVTcodigo#">
		</cfif>	
	</cfquery>
	<cfif isdefined("Form.EVTcodigo") AND #Form.EVTcodigo# NEQ "" >
		<cfquery datasource="#Session.Edu.DSN#" name="rsCual_Valor">
			Select EVvalor, EVdescripcion, str(EVequivalencia,5,2) as EVequivalencia
			from EvaluacionValores
			where EVTcodigo= <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
			<cfif isdefined("form.Valor") and form.Valor NEQ "">
				and EVvalor !=<cfqueryparam value="#form.Valor#" cfsqltype="cf_sql_varchar">
			</cfif>
			  
		</cfquery>
	</cfif>	

	<!--- Seccion del detalle --->
		<cfif isdefined("Form.EVTcodigo") and Form.EVTcodigo NEQ "" and isdefined("form.Valor") and form.Valor NEQ "" >
			<!--- 1. Form --->	
			<cfquery datasource="#Session.Edu.DSN#" name="rsFormDetalle">
				Select EVTcodigo,EVvalor,EVdescripcion, str(EVequivalencia,5,2) as EVequivalencia
				from EvaluacionValores
				where EVTcodigo= <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
				and EVvalor=<cfqueryparam value="#form.Valor#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
	
	<cfif isdefined("Form.EVTcodigo") and len(trim(Form.EVTcodigo)) GT 0>
		<!--- 3. Validaciones de dependencias--->
		<!---  Rodolfo JImenez Jara, SOIN, 03/12/2002 --->
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateria">
			select 1 from Materia
			where EVTcodigo  = <cfqueryparam value="#Form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionMateria">
			select 1 from EvaluacionMateria
			where EVTcodigo  = <cfqueryparam value="#Form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionPlanConcepto">
			select 1 from EvaluacionPlanConcepto
			where EVTcodigo  = <cfqueryparam value="#Form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionCurso">
			select 1 from EvaluacionCurso
			where EVTcodigo  = <cfqueryparam value="#Form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
	</cfif>	  
</cfif>

<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">

	function funcLista() {
		deshabilitarValidacion();
		<cfset Lvar_EVTcodigo="">
		<cfif isdefined("form.EVTcodigo") and form.EVTcodigo GT 0>
			 <cfset Lvar_EVTcodigo="&EVTcodigo=#form.EVTcodigo#">
		</cfif>
		location.href = "listaTablaEvaluac.cfm?<cfoutput>Pagina=#Form.Pagina#&Filtro_EVTnombre=#Form.Filtro_EVTnombre#&HFiltro_EVTnombre=#Form.Filtro_EVTnombre##Lvar_EVTcodigo#</cfoutput>";	
		return false;
	}
	function funcNuevo(){
		deshabilitarValidacion();
		location.href = "tablaEvaluac.cfm<cfoutput>?PageNum_Lista=#form.Pagina#&Pagina=#Form.Pagina#&Pagina2=#Form.Pagina2#&Filtro_EVTnombre=#Form.Filtro_EVTnombre#</cfoutput>";	
		return false;
		}
	function funcBaja(){
		deshabilitarValidacion();
		location.href = "listaTablaEvaluac.cfm?<cfoutput>Pagina=#Form.Pagina#&Filtro_EVTnombre=#Form.Filtro_EVTnombre#</cfoutput>";	
		//return false;
		}	
</script><style type="text/css">
<!--
body,td,th {
	font-size: 12px;
}
-->
</style>

<form name="form1" method="post" action="SQLTablaEvaluac.cfm">
	<cfoutput>
		<input type="hidden" id="EVTcodigo" name="EVTcodigo" value="<cfif modo NEQ "ALTA" and isdefined("form.EVTcodigo")>#Form.EVTcodigo#</cfif>">
		<input type="hidden" id="ExisteEVvalor" name="ExisteEVvalor" value="">
		<input type="hidden" id="ExisteEVequivalencia" name="ExisteEVequivalencia" value="">
		<input name="Pagina" id="Pagina" value="#Form.Pagina#" type="hidden">
		<input name="Pagina2" id="Pagina2" value="#Form.Pagina2#" type="hidden">
		<input name="MaxRows2" id="MaxRows2" value="#Form.MaxRows2#" type="hidden">
		<input name="Filtro_EVTnombre" id="Filtro_EVTnombre" value="#Form.Filtro_EVTnombre#" type="hidden">

		<input name="Filtro_Valor" id="Filtro_Valor" value="<cfif modo NEQ "ALTA" and isdefined("form.Filtro_Valor")>#Form.Filtro_Valor#</cfif>" type="hidden">
		<input name="Filtro_Descripcion" id="Filtro_Descripcion" value="<cfif modo NEQ "ALTA" and isdefined("form.Filtro_Descripcion")>#Form.Filtro_Descripcion#</cfif>" type="hidden">
		
		<input name="Filtro_Equivalencia" id="Filtro_equivalencia" value="<cfif modo NEQ "ALTA" and isdefined("form.Filtro_equivalencia")>#Form.Filtro_equivalencia#</cfif>" type="hidden">
		<input name="Filtro_Minimo" id="Filtro_EVminimo" value="<cfif modo NEQ "ALTA" and isdefined("form.Filtro_EVminimo")>#Form.Filtro_EVminimo#</cfif>" type="hidden">
		<input name="Filtro_Maximo" id="Filtro_maximo" value="<cfif modo NEQ "ALTA" and isdefined("form.Filtro_maximo")>#Form.Filtro_maximo#</cfif>" type="hidden">

	</cfoutput>
	
  <table width="100%" border="0">
    <tr> 
      <td <cfif modo NEQ "ALTA">colspan="2" </cfif>class="tituloAlterno"><cfif modo EQ "ALTA">Nueva <cfelse>Modificar </cfif>Tabla de Evaluaci&oacute;n</td>
    </tr>
    <tr> 
		<td <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top">
			<table width="100%" cellpadding="2" cellspacing="2" border="0">
				<tr>
				  <td align="right" nowrap>Descripci&oacute;n</td>
				  <td nowrap><input name="EVTnombre" type="text" id="EVTnombre" size="40" tabindex="1" maxlength="80" onfocus="javascript:this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.EVTnombre#</cfoutput></cfif>"></td>
				  <td align="right" nowrap>Tipo de Redondeo</td>
				  <td>
					<select name="EVTtipo" id="EVTtipo" tabindex="1">
					  <option value="0" <cfif modo NEQ 'ALTA' and #rsForm.EVTtipo# EQ 0>selected</cfif>>El m&aacute;s cercano</option>
					  <option value="1" <cfif modo NEQ 'ALTA' and #rsForm.EVTtipo# EQ 1>selected</cfif>>Hacia arriba</option>
					  <option value="2" <cfif modo NEQ 'ALTA' and #rsForm.EVTtipo# EQ 2>selected</cfif>>Hacia abajo</option>
					</select>
					<cfoutput>
						<cfif modo NEQ 'ALTA' and isdefined("Form.EVTcodigo") and len(trim(form.EVTcodigo))>
							<input type="hidden" name="HayMateria"  value="#rsHayMateria.recordCount#">
							<input type="hidden" name="HayEvaluacionMateria"  value="#rsHayEvaluacionMateria.recordCount#">
							<input type="hidden" name="HayEvaluacionPlanConcepto"  value="#rsHayEvaluacionPlanConcepto.recordCount#">
							<input type="hidden" name="HayEvaluacionCurso"  value="#rsHayEvaluacionCurso.recordCount#">
						</cfif>
					</cfoutput>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<!---
    <tr> 
      	<td <cfif modo NEQ "ALTA">colspan="2" </cfif>align="center"> 
			<cfif modo EQ "ALTA">
				<cf_botones values="Agregar" names="btnAgregarE" tabindex="1">
				<!--- <input type="submit" name="btnAgregarE" tabindex="1" value="Agregar" onClick="javascript: setBtn(this); " >  --->
			<cfelseif modo NEQ "ALTA">
				<cf_botones values="Modificar Tabla,Borrar Tabla,Nueva Tabla" names="btnCambiarE,btnBorrarE,btnNuevoE" tabindex="1">
				<!--- 	<input type="submit" name="btnCambiarE" tabindex="1" value="Modificar Tabla" onClick="javascript: setBtn(this); deshabilitarDetalle(); habilitarValidacion(); " >
					<input type="submit" name="btnBorrarE" tabindex="1" value="Borrar Tabla" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('Esta seguro(a) que desea borrar esta tabla de evaluacin ?')" > 
					<input type="submit" name="btnNuevoE" tabindex="1" value="Nueva Tabla" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle();">
				 --->
			 </cfif>
			 <cf_botones values="Lista de Tablas de Evaluación" names="Anterior" tabindex="1" >
			<!--- <input type="button" name="btnLista" tabindex="1" value="Lista de Tablas de Evaluacin" onClick="javascript: irALista();"> --->
		</td>
    </tr>--->
	<cfif modo NEQ "ALTA">
	<tr>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td width="100%" valign="top" style="padding-left: 10px" align="center">
			<table border="0" width="50%" cellpadding="2" cellspacing="2">
				<tr>
					<td align="right" nowrap>Valor</td>
					
						<cfoutput>
							<td nowrap><input name="EVvalor" type="text" id="EVvalor" tabindex="3" size="10" maxlength="3"   <cfif modoDet NEQ 'ALTA'>readonly="true"</cfif> value="<cfif modoDet NEQ 'ALTA'>#rsFormDetalle.EVvalor#</cfif>">
							<cfset valores ="">
							<cfset equivalencia ="">
							<cfloop query="rsCual_Valor">
                        		<cfset valores = valores & rsCual_Valor.EVvalor & ",">
								<cfset equivalencia = equivalencia & rsCual_Valor.EVequivalencia & ",">
							</cfloop>
							<input type="hidden" name="Cual_Valor"  value="#valores#">
							<input type="hidden" name="Cual_Equivalencia1"  value="#equivalencia#"> 
						</td></cfoutput>
					
				</tr>
				<tr>
					
              <td height="28" align="right" nowrap>Descripci&oacute;n</td>
					<td nowrap><input name="EVdescripcion" type="text" id="EVdescripcion" tabindex="3" size="35" maxlength="80"  onfocus="javascript:this.select();" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsFormDetalle.EVdescripcion#</cfoutput></cfif>"></td>
				</tr>
				<tr>
					<td align="right" nowrap>Equivalencia</td>
					<td nowrap><input name="EVequivalencia" type="text" id="EVequivalencia" tabindex="3" size="10" maxlength="6"  value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsFormDetalle.EVequivalencia#</cfoutput></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<!---
						<cfif modoDet EQ "ALTA">
							<cf_botones values="Agregar Valor" names="btnAgregarD" tabindex="4">
							<!--- <input type="submit" name="btnAgregarD" tabindex="4" value="Agregar Valor" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion(); " >  --->
						<cfelseif modoDet NEQ "ALTA">
							<cf_botones values="Modificar Valor,Borrar Valor,Nuevo Valor" names="btnCambiarD,btnBorrarD,btnNuevoD" tabindex="4">
<!--- 							
							<input type="submit" name="btnCambiarD" tabindex="4" value="Modificar Valor" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion();" > 
							<input type="submit" name="btnBorrarD" tabindex="4" value="Borrar Valor" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('Esta seguro(a) que desea borrar este valor?')" > 
							<input type="submit" name="btnNuevoD" tabindex="4" value="Nuevo Valor" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion();" >	 --->
						</cfif>
						
						<cf_botones modo="#modo#" mododet="#mododet#" GeneroEnc="F" NameEnc="Tabla" include="Lista">
						--->
					</td>
				</tr>
			</table>
		</td>
    </tr>
	</cfif>
	 <tr> 
      <td colspan="2" align="center"><cf_botones modo="#modo#" mododet="#mododet#" GeneroEnc="F" NameEnc="Tabla" include="Lista"> </td>
    </tr>
  </table>
  <!---  Este Iframe funciona, pero solo tiene la inconveniencia de que si el usuario no hace el onblur, no funciona. --->
  <iframe name="FrEquiv" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="validaequiv.cfm" ></iframe>

<!--- <script>
  	<cfif modo EQ "CAMBIO">
		valValorEquiv(document.form1.EVequivalencia.value, document.form1.EVvalor.value, document.form1.EVTcodigo.value);

	</cfif>
</script> --->
</form>

<cfif (modo neq "ALTA")>
	

	<cfinvoke 
	 component="edu.Componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaTabEvalDet">
		<cfinvokeargument name="tabla" value="EvaluacionValores a,EvaluacionValoresTabla b"/>
		<cfinvokeargument name="columnas" value="b.EVTcodigo, EVdescripcion as Descripcion,EVvalor as Valor,str(EVequivalencia,6,2) as Equivalencia, str(EVminimo,7,3) as Minimo, str(EVmaximo,7,3) as Maximo ,
																				#form.Pagina# as Pagina, '#form.Filtro_EVTnombre#' as Filtro_EVTnombre"/>
		<cfinvokeargument name="desplegar" value="Valor,Descripcion,Equivalencia, Minimo, Maximo"/>
		<cfinvokeargument name="etiquetas" value="Valor,Descripci&oacute;n,Equivalencia, M&iacute;nimo, M&aacute;ximo"/>
		<cfinvokeargument name="formatos" value="S,S,N,N,N"/>
		<cfinvokeargument name="filtro" value=" a.EVTcodigo=b.EVTcodigo and  a.EVTcodigo = #form.EVTcodigo# order by a.EVequivalencia desc "/>
		<cfinvokeargument name="align" value="left,left,right,right,right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="tablaEvaluac.cfm"/>
		<cfinvokeargument name="PageIndex" value="2"/>
		<cfinvokeargument name="formname" value="lista2"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="mostrar_filtro" value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/>
		<cfinvokeargument name="filtrar_por" value="EVvalor,EVdescripcion,  EVequivalencia, EVminimo, EVmaximo"/>
		<!--- <cfinvokeargument name="filtrar_por" value="EVvalor,EVdescripcion,  EVequivalencia, EVminimo, EVmaximo"/> --->
		<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
		<cfinvokeargument name="navegacion" value="&EVTcodigo=#form.EVTcodigo#&Pagina=#Form.Pagina#&Filtro_EVTnombre=#Form.Filtro_EVTnombre#&Filtro_Valor=#Form.Filtro_Valor#&Filtro_Descripcion=#Form.Filtro_Descripcion#&Filtro_minimo=#Form.Filtro_minimo#&Filtro_maximo=#Form.Filtro_maximo#"/>
		<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
	</cfinvoke>	
	<script language="javascript" type="text/javascript">
		function funcFiltrar2(){
			document.lista2.action = "tablaEvaluac.cfm<cfoutput>?EVTcodigo=#EVTcodigo#&Pagina=#Form.Pagina#&Pagina2=#Form.Pagina2#&Filtro_EVTnombre=#Form.Filtro_EVTnombre#&Filtro_Valor=#Form.Filtro_Valor#&Filtro_minimo=#Form.Filtro_minimo#&Filtro_maximo=#Form.Filtro_maximo#</cfoutput>";
			return true;
		}
	</script>
</cfif>
<cf_qforms>
<script language="JavaScript">
	_addValidator("isCual_Valor", __isCual_Valor);
	_addValidator("isCual_Equivalencia", __isCual_Equivalencia);	

	_addValidator("isValida", __isValida);
	_addValidator("isValidaEquivalencia", __isValidaEquivalencia);
	
	function funcAltaDet() {
		habilitarValidacion(true);
	}
	function funcCambioDet() {
		habilitarValidacion(true);
	}
	
	function habilitarValidacion(validar_detalles) {
		objForm.EVTnombre.required = true;
		objForm.EVTnombre.description = "Descripción de la Tabla";
		<cfif modo NEQ "ALTA">
			objForm.EVvalor.description = "Valor";
			objForm.EVvalor.required = validar_detalles;
			objForm.EVdescripcion.description = "Descripción del Valor";
			objForm.EVdescripcion.required = validar_detalles;
			objForm.EVequivalencia.description = "Equivalencia";
			objForm.EVequivalencia.required = validar_detalles;
		</cfif>
	}	
	
	function deshabilitarValidacion() {
		objForm.EVTnombre.required = false;
		<cfif modo NEQ "ALTA">
			objForm.EVvalor.required = false;
			objForm.EVequivalencia.required = false;
			objForm.EVdescripcion.required = false;
			objForm.EVTnombre.required = false;
		</cfif>
	}
	

	function __isValidaEquivalencia() {	
		if(btnSelected("btnAgregarD") || btnSelected("btnCambiarD")) {
			// Valida que la equivalencia se encuentre entre el rango permitido
			//alert(new Number(this.obj.form.EVequivalencia.value)); 
			if (new Number(this.obj.form.EVequivalencia.value) < 0 || new Number(this.obj.form.EVequivalencia.value) > 100) {
				this.error = "Equivalencia incorrecta, el rango sugerido es: mayor que cero y menor o igual que 100";
				this.obj.form.EVequivalencia.focus();
			}
		}
	}

	function __isValidaValor() {	
		//alert(this.obj.form.ExisteEVvalor.value);
		if (this.obj.form.ExisteEVvalor.value == 'S')  {
			this.error = "Valor incorrecto, Ya existe el valor en la Tabla de Evaluacion!";
			this.obj.form.EVvalor.focus();
		}			
 	}

	function __isValidaEquiv() {	
		//alert(this.obj.form.ExisteEVequivalencia.value);
		if (this.obj.form.ExisteEVequivalencia.value == 'S')  {
			this.error = "Valor incorrecto, Ya existe la Equivalencia en la Tabla de Evaluacion!";
			this.obj.form.EVequivalencia.focus();
		}			
 	}
	function __isCual_Valor(){

		if(btnSelected("btnCambiarD") || btnSelected("btnAgregarD")) {
			var valor_digitado = this.obj.form.EVvalor.value + ",";
			var valores = this.obj.form.Cual_Valor.value;
			
			if (valores.indexOf(valor_digitado) == -1) {
				//alert("No lo encontre");
			} else {
				//alert("Si lo encontre");
				this.error = "Valor incorrecto, Ya existe el valor en la Tabla de Evaluacion!";
				this.obj.form.EVvalor.focus();
			}
		}
	}
	
	function __isCual_Equivalencia() {
	
		if(btnSelected("btnCambiarD") || btnSelected("btnAgregarD")) {
			var equivalencia_digitada = this.obj.form.EVequivalencia.value;
			var equivalencia = this.obj.form.Cual_Equivalencia1.value;
			
			var equivArray = equivalencia.split(',');
			for (var i=0; i<equivArray.length; i++) {
				if (equivArray[i] != "" && (new Number(equivArray[i]).valueOf() == new Number(equivalencia_digitada).valueOf())) {
					this.error = "Valor incorrecto, Ya existe la equivalencia en la Tabla de Evaluacion!";
					this.obj.form.EVequivalencia.focus();
					break;
				}
			}
		}
		
		/*if (equivalencia.indexOf(equivalencia_digitada) == -1) {
			//alert("No lo encontre");
		} else {
			//alert("Si lo encontre");
			this.error = "Valor incorrecto, Ya existe la equivalencia en la Tabla de Evaluacion!";
			this.obj.form.EVequivalencia.focus();
		}*/
	}

	
	function __isValida() {
		if(btnSelected("btnBorrarE")) {
			//Rodolfo Jimenez Jara, 05/12/2002
			// Valida que la Tabla de Evaluacion no tenga dependencias con otros.
			var msg = "";
			//alert(new Number(this.obj.form.HayMateria.value)); 
			if (new Number(this.obj.form.HayMateria.value) > 0) {
				msg = msg + "materias"
			}
			//alert(new Number(this.obj.form.HayEvaluacionMateria.value)); 
			if (new Number(this.obj.form.HayEvaluacionMateria.value) > 0) {
				msg = msg + "evaluacion de materias"
			}
			//alert(new Number(this.obj.form.HayEvaluacionPlanConcepto.value)); 
			if (new Number(this.obj.form.HayEvaluacionPlanConcepto.value) > 0) {
				msg = msg + "conceptos de planes de evaluacion"
			}
			//alert(new Number(this.obj.form.HayEvaluacionCurso.value)); 
			if (new Number(this.obj.form.HayEvaluacionCurso.value) > 0) {
				msg = msg + "cursos de evaluacion"
			}
			if (msg != "")
			{
				this.error = "Usted no puede eliminar la tabla de evaluacion '" + this.obj.form.EVTnombre.value + "' porque ste tiene asociado: " + msg + ".";
				this.obj.form.EVTnombre.focus();
			}
		}
	}

	
	//_addValidator("isValidaValor", __isValidaValor);
	//_addValidator("isValidaEquiv", __isValidaEquiv);
	
	objForm.EVTnombre.description = "Descripción";
	<cfif modo EQ "ALTA">
		objForm.EVTnombre.description = "Descripción";
		objForm.EVTnombre.validateValida();
	<cfelseif modo NEQ "ALTA">
		//objForm.EVTnombre.required = true;
		objForm.EVTnombre.description = "Descripción";
		objForm.EVTnombre.validateValida();
		//objForm.EVvalor.required = true;
		<cfif modoDet EQ "ALTA">
			//objForm.EVvalor.required = true;
			objForm.EVvalor.description = "Valor";
			//objForm.EVdescripcion.required = true;
			objForm.EVdescripcion.description = "Descripción del valor";
			//objForm.EVequivalencia.required = true;
			objForm.EVequivalencia.description = "Equivalencia";
			objForm.EVequivalencia.validateValidaEquivalencia();
			objForm.EVequivalencia.validateCual_Equivalencia();
			//objForm.EVvalor.required = true;
			<cfif modo NEQ "ALTA">
				//objForm.EVequivalencia.validateValidaEquiv();
				objForm.EVvalor.validateCual_Valor();
				objForm.EVequivalencia.validateCual_Equivalencia();
			</cfif>
		<cfelseif modoDet NEQ "ALTA">
			//objForm.EVvalor.required = true;
			objForm.EVvalor.description = "Valor";
			//objForm.EVequivalencia.required = true;
			objForm.EVequivalencia.description = "Equivalencia";
			//objForm.EVdescripcion.required = true;
			objForm.EVdescripcion.description = "Descripción";
			objForm.EVTnombre.validateValida();
			objForm.EVequivalencia.validateValidaEquivalencia();
			objForm.EVequivalencia.validateCual_Equivalencia();
			<cfif modo NEQ "ALTA">
				//objForm.EVequivalencia.validateValidaEquiv();
			</cfif>
		</cfif>		
	</cfif>		
</script>
