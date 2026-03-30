<!---
	<cf_dump var = "#form#">
--->
<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- Cantidad horas --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cantidad_Horas"
		Default="Cantidad horas"
		returnvariable="vCantidadHoras"/>

	<!--- Cantidad dias --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cantidad_Dias"
		Default="Cantidad Dias"
		returnvariable="vCantidadDias"/>

	<!--- Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Monto"
		Default="Monto"
		XmlFile="/rh/generales.xml"
		returnvariable="vMonto"/>

	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Valor"
		Default="Valor"
		XmlFile="/rh/generales.xml"		
		returnvariable="vValor"/>
		
	<!--- Concepto Incidente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Concepto_Incidente"
		Default="Concepto Incidente"
		xmlfile="/rh/generales.xml"		
		returnvariable="vConcepto"/>

	<!--- codigo --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Codigo"
		Default="C&oacute;digo"
		xmlfile="/rh/generales.xml"		
		returnvariable="vCodigo"/>		

	<!--- descripcion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		Default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"		
		returnvariable="vDescripcion"/>		

	<!--- Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Filtrar"
		Default="Filtrar"
		xmlfile="/rh/generales.xml"		
		returnvariable="vFiltrar"/>

	<!--- Limpiar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Limpiar"
		Default="Limpiar"
		xmlfile="/rh/generales.xml"		
		returnvariable="vLimpiar"/>		
 
	<!--- importe --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importe"
		Default="Importe"
		returnvariable="vImporte"/>
	<!--- exento --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Exento"
		Default="Exento"
		returnvariable="vExento"/>	
	<!--- grabado --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Grabado"
		Default="Grabado"
		returnvariable="vGrabado"/>	

	<!--- anterior --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Anterior"
		Default="Anterior"
		xmlfile="/rh/generales.xml"				
		returnvariable="vAnterior"/>		

	<!--- Siguiente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="BTN_Siguiente"
		Default="Siguiente"
		xmlfile="/rh/generales.xml"				
		returnvariable="vSiguiente"/>		
<!--- ============================================= --->
<!--- ============================================= --->

<cfif not isdefined("Form.Nuevo") and not isdefined("form.baja")>
	<cfif isdefined("Form.RHLPPid") AND Len(Trim(Form.RHLPPid)) GT 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
<cfelse>
	<cfset modo = "ALTA">
</cfif> 

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select CIid, 
		   {fn concat({fn concat(rtrim(CIcodigo), ' - ')}, CIdescripcion) } as Descripcion,
		   CIcantmin, 
		   CIcantmax, 
		   CItipo

	from CIncidentes

	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and CItipo != 3

	order by Descripcion
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsIncidencia" datasource="#Session.DSN#">
		select a.RHLPPid, 
        	   a.RHPLPid,
			   <!---a.DLlinea,---> 
			   a.DEid, 
			   a.CIid, 
			   a.Ecodigo, 
			   a.RHLPdescripcion, 
			   a.importe as Ivalor, 
			   a.fechaalta, 
			   a.RHLPautomatico, 
			   a.BMUsucodigo,
			   a.RHLIFiniquito,
			   b.*
		from RHLiqIngresosPrev a, CIncidentes b
		where a.RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLPPid#">
		<!---and a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">--->
		and a.CIid = b.CIid
	</cfquery>
	
</cfif>


<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
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
		f.obj.Ivalor.value = qf(f.obj.Ivalor.value);
		return true;
	}
	
	function changeValLabel() {
		var id = document.form1.CIid.value;
		var tipo = tipoConc[id];
		var a = document.getElementById("TDValorLabel");
		var t = null; 
		var t2 = null;
		switch (tipo) {
			<cfoutput>
			case 0: t = document.createTextNode("#vCantidadHoras#:"); objForm.Ivalor.description = "#vCantidadHoras#"; break;
			case 1: t = document.createTextNode("#vCantidadDias#:"); objForm.Ivalor.description = "#vCantidadDias#"; break;
			case 2: t = document.createTextNode("#vMonto#:"); objForm.Ivalor.description = "#vMonto#"; break;
			default: t = document.createTextNode("#vValor#:"); objForm.Ivalor.description = "#vValor#";
			</cfoutput>
		}
		if (a.hasChildNodes()) a.replaceChild(t,a.firstChild);
		else a.appendChild(t);
	}

	function limpiar(){
		document.filtro.fDEnombre.value = '';
		document.filtro.fDEidentificacion.value = '';
	}
	
	function funcAgregar() {
		document.lista.PASO.value=1;
	}
	
	function funcEliminar() {
		document.lista.PASO.value=0;
	}

	function funcAnterior() {
		objForm.CIid.required = false;
		document.form1.paso.value = 0;
	}

	function funcSiguiente() {
		objForm.CIid.required = false;
		document.form1.paso.value = 2;
	}
	
	//-->
