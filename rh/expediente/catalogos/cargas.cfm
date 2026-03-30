<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Carga" default="Carga" returnvariable="vCarga" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde" xmlfile="/rh/generales.xml"	 returnvariable="vDesde" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Hasta" default="Hasta" xmlfile="/rh/generales.xml"	 returnvariable="vHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor_Empleado" default="Valor Empleado" returnvariable="vValorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor_Patrono" default="Valor Patrono" returnvariable="vValorPatrono" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml"	returnvariable="vDescripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Carga_Obrero_Patronal" default="Carga Obrero Patronal" xmlfile="/rh/generales.xml"	returnvariable="vCargaOP" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Inicial" default="Fecha Inicial" xmlfile="/rh/generales.xml" returnvariable="vFechaInicial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Final" default="Fecha Final" xmlfile="/rh/generales.xml" returnvariable="vFechaFinal" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
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

<cfset va_cambiocargas = ArrayNew(1)>	<!---====== Variable con los valores del conlis de cargas para el modo cambio =========---->

<cfif modo EQ "CAMBIO" and isdefined('form.DEid') and isdefined('form.DClinea')>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select 	a.DClinea, 
				a.DEid, 
				b.DCdescripcion, 
				CEdesde, 
				CEhasta, 
				b.DCmetodo, 
				c.ECauto, 
				a.CEvalorpat, 
				a.CEvaloremp,
				b.DCvalorpat,
				b.DCvaloremp
		from CargasEmpleado a

		inner join  DCargas b
		on a.DClinea=b.DClinea

		inner join ECargas c
		on b.ECid=c.ECid 

		where a.DClinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
		  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	

	<cfif rsForm.RecordCount NEQ 0>
		<cfset ArrayAppend(va_cambiocargas, rsForm.DCdescripcion)>
		<cfset ArrayAppend(va_cambiocargas, rsForm.DClinea)>
		<cfset ArrayAppend(va_cambiocargas, rsForm.ECauto)>
		<cfset ArrayAppend(va_cambiocargas, rsForm.DCmetodo)>
	</cfif>
	<cfquery name="rsDeduccAsoc" datasource="#session.DSN#">
		select 1
		from ACAsociados a
		inner join ACAportesAsociado b
			on b.ACAid = a.ACAid
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
	</cfquery>
</cfif>

