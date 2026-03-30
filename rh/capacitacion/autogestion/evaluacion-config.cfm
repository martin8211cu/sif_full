<cfscript>
	formname="formlistaevaluaciones";
	if (isdefined("url.RHRCid") and len(trim(url.RHRCid)) and not isdefined("form.RHRCid")) {
		form.RHRCid = url.RHRCid;
	}
	if (isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")) {
		form.DEid = url.DEid;
	}
	if (isdefined("url.tab") and len(trim(url.tab)) and not isdefined("form.tab")) {
		form.tab = url.tab;
	}
	if (isdefined("form.RHRCid") and len(trim(form.RHRCid))) {
		formname="formlistaempleados";
	}	
	if (isdefined("form.RHRCid") and len(trim(form.RHRCid))
		and isdefined("form.DEid") and len(trim(form.DEid))) {
		formname="formevaluacion";
	}
	
	QueryString_lista = Iif(Len(Trim(CGI.QUERY_STRING)),DE("&"&CGI.QUERY_STRING),DE(""));
	
	tempPos=ListContainsNoCase(QueryString_lista,"RHRCid","&");
	navegacion = "";
	if (tempPos NEQ 0) {
		QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&");
	}
	if (isdefined("form.RHRCid") and len(trim(form.RHRCid))) {
		navegacion=navegacion&"&RHRCid="&form.RHRCid;
	}
	tempPos=ListContainsNoCase(QueryString_lista,"DEid","&");
	if (tempPos NEQ 0) {
		QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&");
	}	
	if (isdefined("form.DEid") and len(trim(form.DEid))) {
		navegacion=navegacion&"&DEid="&form.DEid;
	}
	tempPos=ListContainsNoCase(QueryString_lista,"tab","&");
	if (tempPos NEQ 0) {
		QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&");
	}	
	if (isdefined("form.tab") and len(trim(form.tab))) {
		navegacion=navegacion&"&tab="&form.tab;
	}
	if (isdefined("form.Filtro_DEidentificacion") and LEN(TRIM(form.Filtro_DEidentificacion))){
		navegacion=navegacion&"Filtro_DEidentificacion="&form.Filtro_DEidentificacion;
	}
</cfscript>

<cfif isdefined("form.RHRCid") and len(form.RHRCid)>
	<cfquery name="rsRHRC" datasource="#session.dsn#">
		select RHRCid, Ecodigo, RHRCdesc, RHRCfdesde, RHRCfhasta, RHRCfcorte, RHRCitems, RHRCestado, BMUsucodigo
		from RHRelacionCalificacion
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
</cfif>
<cfif isdefined("form.DEid") and len(form.DEid)>
	<cfquery name="rsDE" datasource="#session.dsn#">
		select a.RHRCid, a.CFid, a.DEid, a.RHPcodigo, c.DEidentificacion,
		{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )}, ' ' )}, c.DEnombre )}
		as DEnombrecompleto
		from RHEmpleadosCF a
			inner join DatosEmpleado c
				on c.DEid = a.DEid
		where a.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>
