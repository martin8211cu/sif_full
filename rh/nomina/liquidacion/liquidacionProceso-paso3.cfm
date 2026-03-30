<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
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

	<!--- porcentaje --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Porcentaje"
		Default="Porcentaje"
		returnvariable="vPorcentaje"/>		

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

	<!--- Socio --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Socio_de_Negocios"
		xmlfile="/rh/generales.xml"
		Default="Socio de Negocios"
		returnvariable="vSocio"/>		

	<!--- Referencia --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Referencia"
		Default="Referencia"
		returnvariable="vReferencia"/>		

	<!--- Deduccion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Deduccion"
		xmlfile="/rh/generales.xml"
		Default="Deducci&oacute;n"
		returnvariable="vDeduccion"/>		

	<!--- Deduccion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Tipo"
		xmlfile="/rh/generales.xml"
		Default="Tipo"
		returnvariable="vTipo"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Saldo"
		xmlfile="/rh/generales.xml"
		Default="Saldo"
		returnvariable="vSaldo"/>	

	<!--- Si Deduccion es de porcentaje, valida que el mismo sea entre 0 y 100 --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_El_Porcentaje_debe_estar_en_el_rango_de_0_a_100"
		Default="Se presentaron los siguientes errores:\n - El Porcentaje debe estar en el rango de 0 a 100"
		returnvariable="vPorcentaje2"/>		

<!--- ============================================= --->
<!--- ============================================= --->


<!--- ----------------------------------------- Refrescamiento de las Deducciones ----------------------------------------- --->

<cfquery name="refrescarDeducciones1" datasource="#Session.DSN#">
	delete RHLiqDeduccion
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	and Did is not null
	and not exists (	select 1
						from DeduccionesEmpleado
						where RHLiqDeduccion.Did = DeduccionesEmpleado.Did
						and (	
								( DeduccionesEmpleado.Dsaldo > 0
							  		and DeduccionesEmpleado.Dcontrolsaldo = 1 )
								or DeduccionesEmpleado.Dmetodo = 0	
							)	
					)
</cfquery>

<cfquery name="refrescarDeducciones2" datasource="#Session.DSN#">
	update RHLiqDeduccion
	set importe = (
		select Dsaldo
		from DeduccionesEmpleado
		where RHLiqDeduccion.Did = DeduccionesEmpleado.Did
		and DeduccionesEmpleado.Dsaldo > 0
		and DeduccionesEmpleado.Dcontrolsaldo = 1
	)
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	and Did is not null
	
	and exists (	select 1
					from DeduccionesEmpleado
					where RHLiqDeduccion.Did = DeduccionesEmpleado.Did
					and DeduccionesEmpleado.Dsaldo > 0
					and DeduccionesEmpleado.Dcontrolsaldo = 1

				)
</cfquery>

<!--- ------------------------------------------------------------------------------------------------------------------- --->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.RHLDid") AND Len(Trim(Form.RHLDid)) GT 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsRHLiqDeduccion" datasource="#Session.DSN#">
		select  b.RHLDid, b.DLlinea, b.DEid, b.Did, b.RHLDdescripcion, b.RHLDreferencia, b.SNcodigo, b.importe as Ivalor, b.fechaalta, 
				b.RHLDautomatico, b.BMUsucodigo, b.ts_rversion, 
				de.SNnombre, de.SNnumero, dempl.Dmetodo, b.RHLDporcentaje
		from RHLiqDeduccion b

			inner join SNegocios de
			on b.SNcodigo = de.SNcodigo
			and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			
		inner join DeduccionesEmpleado dempl
			on b.DEid = dempl.DEid
			and b.Did = dempl.Did
			
		where b.RHLDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLDid#">
		  and b.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	</cfquery>
	
</cfif>
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>

<!---
		/*
		if ( document.form1.Dmetodo.value == 0 ){
			if ( parseFloat(qf(document.form1.Ivalor.value)) > 100 ){
				alert('<cfoutput>#vPorcentaje2#</cfoutput>')
				return false;
			}
		}
		*/
--->

