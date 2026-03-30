<cfset error = false >

<cftransaction>
	<cftry>
	<!--- copia los encabezados --->
	<cfquery name="rsFeriados" datasource="#session.DSN#">
		select convert(varchar, RHFid) as RHFid, Ecodigo, convert(varchar, dateadd(yy, 1, RHFfecha), 103) as RHFfecha, RHFdescripcion, RHFregional
		from RHFeriados
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
		  and datepart(yy, RHFfecha) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ano#">
	</cfquery>
	
	<cfloop query="rsFeriados">
		<cfquery name="insertFeriados" datasource="#session.DSN#" >
			<!--- inserta encabezado de feriados --->
			insert RHFeriados (Ecodigo, RHFfecha, RHFdescripcion, RHFregional)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFeriados.Ecodigo#">,
					 convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFeriados.RHFfecha#">, 103),
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFeriados.RHFdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#rsFeriados.RHFregional#">
			)
			declare @RHFid numeric
			select @RHFid = @@identity
			
			insert RHDFeriados ( RHFid, Ecodigo, Ocodigo )
			select @RHFid, Ecodigo, Ocodigo
			from RHDFeriados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			  and RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFeriados.RHFid#" >
		</cfquery>

	</cfloop>
	<cfcatch type="any">
		<cfset error = true >
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>

<cfoutput>

<form action="CopiarFeriados.cfm" method="post" name="sql">
	<input name="sql_ok"   type="hidden" value="#error#">
</form>

</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>