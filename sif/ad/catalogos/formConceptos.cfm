<!--- ETIQUETAS DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Niva" default="No afecta IVA" returnvariable="LB_Niva" xmlfile="Conceptos.xml">
<!---  --->

<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>
<cfif isdefined("Form.Cid") and len(trim(form.Cid)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Cid") and len(trim(#Form.Cid#)) NEQ 0>
	<cfquery name="rsConceptos" datasource="#Session.DSN#" >
		Select Cid, coalesce(CCid,0) as CCid, Ecodigo, Ccodigo, Ctipo, Cdescripcion, Ucodigo, Cimportacion, cuentac,
		Cformato,	'' as Cdescripcion2,	'' as Ccuenta, ts_rversion, Cd151, coalesce(Cporc,0) as Cporc, CexcostosAuto,
        CComodinExtra,CcodigoAlterno,codIEPS, afectaIVA,FlujoEfec,coalesce(CGeneraSol,0) as CGeneraSol,
		ClaveSAT
        from Conceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >
		order by Cdescripcion asc
	</cfquery>
</cfif>
<cfquery name="rsIEPS" datasource="#session.dsn#">
	select Icodigo, Idescripcion
    from Impuestos
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and ieps=1
</cfquery>
<cfquery name="rsUnidades" datasource="#Session.DSN#" >
	select Ucodigo, Udescripcion
	from Unidades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Utipo in (1,2)
</cfquery>

<cfif modo neq 'ALTA' and isdefined('rsConceptos') and rsConceptos.recordCount GT 0 and rsConceptos.CCid NEQ ''>
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select CCid, CCcodigo, CCdescripcion, CCnivel as CCnivel
		from CConceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CCid#">
	</cfquery>
</cfif>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=540
</cfquery>

<cfquery name="rsCtasServicio" datasource="#session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 890
</cfquery>
<body>
<cfoutput>
<cfsavecontent variable="helpimg">
	<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0"/>
</cfsavecontent>

<form action="SQLConceptos.cfm" method="post" name="form">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="filtro_Ccodigo" type="hidden" value="<cfif isdefined('form.filtro_Ccodigo')>#form.filtro_Ccodigo#</cfif>">
	<input name="filtro_Cdescripcion" type="hidden" value="<cfif isdefined('form.filtro_Cdescripcion')>#form.filtro_Cdescripcion#</cfif>">
	<input name="fTipo" type="hidden" value="<cfif isdefined('form.fTipo')>#form.ftipo#</cfif>">

	<table border="0" width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="Ccodigo" tabindex="1" type="text"
				value="<cfif modo neq "ALTA" >#rsConceptos.Ccodigo#</cfif>"
				size="10" maxlength="10"  alt="El Código del Concepto" <cfif modo NEQ 'ALTA'> class="cajasinborde" readonly</cfif>>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>C&oacute;digo Externo:&nbsp;</td>
			<td>
				<input name="CcodigoAlterno" tabindex="1" type="text"
				value="<cfif modo neq "ALTA" >#rsConceptos.CcodigoAlterno#</cfif>"
				size="10" maxlength="10" onFocus="this.select();" alt="El Código Externo">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>Tipo:&nbsp;</td>

			<td align="left">
				<select name="Ctipo" onChange="javascript:cambiarCostos(); limpiarDetalle();" tabindex="2">

					<cfif session.menues.SMcodigo eq 'CC' or session.menues.SMcodigo eq 'AD' or session.menues.SMcodigo eq 'FAC'>
						<option value="I" <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "I")>selected</cfif> >Ingreso</option>
					</cfif>
					<cfif session.menues.SMcodigo eq 'CP' or session.menues.SMcodigo eq 'AD' or session.menues.SMcodigo eq 'FAC'> 
						<option value="G" <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "G")>selected</cfif> >Gasto</option>
					 </cfif> 	
					 <!--- <option value="I" selected >Ingreso</option> --->
				</select>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="Cdescripcion" tabindex="3" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsConceptos.Cdescripcion#</cfoutput></cfif>" size="35" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Clasificaci&oacute;n:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_sifclasificacionconcepto query="#rsClasificacion#" form="form" tabindex="4">
				<cfelse>
					<cf_sifclasificacionconcepto form="form" tabindex="4">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Unidad de Medida:&nbsp;</td>
			<td>
				<select name="Ucodigo" tabindex="5">
					<option value=""></option>
				<cfloop query="rsUnidades">
					<option value="#rsUnidades.Ucodigo#" <cfif modo neq 'ALTA' and trim(rsConceptos.Ucodigo) eq trim(rsUnidades.Ucodigo)  >selected</cfif> >#rsUnidades.Ucodigo# - #rsUnidades.Udescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>

	<tr>
	  <td nowrap align="right">Complemento:&nbsp;</td>
		<td nowrap>
			<input type="text" name="cuentac" tabindex="6" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsConceptos.cuentac#</cfoutput></cfif>" alt="Complemento">
		</td>
	</tr>
	<tr>
			<td align="right" nowrap>IEPS:&nbsp;</td>
			<td>
				<select name="codIEPS" tabindex="5">
					<option value=""></option>
				<cfloop query="rsIEPS">
					<option value="#rsIEPS.Icodigo#" <cfif modo neq 'ALTA' and trim(rsConceptos.codIEPS) eq trim(rsIEPS.Icodigo)  >selected</cfif> >#rsIEPS.Idescripcion#</option>
				</cfloop>
				</select>

            <input type="checkbox" tabindex="10" name="afectaIVA" id="afectaIVA"
                    <cfif (modo neq 'ALTA' and rsConceptos.afectaIVA eq 1)>checked</cfif>>
                    <label for="afectaIVA" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Niva#</label>

               	</td>
		</tr>
	<tr>
		<td nowrap align="right">Cuenta Gasto:&nbsp;</td>
		<td nowrap>
					<!---<cfif rsCtasServicio.Pvalor EQ 2>					--->
						<cfif modo EQ "ALTA">
							<cf_cuentasanexo
							auxiliares="S"
							movimiento="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							comodin="?" tabindex="7">
						<cfelse>
							<cfquery name="rsCformato" dbtype="query">
								select ccuenta, Cdescripcion2 as cdescripcion, Cformato from rsConceptos
							</cfquery>
							<cf_cuentasanexo
							auxiliares="S"
							movimientos="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							query="#rsCformato#"
							comodin="?" tabindex="7">
						</cfif>
				<!---	<cfelseif rsCtasServicio.Pvalor EQ 3>
						<cfif modo EQ "ALTA">
							<cf_cuentasanexo
							auxiliares="S"
							movimiento="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							comodin="C,S" tabindex="1">
						<cfelse>
							<cfquery name="rsCformato" dbtype="query">
								select ccuenta, Cdescripcion2 as cdescripcion, Cformato from rsConceptos
							</cfquery>
							<cf_cuentasanexo
							auxiliares="S"
							movimientos="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							query="#rsCformato#"
							comodin="C,S" tabindex="1">
						</cfif>
					</cfif>--->
		</td>
	</tr>
	<tr>
		<td nowrap align="right">Clave SAT:</td>
		<td nowrap>
			<cfset valuesArray = ArrayNew(1)>
			<!--- <cfset filtroExtra = ''> --->
			<cfif modo eq 'CAMBIO' and IsDefined('form.CID') and IsDefined('rsConceptos')>
				<cfquery name="rsCatalogo" datasource="#session.dsn#">
					select CSATCodigo,CSATDescripcion
					from CSAT_ProdServ
					where CSATCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConceptos.ClaveSAT#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATCodigo)#')>
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATDescripcion)#')>
			</cfif>
		  	<cf_conlis
				campos="CSATCodigo,CSATDescripcion"
				asignar="CSATCodigo,CSATDescripcion"
				size="8,30"
				desplegables="S,S"
				modificables="S,N"
				title="Conceptos SAT"
				tabla="CSAT_ProdServ a"
				columnas="CSATCodigo,CSATDescripcion"
				filtrar_por="CSATCodigo,CSATDescripcion"
				desplegar="CSATCodigo,CSATDescripcion"
				etiquetas="Clave,Descripcion"
				formatos="S,S"
				align="left,left"
				asignarFormatos="S,S"
				form="form"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No hay registros --- "
				alt="Clave,Descripcion"
				valuesArray="#valuesArray#"
				/>
				<!---
				traerInicial="True"
				traerFiltro=" 1=1 #filtroExtra#"
				 --->
		</td>
	</tr>
    <tr> <!---SML 12-02-2015 Inicio. Modificacion para Nomina SES Mexico--->
		<td nowrap align="right"><input type="checkbox" id="chkGenSol" name="chkGenSol" <cfif (modo neq 'ALTA' and rsConceptos.CGeneraSol eq 1)>checked</cfif> ></td>
		<td nowrap>
        	<table width="100%">
            	<tr>
                	<td width="40%">
                    	Genera Solicitud de Pago
                    </td>
                    <td width="60%" align="left">
                    	 <cf_notas titulo="Genera Solicitud de Pago" link="#helpimg#" pageIndex="4" msg = "<UL type = circle>Habilita el Concepto de Servicio que será<br>utilizado para Sueldos por Pagar en la interfaz de nómina</UL>" animar="true">
                    </td>
                </tr>
            </table>
        <td>
	</tr><!---SML 12-02-2015 Fin. Modificacion para Nomina SES Mexico--->
		<tr>
        	<td>&nbsp;</td>
            <td><table>
            	<tr>
				<cfif rsCtasServicio.Pvalor EQ 3>
				 	<td colspan="3">Complementos: ! = Centro Funcional ? = Socio de Negocio</td>
				<cfelseif rsCtasServicio.Pvalor EQ 2>
					<td colspan="3">Complemento: ? = Socio de Negocio</td>
				</cfif>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                	<td colspan="2">Descartar caracteres del Complemento en la Construccion de Cuentas:</td>
                    <td><input type="text" tabindex="8" id="ComodinExtra" name="ComodinExtra" onKeyPress="return soloComodin(event)" maxlength="15" value="<cfif modo NEQ "ALTA" and rsConceptos.CComodinExtra NEQ "">#rsConceptos.CComodinExtra#</cfif>"></td>
                </tr>

				<tr><td colspan="3">&nbsp;</td></tr>
            	<tr>
                <td valign="baseline">
                    <input type="checkbox" tabindex="9" name="Cimportacion" id="Cimportacion"
                        <cfif (modo neq 'ALTA' and rsConceptos.Cimportacion eq 1)>checked</cfif>>
                        <label for="Cimportacion" style="font-style:normal; font-variant:normal; font-weight:normal">Para Importaci&oacute;n&nbsp;</label>
              	</td>
                <td valign="baseline">
                    <input type="checkbox" tabindex="9" name="FlujoEfec" id="FlujoEfec"
                        <cfif (modo neq 'ALTA' and rsConceptos.FlujoEfec eq 1)>checked</cfif>>
                        <label for="FlujoEfec" style="font-style:normal; font-variant:normal; font-weight:normal">Para Flujo de Efectivo</label>
              	</td>
              	<td valign="baseline">
                	<input type="checkbox" tabindex="10" name="Cd151" id="Cd151"
                    <cfif (modo neq 'ALTA' and rsConceptos.Cd151 eq 1)>checked<cfelseif modo eq 'ALTA'>checked</cfif>>
                    <label for="Cimportacion" style="font-style:normal; font-variant:normal; font-weight:normal">Aplica para el reporte D-151&nbsp;</label>
               	</td>
                <td valign="baseline">
                	<input type="checkbox" tabindex="11" name="costoA" id="costoA" onClick="javascript: cambioPorcentaje();"
                    <cfif (modo neq 'ALTA' and rsConceptos.Cporc gt 0)>checked</cfif>
                    <cfif modo eq 'ALTA' or (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "I")>style="visibility:hidden;"
                    </cfif>>
                  <br>
                  <input type="checkbox" tabindex="12" name="ExCostosAuto" id="ExCostosAuto"
                    <cfif (modo neq 'ALTA' and rsConceptos.CexcostosAuto eq 1)>checked</cfif>
                    <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "G")>style="visibility:hidden;"
                    <cfelseif modo eq 'ALTA'>visibility:visible
                    </cfif>>
                 </td>
				 <td>
                    <label id="costoAl" style="font-style:normal; font-variant:normal; font-weight:normal; <cfif modo eq 'ALTA' or (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "I")>visibility:hidden</cfif>">Costos Automaticos</label>
                    <label id="ExCostosDesc" style="font-style:normal; font-variant:normal; font-weight:normal; <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "G")>visibility:hidden<cfelseif modo eq 'ALTA'>visibility:visible</cfif>"><br>
                    Excento de Costos Autom&aacute;ticos&nbsp;</label>
                </td>
         	</tr>
            <tr>
            	<td valign="baseline">&nbsp;</td>
                <td valign="baseline">&nbsp;</td>
                 <td valign="baseline">&nbsp;</td>
                <td valign="baseline">
                	<input id="Cporc" name="Cporc" type="text" size="7" maxlength="9" value="<cfif (modo neq 'ALTA' and rsConceptos.Cporc gt 0)><cfoutput>#rsConceptos.Cporc#</cfoutput></cfif>"
                            onBlur="javascript:fm(this,2); _mayor(this.value);"  onFocus="javascript:this.value=qf(this); this.select();"
                            onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            alt="Porcentaje"
                            <cfif modo eq 'ALTA' or (modo neq 'ALTA' and rsConceptos.Cporc eq 0)>style="visibility:hidden; position: relative; left: 3px; margin-right: 6px"</cfif>>
                  	<label id="porccosto" <cfif modo eq 'ALTA' or (modo neq 'ALTA' and rsConceptos.Cporc eq 0)>style="font-style:normal; font-variant:normal; font-weight:normal; visibility:hidden"</cfif>><strong>% Costo</strong></label>
                </td>
            </tr>
            </table></td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display' tabindex="13"
					tabla="Conceptos"
					form = "form"
					llave="#form.Cid#" />
			</td></tr>
		</cfif>
		<!--- *************************************************** --->

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr>
			<td colspan="2" align="center" nowrap>
				<cfif modo neq "ALTA">
					<cfset masbotones = "CtasConcepto">
					<cfset masbotonesv = "Cuentas por Concepto">
				<cfelse>
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				</cfif>
				<cf_botones modo="#modo#" include="#masbotones#" includevalues="#masbotonesv#" tabindex="14">

				<!--- <cfif modo NEQ "ALTA">
					<input name="btnContactos" tabindex="2" type="button" value="Cuentas por Concepto" onClick="javascript: document.form.Ccodigo.disabled = false; CtasConcepto('<cfoutput>trim(#rsConceptos.Ccodigo#)</cfoutput>')">
				</cfif> --->
			</td>
		</tr>
	</table>

	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsConceptos.ts_rversion#"/>
		</cfinvoke>
	</cfif>

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="Cid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsConceptos.Cid#</cfoutput></cfif>">
  <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">

 </form>
 </cfoutput>
 <cf_qforms form="form">
            <cf_qformsRequiredField name="Ccodigo" description="Código">
			<cf_qformsRequiredField name="Cdescripcion" description="Descripción">
			<cf_qformsRequiredField name="CCcodigo" description="Clasificación">
			<cf_qformsRequiredField name="Ctipo" description="Tipo">
