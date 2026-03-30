<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
		select 
				CCHid,
				CCHdescripcion,
				CCHcodigo
		from CCHica
		where Ecodigo=#session.Ecodigo#
		and CCHestado='ACTIVA'

</cfquery>
<cfset LvarTipoDocumento = 7>
<form action="LiquidacionAprobar_sql.cfm" name="form1" method="post" onsubmit="return validar(this);" id="form1">
<cfif isdefined('url.GELid') and not isdefined ('form.GELid')>
	<cfset form.GELid=#url.GELid#>
		<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('url.Mensaje')>
	<script lenguage="javascript">
		alert('No se puede aprobar la liquidaciÃ³n porque el pago al empleado es mayor que cero y quedan saldos en los anticipos');
	</script>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('form.GELid')>
   <cfset llave=#form.GELid#>
<cfset modo = 'CAMBIO'>
		<cfquery datasource="#session.dsn#" name="encaLiqui">
			select ant.CFid,ant.GELnumero,ant.GELfecha,ant.ts_rversion,ant.GELreembolso,

				( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion 
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2 
					from DatosEmpleado Em,TESbeneficiario te 
						where ant.TESBid=te.TESBid 
						and Em.DEid=te.DEid
				) as Empleado,	
				
				(select DEid 
					from TESbeneficiario te 
						where ant.TESBid=te.TESBid 
				) as DEid,
						
				(select Mo.Mnombre
					from Monedas Mo
					where ant.Mcodigo=Mo.Mcodigo
				)as Moneda,													
				ant.GELtotalGastos,
				ant.GELtipoCambio,
				ant.GELtotalAnticipos,
				ant.GELtotalDepositos,
				ant.GELtipoP,
				ant.GELtotalDevoluciones,
				ant.CCHid,
				ant.GELdescripcion,ant.GELmsgRechazo, ant.GELtotalGastos,ant.TESid,	
				ant.GEAviatico,
				ant.GEAtipoviatico		
			from GEliquidacion ant 				
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" >
	</cfquery>
</cfif>


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

<cfoutput>
<input type="hidden" name="msgRechazo" value="">
<input type="hidden" name="GELid" value="#llave#">
<cfif encaLiqui.GELtipoP eq 1>
	<input type="hidden" name="FormaPago" value="0" />
<cfelse>
	<input type="hidden" name="FormaPago" value="#encaLiqui.CCHid#" />
</cfif>
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
		<tr>
			<td valign="top" align="right" width="162" nowrap="nowrap"><strong>N&uacute;m. Liquidaci&oacute;n:&nbsp;</strong></td>
			<td width="224" valign="top">#encaLiqui.GELnumero#</td>						
			<td width="177" align="right" valign="top"><strong>Fecha Liquidaci&oacute;n:&nbsp;</strong></td>
			<td width="317" valign="top">#LSDateFormat(encaLiqui.GELfecha,"DD/MM/YYYY")#</td>
		</tr>
		<tr>
			<td align="right"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
			<td colspan="1">#encaLiqui.CentroFuncional#</td>
		</tr>								
		<tr>
		  <td valign="top" align="right"></td>
		  <td valign="top"></td>
		  <td rowspan="6" valign="top" align="right" nowrap>
		   
		    <p><strong>Descripci&oacute;n Liquidaci&oacute;n :</strong> </p>			</td>
		  <td rowspan="6" valign="top" align="left">
		    <textarea name="GELdescripcion" onkeypress="return false;" cols="50" rows="4" MAXLENGTH=20>#encaLiqui.GELdescripcion#
			</textarea>		    
		 </td>
   		</tr>
		<tr>
			<td align="right" nowrap="nowrap"> <strong>Empleado Liquidante:&nbsp;</strong></td>
			<td width="224" valign="top" nowrap="nowrap"><cfif #form.GELid# NEQ "">#encaLiqui.Empleado#</cfif>	</td>
			<input type="hidden" name="DEid" id="DEid" value="#encaLiqui.DEid#" />
		</tr>		
		<tr>
			<td valign="top" align="right"><strong>Moneda:&nbsp;</strong></td>
			<td valign="top">#encaLiqui.Moneda#</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>Tipo de Cambio:</strong></td>
			<td valign="top">#encaLiqui.GELtipoCambio#</td>
		</tr>
		<tr>
		  <td>
		  <td colspan="3">		  
		  </td>
		</tr>
				<tr>
		<cfif #encaLiqui.GELmsgRechazo# neq ''>
		  <td valign="top" align="right"><div align="right"><strong>Motivo de Rechazo:</strong></div></td>
		  <td valign="top"><font color="FF0000">#encaLiqui.GELmsgRechazo#</font></td>
		  <td valign="top" align="right" nowrap>&nbsp;</td>
		  <td valign="top">&nbsp;</td>
		 </cfif>
    	</tr>

		<tr>
		  <td valign="top" align="right" nowrap><strong>Total Anticipos:&nbsp;</strong></td>
		  <td valign="top" align="left">
	  
