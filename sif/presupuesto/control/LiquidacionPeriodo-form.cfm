<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select 	CPPid, CPPidLiquidacion, CPPanoMesDesde, CPPanoMesHasta,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Descripcion				
	 from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	  and CPPestado = 1
	order by CPPfechaDesde
</cfquery>
<!--- Obtiene el mes de Auxiliares --->
<cfquery name="rsSQL" datasource="#session.dsn#">
select Pvalor
  from Parametros
 where Ecodigo = #session.ecodigo#
   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfif LvarAuxMes EQ 1>
	<cfset LvarAuxMesL = "Enero">
<cfelseif LvarAuxMes EQ 2>
	<cfset LvarAuxMesL = "Febrero">
<cfelseif LvarAuxMes EQ 3>
	<cfset LvarAuxMesL = "Marzo">
<cfelseif LvarAuxMes EQ 4>
	<cfset LvarAuxMesL = "Abril">
<cfelseif LvarAuxMes EQ 5>
	<cfset LvarAuxMesL = "Mayo">
<cfelseif LvarAuxMes EQ 6>
	<cfset LvarAuxMesL = "Junio">
<cfelseif LvarAuxMes EQ 7>
	<cfset LvarAuxMesL = "Julio">
<cfelseif LvarAuxMes EQ 8>
	<cfset LvarAuxMesL = "Agosto">
<cfelseif LvarAuxMes EQ 9>
	<cfset LvarAuxMesL = "Setiembre">
<cfelseif LvarAuxMes EQ 10>
	<cfset LvarAuxMesL = "Octubre">
<cfelseif LvarAuxMes EQ 11>
	<cfset LvarAuxMesL = "Noviembre">
<cfelseif LvarAuxMes EQ 12>
	<cfset LvarAuxMesL = "Diciembre">
</cfif>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight:bold;
}
-->
</style>

<br>
<cfoutput>
&nbsp;&nbsp;&nbsp;<strong>#rsPeriodos.Descripcion#</strong>
</cfoutput>
<cfset LvarSePuedeLiquidar = false>
<cfif rsPeriodos.recordCount EQ 0>
	<br><br><br><br><br><br><br>
	<div class="style1" align="center">
	No existen Períodos de Presupuesto Abiertos
	</div>
	<br><br><br><br><br><br><br>
<cfelseif rsPeriodos.recordCount EQ 1>
	<br><br><br><br><br><br><br>
	<div class="style1" align="center">
	Para poder Liquidar este Período de Presupuesto debe crear primero un nuevo Período de Presupuesto y<br>aprobarle una Versión de Formulación de Aprobación Presupuesto Ordinario<br>y adicionalmente realizar primero el Cierre Anual de Auxiliares
	</div>
	<br><br><br><br><br><br><br>
<cfelseif rsPeriodos.recordCount GT 2>
	<br><br><br><br><br><br><br>
	<div class="style1" align="center">
	Existen más de 2 Períodos de Presupuesto Abiertos
	</div>
	<br><br><br><br><br><br><br>