<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisDeducciones() {
		var w = 650;
		var h = 500;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("conlisDeducEmpleado.cfm?DLlinea=<cfoutput>#DLlinea#</cfoutput>",l,t,w,h);
	}

	function validaForm(f) {
		f.obj.Ivalor.value = qf(f.obj.Ivalor.value);
		f.obj.Ivalor.disabled = false;
		
		return true;
	}
	
	function limpiarfiltro(){
		document.filtro.fTDcodigo.value = '';
		document.filtro.fTDdescripcion.value = '';
	}
	
	function validar_porcentaje(){
		if ( document.form1.Dmetodo.value == 0 ){
			if ( parseFloat(qf(document.form1.RHLDporcentaje.value)) > 100 ){
				alert('<cfoutput>#vPorcentaje2#</cfoutput>')
				return false;
			}
		}
		return true
	}

	function funcAgregar() {
		document.lista.PASO.value=3;
	}

	function funcCambio(){
		return validar_porcentaje();
	}
	
	function funcAlta() {
		return validar_porcentaje();		
	}
	
	function funcEliminar() {
		document.lista.PASO.value=2;
	}

	function funcAnterior() {
		objForm.Did.required = false;
		objForm.SNnumero.required = false;
		objForm.referencia.required = false;
		objForm.Ivalor.required = false;
		document.form1.paso.value = 2;
	}

	function funcSiguiente() {
		objForm.Did.required = false;
		objForm.SNnumero.required = false;
		objForm.referencia.required = false;
		objForm.Ivalor.required = false;
		document.form1.paso.value = 4;
	}
	
	function cambiar_etiqueta(desc,valor,Dvalor){
		document.form1.Dmetodo.value = valor;		
		if (valor == 0){
			document.getElementById('tr_porcentaje').style.display = '';
			document.form1.RHLDporcentaje.value = fm(Dvalor, 2);
		}
		else{
			document.getElementById('tr_porcentaje').style.display = 'none';
			document.form1.RHLDporcentaje.value = '';			
		}
	}
	
	//-->
</SCRIPT>

