<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.btnAgregar")>
			<!--- 1. Inserta MSMenu --->
			<cfquery name="rsMenu" datasource="sdc">
				set nocount on
				insert MSMenu( Scodigo, MSMtexto, MSMlink, MSMorden, MSMpath, MSMprofundidad, MSMhijos, MSMumod, MSMfmod )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MSMtexto)#">,
						 <cfif form.MSMestilo eq 'L'><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MSMlink)#"><cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MSMorden#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MSMorden#">,
						 0,
						 0,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 getdate()
				)
				
				select @@identity as MSMmenu
				set nocount off		
			</cfquery>
			<cfset MSMmenu = rsMenu.MSMmenu >
	
			<cfif form.MSMestilo eq 'E'>
				<cfinclude template="SQLPaginas.cfm">
			</cfif>	
	
		</cfif>	
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>

	</cftry>


</cfif>

<cfabort>

<form action="Menu.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="MSMmenu" type="hidden" value="<cfif isdefined("Form.MSMmenu")>#Form.MSMmenu#</cfif>">		
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
