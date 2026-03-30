<!---GENERALES--->
<!---<cf_dump var="#form#">--->
<cfset btnNamePlanCompras="PlanCompras">
<cfset btnValuePlanCompras= "Plan de Compras">

<cfif isdefined('url.mensaje')>
	<script language="javascript">
		alert("El GECcomplemento que contiene ese concepto no concuerda con ninguna cuenta financiera");
	</script>
</cfif>

<cfif isdefined('url.GEAid') and not isdefined('form.GEAid')>
	<cfparam name="form.GEAid" default="#url.GEAid#">
</cfif>


<cfif isdefined('url.GEADid') and not isdefined('form.GEADid')>
	<cfparam name="form.GEADid" default="#url.GEADid#">
</cfif>

<cfif isdefined('form.GEADid') and len(trim(form.GEADid))>
	<cfset modoDep = 'CAMBIO'>
<cfelse>
	<cfset modoDep = 'ALTA'>
</cfif>

<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<!--- Tipo Gasto--->
<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
		GETdescripcion,
		GETid
	from GEtipoGasto
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modoDep NEQ 'ALTA'>
<!---PRINCIPAL--->
		<cfquery datasource="#session.dsn#" name="rsFormAntD">
			select
				GEAid,
				CFcuenta,
				GEADmonto,
				GECid,
				GEPVid,
				GEADtipocambio,
				GEADmontoviatico,
				McodigoPlantilla
				<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
					,PCGDid
				</cfif>
			from GEanticipoDet
			where GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
		</cfquery>
<cfif isdefined ('form.Concepto')>
	<cfquery datasource="#session.dsn#" name="rsTipo">
		select GETid 
		from  
		GEconceptoGasto 
		where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">
	</cfquery>
