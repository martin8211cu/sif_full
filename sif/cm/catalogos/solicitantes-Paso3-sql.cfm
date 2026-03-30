<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp")>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into CMESolicitantes (CMElinea, CMSid, Usucodigo, fechaalta)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMElinea#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					 )
		</cfquery>
	<cfelseif isdefined("Form.Baja") and Form.Baja>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CMESolicitantes
			where CMElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMElinea#">
				and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">
		</cfquery>
	</cfif>

</cfif><!---Form.Nuevo--->
<cflocation url="solicitantes.cfm">