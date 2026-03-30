<cfparam name="action" default="reclamos-lista.cfm">

<cfif isdefined("form.Cambio") >
	<!--- 1. Si el Estado esta en 0, lo pone en 10 --->
	<cfquery datasource="#session.DSN#">
		update EReclamos
		set ERestado = 10
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['ERid']#">
		  and ERestado=0
	</cfquery>

	<!--- 2. Modifica el Encabezado del Reclamo --->
	<cfquery datasource="#session.DSN#">
		update EReclamos
		set SNcodigorec=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigorec#">,
			ERobs = <cfif len(trim(form['ERobs']))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['ERobs']#"><cfelse>null</cfif>
			<cfif form._CMCid neq form.CMCid>
				, CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
				, ERestado = 0
			</cfif>
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['ERid']#">
	</cfquery>

	<!--- 3. Modifica los Detalles del Reclamo (solo Observaciones o Estado) --->
	<cfloop from="1" to="#form.cantidad#" index="i">
		<cfif isdefined("form.DRestado_#i#")>
			<cfquery datasource="#session.DSN#">
				update DReclamos
				set DRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form['DRestado_#i#']#">,
					DDRobsreclamo = <cfif len(trim(form['DDRobsreclamo_#i#']))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['DDRobsreclamo_#i#']#"><cfelse>null</cfif>
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and DRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['DRid_#i#']#">
			</cfquery>
		</cfif>
	</cfloop>

	<!--- 4. Terminar el Reclamo --->
	<cfquery name="rsTerminar" datasource="#session.dsn#">
		select * 
		from DReclamos 
		where ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		and DRestado = 10
	</cfquery>

	<cfif rsTerminar.RecordCount eq 0 >
		<cfquery datasource="#session.DSN#">
			update EReclamos
			set ERestado=20
			where ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
	<cfif form._CMCid neq form.CMCid Or form._SNcodigorec neq form.SNcodigorec >
		<form action="reclamos-email.cfm" method="post" name="sql">
			<input name="ERid" type="hidden" value="<cfif isdefined("form.ERid") and len(trim(form.ERid))>#form.ERid#</cfif>">
			<input name="_CMCid" type="hidden" value="<cfif isdefined("form._CMCid") and len(trim(form._CMCid))>#form._CMCid#</cfif>">
			<input name="CMCid" type="hidden" value="<cfif isdefined("form.CMCid") and len(trim(form.CMCid))>#form.CMCid#</cfif>">
			<input name="_SNcodigorec" type="hidden" value="<cfif isdefined("form._SNcodigorec") and len(trim(form._SNcodigorec))>#form._SNcodigorec#</cfif>">
			<input name="SNcodigorec" type="hidden" value="<cfif isdefined("form.SNcodigorec") and len(trim(form.SNcodigorec))>#form.SNcodigorec#</cfif>">
		</form>
	<cfelse>
		<form action="reclamos.cfm" method="post" name="sql">
			<input name="ERid" type="hidden" value="<cfif isdefined("form.ERid") and len(trim(form.ERid))>#form.ERid#</cfif>">
		</form>
	</cfif>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<!--- Comienza el código viejo, donde enviaba el correo sin mostrar ninguna pantalla --->
<!--- 
<cfif isdefined("form.Cambio") >
	<!--- 0. Si estado esta en cero, lo pone en 10 --->
	<cfquery datasource="#session.DSN#">
		update EReclamos
		set ERestado = 10
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['ERid']#">
		  and ERestado=0
	</cfquery>

	<!--- 1. Modifica encabezado del reclamo --->
	<cfquery datasource="#session.DSN#">
		update EReclamos
		set SNcodigorec=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigorec#">,
			ERobs = <cfif len(trim(form['ERobs']))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['ERobs']#"><cfelse>null</cfif>
			<cfif form._CMCid neq form.CMCid>
				, CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
				, ERestado = 0
			</cfif>
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['ERid']#">
	</cfquery>
	
	<!--- 1.1 Si cambio el comprador, le manda un email notificandolo --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfinclude template="reclamos-correo.cfm">
	<cfif form._CMCid neq form.CMCid>
		<cfset dataUsuario = sec.getUsuarioByRef(form.CMCid, session.EcodigoSDC, 'CMCompradores') >
		<cfif dataUsuario.recordCount gt 0>
			<cfset pnombre = dataUsuario.Pnombre & ' ' & dataUsuario.Papellido1 & ' ' & dataUsuario.Papellido2 >
			<cfset _mailBody  = mailBody(form.ERid, dataUsuario.Usucodigo, pnombre, 0) >
			<cfquery datasource="asp">
				insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dataUsuario.Pemail1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Generación de Reclamo. Sistema de Compras">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
			</cfquery>
		</cfif>	
	</cfif>
	
	<!--- 1.1 Si cambio el socio de negocios del reclamo, le manda un email notificandolo --->
	<cfif form._SNcodigorec neq form.SNcodigorec>
		<cfquery name="rsSocio" datasource="#session.DSN#">
			select SNcodigorec
			from EReclamos
			where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		</cfquery>
		<cfset dataSocio = sec.getUsuarioByRef(rsSocio.SNcodigorec, session.EcodigoSDC, 'SNegocios') >
		<cfif dataSocio.recordCount gt 0>
			<cfset SNnombre = dataSocio.Pnombre & ' ' & dataSocio.Papellido1 & ' ' & dataSocio.Papellido2 >
			<cfset _mailBody  = mailBody(form.ERid, dataSocio.Usucodigo, SNnombre, 0) >
			
			<cfquery datasource="asp">
				insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dataSocio.Pemail1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Generación de Reclamo. Sistema de Compras">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- 2. Modifica detalles del reclamo (solo Observaciones o Estado) --->
	<cfloop from="1" to="#cantidad#" index="i">
		<cfif isdefined("form.DRestado_#i#")>
			<cfquery datasource="#session.DSN#">
				update DReclamos
				set DRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form['DRestado_#i#']#">,
					DDRobsreclamo = <cfif len(trim(form['DDRobsreclamo_#i#']))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form['DDRobsreclamo_#i#']#"><cfelse>null</cfif>
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and DRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['DRid_#i#']#">
			</cfquery>
		</cfif>
	</cfloop>

	<!--- 3. Terminar el reclamo --->
	<cfquery name="rsTerminar" datasource="#session.dsn#">
		select * 
		from DReclamos 
		where ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		and DRestado = 10
	</cfquery>

	<cfif rsTerminar.RecordCount eq 0 >
		<cfquery datasource="#session.DSN#">
			update EReclamos
			set ERestado=20
			where ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
	<form action="reclamos.cfm" method="post" name="sql">
		<input name="ERid" type="hidden" value="<cfif isdefined("form.ERid") and len(trim(form.ERid))>#form.ERid#</cfif>">
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

--->
<!--- Finaliza el código viejo, donde enviaba el correo sin mostrar ninguna pantalla --->
