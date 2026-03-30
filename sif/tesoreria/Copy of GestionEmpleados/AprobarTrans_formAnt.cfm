<cfset LvarTipoDocumento = 6>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="form.GEAid" default="">
<cfif isdefined('form.GEAid') and len(trim(form.GEAid))>
	<cfset modo = 'CAMBIO'>
<cfelseif isdefined("LvarComision")>
	<cfset modo = 'COMISION'>
<cfelse>
	<cf_errorCode	code = "50724" msg = "No se puede incluir un Anticipo Manualmente">
</cfif>

<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">	
<cfset btnNameTC="CalcularTC">
<cfset btnValueTC= "Tipos de Cambio">

	<cfquery datasource="#session.dsn#" name="rsForm">
		select
				a.GEAid as TESSPid,
				a.Ecodigo,
				a.CFid,
				a.Mcodigo as McodigoOri,
				a.GEAnumero as TESSPnumero,
				a.GEAtipo,
				a.GEAestado,
				a.GEAfechaPagar,
				a.GEAtotalOri as TESSPtotalPagarOri,
				a.GEAdescripcion,
				a.GEAfechaSolicitud,
				a.UsucodigoSolicitud,
				a.TESBid,
				a.TESid,
				a.ts_rversion,
				a.GEAmsgRechazo,
				a.GEAtipoP,
				b.CFdescripcion,
				b.CFcodigo,
				m.Mnombre,
				m.Miso4217,
				a.GEAviatico,
				a.GEAtipoviatico,
				a.CCHid
		from GEanticipo a
		  inner join CFuncional b
			on a.CFid=b.CFid
		  inner join Monedas m
			on a.Mcodigo=m.Mcodigo
		where a.Ecodigo	 = #session.Ecodigo#
		  and a.GEAid	 = #form.GEAid#
		  and a.GEAtipo	 = #LvarTipoDocumento#
	</cfquery>
	
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select a.TESBid, 
			   a.DEid, 
			   b.DEidentificacion,
			   b.DEapellido1 #_Cat#' '#_Cat# b.DEapellido2#_Cat#', '#_Cat# b.DEnombre as NombreEmp1
		from TESbeneficiario  a
			inner join DatosEmpleado b
				on a.DEid = b.DEid
		where a.TESBid    = #rsForm.TESBid#
	</cfquery>
	
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		select Edescripcion
		from Empresas
		where Ecodigo = #session.Ecodigo#
	</cfquery>
		
	<cfquery  name="rsCajaChica" datasource="#session.dsn#">
		select 
				c.CCHid,
				c.CCHdescripcion,
				c.CCHcodigo,
				c.CCHtipo
		from CCHica c
		  inner join CCHicaCF cf
			on cf.CCHid=c.CCHid
		   and cf.CFid=c.CFid
		where c.Ecodigo   = #session.Ecodigo#
		  and c.CCHestado = 'ACTIVA'
		  and c.Mcodigo   = #rsForm.McodigoOri#
	<cfif tipo EQ "COMISION">
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	</cfif>
		order by c.CCHtipo desc
	</cfquery>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Mcodigo
		  from Empresas
		 where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfif rsSQL.Mcodigo EQ rsForm.McodigoOri>
		<cfset LvarTClabel = "Tipo Cambio">
		<cfset LvarTC = 1>
	<cfelse>
		<cfset LvarTClabel = "Tipo Cambio Histórico">
		<cfquery name="TCsug" datasource="#Session.DSN#">
			select tc.Hfecha, tc.TCcompra, tc.TCventa
			  from Htipocambio tc
			 where tc.Ecodigo = #Session.Ecodigo#
			   and tc.Mcodigo = #rsForm.McodigoOri#
			   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		</cfquery>
		<cfset LvarTC = TCsug.TCventa>
	</cfif>

	<cfoutput>
		<cf_onEnterKey enterActionDefault="none">
		<form action="AprobarTrans_sql.cfm" method="post" name="form1" id="form1">
		<cfif isdefined("LvarComision")>
			<input type="hidden" name="TIPO" value="COMISION">
			<input type="hidden" name="GECid" value="#form.GECid#">
			<input type="hidden" name="idTransaccion" value="#form.idTransaccion#">
		<cfelse>
			<input type="hidden" name="TIPO" value="ANTICIPO">
		</cfif>
			<input type="hidden" name="GEAid" 		  	value="#form.GEAid#">
			<input type="hidden" name="GEAmsgRechazo" 	value="" />
			<input type="hidden" name="GEAnumero"     	value="#rsForm.TESSPnumero#">
			<input type="hidden" name="DEid"     		value="#rsEmpleado.DEid#">
			<input name="LvarSAporEmpleadoCFM" id="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#" type="hidden" />

			<table align="center" summary="Tabla de entrada" border="0">
				<tr>
					<td valign="top" align="right"><strong>Núm. Anticipo:&nbsp;</strong></td>
					<td valign="top"><strong>#LSNumberFormat(rsForm.TESSPnumero)#</strong></td>
					<td valign="top" align="right"><strong>Fecha Solicitud:&nbsp;</strong></td>
					<td valign="top"><strong>#LSDateFormat(rsForm.GEAfechaSolicitud,"DD/MM/YYYY")#</strong></td>
				</tr>
				<tr>
					<td align="right"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
					<td colspan="3"><strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#</strong></td>
				</tr>									
				<tr>
					<td valign="top" nowrap align="right"><strong>Empleado:&nbsp;</strong></td>
					<td valign="top" colspan="3"><strong>#rsEmpleado.DEidentificacion# -#rsEmpleado.NombreEmp1#</strong></td>
				</tr>						
				<tr>
					<td valign="top" align="right"><strong>Moneda:&nbsp;</strong></td>
					<td valign="top">
						<input type="text" disabled="yes" value="#rsForm.Mnombre#" style="text-align:left; border:solid 1px ##CCCCCC;" tabindex="-1">
					</td>
					<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Descripción:</strong></td>
					<td rowspan="3" valign="top">
					    <input type="text" maxlength="1000" width="1000" size="50"  disabled="disabled" style="text-align:left; border:solid 1px ##CCCCCC; "value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GEAdescripcion)#</cfif>">
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong>#LvarTClabel#:&nbsp;</strong></td>
					<td valign="top">
						<input type="text" value="#NumberFormat(LvarTC,",0.0000")#" disabled="yes" style="text-align:left; border:solid 1px ##CCCCCC;" tabindex="-1">
					</td>					
				</tr>
				<tr>
					<td valign="top" align="right" nowrap="nowrap"><strong>Forma de Pago: </strong></td>
				</cfoutput>				
					<td valign="top" align="left"  nowrap="nowrap" colspan="6">
						<select name="FormaPago" id="FormaPago">
							<option value="-1" >(Seleccionar Forma de Pago)</option>
							<optgroup label="Por Tesorería">
							<option value="0" <cfif rsForm.GEAtipoP Neq 0 and rsForm.CCHid eq 0> selected= "selected" </cfif>>Con Cheque o TEF</option>
								<cfif rsCajaChica.RecordCount>
									<cfoutput query="rsCajaChica" group="CCHtipo">
										<cfif CCHtipo EQ 1>
											<optgroup label="Por Caja Chica">
										<cfelse>
											<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Con Efectivo por Caja Especial">
										</cfif>
										<cfoutput>
										<option value="#rsCajaChica.CCHid#" <cfif modo neq "ALTA" and rsCajaChica.CCHid  eq rsForm.CCHid> selected="selected" </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>									
										</cfoutput>
									</cfoutput>
									</optgroup>
								</cfif>                       
						</select>					                             
			  		</td>
				</tr>
				<cfoutput>
				<tr>
					<td valign="top" align="right" nowrap><strong>Total Pago Solicitado:&nbsp;</strong></td>
					<td valign="top">
						<input disabled="disabled" type="text" readonly="yes" value="<cfif  modo NEQ 'ALTA'>#numberFormat(rsForm.TESSPtotalPagarOri,",0.00")#<cfelse>0.00</cfif>" style="text-align:right; border:solid 1px ##CCCCCC;" tabindex="-1">
					</td>
					<cfif #rsForm.GEAviatico# eq '1'>
					<td>
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Tipo Viático:</strong>
					</td>
					<td>
					<cfif #rsForm.GEAtipoviatico# eq '1'>
					  <strong>Interior</strong>
					<cfelseif #rsForm.GEAtipoviatico# eq '2'>
					  <strong>Exterior</strong> 
					</cfif>
					</td>
					</cfif>
				</tr>
				<tr>
					<td valign="top" nowrap align="right"><strong>Fecha Pago Solicitado:&nbsp;</strong></td>
					<td valign="top">
						<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo NEQ 'ALTA'>
							<cfset fechaSol = LSDateFormat(rsForm.GEAfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
							<input type="text" readonly="yes" value="#fechaSol#" style="text-align:right; border:solid 1px ##CCCCCC;" size="11" tabindex="-1" >
						<cfelse>
							<cf_sifcalendario form="form1" value="#fechaSol#" name="GEAfechaPagar" tabindex="1">
						</cfif>
					</td>
				<cfif rsForm.GEAestado eq 3>
					<td valign="top" align="left" right="nowrap"><strong>Motivo de Rechazo:</strong></td>
					<td valign="top" align="left" nowrap="nowrap">#rsForm.GEAmsgRechazo#</td>
				</cfif>
				</tr>			
				<tr>
					<td></td>
					<td></td>
					<td colspan="1" class="formButtons" align="right">
							<cfset LvarAprobar = true>
							<cfset LvarExclude = "Cambio,Baja,Nuevo">
							<cfset LvarEsAprobadorGE = true>
							<cfinclude template="../Solicitudes/TESbtn_Aprobar.cfm">
							
					</td>
					<td align="left"><cf_botones modo="#modo#" includevalues="#btnValueTC#" align="left" include="#btnNameTC#" exclude="#btnExcluirAbajo#"></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>

			<cfset LvarTitulo = 'Detalle del Anticipo'>
			<cf_web_portlet_start border="true" titulo="#LvarTitulo#" skin="#Session.Preferences.Skin#" width="80%">
				<cf_dbfunction name="dateadd" args="a.GEADhoraini,a.GEADfechaini,MI" returnVariable="LvarFechaIni">
				<cf_dbfunction name="date_format" args="#LvarFechaIni#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaIni"	delimiters="°">
				<cf_dbfunction name="dateadd" args="a.GEADhorafin,a.GEADfechafin,MI" returnVariable="LvarFechaFin">
				<cf_dbfunction name="date_format" args="#LvarFechaFin#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaFin"	delimiters="°">
				<cf_dbfunction name="concat" args="#LvarFechaIni#¬' - '¬#LvarFechaFin#" returnVariable="LvarFechas"  		delimiters="¬">
				<cf_dbfunction name="concat" args="v.GECVdescripcion ¬' - '¬d.GEPVdescripcion" returnVariable="LvarConcepto"	delimiters="¬">
				<cfquery datasource="#session.dsn#" name="listaDetAnt">
				     select 
							a.GEAid as TESSPid
							,a.GEADid
							,a.GECid
							,a.CFcuenta
							,f.CFformato
							,a.GEADmonto
							,a.GEADtipocambio
							,a.GEADmontoviatico
							,coalesce(m.Miso4217,'--') as McodigoPlantilla 
							,#preserveSingleQuotes(LvarConcepto)# as Concepto
							 
							,#preserveSingleQuotes(LvarFechas)#    as fechas
						from GEanticipoDet a						
							inner join CFinanciera f
							  on f.CFcuenta = a.CFcuenta						
							inner join GEconceptoGasto b
							  on b.GECid = a.GECid															
				       inner join GEPlantillaViaticos d
							  on a.GEPVid = d.GEPVid						
							inner join GEClasificacionViaticos v 
							  on  v.GECVid = d.GECVid
							inner join Monedas m 
								on a.McodigoPlantilla=m.Mcodigo   							  
						  where a.GEAid=#form.GEAid#
                union 
                    select 
							a.GEAid as TESSPid
							,a.GEADid
							,a.GECid
							,a.CFcuenta
							,f.CFformato
							,a.GEADmonto
							,coalesce(a.GEADtipocambio,0) as GEADtipocambio
							,coalesce(a.GEADmontoviatico,0) as GEADmontoviatico
							,coalesce(m.Miso4217,'--') as McodigoPlantilla 
							,b.GECdescripcion as Concepto
							,'--' as fechas
						from GEanticipoDet a						
							inner join CFinanciera f
							  on f.CFcuenta = a.CFcuenta						
							inner join GEconceptoGasto b
							  on b.GECid = a.GECid	
							inner join Monedas m 
								on a.McodigoPlantilla=m.Mcodigo  					      											   						  
						  where a.GEAid=#form.GEAid#
                            and a.GEPVid is null
						  				  
				</cfquery>
				<cfset LvarDeplegar = "CFformato,Concepto,GEADmontoviatico,McodigoPlantilla,GEADtipocambio,GEADmonto,Fechas">
				<cfset LvarEtiquetas = "Cuenta Financiera,Concepto,Monto Original,Moneda,Tipo Cambio,Monto Solicitado, Fechas">
				<cfset LvarFormatos = "S,S,M,S,M,M,S">
				<cfset LvarAlign = "left,left,center,center,center,center,center">
	
				
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#listaDetAnt#"
					desplegar	= "#LvarDeplegar#"
					etiquetas	= "#LvarEtiquetas#"
					formatos	= "#LvarFormatos#"
					align		= "#LvarAlign#"
					showEmptyListMsg="yes"
					incluyeForm="No"
					showLink="No"
					maxRows="10"
					width="100%"/>			
								
						<BR>
			<cf_web_portlet_end>
		</form>
	</cfoutput>
	<script language="javascript">
	
		function validar(formulario)	
		{
			var error_input;
			var error_msg = '';
			
			if (document.getElementById("GEAfechaPagar").value == "") {
				error_msg += "\n - La Fecha de la Transacción no puede quedar en blanco.";
				error_input = document.getElementById("GEAfechaPagar");
			}
			if (formulario.FormaPago.value == "" || formulario.FormaPago.value == -1 ) {
			error_msg += "\n - Debe seleccionar una forma de Pago.";
			error_input = formulario.FormaPago;
			}				
					
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				error_input.focus();
				return false;
			}
		
			var LvarCboCambioTESid = document.getElementById("cboCambioTESid");
			if(LvarCboCambioTESid && LvarCboCambioTESid.value != "")
			{
				var LvarTesoreria = LvarCboCambioTESid.options[LvarCboCambioTESid.selectedIndex].text;
				var LvarPto = LvarTesoreria.indexOf("(Adm:");
				LvarTesoreria = " Tesoreria de Pago:\t" + LvarTesoreria.substring(0,LvarPto) + ",\n Administrada por:\t" + LvarTesoreria.substring(LvarPto+6);
				LvarTesoreria = LvarTesoreria.substring(0,LvarTesoreria.length-1);
				return confirm("CAMBIO DE TESORERIA:\n\n¿Desea que el proceso de pago se realice en \n" + LvarTesoreria + "?" );
			}
			return true;
		}
		function funcAprobar()
		{
			if (validar(document.form1))
			{ 
				return confirm('¿Desea APROBAR la Transaccion ## <cfoutput>#rsform.TESSPnumero#</cfoutput> para pago por '+document.form1.FormaPago.options[document.form1.FormaPago.selectedIndex].text + '?');
			}
			return false;
		}	

		function funcRechazar(){
		<cfif isdefined ("rsForm.TESSPnumero")>	
			var vReason = prompt('¿Desea RECHAZAR la Transacción # <cfoutput>#rsForm.TESSPnumero#</cfoutput>?, Debe digitar una razón de rechazo!','');
			if (vReason && vReason != ''){
				document.form1.GEAmsgRechazo.value = vReason;
				return true;
			}
			if (vReason=='')
				alert('Debe digitar una razón de rechazo!');
			return false;
		</cfif>
		}
	</script>

