
<cfquery name="rsReferencia" datasource="asp">
	select llave
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>

	<cfif isdefined("Inscripcion") and isdefined("Inscribe") and Inscribe  EQ "si">
		<cftransaction>
			<cfquery name="InsertRHConcursantes" datasource="#session.DSN#">
				insert into RHConcursantes
				(RHCconcurso,Ecodigo,RHCPtipo,DEid,RHCautogestion,Usucodigo,BMUsucodigo)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="I">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#">,
					   <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				  <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="InsertRHConcursantes">
		</cftransaction>
		
		<!--- Toma el correo remitente desde las politicas del portal--->
		<cfset FromEmail= "Reclutamiento@soin.co.cr">
		<cfquery name="CuentaPortal"   datasource="asp">
			Select valor
			from  PGlobal
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail = CuentaPortal.valor>
		</cfif>	
		
		<cftransaction>
			<cfquery datasource="asp">
				insert into SMTPQueue (SMTPremitente, 
								  SMTPdestinatario, 
								  SMTPasunto, 
								  SMTPtexto, 
								  SMTPhtml )
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FromEmail#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailCon#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Inscripción a Concurso">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#MsgConcursante#">, 
						1)
			</cfquery>
			<cfquery datasource="asp">
				insert into SMTPQueue (SMTPremitente, 
								  SMTPdestinatario, 
								  SMTPasunto, 
								  SMTPtexto, 
								  SMTPhtml )
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailSol#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Inscripción a Concurso">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#MsgSolicitante#">, 
						1)
			</cfquery>			
		</cftransaction>
		<cfset form.RHCconcurso = "">
	</cfif> 


<form action="concursoabierto.cfm" method="post" name="sql">
	<input name="RHCconcurso" type="hidden" value="<cfoutput><cfif isdefined("Form.RHCconcurso")>#Form.RHCconcurso#<cfelse></cfif></cfoutput>">
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>