<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="url.tab" default="1">

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select m.Mcodigo, m.Miso4217
	  from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfset LvarTipoDocumento = 7>
<form action="CancLIQGE_sql.cfm" name="form1" method="post" onsubmit="return validar(this);" id="form1">
<input type="hidden" name="TIPO" value="GASTO">
<cfif isdefined('url.GELid') and not isdefined ('form.GELid')>
	<cfset form.GELid=url.GELid>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('url.Mensaje')>
	<script lenguage="javascript">
		alert('No se puede aprobar la liquidación porque el pago al empleado es mayor que cero y quedan saldos en los anticipos');
	</script>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('form.GELid')>
	<cfset llave=form.GELid>
	<cfset modo = 'CAMBIO'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select 
			a.GELid, 
			a.GELfecha,
			coalesce(a.CCHid,0) as CCHid,
			a.GELnumero,
			a.Mcodigo,
			a.GELdesde, a.GELhasta,
			a.CFid,
			a.TESBid,
			a.BMUsucodigo,
			a.ts_rversion,
			a.GELtipoCambio,
			a.GELestado,
			a.GELmsgRechazo,
			a.GELtipoP,
				case 
					when a.CCHid is null then 'TES'
					when (select CCHtipo from CCHica where CCHid = a.CCHid) = 2 then 'TES'
					else 'CCH'
				end as GELtipoPago,
			GELdescripcion,
			GEAviatico,
			GEAtipoviatico,
			a.GECid as GECid_comision,

			case 
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then 1 else 0 
			end as InitDocs,
			case 
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then GELtotalGastos else GELtotalDocumentos
			end as GELtotalDocumentos,
			GELtotalGastos,
			GELtotalTCE,
			GELtotalRetenciones,
			
			GELtotalAnticipos,
			
			GELtotalDepositos,
			GELtotalDepositosEfectivo,
			GELtotalDevoluciones,
			
			GELreembolso,
			( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion 
				from CFuncional cf 
				where cf.CFid = a.CFid
			) as CentroFuncional,
			
			(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2 
				from DatosEmpleado Em,TESbeneficiario te 
					where a.TESBid=te.TESBid 
					and Em.DEid=te.DEid
			) as Empleado,	
			
			(select DEid 
				from TESbeneficiario te 
					where a.TESBid=te.TESBid 
			) as DEid,
					
			mo.Mnombre as Moneda, mo.Mnombre, mo.Miso4217,
				(GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones ) as MiDevolucion,
				(GELtotalGastos - GELtotalRetenciones - GELtotalAnticipos - GELtotalTCE 
					+ (GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones )
					- GELreembolso) as MiTotal
		  from GEliquidacion a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.Ecodigo
				left join Monedas mo
					on mo.Mcodigo = a.Mcodigo
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
</cfif>
<cfset LvarSAporComision = isdefined("rsForm") and rsForm.GECid_comision NEQ "">

<!---Total Anticipos --->
<cfquery name="totalAntic" datasource="#session.dsn#">
	select coalesce(sum(GELAtotal),0) as totalAnticipos 
	from GEliquidacionAnts 
	where GELid=1
</cfquery>

<cfquery name="sinAnticipos" datasource="#session.dsn#">
	select a.GEAid 
	from GEliquidacionAnts a 
			 inner join GEanticipoDet c 
			   on c.GEAid=a.GEAid 
			   and c.GEADid=a.GEADid 
		where 	a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" >   
</cfquery>		   

<!--- Query que determina si el Usuario es Aprobador de Tesoria--->
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			c.CCHtipo,
			c.CCHid,
			c.CCHdescripcion #LvarCNCT# ' - ' #LvarCNCT# m.Miso4217 as CCHdescripcion,
			c.CCHcodigo,
			m.Miso4217, m.Mcodigo
	from CCHica c
		inner join Monedas m
		on m.Mcodigo=c.Mcodigo
	where c. Ecodigo=#session.Ecodigo#
	  and c.CCHestado='ACTIVA'
	  and c.CCHtipo <> 3
	<cfif rsForm.GELtipoPago EQ "CCH">
		  and c.CCHid = #rsForm.CCHid#   <!--- Compatibilidad cuando no se verificaba CF y ya se habia incluido una CCH --->
	<cfelseif modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "TES">
		  and c.CCHtipo = 2   <!--- Por tesoreria solo se permite Cajas Especiales --->
	<cfelseif LvarSAporComision>
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	</cfif>
	order by c.CCHtipo desc
