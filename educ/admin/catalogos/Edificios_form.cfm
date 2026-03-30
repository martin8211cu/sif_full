<cfif isdefined("Form.EDResul")>
	<cfset Form.EDcodigo = Form.EDResul>
</cfif>
<cfif isdefined("Url.EDResul") and not isdefined("Form.EDcodigo")>
	<cfset Form.EDcodigo = Url.EDResul>
</cfif>
<cfif isdefined("Url.Scodigo") and not isdefined("Form.Scodigo")>
	<cfset Form.Scodigo = Url.Scodigo>
</cfif>


<cfif isdefined("form.AUcodigo_lista")>
	<cfset Form.AUcodigo = form.AUcodigo_lista>
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
<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>
<cfif isdefined("Form.EDcodigo") and len(trim(Form.EDcodigo)) neq 0 and not isdefined("form.btnNuevoE")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<cfif isdefined("Form.AUcodigo") and len(trim(Form.AUcodigo)) neq 0>
	<cfset modoDet="CAMBIO">
</cfif>
<cfif isdefined("Form.btnNuevoE") >
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>


<!--- Consultas --->
<cfif modo EQ "ALTA">
	<cfquery datasource="#Session.DSN#" name="rsEdificio">	
			select convert(varchar,b.EDcodigo) as EDcodigo, rtrim(ltrim(b.EDnombre)) as EDnombre,
			rtrim(ltrim(EDcodificacion)) as EDcodificacion, 
			EDprefijo, convert(varchar,b.Scodigo) as Scodigo,
			b.ts_rversion
			from Edificio b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsSede">
		select convert(varchar,b.Scodigo) as Scodigo, rtrim(b.Snombre) as Snombre,
			Scodificacion, Sprefijo
			from Sede b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- 1. Form Encabezado --->
	<cfquery datasource="#Session.DSN#" name="rsEdificio">
		select convert(varchar,b.EDcodigo) as EDcodigo, rtrim(b.EDnombre) as EDnombre,
			rtrim(ltrim(EDcodificacion)) as EDcodificacion, 
			rtrim(ltrim(EDprefijo)) as EDprefijo, 	
			convert(varchar,b.Scodigo) as Scodigo,
			b.ts_rversion
			from Edificio b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		  and b.EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#"> 
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsSede">
		select convert(varchar,b.Scodigo) as Scodigo, rtrim(b.Snombre) as Snombre,
			Scodificacion, Sprefijo 	
			from Sede b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>

	<cfif modoDet NEQ "ALTA">
		<cfquery datasource="#Session.DSN#" name="rsAula">
			select 	convert(varchar, b.AUcodigo) as AUcodigo,
					convert(varchar, b.EDcodigo) as EDcodigo,
				   	b.AUnombre,
					rtrim(ltrim(b.AUcodificacion)) as AUcodificacion,
					b.AUcapacidad,
				 	b.ts_rversion
			from Edificio a, Aula b
			where a.EDcodigo  = b.EDcodigo
			  and b.AUcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AUcodigo#">
			  and b.EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		</cfquery>
	
	</cfif>
</cfif>


