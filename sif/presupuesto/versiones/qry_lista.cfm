<cfparam name="session.versiones.formular" default="">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="qry_lista" datasource="#session.dsn#">
	select a.CVtipo, b.CPPfechaDesde, a.CVid, a.Ecodigo, a.CVdescripcion, a.CPPid, 
		'Tipo de Version: ' #_Cat#
		   (case a.CVtipo when '1' then 'Formulación de Aprobación Presupuesto Ordinario' when '2' then 'Formulación de Modificación Presupuesto Extraordinario' else '' end) 
		as Vtipo,
		'&nbsp;&nbsp;Período de Presupuesto: ' #_Cat#
			case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
			case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
			#_Cat# ' a ' #_Cat# 
			case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
		as Pdescripcion,
		<cfif session.versiones.formular EQ "RH">
			(select RHEdescripcion from RHEscenarios where RHEid = a.RHEid)
		<cfelse>
			case a.CVestado 
				when 0 then 'Base'
				when 1 then 'Usuario'
				when 2 then 'Final'
				when 3 then 'Aprobada'
			end 
		</cfif>
		as Vestado,
		case 
			when (
					  select count(1)
						from CVFormulacionMonedas c
						where c.Ecodigo = a.Ecodigo
						and c.CVid = a.CVid
				 ) = 0
				then 
					'<font color=''##FF0000''>Formulación vacía</font>'
			when (
					  select count(1)
						from CVFormulacionMonedas c
						where c.Ecodigo = a.Ecodigo
						and c.CVid = a.CVid
						and coalesce(c.CVFMmontoAplicar,0) <> 0
				 ) = 0
				then 
					case 
						when a.CVtipo = '1'
						then
							'<font color=''##FF0000''>No se ha solicitado ningún Monto</font>'
						else
							'<font color=''##FF0000''>No se ha solicitado ninguna Modificacion</font>'
					end
			when (select count(1)
					 from CVFormulacionMonedas c
					where c.Ecodigo = a.Ecodigo
					  and c.CVid = a.CVid
					  and coalesce(c.CVFMtipoCambio,0.00) = 0.00 
				  ) > 0 
				  then '<font color=''##FF0000''>Faltan Tipos de Cambio Proyectados</font>' 
			else 'Formulación Completa'
		end as mensaje
	from CVersion a 
		inner join CPresupuestoPeriodo b 
			on a.CPPid = b.CPPid 
		and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
		and a.CVaprobada = 0
	<cfif isdefined("form.FCPPid") and len(form.FCPPid) and form.FCPPid gt 0>
		and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCPPid#">
	</cfif>
	<cfparam name="session.versiones.formular" default="">
	<cfif session.versiones.formular EQ "V">
	<cfelseif session.versiones.formular EQ "B">
		and a.CVestado = 0
	<cfelseif session.versiones.formular EQ "U">
		and a.CVestado = 1
	<cfelseif session.versiones.formular EQ "F">
		and a.CVestado = 2
	<cfelseif session.versiones.formular EQ "RH">
		and a.CVestado < 3
		and a.RHEid is not null
		and (select RHEestado from RHEscenarios where RHEid = a.RHEid) = 'V'

	</cfif>
	order by a.CVtipo, b.CPPfechaDesde, a.CVid
</cfquery>
