<!--- Modificado en Notepad --->
<!---/-------------------------------------------------------------------------------------
------------------------------REPORTE DE LIQUIDACION DE RENTA-----------------------------
--------------------------------------------------------------------------------------/--->
<!---/-------------------------------------------------------------------------------------
------------------------------TRADUCCIONES UTILIZADAS EN EL REPORTE-----------------------
--------------------------------------------------------------------------------------/--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_Renta_Liquidacion"
	Default="Reporte de Renta (Liquidaci&oacute;n)"
	returnvariable="LB_Reporte_de_Renta_Liquidacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PeriodoInicial"
	Default="Periodo Inicial"
	returnvariable="LB_PeriodoInicial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PeriodoFinal"
	Default="Periodo Final"
	returnvariable="LB_PeriodoFinal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cargo"
	Default="Cargo (o Puesto)"
	returnvariable="LB_Cargo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoBase"
	Default="Monto Base"
	returnvariable="LB_MontoBase"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoRetencion"
	Default="Monto Retenci&oacute;n"
	returnvariable="LB_MontoRetencion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SalarioLiquido"
	Default="Salario L&iacute;quido"
	returnvariable="LB_SalarioLiquido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<!---/-------------------------------------------------------------------------------------
------------------------------EIRID ES REQUERIDO-------------------------------------------
--------------------------------------------------------------------------------------/--->
<cfparam name="Form.EIRid" type="numeric">
<!---/-------------------------------------------------------------------------------------
------------------------------REPORTE-----------------------------------------------------
--------------------------------------------------------------------------------------/--->
<cfquery name="rsIR" datasource="sifcontrol">
	select a.EIRid, 
			<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde,
			<!--- datepart(mm,a.EIRdesde) as mesDesde,  --->
			<cf_dbfunction name="date_part"   args="yy, a.EIRdesde"> as periodoDesde,
			<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
			<cf_dbfunction name="date_part"   args="mm, a.EIRhasta">-1 as mesHasta,
			<!--- datepart(mm,a.EIRhasta)-1 as mesHasta, ---> 
			<cf_dbfunction name="date_part"   args="yy, a.EIRhasta">+1 as periodoHasta,
			<!--- datepart(yy,a.EIRhasta)+1 as periodoHasta,  --->
			b.IRcodigo, 
			b.IRdescripcion
	from EImpuestoRenta a
		inner join ImpuestoRenta b
		on a.IRcodigo = b.IRcodigo
	where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
</cfquery>
<cfset lvarEIRid = rsIR.EIRid>
<cfset lvarPeriodoDesde = rsIR.periodoDesde>
<cfset lvarPeriodoHasta = rsIR.periodoHasta>
<cfset lvarMesDesde = rsIR.mesDesde>
<cfset lvarMesHasta = rsIR.mesHasta>
<cfquery name="rsReporte" datasource="#session.dsn#">
	SELECT cf.CFcodigo, cf.CFdescripcion, de.DEidentificacion, de.DEnombre, de.DEapellido1,
		de.DEapellido2, rhpu.RHPdescpuesto,
		sum ( SEsalariobruto + SEincidencias - SEinorenta ) as montobase , 
		sum ( SErenta ) as montoretencion, 
		sum ( SEsalariobruto + SEincidencias - SEinorenta - SErenta ) as montoliquido

	FROM CalendarioPagos a
		INNER JOIN HSalarioEmpleado b
			INNER JOIN 	DatosEmpleado de
				on de.DEid = b.DEid
		on b.RCNid = a.CPid
		INNER JOIN LineaTiempo lt
			INNER JOIN RHPlazas rhp
				INNER JOIN RHPuestos rhpu
					on rhpu.RHPcodigo = rhp.RHPpuesto
					and rhpu.Ecodigo = rhp.Ecodigo
				INNER JOIN CFuncional cf
					on cf.CFid = rhp.CFid
			on rhp.RHPid = lt.RHPid
		on lt.DEid = b.DEid
		and lt.LTdesde between a.CPdesde and a.CPhasta
	WHERE a.CPperiodo*100+a.CPmes >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde*100+lvarMesDesde#">
	  and a.CPperiodo*100+a.CPmes <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta*100+lvarMesHasta#">
	GROUP BY cf.CFcodigo, cf.CFdescripcion, de.DEidentificacion, de.DEnombre, de.DEapellido1,
		de.DEapellido2, rhpu.RHPdescpuesto
	ORDER BY cf.CFcodigo, de.DEidentificacion
