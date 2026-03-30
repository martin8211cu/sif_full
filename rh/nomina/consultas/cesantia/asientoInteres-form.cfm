<cf_templatecss>

<cf_htmlReportsHeaders 
	irA="asientoAcumulacion-filtro.cfm"
	FileName="asientoAcumulacion.xls"
	method="url"
	title="Asiento de Interes de Cesantia">

<cf_dbtemp name="tbl_trabajo" returnvariable="tbl_trabajo">
	<cf_dbtempcol name="DEid" 					type="numeric"		mandatory="no"  >
	<cf_dbtempcol name="interes" 		 		type="money"		mandatory="no" >
	<cf_dbtempcol name="cuenta_empleado" 		type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="cuenta_empleado_desc" 	type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="cuenta_interes" 		type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="cuenta_interes_desc" 	type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="CFid" 					type="numeric"		mandatory="no"  >
	<cf_dbtempcol name="CFcodigo" 				type="varchar(10)"	mandatory="no"  >
	<cf_dbtempcol name="CFdescripcion" 			type="varchar(100)"	mandatory="no"  >
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #tbl_trabajo#(DEid, interes, cuenta_empleado, cuenta_empleado_desc, cuenta_interes, cuenta_interes_desc)
	select cs.DEid, cs.RHCSmontoMesInt as interes,
		(  select Cformato
		   from CContables
		   where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     from RHParametros 
						    where Ecodigo=#session.Ecodigo# 
							 and Pcodigo=870) ) as cuenta_empleado,
		(  select Cdescripcion
		   from CContables
		   where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     from RHParametros 
						    where Ecodigo=#session.Ecodigo# 
							 and Pcodigo=870) ) as cuenta_empleado_desc,

		(  select Cformato
		   from CContables
		   where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     from RHParametros 
						    where Ecodigo=#session.Ecodigo# 
							 and Pcodigo=880) ) as cuenta_interes,
		(  select Cdescripcion
		   from CContables
		   where Ccuenta = ( select <cf_dbfunction name="to_number" args="Pvalor"> 
						     from RHParametros 
						    where Ecodigo=#session.Ecodigo# 
							 and Pcodigo=880) ) as cuenta_interes_desc

	from RHCesantiaSaldos cs, DatosEmpleado de
	where cs.RHCSperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	  and cs.RHCSmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
	  and cs.RHCScerrado=1
	  and de.DEid=cs.DEid
	  and de.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and cs.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	  
</cfquery>

