<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfquery name="rsReporte" datasource="#session.DSN#">
	 select b.Bdescripcion,
			cb.CBcodigo,
			min(cb.CBdescripcion) as CBdescripcion,
			sn.SNnumero,
			min(sn.SNnombre) as SNnombre,
			sum(op.TESOPtotalPago) as monto
		from TEScontrolFormulariosD cf
		
		inner join TEScuentasBancos tcb
		on cf.TESid = tcb.TESid and
		cf.CBid = tcb.CBid
		
		inner join CuentasBancos cb
		on tcb.CBid = cb.CBid
		and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		
		inner join Monedas m
		on m.Mcodigo = cb.Mcodigo and
		m.Ecodigo = cb.Ecodigo
		
		inner join Bancos b
		on b.Ecodigo = cb.Ecodigo
		and b.Bid = cb.Bid
		and b.Bdescripcion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Bdescripcion_inicio#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Bdescripcion_final#">
		
		inner  join TESordenPago op
		on cf.TESOPid = op.TESOPid
		
		inner join SNegocios sn
		on sn.SNid=op.SNid
		and sn.SNnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.socioDesde#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.socioHasta#">
		
		inner join Empresas e
		on op.EcodigoPago = e.Ecodigo
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		inner join CContables cc
		on op.Ccuenta = cc.Ccuenta
		
		where cf.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
		and coalesce(( case cf.TESCFDestado when 2 then  cf. TESCFDentregadoFecha when 3 then cf.TESCFDfechaAnulacion else cf.TESCFDfechaEmision  end) , cf.TESCFDfechaEmision) between <cfqueryparam cfsqltype="cf_sql_date" value="#vInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#vFinal#">
		<cfif isdefined("url.CBid") and len(trim(url.CBid))>
			and cf.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
		</cfif>
		group by
			Bdescripcion,
			CBcodigo,
			CBdescripcion,
			SNnumero,
			SNnombre
		order by b.Bdescripcion, cb.CBcodigo, sn.SNnumero
</cfquery>

<cfif rsReporte.recordcount gt 0 >
		<cfif isdefined("url.CBid") and len(trim(url.CBid))>
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rsCuenta" datasource="#session.DSN#">
				select CBcodigo #_Cat# '-' #_Cat# CBdescripcion as Cuenta
				from CuentasBancos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
                and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
		</cfif>
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "tesoreria.reportes.reporteChequesHistoricosResumido"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "reporteChequesHistoricosResumido.cfr" query="rsReporte">
		<cfreportparam name="empresa" value="#session.Enombre#">
		<cfreportparam name="socioDesde" value="#trim(url.socioDesde)#">
		<cfreportparam name="socioHasta" value="#url.socioHasta#">
		<cfreportparam name="bancoDesde" value="#trim(url.Bdescripcion_inicio)#">
		<cfreportparam name="bancoHasta" value="#url.Bdescripcion_final#">
		<cfreportparam name="fechaDesde" value="#url.inicio#">
		<cfreportparam name="fechaHasta" value="#url.ffinal#">
		<cfif isdefined("rsCuenta") and rsCuenta.recordcount eq 1>
			<cfreportparam name="Cuenta" value="#rsCuenta.Cuenta#">
		<cfelse>
			<cfreportparam name="Cuenta" value="Todas">
		</cfif>
		
		</cfreport>
	</cfif>
<cfelse>
	<cfquery name="tesoreria" datasource="#session.DSN#">
		select TEScodigo, TESdescripcion
		from Tesoreria
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
	</cfquery>
	<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Cheques Hist&oacute;ricos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<table align="center" width="100%" cellpadding="3" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>Reporte de Cheques Hist&oacute;ricos</strong></td></tr>
				<tr><td align="center"><strong>Tesorer&iacute;a:</strong> #trim(tesoreria.TEScodigo)# - #trim(tesoreria.TESdescripcion)#</td></tr>
				<tr><td align="center">----- No se encontraron registros -----</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
</cfif>