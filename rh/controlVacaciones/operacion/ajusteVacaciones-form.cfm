
<!--- Etiquetas de Traducción --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	Default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"	
	returnvariable="vDescripcion"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	Default="Fecha"
	xmlfile="/rh/generales.xml"	
	returnvariable="vFecha"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Monto"
	Default="Monto"
	xmlfile="/rh/generales.xml"	
	returnvariable="vMonto"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dias_enfermedad"
	Default="D&iacute;as de enfermedad"
	returnvariable="vDiasEnfermedad"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dias_disfrutados"
	Default="D&iacute;as disfrutados"
	returnvariable="vDiasDisfrutados"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dias_compensados"
	Default="D&iacute;as compensados"
	returnvariable="vDiasCompensados"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Modificar"
	Default="Modificar"
	xmlfile="/rh/generales.xml"
	returnvariable="vModificar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Agregar"
	Default="Agregar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vAgregar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Limpiar"
	Default="Limpiar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vLimpiar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Filtrar"
	Default="Filtrar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vFiltrar"/>

<!--- Definición de Variables de Ambiente --->
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.txtDescripcion") and not isdefined("Form.txtDescripcion")>
	<cfparam name="Form.txtDescripcion" default="#Url.txtDescripcion#">
</cfif>

<!--- Definición del MODO --->
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

<!--- Consultas --->
<cfif isdefined('form.DEid') and form.DEid NEQ ''>
	<cfquery datasource="#Session.DSN#" name="rsEncab">
		select EVfantig
		from EVacacionesEmpleado eve
		  inner join DatosEmpleado de
		    on eve.DEid=de.DEid
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and eve.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<cfset vOpcion = true >

<cfif modo EQ "CAMBIO" and isdefined('form.DEid') and form.DEid NEQ '' <!--- and isdefined('form.DVElinea') and form.DVElinea NEQ '' --->>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select DVEfecha,
			DVEdescripcion,
			DVEdisfrutados,
			DVEcompensados,
			DVEenfermedad,
			DVEmonto
		from DVacacionesEmpleado
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and DVElinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DVElinea#">
	</cfquery>	

	<cfif (Abs(rsForm.DVEdisfrutados) + Abs(rsForm.DVEcompensados) eq 0) and (abs(rsForm.DVEenfermedad) + 1) gt 1 >
		<cfset vOpcion = false >
	</cfif>
</cfif>

<cfset filtroVaca = "">
<cfset navegacionVaca = "">
<cfset f_vaca = "">
<cfset navegacionVaca = navegacionVaca & Iif(Len(Trim(navegacionVaca)) NEQ 0, DE("&"), DE("")) & "o=8">

<cfif isdefined("Form.txtDescripcion") and Len(Trim(Form.txtDescripcion)) NEQ 0>
	<cfset filtroVaca = filtroVaca & " and upper(DVEdescripcion) like Upper('%" & #UCase(Form.txtDescripcion)# & "%')">
	<cfset f_vaca = "txtDescripcion='" & Form.txtDescripcion & "',">	
	<cfset navegacionVaca = navegacionVaca & Iif(Len(Trim(navegacionVaca)) NEQ 0, DE("&"), DE("")) & "txtDescripcion=" & Form.txtDescripcion>
