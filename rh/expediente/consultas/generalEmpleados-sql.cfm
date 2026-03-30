
<cfquery name="rsReporte" datasource="#session.DSN#"><!---  maxrows="3000"--->
	SELECT
		CF.CFcodigo,
		CF.CFdescripcion,
		coalesce(CFconta.CFcodigo,'&nbsp;') as CFcodigoconta,
		coalesce(CFconta.CFdescripcion,'&nbsp;') as CFdescripcionconta,
		coalesce(ltrim(rtrim(RHP.RHPcodigoext)),ltrim(rtrim(RHP.RHPcodigo))) as RHPcodigo,
		RHP.RHPdescpuesto,
		DEP.Deptocodigo,
		DEP.Ddescripcion,
		DE.DEidentificacion,
		DE.DEid,
		{fn concat({fn concat({fn concat({fn concat(DE.DEapellido1 , ' ')}, DE.DEapellido2 )}, ' ' )}, DE.DEnombre)} as DEnombre,
		DE.DEfechanac,
		DE.DEsexo,
		CASE DE.DEcivil
			  WHEN 0 THEN 'Soltero(a)'
			  WHEN 1 THEN 'Casado(a)'
			  WHEN 2 THEN 'Divorciado(a)'
			  WHEN 3 THEN 'Viudo(a)'
			  WHEN 4 THEN 'Union Libre'
			  WHEN 5 THEN 'Separado(a)'
		END AS DEcivil,
		CASE RHJ.RHJornadahora WHEN 0 THEN 'Por Salario Base' ELSE 'Por Hora' END AS FormaDePago,
		CASE TN.Ttipopago
			WHEN 0 THEN 'Semanal'
			WHEN 1 THEN 'Bisemanal'
			WHEN 2 THEN 'Quincenal'
			WHEN 3 THEN 'Mensual'
		END AS FrecuenciaDePago,
		DLTmonto as Salario, <!---SML Modificacion para que solo considere el Sueldo Mensual--->
		coalesce(DE.DEdireccion,'&nbsp;') as DEdireccion,
		coalesce(coalesce(DE.DEtelefono1,DE.DEtelefono2),'&nbsp;') as DEtelefono,
		DE.DEemail as Correo,
		coalesce(ve.EVfantig,ve.EVfecha) as Antiguedad,
		<!--- CASE DE.DEtipocontratacion
        	WHEN 0 THEN 'Indefinido'
            WHEN 1 THEN 'Fijo'
            WHEN 2 THEN 'Eventual'
            WHEN 3 THEN 'Construccion'
        END AS tipoContrato, --->
		tc.CSATdescripcion as tipoContrato,
		Banc.Bid,
		Banc.Bdescripcion as Banco,
		DE.DEcuenta as Cuenta,
		case when DE.CBTcodigo = 0 then 'Corriente' else 'Ahorro' end as TipoCuenta,
		CBcc as cuentaCliente,
		DE.DEcodPostal
	FROM LineaTiempo LT
    	<!---SML Modificacion para que solo considere el Sueldo Mensual--->
    	inner join DLineaTiempo dl on dl.LTid = LT.LTid
        inner join ComponentesSalariales cs on cs.CSid = dl.CSid
        	and cs.CSsalariobase = 1
		<!---SML Modificacion para que solo considere el Sueldo Mensual--->
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
		inner join CSATTiposContrato tc
		ON DE.DEtipocontratacion = tc.TCid
			LEFT OUTER JOIN Bancos Banc
			ON Banc.Bid = DE.Bid
		INNER JOIN RHPlazas RHPL
			INNER JOIN CFuncional CF
			ON CF.CFid = RHPL.CFid
			inner JOIN CFuncional CFconta
			ON CFconta.CFid = coalesce(RHPL.CFidconta, RHPL.CFid)
		ON RHPL.RHPid = LT.RHPid
		INNER JOIN RHPuestos RHP
		ON RHP.RHPcodigo = LT.RHPcodigo
		AND RHP.Ecodigo = LT.Ecodigo
		LEFT OUTER JOIN Departamentos DEP
		ON DEP.Dcodigo = LT.Dcodigo
		AND DEP.Ecodigo = LT.Ecodigo
		INNER JOIN RHJornadas RHJ
		ON RHJ.RHJid = LT.RHJid
		INNER JOIN TiposNomina TN
		ON TN.Ecodigo = LT.Ecodigo
		AND TN.Tcodigo = LT.Tcodigo
		inner join EVacacionesEmpleado ve
			on ve.DEid = DE.DEid

		<!---LEFT OUTER JOIN

			(select  (case when  TAcc.RHTtiponomb = 0 then 'Permanente'
				when    TAcc.RHTtiponomb = 1 then 'Practicante'
				when    TAcc.RHTtiponomb = 2 then 'Transitorio'
				when    TAcc.RHTtiponomb = 3 then 'Ocasional'
				else 	<cf_dbfunction name="to_char_integer"	args="TAcc.RHTtiponomb">
			end) AS tipoContrato,
			LT.DEid 	as  DEid

			from LineaTiempo LT,
			RHTipoAccion TAcc
			where 	LT.LTid=(select max(LTid)
					from LineaTiempo LTiempo,
						RHTipoAccion tipoAcc
					where DEid=LT.DEid
					and tipoAcc.RHTid = LTiempo.RHTid
					and tipoAcc.RHTcomportam = 1)

			and LT.Ecodigo = TAcc.Ecodigo
			and LT.RHTid  =  TAcc.RHTid ) tipoContratos

		on tipoContratos.DEid = LT.DEid	--->

	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<cfif not isdefined('ActivarRango')>
		and lt.LTid= (select max(LTid)
               from LineaTiempo lineaT
			   where lineaT.DEid = LT.DEid
		<cfif isdefined("Url.FechaDesde") and len(trim("Url.FechaDesde"))>
			and lineaT.LTdesde <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">
		</cfif>
		and lineaT.LThasta >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaDesde)#">
        or lineaT.LThasta <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaDesde)#"> )
	<cfelse>
		AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#"> between LTdesde and LThasta
	</cfif>
	ORDER BY #url.OrderBy#
</cfquery>

<cfif rsReporte.recordcount GT 3000 and Url.formato neq 'HTML'>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se gener&oacute; un reporte más grande de lo permitido, intente generarlo en formato HTML.  Proceso Cancelado!</cf_translate>
	<br>
	<br>
	 <cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfif Url.formato neq 'HTML'>
		<cfreport format="#Url.formato#" template= "generalEmpleados.cfr" query="rsReporte">
			<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
			<cfif not isdefined('ActivarRango')>
				<cfif isdefined("Url.FechaDesde") and len(trim(Url.FechaDesde))>
				<cfreportparam name="FechaDesde" value="#LSParseDateTime(Url.FechaDesde)#">
				</cfif>
			</cfif>
			<cfreportparam name="OrderBy" value="#Left(Url.OrderBy,1)#">
		</cfreport>
	<cfelse>
		<cfinclude template="generalEmpleados-html.cfm">
	</cfif>
</cfif>