</cfquery>

<cfoutput>
<input type="hidden" name="msgRechazo" value="">
<input type="hidden" name="GELid" value="#llave#">
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
	<cfif LvarSAporComision>
		<tr>
			<td align="right">
				<strong>Num. Comision:&nbsp;</strong>
			</td>
			<td>
				<input type="hidden" name="GECid_comision" value="#rsForm.GECid_comision#">
				<input type="hidden" name="DEid" value="#rsGEcomision.DEid#">
				<input type="text" value="#rsGEcomision.GECnumero# - #rsGEcomision.GECdescripcion#"
					readonly tabindex="-1"
					style="border:none; font-weight:bold; width:350px"
				>
				
			</td>
			<td align="right">
				<strong>Planeado:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECdesdePlan NEQ "">
					<cfset LvarDias = datediff("d",rsGEcomision.GECdesdePlan,rsGEcomision.GEChastaPlan)+1>
					<cfif LvarDias GT 1>
						<cfset LvarDias = "#LvarDias# días planeados">
					<cfelse>
						<cfset LvarDias = "Un día planeado">
					</cfif>
					<input type="text" value="desde #dateFormat(rsGEcomision.GECdesdePlan,"DD/MM/YYYY")# hasta #dateFormat(rsGEcomision.GEChastaPlan,"DD/MM/YYYY")#  #LvarDias#" style="border:none" size="60" readonly/>
				</cfif>
			</td>
		</tr>
		<tr>				
			<!---Centro Funcional --->					
			<td align="right">
				<strong>Centro&nbsp;Funcional:&nbsp;</strong>					
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.CFcodigo)# - #trim(rsGEcomision.CFdescripcion)# (Oficina: #trim(rsGEcomision.Oficodigo)#)" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong>Aprobado:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECdesdeReal EQ "">
					No se han aplicado Liquidaciones
				<cfelse>
					<cfset LvarDias = datediff("d",rsGEcomision.GECdesdeReal,rsGEcomision.GEChastaReal)+1>
					<cfif LvarDias GT 1>
						<cfset LvarDias = "#LvarDias# días totales">
					<cfelse>
						<cfset LvarDias = "Un día total">
					</cfif>
					desde #dateFormat(rsGEcomision.GECdesdeReal,"DD/MM/YYYY")# hasta #dateFormat(rsGEcomision.GEChastaReal,"DD/MM/YYYY")#
					&nbsp;<strong>#LvarDias#</strong>
				</cfif>
			</td>
				
		</tr>
		<tr>
			<!---Empleado--->
			<td align="right">
				<strong>Empleado:&nbsp;</strong>
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.DEidentificacion)# - #trim(rsGEcomision.DEnombre	)#" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong>Tipo:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECtipo EQ 1>Nacional<cfelse>Exterior</cfif>
				<cfif rsGEcomision.GECautomovil EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled">Automóvil
				</cfif>
				<cfif rsGEcomision.GEChotel EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled">Hotel
				</cfif>
				<cfif rsGEcomision.GECavion EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled">Avión
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="10" style="border-top:solid 1px ##CCCCCC; font-size:1px;" >&nbsp;</td>
		</tr>
	</cfif>
		<tr>
		<td colspan="6">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<!---Número de la Liquidación --->
							<td valign="top" align="right" nowrap="nowrap"><strong>Núm. Liquidación:&nbsp;</strong>					
							</td>
							<td valign="top">						
								<cfif modo NEQ 'ALTA'>
									<input type="text" name="GELnumero" value="#rsForm.GELnumero#" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
									<input type="hidden" name="Mcodigo" value="#rsForm.Mcodigo#">
									<input type="hidden" name="CFid" value="#rsForm.CFid#">
								<cfelse>
									<input type="text" value="-- Nueva Liquidación --" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
								</cfif>					
							<!---Fecha Liquidación--->					
								<strong>Fecha:&nbsp;</strong>					
								<cfif modo NEQ 'ALTA'>
									<strong>#LSDateFormat(rsForm.GELfecha,"DD/MM/YYYY")#</strong>
								<cfelse>
									&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
								</cfif>					
							</td>
						</tr>
						<tr>
							<!---Descripción Liquidación --->
							<td valign="top" align="right" nowrap="nowrap">
									<strong>Descripción:&nbsp;</strong>		
							</td>
							<td>		    
									<input type="text"
									  tabindex="1" 
									  maxlength="40" 
									  size="60" 
									  id="GELdescripcion" 
									  readonly tabindex="-1" style="border:none"
									  value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GELdescripcion)#</cfif>">
							</td>
						</tr>
					<cfif NOT LvarSAporComision>
						<tr>				
							<!---Centro Funcional --->					
							<td align="right">
								<strong>Centro&nbsp;Funcional:&nbsp;</strong>					
							</td>
							<td colspan="1">
								<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
									<input type="text" name="CFuncional" value="#trim(rsAnticipo.CFcodigo)# - #trim(rsAnticipo.CFdescripcion)# (Oficina: #trim(rsAnticipo.Oficodigo)#)" disabled="disabled" size="55"/>
								<cfelseif modo neq 'ALTA'>
									<cfquery name="rsCF" datasource="#session.dsn#">
										select CFcodigo,CFdescripcion from CFuncional where CFid=#rsForm.CFid#
									</cfquery>
									<input name="CFunc" type="text" readonly tabindex="-1" style="border:none" value="#trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#" size="55" />
								<cfelse>
									<cf_cboCFid tabindex="1">
								</cfif>
							</td>
						</tr>
						<tr>
							<!---Empleado--->
							<td align="right">
								<strong>Empleado:&nbsp;</strong>
							</td>
							<td valign="top" nowrap="nowrap">
								<input type="text"
								  tabindex="1" 
								  maxlength="40" 
								  size="60" 
								  id="GELdescripcion" 
								  readonly tabindex="-1" style="border:none"
								  value="#rsForm.Empleado#">
								
								<input type="hidden" name="DEid" id="DEid" value="#rsForm.DEid#" />
							</td>
						</cfif>
						</tr>	
						<tr>
							<!--- Moneda Local --->
							<td valign="top" align="right">
								<strong>Moneda:&nbsp;</strong>
							</td>
							<td valign="top">
								<input type="text"
								  tabindex="1" 
								  maxlength="40" 
								  size="60" 
								  id="GELdescripcion" 
								  readonly tabindex="-1" style="border:none"
								  value="#rsForm.Moneda#">
							</td>
						</tr>
						<tr>
							<!--- Tipo Cambio --->
							<td valign="top" align="right">
								<strong>Tipo de Cambio:&nbsp;</strong>
							</td>
							<td valign="top">
								<input type="text"
								  tabindex="1" 
								  maxlength="40" 
								  size="60" 
								  id="GELdescripcion" 
								  readonly tabindex="-1" style="border:none"
								  value="#NumberFormat(rsForm.GELtipoCambio,"0.0000")#">
								
							</td>				
						</tr>
						<cfif  modo NEQ 'ALTA' AND rsForm.GELdesde NEQ "">
							<cfset LvarGELdesde	= rsForm.GELdesde>
							<cfset LvarGELhasta	= rsForm.GELhasta>
							<cfset LvarDias = datediff("d",LvarGELdesde,LvarGELhasta)+1>
						<cfelseif LvarSAporComision>
							<cfif rsGEcomision.GECdesdeReal EQ "">
								<cfset LvarGELdesde	= rsGEcomision.GECdesdePlan>
								<cfset LvarGELhasta	= rsGEcomision.GEChastaPlan>
							<cfelse>
								<cfset LvarGELdesde	= rsGEcomision.GECdesdeReal>
								<cfset LvarGELhasta	= rsGEcomision.GEChastaReal>
							</cfif>
							<cfset LvarDias = datediff("d",LvarGELdesde,LvarGELhasta)+1>
						<cfelse>
							<cfset LvarGELdesde	= now()>
							<cfset LvarGELhasta	= now()>
							<cfset LvarDias = 1>
						</cfif>
						<cfif LvarGELdesde EQ "">
							<cfset LvarDias = "">
						<cfelse>
							<cfif LvarDias GT 1>
								<cfset LvarDias = "#LvarDias# días">
							<cfelse>
								<cfset LvarDias = "#LvarDias# día">
							</cfif>
							<cfset LvarGELdesde	= DateFormat(LvarGELdesde,'DD/MM/YYYY') >
							<cfset LvarGELhasta	= DateFormat(LvarGELhasta,'DD/MM/YYYY') >
						</cfif>
						<tr>
							<!---Fechas--->
							<td align="right"><strong>Fechas Reales:&nbsp;</strong></td>
							<td colspan="10" nowrap="nowrap">
								<table border="0">
									<tr>
										<td align="left">Desde:</td>
										<td>#LvarGELdesde#</td> 
										<td align="right">&nbsp;Hasta:</td>
										<td>#LvarGELhasta#</td>	
										<td align="left"><strong>#LvarDias#</strong></td>
									</tr>
								</table>
							</td>
						</tr>						
						<tr>
							<td valign="middle"align="right" nowrap="nowrap">
								<strong>Forma de Pago:&nbsp; </strong>
							</td>
							<td valign="middle" align="left" nowrap="nowrap">
