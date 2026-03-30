<!--- CertificadoTrabajoIGSSReporte.cfm --->
<!--- SECCIÓN DE CONSULTAS --->
<cfquery name="rsEmpresaReport" datasource="asp">
	select Enombre, Etelefono1 from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
</cfquery>
<cfquery name="rsDireccionReport" datasource="asp">
	select direccion1 from Direcciones where id_direccion = 
	(
	select id_direccion from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	)
</cfquery>
<cfquery name="rsNoPatronalReport" datasource="#session.dsn#">
	SELECT Pvalor as noPatronal
    FROM RHParametros 
    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      AND Pcodigo = 300
</cfquery>
<cfquery name="rsReport" datasource="#session.dsn#">
	SELECT DE.DEnombre as dec01PrimerNombre, 
		'' as dec02SegundoNombre,
		DE.DEapellido1 as dec03PrimerApellido, 
		DE.DEapellido2 as dec04SegundoApellido,
    	DE.DEdato6 as dec05ApellidoCasada, 
	    DE.DEdato1 as dec06NoAfiliacion, 
		DE.DEobs1 as dec07CedulaVecindadOrden, 
		DE.DEobs2 as dec08Registro,
		DE.DEdireccion as dec09Direccion, 
		DE.DEtelefono1 as dec10Telefono, 
		DE.DEinfo3  as dec11Municipio,
		(select EVfantig from EVacacionesEmpleado where DEid = DE.DEid) as dec12FechaIngreso,
		'' as dec13NombreEsposa,
		'#rsNoPatronalReport.noPatronal#' as dec14NoPatronal,
		'#rsEmpresaReport.Enombre#' as dec15NombrePatrono,
		'#rsEmpresaReport.Enombre#' as dec16NombreEmpresa,
		'#rsDireccionReport.direccion1#' as dec17DireccionEmpresa, 
		'#rsEmpresaReport.Etelefono1#' as dec18TelefonoEmpresa
    FROM DatosEmpleado DE
    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      AND DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>
<cfquery name="rsCPid" datasource="#session.dsn#">
	select max(RCNid) as CPid
	from HSalarioEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>
<cfquery name="rsMaxCalendarioPagos" datasource="#session.dsn#">
	select CPdesde, CPhasta, CPperiodo, CPmes
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPid.CPid#">
</cfquery>
<cfif rsMaxCalendarioPagos.CPmes GT 3>
	<cfset Lvar_CalMes = rsMaxCalendarioPagos.CPmes - 3>
	<cfset Lvar_CalPeriodo = rsMaxCalendarioPagos.CPperiodo>
<cfelse>
	<cfset Lvar_CalMes = rsMaxCalendarioPagos.CPmes + 9>
	<cfset Lvar_CalPeriodo = rsMaxCalendarioPagos.CPperiodo-1>
</cfif>