<!--- Calculo de Centro Funcional de empleados --->
<cfquery datasource="#session.DSN#">
	update #tbl_trabajo#
	set CFid = coalesce(( select p.CFid
				 from CFuncional cf, RHPlazas p, LineaTiempo lt
				 where cf.CFid=p.CFid
				 and p.RHPid=lt.RHPid
				 and lt.DEid = #tbl_trabajo#.DEid
				 and lt.LTid = ( select max(lt2.LTid) 
				 				 from LineaTiempo lt2 
								 where lt2.DEid = lt.DEid 
								   and <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(url.periodo, url.mes, 1 )#"> <= lt2.LThasta and <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(url.periodo, url.mes, daysinmonth( createdate(url.periodo, url.mes, 1) ) )#"> > lt2.LTdesde ) ), 0)
</cfquery>

<!--- datos para el asiento --->
<cfquery name="data" datasource="#session.DSN#">
	select 	sum(a.interes) as interes, 
			cf.CFcodigo,
			cf.CFdescripcion,
			min(a.cuenta_empleado) as cuenta_empleado, 
			min(a.cuenta_empleado_desc) as cuenta_empleado_desc, 
			min(a.cuenta_interes) as cuenta_interes, 
			min(a.cuenta_interes_desc) as cuenta_interes_desc 
	from #tbl_trabajo# a
	
	left outer join CFuncional cf
	on cf.CFid=a.CFid

	where interes > 0.00

	group by cf.CFcodigo, cf.CFdescripcion
	order by cf.CFcodigo, cf.CFdescripcion 

</cfquery>	

<cfquery name="rs_cerrado" datasource="#session.DSN#">
	select 1
	from RHCesantiaSaldos cs, DatosEmpleado de
	where de.DEid=cs.DEid
	  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHCScerrado = 1
	  and cs.RHCSperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	  and cs.RHCSmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
</cfquery>

<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="5">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinvoke key="LB_ConsultaDeAsientoDeInteresesDeCesantia" default="Consulta de Asiento de Inter&eacute;s de Cesant&iacute;a" returnvariable="LB_ConsultaDeAsientoDeInteresesDeCesantia" component="sif.Componentes.Translate"  method="Translate"/>
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
							Titulo="#LB_ConsultaDeAsientoDeInteresesDeCesantia#"
							Color="##E3EDEF"
							filtro1="#LB_Periodo#: #url.periodo#  #LB_Mes#: #listgetat(lista_meses, url.mes)#"
							filtro2="#filtro2#"
						>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<!---
	<tr>
		<td colspan="5" align="center">
			<table width="100%" cellpadding="2">
				<tr><td align="center"><font style="font-size:14px; font-weight:bold;">Consulta de Asiento de Inter&eacute;s de Cesant&iacute;a</font></td></tr>
				
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
		<td class="tituloListas" width="20%">Centro Funcional</td>
		<td class="tituloListas" width="20%">Cuenta Contable</td>
		<td class="tituloListas" width="20%">Descripci&oacute;n</td>
		<td class="tituloListas" align="right" width="20%">D&eacute;bito</td>
		<td class="tituloListas" align="right" width="20%">Cr&eacute;dito</td>
	</tr>

	<cfif rs_cerrado.recordcount gt 0>
		<cfset total_debitos = 0 >
		<cfset total_creditos = 0 >
		<cfoutput query="data" group="CFcodigo" >
			<cfoutput>
				<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td nowrap="nowrap"><cfif len(trim(data.CFcodigo))>#trim(data.CFcodigo)# - #data.CFdescripcion#<cfelse>-No definido-</cfif></td>
					<td nowrap="nowrap">#data.cuenta_interes#</td>
					<td nowrap="nowrap">#data.cuenta_interes_desc#</td>
					<td align="right">#LSNumberFormat(data.interes, ',9.00')#</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td>&nbsp;</td>
					<td nowrap="nowrap">#data.cuenta_empleado#</td>
					<td nowrap="nowrap">#data.cuenta_empleado_desc#</td>
					<td>&nbsp;</td>				
					<td align="right">#LSNumberFormat(data.interes, ',9.00')#</td>
				</tr>
				<cfset total_debitos = total_debitos +  data.interes >
				<cfset total_creditos = total_creditos +  data.interes >
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<cfif data.recordcount eq 0>
			<tr><td colspan="5" align="center">- No se encontraron registros -</td></tr>
		<cfelse>
			<cfoutput>
			<tr >
				<td nowrap="nowrap" colspan="3" ><strong><i>Total</i></strong></td>
				<td align="right"><strong><i>#LSNumberFormat(total_debitos, ',9.00')#</i></strong></td>
				<td align="right"><strong><i>#LSNumberFormat(total_creditos, ',9.00')#</i></strong></td>
			</tr>
			</cfoutput>
		
			<tr><td colspan="5" align="center">- Fin de la consulta -</td></tr>	
		</cfif>
	<cfelse>
		<tr><td colspan="5" align="center">- El per&iacute;odo y mes consultado no est&aacute; cerrado -</td></tr>	
	</cfif>
</table>

<script>
function fnImgBack()
	{
		window.parent.location.href = '/cfmx/rh/nomina/consultas/cesantia/asientoInteres-filtro.cfm';
	}
</script>