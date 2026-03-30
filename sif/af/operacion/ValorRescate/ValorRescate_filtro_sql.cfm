<cfif isdefined ('form.filtrar')>
	<cfquery name="slTipo" datasource="#session.dsn#">
		select AFTRtipo from AFTRelacionCambio where AFTRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
	</cfquery>

	<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
	</cfquery>

	<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
	</cfquery>

	<cfquery name="slActivos" datasource="#session.dsn#">
		select count(1) as cantidad
		from Activos a
			inner join AFSaldos s
			on s.Aid=a.Aid
		where a.Ecodigo = #session.Ecodigo#
		and   a.Astatus = 0

		and s.AFSperiodo = #rsPeriodoAuxiliar.Pvalor#
		and s.AFSmes     = #rsMesAuxiliar.Pvalor#
		and s.Ecodigo    = #session.Ecodigo#

		<cfif form.valor neq ''>
			and a.Avalrescate >= #form.valor#
		</cfif>

		<cfif isdefined("form.AplacaDesde") and form.AplacaDesde neq ''>
			and a.Aplaca >= '#form.AplacaDesde#'
		</cfif>

		<cfif isdefined("form.AplacaHasta") and form.AplacaHasta neq ''>
			and a.Aplaca <= '#form.AplacaHasta#'
		</cfif>

		<cfif isdefined ('form.vr')>
			and a.Avalrescate > 0
		</cfif>

		<cfif #form.AFMMid# neq ''>
			and a.AFMMid = #form.AFMMid#
		</cfif>

		<cfif #form.AFMid# neq ''>
			and a.AFMid=#form.AFMid#
		</cfif>

		<cfif form.AFCcodigoORI neq''>
			and a.AFCcodigo = #form.AFCcodigoORI#
		</cfif>

		<cfif form.ACcodigoORI neq ''>
			and s.ACcodigo = #form.ACcodigoORI#
		</cfif>

		<cfif form.ACidORI neq '' and form.ACcodigoORI neq ''>
			and s.ACid     = #form.ACidORI#
			and s.ACcodigo = #form.ACcodigoORI#
		</cfif>

		<cfif isdefined("form.CFid") and form.CFid neq "">
			and s.CFid = #form.CFid#
		</cfif>

		and not exists (select 1
			from AFTRelacionCambioD d
			where d.Aid = a.Aid
			  and d.AFTRid = #form.AFTRid#
			 )
	</cfquery>



	<cfif slActivos.cantidad eq 0>
		<cflocation addtoken="no" url="ValorRescate_filtro.cfm?bandera=1&AFTRid=#form.AFTRid#">
	<cfelse>
    <!---Se agrega en el insert los campos AFMid, AFMMid y AFccodigo para cambio por garantía RVD 04/06/2014--->
			<cfquery datasource="#session.dsn#">
				insert into AFTRelacionCambioD(
					AFTRid,
					Ecodigo,
					Aid,
					Avalrescate,
					Adescripcion,
					Usucodigo,
					AFTDtipo,
					AFTDdescripcion,
					AFTDvalrescate,
					Afechainidep,
					AFTDfechainidep,
                    AFMid,
                    AFMMid,
                    AFCcodigo,
					Aserie)					<!--- JMRV. Para garantia --->
				select
						#form.AFTRid#,
						#session.Ecodigo#,
						a.Aid,
						a.Avalrescate,
						a.Adescripcion,
						#session.Usucodigo#,
						#slTipo.AFTRtipo#,
						a.Adescripcion,
						a.Avalrescate,
						a.Afechainidep,
						a.Afechainidep,
                        a.AFMid,
                        a.AFMMid,
                        a.AFCcodigo,
						a.Aserie			<!--- JMRV. Para garantia --->
				from Activos a
					inner join AFSaldos s
					on s.Aid=a.Aid
				where a.Ecodigo = #session.Ecodigo#
				and a.Astatus=0

				and s.AFSperiodo = #rsPeriodoAuxiliar.Pvalor#
				and s.AFSmes     = #rsMesAuxiliar.Pvalor#
				and s.Ecodigo    = #session.Ecodigo#

				<cfif isdefined("form.AplacaDesde") and form.AplacaDesde neq ''>
					and a.Aplaca >= '#form.AplacaDesde#'
				</cfif>

				<cfif isdefined("form.AplacaHasta") and form.AplacaHasta neq ''>
					and a.Aplaca <= '#form.AplacaHasta#'
				</cfif>

				<cfif form.valor neq ''>
					and a.Avalrescate >= #form.valor#
				</cfif>

				<cfif isdefined ('form.vr')>
					and a.Avalrescate > 0
				</cfif>

				<cfif #form.AFMMid# neq ''>
					and a.AFMMid = #form.AFMMid#
				</cfif>

				<cfif #form.AFMid# neq ''>
					and a.AFMid=#form.AFMid#
				</cfif>

				<cfif form.AFCcodigoORI neq ''>
					and a.AFCcodigo=#form.AFCcodigoORI#
				</cfif>

				<cfif form.ACcodigoORI neq ''>
					and s.ACcodigo = #form.ACcodigoORI#
				</cfif>

				<cfif form.ACidORI neq '' and form.ACcodigoORI neq ''>
					and s.ACid     = #form.ACidORI#
					and s.ACcodigo = #form.ACcodigoORI#
				</cfif>

				<cfif isdefined("form.CFid") and form.CFid neq "">
					and s.CFid = #form.CFid#
				</cfif>

				and not exists (select 1
					from AFTRelacionCambioD d
					where d.Aid = a.Aid
					  and d.AFTRid = #form.AFTRid#
					 )
			</cfquery>
		<script language="JavaScript1.2">
			if (window.opener.funcfiltro) {window.opener.funcfiltro()}
			window.close();
		</script>
	</cfif>
</cfif>