</cfif>
<cfif isdefined("Form.DEid")>
	<cfset navegacionVaca = navegacionVaca & Iif(Len(Trim(navegacionVaca)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif> 
<cfif isdefined("Form.sel")>
	<cfset navegacionVaca = navegacionVaca & Iif(Len(Trim(navegacionVaca)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 
<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea))>
	<cfset f_vaca = "'#Form.RHAlinea#' as RHAlinea, ">	
	<cfset navegacionVaca = navegacionVaca & Iif(Len(Trim(navegacionVaca)) NEQ 0, DE("&"), DE("")) & "RHAlinea=" & Form.RHAlinea>
</cfif>

<!--- Pintado de la Pantalla --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	</tr>
	<tr>
		<td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
				<tr>
			  		<td width="46%" align="center" valign="top">
			  
			  			<table width="99%" border="0" cellspacing="3" cellpadding="3">
				  			<tr>
								<td>
									<form name="formFiltroListaVaca" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
										<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea))>
											<input type="hidden" name="RHAlinea" value="<cfoutput>#form.RHAlinea#</cfoutput>">
										</cfif>
										<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
										<input name="sel" type="hidden" value="1">
										<input type="hidden" name="o" value="8">				

										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
								  			<tr> 
												<td colspan="2" class="fileLabel"><cfoutput>#vDescripcion#</cfoutput>
													<input name="txtDescripcion" type="text" id="txtDescripcion" size="35" maxlength="60" value="<cfif isdefined('form.txtDescripcion')><cfoutput>#form.txtDescripcion#</cfoutput></cfif>">
												</td>
												<td class="fileLabel">
													<input name="btnFiltrarVaca" type="submit" id="btnFiltrarVaca" value="<cfoutput>#vFiltrar#</cfoutput>">
												</td>
								  			</tr>
										</table>
					  				</form>							
								</td>
						  	</tr>
						  	<tr>
								<td nowrap>
									<cfquery name="rsLista" datasource="#session.DSN#">
										select  #PreserveSingleQuotes(f_vaca)# 
											DVElinea,
											dve.DEid,
											<cf_dbfunction name="string_part"   args="DVEdescripcion,1,25"> as DVEdescripcion,
											DVEfecha, 8 as o, 1 as sel 							
										from DVacacionesEmpleado dve
								    		inner join DatosEmpleado de
									  			on dve.DEid=de.DEid
									  			and dve.Ecodigo=de.Ecodigo											
										where dve.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  
							      			and dve.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
								   			<cfif isdefined("filtroVaca") and Len(trim(filtroVaca))>
									  			#PreserveSingleQuotes(filtroVaca)#
								  			</cfif>							
								 		order by DVEfecha											
									</cfquery>
									<!--- Pintado de la Lista --->
									<cfinvoke 
								 	 component="rh.Componentes.pListas"
								 	 method="pListaQuery"
								 	 returnvariable="pListaFam">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="DVEdescripcion,DVEfecha"/>
										<cfinvokeargument name="etiquetas" value="#vDescripcion#,#vFecha#"/>
										<cfinvokeargument name="formatos" value="V,D"/>
										<cfinvokeargument name="formName" value="listaVacaciones"/>	
										<cfinvokeargument name="align" value="left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>			
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>			
										<cfinvokeargument name="navegacion" value="#navegacionVaca#"/>
									</cfinvoke>							
								</td>
						  	</tr>
						</table>
				  	</td>
				  	<td width="4%" align="center" valign="top">&nbsp;</td>
				  	<td width="50%" valign="top" nowrap> 
					  	<cfoutput>
						<form name="formVacacionesEmpl" action="ajusteVacaciones-sql.cfm" enctype="multipart/form-data" method="post" onSubmit="return validar();">
							<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea))>
								<input type="hidden" name="RHAlinea" value="<cfoutput>#form.RHAlinea#</cfoutput>">
							</cfif>
							<input name="DEid" type="hidden" value="<cfif isdefined('form.DEid') and form.DEid NEQ ''><cfoutput>#form.DEid#</cfoutput></cfif>">
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr> 
									<td colspan="2" class="#Session.preferences.Skin#_thcenter" style="padding-left: 5px;"><cf_translate key="LB_Datos_de_vacaciones">Datos de vacaciones</cf_translate></td>
							  	</tr>						
							  	<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
							  	</tr>						  
							  	<tr>
									<td colspan="2" align="center">
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td nowrap="nowrap"><strong><cf_translate key="LB_Trabajar_con">Trabajar con</cf_translate>:&nbsp;</strong></td>
												<td><input style="background-color:##FFFFFF;" type="radio" <cfif modo neq 'ALTA'>disabled</cfif> name="opcion" value="V" <cfif isdefined("vopcion") and vOpcion >checked</cfif> onclick="javascript:mostrar(this);"  ></td>
												<td nowrap="nowrap"><strong><cf_translate key="LB_Dias_de_Vacaciones">D&iacute;as de Vacaciones</cf_translate></strong></td>
												<td><input style="background-color:##FFFFFF;" type="radio" <cfif modo neq 'ALTA'>disabled</cfif> name="opcion" value="E" <cfif isdefined("vopcion") and not vOpcion >checked</cfif> onclick="javascript:mostrar(this);" ></td>
												<td nowrap="nowrap"><strong><cf_translate key="LB_Dias_de_Enfermedad">D&iacute;as de Enfermedad</cf_translate></strong></td>
											</tr>
										</table>
									</td>
							  	</tr>						  
							  	<tr>
									<td width="47%" nowrap="nowrap"><strong><cf_translate key="LB_Fecha_de_antiguedad">Fecha de antiguedad</cf_translate>:</strong></td>
									<td width="53%"><strong><cfoutput>#LSDateFormat(rsEncab.EVfantig,"dd/mm/yyyy")#</cfoutput></strong></td>
							  	</tr>
							  	<tr>
									<td colspan="2"><hr></td>
							  	</tr>
							  	<tr>
									<td><strong>#vFecha#</strong></td>
									<td id="labelMonto" <cfif not vOpcion>style="display:none;"</cfif>><strong>#vMonto#</strong></td>
							  	</tr>
							  	<tr>
									<td>
										<cfif MODO EQ "ALTA">
											<cf_sifcalendario form="formVacacionesEmpl" name="DVEfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
										<cfelse>
											<cfoutput>
												<cf_sifcalendario form="formVacacionesEmpl" name="DVEfecha" value="#LSDateFormat(rsForm.DVEfecha,'DD/MM/YYYY')#">
											</cfoutput>
										</cfif>							
									</td>
									<td id="inputMonto" <cfif not vOpcion>style="display:none;"</cfif>><input name="DVEmonto" type="text" <cfif modo NEQ "ALTA">readonly</cfif>  value="<cfif modo NEQ "ALTA">#rsForm.DVEmonto#<cfelse>0.00</cfif>" size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="Monto"></td>
							  	</tr>
							  	<tr>
									<td id="label" nowrap="nowrap"><strong><cfif not vOpcion ><cf_translate key="LB_Dias_por_Enfermedad">D&iacute;as por Enfermedad</cf_translate><cfelse>#vDiasDisfrutados#</cfif></strong></td>
									<td id="label2" <cfif not vOpcion>style="display:none;"</cfif>><strong>#vDiasCompensados#</strong></td>
							  	</tr>
							  	<tr>
									<td nowrap>
										<cfset cantidad = 0 >
										<cfif modo NEQ 'ALTA'>
											<cfif vOpcion >
												<input name="DVEdisfrutados" type="text" readonly value="#abs(rsForm.DVEdisfrutados)#" size="10" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="D&iacute;as Disfrutados">
												<cfset cantidad = rsForm.DVEdisfrutados >
											<cfelse>
												<input name="DVEdisfrutados" type="text" readonly value="#abs(rsForm.DVEenfermedad)#" size="10" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="D&iacute;as de Enfermedad">
												<cfset cantidad = rsForm.DVEenfermedad >
											</cfif>
										<cfelse>
											<input name="DVEdisfrutados" type="text" value="0.00" size="10" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="D&iacute;as Disfrutados">
										</cfif>	
									
										<select name="ajustevac" <cfif modo neq 'ALTA'>disabled</cfif>>
											<option value="S" <cfif modo neq 'ALTA' and cantidad gte 0>selected</cfif> ><cf_translate key="LB_Suma">Suma</cf_translate></option>
											<option value="R" <cfif modo neq 'ALTA' and cantidad lt 0>selected</cfif> ><cf_translate key="LB_Resta">Resta</cf_translate></option>
										</select>
									</td>
									<td id="input"  <cfif not vOpcion>style="display:none;"</cfif>  >
										<input name="DVEcompensados" type="text" <cfif modo NEQ "ALTA">readonly</cfif> value="<cfif modo NEQ "ALTA">#abs(rsForm.DVEcompensados)#<cfelse>0.00</cfif>" size="10" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="D&iacute;as Compensados">
										<select name="ajustecom" <cfif modo neq 'ALTA'>disabled</cfif>>
											<option value="S" <cfif modo neq 'ALTA' and rsForm.DVEcompensados gte 0>selected</cfif> ><cf_translate key="LB_Suma">Suma</cf_translate></option>
											<option value="R" <cfif modo neq 'ALTA' and rsForm.DVEcompensados lt 0>selected</cfif> ><cf_translate key="LB_Resta">Resta</cf_translate></option>
										</select>
									</td>
							  	</tr>
							  	<tr>
									<td><strong>#vDescripcion#</strong></td>
									<td>&nbsp;</td>
							  	</tr>
							  	<tr>
									<td colspan="2"><input name="DVEdescripcion" value="<cfif modo NEQ "ALTA">#rsForm.DVEdescripcion#</cfif>" type="text" id="DVEdescripcion" size="60" maxlength="60"></td>
							  	</tr>
							  	<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
							  	</tr>
							  	<tr>
									<td colspan="2" align="center">
										<cfif modo NEQ 'ALTA'>
											<input type="submit" name="btnNuevo"   value="#vModificar#" onClick="javascript: setBtn(this); deshabilitarValidacion();" >																
										<cfelse>
											<input type="submit" name="btnAgregar" value="#vAgregar#" onClick="javascript: setBtn(this);" >								
											<input type="reset"  name="btnLimpiar"  value="#vLimpiar#" >																				
										</cfif>
									</td>
							  	</tr>						  						  
							</table>
						</form>					
						</cfoutput>
			  		</td>
				</tr>	
		  	</table>
	    </td>
	</tr>
