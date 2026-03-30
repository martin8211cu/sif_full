
<!--- Consultas --->
<!--- 1. Conceptos de Incidencias --->
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select 	a.CIid, 
			{fn concat(rtrim(a.CIcodigo),{fn concat(' - ',a.CIdescripcion)})} as Descripcion,
			a.CIcantmin, 
			a.CIcantmax, 
			a.CItipo
	from CIncidentes a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.CItipo != 3
	  and a.CIcarreracp = 0
	  <!---- Excluir los conceptos incidentes que estén ligados a un componente salarial ----->
	  and not exists (select 1 
						from ComponentesSalariales b
						where a.CIid = b.CIid
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						)
	order by 2
</cfquery>
<!--- 5. Calendario de Pagos --->
<cfquery name="rsCalendario" datasource="#session.DSN#">
	select CPtipo
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>
<cfif rsCalendario.CPtipo EQ 2>
	<cfset Lvar_Anticipo = 1>
<cfelse>
	<cfset Lvar_Anticipo = 0>
</cfif>
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
		   	a.Usucodigo, a.Ulocalizacion, 
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


<!----=============== TRADUCCION =================----->
<cfinvoke key="LB_Cantidad_horas" default="Cantidad horas"	 returnvariable="LB_Cantidad_horas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Cantidad_dias" default="Cantidad días"	 returnvariable="LB_Cantidad_dias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Monto" default="Monto"	 returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor" default="Valor"	 returnvariable="LB_Valor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_La_Cantidad_digitada_se_sale_del_rango_permitido" default="La Cantidad digitada se sale del rango permitido"	 returnvariable="LB_La_Cantidad_digitada_se_sale_del_rango_permitido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoPuedeSerCero" default="  no puede ser cero"	 returnvariable="LB_NoPuedeSerCero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" xmlfile="/rh/generales.xml" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Concepto_de_Incidencia" default="Concepto de Incidencia"	 returnvariable="LB_Concepto_de_Incidencia" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Aceptar ---->
<cfinvoke key="BTN_Aceptar" default="Aceptar" returnvariable="BTN_Aceptar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
	
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
				<cfoutput>
				case 0: t = document.createTextNode("#LB_Cantidad_horas#"); objForm.ICvalor.description = "#LB_Cantidad_horas#"; break;
				case 1: t = document.createTextNode("#LB_Cantidad_dias#"); objForm.ICvalor.description = "#LB_Cantidad_dias#"; break;
				case 2: t = document.createTextNode("#LB_Monto#"); objForm.ICvalor.description = "#LB_Monto#"; break;
				default: t = document.createTextNode("#LB_Valor#"); objForm.ICvalor.description = "#LB_Valor#";
				</cfoutput>
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
<form name="form1" method="post" action="ResultadoModify-sql.cfm" onsubmit="javascript: return validaForm(this);">
	<table width="95%" border="0" cellspacing="0" cellpadding="3">
    	<!--- Línea No. 1 --->
		<tr> 
        	<td class="fileLabel"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
        	<td class="fileLabel">#LB_Concepto_de_Incidencia#</td>
	  	</tr>
	  	<!--- Linea No. 2 --->
      	<tr> 
        	<td>
				<cfif modo NEQ "ALTA">
					<cfset fecha = LSDateFormat(rsIncidencia.fecha,'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
				</cfif>
				<cf_sifcalendario form="form1" value="#fecha#" name="ICfecha" onChange="CambiaCF();">				   
			</td>
        	<td>
		  		<!---
				<cfif modo NEQ "ALTA">
					<cf_rhCIncidentes onBlur="changeValLabel()" query="#rsIncidencia#" tabindex="1" ExcluirTipo="3" IncluirAnticipo="#Lvar_Anticipo#">
		  		<cfelse>
					<cf_rhCIncidentes onBlur="changeValLabel()" tabindex="1" ExcluirTipo="3"  IncluirAnticipo="#Lvar_Anticipo#">
		  		</cfif> 
				----->				
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
					campos = "CIid,CIcodigo,CIdescripcion,CItipo" 
					desplegables = "N,S,S,N" 
					modificables = "N,S,N,N" 
					size = "0,10,20"
					asignar="CIid,CIcodigo,CIdescripcion,CItipo"
					asignarformatos="I,S,S,I"
					tabla="	CIncidentes a"																	
					columnas="CIid,CIcodigo,CIdescripcion,CInegativo,CItipo"
					filtro="a.Ecodigo =#session.Ecodigo#							
							and CInoanticipo = #Lvar_Anticipo#
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
        	</td>
	  	</tr>
	  	<!--- Línea No. 3 --->
	  	<tr>
        	<td id="TDValorLabel" class="fileLabel">&nbsp;</td>
			<td class="fileLabel"><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></td>
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
      	<tr align="center"> 
        	<td colspan="2">
				<cf_templatecss>
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="IAlta" value="#BTN_Aceptar#">
				<cfelse>	
					<input type="submit" name="ICambio" value="#BTN_Aceptar#">
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
<iframe name="CentroFuncionalx" id="CentroFuncionalx" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>

</cfoutput>

<!---activado en parametros generales--->
<cfquery name="rsCargarCF" datasource="#Session.DSN#">
	select Pvalor
		from RHParametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2105
</cfquery>

<cfif trim(rsCargarCF.Pvalor) eq 1>

	<script language="JavaScript">
	<cfoutput>
		<cfif trim(rsCargarCF.Pvalor) eq 1>
			var fecha=document.form1.ICfecha.value;
			var DEid = #form.DEid#;
			
			document.getElementById('CentroFuncionalx').src = 'CambiaCentroFuncional.cfm?Fecha='+fecha+'&DEid='+DEid;
		</cfif>	
	</cfoutput>	
	</script>
</cfif>

<script language="JavaScript">
	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	function __isRangoCantidad() {
		if ((tipoConc[this.obj.form.CIid.value] == 0 || tipoConc[this.obj.form.CIid.value] == 1) && (parseFloat(qf(this.value)) < rangoMin[this.obj.form.CIid.value] || parseFloat(qf(this.value)) > rangoMax[this.obj.form.CIid.value])) {
			this.error = <cfoutput>"#LB_La_Cantidad_digitada_se_sale_del_rango_permitido#"</cfoutput>;
		}
	}

	function __isNotCero() {
		if ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0)) {
			this.error = this.description + ' '+ <cfoutput>"#LB_NoPuedeSerCero#"</cfoutput>;
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
	
	<cfoutput>
	objForm.ICfecha.required = true;
	objForm.ICfecha.description = "#LB_Fecha#";
	
	objForm.CIid.required = true;
	objForm.CIid.description = "#LB_Concepto_de_Incidencia#";
	objForm.CIid.validateIncidenciaNoExiste();
	</cfoutput>
	objForm.ICvalor.required = true;
	objForm.ICvalor.description = "";
	objForm.ICvalor.validateNotCero();
	objForm.ICvalor.validateRangoCantidad();
	
	// Establecer la etiqueta inicial
	changeValLabel();
	
	function CambiaCF(){
		<cfif trim(rsCargarCF.Pvalor) eq 1>
			var fecha=document.form1.ICfecha.value;
		<cfoutput>
			var DEid = #form.DEid#;
		</cfoutput>
			document.getElementById('CentroFuncionalx').src = 'CambiaCentroFuncional.cfm?Fecha='+fecha+'&DEid='+DEid;
		</cfif>	
	}
	
</script>