</SCRIPT>

<cfoutput>
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

	<!--- ====================================================================== --->
	<!--- ====================================================================== --->
	<cfquery name="rs_parametro_810" datasource="#session.DSN#" >
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 810
	</cfquery>
	<cfif ucase(rs_parametro_810.Pvalor) eq 'YES'>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Manejo_de_Intereses_y_Liquidacion_de_Cesantia"
			Default="Manejo de Intereses y Liquidaci&oacute;n de Cesant&iacute;a"
			returnvariable="vTituloCesantia"/>		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Concepto_de_pago_asociado_a_interes_acumulado_por_cesantia"
			Default="Concepto de pago asociado a inter&eacute;s acumulado por cesant&iacute;a"
			returnvariable="vSeleccionarCesantia"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Motivo"
			Default="Motivo"
			returnvariable="vMotivo"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="BTN_Guardar"
			Default="Guardar"
			xmlfile="/rh/generales.xml"				
			returnvariable="vGuardar"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_El_monto_sera_recalculado_al_aprobar_la_liquidacion"
			Default="El monto ser&aacute; recalculado al aprobar la liquidaci&oacute;n"
			returnvariable="vImporteCalculado"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Renuncia"
			Default="Renuncia"
			returnvariable="vRenuncia"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Despido"
			Default="Despido"
			returnvariable="vDespido"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Concepto_para_pago_de_intereses_acumulados_por_cesantia"
			Default="Concepto para pago de intereses acumulados por cesantía"
			returnvariable="vConceptoJS"/>			
	
		<cfquery datasource="#session.DSN#" name="rs_concepto_cesantia">
			select CIid, motivoliq
			from RHLiqIngresosPrev
			where cesantia = 1
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>	
		<cfset v_concepto_cesantia = rs_concepto_cesantia.CIid >
	
		<cfif len(trim(v_concepto_cesantia)) eq 0 >
			<cfquery datasource="#session.DSN#"  name="rs_parametro_820">
				select coalesce(Pvalor, '0') as CIid
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 820
			</cfquery>	
			<cfset v_concepto_cesantia = rs_parametro_820.CIid >
		</cfif>
	
		<cfquery datasource="#session.DSN#" name="rs_conceptos">
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CItipo = 2
			order by CIcodigo, CIdescripcion
		</cfquery>	
	
		<!--- 	Realiza un precalculo de los montos que hay que pagarle al empleado 
				Es necesario el rollback para no dejar en firme los movimientos, pues
				es en la aprobacion donde quedan firmes. Esto solo lo hace si ya definio
				la incidencia para el pago de cesantia. 
		--->
		<cfif len(trim(rs_concepto_cesantia.CIid)) and len(trim(rs_concepto_cesantia.motivoliq))>
			<cftransaction>
				<cfinvoke component="rh.Componentes.RH_Cesantia" method="liquidacion" returnvariable="rs_calculadoces">
					<cfinvokeargument name="DEid" value="#form.DEid#">
					<cfinvokeargument name="tipo" value="#rs_concepto_cesantia.motivoliq#">
				</cfinvoke>
				<cftransaction action="rollback" />
			</cftransaction>
		</cfif>
	
		<form method="post" name="formCesantia" style="margin:0;" action="#CurrentPage#">
				<input type="hidden" name="paso" value="#Gpaso#">
				<input type="hidden" name="DEid" value="#form.DEid#">
				<cfif DLlinea NEQ 0>
				<input name="DLlinea" type="hidden" value="#DLlinea#">
				</cfif>
				<cfif modo EQ "CAMBIO">
					<input name="RHLPid" type="hidden" value="#rsIncidencia.RHLPid#">
				</cfif>
	
			<tr>
				<td>
					<table width="100%" border="0" align="center" cellpadding="3" style="background-color:##f5f5f5;" cellspacing="0" class="areaFiltro">
						<tr><td colspan="2"  bgcolor="##E8E8E8"><strong>#vTituloCesantia#</strong></td></tr>
						<tr>
							<td nowrap="nowrap">#vSeleccionarCesantia#:</td>
							<td width="1%" nowrap="nowrap">#vMotivo#:</td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap">
								<select name="CIid" >
									<cfloop query="rs_conceptos">
										<cfset v_ciid = rs_conceptos.CIid >
										<cfset v_cicodigo = rs_conceptos.CIcodigo >
										<cfset v_cidescripcion = rs_conceptos.CIdescripcion >
										<option value="#v_CIid#" <cfif v_concepto_cesantia eq v_ciid>selected</cfif> >#trim(v_CIcodigo)# - #trim(v_CIdescripcion)#</option>
									</cfloop>
								</select>
							</td>
							<td width="1%">
								<select name="motivo" >
									<option value="">-seleccionar-</option>
									<option value="D" <cfif rs_concepto_cesantia.motivoliq eq 'D'>selected</cfif> >#vDespido#</option>
									<option value="R" <cfif rs_concepto_cesantia.motivoliq eq 'R'>selected</cfif> >#vRenuncia#</option>
								</select>
							</td>
						</tr>
						
						<cfif isdefined("rs_calculadoces")>
							<tr>
								<td colspan="2">
									<table border="0" width="100%" cellpadding="2">
										<tr>
											<td width="1%" nowrap="nowrap">Monto Calculado:</td>
											<td>#LSNUmberFormat(rs_calculadoces.intereses, ',9.00')#</td>
											<td><em>* #vImporteCalculado#</em></td>
										</tr>
									</table>
								</td>
							</tr>
						</cfif>
						
						<tr>
							<td colspan="2" align="center" valign="middle"><cf_botones include="Guardar" includevalues="#vGuardar#" exclude="Alta,Limpiar" ></td>
						</tr>
	
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</form>
	</cfif>
	<!--- ====================================================================== --->
	<!--- ====================================================================== --->

  <tr>
    <td>
		<form action="#CurrentPage#" method="post" name="form1" onSubmit="javascript: return validaForm(this);">
			<input type="hidden" name="paso" value="#Gpaso#">
			<input type="hidden" name="DEid" value="#form.DEid#">
			<cfif RHPLPid NEQ 0 and modo NEQ "CAMBIO">
			<input name="RHPLPid" type="hidden" value="#RHPLPid#">
			</cfif>
			<cfif modo EQ "CAMBIO">
				<input name="RHPLPid" type="hidden" value="#rsIncidencia.RHPLPid#">
			</cfif>
            <cfif modo EQ "CAMBIO">
				<input name="RHLPPid" type="hidden" value="#rsIncidencia.RHLPPid#">
			</cfif>
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsIncidencia.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
			</cfif>  
			<table width="100%" border="0" cellpadding="3" class="areaFiltro" style="background-color:##f5f5f5;" cellspacing="0" align="center">
				<tr><td colspan="5"  bgcolor="##E8E8E8"><strong>Incidencias Adicionales</strong></td></tr>
			  <tr>
				<td class="fileLabel" align="right">#vConcepto#:</td>
				<td>
					 <cfif modo EQ "CAMBIO">
						<cf_rhCIncidentes onBlur="changeValLabel()" query="#rsIncidencia#" tabindex="1" IncluirTipo="2">
					  <cfelse>
						<cf_rhCIncidentes onBlur="changeValLabel()" tabindex="1" IncluirTipo="2">
					  </cfif>			
				</td>
				<td id="TDValorLabel" class="fileLabel" nowrap align="right"></td>
				<td id="TDValor" nowrap>
				  <input name="Ivalor" type="text" id="Ivalor" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA" and isdefined("rsIncidencia")>#LSCurrencyFormat(rsIncidencia.Ivalor, 'none')#<cfelse>0.00</cfif>" tabindex="1">
				</td>
				<td nowrap><input name="esFiniquito" type="checkbox" id="esFiniquito" <cfif modo EQ "CAMBIO"><cfif rsIncidencia.RHLIFiniquito eq 1>checked</cfif><cfelse>checked</cfif>>Es Finiquito</td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="4" align="center">
					<cf_botones modo=#modo# includebefore="Anterior" includebeforevalues="<< #vAnterior#" include="Siguiente" includevalues="#vSiguiente# >>" >	
				</td>
			  </tr>
			</table>
		</form>
	</td>
  </tr>

  <tr>
    <td>
		<form style="margin:0" name="filtro" method="post">
			<input type="hidden" name="paso" value="#Gpaso#">
			<input type="hidden" name="DEid" value="#form.DEid#">
			<cfif RHPLPid NEQ 0>
				<input name="RHPLPid" type="hidden" value="#RHPLPid#">
			</cfif>
			<table width="99%" align="center" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr><td colspan="4" bgcolor="##E8E8E8"><strong>Listado de Incidencias adicionales</strong></td></tr>
				<tr>
					<td valign="middle" nowrap="nowrap"><strong>#vConcepto#&nbsp;</strong> 
					</td>
					<td valign="middle" align="left"><strong>&nbsp;#vDescripcion# &nbsp;&nbsp;</strong>
					</td>
					<td align="center" rowspan="2" valign="middle">
						<input type="submit" name="btnFiltrar" value="#vFiltrar#">
					</td>
					<td align="center" rowspan="2" valign="middle">
						<input type="button" name="btnLimpiar" value="#vLimpiar#" onClick="javascript:limpiar();">
					</td>

				</tr>

				<tr>
					<td valign="middle" nowrap="nowrap">
						<input name="fCIcodigo" type="text" size="5" maxlength="5" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fCIcodigo")><cfoutput>#form.fCIcodigo#</cfoutput></cfif>">
					</td>

					<td valign="middle" align="left">
						<input name="fRHLPdescripcion" type="text" size="50" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fRHLPdescripcion")><cfoutput>#form.fRHLPdescripcion#</cfoutput></cfif>">
					</td>
				</tr>
			</table>
		</form>
	</td>
  </tr>
  
  <tr>
    <td>
		 <cfquery name="rsRHLiqIngresos" datasource="#session.DSN#">
			select	1 as paso, a.RHPLPid, a.DEid, b.RHLPPid, b.RHLPdescripcion as nombre, b.importe, c.CIcodigo, c.CIdescripcion, b.RHLIexento, b.RHLIgrabado
			from RHPreLiquidacionPersonal a

			  inner join RHLiqIngresosPrev b
				on  a.Ecodigo = b.Ecodigo
				and a.DEid = b.DEid
				and a.RHPLPid = b.RHPLPid
				and coalesce(b.cesantia, 0) = 0 

			  inner join CIncidentes c
				on  b.CIid = c.CIid
				and b.Ecodigo = c.Ecodigo
				
			where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			  and b.RHLPautomatico = 0
			<cfif isdefined("form.fCIcodigo") and len(trim(form.fCIcodigo))>
				and upper(c.CIcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(form.fCIcodigo))#%">
			</cfif>
			
			<cfif isdefined("form.fRHLPdescripcion") and len(trim(form.fRHLPdescripcion))>
				and upper(b.RHLPdescripcion) like '%#Ucase(Trim(form.fRHLPdescripcion))#%'
			</cfif>
			
			order by 2
		</cfquery> 
		 <cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsRHLiqIngresos#"/>
				<cfinvokeargument name="desplegar" value="CIcodigo, CIdescripcion, importe,RHLIexento,RHLIgrabado"/>
				<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#, #vExento#, #vGrabado#"/>
				<cfinvokeargument name="formatos" value="S, S, M, M, M"/>
				<cfinvokeargument name="align" value="left, left, right, right, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="keys" value="RHLPPid"/> 
				<cfinvokeargument name="showEmptyListMsg" value= "1"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="showLink" value= "true"/>
				<cfinvokeargument name="botones" value=""/>
				<cfinvokeargument name="irA" value= "#CurrentPage#"/>
		</cfinvoke>
	</td>
  </tr>
</table>
</cfoutput>

<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.CIid.required = true;
	objForm.CIid.description = "<cfoutput>#vConcepto#</cfoutput>";
	
	// Establecer la etiqueta inicial
	changeValLabel();
	

	<cfif ucase(rs_parametro_810.Pvalor) eq 'YES'>
		objFormCes = new qForm("formCesantia");
		objFormCes.CIid.required = true;
		objFormCes.CIid.description = "<cfoutput>#vConceptoJS#</cfoutput>";
		
		objFormCes.motivo.required = true;
		objFormCes.motivo.description = "<cfoutput>#vMotivo#</cfoutput>";
	</cfif>
	
	
	// 
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.CIid.required = false;
	}
	
	function limpiar(){
		//document.form1.CIid.value   	    	= '';
		document.filtro.fCIcodigo.value      		= ''; 
		document.filtro.fRHLPdescripcion.value	 	= ''; 
	}
</SCRIPT>