<cfelse>
<cfquery datasource="#session.dsn#" name="rsTipo">
		select GETid 
		from  
		GEconceptoGasto 
		where GECid=(select GECid from GEanticipoDet where GEADid=#form.GEADid#)
	</cfquery>
	</cfif>
</cfif>


<!--- SQL selecciona el concepto asociado a una liquidacion--->

<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
	select 
		c.GECdescripcion,
		c.GECid,
		c.GETid,
		c.GECcomplemento
	from GEconceptoGasto c
		inner join GEtipoGasto t
		on  c.GETid = t.GETid
	where Ecodigo = #session.Ecodigo#
	<cfif modoDep eq "ALTA">
	and c.GETid= (
						select 
							min(GETid)
						from GEtipoGasto
						where Ecodigo = #session.Ecodigo#
						)
	<cfelse>
		and c.GETid = #rsTipo.GETid#
	</cfif>				 
</cfquery>

<!---QUERYS PARA EL CAMBIO Y PARA LA CUENTA FINANCIERA--->
<cf_dbfunction name="to_char" args="ant.GEAnumero" returnvariable="LvarNumero">
<cf_dbfunction name="to_char_currency" args="ant.GEAtotalOri" returnvariable="LvarMonto">
<cfquery datasource="#session.dsn#" name="listaDetAnt">
		select
			a.GEAid,
			ant.GECid,
			<cf_dbfunction name="concat" args="'Anticipo ';#LvarNumero#;': ';m.Miso4217;' ';#LvarMonto#" delimiters=";"> as Anticipo,
			a.GEADid,
			a.GECid  as Concepto,
			a.CFcuenta, f.CFformato,
			a.GEADmonto,
			a.GEPVid,
			a.GEADfechaini,
			a.GEADfechafin,
			b.GECdescripcion,
			gep.GEPVdescripcion,
			gep.GECVid,
			gec.GECVdescripcion
		from GEanticipoDet a
			inner join GEanticipo ant
				inner join Monedas m on m.Mcodigo = ant.Mcodigo
				on ant.GEAid = a.GEAid
			inner join CFinanciera f
				on f.CFcuenta = a.CFcuenta
			inner join GEconceptoGasto b
				on b.GECid=a.GECid	
			left outer join GEPlantillaViaticos gep
				on a.GEPVid=gep.GEPVid     		
			left outer join GEClasificacionViaticos gec
				on gep.GECVid=gec.GECVid    	
	<cfif LvarSAporComision>
		where ant.GECid=#form.GECid#
		  and ant.GEAestado = 0 
		order by a.GEAid
	<cfelse>
		where a.GEAid=#form.GEAid#
	</cfif>
</cfquery>


<cfquery name="rsTipoCambio" datasource="#session.dsn#">
	select distinct  GEADtipocambio, McodigoPlantilla
    from GEanticipoDet a
			inner join GEanticipo ant
				on ant.GEAid = a.GEAid
	<cfif LvarSAporComision>
		where ant.GECid=#form.GECid#
	<cfelse>
		where a.GEAid=#form.GEAid#
	</cfif>
	and  a.GEADtipocambio<>1
</cfquery>
	
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction1_ComboConceptoDet(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vID_tipo_gasto1 ='';
	var vmodoD1 ='';
	vID_tipo_gasto1 = document.formAntD.Tipo1.value;
	vmodoD1 = document.formAntD.modoDep.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?GETid='+vID_tipo_gasto1+'&modoD='+vmodoD1, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
}

function ajaxFunction1_ComboConceptoDet(GECid){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vID_tipo_gasto1 ='';
	var vmodoD1 ='';
	vID_tipo_gasto1 = document.formAntD.Tipo1.value;
	vmodoD1 = document.formAntD.modoDep.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?GETid='+vID_tipo_gasto1+'&GECid='+GECid+'&modoD='+vmodoD1, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
}

//funcion que asigna los valores que vienen cuando se escoje el popup de plan de compras
	function fnAsignarValores(GETid,GECid,cuenta,LvarPCGDid,monto){
		document.formAntD.CFcuenta.value = cuenta;
		document.formAntD.PCGDid.value = LvarPCGDid;
		document.formAntD.Tipo1.value = GETid;
		document.formAntD.ConceptoGasto.value = GECid;
		document.formAntD.MontoDet.value = monto;
		
		ajaxFunction1_ComboConceptoDet(GECid);
		//para q me refresque el campo del monto calculado
		calcularMonto();
	}
	
//-->
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td valign="top" width="50%">
<table width="100%" align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2"><hr></td>						
		</tr><tr>
			<td align="left" valign="top" width="80%">
			<cfset LvarNavegacion="">
			<cfif LvarSAporComision>
				<cfset LvarNavegacion="&GECid=#form.GECid#">
				<cfset LvarCortes = "Anticipo">
				<cfset LvarDesplegar = "CFformato,GEADmonto,GECdescripcion">
				<cfset LvarEtiquetas = "Cuenta Financiera, Monto Solicitado, Concepto">
			<cfelse>
				<cfset LvarCortes = "">
				<cfset LvarDesplegar = "CFformato,GEADmonto,GECdescripcion,GEPVdescripcion,GECVdescripcion,GEADfechaini,GEADfechafin">
				<cfset LvarEtiquetas = "Cuenta Financiera, Monto Solicitado, Concepto, Plantilla, Viatico, Inicio, Final">
			</cfif>
			<cfif isdefined("form.GEAid")>
				<cfset LvarNavegacion=LvarNavegacion & "&GEAid=#form.GEAid#">
			</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDetAnt#"
					Cortes="#LvarCortes#"
					desplegar="#LvarDesplegar#"
					etiquetas="#LvarEtiquetas#"
					formatos="S,M,S,S,S,D,D"
					align="left,right,left,left,left,left,left"
					ira="#LvarSAporEmpleadoCFM#"
					showEmptyListMsg="yes"
					keys="GEADid"
					maxRows="20"
					formName="formAntDLista"
					PageIndex="1"
					navegacion="#LvarNavegacion#"
					checkboxes="Y" />
			</td>
			<td align="left" valign="top" width="20%"></td></tr>
	</table>
	</td>
	


<td valign="top" width="50%">
<cfif modo EQ "ALTA">
</td></tr></table>
<cfreturn>
</cfif>
<cfoutput>
	<form action="solicitudesAnticipo_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onsubmit="return validaDet(this);" method="post" name="formAntD" id="formAntD">
	<input type="hidden" name="modoDep" id="modoDep"  value="#modoDep#" />
	<input type="hidden" name="GEAid" id="GEAid" value="<cfif isdefined('form.GEAid')>#form.GEAid#</cfif>"/>
	<input type="hidden" name="GEADid" id="GEADid" value="<cfif isdefined('form.GEADid')>#form.GEADid#</cfif>"/>
	<input type="hidden" name="CFid" id="CFid" value="<cfif isdefined('LvarCFid')>#LvarCFid#</cfif>"/>
	<input type="hidden" name="tcDeConversion" id="tcDeConversion" value=""/>
	<!---CFcuenta y ConceptoGasto se usa cuando es por plan de compras y se le da valor con el pop up--->
	<input type="hidden" name="CFcuenta" id="CFcuenta" value="<cfif isdefined('rsFormAntD.CFcuenta')>#rsFormAntD.CFcuenta#</cfif>">
	<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
		<input type="hidden" name="ConceptoGasto" id="ConceptoGasto" value="">
		<input type="hidden" name="PCGDid" id="PCGDid" value="">
	</cfif>

	
<table width="100%" align="right" cellpadding="0" border="0">
		<tr>
			<td colspan="2" valign="top"><hr></td>						
		</tr>
		<!--- Tipo Gasto--->
		<tr>
			<td nowrap="nowrap" align="right"  valign="top"><strong>Tipo Gasto:&nbsp; </strong> </td>
			<td>
				<select name="Tipo1" onchange="ajaxFunction1_ComboConceptoDet();" <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif> <cfif modoDep neq "ALTA">disabled="disabled"</cfif> >  
					<cfif rsID_tipo_gasto.RecordCount>
						<cfloop query="rsID_tipo_gasto">
							<option value="#rsID_tipo_gasto.GETid#"<cfif modoDep neq "ALTA" and rsID_tipo_gasto.GETid  eq rsTipo.GETid>selected="selected"</cfif>>#rsID_tipo_gasto.GETdescripcion#</option>
						</cfloop>
					</cfif>
				</select>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
<!---Concepto_gasto--->
		<tr>
			<td nowrap="nowrap" align="right" valign="top"><strong>Concepto de Gasto:&nbsp; </strong> </td>
			<td>
				<span id="contenedor_Concepto1">
					<select name="Concepto" id="concepto" <cfif modoDep neq "ALTA">disabled="disabled"</cfif> <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif>>  
						<cfif isdefined("rsID_concepto_gasto") and rsID_concepto_gasto.recordcount gt 0>
							<cfloop query="rsID_concepto_gasto">
									<option value="#rsID_concepto_gasto.GECid#"<cfif modoDep neq 'ALTA' and rsID_concepto_gasto.GECid eq rsFormAntD.GECid>selected="selected"</cfif>>#rsID_concepto_gasto.GECdescripcion#</option>
							</cfloop>
						</cfif>
					</select>
				</span>
			</td>
		</tr>
	<tr><td>&nbsp;</td></tr>	
	<!---Moneda--->
			<tr>
				<td valign="top" align="right"><strong>Moneda:&nbsp;</strong></td>
				<td valign="top">
					<cfif  modoDep NEQ 'ALTA'>
						<cfquery name="rsMoneda" datasource="#session.DSN#">
							select 
									Mcodigo
									, Mnombre
							from Monedas 
							where Ecodigo=#session.Ecodigo#
							and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormAntD.McodigoPlantilla#">
						</cfquery>
						
						<cfset LvarMnombreSP = rsMoneda.Mnombre>
						
						<cfif rsForm.GEAtotalOri GT 0>
							<cf_sifmonedas onChange="asignaTCdet();calcularMonto();"  form="formAntD"  Mcodigo="McodigoOriD" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="2" habilita="S">
						<cfelse>
							<cf_sifmonedas onChange="asignaTCdet();calcularMonto();"  form="formAntD"  Mcodigo="McodigoOriD" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="2">
						</cfif>
					<cfelse>
						<cf_sifmonedas onChange="asignaTCdet();calcularMonto();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" form="formAntD"  Mcodigo="McodigoOriD"  tabindex="2">
					</cfif>   
				</td>
			</tr>
			
			<!---Tipo de cambio--->
			<tr>
				<td valign="top" align="right"><strong>Tipo de Cambio:&nbsp;</strong></td>
				<td valign="top">
					<input name="GEAmanualDet" 
						id="GEAmanualDet"
						maxlength="10" readonly="true"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GEAmanual,",0.00")#</cfif>"
						style="text-align:right;" 
						onfocus="this.value=qf(this); this.select();" 
						tabindex="1" />
				</td>
			</tr>	
				   
