
<cfif isdefined("url.Bid") and  not isdefined("form.Bid")>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif isdefined("url.CBid") and  not isdefined("form.CBid")>
	<cfset form.CBid = url.CBid>
</cfif>
<cfif isdefined("url.formato") and  not isdefined("form.formato")>
	<cfset form.formato = url.formato>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- <cfdump var="#form#"> --->
<cfif isdefined('form.formato') and isdefined('form.Bid') and isdefined('form.CBid')>
	<cfquery name="rsLibrosSinConciliar" datasource="#session.DSN#">
		select CDLdocumento, BTdescripcion ,CDLfecha as fechalibros, CDLmonto
		from ECuentaBancaria a left outer join CDLibros b
		  on a.ECid = b.ECid and 
			 b.CDLconciliado = 'N' left outer join BTransacciones c
		  on b.CDLidtrans = c.BTid
		where a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		  and a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
				select Pvalor as valParam
				from Parametros
				where Pcodigo = 20007
				and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
		<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			<cfset typeRep = 1>
			<cfif form.formato EQ "pdf">
				<cfset typeRep = 2>
			</cfif>
			<cf_js_reports_service_tag queryReport = "#rsLibrosSinConciliar#" 
				isLink = False 
				typeReport = typeRep
				fileName = "mb.consultas.RPPartidasSinConciliar"/>
		<cfelse>
	<cfreport format="#form.formato#" template= "RPPartidasSinConciliar.cfr" query="rsLibrosSinConciliar">
	<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
		<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
	</cfif>
	</cfreport>
	</cfif>
<cfelse>
	<table align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center">-----No hay datos para reportar-----</td></tr>
	</table>
</cfif>