<cfquery name="rsSalarios" datasource="#session.dsn#">
	select CPid, CPdesde, CPhasta, CPperiodo, CPmes, (c.CPperiodo*100+c.CPmes) as CPperiodomes, SEsalariobruto
	from HSalarioEmpleado a
		inner join HRCalculoNomina b
		on b.RCNid = a.RCNid
		inner join CalendarioPagos c
		on c.CPid = b.RCNid
		and (c.CPperiodo*100+c.CPmes) >= (#Lvar_CalPeriodo*100+Lvar_CalMes#)
		and c.CPtipo = 0 <!---in (0,2) los Anticipos(2) tienen el mismo salario bruto por lo que si se toman en cuenta duplicarían el salario bruto --->
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	order by CPperiodo, CPmes, CPdesde, CPhasta
</cfquery>
<cfset rsReportDetail = querynew("FechaDesde,FechaHasta,Ordinario,ExtraOrdinario")>
<cfoutput query="rsSalarios" group="CPperiodomes">
	<cfset Lvar_FechaDesde = CPdesde>
	<cfset Lvar_FechaHasta = CPhasta>
	<cfset Lvar_Ordinario = 0.00>
	<cfset Lvar_ExtraOrdinario = 0.00>
	<cfoutput>
		<cfquery name="rsJornada" datasource="#session.dsn#">
			select coalesce(min(j.RHJincHJornada),0) as RHJincHJornada
			from DatosEmpleado de
				inner join LineaTiempo lt
				on lt.DEid = de.DEid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CPdesde#"> between lt.LTdesde and lt.LThasta
				left outer join RHPlanificador p
				on p.DEid = de.DEid
				and <cf_dbfunction name="date_format" args="p.RHPJfinicio,yyyymmdd"> >=
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CPdesde#">
				and <cf_dbfunction name="date_format" args="p.RHPJfinicio,yyyymmdd"> <=
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CPhasta#">
				inner join RHJornadas j
				on j.RHJid = coalesce(p.RHJid,lt.RHJid)
			where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfquery>
		<cfset Lvar_CIidList = "">
		<cfif rsJornada.RHJincHJornada GT 0>
			<cfset Lvar_CIidList = ListAppend(Lvar_CIidList,rsJornada.RHJincHJornada)>
		</cfif>
		<!--- BUSCA LA INCIDENCIA DEL PAGO DEL SEPTIMO --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.ecodigo#" pvalor="750" default="-1" returnvariable="Lvar_CIid">
		<cfif Lvar_CIid GT 0>
			<cfset Lvar_CIidList = ListAppend(Lvar_CIidList,Lvar_CIid)>
		</cfif>
		<cfif ListLen(Lvar_CIid)>
			<cfquery name="rsIOrdinarias" datasource="#session.dsn#">
				select coalesce(sum(ICmontores),0.00) as monto
				from HIncidenciasCalculo ic
					inner join CIncidentes ci
					 on ci.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SALORDINARIO'
											where c.RHRPTNcodigo = 'CTI'
											  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
					and ci.CIid = ic.CIid
				where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
				  and ci.CInocargasley = 0 --y que afecten las cargas de ley
			</cfquery>
		<cfelse>
			<cfset rsIOrdinarias.monto = 0.00>
		</cfif>
		<cfquery name="rsIExtraOrdinarias" datasource="#session.dsn#">
			select coalesce(sum(ICmontores),0.00) as monto
			from HIncidenciasCalculo ic
				inner join CIncidentes ci
				  on ci.CIid in (select distinct a.CIid
										from RHReportesNomina c
											inner join RHColumnasReporte b
														inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												 on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'SALEXTRA'
										where c.RHRPTNcodigo = 'CTI'
										  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
				and ci.CIid = ic.CIid
			where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			  and ci.CInocargasley = 0 --y que afecten las cargas de ley
		</cfquery>
		<cfquery name="Deducciones" datasource="#session.DSN#">
			select coalesce(sum(a.DCvalor),0) as monto
			from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
			where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			and a.DEid = b.DEid
			and a.Did = b.Did
			and b.TDid=z.TDid
			and z.TDid in (select distinct a.TDid
					from RHReportesNomina c
						inner join RHColumnasReporte b
									inner join RHConceptosColumna a
									on a.RHCRPTid = b.RHCRPTid
							 on b.RHRPTNid = c.RHRPTNid
							and b.RHCRPTcodigo = 'SALORDINARIO'
					where c.RHRPTNcodigo = 'CTI'
					  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
		</cfquery>
		<cfquery name="Cargas" datasource="#session.DSN#">
			select coalesce(sum(a.CCvaloremp),0) as monto
			from HCargasCalculo a, DCargas b, ECargas c
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			  and b.DClinea = a.DClinea
			  and c.ECid = b.ECid
			  and b.DClinea in (select distinct a.DClinea
						from RHReportesNomina c
							inner join RHColumnasReporte b
										inner join RHConceptosColumna a
										on a.RHCRPTid = b.RHCRPTid
								 on b.RHRPTNid = c.RHRPTNid
								and b.RHCRPTcodigo = 'SALORDINARIO'
						where c.RHRPTNcodigo = 'CTI'
						  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
		</cfquery>
		<cfquery name="DeduccionesAdic" datasource="#session.DSN#">
			select coalesce(sum(a.DCvalor),0) as monto
			from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion z
			where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			and a.DEid = b.DEid
			and a.Did = b.Did
			and b.TDid=z.TDid
			and z.TDid in (select distinct a.TDid
					from RHReportesNomina c
						inner join RHColumnasReporte b
									inner join RHConceptosColumna a
									on a.RHCRPTid = b.RHCRPTid
							 on b.RHRPTNid = c.RHRPTNid
							and b.RHCRPTcodigo = 'DEDUCADIC'
					where c.RHRPTNcodigo = 'CTI'
					  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
		</cfquery>
		<cfset Lvar_FechaHasta = CPhasta>
		<cfset Lvar_Ordinario = Lvar_Ordinario + SEsalarioBruto + rsIOrdinarias.monto - (Deducciones.monto + Cargas.monto) + DeduccionesAdic.monto>
		<cfset Lvar_ExtraOrdinario = Lvar_ExtraOrdinario + rsIExtraOrdinarias.monto>
	</cfoutput>

	<cfset QueryAddRow(rsReportDetail,1)>
	<cfset QuerySetCell(rsReportDetail,"FechaDesde",Lvar_FechaDesde,rsReportDetail.RecordCount)>
	<cfset QuerySetCell(rsReportDetail,"FechaHasta",Lvar_FechaHasta,rsReportDetail.RecordCount)>
	<cfset QuerySetCell(rsReportDetail,"Ordinario",Lvar_Ordinario,rsReportDetail.RecordCount)>
	<cfset QuerySetCell(rsReportDetail,"ExtraOrdinario",Lvar_ExtraOrdinario,rsReportDetail.RecordCount)>
</cfoutput>
<!--- SECCIÓN DE REPORTE --->
<cfoutput>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
  <tr>
    <td align="center" style="font-size:14px; font-family:Verdana, Arial, Helvetica, sans-serif"><cf_translate key="IGSS">INSTITUTO GUATEMALTECO DE SEGURIDAD SOCIAL</cf_translate></td>
  </tr>
  <tr>
    <td align="center" style="font-size:12px; font-family:Verdana, Arial, Helvetica, sans-serif"><cf_translate key="IGSSCT">CERTIFICADO DE TRABAJO</cf_translate></td>
  </tr>
  <tr>
    <td align="center" style="font-size:10px; font-family:Verdana, Arial, Helvetica, sans-serif"><cf_translate key="IGSSAEM">PARA LOS PROGRAMAS DE ACCIDENTES ENFERMEDAD Y MATERNIDAD</cf_translate></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="font-size:10px; font-family:Verdana, Arial, Helvetica, sans-serif"><cf_translate key="IGSS_DATOS_GENERALES">DATOS GENERALES</cf_translate></td>
  </tr>
  <tr>
    <td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
        <tr>
          <td width="70%" align="center" style="font-size:10px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;"><cf_translate key="IGSS_DEL_TRABAJADOR">DEL TRABAJADOR</cf_translate></td>
          <td width="0%">&nbsp;&nbsp;&nbsp;</td>
          <td width="30%" align="center" style="font-size:10px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;"><cf_translate key="IGSS_DEL_PATRONO">DEL PATRONO</cf_translate></td>
        </tr>
        <tr>
          <td valign="top"> <!--- TABLA DEl TRABAJADOR --->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td nowrap height="15"width="4%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">1. &nbsp;</td>
                <td nowrap height="15"width="24%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec01PrimerNombre#</td>
                <td nowrap height="15"width="24%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec02SegundoNombre#</td>
                <td nowrap height="15"width="24%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec03PrimerApellido#</td>
                <td nowrap height="15"width="24%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec04SegundoApellido#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Primer_Nombre">Primer Nombre</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Segundo_Nombre">Segundo Nombre</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Primer_Apellido">Primer Apellido</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Segundo_Apellido">Segundo Apellido</cf_translate></td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; ">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec05ApellidoCasada#</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; ">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; ">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; ">&nbsp;</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Apellido_Casada">Apellido de Casada</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">2.&nbsp;
                  <cf_translate key="IGSS_No_Afiliacion">No. Afiliaci&oacute;n</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec06NoAfiliacion#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">3. &nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Cedula_de_Vecindad_Orden">C&eacute;dula de Vecindad Orden</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec07CedulaVecindadOrden#</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Registro">Registro</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec08Registro#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">4. &nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Direccion">Direcci&oacute;n</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec09Direccion#</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Telefono">Tel&eacute;fono</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec10Telefono#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">5. &nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Municipio_donde_trabaja">Municipio donde trabaja</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="3">&nbsp;#rsReport.dec11Municipio#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">6. &nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Fecha_de_ingreso_a_la_empresa">Fecha de ingreso a la empresa</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="3">&nbsp;#LSDateFormat(rsReport.dec12FechaIngreso,'dd/mm/yyyy')#</td>
              </tr>
              <tr>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">7. &nbsp;</td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                  <cf_translate key="IGSS_Nombre_de_la_esposa_o_conviviente">Nombre de la esposa o conviviente</cf_translate></td>
                <td nowrap height="15"style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec13NombreEsposa#</td>
              </tr>
            </table></td>
          <td>&nbsp;</td>
          <td nowrap valign="top"> <!--- TABLA DEl PATRONO --->
          	<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td nowrap height="15" width="1%" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">8. &nbsp;</td>
                <td nowrap height="15" width="1%"  style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                	<cf_translate key="IGSS_No_Patronal">No. Patronal</cf_translate>
                </td>
                <td nowrap height="15" width="96%"  style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec14NoPatronal#</td>
                <td nowrap height="15" width="1%"  style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;</td>
                <td nowrap height="15" width="1%"  style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                	<cf_translate key="IGSS_Nombre_del">Nombre del</cf_translate>
                </td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">
                	<cf_translate key="IGSS_Patrono">Patrono</cf_translate>
                </td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="3">
					&nbsp;#Mid(rsReport.dec15NombrePatrono,1,Find(' ',rsReport.dec15NombrePatrono,1))#
				</td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="4">
					&nbsp;#Mid(rsReport.dec15NombrePatrono,Find(' ',rsReport.dec15NombrePatrono,1)+1,len(trim(rsReport.dec15NombrePatrono)))#
				</td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">9. &nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;" colspan="4"><cf_translate key="IGSS_Nombre_de_la_empresa_o_dependencia">Nombre de la empresa o dependencia</cf_translate></td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_del_estado">del estado</cf_translate></td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="3">
					&nbsp;&nbsp;#Mid(rsReport.dec16NombreEmpresa,1,Find(' ',rsReport.dec16NombreEmpresa,1))#
				</td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="4">
					&nbsp;#Mid(rsReport.dec16NombreEmpresa,Find(' ',rsReport.dec16NombreEmpresa,1)+1,len(trim(rsReport.dec16NombreEmpresa)))#
				</td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">10. &nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Direccion">Direcci&oacute;n</cf_translate></td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="3">
					&nbsp;#Mid(rsReport.dec17DireccionEmpresa,1,Find(' ',rsReport.dec17DireccionEmpresa,Find(' ',rsReport.dec17DireccionEmpresa,1)+1))#
				</td>
              </tr>
              <tr>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;">&nbsp;</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;" colspan="2">
					&nbsp;#Mid(rsReport.dec17DireccionEmpresa,Find(' ',rsReport.dec17DireccionEmpresa,Find(' ',rsReport.dec17DireccionEmpresa,1)+1)+1,len(trim(rsReport.dec17DireccionEmpresa)))#
				</td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif;"><cf_translate key="IGSS_Telefono">Tel&eacute;fono</cf_translate></td>
                <td nowrap height="15" style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin;">&nbsp;#rsReport.dec18TelefonoEmpresa#</td>
              </tr>
            </table>
          </td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="center" style="font-size:10px; font-family:Verdana, Arial, Helvetica, sans-serif"><cf_translate key="IGSS_INFORME_DE_SALARIOS">INFORME DE SALARIOS</cf_translate></td>
  </tr>
  <tr>
    <td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
        <tr>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" class="tituloListas" colspan="1" align="left"><cf_translate key="LB_No">No.</cf_translate></td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" class="tituloListas" colspan="3" align="center"><cf_translate key="LB_MESES_O_PERIODOS">MESES O PERIODOS</cf_translate></td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" class="tituloListas" colspan="1" align="right"><cf_translate key="LB_ORDINARIO">ORDINARIO</cf_translate></td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" class="tituloListas" colspan="1" align="right"><cf_translate key="LB_MESEEXTRAORDINARIO_O_COMISION">EXTRAORDINARIO O COMISION</cf_translate></td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" class="tituloListas" colspan="1" align="right"><cf_translate key="LB_TOTAL">TOTAL</cf_translate></td>
        </tr>
		<!--- rsReportDetail FechaDesde,FechaHasta,Ordinario,ExtraOrdinario --->
		<cfloop query="rsReportDetail">
		<tr>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="left">#CurrentRow#</td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="left">Del#LSDateFormat(FechaDesde,"dd/mm/yyyy")#</td>
		  <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="left">al&nbsp;#LSDateFormat(FechaHasta,"dd/mm/yyyy")#</td>
          <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="left">20</td>
		  <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="right">Q&nbsp;#LSCurrencyFormat(Ordinario,"none")#</td>
		  <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="right">Q&nbsp;#LSCurrencyFormat(ExtraOrdinario,"none")#</td>
		  <td style="font-size:8px; font-family:Verdana, Arial, Helvetica, sans-serif" colspan="1" align="right">Q&nbsp;#LSCurrencyFormat(Ordinario+ExtraOrdinario,"none")#</td>
        </tr>
		</cfloop>
      </table></td>
  </tr>
</table>
</cfoutput>