<!---MONTO detalle--->
		<tr>
			<td align="right" nowrap><strong>Monto en moneda del detalle:&nbsp; </strong></td>
			<cfset valor_monto = 0 >
				<cfif modoDep neq 'ALTA'>
					<cfset valor_monto = LSNumberFormat(abs(rsFormAntD.GEADmontoviatico),"0.00") >
					<td><cf_inputNumber name="MontoDet" value="#valor_monto#" size="15" enteros="13" decimales="2"  onChange="calcularMonto();"></td> 
				<cfelse>
					<td><cf_inputNumber name="MontoDet" value="0.00" size="15" enteros="13" decimales="2" onChange="calcularMonto();"></td>
				</cfif>
		</tr>
<!---MONTO calculado encabezado--->
		<tr>
			<td align="right" nowrap><strong>Monto en moneda del encabezado:&nbsp; </strong></td>
			<cfset valor_montoCalculado = 0 >
				<cfif modoDep neq 'ALTA'>
					<cfset valor_montoCalculado = LSNumberFormat(abs(rsFormAntD.GEADmonto),"0.00") >
					<td><cf_inputNumber name="MontoDetCalculado" value="#valor_montoCalculado#" size="15" enteros="13" decimales="2"   readonly="true"></td>
				<cfelse>
					<td><cf_inputNumber name="MontoDetCalculado" value="0.00" size="15" enteros="13" decimales="2" readonly="true"></td>
				</cfif>
		</tr>	
