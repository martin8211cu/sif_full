<cfif isdefined("url.final") and not len(trim(url.final))>
	<cfquery name="rsFinal" datasource="#session.DSN#">
		select max(f.TESCFDnumFormulario) as consecutivo 
		from TEScontrolFormulariosD f
			inner join CuentasBancos cb
			on cb.CBid=f.CBid
			and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
       	where
        	cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfif len(trim(rsFinal.consecutivo))>
		<cfset url.final = rsFinal.consecutivo >
	<cfelse>
		<cfset url.final = url.inicio >
	</cfif>
</cfif>

<cfif url.inicio gt url.final>
	<cfset tmp = url.inicio >
	<cfset url.inicio = url.final >
	<cfset url.final = tmp >
</cfif> 
<!--- Variables para validar las fechas --->
<cfset LvarFecha1 = "">
<cfset LvarFecha2 = "">
<cfquery name="rsReporte" datasource="#session.DSN#"  maxrows="5000">
	select f.TESCFDnumFormulario as consecutivo, 
			f.CBid, 
			cb.CBcodigo, 
			cb.CBdescripcion,
			case f.TESCFDestado 
				when 0 then 'Preparación' 
				when 1 then 'Posteado' 
				when 2 then 'Entregado' 
				when 3 then 'Anulado'  
				end 
			  as estado,
			case f.TESCFDestado 
            <!--- Cuando esta en estado Anulado se utiliza la fecha de Anulación en caso de que este sino la de emision--->
				when 3 then coalesce(f.TESCFDfechaAnulacion, f.TESCFDfechaEmision) 
			<!--- Cuando esta en estado Entregado se utiliza la fecha de entrega en caso de que este sino la de emision--->
				when 2 then coalesce(f.TESCFDentregadoFecha,f.TESCFDfechaEmision) 
			    else f.TESCFDfechaEmision 
			  end as fecha,
			op.TESOPbeneficiario as beneficiario,
			op.TESOPtotalPago
	from TEScontrolFormulariosD f
	
	inner join CuentasBancos cb
	on cb.CBid=f.CBid
	and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    	
	left join TEScontrolFormulariosL l
	on l.TESid=f.TESid
	and l.CBid=f.CBid
	and l.TESMPcodigo=f.TESMPcodigo
	and l.TESCFLid=f.TESCFLid
	
	inner join Bancos b
	on b.Bid=cb.Bid
	and b.Ecodigo=cb.Ecodigo
	
	left outer join TESordenPago op
	on op.TESOPid=f.TESOPid
	
	where
	<cfif #url.final# NEQ '0'> <!--- Si el filtro es Inicio= 0 y final = 0  no se toman en cuenta estos rangos --->
	f.TESCFDnumFormulario between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.inicio#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#url.final#">	and
	</cfif>
	f.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
    and (case f.TESCFDestado when 3 then coalesce(f.TESCFDfechaAnulacion, f.TESCFDfechaEmision) when 2 then coalesce(f.TESCFDentregadoFecha,f.TESCFDfechaEmision) else f.TESCFDfechaEmision end) is not null	
	<!--- Fechas Desde / Hasta --->
	 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
		<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
        	<cfset LvarFecha1 =  lsparsedatetime(url.fechaDes)>
			<cfset LvarFecha2 =  lsparsedatetime(url.fechaHas)>
		<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
			<cfset LvarFecha1 =  lsparsedatetime(url.fechaHas)>
            <cfset LvarFecha2 =  lsparsedatetime(url.fechaDes)>
		<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
			<cfset LvarFecha1 =  lsparsedatetime(url.fechaDes)>
			<cfset LvarFecha2 =  LvarFecha1>
		</cfif>
       <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
			and f.TESCFDfechaEmision between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
	<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
		and f.TESCFDfechaEmision >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(url.fechaDes)#">
	<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
     	<cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
        <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
			and f.TESCFDfechaEmision <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
	</cfif>
	order by  f.TESCFDnumFormulario
</cfquery>

<cfif rsReporte.recordcount gt 0>
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
		fileName = "tesoreria.reportes.reporteConsecutivoCheques"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "reporteConsecutivoCheques.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.Enombre#">
			<cfreportparam name="inicio" value="#url.inicio#">
			<cfreportparam name="final" value="#url.final#">
		</cfreport>
	</cfif>
<cfelse>
	<cfquery name="cuenta" datasource="#session.DSN#">
		select a.CBcodigo, a.CBdescripcion
		from CuentasBancos a
		where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	
	<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Consecutivo de Cheques'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<table align="center" width="100%" cellpadding="3" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>Reporte de Consecutivo de Cheques</strong></td></tr>
				<tr><td align="center"><strong>Cuenta Bancaria:</strong> #cuenta.CBcodigo#</td></tr>
				<tr><td align="center"><strong>Consecutivos:</strong> #url.inicio# - #url.final#</td></tr>
				<tr><td align="center">----- No se encontraron registros -----</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cf_botones tabindex="1" regresar="reporteConsecutivoCheques-filtro.cfm" exclude="Alta,Limpiar"></td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
</cfif>