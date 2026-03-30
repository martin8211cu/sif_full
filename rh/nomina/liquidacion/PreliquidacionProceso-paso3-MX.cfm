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

	<!--- importe --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importe"
		Default="Importe"
		returnvariable="vImporte"/>		

	<!--- Provisiones --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Provisiones"
		Default="Provisiones"
		returnvariable="vProvisiones"/>		
<!--- ============================================= --->
<!--- ============================================= --->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.RHLPCid") AND Len(Trim(Form.RHLPCid)) GT 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
<cfelse>
	<cfset modo = "ALTA">
</cfif>


<cfif modo NEQ "ALTA">
	<cfquery name="rsRHLiqCargasPrev" datasource="#Session.DSN#">
		select a.RHLPCid, a.RHPLPid, a.DEid, a.DClinea, a.SNcodigo, a.Ecodigo, a.RHLCdescripcion, 
		a.importe, a.fechaalta, a.RHLCautomatico, a.BMUsucodigo, a.ts_rversion
		from RHLiqCargasPrev a
		where a.RHLPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLPCid#">
		and a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPID#">
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

	

	function validaForm(f) {
		f.obj.Ivalor.value = qf(f.obj.Ivalor.value);
		f.obj.DCdescripcion.disabled = false;
		f.obj.DClinea.required = false;
		return true;
		
	}
	
	function limpiarfiltro(){
		document.filtro.fDCcodigo.value = '';
		document.filtro.fDCdescripcion.value = '';
	}
	
	function funcAlta() {
		document.lista.PASO.value=3;
		document.form1.DClinea.required = false;
	}
	function funcNuevo() {
		document.lista.PASO.value=3;
		document.form1.DClinea.required = false;
		
	}
	function funcBaja() {
		document.lista.PASO.value=2;
		document.form1.DClinea.required = false;
	}
	function funcSiguiente() {
		objForm.DClinea.required = false;
		document.form1.paso.value = 4;
	}
	
	//-->
</SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
		
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("/cfmx/rh/expediente/catalogos/ConlisCargas.cfm?DEid=" + document.form1.DEid.value ,250,200,650,350);
	}
	</script>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<form action="#CurrentPage#" method="post" name="form1" onSubmit="javascript: return validaForm(this);">
			<input type="hidden" name="paso" value="#Gpaso#">
			<input type="hidden" name="DEid" value="#form.DEid#">
			<cfif RHPLPID NEQ 0>
			<input name="RHPLPID" type="hidden" value="#RHPLPID#">
			</cfif>
			
				<input name="RHLPCid" type="hidden" value="<cfif modo EQ "CAMBIO">#rsRHLiqCargasPrev.RHLPCid#</cfif>">
			
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsRHLiqCargasPrev.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
			</cfif>  
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			  <tr>
				<td class="fileLabel" align="right"><strong>#vProvisiones#:</strong></td>
				<td nowrap>
                  <input name="DCdescripcion" disabled type="text" value="<cfif modo NEQ "ALTA" >#rsRHLiqCargasPrev.RHLCdescripcion#</cfif>" size="50" maxlength="50">
                  <cfif modo eq 'ALTA'>
                    <a href="javascript:doConlis();"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle"> </a>
                  </cfif>
                  <input type="hidden" name="DClinea" value="">
                  <input type="hidden" name="ECauto" value="">
                  <input type="hidden" name="DCmetodo" value="">
                </td>
				<td id="TDValorLabel" class="fileLabel" nowrap align="right"><strong>#vImporte#:</strong></td>
				<td id="TDValor" nowrap>
                  <input name="Ivalor" type="text" id="Ivalor" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA" and isdefined("rsRHLiqCargasPrev")>#LSCurrencyFormat(rsRHLiqCargasPrev.importe, 'none')#<cfelse>0.00</cfif>" tabindex="1">
                </td>
			  </tr>
			  <tr>
				<td colspan="4">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="4">
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
			<cfif RHPLPID NEQ 0>

				<input name="RHPLPID" type="hidden" value="#RHPLPID#">
			</cfif>
			<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td valign="middle"><strong><span class="fileLabel"><cf_translate key="LB_Provisiones">Provisiones</cf_translate>:</span>&nbsp;</strong> 
						<input name="fDCcodigo" type="text" size="5" maxlength="3" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDCcodigo")><cfoutput>#form.fDCcodigo#</cfoutput></cfif>">				  </td>
					<td valign="middle" align="left"><strong>&nbsp;#vDescripcion#: &nbsp;&nbsp;</strong>
						<input name="fDCdescripcion" type="text" size="50" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDCdescripcion")><cfoutput>#form.fDCdescripcion#</cfoutput></cfif>">
					</td>
					<td colspan="4" align="center">
						<input type="submit" name="btnFiltrar" value="#vFiltrar#">
						<input type="button" name="btnLimpiar" value="#vLimpiar#" onClick="javascript:limpiarfiltro();">
					</td>
				</tr>
			</table>
		</form>
	</td>
  </tr>
  <tr>
    <td>
		 <cfquery name="rsRHLiqCargasPrev" datasource="#session.DSN#">
			select	3 as paso, a.RHPLPid, a.DEid, 
				b.RHLPCid, b.DEid, b.DClinea, b.SNcodigo, b.RHLCdescripcion, 
				b.importe, b.fechaalta, b.RHLCautomatico, b.BMUsucodigo,
				d.ECid, d.SNcodigo, d.DCcodigo, d.DCmetodo, d.DCdescripcion, d.DCvaloremp, d.DCvalorpat, 
				d.DCprovision, d.DCnorenta, d.DCtipo, d.SNreferencia, d.DCcuentac, d.DCtiporango, d.DCrangomin, 
				d.DCrangomax, d.BMUsucodigo
			from RHPreLiquidacionPersonal a
			  inner join RHLiqCargasPrev b
				on  a.Ecodigo = b.Ecodigo
				and a.DEid = b.DEid
				and a.RHPLPid = b.RHPLPid
			  inner join DCargas d 
				on  b.DClinea = d.DClinea
				and b.Ecodigo = d.Ecodigo
 				and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.fDCcodigo") and len(trim(form.fDCcodigo))>
				and upper(d.DCcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(form.fDCcodigo))#%">
			</cfif>
			
			<cfif isdefined("form.fDCdescripcion") and len(trim(form.fDCdescripcion))>
				and upper(d.DCdescripcion) like '%#Ucase(Trim(form.fDCdescripcion))#%'
			</cfif>
			where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			order by 2
		</cfquery> 

		 <cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsRHLiqCargasPrev#"/>
				<cfinvokeargument name="desplegar" value="DCcodigo, DCdescripcion, importe "/>
				<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vImporte#"/>
				<cfinvokeargument name="formatos" value="S, S, M"/>
				<cfinvokeargument name="align" value="left, left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="keys" value="RHLPCid"/> 
				<cfinvokeargument name="showEmptyListMsg" value= "1"/>
				<cfinvokeargument name="showLink" value= "true"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="botones" value=""/>
				<cfinvokeargument name="irA" value= "#CurrentPage#"/>
		</cfinvoke>
	</td>
  </tr>
</table>
</cfoutput>

<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
		
	objForm.DClinea.required = true;
	objForm.DClinea.description = "#vProvisiones#";
	 <cfif modo neq 'ALTA'>
		objForm.DCdescripcion.disabled = false;
		objForm.DClinea.required = false;
	 </cfif>
	
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		document.form1.DClinea.required = false;
	}
	
	function limpiar(){
		document.form1.RHLPCid.value = '';
		document.form1.DCdescripcion.value = ''; 
		document.form1.Ivalor.value = ''; 
	}
</SCRIPT>
</cfoutput>