
<cftransaction>
		<cfif isdefined("Form.accion") and Form.accion EQ 1 and isdefined("Form.TEid") and Len(Trim(Form.TEid))>
			<cfquery name="ABC_ConceptoExp" datasource="#Session.DSN#">
				insert into ConceptosTipoE(ECEid, TEid)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				)
			</cfquery>
		<cfelseif isdefined("Form.accion") and Form.accion EQ 2 and isdefined("Form.TEid") and Len(Trim(Form.TEid)) and isdefined("Form.ECEid_del") and Len(Trim(Form.ECEid_del))>
			<!---
			<cfquery name="ABC_ConceptoExp" datasource="#Session.DSN#">
				delete from ConceptosTipoE
				from EConceptosExpediente a					
				where ConceptosTipoE.ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid_del#">
				and ConceptosTipoE.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				and a.ECEid = ConceptosTipoE.ECEid
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			</cfquery>
			--->
			<!---- El subquery es para verficar que se elimina de la cuenta de la sesion --->
			<cfquery name="ABC_ConceptoExp" datasource="#Session.DSN#">
				delete from ConceptosTipoE
				where ConceptosTipoE.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				and ConceptosTipoE.ECEid in ( select ECEid 
											  from EConceptosExpediente a 
											  where a.ECEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECEid_del#">  
											    and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">  
												and a.ECEid=ConceptosTipoE.ECEid )
			</cfquery>
		</cfif>
</cftransaction>

<cfoutput>
	<form action="ConceptosExp-lista.cfm" method="post" name="sql">
		<input name="TEid" type="hidden" value="#Form.TEid#">	
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
