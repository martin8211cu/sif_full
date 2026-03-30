	<!--- Invoca el portlet de traducción y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<!--- Genera variables de traducción --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal"/>

	<cfinvoke component="sif.Componentes.Translate"	method="Translate" xmlFile="/rh/generales.xml"
		Key="LB_Fecha_Desde"
		Default="Fecha Desde"
		returnvariable="LB_Fecha_Desde"/>
		
	<cfinvoke component="sif.Componentes.Translate" xmlFile="/rh/generales.xml" method="Translate"
		Key="LB_Fecha_Hasta"
		Default="Fecha Hasta"
		returnvariable="LB_Fecha_Hasta"/>
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Empleado"
		Default="Empleado"
		returnvariable="LB_Empleado"/>
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Tipo_Accion"
		Default="Tipo Acción"
		returnvariable="LB_Tipo_Accion"/>
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Monto_Resultante"
		Default="Monto Resultante"
		returnvariable="LB_Monto_Resultante"/>
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Valor_Cantidad"
		Default="Valor / Cantidad"
		returnvariable="LB_Valor_Cantidad"/>

	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Concepto_de_Pago"
		Default="Concepto de Pago"
		returnvariable="LB_Concepto_de_Pago"/>  
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Relacion_de_Calculo"
		Default="Relación de Cálculo"
		returnvariable="LB_Relacion_de_Calculo"/> 
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 	xmlFile="/rh/generales.xml"	
		Key="LB_Total"
		Default="Total"
		returnvariable="LB_Total"/> 
		
		
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="PagosEmpleado_RepCPAP" returnvariable="PE">
		<cf_dbtempcol name="RCNid"   		type="numeric"      mandatory="yes">
		<cf_dbtempcol name="DEid"   		type="numeric"      mandatory="yes">
		<cf_dbtempcol name="PEtiporeg"  	type="int"      mandatory="yes">
		<cf_dbtempcol name="RHTid"   		type="numeric"      mandatory="yes">
		<cf_dbtempcol name="PEdesde" 		type="datetime"     mandatory="no">
		<cf_dbtempcol name="PEhasta" 		type="datetime"     mandatory="no">
		<cf_dbtempcol name="monto" 			type="money"     	mandatory="no">
		<cf_dbtempcol name="cantidad" 		type="money"     	mandatory="no">
		<cf_dbtempcol name="empleado" 		type="varchar(200)" mandatory="no">
		<cf_dbtempcol name="accion" 		type="varchar(200)" mandatory="no">
		<cf_dbtempcol name="descripcion" 	type="varchar(200)" mandatory="no">
		<cf_dbtempcol name="relacionCalculo" type="varchar(200)" mandatory="no">
		<cf_dbtempcol name="orden" 			type="int" mandatory="no">
	</cf_dbtemp>

	<cfset pre=''>
	<cfif isdefined('form.tiponomina')><!--- historico--->
		<cfset pre='H'>		
	</cfif>
	
	<!---- en el caso que la opcion de filtro sea por FECHAS---->
	<cfif isdefined("form.chkutilizarfiltro")>
		<cfquery datasource="#session.dsn#" name="listaNominas" >
			select cp.CPid
			from CalendarioPagos cp
				inner join #PRE#RCalculoNomina hr
					on cp.CPid =  hr.RCNid
			where cp.Ecodigo = #session.Ecodigo#
			and CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.filtro_FechaDesde)#">
			and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.filtro_FechaHasta)#">
			<cfif isdefined("form.LISTATIPONOMINA10") and len(trim(form.LISTATIPONOMINA10))>
				and cp.Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.LISTATIPONOMINA10#">)
			</cfif>
		</cfquery>
		<cfset listaNomina='-1'>
		<cfloop query="listaNominas">
			<cfset listaNomina = ListAppend(listaNomina, CPid)>
		</cfloop>
		<cfif isdefined('form.tiponomina')><!--- historico--->
			<cfset form.listatcodigocalendario1= listaNomina>
		<cfelse>
			<cfset form.listatcodigocalendario2= listaNomina>
		</cfif>
	</cfif>
	
	<!--- Define Form.CPidlist (Puede venir en Form.listatcodigocalendario1 o Form.listatcodigocalendario2) --->
	<cfif isdefined("form.listatcodigocalendario1") and len(trim(form.listatcodigocalendario1)) gt 0>
		<cfset form.CPidlist = form.listatcodigocalendario1>
	<cfelseif isdefined("form.listatcodigocalendario2") and len(trim(form.listatcodigocalendario2)) gt 0>
		<cfset form.CPidlist = form.listatcodigocalendario2>
	<cfelse>
		<!--- Este error no debe presentarse. --->
		<cf_errorCode	code="51919" msg="Error. Se requiere Una lista de Nóminas. Proceso Cancelado!">
	</cfif>
	
	
	<cfquery datasource="#session.dsn#">
		insert into #PE# (RCNid, DEid,PEtiporeg, RHTid,PEdesde, PEhasta, monto, cantidad,empleado,accion,descripcion,relacionCalculo,orden)
		select p.RCNid, p.DEid,PEtiporeg, p.RHTid,
		PEdesde, PEhasta,
		PEmontores, 
		PEmontores,
			de.DEidentificacion#concat#' '#concat#de.DEnombre#concat#' '#concat#de.DEapellido1#concat#' '#concat#de.DEapellido2 as empleado,
			rh.RHTcodigo#concat#' '#concat#rh.RHTdesc as accion,
			(select CSdescripcion from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CSsalariobase=1) as descripcion,
			rhc.Tcodigo#concat#' '#concat#rhc.RCDescripcion as relacionCalculo,
			0 as orden
		from #pre#PagosEmpleado p
			inner join #pre#RCalculoNomina rhc
				on p.RCNid = rhc.RCNid
			inner join DatosEmpleado de
				on p.DEid = de.DEid
			inner join RHTipoAccion rh
				on p.RHTid = rh.RHTid	
		where p.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPidlist#" list="yes">)
		<cfif isdefined("form.ListaTipoAccion1") and len(trim(form.ListaTipoAccion1))>
			and p.RHTid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaTipoAccion1#" list="yes">)
		</cfif>
		<cfif isdefined("form.LISTADEIDEMPLEADO1") and len(trim(form.LISTADEIDEMPLEADO1))>
			and p.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO1#" list="yes">)
		</cfif>
		and (	<!--- unicamente las acciones que escriben en la linea de tiempo y tienen conceptos asociados---->
				select count(1)
				from ConceptosTipoAccion x
				where x.RHTid = rh.RHTid
			) > 0
		order by de.DEidentificacion, rh.RHTcodigo
	</cfquery> 
	
	<!---- ingresa las incidencias de CalculoEspecial---->
	<cfquery datasource="#session.dsn#">
		insert into #PE# (RCNid, DEid,PEtiporeg, RHTid,PEdesde, PEhasta, monto, cantidad,empleado,accion,descripcion,relacionCalculo, orden)
		select 
		p.RCNid, p.DEid,PEtiporeg, p.RHTid,
		PEdesde, PEhasta,
		ICmontores as monto, 
		ICvalor  as cantidad,
			empleado,
			accion,
			ci.CIcodigo#concat#' - '#concat#ci.CIdescripcion as descripcion,
			relacionCalculo,
			case when
					( 	select count(1)
						from ComponentesSalariales cs1
						where cs1.CIid = ic.CIid
					) > 0 then 1
				when					
					( 	select count(1)
						from ComponentesSalariales cs2
							inner join CIncidentes y3
								on cs2.CIid = y3.CIidpadre
						where y3.CIid = ic.CIid
					) > 0 then 2
				when
					( 	select count(1)
						from ConceptosTipoAccion x1
						where x1.CIid = ic.CIid
					) > 0 then 3
				when
					( 	select count(1)
						from ConceptosTipoAccion x2
							inner join CIncidentes y2
								on x2.CIid = y2.CIidpadre
						where y2.CIid = ic.CIid
					) > 0 then 4
			end as orden			
		from #PE# p	
			inner join #pre#IncidenciasCalculo ic
				on p.DEid = ic.DEid
				and p.RCNid = ic.RCNid
				and ic.ICfecha between p.PEdesde and p.PEhasta
			inner join CIncidentes ci
				on ic.CIid = ci.CIid

		where 1=1
			<cfif isdefined("form.ListaConceptoPago1") and len(trim(form.ListaConceptoPago1))>
				and ic.CIid in (<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ListaConceptoPago1#" list="yes">)
			</cfif>
		
			and (
					<!---- si son componentes salariales incidentes--->
				
					( 	select count(1)
						from ComponentesSalariales cs1
						where cs1.CIid = ic.CIid
					) > 0
					
					<!---- si la incidencia alterna está ligada a una incidencia que es un componente salarial--->
					or
					
					( 	select count(1)
						from ComponentesSalariales cs2
							inner join CIncidentes y3
								on cs2.CIid = y3.CIidpadre
						where y3.CIid = ic.CIid
					) > 0
					
					or
					
					<!---- si la incidencia es un concepto por calculo especial--->
					( 	select count(1)
						from ConceptosTipoAccion x1
						where x1.CIid = ic.CIid
					) > 0
					
					<!---- si la incidencia es un concepto de calculo especial alterno--->
					or
					
					( 	select count(1)
						from ConceptosTipoAccion x2
							inner join CIncidentes y2
								on x2.CIid = y2.CIidpadre
						where y2.CIid = ic.CIid
					) > 0
					
			   )
	</cfquery>
	

	<cfquery datasource="#session.dsn#" name="rsReporte">
		select DEid, RHTid, RCNid, monto, empleado, accion,PEdesde, PEhasta, cantidad, descripcion, relacionCalculo,orden
		from #PE#
		<cfif isdefined("form.chkAgruparRC")>
			order by relacionCalculo,empleado,accion, orden
		<cfelse>
			order by empleado,accion, orden
		</cfif>
	</cfquery>
	
	<cfset archivo = "ReporteConceptosPago_En_AccionPersonal_#hour(now())##minute(now())##second(now())#">
		
	<cfif isdefined("ExportarExcel")>
		<cfset txtfile = GetTempFile(getTempDirectory(), 'ReporteConceptoPago')>
		
		<cfsavecontent variable="salidaReporte">
			<cfset ReporteHTML()>
		</cfsavecontent>
		
		<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#salidaReporte#" charset="windows-1252">
				<cfheader name="Content-Disposition" value="attachment;filename=#archivo#.xls">
				<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
	<cfelse>
	
		<cf_htmlReportsHeaders 
			irA="ConceptosPagoEnAccionesPersonal.cfm"
			FileName="#archivo#.xls"
			title="#LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal#"
			download="false"
		>	
		<cf_templatecss>	
		<cfflush interval="512">
		<cfset ReporteHTML()>
	</cfif>


<cffunction name="ReporteHTML" output="true">	
	<cf_EncReporte titulo="#LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal#">
	<table width="98%" border="0" cellpadding="1" cellspacing="1" align="center">
	
		<cfset total_Reporte=0>
		<cfif isdefined("form.chkAgruparRC")>
			
			<cfoutput query="rsReporte" group="RCNid">
				<cfset total_RC=0>
				<tr>
					<td  class="tituloListas" valign="top" colspan="7"><strong>#LB_Relacion_de_Calculo#</strong>&nbsp; #relacionCalculo#</td>
				</tr>
				<cfoutput group="DEid">
					<cfset total_Empleado=0>
					<cfset showEmpleado=true>	
					<tr>
						<td  class="tituloListas" valign="top"><strong>#LB_empleado#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top"><strong>#LB_Tipo_Accion#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="left" nowrap="nowrap"><strong>#LB_Fecha_Desde#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="left" nowrap="nowrap"><strong>#LB_Fecha_Hasta#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="left"><strong>#LB_Concepto_de_Pago#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right" nowrap="nowrap"><strong>#LB_Valor_Cantidad#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right" nowrap="nowrap"><strong>#LB_Monto_Resultante#</strong>&nbsp;</td>
					</tr>
					<cfoutput group="RHTid">	
						<cfset showAccion=true>	
						<cfset total_Accion=0>
						<cfoutput>
							<tr>
								<td nowrap><cfif showEmpleado>#rsReporte.empleado#</cfif></td><cfset showEmpleado=false>	
								<td nowrap align="left"><cfif showAccion>#accion#</cfif></td> <cfset showAccion=false>	
								<td nowrap align="left">#dateformat(rsReporte.PEdesde,'dd/mm/yyyy')#</td>
								<td nowrap align="left">#dateformat(rsReporte.PEhasta,'dd/mm/yyyy')#</td>
								<td nowrap align="left">#descripcion#</td>
								<td nowrap align="right">#LSCurrencyformat(cantidad,'none')#</td>
								<td nowrap align="right">#LSCurrencyformat(monto,'none')#</td>
							</tr>
							<cfset total_Accion=total_Accion+monto>
							<cfset total_Empleado=total_Empleado+monto>
							<cfset total_RC=total_RC+monto>
							<cfset total_Reporte=total_Reporte+monto>
						</cfoutput>
						<tr>
							<td valign="top" align="right" colspan="7"><strong>#LB_Total# #LB_Tipo_Accion#:&nbsp;#LSCurrencyFormat(total_Accion,'none')#</td>
						</tr>
					</cfoutput><!---- agrupado por accion--->
					<tr>
						<td valign="top" align="right" colspan="7"><strong>#LB_Total# #LB_empleado#</strong>:&nbsp;<strong>#LSCurrencyFormat(total_Empleado,'none')#</td>
					</tr>
				</cfoutput><!--- agrupado por empleado--->
				<!--- TOTAL RELACION CALCULO----->
				<tr>
					<td  class="tituloListas" valign="top" colspan="7" align="right"><strong>#LB_Total# #LB_Relacion_de_Calculo#</strong>&nbsp; #relacionCalculo#: #LSCurrencyFormat(total_RC,'none')#</td>
				</tr>
			</cfoutput><!--- agrupado por Relacion de Calculo--->
			<tr>
				<td  class="tituloListas" valign="top" colspan="7" align="right"><strong>#LB_Total#</strong>&nbsp; #LSCurrencyFormat(total_Reporte	,'none')#</td>
			</tr>
		<cfelse><!---- Agrupamiento unicamente por empleado, accion---->
			<cfset total_Reporte=0>
			<cfoutput query="rsReporte" group="DEid">
				<cfset showEmpleado=true>	
				<cfset total_Empleado=0>
				<tr>
					<td  class="tituloListas" valign="top"><strong>#LB_empleado#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top"><strong>#LB_Tipo_Accion#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top" align="left" nowrap="nowrap"><strong>#LB_Fecha_Desde#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top" align="left" nowrap="nowrap"><strong>#LB_Fecha_Hasta#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top" align="left"><strong>#LB_Concepto_de_Pago#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top" align="right" nowrap="nowrap"><strong>#LB_Valor_Cantidad#</strong>&nbsp;</td>
					<td  class="tituloListas" valign="top" align="right" nowrap="nowrap"><strong>#LB_Monto_Resultante#</strong>&nbsp;</td>
				</tr>
				<cfoutput group="RHTid">	
					<cfset showAccion=true>	
					<cfset total_Accion=0>
					<cfoutput>
						<tr>
							<td nowrap><cfif showEmpleado>#rsReporte.empleado#</cfif></td><cfset showEmpleado=false>	
							<td nowrap align="left"><cfif showAccion>#accion#</cfif></td> <cfset showAccion=false>	
							<td nowrap align="left">#dateformat(rsReporte.PEdesde,'dd/mm/yyyy')#</td>
							<td nowrap align="left">#dateformat(rsReporte.PEhasta,'dd/mm/yyyy')#</td>
							<td nowrap align="left">#descripcion#</td>
							<td nowrap align="right">#LSCurrencyformat(cantidad,'none')#</td>
							<td nowrap align="right">#LSCurrencyformat(monto,'none')#</td>
						</tr>
							<cfset total_Accion=total_Accion+monto>
							<cfset total_Empleado=total_Empleado+monto>
							<cfset total_Reporte=total_Reporte+monto>
					</cfoutput>
					<tr>
						<td valign="top" align="right" colspan="7"><strong>#LB_Total# #LB_Tipo_Accion#:&nbsp;#LSCurrencyFormat(total_Accion,'none')#</td>
					</tr>
				</cfoutput><!---- agrupado por accion---> 
				<tr>
					<td valign="top" align="right" colspan="7"><strong>#LB_Total# #LB_empleado#</strong>:&nbsp;<strong>#LSCurrencyFormat(total_Empleado,'none')#</td>
				</tr>
			</cfoutput><!--- agrupado por empleado--->
			<tr>
				<td  class="tituloListas" valign="top" colspan="7" align="right"><strong>#LB_Total#</strong>&nbsp; #LSCurrencyFormat(total_Reporte	,'none')#</td>
			</tr>
		</cfif>	
		
		<tr><td colspan="7" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
	</table>
</cffunction>