<!--- BOTONES--->			
		<tr>
			<td colspan="4" class="formButtons">
				<cf_botones sufijo='Det' modo='#modoDep#' tabindex="2" exclude="">		
			</td>
		</tr>
		<cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom>
			<tr><td>&nbsp;</td></tr>
		<cfelse>
			<tr>
				<td colspan="2" align="center">
					<input type="button"  name="btnPlan"  value="Plan de Compras" tabindex="1" onClick="PlanCompras()" >
					<input type="hidden"  name="LvarParametroPlanCom"  value="">
				</td>
			</tr>
		</cfif>	
		<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and modoDep neq 'ALTA'>
				<cfquery name="rsPCGDid" datasource="#session.dsn#">
					select PCGDid from GEanticipoDet 
						where GEADid=#form.GEADid#
				</cfquery>
				<cfquery name="rsMontoOriginal" datasource="#session.dsn#">
					select PCGDautorizado from PCGDplanCompras 
						where PCGDid=#rsPCGDid.PCGDid#
				</cfquery>
				<input type="hidden"  name="LvarParametroPlanCom"  value="#LvarParametroPlanCom#">
				<input type="hidden"  name="MontoOriginal"  value="#rsMontoOriginal.PCGDautorizado#">
				<input type="hidden" name="PCGDid" id="PCGDid" value="#rsFormAntD.PCGDid#">
		</cfif>
	</table>
	</form>
	</td>
	</tr>
</table>
<iframe name="verifica_Concepto" id="verifC" marginheight="0" marginwidth="0" frameborder="" height="0" width="0" scrolling="auto"></iframe>

</cfoutput>
<script language="javascript">
	function verificaConcep(id){
		var uno= document.formAntD.Concepto.value
		var tc=document.form1.GEAmanual.value
		document.getElementById('verifC').src = 'verificaConcepto.cfm?Concepto='+uno+'&monto='+id+'&dir='+2+'&tc='+tc+'';
	}
