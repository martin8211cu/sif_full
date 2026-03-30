
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="UpdMensajesPV" datasource="#Session.DSN#">		
			insert into MensajesPV (CEcodigo, SNCcodigo, MPVmsg, MPVleido)
			values (
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> , 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPVmsga#">, 
 				 0
			)
		</cfquery>			 
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="MensajesPV"
							redirect="MensajesPV.cfm"
							timestamp="#form.ts_rversion#"
							field1="MPVid" type1="numeric" value1="#form.MPVid#"
							field2="CEcodigo" type2="numeric" value2="#Session.CEcodigo#">		
							
			<cfquery name="UpdMensajesPV" datasource="#Session.DSN#">								
				update MensajesPV  set 
					MPVmsg =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPVmsga#">
				where MPVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPVid#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			</cfquery>				  
		  <cfset modo="CAMBIO">

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="SNegocios" datasource="#Session.DSN#">
			delete from MensajesPV
			where MPVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPVid#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
		</cfquery>			  
		<cfset modo="ALTA">

	</cfif>
</cfif>
<cfoutput>
<form action="MensajesPV.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
	<cfif modo neq 'ALTA'>
	<input name="MPVid" type="hidden" value="<cfif isdefined("Form.MPVid")>#Form.MPVid#</cfif>">
	</cfif>	
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