</cf_qforms>

<script language="JavaScript" type="text/JavaScript">
	function CtasConcepto(data1, data2, filtro) {
		if (data1!="" && data2!="") {
			location.href = 'CtasConcepto.cfm?Ccodigo='+ data1+'&Cid='+data2+filtro;
		}
		return false;
	}
	function funcCtasConcepto(){
		var filtro;
		document.form.Ccodigo.disabled = false;
		filtro = '&Pagina='+document.form.Pagina.value+'&filtro_Ccodigo='+document.form.filtro_Ccodigo.value+'&filtro_Cdescripcion='+document.form.filtro_Cdescripcion.value+'&hfiltro_Ccodigo='+document.form.filtro_Ccodigo.value+'&hfiltro_Cdescripcion='+document.form.filtro_Cdescripcion.value+'&fTipo='+document.form.fTipo.value;
		CtasConcepto(document.form.Ccodigo.value,document.form.Cid.value,filtro);
		return false;
	}
	function funcCCcodigo(){
		if( document.form.profundidad.value != (parseInt(document.form.CCnivel.value))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form.CCid.value = '';
			document.form.CCcodigo.value = '';
			document.form.CCdescripcion.value = '';
			document.form.CCnivel.value = '';
		}
	}
	function _mayor(number){
		if ( number > 100 ){
			document.form.Cporc.value = '0.00';
			alert ('El campo no puede ser mayor a 100');
			return false;
		}
	}
	function limpiarDetalle() {
		var f = document.form;
		f.costoA.value="";
		f.Cporc.value="";
	}

	// cambia según el item que se escogió
	function cambiarCostos(){
		var f = document.form;
		if(f.Ctipo.value=="I"){
			f.costoA.style.visibility="hidden";
			f.costoA.checked = false;
			document.getElementById("costoAl").style.visibility = "hidden";
			f.Cporc.style.visibility = "hidden";
			document.getElementById("porccosto").style.visibility = "hidden";

			f.ExCostosAuto.style.visibility="visible";
			document.getElementById("ExCostosDesc").style.visibility = "visible";
		}

		if(f.Ctipo.value=="G"){
			f.costoA.style.visibility="visible";
			document.getElementById("costoAl").style.visibility = "visible";
			f.ExCostosAuto.style.visibility="hidden";
			f.ExCostosAuto.checked = false;
			document.getElementById("ExCostosDesc").style.visibility = "hidden";
		}

	}
	function cambioPorcentaje(){
		var f1 = document.form;
		if(document.form.costoA.checked == true){
			f1.Cporc.style.visibility = "visible";
			document.getElementById("porccosto").style.visibility = "visible";
		}
		if(document.form.costoA.checked == false){
			f1.Cporc.style.visibility = "hidden";
			document.getElementById("porccosto").style.visibility = "hidden";
		}
	}

	function soloComodin(e) {
		key = e.keyCode || e.which;
		tecla = String.fromCharCode(key).toLowerCase();
		comodin = "?!";
		especiales = [8,15,13,9,35,36,37,38,39,40,46];
		tecla_especial = false
		for(var i in especiales) {
			if(key == especiales[i]) {
				tecla_especial = true;
				break;
			}
		}

		if(comodin.indexOf(tecla) == -1 && !tecla_especial)
			return false;
	}

 	<cfif modo NEQ "ALTA">
 		document.form.Cdescripcion.focus();
	<cfelse>
		document.form.Ccodigo.focus();
 	</cfif>
</script>
