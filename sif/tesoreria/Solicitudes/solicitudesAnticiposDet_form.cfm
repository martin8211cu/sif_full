<cfif isdefined('url.TESDPid') and not isdefined('form.TESDPid')>
	<cfparam name="form.TESDPid" default="#url.TESDPid#">
</cfif>
<cfparam name="form.TESDPid" default="">
<cfif isdefined('form.TESDPid') and len(trim(form.TESDPid))>
	<cfset modoD = 'CAMBIO'>
<cfelse>
	<cfset modoD = 'ALTA'>
</cfif>

<cfif modoD NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsFormDet">
		Select 	TESDPid,
				TESDPfechaVencimiento,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPdescripcion, 
				TESDPmontoVencimientoOri, 
				TESDPmontoSolicitadoOri, 
				ts_rversion
		from TESdetallePago 
		where EcodigoOri= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and TESSPid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			and TESDPid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
	</cfquery>
</cfif>

<cfoutput>

	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
	
	<cfoutput>
	<form action="solicitudesAnt#LvarTipoAnticipo#_sql.cfm" onsubmit="return validaDet(this);" method="post" name="formDet" id="formDet">
			<input type="hidden" name="McodigoOri" value="#rsForm.McodigoOri#">
			<input type="hidden" name="TESSPid" value="#rsForm.TESSPid#">
			<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#">
			<input type="hidden" name="TESSPfechaPagar" value="#rsForm.TESSPfechaPagar#">

			<table align="center" summary="Tabla de entrada" border="0" width="10%">
				<tr>
					<td valign="top" align="right" width="1%">
						<strong>Fecha:&nbsp;</strong>
					</td>
					<td valign="top" width="1%">
						#DateFormat(rsFormDet.TESDPfechaVencimiento,"DD/MM/YYYY")#
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right" nowrap><strong>Documento:&nbsp;</strong></td>
					<td valign="top" nowrap>#rsFormDet.TESDPdocumentoOri#&nbsp;&nbsp;</td>
					<td valign="top"><strong>Referencia:&nbsp;</strong>&nbsp;#rsFormDet.TESDPreferenciaOri#</td>
				</tr>
				<tr>
					<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
					<td valign="top" colspan="4">
						<input type="text" name="TESDPdescripcion" id="TESDPdescripcion" tabindex="1" 
							value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.TESDPdescripcion)#</cfif>"
							size="50" maxlength="80"
						>
					</td>
				</tr>								
				<tr>
					<td valign="top" align="right" nowrap>
						<strong>Saldo:&nbsp;</strong>
					</td>
					<td valign="top" colspan="3">
						<input type="hidden" 
							name="TESDPmontoVencimientoOri" 
							id="TESDPmontoVencimientoOri"
							value="<cfif  modoD NEQ 'ALTA'>#rsFormDet.TESDPmontoVencimientoOri#<cfelse>0.00</cfif>"
						>
						<input 
							type="text"
							tabindex="-1" readonly="yes"
							size="18"
							value="<cfif  modoD NEQ 'ALTA'>#NumberFormat(abs(rsFormDet.TESDPmontoVencimientoOri),",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right;border:none;" >
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong>Monto:&nbsp;</strong></td>
					<td valign="top" colspan="3">
						<input name="TESDPmontoSolicitadoOri" 
							id="TESDPmontoSolicitadoOri"
							type="text"
							tabindex="1"
							value="<cfif  modoD NEQ 'ALTA'>#NumberFormat(abs(rsFormDet.TESDPmontoSolicitadoOri),",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right;"
							onFocus="this.value=qf(this); this.select();" 
							onBlur="javascript:fm(this,2);"
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							size="18" maxlength="18"
							>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
			<cfif NOT isdefined("form.chkCancelados")>
				<tr>
					<td colspan="4" class="formButtons">
						<cf_botones sufijo='Det' modo='#modod#' exclude="Nuevo" tabindex="1">
					</td>
				</tr>
			</cfif>
			</table>
			<cfif modoD NEQ 'ALTA'>
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
		function validaDet(formulario)	{
			if (btnSelectedDet('CambioDet',document.formDet)){
				var error_input = null;;
				var error_msg = '';
				var LvarSaldo = formulario.TESDPmontoVencimientoOri.value;
				var LvarMonto = qf(formulario.TESDPmontoSolicitadoOri);
				if (formulario.TESDPdescripcion.value == "") 
				{
					error_msg += "\n - La Descripcion no puede quedar en blanco.";
					if (error_input == null) error_input = formulario.TESDPdescripcion;
				}
				if (formulario.TESDPmontoSolicitadoOri.value == "") 
				{
					error_msg += "\n - El monto solicitado no puede quedar en blanco.";
					if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
				}
				else if (parseFloat(LvarMonto) <= 0)
				{
					error_msg += "\n - El monto solicitado debe ser mayor que cero.";
					if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
				}
				else if (parseFloat(LvarMonto) > parseFloat(LvarSaldo))
				{
					error_msg += "\n - El monto solicitado no debe ser mayor que el Saldo del Anticipo.";
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
</cfoutput>