<cfelse>
	<cfset LvarError = 0>
	<cfset LvarCPPid_1 = "">
	<cfset LvarCPPid_1in2 = "">
	<cfset LvarCPPid_2 = "">
	<cfloop query="rsPeriodos">
		<cfif LvarCPPid_1 EQ "">
			<cfset LvarCPPid_1 = rsPeriodos.CPPid>
			<cfset LvarCPPid_1in2 = rsPeriodos.CPPidLiquidacion>
		<cfelseif LvarCPPid_1in2 NEQ "">
			<cfset LvarCPPid_2 = rsPeriodos.CPPid>
			<cfif LvarCPPid_1in2 NEQ rsPeriodos.CPPid>
				<cfquery name="rsPeriodos" datasource="#Session.DSN#">
					select 
						'Presupuesto ' #_Cat#
							case n.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(n.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(n.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaHasta)}">
						as Nuevo,
						'Presupuesto ' #_Cat#
							case v.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(v.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(v.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaHasta)}">
						as Viejo
					  from CPresupuestoPeriodo v, CPresupuestoPeriodo n
					 where v.Ecodigo 	= #session.Ecodigo#
					   and v.CPPid 		= #LvarCPPid_1#
					   and n.Ecodigo 	= #session.Ecodigo#
					   and n.CPPid 		= #LvarCPPid_1in2#
				</cfquery>
				<cf_errorCode	code = "50471"
								msg  = "El Período '@errorDat_1@' ya fue Liquidado anteriormente y sólo puede ser liquidado nuevamente en el Período '@errorDat_2@'"
								errorDat_1="#rsPeriodos.Viejo#"
								errorDat_2="#rsPeriodos.Nuevo#"
				>
			</cfif>
		<cfelse>
			<cfset LvarCPPid_2 = rsPeriodos.CPPid>
			<cfif rsPeriodos.CPPidLiquidacion NEQ "">
				<cfquery name="rsPeriodos" datasource="#Session.DSN#">
					select 
						'Presupuesto ' #_Cat#
							case n.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(n.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(n.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaHasta)}">
						as Nuevo,
						'Presupuesto ' #_Cat#
							case v.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(v.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(v.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaHasta)}">
						as Viejo
					  from CPresupuestoPeriodo v, CPresupuestoPeriodo n
					 where v.Ecodigo 	= #session.Ecodigo#
					   and v.CPPid 		= #LvarCPPid_1#
					   and n.Ecodigo 	= #session.Ecodigo#
					   and n.CPPid 		= #LvarCPPid_2#
				</cfquery>
				<cf_errorCode	code = "50472"
								msg  = "El Período '@errorDat_1@' no puede liquidarse, puesto que el nuevo Período '@errorDat_2@' ya fue liquidado"
								errorDat_1="#rsPeriodos.Viejo#"
								errorDat_2="#rsPeriodos.Nuevo#"
				>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfset session.CPPid=rsPeriodos.CPPid>
	<cfquery name="rsPeriodoNuevo" datasource="#Session.DSN#">
		select 	CPPid, CPPanoMesDesde, CPPanoMesHasta,
				'Presupuesto ' #_Cat#
					case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as Descripcion				
		 from CPresupuestoPeriodo
		where Ecodigo = #Session.Ecodigo#
		  and CPPestado = 1
		  and CPPid = #LvarCPPid_2#
	</cfquery>

	<cfif rsPeriodos.CPPanoMesHasta GT LvarAuxAnoMes>
		<br><br><br><br><br><br><br>
		<div class="style1" align="center">
		Para poder Liquidar este Período de Presupuesto debe realizar primero el Cierre Anual de Auxiliares
		</div>
		<br><br><br><br><br><br><br>
		<cfset LvarSePuedeLiquidar = false>
	<cfelseif NOT (LvarAuxAnoMes GTE rsPeriodoNuevo.CPPanoMesDesde AND LvarAuxAnoMes LTE rsPeriodoNuevo.CPPanoMesHasta)>
		<br><br><br><br><br><br><br>
		<div class="style1" align="center">
		El Mes Actual de Auxiliares no pertenece al Nuevo Período de Presupuesto
		</div>
		<br><br><br><br><br><br><br>

		<BR>

		<cfset LvarSePuedeLiquidar = false>
	<cfelse>
		<br><br>
		<cfset LvarSePuedeLiquidar = true>
	</cfif>

	<cf_web_portlet_start titulo="Parámetros de Liquidacion" width="40%">
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPLiquidacionParametros
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #rsPeriodos.CPPid#
		</cfquery>
		<cfif rsParametros.cantidad EQ 0>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'A', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'A', 'CC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'G', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'G', 'CC', 'N')
			</cfquery>
		</cfif>

		<cfif rsParametros.cantidad LTE 4>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'O', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'O', 'CC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'P', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'P', 'CC', '-')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'E', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'E', 'CC', '-')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'I', 'RC', 'N')
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacionParametros (Ecodigo, CPPid, Ctipo, CPNAPDtipoMov, CPLtipoLiquidacion)	
				values (#session.Ecodigo#, #rsPeriodos.CPPid#, 'I', 'CC', 'N')
			</cfquery>
		</cfif>
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select RC.Ctipo, 
						case RC.Ctipo
							when 'A' then 'Compras de Activo' 
							when 'G' then 'Compras de Gasto'
							when 'O' then 'Compras de Otros'
							when 'P' then 'Solicitud de Pago'
							when 'E' then 'Anticipo Empleados'
							when 'I' then 'Interfaces'
							else 'OTRO ???'
						end	as TipoCta,
						RC.CPLtipoLiquidacion as TipoLiq_RC,
						CC.CPLtipoLiquidacion as TipoLiq_CC
			  from CPLiquidacionParametros RC, CPLiquidacionParametros CC
			 where RC.Ecodigo 	= #session.Ecodigo#
			   and RC.CPPid 	= #rsPeriodos.CPPid#
			   and RC.CPNAPDtipoMov = 'RC'
			   and CC.Ecodigo 	= RC.Ecodigo
			   and CC.CPPid 	= RC.CPPid
			   and CC.CPNAPDtipoMov = 'CC'
			   and CC.Ctipo 	= RC.Ctipo
			order by 2
		</cfquery>
		<cfquery name="rsLiquidacion" datasource="#Session.DSN#">
			select CPLnumeroLiquidacion
			  from CPLiquidacion
			 where Ecodigo 				= #session.Ecodigo#
			   and CPPid				= #rsPeriodos.CPPid#
			   and CPNAPnumLiquidacion	is null
		</cfquery>
		<cfif rsLiquidacion.CPLnumeroLiquidacion EQ "">
			<cfquery name="rsLiquidacion" datasource="#Session.DSN#">
				select coalesce(max(CPLnumeroLiquidacion)+1,1) as CPLnumeroLiquidacion
				  from CPLiquidacion
				 where Ecodigo 				= #session.Ecodigo#
			</cfquery>
			<cfif rsLiquidacion.CPLnumeroLiquidacion EQ "">
				<cfset rsLiquidacion.CPLnumeroLiquidacion = 1>
			</cfif>

			<cfquery datasource="#Session.DSN#">
				insert into CPLiquidacion
					(Ecodigo, CPPid, CPLnumeroLiquidacion)
				values(
					#session.Ecodigo#,
					#rsPeriodos.CPPid#,
					#rsLiquidacion.CPLnumeroLiquidacion#
					)
			</cfquery>
		</cfif>

		<cfquery name="rsLiquidacionCuentas" datasource="#Session.DSN#">
			select 	case m.Ctipo
						when 'A' then 'Activo' 
						when 'G' then 'Gasto' 
						else 'OTRO ???'
					end	as TipoCta,
					l.CPcuenta, c.CPformato,
					l.Ocodigo, o.Oficodigo,
					CPLCdisponibleAntes,
					CPLCpendientesAntes,
					CPLCmontoReservas,
					CPLCmontoCompromisos,
					CPLCmontoModificacion,
					CPLCdisponibleAntes-CPLCpendientesAntes-CPLCmontoReservas-CPLCmontoCompromisos+CPLCmontoModificacion as DisponibleNeto,
					CPLCresultado,
					case CPLCresultado
						when 0 then 'OK&nbsp;'
						when 1 then 'No hay disponible&nbsp;'
						when 2 then 'No existe Cuenta&nbsp;'
						else 'Cuenta+Oficina no Formulada&nbsp;'
					end as Resultado
			  from CPLiquidacionCuentas l
				inner join CPresupuesto c
					inner join CtasMayor m
						 on m.Ecodigo = c.Ecodigo
						and m.Cmayor  = c.Cmayor
					on c.CPcuenta = l.CPcuenta
				inner join Oficinas o
					 on o.Ecodigo = l.Ecodigo
					and o.Ocodigo = l.Ocodigo
			 where l.Ecodigo 	= #session.Ecodigo#
			   and l.CPPid 		= #rsPeriodos.CPPid#
			   and l.CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			 order by m.Ctipo, c.CPformato
		</cfquery>
		<cfquery name="rsTotal" datasource="#Session.DSN#">
			select 	sum(CPLCmontoReservas) as Total_RC
					,sum(CPLCmontoCompromisos) as Total_CC
					,sum(CPLCmontoModificacion) as Total_M
					,sum(CPLCmontoReservas+CPLCmontoCompromisos-CPLCmontoModificacion) as Total_SF
					,count(1) as buenos
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #rsPeriodos.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado = 0 
		</cfquery>
		<cfquery name="rsTotal_ErrSD" datasource="#Session.DSN#">
			select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #rsPeriodos.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado = 1 
		</cfquery>
		<cfquery name="rsTotal_ErrSC" datasource="#Session.DSN#">
			select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #rsPeriodos.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado in (2, 3)
		</cfquery>
		<form action="LiquidacionPeriodo-sql.cfm" name="frmLiquidacion" method="post">
		<input name="CPPid" type="hidden" value="<cfoutput>#rsPeriodos.CPPid#</cfoutput>">
		<input name="CPLnumeroLiquidacion" type="hidden" value="<cfoutput>#rsLiquidacion.CPLnumeroLiquidacion#</cfoutput>">
		<input name="CPPidNuevo" type="hidden" value="<cfoutput>#rsPeriodoNuevo.CPPid#</cfoutput>">
		<table  align="center">
			<tr>
				<td valign="bottom"><strong>Tipo de NAP</strong></td>
				<td>&nbsp;</td>
				<td align="center"><strong>Tipo Liquidacion<br>para Reservas<br><br>(Solicitudes)</strong></td>
				<td>&nbsp;</td>
				<td align="center"><strong>Tipo Liquidacion<br>para Compromisos<br><br>(Órdenes)</strong></td>
			</tr>
			<cfoutput query="rsParametros">
			<tr>
				<td align="center" nowrap><strong>#rsParametros.TipoCta#</strong></td>
				<td>&nbsp;</td>
				<td>
					<select name="TipoLiq_#rsParametros.Ctipo#_RC">
						<option value="N" <cfif rsParametros.TipoLiq_RC EQ "N">selected</cfif>>No Liquidar Reservas</option>
						<option value="S" <cfif rsParametros.TipoLiq_RC EQ "S">selected</cfif>>Pasar sólo Reserva (sin fondos)</option>
						<option value="C" <cfif rsParametros.TipoLiq_RC EQ "C">selected</cfif>>Pasar Reserva y Modificar Presupuesto</option>
					</select>
				</td>
				<td>&nbsp;</td>
				<td>
					<cfif rsParametros.TipoLiq_CC NEQ "-">
					<select name="TipoLiq_#rsParametros.Ctipo#_CC">
						<option value="N" <cfif rsParametros.TipoLiq_CC EQ "N">selected</cfif>>No Liquidar Compromisos</option>
						<option value="S" <cfif rsParametros.TipoLiq_CC EQ "S">selected</cfif>>Pasar sólo Compromiso (sin fondos)</option>
						<option value="C" <cfif rsParametros.TipoLiq_CC EQ "C">selected</cfif>>Pasar Compromiso y Modificar Presupuesto</option>
					</select>
					</cfif>
				</td>
			</tr>
			</cfoutput>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<td nowrap><strong>Número Liquidación: </strong></td>
				<td>&nbsp;</td>
				<td colspan="3"><cfoutput>#rsLiquidacion.CPLnumeroLiquidacion#</cfoutput></td>
			</tr>
			<tr>
				<td nowrap><strong>Período a Liquidar: </strong></td>
				<td>&nbsp;</td>
				<td colspan="3"><cfoutput>#rsPeriodos.Descripcion#</cfoutput></td>
			</tr>
			<tr>
				<td nowrap><strong>Liquidar en: </strong></td>
				<td>&nbsp;</td>
				<td colspan="3"><cfoutput>#rsPeriodoNuevo.Descripcion#</cfoutput></td>
			</tr>
			<tr>
				<td nowrap><strong>Liquidar en Mes: </strong></td>
				<td>&nbsp;</td>
				<td colspan="3"><cfoutput>#LvarAuxAno# - #LvarAuxMesL#</cfoutput></td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5" align="center">
					<input type="submit" name="btnGenerar" value="Generar Liquidación">
				<cfif LvarSePuedeLiquidar AND rsTotal.buenos GT 0>
					<input type="submit" name="btnLiquidar" value="Aprobar Liquidación" onClick="javascript:return sbLiquidar();">
				</cfif>
				</td>
			</tr>
		</table>
		</form>
	<cf_web_portlet_end>
	<BR>
	<BR>
	<cf_web_portlet_start titulo="Liquidacion a Aprobar" width="80%">
		<cfoutput>
		<table width="40%" align="center">
			<tr>
				<td>
					<strong>Total Reservas a Liquidar:</strong>
				</td>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_RC,",0.00")#
				</td>
			</tr>
			<tr>
				<td>
					<strong>Total Compromisos a Liquidar:</strong>
				</td>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_CC,",0.00")#
				</td>
			</tr>
			<tr>
				<td>
					<strong>Total con Modificacion:</strong>
				</td>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_M,",0.00")#
				</td>
			</tr>
			<tr>
				<td>
					<strong>Total sin Modificacion:</strong>
				</td>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_SF,",0.00")#
				</td>
			</tr>
			<tr>
				<td class="style1">
					<strong>Total Reservas y Compromisos con Error que no se van a liquidar:</strong>
				</td>
				<td>&nbsp;
					
				</td>
				<td class="style1" align="right">
					#numberFormat(rsTotal_ErrSD.Total + rsTotal_ErrSC.Total,",0.00")#
				</td>
			</tr>
			<tr>
				<td class="style1" style="font-weight:100" align="right">
					Sin Fondos en nuevo Período:
				</td>
				<td>&nbsp;</td>
				<td class="style1" style="font-weight:100" align="right">
					#numberFormat(rsTotal_ErrSD.Total,",0.00")#
				</td>
			</tr>
			<tr>
				<td class="style1" style="font-weight:100" align="right">
					Sin Cuenta en nuevo Período:
				</td>
				<td>&nbsp;</td>
				<td class="style1" style="font-weight:100" align="right">
					#numberFormat(rsTotal_ErrSC.Total,",0.00")#
				</td>
			</tr>
		</table>
		</cfoutput>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
			<cfinvokeargument name="query" value="#rsLiquidacionCuentas#">
			<cfinvokeargument name="desplegar" value="TipoCta, CPformato, Oficodigo, CPLCdisponibleAntes, CPLCpendientesAntes, CPLCmontoReservas, CPLCmontoCompromisos, CPLCmontoModificacion, DisponibleNeto, Resultado"/>
			<cfinvokeargument name="etiquetas" value="Tipo Cuenta, Cuenta, Oficina, Disponible Anterior, Pendientes Anterior, Monto Reservas, Monto Compromisos, Monto Modificacion, Disponible&nbsp;Neto<BR>a Generar, Resultado"/>
			<cfinvokeargument name="formatos" value="S, S, S, M, M, M, M, M, M, S"/>
			<cfinvokeargument name="align" value="left, left, left, right, right, right, right, right, right, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="maxrows" value="20"/>
			<cfinvokeargument name="linearoja" value="CPLCresultado NEQ 0"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="irA" value="../consultas/ConsPresupuesto-detallesNAP.cfm"/>
		</cfinvoke>						
		<BR/>
		<strong>&nbsp;&nbsp;(*)	 Posicione el cursor en una cuenta y presione click para consultar los NAPs que se deben liquidar</strong>
		<BR/><BR/>
		
		<table width="100%">
		<tr><td align="center">
			&nbsp;<input type="button" name="btnimprimir" class="btnimprimir" value="Imprimir" onclick="popup();">
		</td></tr>
		</table>
		
	<cf_web_portlet_end>
