<cfinclude template="../../Utiles/sifConcat.cfm">
<cfset LvarTipoDocumento = 8>
<form action="TransaccionCustodiaP_sql.cfm" name="form1" method="post" >
<cfoutput>
<cfif isdefined ('form.tipo')>
	<input name="tipo" type="hidden" value="#form.tipo#" />
</cfif> 
</cfoutput>
<cfif isdefined('url.GELid') and len(trim(url.GELid)) gt 0>
	<cfset form.id=#url.GELid#>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('form.GELid') and  len(trim(form.GELid)) gt 0>
	<cfset form.id=#form.GELid#>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined('url.GEAid') and not isdefined ('form.GEAid')>
	<cfset form.GEAid=#url.GEAid#>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('url.tipo') and not isdefined ('form.tipo')>
	<cfset form.tipo=#url.tipo#>
	<cfoutput>
	<input name="tipo" type="hidden" value="#form.tipo#" />
	<cfset modo = 'CAMBIO'>
	</cfoutput>
</cfif>

<cfif isdefined('form.tipo') and #form.tipo# neq 'ANTICIPO'>
	<cfset GELid=#id#>
	<cfset modo = 'CAMBIO'>
	<cfset LvarTipo = "GASTOS">
<cfelse>
	<cfset GEAid=#id#>
	<cfset modo = 'CAMBIO'>
	<cfset LvarTipo = "ANTICIPO">
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select m.Mcodigo, m.Miso4217
	  from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfif isdefined('id')>
	<cfset llave=#id#>
	<cfset modo = 'CAMBIO'>

	<cfif LvarTipo EQ "GASTOS">
		<cfquery datasource="#session.dsn#" name="encaLiqui">
			select 	
				ant.GELid,
				ant.CFid,
				ant.GELnumero as numero,
				ant.GELfecha as fecha,
				ant.GELdescripcion as descripcion,
				case 
					when ant.CCHid is null then 'TES'
					when (select CCHtipo from CCHica where CCHid = ant.CCHid) = 2 then 'TES'
					else 'CCH'
				end as GELtipoPago,
				
				(
					select  min(us.Usulogin)	
					from STransaccionesProceso a
						inner join Usuario us
							on a.BMUsucodigo=us.Usucodigo
					where a.CCHTrelacionada= #id#
					and a.CCHTestado='POR CONFIRMAR'
				) as usuario,
						
			
				( select min(rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion)
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select min(Em.DEnombre #_Cat# ' ' #_Cat# Em.DEapellido1 #_Cat# ' ' #_Cat# Em.DEapellido2)
					from DatosEmpleado Em,TESbeneficiario te
					where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
				) as Empleado,	
						
				(select min(Ca.CCHcodigo)
					from CCHica Ca
					where ant.CCHid=Ca.CCHid  
				) as CCHcodigo,		
				
				(select min(CP.CCHTtipo)
					from CCHTransaccionesCProceso CP
					where ant.GELid=CP.CCHTCrelacionada
					and ant.CCHTid=CP.CCHTid  
				) as CCHTtipo,	
				
				mo.Mnombre as Moneda, mo.Mnombre, mo.Miso4217,
				coalesce(ant.GELtotalGastos,0) as GELtotalGastos,
				ant.GELtipoCambio as Cambio,

				ant.GELreembolso, GELtotalDocumentos, GELtotalRetenciones, GELtotalTCE, 
				coalesce(ant.GELtotalAnticipos,0) as GELtotalAnticipos,
				coalesce(ant.GELtotalDepositos,0) as GELtotalDepositos,
				coalesce(ant.GELtotalDepositosEfectivo,0) as GELtotalDepositosEfectivo,
				coalesce(ant.GELtotalDevoluciones,0) as GELtotalDevoluciones,
				ant.GELdescripcion,ant.GELmsgRechazo, ant.TESid		,
				(ant.GELtotalDepositos + ant.GELtotalDepositosEfectivo + ant.GELtotalDevoluciones ) as MiDevolucion,
				(ant.GELtotalGastos - ant.GELtotalRetenciones - ant.GELtotalAnticipos - ant.GELtotalTCE 
					+ (ant.GELtotalDepositos + ant.GELtotalDepositosEfectivo + ant.GELtotalDevoluciones )
					- ant.GELreembolso) as MiTotal
			from GEliquidacion ant 				
				left join Monedas mo
					on mo.Mcodigo = ant.Mcodigo
			where GELid = #id#
		</cfquery>

		<cfset neto=#encaLiqui.GELtotalAnticipos#-(#encaLiqui.GELtotalGastos#+#encaLiqui.GELtotalDevoluciones#)>
	<cfelseif LvarTipo EQ "ANTICIPO">
		<cfquery datasource="#session.dsn#" name="encaLiqui">
			select 
				ant.CFid,
				ant.GEAnumero as numero,
				ant.GEAfechaPagar as fecha,
				ant.GEAdescripcion as descripcion,
				ant.GEAtotalOri as anticipo,
				b.GECdescripcion,
				c.GEADmonto,
	
				(
					select  min(us.Usulogin)	
					from STransaccionesProceso a
						inner join Usuario us
							on a.BMUsucodigo=us.Usucodigo
					where a.CCHTrelacionada= <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
					and a.CCHTestado='POR CONFIRMAR'
				) as usuario,
				
				( select min(rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion)
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select min(Em.DEnombre #_Cat# ' ' #_Cat# Em.DEapellido1 #_Cat# ' ' #_Cat# Em.DEapellido2)
					from DatosEmpleado Em,TESbeneficiario te
					where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
				) as Empleado,	
						
				(select min(Ca.CCHcodigo)
					from CCHica Ca
					where ant.CCHid=Ca.CCHid  
				) as CCHcodigo,		
				
				(select min(g.GETdescripcion)
					from GEtipoGasto g
					where b.GETid=g.GETid
				)as TipoGasto,
				
				(select min(CP.CCHTtipo)
					from CCHTransaccionesCProceso CP
					where ant.GEAid=CP.CCHTCrelacionada  
				) as CCHTtipo,			
						
				(select min(Mo.Mnombre)
					from Monedas Mo
					where ant.Mcodigo=Mo.Mcodigo
				)as Moneda,		
				ant.GEAmanual as Cambio,
									
				ant.GEAdescripcion	
			from GEanticipo ant 		
				inner join GEanticipoDet c
				on c.GEAid=ant.GEAid		
				inner join GEconceptoGasto b
				on  b.GECid=c.GECid	
			where ant.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
		</cfquery>
		<cfquery name="detAnt" datasource="#session.dsn#">
			select a.GECid ,b.GECdescripcion, c.GETdescripcion,mo.Miso4217,a.GEADmonto,a.GEADmontoviatico
			  from GEanticipoDet a
				inner join GEconceptoGasto b
					on a.GECid =b.GECid
				inner join GEtipoGasto c
					on c.GETid=b.GETid
				inner join Monedas mo
					on mo.Mcodigo = a.McodigoPlantilla
			where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
		</cfquery>
	</cfif>
</cfif>

<!---Total Anticipos --->
<cfquery name="totalAntic" datasource="#session.dsn#">
	select coalesce(sum(GELAtotal),0) as totalAnticipos 
	from GEliquidacionAnts 
	where GELid=1
</cfquery>

<cfoutput>
<script language="javascript" type="text/javascript">
	function funcImprime(){
		var PARAM  = "Recibo_Dinero.cfm?id=#id#"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
		return false;
		}
		
	function funcRechazar(){
		<cfif isdefined ("encaLiqui.GELid")>	
			var vReason = prompt('¿Desea RECHAZAR la Transacción <cfoutput>#encaLiqui.numero#</cfoutput>?, Debe digitar una razón de rechazo!','');
			if (vReason && vReason != ''){
				document.form1.CCHTCRechazo.value = vReason;
				return true;
			}
			if (vReason=='')
				alert('Debe digitar una razón de rechazo!');
			return false;
		</cfif>
		}
		
</script>	
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
	<input name="id" type="hidden" <cfif isdefined ('form.id')>value="#form.id#"</cfif> />
	<input type="hidden" name="CCHTCRechazo" value="" />
		<tr>
			<td valign="top" align="right" nowrap="nowrap"><strong><cf_translate key = LB_NumTransaccion xmlfile = "TransaccionCustodiaP_form.xml">N&uacute;m. Transacci&oacute;n</cf_translate>:</strong></td>
			
			<td valign="top">#encaLiqui.numero#</td>						
			<td align="right" valign="top" nowrap><strong><cf_translate key = LB_FechaTransaccion xmlfile = "TransaccionCustodiaP_form.xml">Fecha Transacci&oacute;n</cf_translate>:</strong></td>
			<td valign="top">#LSDateFormat(encaLiqui.fecha,"DD/MM/YYYY")#</td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key = LB_CentroFuncional xmlfile = "TransaccionCustodiaP_form.xml">Centro&nbsp;Funcional</cf_translate>:</strong></td>
			<td colspan="1">#encaLiqui.CentroFuncional#</td>
		</tr>								
		<tr>
			<td valign="top" align="right"></td>
			<td valign="top"></td>
			<td rowspan="4" valign="top" align="right" nowrap>
				<p><strong><cf_translate key = LB_Descripcion xmlfile = "TransaccionCustodiaP_form.xml">Descripci&oacute;n</cf_translate>:</strong></p></td>
			<td rowspan="4" valign="top" align="left">
				<textarea name="GELdescripcion" onkeypress="return false;" cols="50" rows="4" MAXLENGTH=20>#encaLiqui.descripcion#</textarea>
			</td>
   		</tr>
		<tr>
			<td align="right" nowrap="nowrap"> <strong><cf_translate key = LB_EmpleadoLiquidante xmlfile = "TransaccionCustodiaP_form.xml">Empleado Liquidante</cf_translate>:</strong></td>
			<td valign="top" nowrap="nowrap"><cfif #id# NEQ "">#encaLiqui.Empleado#</cfif>	</td>
		</tr>		
		<tr>
			<td valign="top" align="right"><strong> <cf_translate key = LB_Moneda xmlfile = "TransaccionCustodiaP_form.xml">Moneda</cf_translate>:</strong></td>
			<td valign="top">#encaLiqui.Moneda#</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong><cf_translate key = LB_TipoCambio xmlfile = "TransaccionCustodiaP_form.xml">Tipo de Cambio</cf_translate>:</strong></td>
			<td valign="top">#encaLiqui.Cambio#</td>
		</tr>
		<tr>
		  <td valign="top" align="right"><div align="right"><strong><cf_translate key = LB_Caja xmlfile = "TransaccionCustodiaP_form.xml">Caja</cf_translate>:</strong></div></td>
		  <td valign="top">#encaLiqui.CCHcodigo#</font></td>
		  <td width="1" align="right" valign="top" nowrap>&nbsp;</td>
		  <td width="1" valign="top">&nbsp;</td>
		</tr>
		<tr>
		  <td valign="top" align="right"><div align="right"><strong><cf_translate key = LB_TipoTransaccion xmlfile = "TransaccionCustodiaP_form.xml">Tipo de Transacci&oacute;n</cf_translate>: </strong></div></td>
		  <td valign="top">#encaLiqui.CCHTtipo#</font></td>
		  <td valign="top" align="right" nowrap><strong><cf_translate key = LB_AutorizadoPor xmlfile = "TransaccionCustodiaP_form.xml">Autorizado por</cf_translate>:</strong></td>
		  <td valign="top">#encaLiqui.usuario#</font></td>
		</tr>
	<cfif LvarTipo EQ "ANTICIPO">
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" align="right">&nbsp;</td>
		  	<td valign="top">&nbsp;</td>
			<td valign="top" align="center" nowrap colspan="2">
				<font color='##0033FF'><strong><cf_translate key = LB_TOTALANTICIPOPAGAR xmlfile = "TransaccionCustodiaP_form.xml">TOTAL ANTICIPO A PAGAR: #NumberFormat(encaLiqui.anticipo,"0.00")# #encaLiqui.Moneda#</cf_translate></strong></font>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td valign="top" align="right">&nbsp;</td>
		  	<td valign="top">&nbsp;</td>
			<td valign="top" colspan="2">
				<table>
				<!--- Detalle de Liquidación --->
				<cfset LvarResult		= createobject("component","sif.tesoreria.Componentes.TESgastosEmpleado").sbImprimirResultadoLiquidacion(encaLiqui, true)>
				<cfset LvarTotal 		= LvarResult.Total>
				<cfset LvarDevoluciones = LvarResult.Devoluciones>
				<cfset rsTotalReal 		= LvarResult.rsViaticos>
				</table>
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="4" class="formButtons" align="center">
			<cfif  isdefined ('form.tipo') and form.tipo eq 'GASTOS' and isdefined('encaliqui.GELtotalGastos') and #encaliqui.GELtotalGastos# neq 0 or isdefined ('form.GELid') and isdefined('encaliqui.GELtotalGastos') and #encaliqui.GELtotalGastos# neq 0>
				<cfset btnNameArriba 	= "IrLista">
				<cfset btnValuesArriba	= "Lista Liquidaciones">
				<cf_botones modo='Cambio' tabindex="1" 
					include="#btnNameArriba#,Imprime" 
					includevalues="#btnValuesArriba#,Imprime"
					exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
					
			<cfelseif LvarTipo EQ "GASTOS">
				<cfset btnNameArriba 	= "IrLista">
				<cfset btnValuesArriba	= "Lista Gastos">
				<cf_botones modo='Cambio' tabindex="1" 
					include="#btnNameArriba#,Imprime" 
					includevalues="#btnValuesArriba#,Imprime"
					exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
			<cfelse>
				<cfset btnNameArriba 	= "IrLista">
				<cfset btnValuesArriba	= "Lista Liquidaciones">
				
				<cf_botones modo='Cambio' tabindex="1" 
					include="#btnNameArriba#" 
					includevalues="#btnValuesArriba#"
					exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
			</cfif>
				
			<cfif  isdefined('encaLiqui.GELtotalAnticipos') and #encaLiqui.GELtotalAnticipos# neq 0  and isdefined('encaLiqui.GELtotalGastos') and #encaLiqui.GELtotalGastos# neq 0 and #encaLiqui.GELtotalGastos#  lt #encaLiqui.GELtotalAnticipos# or isdefined ('form.tipo') and #form.tipo# eq 'ANTICIPO'>
				<cfinclude template="CCHbtn_erdoc.cfm">  
			</cfif>	
			</td>	
		</tr>
		<tr>
			<td colspan="4" class="formButtons" align="center">
				<cfif isdefined ("encaLiqui.GELid")>	
                    <cf_botones values="Aplicar,Rechazar" name="Aplicar,Rechazar" tabindex="1">
                <cfelse>
                    <cf_botones values="Aplicar" name="Aplicar" tabindex="1">
                </cfif>
			</td>
		</tr>
	</table>
  </form>
</cfoutput>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anticipos" Default="Anticipos" returnvariable="LB_Anticipos" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DocumentosGasto" Default="Documentos de Gasto" returnvariable="LB_Gastos" xmlfile = "TransaccionCustodiaP_form.xml"/>    
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Devoluciones" Default="Devoluciones" returnvariable="LB_Depositos" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DepositosBancarios" Default="Dep&oacute;sitos Bancarios" returnvariable="LB_DepositosBancarios" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DepositosEfectivo" Default="Dep&oacute;sitos en Efectivo" returnvariable="LB_DepositosEfectivo" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoGasto" Default="Tipo Gasto" returnvariable="LB_TipoGasto" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto" returnvariable="LB_Concepto" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoSolicitado" Default="MontoSolicitado" returnvariable="LB_MontoSolicitado" xmlfile = "TransaccionCustodiaP_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto" xmlfile = "TransaccionCustodiaP_form.xml"/>

<!---TabTi--->
<cfif LvarTipo EQ "GASTOS">
	<cfif not isdefined("form.tab") and isdefined("url.tab") >
		<cfset form.tab = url.tab >
	</cfif>
	<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
		<cfset form.tab = 1 >
	</cfif>


	<cf_tabs width="100%">
		<cf_tab text="#LB_Anticipos#" selected="#form.tab eq 1#">
			<cfinclude template="TabT1_Anticipos.cfm">
		</cf_tab>
		<cf_tab text="#LB_Gastos#" selected="#form.tab eq 2#">
			<cfinclude template="TabT2_Gastos_Custodia.cfm">
		</cf_tab>
		<cfif encaLiqui.GELtipoPago EQ 'TES'>
			<cfset form.GELid = encaLiqui.GELid>
			<cf_tab text="#LB_DepositosBancarios#" selected="#form.tab eq 3#">
				<cfinclude template="TabT3_Depositos.cfm">
			</cf_tab>
			<cf_tab text="#LB_DepositosEfectivo#" selected="#form.tab eq 5#">
				<cfinclude template="TabT5_DepositosE.cfm">
			</cf_tab>
		<cfelse>		
			<cf_tab text="#LB_Depositos#" selected="#form.tab eq 4#">
				<cfinclude template="TabT4_Devoluciones.cfm">
			</cf_tab>
		</cfif>
	</cf_tabs>
<cfelse>
	<table align="center"><tr><td>
		
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
		query="#detAnt#"
		desplegar="GETdescripcion,GECdescripcion,Miso4217,GEADmonto,GEADmontoviatico"
		etiquetas="#LB_TipoGasto#,#LB_Concepto#,#LB_Moneda#,#LB_MontoSolicitado#,#LB_Monto#"
		formatos="S,S,S,M,M"
		align="left,left,center,right,right,"
		showEmptyListMsg="yes"
		maxRows="0"
		formName="SolicAnticipos"
		PageIndex="21"
		form_method="post"
		showLink="no"
	/>
	</td></tr></table>
</cfif>
<cf_web_portlet_end>

	
	

