<cfset btnNameCalcular="CalcularViaticos">
<cfset btnValueCalcular= "Calcular Viaticos">
<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">	
<!--- Formulario para la insercion de un encabezado de una liquidación --->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset LvarTipoDocumento = 7>
<cfparam name="form.GELid" default="">

<cfif isdefined ('url.error') and len(trim(url.error)) gt 0>
	<script language="javascript">
		alert('La moneda de la liquidación y la del documento deben de ser iguales');
	</script>
</cfif>
<cfif isdefined( 'url.GELid')  and len(trim(url.GELid))>
	<cfset form.GELid=#url.GELid#>
</cfif>
<cfif isdefined('form.GELid') and len(trim(form.GELid))> <!---or isdefined('form.GEAnumero')--->
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
<cfquery name="rsSPaprobador" datasource="#session.dsn#">
	Select TESUSPmontoMax, TESUSPcambiarTES
	from TESusuarioSP
	where <!---CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
	and---> Usucodigo	= #session.Usucodigo#
	and TESUSPaprobador = 1
</cfquery>
<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
	
<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			c.CCHid,
			c.CCHdescripcion,
			c.CCHcodigo,
			m.Miso4217
	from CCHica c
		inner join Monedas m
		on m.Mcodigo=c.Mcodigo
	where c. Ecodigo=#session.Ecodigo#
	and c.CCHestado='ACTIVA'
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select 
			a.GELid, 
			a.GELfecha,
			coalesce(a.CCHid,0) as CCHid,
			a.GELnumero,
			a.Mcodigo,
			coalesce(a.GELtotalGastos,0) as GELtotalGastos,
			coalesce(a.GELtotalAnticipos,0) as GELtotalAnticipos,
			coalesce(a.GELtotalDepositos,0) as GELtotalDepositos,
			coalesce(a.GELreembolso,0) as GELreembolso,
			a.CFid,
			a.TESBid,
			a.BMUsucodigo,
			a.ts_rversion,
			a.GELtipoCambio,
			a.GELestado,
			a.GELmsgRechazo,
			a.GELtipoP ,
			coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones
			,GELdescripcion
			,GEAviatico
			,GEAtipoviatico			

		  from GEliquidacion a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.Ecodigo
				where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.GELid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		  and a.GELtipo= #LvarTipoDocumento#
	</cfquery>

	<cfquery name="rsAntic" datasource="#session.dsn#">
		select count(1) as cantidad from GEliquidacionAnts where GELid=#form.GELid#
	</cfquery>
		<cfif rsAntic.cantidad gt 0>
			<cfset negativo=1>
		</cfif>
	<cfquery datasource="#session.dsn#" name="Benef">
		select DEid as emple from TESbeneficiario where TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#rsForm.TESBid#">
	</cfquery>
	
	<!---Indica Forma de Pago cuando hay anticipos relacionados.--->
	<cfquery name="rsAntPago" datasource="#session.dsn#">
		select a.GEAid,a.GELid,b.GEAtipoP, b.CCHid
		from GEliquidacionAnts a
			inner join GEanticipo b
				on a.GEAid=b.GEAid
		where a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfquery name="rsTotalReal" datasource="#session.dsn#">
		select sum (GELVmonto)as total 
			from GEliquidacionViaticos
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfoutput>
<form action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onSubmit="return validar(this);" method="post" name="form1" id="form1" style= "margin: 0;">
	<cfif isdefined ('url.GEAid') and len(trim(url.GEAid)) gt 0>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select a.CFid, a.TESBid,a.Mcodigo,a.GEAmanual,a.GEAtipoP, b.CFcodigo,c.TESBeneficiario,m.Mnombre,c.DEid,b.CFdescripcion,o.Oficodigo
			from 
			GEanticipo a
				inner join CFuncional b
					inner join Oficinas o
					on b.Ocodigo=o.Ocodigo
				on a.CFid=b.CFid
				inner join TESbeneficiario c
				on a.TESBid=c.TESBid
				inner join Monedas m
				on a.Mcodigo=m.Mcodigo
			where 
			GEAid=#url.GEAid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
			<input type="hidden" name="DEid" value="#rsAnticipo.DEid#" />
			<input type="hidden" name="McodigoE" value="#rsAnticipo.Mcodigo#" />
			<input type="hidden" name="GELtipoCambio" value="#rsAnticipo.GEAmanual#" />
	</cfif>

	  <cfoutput>
	    <table align="center" summary="Tabla de entrada"  width="100%" border="0">
			<tr>
				<!---Número de la Liquidación --->
				<td valign="top" align="right"><strong>Núm. Liquidación:&nbsp;</strong>					
				</td>
				<td valign="top">						
					<cfif modo NEQ 'ALTA'>
						<strong>#rsForm.GELnumero#</strong>
						<input type="hidden" name="GELnumero" value="#rsForm.GELnumero#">
						<input type="hidden" name="Mcodigo" value="#rsForm.Mcodigo#">
						<input type="hidden" name="CFid" value="#rsForm.CFid#">
					<cfelse>
						&nbsp;&nbsp; -- Nueva Liquidación --
					</cfif>					
				</td>
					
				<!---Fecha Liquidación--->					
				<td valign="top" align="right">
					<strong>Fecha Liquidación:&nbsp;</strong>					
				</td>
				<td valign="top" align="left">
					<cfif modo NEQ 'ALTA'>
						<strong>#LSDateFormat(rsForm.GELfecha,"DD/MM/YYYY")#</strong>
						<input type="hidden" name="GELfecha" value="#rsForm.GELfecha#">
					<cfelse>
						&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
					</cfif>					
				</td>
			</tr>
			<tr>				
				<!---Centro Funcional --->					
				<td align="right">
					<strong>Centro&nbsp;Funcional:&nbsp;</strong>					
				</td>
				<td colspan="1">
				  <cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
					<input type="text" name="CFuncional" value="#trim(rsAnticipo.CFcodigo)#-#trim(rsAnticipo.CFdescripcion)# (Oficina: #trim(rsAnticipo.Oficodigo)#)" disabled="disabled" size="55"/>
				  <cfelse>
					  <cfif modo neq 'ALTA'>
							<cfquery name="rsCF" datasource="#session.dsn#">
								select CFcodigo,CFdescripcion from CFuncional where CFid=#rsForm.CFid#
							</cfquery>
							<input name="CFunc" type="text" disabled="disabled" value="#rsCF.CFcodigo#-#rsCF.CFdescripcion#" size="55" />
					  <cfelse>
						<cf_cboCFid tabindex="1">
					  </cfif>
				  </cfif>					
				 </td>
			</tr>
			<tr>
				<!---Empleado--->
				<td align="right">
					<strong>Empleado:&nbsp;</strong>
				</td>
				<td valign="top" nowrap="nowrap">
					<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
						<input type="text" name="Empleado" value="#rsAnticipo.TESBeneficiario#" size="55" disabled="disabled"/>
					<cfelse>
						<cfif modo NEQ 'ALTA'>
							<!---<cfif isdefined("LvarSAporEmpleado") OR rsForm.GELtotalGastos NEQ 0 or rsAntic.cantidad gt 0>--->
								<cfset LvarModificable = 'N'>
						<!---	<cfelse>
								<cfset LvarModificable = 'S'>
							</cfif>   --->
							<cfset LvarDEid = Benef.emple>
						<cfelse>
							<cfif isdefined("LvarSAporEmpleado")>
								<cfquery name="rsSQL" datasource="#session.dsn#">
									select llave as DEid
									from UsuarioReferencia
									where Usucodigo= #session.Usucodigo#
									and Ecodigo      = #session.EcodigoSDC#
									and STabla        = 'DatosEmpleado'
								</cfquery>
									<cfif rsSQL.recordCount EQ 0>
										<cf_errorCode	code = "50740" msg = "El usuario no ha sido registrado como Empleado de la Empresa">
									</cfif>
								<cfset LvarDEid = rsSQL.DEid>
								<cfset LvarModificable = 'N'>
							<cfelse>
								<cfset LvarDEid = "">
								<cfset LvarModificable = 'S'>
							</cfif>
						</cfif>

					</cfif>
					<cf_conlis title="LISTA DE EMPLEADOS"
					campos = "DEid, DEidentificacion, DEnombre" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombre"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombre"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre"
					etiquetas="Identificación,Nombre"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre"
					index="1"                                  
					traerInicial="#LvarDEID NEQ ''#"
					traerFiltro="DEid=#LvarDEid#"
					readonly="#LvarModificable EQ 'N'#"
					funcion="funcCambiaDEid"
					fparams="DEid"/>        

				</td>
				<!---Descripción Liquidación --->
				<td rowspan="1" valign="top" align="right" nowrap="nowrap">
						<strong>Descripción:</strong>				    
				</td>
				<td valign="top" align="left">
						<input type="text"
						  tabindex="1" 
						  name="GELdescripcion" 
						  maxlength="40" 
						  size="40" 
						  id="GELdescripcion" 
						  value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GELdescripcion)#</cfif>">
				</td>
			</tr>	
			<tr>
				<!--- Moneda Local --->
				<td valign="top" align="right">
					<strong>Moneda:&nbsp;</strong>
				</td>
				<td valign="top">	
				  <cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
					<input type="text" name="Moneda" value="#rsAnticipo.Mnombre#" disabled="disabled" />
				  <cfelse>						
					<cfif  modo NEQ 'ALTA'>
						<cfquery name="rsMoneda" datasource="#session.DSN#">
							select Mcodigo, Mnombre
							from Monedas
							where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
								and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
