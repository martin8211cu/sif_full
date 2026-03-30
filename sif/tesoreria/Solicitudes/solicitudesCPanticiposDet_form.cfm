<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('url.TESDPid') and not isdefined('form.TESDPid')>
	<cfparam name="form.TESDPid" default="#url.TESDPid#">
</cfif>
<cfparam name="form.TESDPid" default="">
<cfif isdefined('form.TESDPid') and len(trim(form.TESDPid))>
	<cfset modoD = 'CAMBIO'>
<cfelse>
	<cfset modoD = 'ALTA'>
</cfif>

<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor as CambiarCtas
	  from Parametros
	 where Ecodigo =  #Session.Ecodigo# 
	   and Pcodigo = 2
</cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CPTcodigo, 
			case when coalesce(a.CPTvencim,0) < 0 then a.CPTdescripcion #LvarCNCT# ' (contado)' else a.CPTdescripcion end as CPTdescripcion,
			case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end as CPTorden,
			a.CPTtipo
	<cfif (isdefined("rsForm.SNcodigoOri") and LEN(TRIM(rsForm.SNcodigoOri)))>
			, case when ctas.CFcuenta is null
				then
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta =
							(
								select min(CFcuenta)
								  from CFinanciera
								 where Ccuenta = n.SNcuentacxp
							)
					)
				else
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFformato
			, case when ctas.CFcuenta is null
				then
					(
						select CFdescripcion
						  from CFinanciera
						 where CFcuenta =
							(
								select min(CFcuenta)
								  from CFinanciera
								 where Ccuenta = n.SNcuentacxp
							)
					)
				else
					(
						select CFdescripcion
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFdescripcion
			, case when ctas.CFcuenta is null
				then n.SNcuentacxp
				else
					(
						select Ccuenta
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as Ccuenta
			, case when ctas.CFcuenta is null
				then 
					(
						select min(CFcuenta)
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxp
					)
				else
					ctas.CFcuenta
				end
			as CFcuenta
	  from CPTransacciones a
	  	 inner join SNegocios n
		 	 on n.Ecodigo 	= #session.Ecodigo#
			and n.SNcodigo 	= #rsForm.SNcodigoOri#
	  	 left join SNCPTcuentas ctas
		 	 on ctas.Ecodigo 	= #session.Ecodigo#
			and ctas.SNcodigo 	= #rsForm.SNcodigoOri#
			and ctas.CPTcodigo 	= a.CPTcodigo
	<cfelse>
	  from CPTransacciones a
	</cfif>
	 where a.Ecodigo =  #Session.Ecodigo# 
	   and a.CPTtipo = 'D'
	   and coalesce(a.CPTpago,0) = 0
       and coalesce(a.CPTanticipo,0) = 1
	order by case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end, a.CPTcodigo
</cfquery>

<cfquery datasource="#session.dsn#" name="rsDirecciones">
	select b.id_direccion, c.direccion1 #LvarCNCT# ' / ' #LvarCNCT# c.direccion2 as texto_direccion
	from SNegocios a
		join SNDirecciones b
			on a.SNid = b.SNid
		join DireccionesSIF c
			on c.id_direccion = b.id_direccion
	where a.Ecodigo =  #Session.Ecodigo#  
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigoOri#"> 
	  and b.SNDfacturacion = 1
</cfquery>

<cfif modoD NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsFormDet">
		Select 	
				TESDPid,
				TESDPdocumentoOri, TESDPreferenciaOri, TESDPdescripcion, 
				TESDPmontoSolicitadoOri, 
				0 as CcuentaDB, CFcuentaDB, BMUsucodigo, ts_rversion, OcodigoOri,
				TESRPTCid, id_direccion, TESRPTCietu
		from TESdetallePago 
		where EcodigoOri=  #session.Ecodigo# 
			and TESSPid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			and TESDPid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
	</cfquery>
	
	<!--- Cuenta Contable --->
	<cfif rsFormDet.recordcount and rsFormDet.CFcuentaDB neq ''>
		<cfquery name="rsCuentasDet" datasource="#Session.DSN#">
			select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor
			from CFinanciera
			where Ecodigo =  #session.Ecodigo# 
				and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.CFcuentaDB#">	
		</cfquery>	
	</cfif>
</cfif>

	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
	
	<cfoutput>
	<form action="solicitudesCPanticipos_sql.cfm" onsubmit="return validaDet(this);" method="post" name="formDet" id="formDet">
			<input type="hidden" name="McodigoOri" value="#rsForm.McodigoOri#">
			<input type="hidden" name="TESSPid" value="#rsForm.TESSPid#">
			<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#">
			<input type="hidden" name="TESSPfechaPagar" value="#rsForm.TESSPfechaPagar#">
		<cfif (isdefined("rsForm.SNcodigoOri") and LEN(TRIM(rsForm.SNcodigoOri)))>
			<input type="hidden" name="SNcodigoOri" value="#rsForm.SNcodigoOri#">
		</cfif>

			<table align="center" summary="Tabla de entrada">
				<tr>
					<td valign="top" align="right"><strong>Documento:</strong></td>
					<td valign="top">
						<input type="text" name="TESDPdocumentoOri" id="TESDPdocumentoOri" 
							maxlength="17"
						<cfif modoD EQ 'ALTA'>
							<cfif isdefined("listaDet") and listaDet.recordcount GT 0>
								value="#trim(rsForm.TESSPnumero)#-#listaDet.recordcount#"
							<cfelse>
								value="#trim(rsForm.TESSPnumero)#"
							</cfif>
						<cfelse>
							value="#trim(rsFormDet.TESDPdocumentoOri)#"
						</cfif>
							tabindex="1"
							onBlur="sbTESDPdocumentoOriOnChange();"
						>
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right"><strong>Transaccion:</strong></td>
					<td valign="top">
						<select name="TESDPreferenciaOri" id="TESDPreferenciaOri" 
								onChange="sbCPTcodigoOnChange(this.value);"
								tabindex="1"
						>
								<option value=""></option>
							<cfloop query="rsTransacciones"> 
								<option value="#CPTcodigo#" <cfif modoD NEQ 'ALTA' AND rsFormDet.TESDPreferenciaOri EQ rsTransacciones.CPTcodigo>selected</cfif>>#rsTransacciones.CPTcodigo# - #rsTransacciones.CPTdescripcion#</option>
							</cfloop> 
						</select>
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right"><strong>Descripci&oacute;n:</strong></td>
					<td valign="top">
						<input type="text" name="TESDPdescripcion" id="TESDPdescripcion"
							<cfif modoD NEQ 'ALTA' AND len(rsFormDet.TESDPdescripcion)>value="#rsFormDet.TESDPdescripcion#"</cfif>
							tabindex="1"
							size="80"
						>
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right"><strong>Pago Terceros:</strong></td>
					<td valign="top">
						<cfif modoD NEQ 'ALTA'>
							<cf_cboTESRPTCid query="#rsFormDet#" SNid="#rsForm.SNid#" TESBid="#rsForm.TESBid#">
						<cfelse>
							<cf_cboTESRPTCid SNid="#rsForm.SNid#" TESBid="#rsForm.TESBid#">
						</cfif>
						<cfif modoD EQ "ALTA">
							<cfset rsFormDet.TESRPTCietu = 2>
						</cfif>
						Afectar IETU inmediato:
						<select name="TESRPTCietu" id="TESRPTCietu">
						  <option value="2" <cfif rsFormDet.TESRPTCietu EQ 2>selected</cfif>>NO</option>
						  <option value="3" <cfif rsFormDet.TESRPTCietu EQ 3>selected</cfif>>SÍ</option>
						</select>
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right" nowrap><strong>Cta.Financiera:</strong></td>
					<td valign="top">
					<cfif isdefined("rsParam") and rsParam.CambiarCtas EQ 'N'>
						<input 	type="hidden" 	name="CFcuentaDB" 	id="CFcuentaDB"  	VALUE="<cfif modoD NEQ 'ALTA' and isdefined('rsFormDet') and rsFormDet.RecordCount>#rsFormDet.CFcuentaDB#</cfif>">
					<cfelse>
						<cfif modoD NEQ "ALTA" and isdefined('rsCuentasDet') and rsCuentasDet.recordCount GT 0>
							<cf_cuentas Ccuenta="CcuentaDB" 
										CFcuenta="CFcuentaDB" 
										Cdescripcion="CdescripcionDet" 
										Cformato="CformatoDet" 
										Cmayor="CmayorDet" 
										form="formDet" 
										query="#rsFormDet#" tabindex="1">
						<cfelse>
							<cf_cuentas Ccuenta="CcuentaDB" 
										CFcuenta="CFcuentaDB" 
										Cdescripcion="CdescripcionDet" 
										Cformato="CformatoDet" 
										Cmayor="CmayorDet" 
										form="formDet" 
										tabindex="1">
						</cfif>							
					</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Direcci&oacute;n facturaci&oacute;n:</strong></td>
					<td colspan="12">
						<select style="width:450px" name="id_direccion" id="id_direccion" tabindex="2">
							<option value="">- Ninguna -</option>
							<cfloop query="rsDirecciones">
								<option value="#rsDirecciones.id_direccion#" <cfif modoD NEQ 'ALTA' AND rsDirecciones.id_direccion eq rsFormDet.id_direccion>selected</cfif>>#HTMLEditFormat(rsDirecciones.texto_direccion)#</option>
							</cfloop>
						</select>
					</td> 
				</tr>
				<tr>
					<td valign="top" align="right"><strong>Monto: </strong></td>
					<td valign="top">
						<input name="TESDPmontoSolicitadoOri" 
							id="TESDPmontoSolicitadoOri"
							type="text"
							tabindex="2"
							value="<cfif  modoD NEQ 'ALTA'>#NumberFormat(abs(rsFormDet.TESDPmontoSolicitadoOri),",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right;"
							onFocus="this.value=qf(this); this.select();" 
							onChange="javascript:fm(this,2);"
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							size="14" maxlength="14">
						<cfif isdefined("LvarMnombreSP")>
							#LvarMnombreSP#
						</cfif>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			<cfif NOT isdefined("form.chkCancelados")>
				<tr>
					<td colspan="2" class="formButtons">
						<cf_botones sufijo='Det' modo='#modod#'  tabindex="2">
					</td>
				</tr>
			</cfif>
			</table>
			<cfif modoD NEQ 'ALTA'>
				<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsFormDet.BMUsucodigo)#">
				<input type="hidden" name="TESDPid" value="#rsFormDet.TESDPid#">
				
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
	</form>
</cfoutput>	

<script type="text/javascript">
<!--
		var LvarArrCFcuenta   = new Array();
		var LvarArrCFformato = new Array();
		var LvarArrCFdescripcion = new Array();
	<cfoutput query="rsTransacciones"> 
		<cfif isdefined("rsTransacciones.CFformato")>
			LvarArrCFcuenta  ["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.CFcuenta#";
			LvarArrCFformato["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.CFformato#";
			LvarArrCFdescripcion["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.CFdescripcion#";
		<cfelse>
			LvarArrCFcuenta  ["#rsTransacciones.CPTcodigo#"] = "";
			LvarArrCFformato["#rsTransacciones.CPTcodigo#"] = "";
			LvarArrCFdescripcion["#rsTransacciones.CPTcodigo#"] = "";
		</cfif>
	</cfoutput>
	function sbCPTcodigoOnChange (NC_CPTcodigo)
	{
		if (NC_CPTcodigo != ""){
			document.getElementById("CFcuentaDB").value = LvarArrCFcuenta  [NC_CPTcodigo];
			<cfif isdefined("rsParam") and rsParam.CambiarCtas EQ 'S'>
				var LvarCFformato = LvarArrCFformato[NC_CPTcodigo];
				document.getElementById("CmayorDet").value 		= LvarCFformato.substring(0,4);
				document.getElementById("CformatoDet").value 		= LvarCFformato.substring(5,100);
				document.getElementById("CdescripcionDet").value 	= LvarArrCFdescripcion[NC_CPTcodigo];
			</cfif>
		}else{
			<cfif isdefined("rsParam") and rsParam.CambiarCtas EQ 'S'>
				document.getElementById("CmayorDet").value 		= "";
				document.getElementById("CformatoDet").value 		= "";
				document.getElementById("CdescripcionDet").value 	= "";
			</cfif>
		}
		sbTESDPdocumentoOriOnChange();
	}
	function sbTESDPdocumentoOriOnChange()
	{
		var LvarRef = document.getElementById("TESDPreferenciaOri");
		var LvarDoc = document.getElementById("TESDPdocumentoOri");
		var LvarDescripcion = "Generación de Anticipo CxP";
		if ( LvarRef.selectedIndex > 0)
			LvarDescripcion =
				LvarRef.options[LvarRef.selectedIndex].text.substring(5) +
				" " +
				LvarDoc.value;

		document.getElementById("TESDPdescripcion").value = LvarDescripcion;
	}
	
	function validaDet(formulario)	{
		if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet)){
			var error_input = null;;
			var error_msg = '';
			
			if (formulario.TESDPdocumentoOri.value == "") 
			{
				error_msg += "\n - El Documento no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.TESDPdocumentoOri;
			}
			if (formulario.TESDPreferenciaOri.selectedIndex <= 0) 
			{
				error_msg += "\n - La Transaccion no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.TESDPreferenciaOri;
			}
			if (formulario.TESDPdescripcion.value == "") 
			{
				error_msg += "\n - La Descripción no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.TESDPdescripcion;
			}
			if (formulario.TESRPTCid.value == "") 
			{
				error_msg += "\n - El Concepto de Pagos a Terceros no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.TESRPTCid;
			}
			if (formulario.CFcuentaDB.value == "") 
			{
				error_msg += "\n - La Cuenta Financiera no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.CFcuentaDB;
			}
			if (formulario.TESDPmontoSolicitadoOri.value == "") 
			{
				error_msg += "\n - El monto solicitado no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
			}
			else if (parseFloat(formulario.TESDPmontoSolicitadoOri.value) <= 0)
			{
				error_msg += "\n - El monto solicitado debe ser mayor que cero.";
				if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
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
		
		formulario.TESDPmontoSolicitadoOri.value = qf(formulario.TESDPmontoSolicitadoOri);
		
		return true;
	}

//-->
</script>
