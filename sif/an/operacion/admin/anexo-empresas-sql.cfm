<cfinclude template="anexo-validar-permiso.cfm">
<cfoutput>
	<cfquery name="delete" datasource="#session.DSN#">
		delete from AnexoEm
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
	</cfquery>
	<cfif isdefined("form.chk")>
		<cfloop list="#form.chk#" index="i">
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into AnexoEm(Ecodigo, AnexoId, BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
			</cfquery>
		</cfloop>
	</cfif>
	<form action="anexo.cfm?AnexoId=#form.AnexoId#&tab=#form.tab#" method="post" name="sqlEmp">
		<input name="AnexoId" type="hidden" value="#form.AnexoId#">
		<input type="hidden" name="tab" value="#form.tab#">
	</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