<!---						<cfif rsForm.GELtotalGastos GT 0 or rsAntic.cantidad gt 0>
--->							<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.GELtipoCambio#" 	
							form="form1" Mcodigo="McodigoE" query="#rsMoneda#" 
							FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="Y" readOnly="yes">
						<!---<cfelse>
							<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.GELtipoCambio#" 
							form="form1" Mcodigo="McodigoE" query="#rsMoneda#" 
							FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
						</cfif>--->
					<cfelse>
						<cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
						form="form1" Mcodigo="McodigoE"  tabindex="1" readOnly="yes">
					</cfif>	
				  </cfif>						
				</td>
					
				<!---TOTAL DEL ANTICIPO NO ESTA MODIFICADO --->
				<td valign="top" align="right" nowrap>
					<strong>Total Anticipos:&nbsp;</strong>
				</td>
				<td valign="top">
					<input type="text" align="right"
						name="GELtotalAnticipos" 
						id="GELtotalAnticipos"
						readonly="yes"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GELtotalAnticipos,",0.00")#<cfelse>0.00</cfif>"
						style="text-align:right; border:solid 1px ##CCCCCC;"
						tabindex="1"
					>					
				</td>
			</tr>
			<tr>
				<!--- Tipo Cambio --->
				<td valign="top" align="right">
					<strong>Tipo de Cambio:&nbsp;</strong>
				</td>
				<td valign="top">
				  <cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
					<input type="text" name="tipoC" value="#rsAnticipo.GEAmanual#" disabled="disabled"/>
				  <cfelse>
					<input name="GELtipoCambio" 
					id="GELtipoCambio"
					maxlength="10"
					value="<cfif modo NEQ'ALTA'>#NumberFormat(rsForm.GELtipoCambio,"0.0000")#</cfif>"
					style="text-align:right;"
					onfocus="this.value=qf(this); this.select();" 
					onblur="javascript: fm(this,4);"
					onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
					tabindex="1" />
				  </cfif>
				</td>				
				<!---Monto Total de Doc. Liquidantes --->
				<td valign="top" align="right" nowrap>
					<strong>Total Gastos  :&nbsp;</strong>
				</td>
				<td valign="top">
					<input type="text"
					name="GELtotalGastos" 
					id="GELtotalGastos"
					readonly="yes"
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GELtotalGastos,",0.00")#<cfelse>0.00</cfif>"
					style="text-align:right; border:solid 1px ##CCCCCC;"
					tabindex="1"
					>					
				</td>
			</tr>
			<tr>
			<!---total viaticos--->
			<td></td><td></td>
			<td valign="top" align="right" nowrap="nowrap">
				<strong>Total Viaticos  :&nbsp;</strong>
			</td>
			<td valign="top">
				<input type="text"
				name="GELtotalViaticos" 
				id="GELtotalViaticos"
				readonly="yes"
				value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsTotalReal.total,",0.00")#<cfelse>0.00</cfif>"
				style="text-align:right; border:solid 1px ##CCCCCC;"
				tabindex="1"
				>					
			</td>
			</tr>		
			<tr>
				<cfif modo NEQ 'ALTA'>
					<cfif #rsForm.GELestado# EQ 3>
						<td valign="top" align="right" nowrap="nowrap">
							<strong>Motivo de Rechazo:</strong>
						</td>
						<td valign="top" align="left">
						<cfoutput><font color="FF0000">#rsForm.GELmsgRechazo#</font></cfoutput>							
						</td>
					<cfelse>
						<td colspan="2">&nbsp;</td>
					</cfif>
				<cfelse>
					<td colspan="2">&nbsp;</td>
				</cfif>
				<!---Monto Total Deposito --->
				<cfif modo neq 'ALTA'>
					<cfif rsForm.GELtipoP eq 0>
						<td valign="top" align="right" nowrap="nowrap">
							<strong>Devoluciones :&nbsp;</strong>
						</td>
						<td valign="top">
							<input type="text"
							name="GELtotalDepositos" 
							id="GELtotalDepositos"
							readonly="yes"
							value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GELtotalDevoluciones,",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right; border:solid 1px ##CCCCCC;"
							tabindex="1"
							>					
						</td>
				
				<cfelse>
					<td valign="top" align="right" nowrap="nowrap">
						<strong>Total Deposito  :&nbsp;</strong>
					</td>
					<td valign="top">
						<input type="text"
						name="GELtotalDepositos" 
						id="GELtotalDepositos"
						readonly="yes"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GELtotalDepositos,",0.00")#<cfelse>0.00</cfif>"
						style="text-align:right; border:solid 1px ##CCCCCC;"
						tabindex="1"
						>					
					</td>
				</cfif>
			</cfif>
			</tr>
		</cfoutput>
