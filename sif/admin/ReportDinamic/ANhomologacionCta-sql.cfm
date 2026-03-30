<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
<!---=================Agregar cta Homologacion======================--->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into ANhomologacionCta (
					ANHid,
				   ANHCcodigo,
				   ANHCdescripcion,
				   Ecodigo,
				   BMUsucodigo
				  )
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANHCcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANHCdescripcion#">,
					#Session.Ecodigo#,
					#session.Usucodigo#
				) 
		</cfquery>
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#">

		<cfset modo = "ALTA">
<!---====================Eliminar  cta Homologacion=======================--->	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ANhomologacionCta
			  where ANHCid =#form.ANHCid# 
		</cfquery>
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
		<cfset modo="ALTA">
<!---====================Modificar cta Homologacion=======================--->
	<cfelseif isdefined("Form.Cambio")>
		 <cf_dbtimestamp
					datasource="#session.dsn#"
					table="ANhomologacionCta" 
					redirect="ANhomologacionCta.cfm"
					timestamp="#form.ts_rversion#"
					field1="ANHCid,numeric,#form.ANHCid# "
					>
		<cfquery name="update" datasource="#Session.DSN#">
			update ANhomologacionCta set 
				   	ANHCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANHCdescripcion#">,
					BMUsucodigo = #session.Usucodigo#
			where ANHCid       = #form.ANHCid#
		</cfquery> 
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.VerCtas")>			
		<cflocation url="modificaHomologacion.cfm?VER&ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
	<!---====================ANhomologacionFmts=======================--->		
	<cfelseif isdefined("Form.AgregarFmts")>
		<cfquery datasource="#Session.DSN#">
			insert into ANhomologacionFmts(
						ANHCid, 
						Cmayor,  
						AnexoCelFmt,
						AnexoSigno, 
						Ecodigo,  
						BMUsucodigo
					  )
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHCid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno#">,
						#Session.Ecodigo#,
						#session.Usucodigo#
					) 
		</cfquery>
				<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.ModificarFmts")>
		<cfquery datasource="#Session.DSN#">
			update ANhomologacionFmts
			   set Cmayor		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor#">
			     , AnexoCelFmt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara()#">
				 , AnexoSigno	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno#">
				 , BMUsucodigo	= #session.Usucodigo#
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid#">
		</cfquery>
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.EliminarFmts")>		
		<cfquery datasource="#Session.DSN#">
			delete from ANhomologacionFmts
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid#">
		</cfquery>
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
		<cfset modo="CAMBIO">
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid=#form.ANHCid#">
	</cfif>
<cfelse>
	<cflocation url="modificaHomologacion.cfm">
</cfif>

<form action="modificaHomologacion.cfm" method="post" name="sql">
	<input name="modo"  type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="ANHid" type="hidden" value="<cfoutput>#form.ANHid#</cfoutput>">
	<input name="ANHCid" type="hidden" value="<cfif isdefined("form.ANHCid") and modo neq 'ALTA'><cfoutput>#form.ANHCid#</cfoutput></cfif>">
</form>
	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
<cffunction name="fnAjustaMascara" output="no" returntype="string">
	<cfset var LvarCta = replace(trim(form.ctaFinal),"%","_","ALL")>
	<cfset var i = len(LvarCta)>
	<cfloop condition="true">
		<cfif mid(LvarCta,i,1) NEQ "_" or i EQ 0>
			<cfbreak>
		</cfif>
		<cfset i=i-1>
	</cfloop>
	<cfif mid(LvarCta,i,1) EQ "-">
		<cfset i=i-1>
	</cfif>
	<cfreturn mid(LvarCta,1,i) & "%">
</cffunction>
