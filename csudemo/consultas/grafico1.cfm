<cfquery name="grafico1" datasource="csulog">
	select a.CODCLIENTE , avg(COALESCE(TIMESTAMPDIFF(16, CHAR(TIMESTAMP(SUBSTR(b.FECDESPACHO,1,4)||'-'||SUBSTR(b.FECDESPACHO,5,2)||'-'||SUBSTR(b.FECDESPACHO,7,2)||'-00.00.00.00')-
		   							   		   TIMESTAMP(SUBSTR(a.FECESTENTREGA,1,4)||'-'||SUBSTR(a.FECESTENTREGA,5,2)||'-'||SUBSTR(a.FECESTENTREGA,7,2)||'-00.00.00.00'))),0)) as dias
	from ENCPED a
	left outer join ENCDESP b
	on b.CODCLIENTE = a.CODCLIENTE
	and a.NUMPEDIDO = b.NUMDESPACHO
	where a.FECREGISTRO between <cfqueryparam cfsqltype="cf_sql_varchar" value="#finicio#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ffinal#">
	<cfif isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE))>
		and a.CODCLIENTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CODCLIENTE#">
	</cfif>
	and b.FECDESPACHO is not null
	group by a.CODCLIENTE
</cfquery>
<cfoutput>
	<cfif grafico1.recordcount gt 0>
		<cfchart format="flash"  rotated="yes" scalefrom="0" scaleto="100"
			title="Tiempo de Despacho vs Entrega"
			chartwidth="300"
			chartheight="300"
			show3d="true"  >
			<cfloop  query="grafico1">
				<cfchartseries type="bar" seriesLabel="" markerstyle="rectangle" query="grafico1"  >
					<cfchartdata item="Cliente: #grafico1.CODCLIENTE#" value="#grafico1.dias#"/>
				</cfchartseries>
			</cfloop>
		</cfchart>
	 </cfif>
</cfoutput>

