<cf_templatecss>

<cf_htmlReportsHeaders 
	irA="asientoAcumulacion-filtro.cfm"
	FileName="asientoAcumulacion.xls"
	method="url"
	title="Asiento de Acumulacion de Cesantia">

<cf_dbtemp name="tbl_trabajo" returnvariable="tbl_trabajo">
	<cf_dbtempcol name="CFid" 				type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="CFcodigo" 			type="varchar(10)" 		mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"		type="varchar(60)" 		mandatory="yes">
	<cf_dbtempcol name="cuenta_centrocosto"	type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="cuenta_provision"	type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="complemento"		type="varchar(100)"		mandatory="no">	
	<cf_dbtempcol name="cuenta_empleado"	type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="acumulado"			type="money"			mandatory="no">
	<cf_dbtempcol name="provision"			type="money"			mandatory="no">
	<cf_dbtempcol name="diferencia"			type="money"			mandatory="no">
</cf_dbtemp>

<!--- calcula fechas de la nomina --->
<cfquery name="rs_fecha_nomina" datasource="#session.DSN#">
	select RCdesde, RChasta
	from HRCalculoNomina
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into #tbl_trabajo#( CFid, CFcodigo, CFdescripcion, cuenta_centrocosto, cuenta_provision, complemento, cuenta_empleado, acumulado, provision, diferencia )
	select p.CFid,
		 cf.CFcodigo,
 		 cf.CFdescripcion,
		 cf.CFcuentagastoretaf as cuenta_centrocosto,
		 min(CFcuentac) as cuenta_provision,
		 min(DCcuentac) as complemento,
		(	select Cformato
			from CContables
			where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
							  from RHParametros 
							  where Ecodigo=#session.Ecodigo# 
							    and Pcodigo=870) ) as cuenta_empleado,
		 sum(a.RHCTmonto) as acumulado, 
		 sum(b.CCvalorpat) as provision, 
		 sum(b.CCvalorpat-a.RHCTmonto) as diferencia  

	from RHCesantiaTransacciones a, HCargasCalculo b, LineaTiempo lt, RHPlazas p, CFuncional cf, DCargas dc
	where b.RCNid=a.RCNid
	  and b.DClinea=a.DClinea
	  and b.DEid=a.DEid
	  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
	  and lt.DEid=a.DEid
	  
	  and lt.LTid = ( 	select max(LTid) 
	  					from LineaTiempo 
						where DEid = a.DEid 
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#rs_fecha_nomina.RCdesde#"> <= LThasta 
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#rs_fecha_nomina.RChasta#"> > LTdesde )
	  <!---and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta--->
	  
	  
	  and p.RHPid=lt.RHPid
	  and cf.CFid=p.CFid
	  and RHCTtipo=0  <!--- solo aporte mes --->
	  and dc.DClinea=b.DClinea
	
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	
	group by p.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFcuentagastoretaf
</cfquery>

<!--- aplicacion de la mascara a la cuenta de provision --->
<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
<cfquery name="rs_cuentas" datasource="#session.DSN#">
	select cuenta_provision, complemento
	from #tbl_trabajo#
</cfquery>
<cfset v_FormatoCuenta = '' >
<cfloop query="rs_cuentas">
	<cfset v_FormatoCuenta = mascara.AplicarMascara(rs_cuentas.cuenta_provision, rs_cuentas.Complemento, '?')>
	<cfset v_FormatoCuenta = mascara.AplicarMascara(v_FormatoCuenta, rs_cuentas.Complemento, '*')>
	<cfset v_FormatoCuenta = mascara.AplicarMascara(v_FormatoCuenta, rs_cuentas.Complemento, '!')>		
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set cuenta_provision = <cfqueryparam cfsqltype="cf_sql_varchar" value="#v_FormatoCuenta#">
		where cuenta_provision = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_cuentas.cuenta_provision#">
	</cfquery>
</cfloop>

<cfquery name="data" datasource="#session.DSN#">
	select a.CFid, 
		   a.CFcodigo, 
		   a.CFdescripcion, 
		   a.cuenta_centrocosto, 
		   ( select Cdescripcion
			 from CContables
			 where Cformato = a.cuenta_centrocosto
			 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as cuenta_centrocosto_desc,
		   a.cuenta_provision, 
		   ( select Cdescripcion
			 from CContables
			 where Cformato = a.cuenta_provision
			 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as cuenta_provision_desc,
		   a.cuenta_empleado, 
		   ( select Cdescripcion
			 from CContables
			 where Cformato = a.cuenta_empleado
			 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as cuenta_empleado_desc,
		   a.acumulado, 
		   a.provision, 
		   a.diferencia
	from #tbl_trabajo# a
	order by a.CFcodigo, a.cuenta_centrocosto
</cfquery>

<table width="80%" align="center" border="0" cellspacing="0" cellpadding="2">	
	<cfquery name="rs_relacion" datasource="#session.DSN#">
		select RCDescripcion, RCdesde, RChasta
		from HRCalculoNomina
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
	</cfquery>
	<!-----========================= ENCABEZADO ANTERIOR =========================
	<tr>
		<td colspan="5" align="center">
			<table width="100%" cellpadding="2">
				<tr><td align="center"><font style="font-size:14px; font-weight:bold;">Consulta de Asiento de Acumulaci&oacute;n de Cesant&iacute;a</font></td></tr>								
				<tr><td align="center"><font style="font-size:13px; font-weight:bold;">Relaci&oacute;n de C&aacute;lculo:&nbsp;</font><font style="font-size:12px;"><cfoutput>#rs_relacion.RCDescripcion#</cfoutput></font></td></tr>
				<tr><td align="center"><font style="font-size:13px; font-weight:bold;">Fecha Desde:&nbsp;</font><font style="font-size:12px;"><cfoutput>#LSDateFormat(rs_relacion.RCdesde, 'dd/mm/yyyy')#</cfoutput></font><font style="font-size:13px; font-weight:bold;">&nbsp;Hasta:&nbsp;</font><font style="font-size:12px;"><cfoutput>#LSDateFormat(rs_relacion.RChasta, 'dd/mm/yyyy')#</cfoutput></font></td></tr>
				
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
	------>
	<tr>
		<td colspan="6" align="center">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinvoke key="LB_ConsultaDeAsientoDeAcumulaciones" default="Consulta de Asiento de Acumulaci&oacute;n de Cesant&iacute;a" returnvariable="LB_ConsultaDeAsientoDeAcumulaciones" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_RelacionDeCalculo" default="Relaci&oacute;n de C&aacute;lculo" returnvariable="LB_RelacionDeCalculo" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_FechaDesde" default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
						<cfset filtro3=''>
						<cfif isdefined("url.DEid") and len(trim(url.DEid))>
							<cfquery name="rs_empleado" datasource="#session.DSN#">
								select DEidentificacion, DEnombre, DEapellido1, DEapellido2
								from DatosEmpleado
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
							</cfquery>
							<cfset filtro3='#LB_Empleado#: #rs_empleado.DEidentificacion# - #rs_empleado.DEapellido1# #rs_empleado.DEapellido2# #rs_empleado.DEnombre#'>
						</cfif>
						<cf_EncReporte
							Titulo="#LB_ConsultaDeAsientoDeAcumulaciones#"
							Color="##E3EDEF"
							filtro1="#LB_RelacionDeCalculo#: #rs_relacion.RCDescripcion#"
							filtro2="#LB_FechaDesde#: #LSDateFormat(rs_relacion.RCdesde, 'dd/mm/yyyy')#  #LB_Hasta#: #LSDateFormat(rs_relacion.RChasta, 'dd/mm/yyyy')#"
							filtro3="#filtro3#"
						>
					</td>
				</tr>
			</table>
		</td>
	</tr>	

	<tr>
		<td class="tituloListas" width="30%">Centro Funcional</td>
		<td class="tituloListas" width="30%">Cuenta Contable</td>
		<td class="tituloListas" width="30%">Descripci&oacute;n</td>
		<td class="tituloListas" align="right" width="20%">D&eacute;bito</td>
		<td width="1%" class="tituloListas">&nbsp;</td>		
		<td class="tituloListas" align="right" width="20%">Cr&eacute;dito</td>
	</tr>

	<cfif data.recordcount gt 0>
		<cfset total_debitos_general = 0 >
		<cfset total_creditos_general = 0 >
		<cfset total_creditos_ces = 0 >
		<cfset total_creditos_dif = 0 >
		<cfoutput query="data" group="cuenta_centrocosto">
			<cfset total_debitos = 0 >
			<cfset total_creditos = 0 >
			<cfoutput>
				<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td>#trim(data.CFcodigo)# - #data.CFdescripcion#</td>
					<td nowrap="nowrap">#data.cuenta_centrocosto#</td>
					<td nowrap="nowrap">#data.cuenta_centrocosto_desc#</td>
					<td align="right">#LSNumberFormat(data.provision, ',9.00')#</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td>&nbsp;</td>
					<td nowrap="nowrap">#data.cuenta_empleado#</td>
					<td nowrap="nowrap">#data.cuenta_empleado_desc#</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>				
					<td align="right">#LSNumberFormat(data.acumulado, ',9.00')#</td>
				</tr>
				<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td>&nbsp;</td>
					<td nowrap="nowrap">#data.cuenta_empleado#</td>
					<td nowrap="nowrap">#data.cuenta_empleado_desc#</td>
					<!---
					<td nowrap="nowrap">#data.cuenta_provision#</td>
					<td nowrap="nowrap">#data.cuenta_provision_desc#</td>
					--->
					<td>&nbsp;</td>
					<td>&nbsp;</td>				
					<td align="right">#LSNumberFormat(data.diferencia, ',9.00')#</td>
				</tr>
				<cfset total_debitos = total_debitos + data.provision>
				<cfset total_creditos = total_creditos + data.acumulado + data.diferencia>

				<cfset total_creditos_ces = total_creditos_ces + data.acumulado >
				<cfset total_creditos_dif = total_creditos_dif + data.diferencia >

			</cfoutput>
			<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td><strong><i>Total Centro Funcional #data.CFcodigo#</i></strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>				
				<td align="right" style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(total_debitos, ',9.00')#</i></strong></td>
				<td>&nbsp;</td>			
				<td align="right"  style="border-top: 1px solid black;"><strong><i>#LSNumberFormat(total_creditos, ',9.00')#</i></strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<cfset total_debitos_general = total_debitos_general + total_debitos >
			<cfset total_creditos_general = total_creditos_general + total_creditos >
		</cfoutput>

		<cfoutput>
		<tr class="listaPar">
			<td><strong><i>Total</i></strong></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="right" ><strong><i>#LSNumberFormat(total_debitos_general, ',9.00')#</i></strong></td>
			<td>&nbsp;</td>			
			<td align="right" ><strong><i>#LSNumberFormat(total_creditos_ces, ',9.00')#</i></strong></td>
			<td><i>(cesant&iacute;a)</i></td>
		</tr>

		<tr class="listaPar">
			<td></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="right" ></td>
			<td>&nbsp;</td>			
			<td align="right" style="border-bottom: 1px solid black;" nowrap="nowrap" ><strong><i>#LSNumberFormat(total_creditos_dif, ',9.00')#</i></strong></td>
			<td><i>(dif.)</i></td>			
		</tr>
		<tr class="listaPar">
			<td></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="right" ></td>
			<td>&nbsp;</td>			
			<td align="right" nowrap="nowrap" ><strong><i>#LSNumberFormat(total_creditos_dif+total_creditos_ces, ',9.00')#</i></strong></td>
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
