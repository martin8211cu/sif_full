<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
<cfparam name="form.id" default="">
<cfparam name="form.ni" default="">
<cfparam name="form.sc" default="">
<cfparam name="form.msg" default="">
<cfparam name="form.cmd" default="">
<cfif isdefined("form.cmdV")>
	<cfset LvarSoloConsultar = true>
	<cfset form.cmd="V">
</cfif>
<cfif isdefined("url.cmd") AND url.cmd EQ "V">
	<cfset form.id = url.id>
	<cfset form.ni=url.ni>
	<cfset form.sc="0">
	<cfset form.msg="0">
	<cfset form.cmd="V">
</cfif>

<cfif Len(Trim(form.id)) AND Len(Trim(form.ni)) AND Len(Trim(form.sc)) AND Len(Trim(form.msg)) and Len(Trim(form.cmd))>
	<cfif form.cmd EQ "C">
		<cfset LobjColaProcesos.fnProcesoCancelar (form.NI,form.ID,form.SC,form.MSG)>
	<cfelseif form.cmd EQ "R">
		<cfset LobjColaProcesos.fnProcesoReprocesar (form.NI,form.ID,form.SC)>
	<cfelseif form.cmd EQ "SP">
		<cftry>
			<cfset LobjColaProcesos.sbProcesoSpFinal (session.CEcodigo,form.NI,form.ID,form.SC)>
			<cfset LobjColaProcesos.fnProcesoFinalizarConExito (form.NI,form.ID,form.SC)>
		<cfcatch type="any">
		</cfcatch>
		</cftry>
	<cfelseif form.cmd EQ "V">
		<cfinclude template="consola-procesos-ver.cfm">
		<cfabort>
	</cfif>
</cfif>

<cfoutput>
<HTML>
<head>
</head>
<body>
<form action="consola-procesos.cfm" method="post" name="sql">
	<cfif isdefined("Form.fltStatus") and Len(Trim(Form.fltStatus))>
		<input type="hidden" name="fltStatus" value="#Form.fltStatus#">
	</cfif>
	<cfif isdefined("Form.fltFechaDesde") and Len(Trim(Form.fltFechaDesde))>
		<input type="hidden" name="fltFechaDesde" value="#Form.fltFechaDesde#">
	</cfif>
	<cfif isdefined("Form.fltFechaHasta") and Len(Trim(Form.fltFechaHasta))>
		<input type="hidden" name="fltFechaHasta" value="#Form.fltFechaHasta#">
	</cfif>
	<cfif isdefined("Form.fltInterfaz") and Len(Trim(Form.fltInterfaz))>
		<input type="hidden" name="fltInterfaz" value="#Form.fltInterfaz#">
	</cfif>
	<cfif isdefined("Form.fltOrigen") and Len(Trim(Form.fltOrigen))>
		<input type="hidden" name="fltOrigen" value="#Form.fltOrigen#">
	</cfif>
	<cfif isdefined("Form.chkRefrescar") and Len(Trim(Form.chkRefrescar))>
		<input type="hidden" name="chkRefrescar" value="#Form.chkRefrescar#">
	</cfif>
	<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		<input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#">
	</cfif>
</form>
</cfoutput>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