</cfoutput>	

			<tr>
				<!---<cfif modo NEQ 'ALTA'>--->
				<!---<cfif LvarEsAprobadorSP>--->
				<td valign="middle"align="right" nowrap="nowrap">
					<strong>Pagada por:&nbsp; </strong>
				</td>
				<td valign="middle" align="left" nowrap="nowrap">
						<select name="FormaPago" id="FormaPago" <cfif modo EQ 'CAMBIO'>disabled="disabled"</cfif>>
								<option value="">--</option>
								<option value="0"<cfif modo EQ 'CAMBIO'and rsForm.CCHid EQ 0>selected="selected"</cfif>>Tesoreria </option>
								<cfif rsCajaChica.RecordCount>
									<cfoutput query="rsCajaChica" group="CCHid">
										<option value="#rsCajaChica.CCHid#"<cfif modo eq "CAMBIO" and rsCajaChica.CCHid  eq rsForm.CCHid or isdefined('rsAntPago') and rsCajaChica.CCHid eq rsAntPago.CCHid>selected="selected"</cfif>>#rsCajaChica.CCHcodigo#/#rsCajaChica.CCHdescripcion#-#rsCajaChica.Miso4217#</option>
									</cfoutput>
								</cfif>                       
						</select>
						<cfif modo eq 'CAMBIO'>
							<cfoutput>
                            <input type="hidden" name="CCHid" value="#rsForm.CCHid#" />
							<cfif rsForm.GELtipoP eq 1>
                                <input type="hidden" name="FormaPago" value="0" />
                            <cfelse>
                                <input type="hidden" name="FormaPago" value="#rsForm.CCHid#" />
                            </cfif>
                            </cfoutput>
						</cfif>
					
				</td>				
				<!---</cfif>--->
				<!---</cfif>--->
				<cfoutput>
				<!---Rembolso al Empleado --->				
				<td valign="top" align="right" nowrap><strong>Pago al Empleado: &nbsp;</strong></td>
				<td valign="top" align="left">
					<input type="text"
						name="GELreembolso" 
						id="GELreembolso"
						readonly="yes"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GELreembolso,",0.00")#<cfelse>0.00</cfif>"
						style="text-align:right; border:solid 1px ##CCCCCC;"
						tabindex="1"
					>					
				</td>
			</tr>
			<cfif (isdefined ('rsAntPago') and rsAntPago.recordcount eq 0)  or not isdefined ('rsAntPago') and  modo eq 'ALTA'><!---si no tiene anticipos asociado es decir es una liq directa--->
				<tr><td></td><td></td>
					<!---Si es Viatico--->
					<td align="right" valign="top" nowrap><strong>Vi&aacute;tico:&nbsp;</strong></td>
						<td>
							<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1" onchange="cambiaUsoCuenta();"     <cfif modo NEQ "ALTA" and #rsForm.GEAviatico# EQ 1>checked="checked" disabled="disabled" </cfif>  value="1"  />
						</td>
				</tr>
				<tr>
	
					<td></td>	
					<cfif isdefined ("rsForm.GEAviatico") and rsForm.GEAviatico EQ 1>
						<td align="right">
							<input name="LvarSAporEmpleadoCFM" id="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#" type="hidden" />
							<cf_botones modo="#modo#" includevalues="#btnValueCalcular#" align="right"  	include="#btnNameCalcular#" exclude="#btnExcluirAbajo#">		
						</td>	
					<cfelse>
						<td></td>
					</cfif>
					
					<td align="right"><strong>Tipo:&nbsp;</strong></td>
					<td nowrap="nowrap" align="left">		
						<input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 1> checked=" checked " </cfif>checked >
							<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Interior</label>
						 <input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 2>  checked="checked"  </cfif> >
							<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Exterior</label>					
					</td>	
					
				</tr>
			</cfif>
			<tr>
				<td colspan="4" class="formButtons" align="center">
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="GELid" value="#HTMLEditFormat(rsForm.GELid)#">
					<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">				
					<cfset ts = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
							artimestamp="#rsForm.ts_rversion#" returnvariable="ts">							
						</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
				<cfinclude template="TESbtn_Aprobar.cfm">	
						
				
			</tr>
	</table>
