<!--- === ETIQUETAS  DE  TRADUCCION ==== --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	default="Fecha"	
	returnvariable="LB_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_ConceptoDeIncidencia"
	default="Concepto de Incidencia"	
	returnvariable="LB_ConceptoDeIncidencia"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CentroFuncionalServicio"
	default="Centro Funcional de Servicio"	
	returnvariable="LB_CentroFuncionalServicio"/>	

<!--- Consultas --->
<!--- 1. Conceptos de Incidencias --->
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select 	<cf_dbfunction name="to_char" args="CIid"> as CIid,	
			<cf_dbfunction name="concat" args="rtrim(CIcodigo),' - ',CIdescripcion"> as Descripcion,			
			CIcantmin, CIcantmax, CItipo
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and CItipo != 3
	  and CIcarreracp = 0
	order by Descripcion
</cfquery>
<cfset va_arrayvalues=ArrayNew(1)>
<!--- 2. Incidencias --->
<cfif modo NEQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("Form.ICid") AND Len(Trim(Form.ICid)) GT 0>
	<cfquery name="rsIncidencia" datasource="#Session.DSN#">
		SELECT 
			a.ICid, 
			a.DEid, 
			a.CIid, 
			c.CIcodigo,
			c.CIdescripcion,
			ICfecha as fecha, 
			a.ICvalor, 
			a.Usucodigo, 
			a.Ulocalizacion, 
			{fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) }	as NombreEmp,
			b.DEidentificacion,
			b.NTIcodigo,
			a.ts_rversion,
			a.RHJid
		FROM IncidenciasCalculo a
			INNER JOIN DatosEmpleado b
				ON b.DEid = a.DEid
			INNER JOIN CIncidentes c
				ON c.CIid = a.CIid
		WHERE a.ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICid#">
	</cfquery>
	<cfif isdefined("rsIncidencia.CIid")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIid)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIcodigo")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIcodigo)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIdescripcion")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIdescripcion)>
	</cfif>
</cfif>

<!--- 3. Llaves de Incidencias --->
<cfquery name="rsLlavesIncidencias" datasource="#Session.DSN#">
	select a.DEid, 
		   a.CIid, 
		   a.Ifecha
	from Incidencias a, RCalculoNomina b, IncidenciasCalculo c
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and b.RCNid = c.RCNid
		and a.DEid = c.DEid
		and a.CIid = c.CIid
</cfquery>