</cfquery>
<!---/-------------------------------------------------------------------------------------
-------------------------OBTIENE LAS DESCRIPCIONES DE LOS MESES----------------------------
--------------------------------------------------------------------------------------/--->
<cfquery name="rsMeses"  datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="b.VSvalor"> as MesNumber, VSdesc as Mes
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	order by <cf_dbfunction name="to_number" args="b.VSvalor">
</cfquery>
<cffunction name="getMonthName" access="private" returntype="string">
	<cfargument name="mes" type="numeric" required="true">
	<cfquery name="rsMes" dbtype="query">
		select Mes
		from rsMeses
		where MesNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mes#">
	</cfquery>
	<cfif rsMes.recordcount eq 1 and len(trim(rsMes.Mes)) gt 0>
		<cfreturn rsMes.Mes>
	<cfelse>
		<cfreturn arguments.Mes>
	</cfif>
</cffunction>
<!---/-------------------------------------------------------------------------------------
-------------------PINTA COMPONENTE DE REGRESAR, IMPRESIÓN Y BAJAR A EXCEL-----------------
--------------------------------------------------------------------------------------/--->
<cf_htmlReportsHeaders 
	irA="liquidacionRenta.cfm"
	FileName="Reporte_de_Renta_Liquidacion.xls"
	title="#LB_Reporte_de_Renta_Liquidacion#">
<!---/-------------------------------------------------------------------------------------
-------------------CARGA ESTILOS DE LA PLANTILLA-------------------------------------------
--------------------------------------------------------------------------------------/--->
<cf_templatecss>
<!---/-------------------------------------------------------------------------------------
-------------------PINTA LA REPORTE-------------------------------------------------------
--------------------------------------------------------------------------------------/--->
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="12">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td>
					<cf_EncReporte
						Titulo="#LB_Reporte_de_Renta_Liquidacion#"
						Color="##E3EDEF"
						filtro1="#LB_PeriodoInicial# : #getMonthName(lvarMesDesde)# - #lvarPeriodoDesde#"	
						filtro2="#LB_PeriodoFinal# : #getMonthName(lvarMesHasta)# - #lvarPeriodoHasta#"								
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<!----
	<tr><td colspan="12" align="center"><strong>#LB_Reporte_de_Renta_Liquidacion#</strong></td></tr>
	<tr><td colspan="12" align="center"><strong>#LB_PeriodoInicial#&nbsp;:&nbsp;#getMonthName(lvarMesDesde)# - #lvarPeriodoDesde#</strong></td></tr>
	<tr><td colspan="12" align="center"><strong>#LB_PeriodoFinal#&nbsp;:&nbsp;#getMonthName(lvarMesHasta)# - #lvarPeriodoHasta#</strong></td></tr>
	---->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td nowrap align="left" class="tituloListas"><strong>#LB_Identificacion#</strong>&nbsp;</td>
		<td nowrap align="left" class="tituloListas"><strong>#LB_Nombre#</strong>&nbsp;</td>
		<td nowrap align="left" class="tituloListas"><strong>#LB_Cargo#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_MontoBase#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_MontoRetencion#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_SalarioLiquido#</strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<cfoutput query="rsReporte" group="CFcodigo">
		<tr>
			<td colspan="6" nowrap align="left" class="tituloListas"><strong>#LB_CentroFuncional#&nbsp;:&nbsp;#rsReporte.CFcodigo#-#rsReporte.CFdescripcion#</strong>&nbsp;</td>
		</tr>
		<cfoutput>
			<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td nowrap align="left">&nbsp;&nbsp;#rsReporte.DEidentificacion#&nbsp;</td>
				<td nowrap align="left">#rsReporte.DEapellido1#&nbsp;#rsReporte.DEapellido2#&nbsp;#rsReporte.DEnombre#&nbsp;</td>
				<td nowrap align="left">#rsReporte.RHPdescpuesto#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsReporte.montobase,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsReporte.montoretencion,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsReporte.montoliquido,'none')#</td>
			</tr>
		</cfoutput>
	</cfoutput>
	<tr><td>&nbsp;</td></tr>
	<cfif rsReporte.recordcount gt 0>
		<tr><td colspan="12" align="center"><strong><cf_translate key="LB_Fin_del_reporte">--Fin del reporte--</cf_translate></strong></td></tr>
	<cfelse>
		<tr><td colspan="12" align="center"><strong><cf_translate key="LB_No_se_encontraron_registros">--No se encontraron registros--</cf_translate></strong></td></tr>
	</cfif>
</table>