<cf_templatecss>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function irALista() {
		<cfset ts =  LSDateFormat(Now(), 'ddmmyyyy') & LSTimeFormat(Now(),'hhmmss')>
		<cfoutput>
		location.href = "Edificios.cfm?a=#ts#";
		</cfoutput>
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
	<cfif modo EQ "ALTA">
		var sedes = new  Object();
		<cfoutput>
		<cfloop query="rsSede">
			var name = "#Scodigo#";
			sedes[name] = "#Sprefijo#";
		</cfloop>
		</cfoutput>

	function cambioSede(combo) {
		if (combo.length > 0) combo.form.EDcodificacion.value = sedes[combo.value];
	}

	</cfif>
	
</script>
<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<form name="form1" method="post" action="Edificios_SQL.cfm">
	<input name="EDcodigo" id="EDcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.EDcodigo#</cfoutput></cfif>" type="hidden">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" align="center">
			<table width="90%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="center" colspan="3" class="tituloMantenimiento">
					<cfif modo EQ "ALTA">
						Nuevo 
					<cfelse>
						Modificar 
					</cfif>
					Edificio
					<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">					
				</td>
			  </tr>			
			  <tr>
				<td width="41%" align="right"><strong>Sede:</strong></td>
				<td width="4%">&nbsp;</td>
				<td width="55%">
					<select name="Scodigo" <cfif modo EQ "ALTA">onChange="javascript: cambioSede(this);"</cfif>>
                  <cfoutput query="rsSede">
                    <option value="#rsSede.Scodigo#" <cfif modo NEQ 'ALTA' and rsSede.Scodigo EQ rsEdificio.Scodigo>selected</cfif>>#rsSede.Snombre#</option>
                  </cfoutput>
                </select></td>
			  </tr>
			  <tr>
				<td align="right"><strong>C&oacute;digo:</strong></td>
				<td>&nbsp;</td>
				<td>
					<cfoutput>
					<input name="EDcodificacion" type="text" id="EDcodificacion" size="16" maxlength="15" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsEdificio.EDcodificacion#<cfelseif isdefined("rsSede") and rsSede.recordCount GT 0>#rsSede.Sprefijo#</cfif>">
					</cfoutput>
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Nombre Edificio:</strong></td>
				<td>&nbsp;</td>
				<td><cfoutput>
				  <input name="EDnombre"  type="text"  value="<cfif modo NEQ 'ALTA'>#rsEdificio.EDnombre#</cfif>"  size="50" maxlength="50"
				  		onFocus="javascript:if(this.value=='') this.value='Edificio '+this.form.EDcodificacion.value; else this.select();">
			    </cfoutput></td>
			  </tr>
			  <tr>
				<td align="right" nowrap><strong>Prefijo para el Aula</strong></td>
				<td>&nbsp;</td>
				<td><input name="EDprefijo" type="text" id="EDprefijo2" size="4" maxlength="3" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEdificio.EDprefijo#</cfoutput></cfif>"></td>
			  </tr>
			  <tr>
			    <td align="right" nowrap>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
		      </tr>
			  <tr>
				<td colspan="3" align="center" nowrap>
					<cfif modo EQ "ALTA">
						<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: setBtn(this); habilitarValidacion();"> 
					<cfelseif modo NEQ "ALTA">
						<input type="submit" name="btnCambiarE" value="Modificar Edificio" onClick="javascript: setBtn(this); deshabilitarDetalle(); habilitarValidacion(); " >
						<input type="submit" name="btnBorrarE" value="Borrar Edificio" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('¿Esta seguro(a) que desea borrar este Edificio?')" > 
						<input type="submit" name="btnNuevoE" value="Nuevo Edificio" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion();" >
					</cfif>
					<input type="button" name="btnLista"  value="Lista de Edificios" onClick="javascript: irALista();">				
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
		  </table>
		</td>
	  </tr>
	  <cfif modo NEQ "ALTA">
		  <tr>
			<td colspan="2"><hr></td>	  
		  </tr>			
		  <tr>
			<td width="50%" valign="top">
				<cfset ts = "">	
				<cfif modo neq "ALTA">
					<cfinvoke 
						component="educ.componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsEdificio.ts_rversion#"/>
					</cfinvoke>
				</cfif>
				<input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
				<cfinvoke 
				 component="educ.componentes.pListas"
				 method="pListaEdu"
				 returnvariable="pListaPlan">
					<cfinvokeargument name="tabla" value="Edificio a, Aula b"/>
					<cfinvokeargument name="columnas" value="substring(b.AUnombre,1,50) as AUnombre_lista, convert(varchar,b.EDcodigo) as EDResul, convert(varchar,b.AUcodigo) as AUcodigo_lista, rtrim(ltrim(AUcodificacion)) as AUcodificacion, AUcapacidad"/>
					<cfinvokeargument name="desplegar" value="AUCodificacion, AUnombre_lista, AUcapacidad"/>
					<cfinvokeargument name="etiquetas" value="Código, Aula, Capacidad "/>
					<cfinvokeargument name="align" value="left,left,center"/>
					<cfinvokeargument name="ajustar" value="N,N,N"/>,
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="a.EDcodigo = #form.EDcodigo# and a.EDcodigo = b.EDcodigo order by b.AUcodificacion"/>
					<cfinvokeargument name="irA" value="Edificios.cfm"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="form1"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>			
			</td>
			<td width="50%" valign="top">
				<table border="0" width="100%" cellpadding="2" cellspacing="2">
					<tr align="center"> 
						<td  colspan="2" class="tituloMantenimiento" > 
						
							<cfif modoDet EQ "ALTA">
								Nuevo
							<cfelse>
								Modificar 
							</cfif>
							Aula</td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>C&oacute;digo:</strong></td>
						<td nowrap>
							<cfoutput>
								<input name="AUcodificacion_text"  onFocus="this.select()" type="text"  value="<cfif modoDet NEQ 'ALTA'>#rsAula.AUcodificacion#<cfelse>#rsEdificio.EDprefijo#</cfif>" size="10" maxlength="5">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
						<td nowrap> 
							<cfoutput>
								<input name="AUnombre"  type="text"  value="<cfif modoDet NEQ 'ALTA'>#rsAula.AUnombre#</cfif>"  size="50" maxlength="50"
							  		onFocus="javascript:if(this.value=='') this.value='Aula '+this.form.AUcodificacion_text.value; else this.select();">
								<input type="hidden" name="AUcodigo" value="<cfif isdefined("form.AUcodigo") and len(trim(form.AUcodigo)) neq 0>#form.AUcodigo#</cfif>">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>Capacidad Alumnos:</strong></td>
						<td nowrap>
							<cfoutput>
								<input name="AUcapacidad_text" type="text" id="AUcapacidad_text" size="10" maxlength="5"  value="<cfif modoDet NEQ 'ALTA'>#rsAula.AUcapacidad#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center" nowrap>
							<cfif modoDet EQ "ALTA">
								<input type="submit" name="btnAgregarD" value="Agregar Aula" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion(); " >
							<cfelseif modoDet NEQ "ALTA">
								<cfset ts = "">	
								<cfinvoke 
									component="educ.componentes.DButils"
									method="toTimeStamp"
									returnvariable="ts">
									<cfinvokeargument name="arTimeStamp" value="#rsAula.ts_rversion#"/>
								</cfinvoke>
							
								<input type="hidden" name="timestampD" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
								<input type="submit" name="btnCambiarD" value="Modificar Aula" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion();" > 
								<input type="submit" name="btnBorrarD" value="Eliminar Aula" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle(); return confirm('¿Esta seguro(a) que desea borrar esta Aula?')" > 
								<input type="submit" name="btnNuevoD" value="Nueva Aula" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle();" >
							</cfif>
						</td>
					</tr>
				</table>			
			</td>
		  </tr>
	  </cfif>		  
	</table>
<script language="JavaScript">
	//Rodolfo Jiménez Jara, SOIN,29/10/2003
	function deshabilitarValidacion() {
		objForm.EDnombre.required = false;
		objForm.EDcodificacion.required = false;
		objForm.EDprefijo.required = false;
		objForm.AUnombre.required = false;
		objForm.AUcodificacion_text.required = false;
		objForm.AUcapacidad_text.required = false;

	}
	
	function habilitarValidacion() {
		//alert(objForm.obj.CILtipoCalificacion.value);
		objForm.EDnombre.required = true;
		objForm.EDcodificacion.required = true;
		objForm.EDprefijo.required = true;
	}	
	
	function deshabilitarDetalle() {
		objForm.EDnombre.required = false;
		objForm.AUnombre.required = false;
		objForm.AUcodificacion_text.required = false;
		objForm.AUcapacidad_text.required = false;
	}

	function habilitarDetalle() {
		<cfif modoDet EQ "ALTA">
			objForm.EDnombre.required = true;
			objForm.AUnombre.required = true;
			objForm.AUcodificacion_text.required = true;
			objForm.AUcapacidad_text.required = true;

		</cfif>
		//objForm.CIEsemanas.required = true;
		//objForm.CIEextraordinario.required = true;
	}
	

	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.EDnombre.required = true;
		objForm.EDnombre.description = "Nombre del edificio";
		objForm.EDprefijo.required = true;
		objForm.EDprefijo.description = "Prefijo del edificio";
		objForm.EDcodificacion.required = true;
		objForm.EDcodificacion.description = "codificación del edificio";
		
	<cfelseif modo NEQ "ALTA">
		objForm.EDnombre.required = true;
		objForm.EDnombre.description = "Nombre del edificio";
		objForm.EDprefijo.required = true;
		objForm.EDprefijo.description = "Prefijo del edificio";
		objForm.EDcodificacion.required = true;
		objForm.EDcodificacion.description = "codificación del edificio";
			objForm.AUnombre.required = true;
			objForm.AUnombre.description = "Nombre del aula";
			objForm.AUcodificacion_text.required = true;
			objForm.AUcodificacion_text.description = "codificación del aula";
		_addValidator("isCodificacionValida", __isCodificacionValida);
		objForm.AUcodificacion_text.validateCodificacionValida();
			objForm.AUcapacidad_text.required = true;
			objForm.AUcapacidad_text.descripcion = "capacidad de alumnos";
	</cfif>
	
	<cfif modo EQ "ALTA">
		cambioSede(document.form1.Scodigo);
	</cfif>
function __isCodificacionValida()
{
	if (this.required) 
		if (trim(this.obj.form.AUcodificacion_text.value) == trim(this.obj.form.EDprefijo.value))
			this.error = "El codigo de Aula no puede ser igual al 'prefijo de aulas' del Edificio.";
}
function trim ( s )
{
	return rtrim(ltrim(s));
}
function ltrim ( s )
{
	return s.replace( /^\s*/, "" );
}
function rtrim ( s )
{
	return s.replace( /\s*$/, "" );
}
</script>	