<!--- 4. Jornadas --->
<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select 	RHJid, 
			{fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---
<cfquery name="rsLlavesIncidencias" datasource="#Session.DSN#">
	select a.DEid, 
		   a.CIid, 
		   convert(varchar,a.Ifecha,103) as Ifecha,
	from Incidencias a, IncidenciasCalculo b
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and b.ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICid#">
	and a.DEid = b.DEid
	and a.CIid = b.CIid
</cfquery>
--->

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var tipoConc= new Object();
	var rangoMin = new Object();
	var rangoMax = new Object();
	<cfloop query="rsConceptos">
		tipoConc['<cfoutput>#CIid#</cfoutput>'] = parseInt(<cfoutput>#CItipo#</cfoutput>);
		rangoMin['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmin#</cfoutput>);
		rangoMax['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmax#</cfoutput>);
	</cfloop>

	function validaForm(f) {
		f.obj.ICvalor.value = qf(f.obj.ICvalor.value);
		return true;
	}
	
	function changeValLabel() {
		var id = document.form1.CIid.value;
		if (id != null) {
			var tipo = tipoConc[id];
			var a = document.getElementById("TDValorLabel");
			var t = null; 
			var t2 = null;
			switch (tipo) {
				case 0: t = document.createTextNode("Cantidad horas"); objForm.ICvalor.description = "Cantidad horas"; break;
				case 1: t = document.createTextNode("Cantidad días"); objForm.ICvalor.description = "Cantidad días"; break;
				case 2: t = document.createTextNode("Monto"); objForm.ICvalor.description = "Monto"; break;
				default: t = document.createTextNode("Valor"); objForm.ICvalor.description = "Valor";
			}
			if (a.hasChildNodes()) a.replaceChild(t,a.firstChild);
			else a.appendChild(t);
		
			// Habilitar/deshabilitar combo de jornadas
			var vs_trLabelJornada = document.getElementById("TRLabelJornada");
			var vs_trJornada = document.getElementById("TRJornada");
			if (tipo == 0 || tipo == 1){
				vs_trLabelJornada.style.display = '';
				vs_trJornada.style.display = '';
			}
			else{
				vs_trLabelJornada.style.display = 'none';
				vs_trJornada.style.display = 'none';		
			}		
		
		}
	}
	//-->
</script>

<cfoutput>
<form name="form1" method="post" action="ResultadoModifyEsp-sql.cfm" onsubmit="javascript: return validaForm(this);">
	<table width="95%" border="0" cellspacing="0" cellpadding="3">
    	<!--- Línea No. 1 --->
		<tr> 
        	<td class="fileLabel">#LB_Fecha#</td>
        	<td class="fileLabel">#LB_ConceptoDeIncidencia#</td>
	 	</tr>
	 	<!--- Línea No. 2 --->
	 	<tr> 
        	<td>
				<cfif modo NEQ "ALTA">
					<cfset fecha = rsIncidencia.fecha>
				<cfelse>
					<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
				</cfif>
				<cf_sifcalendario form="form1" value="#fecha#" name="ICfecha">				   
			</td>
        	<td>
		  		<!---
				<cfif modo NEQ "ALTA">
					<cf_rhCIncidentes onBlur="changeValLabel()" query="#rsIncidencia#" tabindex="1" ExcluirTipo="3">
		  		<cfelse>
					<cf_rhCIncidentes onBlur="changeValLabel()" tabindex="1" ExcluirTipo="3">
		  		</cfif> 
				---->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_ListaDeIncidencias"
					default="Lista de Incidencias"
					returnvariable="LB_ListaDeIncidencias"/>
				<!--- Codigo concepto --->	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Codigo"
					default="C&oacute;digo"
					xmlfile="/rh/generales.xml"
					returnvariable="LB_Codigo"/>
				<!---Descripcion concepto---->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Descripcion"
					default="Descripci&oacute;n"
					xmlfile="/rh/generales.xml"
					returnvariable="LB_Descripcion"/>	
				<cf_conlis title="#LB_ListaDeIncidencias#"
					campos = "CIid,CIcodigo,CIdescripcion" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,10,20"
					asignar="CIid,CIcodigo,CIdescripcion"
					asignarformatos="I,S,S"
					tabla="	CIncidentes a"																	
					columnas="CIid,CIcodigo,CIdescripcion,CInegativo"
					filtro="a.Ecodigo =#session.Ecodigo#							
							and (CItipo != 3 
									or
								coalesce(CInomostrar,0) = 0
								)"
					desplegar="CIcodigo,CIdescripcion"
					etiquetas="	#LB_Codigo#, 
								#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					debug="false"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="CIcodigo,CIdescripcion"
					valuesarray="#va_arrayvalues#">				
         		<!--- 
				<select name="CIid" onChange="javascript: changeValLabel(this.value);">
					<cfloop query="rsConceptos">
						<option value="#rsConceptos.CIid#" <cfif modo NEQ "ALTA" and rsConceptos.CIid eq rsIncidencia.CIid>selected</cfif>>#rsConceptos.Descripcion#</option>
					</cfloop>
          		</select>
				--->          		
        	</td>
	 	</tr>
	 	<!--- Línea No. 3 --->
	 	<tr>	
			<td class="fileLabel" id="TDValorLabel">&nbsp;</td>
			<td class="fileLabel">#LB_CentroFuncionalServicio#</td>
      	</tr>
		<!--- Línea No. 4 --->
		<tr>
        	<td id="TDValor" nowrap>
          		<input name="ICvalor" type="text" id="ICvalor" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsIncidencia.ICvalor, 'none')#<cfelse>0.00</cfif>">
        	</td>
			<td>
				<cf_rhcfuncional>
			</td>
      	</tr>
	  	<!--- Línea No. 5 --->
		<tr>
			<td class="fileLabel">&nbsp;</td>
			<td>			
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
					<tr id="TRLabelJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>" >
						<td class="fileLabel"><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
					</tr>
					<tr id="TRJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>" >
						<td>
							<select name="RHJid">
								<option value="">--- Seleccionar ---</option>
								<cfloop query="rsJornadas">
									<option value="#RHJid#" <cfif modo EQ 'CAMBIO' and rsJornadas.RHJid EQ rsIncidencia.RHJid> selected</cfif>>#Descripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!--- Línea No. 6 --->
		<tr> 
        	<td class="fileLabel" colspan="2">&nbsp;</td>
	 	</tr>		
		<!--- Línea No. 7 --->
      	<tr align="center"> 
        	<td colspan="2">
				<cf_templatecss>
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="IAlta" value="Aceptar">
				<cfelse>	
					<input type="submit" name="ICambio" value="Aceptar">
				</cfif>
			</td>
      	</tr>
    </table>
	
    <cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsIncidencia.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="ICid" value="#rsIncidencia.ICid#">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	<input type="hidden" name="RCNid" value="#Form.RCNid#">
	<input type="hidden" name="DEid" value="#Form.DEid#">
	<input name="Tcodigo" type="hidden" value="#Form.Tcodigo#">
</form>
</cfoutput>
<script language="JavaScript">
	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	function __isRangoCantidad() {
		if ((tipoConc[this.obj.form.CIid.value] == 0 || tipoConc[this.obj.form.CIid.value] == 1) && (parseFloat(qf(this.value)) < rangoMin[this.obj.form.CIid.value] || parseFloat(qf(this.value)) > rangoMax[this.obj.form.CIid.value])) {
			this.error = "La Cantidad digitada se sale del rango permitido";
		}
	}

	function __isNotCero() {
		if ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0)) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}
	}
	
	function __isIncidenciaNoExiste() {
	//Compara CIid, Ifecha para el Empleado(DEid)
	<cfoutput query='rsLlavesIncidencias'>
		if ('#CIid#'==objForm.CIid.obj.value && '#LSDateFormat(Ifecha, "DD/MM/YYYY")#'==objForm.ICfecha.obj.value)
			this.error = 'La Relación entre el ' 
							+ objForm.CIid.description + ' y la ' 
							+ objForm.ICfecha.description + ' ya existe.';
	</cfoutput>
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isRangoCantidad", __isRangoCantidad);
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isIncidenciaNoExiste", __isIncidenciaNoExiste);

	objForm.ICfecha.required = true;
	objForm.ICfecha.description = "Fecha";
	
	objForm.CIid.required = true;
	objForm.CIid.description = "Concepto de Incidencia";
	objForm.CIid.validateIncidenciaNoExiste();
	
	objForm.ICvalor.required = true;
	objForm.ICvalor.description = "";
	objForm.ICvalor.validateNotCero();
	objForm.ICvalor.validateRangoCantidad();
	
	// Establecer la etiqueta inicial
	changeValLabel();
</script>