<!---Monto en Anticipos--->
			<cfif #encaLiqui.GELtotalAnticipos# LT 0>
				<span class="style3">ERROR: Monto es menor 0 </span>
				<cfdump var="#encaLiqui.GELtotalAnticipos# ">
			  <cfelseif #encaLiqui.GELtotalAnticipos#  GT 0>
				#NumberFormat(encaLiqui.GELtotalAnticipos ,"0.00")#
			<cfelse>
				<span class="style2">No hay anticipos Asociados</span>
			</cfif>			
			</td>
		
			<td valign="top" align="right" nowrap="nowrap"><strong>Forma Pago:</strong></td>
</cfoutput>
			<td valign="top" align="left"  nowrap="nowrap" colspan="6">
						<select name="FormaPago" id="FormaPago" disabled="disabled">
							<option  value="0" <cfif encaLiqui.GELtipoP eq 1>selected="selected"</cfif>>Tesoreria</option>
								<cfif rsCajaChica.RecordCount>
									<cfoutput query="rsCajaChica" group="CCHid">
										<option value="#rsCajaChica.CCHid#" <cfif rsCajaChica.CCHid  eq encaLiqui.CCHid> selected="selected"  </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>									
									</cfoutput>
								</cfif>   
						</select>		                    
			  </td>
<cfoutput>			  
    	</tr>
	
		<tr>
			<td valign="top" align="right" nowrap><strong>Total de Gastos :&nbsp;</strong></td>
			<td valign="top">
	<!---Monto en Doc Liquidantes--->
			<cfif encaLiqui.GELtotalGastos LT 0>
			  <span class="style3">	Monto en Facturas menor a 0</span>
			  <cfelseif encaLiqui.GELtotalGastos GT 0>
				#NumberFormat(encaLiqui.GELtotalGastos,"0.00")#
			<cfelse>
				<span class="style2">No hay Facturas</span>
			</cfif></td>
<!---   </tr>
		<tr>
