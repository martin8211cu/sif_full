<cf_templatecss>

<cf_htmlReportsHeaders 
	irA="asientoLiquidacion-filtro.cfm"
	FileName="asientoLiquidacion.xls"
	method="url"
	title="Asiento de Liquidacion de Cesantia">

	<!--- 1. tabla que tiene los empleados que fueron liquidados en el periodo mes --->
	<cf_dbtemp name="tbl_trabajo" returnvariable="tbl_trabajo">
		<cf_dbtempcol name="DEid" 					type="numeric" 		mandatory="yes">
		<cf_dbtempcol name="periodo" 				type="int" 			mandatory="yes">
		<cf_dbtempcol name="mes" 					type="int" 			mandatory="yes">
		<cf_dbtempcol name="DClinea" 				type="numeric"		mandatory="yes">
		<cf_dbtempcol name="CFid" 					type="numeric"		mandatory="yes">
		<cf_dbtempcol name="cuenta_bancos" 			type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="cuenta_bancos_desc" 	type="varchar(80)" 	mandatory="no">
		<cf_dbtempcol name="cuenta_empleado" 		type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="cuenta_empleado_desc"	type="varchar(80)" 	mandatory="no">
		<cf_dbtempcol name="cuenta_provision" 		type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="cuenta_provision_desc"	type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="complemento"			type="varchar(100)"	mandatory="no">
		<cf_dbtempcol name="monto_empleado"			type="money"		mandatory="no" >
		<cf_dbtempcol name="monto_bancos"			type="money"		mandatory="no" >
		<cf_dbtempcol name="monto_diferencia"		type="money"		mandatory="no" >		
	</cf_dbtemp>
	
	<cfset v_fecha = createdate(url.periodo, url.mes, 1) >

	<!--- 2. Inserta los empleados que fueron liquidados en el periodo mes indicados --->
	<cfquery datasource="#session.DSN#">
		insert into #tbl_trabajo#(DEid, periodo, mes, DClinea, monto_empleado, CFid)
		select DEid, RHCLBperiodo, RHCLBmes, DClinea, (RHCLBmontocesantia+RHCLBmontointeres), coalesce(( select max(CFid)
																										 from LineaTiempo lt, RHPlazas p
																										 where p.RHPid=lt.RHPid
																										  and lt.DEid = RHCesantiaLiqBitacora.DEid
																										  and ( <cfqueryparam cfsqltype="cf_sql_date" value="#v_fecha#"> between lt.LTdesde and lt.LThasta 
																											or  (select max(lt2.LThasta) from LineaTiempo lt2 where lt2.DEid=lt.DEid )  <= <cfqueryparam cfsqltype="cf_sql_date" value="#v_fecha#"> ) ), 0)
		from RHCesantiaLiqBitacora 
		where RHCLBperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		  and RHCLBmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		  
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>

	<!--- 3. Pone las cuentas requeridas --->
	<!--- 3.1 cuenta empleado --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set cuenta_empleado =	(  	select Cformato
		   						from CContables
		   						where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     					  from RHParametros 
						    					  where Ecodigo=#session.Ecodigo# 
							 					    and Pcodigo=870) ),
			cuenta_empleado_desc =	(  	select Cdescripcion
										from CContables
										where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
														  from RHParametros 
														  where Ecodigo=#session.Ecodigo# 
															and Pcodigo=870) )													
	</cfquery>		
	
	<!--- 3.2 cuenta bancos --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set cuenta_bancos =	(  	select Cformato
		   						from CContables
		   						where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     					  from RHParametros 
						    					  where Ecodigo=#session.Ecodigo# 
							 					    and Pcodigo=900) ),
			cuenta_bancos_desc =	(  	select Cdescripcion
										from CContables
										where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
														  from RHParametros 
														  where Ecodigo=#session.Ecodigo# 
															and Pcodigo=900) )													
	</cfquery>
	
	<!--- 3.4 cuenta de provision --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set cuenta_provision = ( select CFcuentac
								 from CFuncional
								 where CFid = #tbl_trabajo#.CFid ) 
	</cfquery>

	<!--- 3.5 objeto de gasto para cuenta de provision --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set complemento = ( select DCcuentac from DCargas where DClinea=#tbl_trabajo#.DClinea )
	</cfquery>
	<!--- 3.6 aplica la mascara a la cuenta de provision --->
	<!--- lo hace uno a uno para compatibilidad sybase,oracle,sqlserver--->
	<cfquery name="rs_cuentas" datasource="#session.DSN#">
		select cuenta_provision, complemento
		from #tbl_trabajo#
	</cfquery>
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<cfset v_FormatoCuenta = '' >
	<cfloop query="rs_cuentas">
		<cfset v_FormatoCuenta = mascara.AplicarMascara(rs_cuentas.cuenta_provision, rs_cuentas.Complemento)>
		<cfset v_FormatoCuenta = mascara.AplicarMascara(v_FormatoCuenta, rs_cuentas.Complemento, '*')>
		<cfset v_FormatoCuenta = mascara.AplicarMascara(v_FormatoCuenta, rs_cuentas.Complemento, '!')>		
		<cfquery datasource="#session.DSN#">
			update #tbl_trabajo#
			set cuenta_provision = <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_FormatoCuenta#">
			where cuenta_provision = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_cuentas.cuenta_provision#">
		</cfquery>
	</cfloop>
	
	<!--- trae las descripciones de las cuentas --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set cuenta_bancos_desc = (select Cdescripcion from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Cformato = #tbl_trabajo#.cuenta_bancos) ,
			cuenta_empleado_desc = (select Cdescripcion from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Cformato = #tbl_trabajo#.cuenta_empleado) ,
			cuenta_provision_desc = (select Cdescripcion from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Cformato = #tbl_trabajo#.cuenta_provision)
	</cfquery>
	
	<!--- ==================================== --->
	<!--- 2. CALCULO DE MONTOS 				   --->
	<!--- ==================================== --->
	<!--- Para cada empleado debe traer el monto de liquidacion de personal y 
		  el monto acumulado por concepro de cesantia  --->
	<cfquery name="rs_empleados" datasource="#session.DSN#">
		select DEid, monto_empleado
		from #tbl_trabajo#
	</cfquery>
	<cfset hay_liquidacion = false >
	<cfset v_montoliquidacion = 0 >	
	<cfloop query="rs_empleados">
		<!--- 2.1 Se fija si el empleado tiene fin de relacion laboral con la empresa --->	  
		<cfquery name="rs_liquidacion" datasource="#session.DSN#">
			select DLlinea, RHLPrenta as renta
			from RHLiquidacionPersonal
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
		</cfquery>	
		<cfif len(trim(rs_liquidacion.renta))>
			<cfset v_montoliquidacion = rs_liquidacion.renta >
		</cfif>
		<cfif len(trim(rs_liquidacion.DLlinea))>
			<!--- *** no se si hay que excluir la incidencia por cesantia que ya esta aqui, si hubiera liquidacion por fin de relacion --->
			<cfquery name="rs_ingresos" datasource="#session.DSN#">
				select sum(importe) as monto
				from RHLiqIngresos
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_liquidacion.DLlinea#">
			</cfquery>
			<cfif len(trim(rs_ingresos.monto))>
				<cfset v_montoliquidacion = v_montoliquidacion + rs_ingresos.monto >				
			</cfif>	
			<cfquery name="rs_cargas" datasource="#session.DSN#">
				select sum(importe) as monto
				from RHLiqCargas
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_liquidacion.DLlinea#">
			</cfquery>	
			<cfif len(trim(rs_cargas.monto))>
				<cfset v_montoliquidacion = v_montoliquidacion + rs_cargas.monto >
			</cfif>	
			<cfquery name="rs_deducciones" datasource="#session.DSN#">
				select sum(importe) as monto
				from RHLiqDeduccion
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_liquidacion.DLlinea#">
			</cfquery>
			<cfif len(trim(rs_deducciones.monto))>
				<cfset v_montoliquidacion = v_montoliquidacion + rs_deducciones.monto >
			</cfif>	
			
			<cfif v_montoliquidacion gt 0>
				<cfset hay_liquidacion = true >
			</cfif>
		</cfif>

		<cfif hay_liquidacion >
			<cfif v_montoliquidacion gt rs_empleados.monto_empleado >
				<cfquery datasource="#session.DSN#">
					update #tbl_trabajo#
					set monto_bancos = <cfqueryparam cfsqltype="cf_sql_money" value="#v_montoliquidacion#">,
					    monto_diferencia = <cfqueryparam cfsqltype="cf_sql_money" value="#v_montoliquidacion-rs_empleados.monto_empleado#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.DSN#">
					update #tbl_trabajo#
					set monto_bancos = <cfqueryparam cfsqltype="cf_sql_money" value="#v_montoliquidacion#">,
						monto_empleado = <cfqueryparam cfsqltype="cf_sql_money" value="#v_montoliquidacion#">,
						cuenta_provision = null,
						cuenta_provision_desc = null,
					    monto_diferencia = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
				</cfquery>			
			</cfif>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update #tbl_trabajo#
				set monto_bancos = <cfqueryparam cfsqltype="cf_sql_money" value="#rs_empleados.monto_empleado#">,
					cuenta_provision = null,
					cuenta_provision_desc = null,
					monto_diferencia = 0
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
			</cfquery>
		</cfif>
	</cfloop>

	<cfquery name="data" datasource="#session.DSN#">
		select 	cuenta_bancos, cuenta_bancos_desc, 
				cuenta_empleado, cuenta_empleado_desc, 
				cuenta_provision, cuenta_provision_desc, 
				sum(monto_empleado) as monto_empleado, 
				sum(monto_bancos) as monto_bancos, 
				sum(monto_diferencia) as monto_diferencia
		from #tbl_trabajo#
		group by cuenta_bancos, cuenta_bancos_desc,cuenta_empleado,cuenta_empleado_desc,cuenta_provision, cuenta_provision_desc  
		order by cuenta_empleado, cuenta_provision, cuenta_bancos
	</cfquery>


<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
<table width="80%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="5">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td>
					<cfinvoke key="LB_ConsultaDeAsientoDeLiquidacionDeCesantia" default="Consulta de Asiento de Liquidaci&oacute;n de Cesant&iacute;a" returnvariable="LB_ConsultaDeAsientoDeLiquidacionDeCesantia" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2=''>
					<cfif isdefined("url.DEid") and len(trim(url.DEid))>
						<cfquery name="rs_empleado" datasource="#session.DSN#">
							select DEidentificacion, DEnombre, DEapellido1, DEapellido2
							from DatosEmpleado
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
						</cfquery>
						<cfset filtro2='#LB_Empleado#: #rs_empleado.DEidentificacion# - #rs_empleado.DEapellido1# #rs_empleado.DEapellido2# #rs_empleado.DEnombre#'>
					</cfif>	
					<cf_EncReporte
						Titulo="#LB_ConsultaDeAsientoDeLiquidacionDeCesantia#"
						Color="##E3EDEF"
						filtro1="#LB_Periodo#: #url.periodo#  #LB_Mes#:#listgetat(lista_meses, url.mes)#"	
						filtro2="#filtro2#"								
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<!----
	<tr>
		<td colspan="5" align="center">
			<table width="100%" cellpadding="2">
				<tr><td align="center"><font style="font-size:14px; font-weight:bold;">Consulta de Asiento de Liquidaci&oacute;n de Cesant&iacute;a</font></td></tr>
				
				<tr>
					<td align="center"><font style="font-size:13px; font-weight:bold;">Per&iacute;odo:&nbsp;</font><font style="font-size:12px;"><cfoutput>#url.periodo#</cfoutput></font><font style="font-size:13px; font-weight:bold;">&nbsp;Mes:&nbsp;</font><font style="font-size:12px;"><cfoutput>#listgetat(lista_meses, url.mes)#</cfoutput></font></td>
				</tr>
				<cfif isdefined("url.DEid") and len(trim(url.DEid))>
					<cfquery name="rs_empleado" datasource="#session.DSN#">
						select DEidentificacion, DEnombre, DEapellido1, DEapellido2
						from DatosEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
					</cfquery>
						<tr><td align="center"><font style="font-size:13px; font-weight:bold;">Empleado:&nbsp;</font><font style="font-size:12px;"><cfoutput>#rs_empleado.DEidentificacion# - #rs_empleado.DEapellido1# #rs_empleado.DEapellido2# #rs_empleado.DEnombre#</cfoutput></font></td></tr>
				</cfif>
			</table>
		</td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	----->

	<tr>
		<td class="tituloListas" width="30%">Cuenta Contable</td>
		<td class="tituloListas" align="left" width="20%">Descripci&oacute;n</td>
		<td class="tituloListas" align="right" width="20%">D&eacute;bito</td>
		<td width="1%" class="tituloListas">&nbsp;</td>		
		<td class="tituloListas" align="right" width="20%">Cr&eacute;dito</td>
	</tr>

	<cfif data.recordcount gt 0>
		<cfset total_debitos = 0 >
		<cfset total_creditos = 0 >				
		<cfoutput query="data" group="cuenta_empleado" >
			<cfoutput group="cuenta_provision">
				<cfset subtotal_debitos = 0 >
				<cfset subtotal_creditos = 0 >				
				<cfoutput group="cuenta_bancos">
					<cfoutput>
						<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td nowrap="nowrap">#data.cuenta_empleado#</td>
							<td>#data.cuenta_empleado_desc#</td>
							<td align="right">#LSNumberFormat(data.monto_empleado, ',9.00')#</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
				
						<cfif data.monto_diferencia gt 0 >
							<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td nowrap="nowrap">#data.cuenta_provision#</td>
								<td>#data.cuenta_provision_desc#</td>				
								<td align="right">#LSNumberFormat(data.monto_diferencia, ',9.00')#</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<cfset subtotal_debitos = subtotal_debitos  + data.monto_diferencia >
							<cfset total_debitos = total_debitos  + data.monto_diferencia >
						</cfif>
				
						<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td nowrap="nowrap">#data.cuenta_bancos#</td>
							<td>#data.cuenta_bancos_desc#</td>							
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td align="right">#LSNumberFormat(data.monto_bancos, ',9.00')#</td>
						</tr>
						<cfset subtotal_debitos = subtotal_debitos  + data.monto_empleado >
						<cfset subtotal_creditos = subtotal_creditos +  data.monto_bancos >
						<cfset total_debitos = total_debitos  + data.monto_empleado >
						<cfset total_creditos = total_creditos +  data.monto_bancos >
					</cfoutput>	
				</cfoutput>
				
				<tr class="listaPar">
					<td style="padding-left:15px;"><i><strong>Total</strong></i></td>
					<td></td>
					<td align="right" style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(subtotal_debitos, ',9.00')#</i></strong></td>
					<td></td>
					<td align="right" style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(subtotal_creditos, ',9.00')#</i></strong></td>
				</tr>
				<tr><td>&nbsp;</td></tr>			
			</cfoutput>
		</cfoutput>
		<cfoutput>
		<tr class="listaPar">
			<td><strong><i>Total General</i></strong></td>
			<td>&nbsp;</td>
			<td align="right" style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(total_debitos, ',9.00')#</i></strong></td>
			<td>&nbsp;</td>			
			<td align="right"  style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(total_creditos, ',9.00')#</i></strong></td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="5" align="center">- No se encontraron registros -</td></tr>
	</cfif>	
	<tr><td>&nbsp;</td></tr>

</table>

<script>
function fnImgBack()
	{
		window.parent.location.href = '/cfmx/rh/nomina/consultas/cesantia/asientoAcumulacion-filtro.cfm';
	}
</script>