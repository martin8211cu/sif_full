<cfif not isdefined("form.Nuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Categorias" datasource="sdc">
				set nocount on			
				insert MSContenido ( Scodigo, MSCtitulo, MSCcategoria, MSCexpira, MSCtexto )
				values( #session.Scodigo#,
					<cfqueryparam value="#form.MSCtitulo#"    cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#form.MSCcategoria#" cfsqltype="cf_sql_numeric">,
					<cfif IsDefined("form.MSCexpira") and Len(form.MSCexpira) GT 1>
						convert(datetime,<cfqueryparam value="#form.MSCexpira#" cfsqltype="cf_sql_varchar">,103)
					<cfelse>
						dateadd(dd, 60, getdate())
					</cfif>,
					<cfqueryparam value="#form.MSCtexto#" cfsqltype="cf_sql_varchar">
				)
				select @@identity as MSCcontenido
				set nocount off
			</cfquery>
			<cfset modo="ALTA">
			<cfset MSCcontenido=ABC_Categorias.MSCcontenido>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Categorias" datasource="sdc">
				set nocount on
				
				<!--- Por ahora se realiza estos deletes --->
				delete MSContenidoGenerado
				where Scodigo = <cfqueryparam value="#Session.Scodigo#" cfsqltype="cf_sql_numeric">
				and MSCcontenido = <cfqueryparam value="#form.MSCcontenido#" cfsqltype="cf_sql_numeric">

				delete MSPaginaGenerada
				where Scodigo = <cfqueryparam value="#Session.Scodigo#" cfsqltype="cf_sql_numeric">
				and MSCcontenido = <cfqueryparam value="#form.MSCcontenido#" cfsqltype="cf_sql_numeric">
							
				delete MSImagen
				where Scodigo = <cfqueryparam value="#Session.Scodigo#" cfsqltype="cf_sql_numeric">
				and MSCcontenido = <cfqueryparam value="#form.MSCcontenido#" cfsqltype="cf_sql_numeric">
				<!--- -------------------------------------- --->
							
				delete MSContenido
				where MSCcontenido = <cfqueryparam value="#form.MSCcontenido#" cfsqltype="cf_sql_numeric">
				  and Scodigo = #Session.Scodigo#
				set nocount off
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Categorias" datasource="sdc">
				set nocount on			
				 update MSContenido
				 set MSCtitulo = <cfqueryparam value="#form.MSCtitulo#" cfsqltype="cf_sql_varchar">,
					 MSCcategoria = <cfqueryparam value="#form.MSCcategoria#" cfsqltype="cf_sql_numeric">
					 <cfif IsDefined("form.MSCexpira") and Len(form.MSCexpira) GT 1>
						 , MSCexpira = convert(datetime,<cfqueryparam value="#form.MSCexpira#" cfsqltype="cf_sql_varchar">,103)
					</cfif>,
					MSCtexto = <cfqueryparam value="#form.MSCtexto#" cfsqltype="cf_sql_varchar">
				 where MSCcontenido = <cfqueryparam value="#form.MSCcontenido#" cfsqltype="cf_sql_numeric">
				   and Scodigo = #session.Scodigo#
				set nocount off
			</cfquery>
			 <cfset modo="CAMBIO">
			 <cfset MSCcontenido=form.MSCcontenido>
		</cfif>
		
		<cfif IsDefined("MSCcontenido") AND (NOT IsDefined("Form.Baja")) AND IsDefined("form.MSIimagen") AND Len(form.MSIimagen) GT 2>
			<cffile action="Upload" fileField="form.MSIimagen"
				destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*">
			<cffile action="readbinary" file="#GetTempDirectory()##cffile.serverFile#" variable="tmp" >
			<cffile action="delete" file="#gettempdirectory()##cffile.serverFile#" >

			<cfquery datasource="sdc">
				insert MSImagen (Scodigo, MSCcontenido, MSIimagen,
					MSIcontentType, MSInombre, MSIumod, MSIfmod)
				values (#session.Scodigo#, #MSCcontenido#, 
					0x<cfoutput><cfloop from="1" to="#Len(tmp)#" index="i"><cfif tmp[i] GE 0 AND tmp[i] LE 15
						>0#FormatBaseN((tmp[i]+256)mod 256,16)#<cfelseif tmp[i] GT 0 
						>#FormatBaseN(tmp[i],16)#<cfelse>#FormatBaseN(tmp[i]+256,16)#</cfif></cfloop></cfoutput>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.ContentType#/#cffile.ContentSubType#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.ClientFile#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">, getdate())
					
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<HTML>
<head>
</head>
<body>
<cfoutput>
<form action="Contenidos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("modo") and modo neq 'ALTA'>
		<input name="MSCcontenido" type="hidden" value="<cfif isdefined("form.MSCcontenido")>#form.MSCcontenido#</cfif>">
	</cfif>	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>