--->		<cfif encaLiqui.GELtipoP EQ 1>	
			<td valign="top" align="right" nowrap><strong>Total Dep&oacute;sitos:&nbsp;</strong></td>
			<td valign="top">
	<!---Monto en depositos   ********CAMBIAR******* --->
		<cfset depositos=0>
			<cfif encaLiqui.GELtotalDepositos LT 0>
			  <span class="style3">	Monto en Depositos menor a 0	</span>
			 <cfelseif encaLiqui.GELtotalDepositos GT 0>
				#NumberFormat(encaLiqui.GELtotalDepositos,"0.00")#
			<cfelse>
				<span class="style2">No hay Depositos  </span>
			</cfif>			</td>
		<cfelse>
			<td valign="top" align="right" nowrap><strong>Total Devoluciones</strong></td>
			<td valign="top">
			<cfset devoluciones=0>
			<cfif encaLiqui.GELtotalDevoluciones LT 0>
			  <span class="style3">	Monto en Facturas menor a 0</span>
			 <cfelseif encaLiqui.GELtotalDevoluciones GT 0>
				#NumberFormat(encaLiqui.GELtotalDevoluciones,"0.00")#
			<cfelse>
				<span class="style2">No hay Devoluciones</span>
			</cfif>
			</td>
		</cfif>
    	</tr>
		<tr>
			<td valign="top" align="right" nowrap>
		   <!---Rembolso al Empleado --->
		    <strong>Pago  Empleado :</strong></td>
		    <td valign="top">
			
			<input type="text"
			name="GELreembolso" 
			id="GELreembolso"
			readonly="yes"
			value="#NumberFormat(encaLiqui.GELreembolso,",0.00")#"
			style="text-align:left; border:solid 0px ##CCCCCC;"
			tabindex="1">	
		<!---</tr>--->
		<cfif (isdefined ('sinAnticipos') and sinAnticipos.recordcount eq 0)  or not isdefined ('sinAnticipos') and  modo eq 'ALTA'><!---si no tiene anticipos asociado es decir es una liq directa--->
					<!---Si es Viatico--->
					<td align="right" valign="top" nowrap><strong>Vi&aacute;tico:&nbsp;</strong></td>
						<td>
							<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1"    disabled="disabled"  <cfif modo NEQ "ALTA" and #encaLiqui.GEAviatico# EQ 1>checked="checked"  </cfif>  value="1"  />
						</td>
				</tr>
				<tr>
	
					<td></td>	
					<cfif isdefined ("encaLiqui.GEAviatico") and encaLiqui.GEAviatico EQ 1>
						<td align="right">
							<input type="button" name="mostrarViaticos" id="mostrarViaticos" value="Mostrar Viaticos"  onclick="MostrarViaticos(#form.GELid#);" />
						</td>	
					<cfelse>
						<td></td>
					</cfif>
					
					<td align="right"><strong>Tipo:&nbsp;</strong></td>
					<td nowrap="nowrap" align="left">		
						<input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #encaLiqui.GEAtipoviatico# EQ 1> checked=" checked " </cfif>checked >
							<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Interior</label>
						 <input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #encaLiqui.GEAtipoviatico# EQ 2>  checked="checked"  </cfif> >
							<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Exterior</label>					
					</td>	
					
				</tr>
			<cfelse>
				<tr>	
			</cfif>
		
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		 artimestamp="#encaLiqui.ts_rversion#" returnvariable="ts"> </cfinvoke>
		<cfinclude template="TESbtn_Aprobarliq.cfm">        </td>
		</tr>
		<br />
		<br />
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
			 <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
               <cfset form.tab = 1 >
    		</cfif>
          <br />
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
				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Depositos"
				Default="Depositos"
				returnvariable="X"/>
						
				<cf_tab text="Anticipos" selected="#form.tab eq 1#">
					<cfinclude template="TAP_ANTICIPOS_APROBACION.cfm">	
				</cf_tab>
				
				<cf_tab text="Gastos" selected="#form.tab eq 2#">
					<cfinclude template="tap_liquidaciones.cfm">
				</cf_tab>
		<cfif encaLiqui.GELtipoP EQ 1>
				<cf_tab text="Dep&oacute;sitos" selected="#form.tab eq 3#">
					<cfinclude template="tap_Depositos.cfm">
				</cf_tab>
		<cfelse>		
				<cf_tab text="Devoluciones" selected="#form.tab eq 4#">
					<cfinclude template="tap_Devoluciones.cfm">
				</cf_tab>
		</cfif>
</cf_tabs>
		<cf_web_portlet_end>
        </td>
      </tr>
    </table>
	
<script language="javascript">	
		function funcRechazar()
		{
			var vReason = prompt('Â¿Desea RECHAZAR la Liquidacion Num. <cfoutput>#encaLiqui.GELnumero#</cfoutput>?, Debe digitar una razon de rechazo!','');
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