<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<form action="#CurrentPage#" method="post" name="form1" onSubmit="javascript: return validaForm(this);">
			<input type="hidden" name="paso" value="#Gpaso#">
			<input type="hidden" name="DEid" value="#form.DEid#">
			<cfif DLlinea NEQ 0>
			<input name="DLlinea" type="hidden" value="#DLlinea#">
			</cfif>
			<cfif modo EQ "CAMBIO">
				<input name="RHLDid" type="hidden" value="#rsRHLiqDeduccion.RHLDid#">
			</cfif>
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsRHLiqDeduccion.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
			</cfif>  
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			  <tr>
				<td width="15%" class="fileLabel" align="right">#vDeduccion#:</td>
				<td>
					<input name="Dmetodo"  id="Dmetodo" type="hidden" value="<cfif modo neq 'ALTA' and rsRHLiqDeduccion.Dmetodo eq 0>0<cfelse>1</cfif>">
					<input name="Did"  id="Did" type="hidden" value="<cfif modo NEQ "ALTA" >#rsRHLiqDeduccion.Did#</cfif>">
					<input name="Ddescripcion" type="text"  value="<cfif modo NEQ "ALTA" >#rsRHLiqDeduccion.RHLDdescripcion#</cfif>"  tabindex="-1" readonly size="50" maxlength="180">
					<a href="javascript:doConlisDeducciones();"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Deducciones de Empleado" name="imagen" width="18" height="14" border="0" align="absmiddle" ></a>
				</td>
			    <td class="fileLabel" align="right">#vSocio#:</td>
			    <td>
					<cfif modo EQ "CAMBIO">
						<cf_sifsociosnegocios2 idquery="#rsRHLiqDeduccion.SNcodigo#">
					<cfelse>
						<cf_sifsociosnegocios2>
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td width="15%" class="fileLabel" nowrap align="right" id="etiquetaLabel" >#vImporte#:</td>
				<td nowrap>
				  <input name="Ivalor" type="text" id="Ivalor" disabled="disabled" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA" and isdefined("rsRHLiqDeduccion")>#LSCurrencyFormat(rsRHLiqDeduccion.Ivalor, 'none')#<cfelse>0.00</cfif>" tabindex="1">
				</td>
				<td class="fileLabel" align="right">#vReferencia#:</td>
				<td>
					<input name="referencia" id="referencia" type="text" value="<cfif modo NEQ "ALTA" >#rsRHLiqDeduccion.RHLDreferencia#</cfif>" tabindex="-1" size="50" maxlength="180">
				</td>
			  </tr>

				<tr id="tr_porcentaje" <cfif modo neq 'ALTA' and rsRHLiqDeduccion.Dmetodo eq 0>style="display:;"<cfelse>style="display:none;"</cfif>   >
					<td width="15%" class="fileLabel" nowrap align="right" id="etiquetaLabel" >#vPorcentaje#:</td>
					<td nowrap>
					  <input name="RHLDporcentaje" type="text" id="RHLDporcentaje" size="10" maxlength="6" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA" and isdefined("rsRHLiqDeduccion")>#LSCurrencyFormat(rsRHLiqDeduccion.RHLDporcentaje, 'none')#<cfelse>0.00</cfif>" tabindex="1">
					</td>
				</tr>

			  <tr>
				<td>&nbsp;</td>
				<td colspan="3">&nbsp;</td>
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
			<cfif DLlinea NEQ 0>
				<input name="DLlinea" type="hidden" value="#DLlinea#">
			</cfif>
			<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td valign="middle"><strong>#vdeduccion#:&nbsp;</strong> 
						<input name="fTDcodigo" type="text" size="5" maxlength="3" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fTDcodigo")><cfoutput>#form.fTDcodigo#</cfoutput></cfif>">
					</td>
					<td valign="middle" align="left"><strong>&nbsp;#vDescripcion#: &nbsp;&nbsp;</strong>
						<input name="fTDdescripcion" type="text" size="50" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fTDdescripcion")><cfoutput>#form.fTDdescripcion#</cfoutput></cfif>">
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
		 <cfquery name="rsRHLiqDeducciones" datasource="#session.DSN#">
			select	3 as paso, a.DLlinea, a.DEid, 
			b.RHLDid, b.Did, RHLDdescripcion as nombre, b.RHLDreferencia, b.SNcodigo, b.importe, 
			b.fechaalta, b.RHLDautomatico, b.BMUsucodigo , td.TDcodigo, td.TDdescripcion,
			c.SNnombre, c.SNnumero, de.Dmetodo, 
			case when de.Dmetodo = 0 then 'Porcentaje' else 'Importe' end as tipo,
			
			case when exists( select 1
							  from DeduccionesEmpleado
							  where DeduccionesEmpleado.Did = b.Did
								and DeduccionesEmpleado.Dsaldo > 0
								and DeduccionesEmpleado.Dcontrolsaldo = 1	) then '<img border="0" src="/cfmx/rh/imagenes/checked.gif" />' else '<img border="0" src="/cfmx/rh/imagenes/unchecked.gif" />' end as saldo,
			
			case when de.Dmetodo = 0 then <cf_dbfunction name="to_char" args="b.RHLDporcentaje"> else '-' end as porcentaje
			

			from RHLiquidacionPersonal a

				inner join RHLiqDeduccion b
					on a.DEid = b.DEid
					and a.DLlinea = b.DLlinea

				inner join SNegocios c
					on a.Ecodigo = c.Ecodigo
					and b.SNcodigo = c.SNcodigo

				left outer join DeduccionesEmpleado de
					on b.DEid = de.DEid
					and b.Did = de.Did

				left outer join TDeduccion td
					on de.Ecodigo = td.Ecodigo
					and de.TDid = td.TDid
				<cfif isdefined("form.fTDcodigo") and len(trim(form.fTDcodigo))>
					and upper(td.TDcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(form.fTDcodigo))#%">
				</cfif>
				<cfif isdefined("form.fTDdescripcion") and len(trim(form.fTDdescripcion))>
					and upper(td.TDdescripcion) like '%#Ucase(Trim(form.fTDdescripcion))#%'
				</cfif>

			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			order by 2
		</cfquery> 
		
		 <cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsRHLiqDeducciones#"/>
				<cfinvokeargument name="desplegar" value="TDcodigo, nombre, SNnombre, RHLDreferencia,tipo, porcentaje,importe, saldo"/>
				<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#, #vSocio#, #vReferencia#, #vTipo#, #vPorcentaje#, #vImporte#, #vsaldo#"/>
				<cfinvokeargument name="formatos" value="S, S, S, S,S,S,M,S"/>
				<cfinvokeargument name="align" value="left, left, left, left,left,right,right,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="keys" value="RHLDid"/> 
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
		
	objForm.SNnumero.required = true;
	objForm.SNnumero.description = "#Vsocio#";
	objForm.referencia.required = true;
	objForm.referencia.description = "#vReferencia#";
	objForm.Ivalor.required = true;
	objForm.Ivalor.description = "#vImporte#";
	
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.Did.required = false;
	}
	
	function limpiar(){
		document.form1.Did.value   	    	= '';
		document.form1.TDdescripcion.value	 	= ''; 
	}
</SCRIPT>
</cfoutput>