<cfset navegacionCar = "">
<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "o=7">
<cfif isdefined("Form.DEid")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.DClinea")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "DClinea=" & Form.DClinea>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 

	<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
	<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
	<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
	<script language="JavaScript1.2" type="text/javascript">
	
	function validar(){	
		document.form1.CEvalorpat.value = qf(document.form1.CEvalorpat.value);
		document.form1.CEvaloremp.value = qf(document.form1.CEvaloremp.value);
		return true; 
	}
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisCargas.cfm?DEid=" + document.form1.DEid.value ,250,200,650,350);
	}
	
	function funcPreCarga(pn_valempleado,pn_valpatrono){
		if (pn_valempleado!= '' && pn_valpatrono != ''){
			document.form1.CEvalorpat.value = pn_valpatrono;
			document.form1.CEvaloremp.value = pn_valempleado;
			document.form1.CEvalorpat.value = fm(document.form1.CEvalorpat.value,2);
			document.form1.CEvaloremp.value = fm(document.form1.CEvaloremp.value,2);
		}
		else{
			document.form1.CEvalorpat.value = 0.00;
			document.form1.CEvaloremp.value = 0.00;
		}
	}
	</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="2" align="center">
	<table align="center" width="95%"><tr><td align="center">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
	</td>
	</tr>
	</table></td></tr>	
	<tr><td>&nbsp;</td></tr>
						
	<tr>
		<td>
			<table align="center" width="95%">
				<tr>
					<td>
					<td valign="top" width="40%">
					<cfquery name="rsLista" datasource="#session.DSN#">
						select c.ECdescripcion, a.DEid, a.DClinea, a.CEdesde, b.DCdescripcion, a.CEhasta, 7 as o, (0+1) as sel
						from CargasEmpleado a
						  inner join  DCargas b
							on a.DClinea = b.DClinea   
						  inner join ECargas c
						  	on b.ECid = c.ECid 

						where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
						order by c.ECdescripcion, b.DCdescripcion
					</cfquery>

						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaCar">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="DCdescripcion, CEdesde, CEhasta"/>
								<cfinvokeargument name="etiquetas" value="#vCarga#, #vDesde#, #vHasta#"/>
								<cfinvokeargument name="formatos" value="V, D, D"/>
								<cfinvokeargument name="formName" value="listaCargas"/>	
								<cfinvokeargument name="align" value="left,left, rigth"/>
								<cfinvokeargument name="ajustar" value="N"/>				
								<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
								<cfinvokeargument name="navegacion" value="#navegacionCar#"/>
								<cfinvokeargument name="Cortes" value="ECdescripcion"/>
						</cfinvoke>		
					</td>
						
					<td width="60%" valign="top">

						<form method="post" enctype="multipart/form-data" name="form1" action="SQLcargas.cfm" onsubmit="javascript:return validar();" >
							<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr> 
									<td colspan="4" align="center" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>"><cfif modo neq 'ALTA'><cf_translate key="LB_Modificar_Cargas">Modificar Cargas</cf_translate><cfelse><cf_translate key="LB_Agregar_Cargas">Agregar Cargas</cf_translate></cfif></td>
								</tr>

								<cfoutput>
								
								<tr>
									<td class="fileLabel">#vCarga#</td>
									<td class="fileLabel">#vFechaInicial#</td>
									<td class="fileLabel">#vFechaFinal#</td>
								</tr>

								<tr>
									<td nowrap>
										<cfif isdefined("rsForm") and rsform.ECauto EQ 1>
											<cfset vReadonly = 'yes'>
										<cfelse>
											<cfset vReadonly = 'no'>
										</cfif>
											<cf_conlis 
												campos="DCdescripcion,DClinea,ECauto,DCmetodo"
												asignar="DCdescripcion,DClinea,ECauto,DCmetodo"
												size="50,0,0,0"
												desplegables="S,N,N,N"
												modificables="N,N,N,N"						
												title="Lista de Cargas Obrero Patronales"
												tabla="DCargas a,ECargas b"
												columnas="a.ECid,ECdescripcion,DClinea,DCdescripcion,ECauto,DCmetodo,a.DCvaloremp,a.DCvalorpat"
												filtro="a.ECid=b.ECid
		 												and b.Ecodigo= #Session.Ecodigo# 
														and DClinea not in ( select distinct DClinea from CargasEmpleado where DEid = #form.DEid#)
														order by a.ECid, DCdescripcion"
												filtrar_por="DCdescripcion"
												desplegar="DCdescripcion"
												etiquetas="#vDescripcion#"
												formatos="S"
												align="left"								
												asignarFormatos="S,S,S,S"
												form="form1"
												showEmptyListMsg="true"
												Cortes="ECdescripcion"
												funcion="funcPreCarga"
												fparams="DCvaloremp,DCvalorpat"
												valuesArray="#va_cambiocargas#"
												readonly="#vReadonly#"
											/>
									</td>
									<cfif modo neq 'ALTA' and rsDeduccAsoc.REcordCount><cfset Lvar_ReadOnly = true><cfelse><cfset Lvar_ReadOnly = false></cfif>
									<td>
										<cfif modo neq 'ALTA' >
											<cfset fechaini = LSDateFormat(rsForm.CEdesde,"dd/mm/yyyy") >
										<cfelse>
											<cfset fechaini = "" >
										</cfif>
										<cf_sifcalendario form="form1" name="CEdesde" value=#fechaini# readonly="#Lvar_ReadOnly#">
									</td>	
								
									<td>
										<cfif modo neq 'ALTA' >
											<cfset fechafin = LSDateFormat(rsForm.CEhasta,"dd/mm/yyyy") >
										<cfelse>
											<cfset fechafin = "" >
										</cfif>
										<cf_sifcalendario form="form1" name="CEhasta" value=#fechafin# readonly="#Lvar_ReadOnly#">
									</td>	
								</tr>	
								
								<tr id="labelInput" >
									<td></td>
									<td class="fileLabel">#vValorPatrono#</td>
									<td class="fileLabel">#vValorEmpleado#</td>
								</tr>
								
								<tr>
									<td id="inputCheck" valign="baseline">
										<cfif isdefined('rsform')>
										<input name="ValorPatron" type="hidden" value="#rsForm.DCvalorpat#">
										<input name="ValorEmpleado" type="hidden" value="#rsForm.DCvaloremp#">
										</cfif>
										<input type="checkbox" name="check" <cfif modo neq 'ALTA' and rsDeduccAsoc.REcordCount>disabled</cfif> 
											<cfif modo neq 'ALTA'><cfif len(trim(rsForm.CEvalorpat)) eq 0>checked</cfif> <cfelse>checked</cfif> 
											onclick="javascript:fcheck(this);">
											<cf_translate key="LB_Tomar_valores_del_catalogo">Tomar valores del cat&aacute;logo</cf_translate>
									</td>
									<td id="inputPatrono" >
										<input name="CEvalorpat" type="text" style="text-align:right" 
											onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
											onfocus="javascript:this.select();" 
											onchange="javascript: fm(this,2);" 
											value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.CEvalorpat,'none')#<cfelse>0.00</cfif>" 
											size="18"  maxlength="18" >
									</td>
									<td id="inputEmpleado">
										<input name="CEvaloremp" type="text" style="text-align:right" 
											onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
											onfocus="javascript:this.select();" 
											onchange="javascript: fm(this,2);" 
											value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.CEvaloremp,'none')#<cfelse>0.00</cfif>" 
											size="18"  maxlength="18" ></td>
								</tr>

								<tr><td colspan="4">&nbsp;</td></tr>
								
								<tr> 
									<td colspan="4" align="center"> 
										<cfif isdefined('rsForm') and rsForm.ECauto EQ 1>
											<cf_botones modo="#modo#" exclude="Baja">
										<cfelse>
											<cfset Lvar_exclude = "">
											<cfif modo neq 'ALTA' and rsDeduccAsoc.REcordCount><cfset Lvar_exclude = "Cambio,Baja"></cfif>
											<cf_botones modo="#modo#" exclude="#Lvar_exclude#">
										</cfif>
									</td>
								</tr>
								
								<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
								
								</cfoutput>
							</table>
							<!--- Cargas--->
						</form>
					</td>
				</tr>																									  
			</table>
		</td>																									  
	</tr>  		
