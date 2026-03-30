<!---
	Modificado por Gustavo Fonseca H.
		Fecha: 6-9-2005.
		Motivo: Se corrige el query pues filtraba por el SNnombre y debe filtrar por el SNnumero que es el número que se ve en la pantalla,
		además se prevee si por alguna razón falla la validacion de los rangos del socio en el fuente EstadoCuenta.cfm para que actue como se espera.
 --->
<!--- Las Fechas Son Requeridas --->
<cfif isdefined("url.fecha1") and not isdefined("Form.fecha1")>
	<cfparam name="Form.fecha1" default="#url.fecha1#">
</cfif>
<cfif isdefined("url.fecha2") and not isdefined("Form.fecha2")>
	<cfparam name="Form.fecha2" default="#url.fecha2#">
</cfif>
<!--- Los Nombres No Son Requeridos --->
<cfif isdefined("url.SNnombre1") and not isdefined("Form.SNnombre1")>
	<cfparam name="Form.SNnombre1" default="#url.SNnombre1#">
</cfif>
<cfif isdefined("url.SNnombre2") and not isdefined("Form.SNnombre2")>
	<cfparam name="Form.SNnombre2" default="#url.SNnombre2#">
</cfif>

<cfif isdefined("url.SNnumero1") and not isdefined("Form.SNnumero1")>
	<cfparam name="Form.SNnumero1" default="#url.SNnumero1#">
</cfif>
<cfif isdefined("url.SNnumero2") and not isdefined("Form.SNnumero2")>
	<cfparam name="Form.SNnumero2" default="#url.SNnumero2#">
</cfif>
<cf_dbfunction name="date_format"	args="a.Dfecha,DD/MM/YYYY" returnvariable="Dfecha">
<!--- Consulta ---> 
<cfquery name="rsData" datasource="#Session.DSN#">
	<!--- Facturas --->
	select sn.SNnumero, sn.SNnombre, a.CPTcodigo, t1.CPTdescripcion, a.Ddocumento, a.Dtotal as Dtotal, a.Mcodigo as Mcodigo, a.Dfecha,
	'1. Creación' as Movimiento, t1.CPTtipo, a.CPTRcodigo, a.DRdocumento
	from BMovimientosCxP a
	 inner join CPTransacciones t1
	 	 on t1.Ecodigo   = a.Ecodigo
		and t1.CPTcodigo = a.CPTcodigo
	 inner join SNegocios sn
	 	on  sn.Ecodigo  = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
	where a.Ecodigo =  #session.ecodigo#
		and a.CPTcodigo  = a.CPTRcodigo
		and a.Ddocumento = a.DRdocumento
		and t1.CPTtipo = 'C'
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>

		<!--- Fechas Desde / Hasta --->
		<cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
		 	and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif>

	union all
	<!--- Saldo de NC --->
	select sn.SNnumero, sn.SNnombre, a.CPTcodigo, t1.CPTdescripcion, a.Ddocumento,
	a.Dtotal
	<!--- MEGS: Por indicacion de funcional Marcos Díaz, se quita este descuento --->
	<!--- -
	(select sum(s.Dtotal)
		from BMovimientosCxP s
		where s.Ecodigo = a.Ecodigo
		and s.SNcodigo = a.SNcodigo
		and s.CPTcodigo = a.CPTcodigo
		and s.Ddocumento = a.Ddocumento
		and (s.CPTcodigo <> s.CPTRcodigo or s.Ddocumento <> s.DRdocumento))
	as Dtotal --->, a.Mcodigo as Mcodigo, a.Dfecha,
	'1. Creación' as Movimiento, t1.CPTtipo, a.CPTRcodigo, a.DRdocumento
	from BMovimientosCxP a
	 inner join CPTransacciones t1
	 	 on t1.Ecodigo   = a.Ecodigo
		and t1.CPTcodigo = a.CPTcodigo
	 inner join SNegocios sn
	 	on  sn.Ecodigo  = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
	where a.Ecodigo =  #session.ecodigo#
		and a.CPTcodigo  = a.CPTRcodigo
		and a.Ddocumento = a.DRdocumento
		and t1.CPTtipo = 'D'
		and t1.CPTpago = 0
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>

		<!--- Fechas Desde / Hasta --->
		<cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
		 	and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif>

	union all
	<!--- Pagos --->
	select sn.SNnumero, sn.SNnombre, a.CPTcodigo, t1.CPTdescripcion, a.Ddocumento, coalesce(a.BMmontoref,a.Dtotal) as Dtotal, coalesce(a.Mcodigoref,a.Mcodigo) as Mcodigo, a.Dfecha,
	'2. Creación Credito' , t1.CPTtipo, a.CPTRcodigo, a.DRdocumento
	from BMovimientosCxP a
		inner join CPTransacciones t1
			on t1.Ecodigo   = a.Ecodigo
		   and t1.CPTcodigo = a.CPTcodigo
		inner join CPTransacciones t2
		   on t2.CPTcodigo = a.CPTRcodigo
		  and t2.Ecodigo   = a.Ecodigo
		inner join SNegocios sn
			on sn.Ecodigo = a.Ecodigo
		   and sn.SNcodigo = a.SNcodigo
	where a.Ecodigo =  #session.ecodigo#
		and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CPTpago = 1
		and t1.CPTtipo = 'D'
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>

		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>

		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
		 	and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		 <cfelseif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif>

	union all
	<!--- Neteos --->
	select sn.SNnumero, sn.SNnombre, a.CPTRcodigo, t2.CPTdescripcion, a.DRdocumento, coalesce(a.BMmontoref,a.Dtotal) as Dtotal, coalesce(a.Mcodigoref,a.Mcodigo) as Mcodigo, a.Dfecha,
	<cf_dbfunction name="concat" args="'3. Aplicación',a.CPTcodigo,' ',a.Ddocumento">,
	case t2.CPTtipo when 'D' then 'C' else 'D' end, a.CPTcodigo, a.Ddocumento
	from BMovimientosCxP a
		inner join CCTransacciones t1
			on  t1.Ecodigo   = a.Ecodigo
		   and  t1.CCTcodigo = a.CPTcodigo
	 	inner join CPTransacciones t2
			on t2.Ecodigo   = a.Ecodigo
		   and t2.CPTcodigo = a.CPTRcodigo
		inner join SNegocios sn
			on sn.Ecodigo  = a.Ecodigo
		   and sn.SNcodigo = a.SNcodigo
	where a.Ecodigo =  #session.ecodigo#
		and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CCTtranneteo = 1
		and t2.CPTpago = 0
		and upper(sn.SNnumero)

		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>

		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>

		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
		 	and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		 <cfelseif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif>


	<!--- Aplicacion de NC --->
	<cfif isdefined("form.IncluirAfecNC") AND form.IncluirAfecNC eq 1>
	union all
	select sn.SNnumero, sn.SNnombre, a.CPTcodigo, t1.CPTdescripcion, a.Ddocumento, coalesce(a.BMmontoref,a.Dtotal) as Dtotal, coalesce(a.Mcodigoref,a.Mcodigo) as Mcodigo, a.Dfecha,
	<cf_dbfunction name="concat" args="'3. Aplicación',a.CPTRcodigo,' ',a.DRdocumento">, t1.CPTtipo, a.CPTRcodigo, a.DRdocumento
	from BMovimientosCxP a
		inner join CPTransacciones t1
			on t1.Ecodigo   = a.Ecodigo
		   and t1.CPTcodigo = a.CPTcodigo
		inner join CPTransacciones t2
			on t2.Ecodigo   = a.Ecodigo
		   and t2.CPTcodigo = a.CPTRcodigo
		inner join SNegocios sn
			on sn.Ecodigo = a.Ecodigo
		   and sn.SNcodigo = a.SNcodigo
	where a.Ecodigo =   #session.ecodigo#
		and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CPTtipo = 'D'
		and t1.CPTpago = 0
		and t2.CPTpago = 0
		and upper(sn.SNnumero)

		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>

		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>

		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
		 	and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		 <cfelseif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		 <cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		 <cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		 </cfif>
		order by 7,1,9
	</cfif>