</script>
<script type="text/javascript">
	function validaDet(formulario)	{
		formulario.MontoDet.value = qf(formulario.MontoDet);	
		formulario.MontoDetCalculado.value = qf(formulario.MontoDetCalculado);
			
		if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet))
		{
			var error_input = null;;
			var error_msg = '';
			
			if (formulario.Concepto.value == "") 
			{
				error_msg += "\n - El concepto no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.Concepto;
			}	
			if (formulario.MontoDet.value == "") 
			{
				error_msg += "\n - El Monto no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.MontoDet;
			}		
			
			else if (parseFloat(formulario.MontoDet.value) <= 0)
			{
				error_msg += "\n - El monto solicitado debe ser mayor que cero.";
				if (error_input == null) error_input = formulario.MontoDet;
			}

			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				try 
				{
					error_input.focus();
				} 
				catch(e) 
				{}
				
				return false;
			}
		}
		formulario.Concepto.disabled = false;
		formulario.GEAmanualDet.disabled = false;
return true;
	}
	
function PlanCompras(){
	var Lvartipo = 'S';
	var LvarCFid = document.form1.CFid.value;
	var LvarGEAid=document.form1.GEAid.value;
	var LvarfechaPago=document.form1.GEAfechaPagar.value
		
	if((Lvartipo != '') && (LvarCFid != '')&& (LvarGEAid != ''))
	{
		window.open('popUp-planDeCompras.cfm?tipo='+Lvartipo+'&GEAid='+LvarGEAid+'&fechaPago='+LvarfechaPago+'&CFid='+LvarCFid,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
	}
	else
	{
	 alert("Falta el Tipo en el detalle o el Id del Centro Funcional ");
	}  
}
	//asigna el tc del detalle cuando cambio la moneda
	function asignaTCdet() {	
		if (document.formAntD.McodigoOriD.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(document.formAntD.TC,2);
			document.formAntD.GEAmanualDet.disabled = true;
		}
		else
			document.formAntD.GEAmanualDet.disabled = false;				
		var estado = document.formAntD.GEAmanualDet.disabled;
		document.formAntD.GEAmanualDet.disabled = false;
		document.formAntD.GEAmanualDet.value = fm(document.formAntD.TC.value,2);<!---Asigna TC--->
		document.formAntD.GEAmanualDet.disabled = estado;

		if(document.formAntD.McodigoOriD.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
			return true;
		else{
					
			<cfwddx action="cfml2js" input="#rsTipoCambio#" topLevelVariable="TCambio"> 
			//Verificar si existe en el recordset
			var nRows = TCambio.getRowCount();
			if(nRows > 0){
				for(row = 0; row < nRows; ++row){
					if (TCambio.getField(row, "McodigoPlantilla") == document.formAntD.McodigoOriD.value){
						document.formAntD.GEAmanualDet.value = TCambio.getField(row, "GEADtipocambio");
						break;				
					}
				}
			}
		}
	}
	document.formAntD.GEAmanualDet.value='1.00';					
	//esta funcion es la q genera el tag sifmonedas. y me carga el tipo de cambio sin el onchange
	validatcMcodigoOriD();
	asignaTCdet();
	
	// calcula en monto en la moneda del encabezado	
	function calcularMonto(){
		//guarda el tipo de cambio entre las monedas y a la vez lo guarda en base de datos por si se utiliza mas adelante
		var TCdet	= parseFloat(qf(document.formAntD.GEAmanualDet.value));
		var TCenc	= parseFloat(qf(document.form1.GEAmanual.value));
		var tcDeConversion=1;
		var MtoDet	= parseFloat(qf(document.formAntD.MontoDet.value));

		if (TCdet == TCenc) 
		{
			document.formAntD.tcDeConversion.value	 = "1";
			document.formAntD.MontoDetCalculado.value= document.formAntD.MontoDet.value;
		}
		else
		{
			tcDeConversion = TCdet / TCenc;
			document.formAntD.tcDeConversion.value	 = tcDeConversion;
			document.formAntD.MontoDetCalculado.value= (MtoDet * tcDeConversion);
			document.formAntD.MontoDetCalculado.value= fm(document.formAntD.MontoDetCalculado.value,2);
		}
	}
	
	


</script>
