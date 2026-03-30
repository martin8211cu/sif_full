<!---GENERALES--->
<cfif isdefined('url.mensaje')>
			<script language="javascript">
				alert("El complemento que contiene ese concepto no concuerda con ninguna cuenta financiera");
			</script>
		</cfif>

<cfif isdefined('url.TESSAid') and not isdefined('form.TESSAid')>
	<cfparam name="form.TESSAid" default="#url.TESSAid#">
</cfif>


<cfif isdefined('url.TESSADid') and not isdefined('form.TESSADid')>
	<cfparam name="form.TESSADid" default="#url.TESSADid#">
</cfif>

<cfif isdefined('form.TESSADid') and len(trim(form.TESSADid))>
	<cfset modoDep = 'CAMBIO'>
<cfelse>
	<cfset modoDep = 'ALTA'>
</cfif>

<!--- Tipo Gasto--->

<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
		DESC_tipogasto,
		ID_tipo_gasto
	from GASTOE_Ctipos_degastos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- SQL FIN--->



<cfif modoDep NEQ 'ALTA'>
<!---PRINCIPAL--->
		<cfquery datasource="#session.dsn#" name="rsFormAntD">
			select
				TESSAid,
				CFcuenta,
				TESSAMonto,
				ID_concepto_gasto
			from GASTOE_SoliAntiD
			where TESSADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSADid#">
		</cfquery>
<cfif isdefined ('form.ID_concepto_gasto')>
	<cfquery datasource="#session.dsn#" name="rsTipo">
		select ID_tipo_gasto 
		from  
		GASTOE_Cconceptos_degasto 
		where ID_concepto_gasto=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_concepto_gasto#">
	</cfquery>
<cfelse>
<cfquery datasource="#session.dsn#" name="rsTipo">
		select ID_tipo_gasto 
		from  
		GASTOE_Cconceptos_degasto 
		where ID_concepto_gasto=(select ID_concepto_gasto from GASTOE_SoliAntiD where TESSADid=#form.TESSADid#)
	</cfquery>
	</cfif>
</cfif>


<!--- SQL selecciona el concepto asociado a una liquidacion--->

<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
	select 
		c.DESC_concepto_gasto,
		c.ID_concepto_gasto,
		c.ID_tipo_gasto,
		c.complemento
	from GASTOE_Cconceptos_degasto c
		inner join GASTOE_Ctipos_degastos t
		on  c.ID_tipo_gasto = t.ID_tipo_gasto
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modoDep eq "ALTA">
	and c.ID_tipo_gasto= (
						select 
							min(ID_tipo_gasto)
						from GASTOE_Ctipos_degastos
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						)
	<cfelse>
		and c.ID_tipo_gasto = #rsTipo.ID_tipo_gasto#
	</cfif>				 
</cfquery>

<!---QUERYS PARA EL CAMBIO Y PARA LA CUENTA FINANCIERA--->
	<cfquery datasource="#session.dsn#" name="listaDetAnt">
			select
				a.TESSAid,
				a.TESSADid,
				a.ID_concepto_gasto,
				a.CFcuenta, f.CFformato,
				a.TESSAMonto,
				b.DESC_concepto_gasto
			from GASTOE_SoliAntiD a
				inner join CFinanciera f
					on f.CFcuenta = a.CFcuenta
				inner join GASTOE_Cconceptos_degasto b
					on b.ID_concepto_gasto=a.ID_concepto_gasto			
			where TESSAid=#form.TESSAid#
	</cfquery>


	
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction1_ComboConcepto(){
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

	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?ID_tipo_gasto='+vID_tipo_gasto1+'&modoD='+vmodoD1, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
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
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDetAnt#"
					desplegar="CFformato,TESSAMonto,DESC_concepto_gasto"
					etiquetas="Cuenta Financiera, Monto Solicitado, Concepto"
					formatos="S,M,S"
					align="left,center,left"
					ira="solicitudesAnticipo.cfm"
					showEmptyListMsg="yes"
					keys="TESSADid"
					maxRows="4"
					formName="formAntDLista"
					PageIndex="1"
					navegacion="&TESSAid=#form.TESSAid#" />
			</td>
			<td align="left" valign="top" width="20%"></td></tr>
	</table>
	</td>
<!---<script language="JavaScript" src="../../js/utilesMonto.js"></script>
--->	


<td valign="top" width="50%">
<cfoutput>
	<form action="solicitudesAnticipo_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onsubmit="return validaDet(this);" method="post" name="formAntD" id="formAntD">
	<input type="hidden" name="modoDep" id="modoDep"  value="#modoDep#" />
	<input type="hidden" name="TESSAid" id="TESSAid" value="<cfif isdefined('form.TESSAid')>#form.TESSAid#</cfif>"/>
	<input type="hidden" name="TESSADid" id="TESSADid" value="<cfif isdefined('form.TESSADid')>#form.TESSADid#</cfif>"/>
<table width="100%" align="right" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2" valign="top"><hr></td>						
		</tr>
		<tr>
			<td nowrap="nowrap" align="right"  valign="top"><strong>Tipo Gasto:&nbsp; </strong> </td>
			<td>
				<select name="Tipo1" onchange="ajaxFunction1_ComboConcepto();" <cfif modoDep neq "ALTA">disabled="disabled"</cfif>>  
					<cfif rsID_tipo_gasto.RecordCount>
						<cfloop query="rsID_tipo_gasto">
							<option value="#rsID_tipo_gasto.ID_tipo_gasto#"<cfif modoDep neq "ALTA" and rsID_tipo_gasto.ID_tipo_gasto  eq rsTipo.ID_tipo_gasto>selected="selected"</cfif>>#rsID_tipo_gasto.DESC_tipogasto#</option>
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
					<select name="Concepto" id="concepto" <cfif modoDep neq "ALTA">disabled="disabled"</cfif>>  
						<cfif isdefined("rsID_concepto_gasto") and rsID_concepto_gasto.recordcount gt 0>
							<cfloop query="rsID_concepto_gasto">
									<option value="#rsID_concepto_gasto.ID_concepto_gasto#"<cfif modoDep neq 'ALTA' and rsID_concepto_gasto.ID_concepto_gasto eq rsFormAntD.ID_concepto_gasto>selected="selected"</cfif>>#rsID_concepto_gasto.DESC_concepto_gasto#</option>
							</cfloop>
						</cfif>
					</select>
				</span>
			</td>
		</tr>
	<tr><td>&nbsp;</td></tr>	   
<!---MONTO--->
		<tr>
			<td align="right" nowrap><strong>Monto:&nbsp; </strong></td>
			<cfset valor_monto = 0 >
				<cfif modoDep neq 'ALTA'>
					<cfset valor_monto = LSNumberFormat(abs(rsFormAntD.TESSAMonto),"0.00") >
					<td><cf_inputNumber name="MontoDet" value="#valor_monto#" size="15" enteros="13" decimales="2"></td>
				<cfelse>
					<td><cf_inputNumber name="MontoDet" value="0.00" size="15" enteros="13" decimales="2"></td>
				</cfif>
		</tr>
		<tr>
			<td colspan="4" class="formButtons">
				<cf_botones sufijo='Det' modo='#modoDep#' tabindex="2">		
			</td>
		</tr>
	<tr><td>&nbsp;</td></tr>
	</table>
	</form>
	</td>
	</tr>
</table>
	
</cfoutput>

<script type="text/javascript">
	function validaDet(formulario)	{
		if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet)){
			var error_input = null;;
			var error_msg = '';
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
		formulario.MontoDet.value = qf(formulario.MontoDet);		
return true;
	}
</script>