</cfif>

<script language="javascript">
	<cfif LvarSePuedeLiquidar AND rsLiquidacionCuentas.recordCount GT 0>
	function sbLiquidar()
	{
		<cfoutput>
		<cfif rsTotal_ErrSD.Total + rsTotal_ErrSC.Total GT 0>
			return confirm ("Existen Cuentas+Oficina con Errores que no se pueden liquidar, si aprueba la Liquidación todas las transacciones con saldo de dichas Cuentas+Oficina no se podrán referenciar en el nuevo Período. ¿Desea realizar la Aprobación de la Liquidación en el Mes de Presupuesto '#LvarAuxAno# - #LvarAuxMesL#'?");
		<cfelse>
			return confirm ("¿Desea aprobar la Liquidación en el Mes de Presupuesto '#LvarAuxAno# - #LvarAuxMesL#'?");
		</cfif>
		</cfoutput>
	}
	function popup(imprimir,w,h,format)
		{
		var PARAM  = "../consultas/ConsLiquCuent-PopUp.cfm?lpf=1&CPPid=<cfoutput>#rsPeriodos.CPPid#</cfoutput>";
		if(!w) w = 400;
		if(!h) h = 200;

		if(imprimir) PARAM = PARAM + '&imprimir=true&format=' + format;
		args = 'left=250,top=250,scrollbars=yes,resizable=yes,width='+w+',height='+h;
		windowOpener (PARAM,'popUpWin',args, w, h);
		}
	function windowOpener(url, name, args, width, height, cerrar) 
	{
		if (typeof(popupWin) != "object")
			{popupWin = window.open(url,name,args);} 
		else {
			if (!popupWin.closed){popupWin.location.href = url;} 
			else {popupWin = window.open(url, name,args);}
			 }
		popupWin.focus();
		popupWin.resizeTo(width,height);
	}
	</cfif>
</script>