</table>
  
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	botonActual = "";

	function mostrar(obj){
		var contenido = '';
		var input = '';
		if ( obj.value == 'V' ){
			objForm.DVEdisfrutados.description = "#vDiasDisfrutados#";	
			document.getElementById('label').innerHTML = '<strong>#vDiasDisfrutados#</strong>';
			document.getElementById('label2').innerHTML = '<strong>#vDiasCompensados#</strong>';
			document.getElementById('label2').style.display = '';
			document.getElementById('input').style.display = '';
			document.getElementById('labelMonto').style.display = '';
			document.getElementById('inputMonto').style.display = '';
			
			<cfif modo neq 'ALTA'>
				document.formVacacionesEmpl.DVEdisfrutados.value = '<cfoutput>#rsForm.DVEdisfrutados#</cfoutput>'
			<cfelse>
				document.formVacacionesEmpl.DVEdisfrutados.value = '0.00';
			</cfif>
		}
		else{
			objForm.DVEdisfrutados.description = "#vDiasEnfermedad#";	
			document.getElementById('label').innerHTML = '<strong>#vDiasEnfermedad#</strong>';
			document.getElementById('label2').style.display = 'none';
			document.getElementById('input').style.display = 'none';
			document.getElementById('labelMonto').style.display = 'none';
			document.getElementById('inputMonto').style.display = 'none';

			<cfif modo neq 'ALTA'> 
				document.formVacacionesEmpl.DVEdisfrutados.value = '<cfoutput>#rsForm.DVEenfermedad#</cfoutput>'
			<cfelse>
				document.formVacacionesEmpl.DVEdisfrutados.value = '0.00';
			</cfif>
		}
	}

	function setBtn(obj) {
		botonActual = obj.name;
	}

	function validar(){
		document.formVacacionesEmpl.DVEdisfrutados.value = qf(document.formVacacionesEmpl.DVEdisfrutados.value);
		document.formVacacionesEmpl.DVEcompensados.value = qf(document.formVacacionesEmpl.DVEcompensados.value);
		document.formVacacionesEmpl.DVEmonto.value =  qf(document.formVacacionesEmpl.DVEmonto.value);
		return true;
	}

	function btnSelected(name, f) {
		return (botonActual == name)
	}

	function deshabilitarValidacion(){
		objForm.DVEfecha.required = false;
		objForm.DVEmonto.required = false;
		objForm.DVEdescripcion.required = false;
	}

	function habilitarValidacion(){
		objForm.DVEfecha.required = true;
		objForm.DVEmonto.required = true;
		objForm.DVEdescripcion.required = true;						
	}

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			

	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("formVacacionesEmpl");
	
	objForm.DVEfecha.required = true;
	objForm.DVEfecha.description = "#vFecha#";	
	objForm.DVEmonto.required = true;
	objForm.DVEmonto.description = "#vMonto#";
	objForm.DVEdisfrutados.required = true;
	objForm.DVEdisfrutados.description = "#vDiasDisfrutados#";	
	objForm.DVEcompensados.required = true;
	objForm.DVEcompensados.description = "#vDiasCompensados#";	
	objForm.DVEdescripcion.required = true;
	objForm.DVEdescripcion.description = "#vDescripcion#";	
</script>
</cfoutput>