</form>
<!---ValidacionesFormulario--->
<script type="text/javascript">
<!--
function validar(formulario){
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1) && !btnSelected('Anticipos',document.form1)){
		var error_input;
      	var error_msg = '';
		
		<cfif modo eq 'Alta'>
			if (formulario.GELtotalGastos.value == "") {
				error_msg += "\n - El Monto del gasto no puede ir en blanco.";
				error_input = formulario.GELtotalGastos;
			}      
			     
			/*else if (parseFloat(formulario.GELtotalGastos.value) <= 0){
				error_msg += "\n - El monto del gastos debe ser mayor que cero.";
					if (error_input == null) 
					error_input = formulario.GELtotalGastos;
			}*/
			formulario.GELtotalGastos.value = qf(formulario.GELtotalGastos);
			document.form1.GELtotalGastos.value = 0.00;
//document.form1.MontoDetA.value=formatCurrency(document.form1.TC,2);
		</cfif>
			if (formulario.McodigoE.value == "") {
				error_msg += "\n - La Moneda no puede quedar en blanco.";
				error_input = formulario.McodigoE;
 			}
			
			if (formulario.GELdescripcion.value == "") {
				error_msg += "\n - La descripción no puede quedar en blanco.";
				error_input = formulario.GELdescripcion;
			} 
			
			if (formulario.FormaPago.value == "") {
				error_msg += "\n - La forma de pago no puede quedar en blanco.";
				error_input = formulario.GELdescripcion;
			} 
			if (formulario.DEid.value == "") {
				error_msg += "\n - La descripción del empleado no puede quedar en blanco.";
				error_input = formulario.DEid;
			}
		<cfif modo eq 'CAMBIO'>
			if (formulario.FormaPago.value == "") {
				error_msg += "\n - Debe seleccionar una forma de Pago.";
				error_input = formulario.FormaPago;
			}
		</cfif>           
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
			 return false;
			 }
	 }
	if(formulario.GELtipoCambio.disabled)
		formulario.GELtipoCambio.disabled = false;
		return true;
		
	if(formulario.FormaPago.disabled)
	formulario.FormaPago.disabled = true;
	return true;
	}