</cfquery>

<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mcodigo, Mnombre
	 from Monedas
	where Ecodigo =  #session.ecodigo#
</cfquery>

<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
</style>
<br>
<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">Integración de Saldos Resumido en Cuentas por Pagar</td>
		</tr>
		<tr>
			<td class="style2">
				<cfif isdefined("Form.fecha1") and Len(Trim(Form.fecha1)) NEQ 0>
					Desde: #LSDateFormat(Form.fecha1, 'dd/mm/yyyy')# &nbsp;
				<cfelse>
					Desde: Inicio &nbsp;
				</cfif>
				<cfif isdefined("Form.fecha2") and Len(Trim(Form.fecha2)) NEQ 0>
					Hasta: #LSDateFormat(Form.fecha2, 'dd/mm/yyyy')#
				<cfelse>
					Hasta: #LSdateFormat(Now(),'dd/mm/yyyy')#
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="style3">
				Clientes:
				<cfif Len(Trim(Form.SNnombre1)) EQ 0 and Len(Trim(Form.SNnombre2)) EQ 0>
					Todos
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0 and Len(Trim(Form.SNnombre2)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i> Hasta <i>#Form.SNnombre2#</i>
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i>
				<cfelseif Len(Trim(Form.SNnombre2)) NEQ 0>
					Hasta <i>#Form.SNnombre2#</i>
				</cfif>
			</td>
		</tr>
		<cfif isdefined("form.SaldoI") AND form.SaldoI eq 1>
			<tr>
				<td class="style3">
					Incluye Saldo Inicial
				</td>
			</tr>
		</cfif>
	</table>
</cfoutput>
<br>

<cfquery name="q_monedas" dbtype="query">
	select distinct Mcodigo from rsData
</cfquery>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="tituloListas">Moneda</td>
        <td class="tituloListas" align="right">Cantidad</td>
        <td class="tituloListas" align="right">Saldo Inicial</td>
        <td class="tituloListas" align="right">Débitos</td>
        <td class="tituloListas" align="right">Créditos</td>
        <td class="tituloListas" align="right">Saldo Final</td>
    </tr>
    <cfloop query="#q_monedas#">
        <cfquery name="q_Socio" dbtype="query">
            select distinct SNnumero, Mcodigo, SNnombre from rsData where Mcodigo = #q_monedas.Mcodigo#
        </cfquery>
        <cfset Lvar_mcantidad = 0>
        <cfset Lvar_msaldoinicial = 0.00>
        <cfset Lvar_mdocumentos = 0.00>
        <cfset Lvar_mpagos = 0.00>
        <cfset Lvar_msaldo = 0.00>
        <cfquery dbtype="query" name="rsMoneda">
            select Mnombre from rsMonedas where Mcodigo = <cfif len(Mcodigo)>#Mcodigo#<cfelse>-1</cfif>
        </cfquery>
        <cfoutput>
        <tr class="listaCorte">
            <td style="border-top: 1px solid black;" class="listaCorte" align="left" colspan="6" nowrap >
                <cfif rsMoneda.recordcount and len(rsMoneda.Mnombre)>#rsMoneda.Mnombre#<cfelse>Desconocida</cfif>
            </td>
        </tr>
        </cfoutput>
        <cfset SNnombre = "">
        <cfloop query="#q_Socio#">
            <cfquery name="q_data" dbtype="query">
                select * from rsData 
                where Mcodigo = #q_monedas.Mcodigo#
                and SNnumero = '#q_Socio.SNnumero#'
            </cfquery>
            <cfset SNnombre = "#q_socio.SNnombre#">
            <cfset Lvar_cantidad = 0>
            <cfset Lvar_saldoinicial = 0.00>
            <cfset Lvar_documentos = 0.00>
            <cfset Lvar_pagos = 0.00>
            <cfset Lvar_saldo = 0.00>
            
            <cfloop query="#q_data#">
                
                <cfif len(q_data.Dtotal) and IsNumeric(q_data.Dtotal) and q_data.Dtotal gt 0.00>
                    <cfif DateCompare(q_data.Dfecha,LSParseDateTime(form.fecha1)) lt 0>
                        <cfif q_data.CPTtipo eq 'C'>
                            <cfset Lvar_saldoinicial = Lvar_saldoinicial - q_data.Dtotal>
                        <cfelse>
                            <cfset Lvar_saldoinicial =  Lvar_saldoinicial + q_data.Dtotal>
                        </cfif>
                    <cfelse>
                        <cfif q_data.CPTtipo eq 'C'>
                            <cfset Lvar_documentos = Lvar_documentos + q_data.Dtotal>
                        <cfelse>
                            <cfset Lvar_pagos = Lvar_pagos + q_data.Dtotal>
                        </cfif>
                    </cfif>
                    <cfif q_data.CPTtipo eq 'C'>
                        <cfset Lvar_saldo = Lvar_saldo - q_data.Dtotal>
                    <cfelse>
                        <cfset Lvar_saldo = Lvar_saldo + q_data.Dtotal>
                    </cfif>
                </cfif>
                <cfset Lvar_cantidad = Lvar_cantidad + 1>
                
            </cfloop>
            <cfoutput>
                <tr>
                    <td>#SNnombre#</td>
                    <td align="right">#Lvar_cantidad#</td>
                    <td align="right">#LSCurrencyFormat(Lvar_saldoinicial,'none')#</td>
                    <td align="right">#LSCurrencyFormat(Lvar_pagos,'none')#</td>
                    <td align="right">#LSCurrencyFormat(Lvar_documentos,'none')#</td>
                    <td align="right">#LSCurrencyFormat(Lvar_saldoinicial+Lvar_pagos-Lvar_documentos,'none')#</td>
                </tr>
            </cfoutput>
            <cfset Lvar_mcantidad = Lvar_mcantidad + Lvar_cantidad>
            <cfset Lvar_msaldoinicial = Lvar_msaldoinicial + Lvar_saldoinicial>
            <cfset Lvar_mdocumentos = Lvar_mdocumentos + Lvar_documentos>
            <cfset Lvar_mpagos = Lvar_mpagos + Lvar_pagos>
            <cfset Lvar_msaldo = Lvar_msaldo + Lvar_saldo>
        </cfloop>
        <cfoutput>
        <tr class="listaCorte">
            <td style="border-bottom: 1px solid black; " nowrap><strong>Total <cfif rsMoneda.recordcount and len(rsMoneda.Mnombre)>#rsMoneda.Mnombre#<cfelse>Desconocida</cfif></strong></td>
            <td style="border-bottom: 1px solid black; " align="right"><strong>#Lvar_mcantidad#</strong></td>
            <td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(Lvar_msaldoinicial,'none')#</strong></td>
            <td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(Lvar_mpagos,'none')#</strong></td>
            <td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(Lvar_mdocumentos,'none')#</strong></td>
            <td style="border-bottom: 1px solid black; " nowrap align="right"><strong>#LSCurrencyFormat(Lvar_msaldoinicial+Lvar_mpagos-Lvar_mdocumentos,'none')#</strong></td>
        </tr>

        </cfoutput>
    </cfloop>

</table>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>
