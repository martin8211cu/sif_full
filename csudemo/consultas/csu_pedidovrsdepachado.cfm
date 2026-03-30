<!--- ////////////////////////////////////////////////////////// --->
<cfset ainicio = listtoarray(form.fechai,'/')>
<cfset afinal = listtoarray(form.fechaf,'/')>
<cfset finicio = createdate(ainicio[3],ainicio[2],ainicio[1]) >
<cfset ffinal = createdate(afinal[3],afinal[2],afinal[1]) >
<cfif datecompare(finicio, ffinal) gt 0>
	<cfset tmp = finicio >
	<cfset finicio = ffinal >
	<cfset ffinal = tmp >
</cfif>
<cfset finicio = LSDateFormat(finicio,'yyyymmdd') >
<cfset ffinal = LSDateFormat(ffinal,'yyyymmdd') >
<!--- ////////////////////////////////////////////////////////// --->
<cfquery name="Graph" datasource="csulog">
	select 
		  cast(a.TotCosto  as  numeric(15,2)) as TotCosto, 
		  ( select coalesce(sum(coalesce(cast(det.MONTOTOTDESPACHADO as  numeric(15,2)),0)),0)
		   	 from DETDESP det 
			 where det.CODCLIENTE=a.CODCLIENTE 
			   and det.NUMDESPACHO=a.NUMPEDIDO ) as totaldesp
	from ENCPED a
 	where a.FECREGISTRO between <cfqueryparam cfsqltype="cf_sql_varchar" value="#finicio#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ffinal#">
	<cfif isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE))>
		and a.CODCLIENTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CODCLIENTE#">
	</cfif>
</cfquery>

<cfquery name="RSGraph"  dbtype="query">
	select sum(TotCosto-totaldesp) as faltante, sum(TotCosto) as pedido,sum(totaldesp)as Despachado
	from Graph
</cfquery>

<cfoutput>
	<cfif RSGraph.recordcount gt 0 and  RSGraph.pedido gt 0>
		<cfchart format="flash" 
			title=" Monto Pedido : #LSNumberFormat(RSGraph.pedido,',9.00')#"
			chartwidth="300"
			chartheight="300"
			seriesplacement="stacked"
			show3d="true"
			>
			<cfchartseries type="pie" seriesLabel="x">
				<cfchartdata item="Faltante" value="#RSGraph.faltante#"/>
				<cfchartdata item="Despachado" value="#RSGraph.Despachado#"/>
			</cfchartseries>
		</cfchart>
	 </cfif>
</cfoutput>