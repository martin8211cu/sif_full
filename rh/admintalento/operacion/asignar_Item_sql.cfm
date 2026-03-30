

<cfif isdefined("form.CHK") and len(trim(form.CHK)) and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo eq 'C'>
	<cftransaction>
		<cfset listaCHK = ListToArray(FORM.CHK)>
		<cfloop from="1" to="#ArrayLen(listaCHK)#" index="i">
			<cfquery name="insert" datasource="#Session.DSN#">
					insert into RHItemEvaluar 
					(	Ecodigo,
						RHEid, 
						RHHid, 
						RHOSid, 
						RHIEorden, 
						RHIEfinicio, 
						RHIEffin, 
						RHIEestado, 
						RHIEporcentaje, 
						RHIEpeso, 
						BMUsucodigo, 
						BMfechaalta
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#listaCHK[i]#">,
						null,
						1,
						null,
						null,
						null,
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)				
			</cfquery>
		</cfloop>
	</cftransaction>
	
<cfelseif isdefined("form.RHIEid") and len(trim(form.RHIEid)) and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo eq 'C'>
	<cfquery name="delete" datasource="#Session.DSN#">
		delete from RHItemEvaluar 
		where RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIEid#">
	</cfquery>
<cfelseif isdefined("form.ALTA")   and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo neq 'C'>
	<cfquery name="rsObjetivo" datasource="#session.DSN#">
		select RHOSporcentaje,RHOSpeso from RHObjetivosSeguimiento 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOSid#">
	</cfquery>
	
	<cfset RHIEffin = CreateDateTime(year(LSParseDateTime(form.RHIEffin)), month(LSParseDateTime(form.RHIEffin)), day(LSParseDateTime(form.RHIEffin)), 23, 59,59)>
	<cfquery name="insert" datasource="#Session.DSN#">
		insert into RHItemEvaluar 
		(	Ecodigo,
			RHEid, 
			RHHid, 
			RHOSid, 
			RHIEorden, 
			RHIEfinicio, 
			RHIEffin, 
			RHIEestado, 
			RHIEporcentaje, 
			RHIEpeso, 
			BMUsucodigo, 
			BMfechaalta
		)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
			null,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOSid#">,
			1,
			<cfqueryparam  cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHIEfinicio)#">,
			<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#RHIEffin#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHIEporcentaje, ',','','all')#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#rsObjetivo.RHOSpeso#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)				
	</cfquery>
<cfelseif isdefined("form.BAJA")   and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo neq 'C'>
	<cfquery name="delete" datasource="#Session.DSN#">
		delete from RHItemEvaluar 
		where RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIEid#">
	</cfquery>
	<cfset form.RHIEid	 =  "" >
<cfelseif isdefined("form.CAMBIO") and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo neq 'C'>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="RHItemEvaluar"
		redirect="registro_evaluacion.cfm"
		timestamp="#form.ts_rversion#"
		field1="RHIEid" 
		type1="numeric" 
		value1="#form.RHIEid#"
	>	
	<cfset RHIEffin = CreateDateTime(year(LSParseDateTime(form.RHIEffin)), month(LSParseDateTime(form.RHIEffin)), day(LSParseDateTime(form.RHIEffin)), 23, 59,59)>
	<cfquery name="insert" datasource="#Session.DSN#">
			update RHItemEvaluar
			set RHIEfinicio = <cfqueryparam  cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHIEfinicio)#">,
			RHIEffin        = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#RHIEffin#">,
			RHIEporcentaje  = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHIEporcentaje, ',','','all')#">
			where RHIEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIEid#">
	</cfquery>		
<cfelseif isdefined("form.BTNREGRESAR") or  isdefined("form.REGRESAR")>
	<cfset form.SEL =  form.SEL -1 >
<cfelseif isdefined("form.BTNSIGUIENTE") or  isdefined("form.SIGUIENTE")>
	<cfset form.SEL =  form.SEL +1 >
<cfelseif isdefined("form.NUEVO")>
	<cfset form.RHIEid	 =  "" >
</cfif>
<cfoutput>


<form action="registro_evaluacion.cfm" method="post" name="sql">
	<input name="RHRSid" type="hidden" value="#form.RHRSid#">
	<input name="SEL" type="hidden" value="#form.SEL#">
	<cfif isdefined("form.RHIEid") and len(trim(form.RHIEid)) and isdefined("form.RHRStipo") and len(trim(form.RHRStipo)) and form.RHRStipo neq 'C'>
		<input name="RHIEid" type="hidden" value="#form.RHIEid#">
	</cfif>
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

