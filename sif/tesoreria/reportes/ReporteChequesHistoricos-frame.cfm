<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	frame para el nuevo reporte de Estados de Cuenta Bancario
----------->

<cfif isdefined("url.ECid") and  not isdefined("form.ECid")>
	<cfset form.ECid = url.ECid>
</cfif>
<cfif isdefined("url.formato") and  not isdefined("form.formato")>
	<cfset form.formato = url.formato>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined('form.formato') and isdefined('form.ECid')>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		
		select ECdescripcion, ECfecha, CBdescripcion, Bdescripcion, ECsaldoini, ECsaldofin, Mnombre,BTdescripcion, 
			   Documento, DCfecha, DCReferencia, DCmontoori
		from ECuentaBancaria a left outer join DCuentaBancaria b
		  on a.ECid = b.ECid left outer join Bancos c
		  on a.Bid = c.Bid left outer join CuentasBancos d
		  on a.Bid = c.Bid and
			 c.Bid = d.Bid and
			 a.CBid = d.CBid left outer join Monedas e
		  on d.Ecodigo = e.Ecodigo and 
			 d.Mcodigo = e.Mcodigo left outer join BTransacciones f
		  on d.Ecodigo = f.Ecodigo and
			 b.BTid = f.BTid
		where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and coalesce(d.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and a.ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
  		group by ECdescripcion,ECfecha, CBdescripcion, Bdescripcion, ECsaldoini, ECsaldofin, Mnombre,BTdescripcion, Documento, DCfecha, DCReferencia, DCmontoori
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
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "tesoreria.reportes.RPRegistroEstadosCtas"/>
	<cfelse>
		<cfreport format="#form.formato#" template= "RPRegistroEstadosCtas.cfr" query="rsReporte">
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