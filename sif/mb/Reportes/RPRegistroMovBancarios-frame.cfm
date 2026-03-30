<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Nuevo reporte de Movimientos bancarios
----------->

<cfif isdefined("url.EMid") and  not isdefined("form.EMid")>
	<cfset form.EMid = url.EMid>
</cfif>
<cfif isdefined("url.formato") and  not isdefined("form.formato")>
	<cfset form.formato = url.formato>
</cfif>

<cfif isdefined('form.formato')>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.EMfecha, a.EMdocumento, a.EMtipocambio, b.DMdescripcion,b.DMmonto,c.BTdescripcion, d.CBdescripcion, 
				e.Bdescripcion, f.Mnombre, g.Cformato, h.Edescripcion
		from EMovimientos a inner join DMovimientos b
		  on a.Ecodigo = b.Ecodigo and 
			 a.EMid = b.EMid left outer join BTransacciones c
		  on a.Ecodigo = c.Ecodigo and
			 a.BTid = c.BTid left outer join CuentasBancos d
		  on a.Ecodigo = d.Ecodigo and
			 a.CBid = d.CBid left outer join Bancos e
		  on d.Ecodigo = e.Ecodigo and
			 d.Bid = e.Bid left outer join Monedas f
		  on d.Ecodigo = f.Ecodigo and
			 d.Mcodigo = f.Mcodigo left outer join CContables g
		  on d.Ecodigo = g.Ecodigo and 
			 b.Ccuenta = g.Ccuenta left outer join Empresas h
		  on a.Ecodigo = h.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and coalesce(d.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">
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
				typeReport = typeRep
				fileName = "mb.consultas.RPRegistroMovBancarios"/>
	<cfelse>
	    <cfreport format="#form.formato#" template= "RPRegistroMovBancarios.cfr" query="rsReporte">
	</cfif>
</cfif>