/* aqui asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTC() {      
	if (document.form1.McodigoE.value == "#rsMonedaLocal.Mcodigo#") {
		formatCurrency(document.form1.TC,2);
		document.form1.GELtipoCambio.disabled = true;                                   
	}
	else
		document.form1.GELtipoCambio.disabled = true;
		var estado = document.form1.GELtipoCambio.disabled;
		document.form1.GELtipoCambio.disabled = true;
		document.form1.GELtipoCambio.value = fm(document.form1.TC.value,4);
		document.form1.GELtipoCambio.disabled = estado;
	}
asignaTC();


function cambiaUsoCuenta()
{
	if(document.form1.GEAviatico.checked) 
	{
		 SiViatico ();
	}
}

function SiViatico ()
{
	var estado=document.form1.GEAviatico.checked;
	
	if(!estado){
		disabled="disabled";
		document.form1.GEAtipoviatico1.disabled=disabled;
		document.form1.GEAtipoviatico2.disabled=disabled;
	}else{
		var disabled="";
		document.form1.GEAtipoviatico1.disabled=disabled;
		document.form1.GEAtipoviatico2.disabled=disabled;
	}

}
 //-->
</script>
</cfoutput>
<cfif isdefined('form.GELid') and len(trim(form.GELid))>
	<cfinclude template="DetLiquidaciones.cfm">
</cfif>

		