</cfoutput>
									<select name="FormaPago" id="FormaPago">
									<cfif rsForm.GELtipoPago EQ "TES">
										<optgroup label="Por Tesorería">
										<option value="0" <cfif modo EQ 'CAMBIO'and rsForm.CCHid EQ 0> selected</cfif>>Con Cheque o TEF</option>
									</cfif>
											                     
									</select>					                             
									
<cfoutput>
									<cfif modo eq 'CAMBIO'>
										<input type="hidden" name="CCHid" value="#rsForm.CCHid#" />
									</cfif>
								
							</td>				
						</tr>
						<tr>
						<cfif NOT LvarSAporComision>
							<td align="right" valign="top" nowrap>
								<strong>Vi&aacute;tico:&nbsp;</strong>
							</td>
							<td>
								<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1"    disabled="disabled"  <cfif modo NEQ "ALTA" and #rsForm.GEAviatico# EQ 1>checked="checked"  </cfif>  value="1"  />
							<cfif isdefined ("rsForm.GEAviatico") and rsForm.GEAviatico EQ 1>
								<img src="../../imagenes/find.small.png" style="cursor:pointer" onclick="MostrarViaticos(#form.GELid#);" />
							</cfif>
							&nbsp;&nbsp;&nbsp;
						<cfelse>
							<td></td>
							<td>
						</cfif>
								<strong>Tipo:&nbsp;</strong>
								<cfif #rsForm.GEAtipoviatico# EQ 2>Exterior<cfelse>Nacional</cfif>
							</td>
						</tr>
					</table>
					</td>
					<td valign="top">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
					<cfif modo NEQ "ALTA">
						<!--- Detalle de Liquidación --->
						<cfset LvarResult 		= createobject("component","sif.tesoreria.Componentes.TESgastosEmpleado").sbImprimirResultadoLiquidacion(rsForm)>
						<cfset LvarTotal 		= LvarResult.Total>
						<cfset LvarDevoluciones = LvarResult.Devoluciones>
						<cfset rsTotalReal 		= LvarResult.rsViaticos>
					</cfif>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>
				
	<cfif rsForm.GELmsgRechazo neq ''>
		<tr>
			<td valign="top" align="right"><div align="right"><strong>Motivo de Rechazo:</strong></div></td>
			<td valign="top"><font color="FF0000">#rsForm.GELmsgRechazo#</font></td>
			<td valign="top" align="right" nowrap>&nbsp;</td>
			<td valign="top">&nbsp;</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="10">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts" /> 
				
                <cfparam name="LvarInclude" default="">
                <cfset LvarInclude = "Cancelar,irLista">
                <cfparam name="LvarIncludeValues" default="">
                <cfset LvarIncludeValues = "Cancelar,Lista Liquidaciones">
                <cf_botones modo='#modo#' tabindex="1" 
                include="#LvarInclude#" 
                includevalues="#LvarIncludeValues#"
                exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
                >     
			</td>
		</tr>
	</table>
  </form>
 </cfoutput>