</table>
  
<script language="JavaScript" type="text/javascript">	
	function limpiar(){
		document.form1.DCdescripcion.value = '';
		document.form1.DClinea.value = '';
		document.form1.ECauto.value = '';
		document.form1.DCmetodo.value = '';
		document.form1.CEdesde.value = '';
		document.form1.CEhasta.value = '';
		document.form1.CEvalorpat.value = '';
		document.form1.CEvaloremp.value = '';
		document.form1.check.checked = false;		
	}
	function desplegar(value){		
		if (!value){
			document.getElementById("labelInput").style.display = 'none';
			document.getElementById("inputCheck").style.display = 'none';
			document.getElementById("inputPatrono").style.display = 'none';
			document.getElementById("inputEmpleado").style.display = 'none';
		}

	}

	function fcheck(obj){
		if ( obj.checked ){
			document.getElementById("labelInput").style.display = 'none';
			document.getElementById("inputCheck").style.display = '';
			document.getElementById("inputPatrono").style.display = 'none';
			document.getElementById("inputEmpleado").style.display = 'none';
			<cfif modo neq 'ALTA'>
			document.form1.CEvalorpat.value = document.form1.ValorPatron.value;
			document.form1.CEvaloremp.value = document.form1.ValorEmpleado.value;
			</cfif>
		}
		else{
			document.getElementById("labelInput").style.display = '';
			document.getElementById("inputCheck").style.display = '';
			document.getElementById("inputPatrono").style.display = '';
			document.getElementById("inputEmpleado").style.display = '';
		}
	}

//------------------------------------------------------------------------------------------			
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);	

	// Valida el campo ya sea si es monto o porcentaje
	function _isPorcentaje() {
		var valor = new Number(qf(this.obj.value));
		if (document.form1.DCmetodo.value == '1' && !document.form1.check.checked ) {
			if (valor > 100) {
			    this.error = this.description + " debe estar entre 0 y 100%.";
			} 
		}
	}
	_addValidator("isPorcentaje", _isPorcentaje);	

	<cfoutput>
	objForm.DClinea.required = true;
	objForm.DClinea.description = "#vCargaOP#";

	objForm.CEdesde.required = true;
	objForm.CEdesde.description = "#vFechaInicial#";
	
	objForm.CEdesde.validateFecha();
	objForm.CEhasta.validateFecha();
	objForm.CEhasta.description = "#vFechaFinal#";

	objForm.CEvalorpat.description = "#vValorPatrono#";
	objForm.CEvaloremp.description = "#vValorEmpleado#";
	objForm.CEvalorpat.validatePorcentaje();
	objForm.CEvaloremp.validatePorcentaje();
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.CEdesde.required = false;
	}
	

	<cfif modo eq 'ALTA'>
		fcheck(document.form1.check);
	<cfelseif modo neq 'ALTA' >
		<!--- <cfif rsForm.ECauto eq 1 >
			desplegar(false); --->
		<cfif len(trim(rsForm.CEvalorpat)) eq 0 >	
			fcheck(document.form1.check);
		</cfif>
	</cfif>
</script>