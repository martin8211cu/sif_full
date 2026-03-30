<cfif isdefined("form.chk") and len(trim(form.chk))>

	<cfquery name="data_relacion" datasource="#session.DSN#">
		select cp.CPcodigo, a.RChasta
		from HRCalculoNomina a
		
		inner join CalendarioPagos cp
		on cp.CPid=a.RCNid
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
	</cfquery>
	
	<cfquery name="data_empresa" datasource="asp">
		select e.Enumero, e.Eidentificacion
		from Empresa e
		
		inner join Caches c
		on c.Cid=e.Cid
		and c.Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DSN#">
		
		where e.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>

	<cfquery name="data" datasource="#session.DSN#">
		select 	'RHPN' as origen,													<!--- origen --->
				1 as constante,														<!--- constante --->
				'#data_relacion.CPcodigo#' as documento,							<!--- CPcodigo --->
				#form.chk# as RCNid, 												<!--- referencia --->
				sum(round(a.montores*coalesce(n.RCtc, 1),2)) as monto_tc,			<!--- monto con tipo de cambio sum(round(a.montores*#LvarTC#,2)), --->
				a.tipo, 															<!--- tipo --->
				case when cm.Ctipo = 'G' then cf.CFcodigo else '' end as CFcodigo, 	<!--- centro funcional --->
				'#LSDateFormat(data_relacion.RChasta, "yyyymmdd")#' as RChasta,		<!--- fecha de la relacion --->
				1 as tc, 															<!--- #LvarTC# de donde lo saco ---> 
				1 as Mcodigo,		 												<!--- #LvarMcodigo# de donde lo saco ---> 
				a.Ocodigo,															<!--- oficina --->
				sum(round(a.montores, 2)) * case tipo when 'C' then -1 else 1 end as monto,				<!--- monto origen --->
				a.Ccuenta, 															<!--- cuenta contable --->
				{fn concat(substring(cc.Cformato,1,4),substring(cc.Cformato,6,4))} as Cformato,
				a.CFcuenta															<!--- cuenta financiera --->
		
		from RCuentasTipo a
		
		inner join HRCalculoNomina n
		on n.RCNid=a.RCNid
		
		inner join CFuncional cf
		on cf.CFid = a.CFid
		
		inner join CContables cc
		on cc.Ccuenta=a.Ccuenta
		
		inner join CtasMayor cm
		on cc.Cmayor = cm.Cmayor
		and cc.Ecodigo = cm.Ecodigo
		
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		group by a.tipo, a.tiporeg, a.Ocodigo, a.Ccuenta, cc.Cformato, a.CFcuenta, cf.CFcodigo, cm.Ctipo
		having sum(round(a.montores, 2)) != 0
		order by a.tipo desc, a.tiporeg, a.Ocodigo, cf.CFcodigo
		
	</cfquery>
	
	<cfif data.recordcount gt 0 >
		<cfset resultado = '' >
		<cfoutput query="data">
			<cfset resultado = resultado & '#trim(data_empresa.Enumero)#;#trim(data.Cformato)#;#trim(data.CFcodigo)#;;#LSNumberFormat(data.monto, '9.00')##chr(13)##chr(10)#' >
		</cfoutput>

		<!--- ============================================================================================= --->
		<!--- Generacion de Archivo TXT --->
		<!--- ============================================================================================= --->		
		<cfset archivo = "#trim(data_relacion.CPcodigo)#_#hour(now())##minute(now())##second(now())#">
		<!---<cfset fullpath = "#expandpath('/rh/nomina/operacion/#archivo#')#" >--->
		<!---<cfset txtfile = "#expandpath('/rh/nomina/operacion/#archivo#.txt')#">--->
		<cfset txtfile = GetTempFile(getTempDirectory(), 'relcalc')>
		
		<!---<cfif Not DirectoryExists(fullpath)><cfdirectory action="create" directory="#fullpath#"></cfif>--->
		<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#resultado#" charset="utf-8">
		<cfheader name="Content-Disposition" value="attachment;filename=RelacionCalculo.txt">
		<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
	<cfelse>
		<cfset no_data = 1 >
	</cfif>
</cfif>

<cfset navegacion = '' >
<cfif isdefined("form.fTcodigo") and len(trim(form.fTcodigo))>
	<cfset navegacion = navegacion & '&fTcodigo=#trim(form.fTcodigo)#' >
</cfif>
<cfif isdefined("form.fCPcodigo") and len(trim(form.fCPcodigo))>
	<cfset navegacion = navegacion & '&fCPcodigo=#trim(form.fCPcodigo)#' >
</cfif>
<cfif isdefined("form.fecha1") and len(trim(form.fecha1))>
	<cfset navegacion = navegacion & '&fecha1=#trim(form.fecha1)#' >
</cfif>
<cfif isdefined("form.fecha2") and len(trim(form.fecha2))>
	<cfset navegacion = navegacion & '&fecha2=#trim(form.fecha2)#' >
</cfif>
<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
	<cfset navegacion = navegacion & '&pageNum_lista=#form.pageNum_lista#' >
</cfif>
<!---
<cfif isdefined("no_data")>
	<cfset navegacion = navegacion & '&no_data=1' >
</cfif>
--->

<cflocation url="exportarRelacionCalculo.cfm?ok=true#navegacion#">