<!---TAP--->
<cf_templatecss>
	<script language="JavaScript" type="text/JavaScript">
		function MM_reloadPage(init) 
		{  
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		function validar(formulario)	
		{
			var error_input;
			var error_msg = '';
			
			if (formulario.FormaPago.value == "") {
				error_msg += "\n - Debe seleccionar una forma de Pago.";
				error_input = formulario.FormaPago;
				}				
						
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				error_input.focus();
				return false;
			}
			return true;
		}
		
		function MostrarViaticos(GELid) {
			_VControl = false;
			_lvar_width = 1200;
			_lvar_height = 600;
			_lvar_left = 100;
			_lvar_top = 100;
			//_lvar_num = GEAnumero;
			_lvar_liq = GELid;
			_lvar_ant = -1;
			_lvar_via = 1;
			
			if(_VpopUpWin) {
				if(!_VpopUpWin.closed) _VpopUpWin.close();
			}
			_VpopUpWin = open('/cfmx/sif/tesoreria/GestionEmpleados/DetalleAnticipo.cfm?GELid='+_lvar_liq+'&GEAviatico='+_lvar_via+'&GEAid='+_lvar_ant+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');
		
		}	
			
	</script>
			<cfif not isdefined("form.tab") and isdefined("url.tab") >
               <cfset form.tab = url.tab >
			</cfif>
			<cfif not ( isdefined("form.tab") and ListContains('1,2,3,5', form.tab) )>
               <cfset form.tab = 1 >
    		</cfif>
			<cf_tabs width="99%">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DatosGenerales"
				Default="Anticipos"
				returnvariable="X"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Cuentas"
					Default="Gastos Empleado"
					returnvariable="X"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Depositos"
					Default="Depositos"
					returnvariable="X"/>
					<cf_tab text="Anticipos" selected="#form.tab eq 1#">
						<cfinclude template="TabT1_Anticipos_Aprobar.cfm">	
					</cf_tab>
					
					<cf_tab text="Documentos de Gastos" selected="#form.tab eq 2#">
						<cfinclude template="TabT2_Gastos.cfm">
					</cf_tab>
				
					<cf_tab text="Dep&oacute;sitos Bancarios" selected="#form.tab eq 3#">
						<cfinclude template="TabT3_Depositos.cfm">
					</cf_tab>
					<cf_tab text="Dep&oacute;sitos en Efectivo" selected="#form.tab eq 5#">
						<cfinclude template="TabT5_DepositosE.cfm">
					</cf_tab>
				
			</cf_tabs>
		<cf_web_portlet_end>
        </td>
      </tr>
    </table>
	
<script language="javascript">	
		function funcCancelar()
		{
			var vReason = prompt('¿Desea CANCELAR la Liquidacion Num. <cfoutput>#rsForm.GELnumero#</cfoutput>?, Debe digitar una razon de rechazo!','');
			if (vReason != null )
			{
				if(vReason != '')
				{
				document.form1.msgRechazo.value = vReason;
				return true;
				}
				else
				{
				alert('Debe digitar una razon de rechazo!');
				return false;
				}
			}
			else
			{
			return false;
			}
			
		}
</script>
