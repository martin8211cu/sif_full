<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select FVnivel, FVpath
		from FVendedores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.padre#">
	</cfquery>
	<cfreturn data >
</cffunction>

<cffunction name="farbol" returntype="struct">
	<cfargument name="id" required="yes" type="string">
	<cfargument name="idpadre" required="yes" type="string">
	<cfset _data.path = ''>
	<cfset _data.path  = RepeatString("0", 18-len(trim(arguments.id)) ) & "#trim(arguments.id)#" >
	<cfset _datos = datos(arguments.idpadre) >
	<cfset _data.nivel = _datos.FVnivel + 1>
	<cfset _data.path  = trim(_datos.FVpath) & "/" & trim(_data.path) >
	<cfreturn _data >
</cffunction>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif not isdefined("Form.Nuevo")>
	<cftry>

		<cfset nivel = 0 >
		<cfset path  = ''>
			<cfif isdefined("Form.Alta")>
				<cfquery name="rsinsert" datasource="#Session.DSN#">
					Insert into FVendedores (Ecodigo, FVnombre, Usucodigo, Ulocalizacion, EUcodigo, FVjefe, DEid, Ocodigo, FVnivel )
					values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.FVnombre)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ulocalizacion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">,
							<cfif isdefined("form.FVjefe") and len(trim(form.FVjefe))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FVjefe#"><cfelse>null</cfif>,
							<cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
							<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#"><cfelse>null</cfif>,
							 0 )
					select @@rowcount as id
				</cfquery>

				<cfif isdefined("form.FVjefe") and len(trim(form.FVjefe))>
					<cfset varbol =  farbol(rsinsert.id, form.FVjefe )>
					<cfquery name="update" datasource="#session.DSN#">
						update FVendedores
						set FVnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#varbol.nivel#">,
							FVpath  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varbol.path#">
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and FVid = <cfqueryparam value="#rsinsert.id#" cfsqltype="cf_sql_numeric">
					</cfquery>
				</cfif>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delete" datasource="#Session.DSN#">
						delete from FVendedores
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and FVid = <cfqueryparam value="#Form.FVid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo="BAJA">

			<cfelseif isdefined("Form.Cambio")>
				<cfif isdefined("form.FVjefe") and len(trim(form.FVjefe))>
					<cfset varbol =  farbol(form.FVid, form.FVjefe )>
				</cfif>
				<cfquery name="update" datasource="#Session.DSN#">
					update FVendedores
					set FVjefe = <cfif isdefined("form.FVjefe") and len(trim(form.FVjefe))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FVjefe#"><cfelse>null</cfif>,
					    Ocodigo = <cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#"><cfelse>null</cfif>,
						DEid = <cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
						FVnivel = <cfif isdefined("varbol")><cfqueryparam cfsqltype="cf_sql_integer" value="#varbol.nivel#"><cfelse>0</cfif>,
						FVpath  = <cfif isdefined("varbol")><cfqueryparam cfsqltype="cf_sql_varchar" value="#varbol.path#"><cfelse>right('000000000000000000' #_Cat# ltrim(rtrim(convert(varchar,FVid))), 18)</cfif>
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and FVid = <cfqueryparam value="#Form.FVid#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = #lcase(form.ts_rversion)#

				</cfquery>
				<cfset modo="BAJA">

			</cfif>

			<!--- Reordenamiento del arbolito --->
			<!--- solo si cambia padre --->

			<!---<cfif isdefined("form.Alta") or isdefined("form.Cambio") >--->
			<cfif isdefined("form.Cambio") >
				<cfquery name="update_path" datasource="#session.DSN#" >
					  update FVendedores
					  set FVpath =  right('000000000000000000' #_Cat# ltrim(rtrim(convert(varchar,FVid))), 18),
						  FVnivel = case when FVjefe is null then 0 else -1 end
					  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>

				<cfset nivel  = 0 >
				<cfloop from="0" to="99" index="i">
					<cfquery datasource="#session.dsn#">
						   update a
						   set a.FVpath = p.FVpath #_Cat# '/' #_Cat# right ('00000000000000000' #_Cat# rtrim(ltrim(convert(varchar,h.FVid))), 18),
							   a.FVnivel = #nivel# + 1
						   from FVendedores a, FVendedores h, FVendedores p
						   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.Ecodigo#">
							 and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.Ecodigo#">
							 and h.FVjefe = p.FVid
							 and p.FVnivel = #nivel#
							 and h.FVnivel = -1
					</cfquery>

					<cfquery datasource="#session.dsn#" name="rsSeguir">
						select count(1) as cantidad
						from FVendedores
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and FVnivel=-1
					</cfquery>

					<cfif rsSeguir.cantidad eq 0>
						<cfbreak>
					</cfif>
					<cfset nivel = nivel + 1 >

					<cfif nivel gt 100 >
						<cf_errorCode	code = "50002" msg = "fue horrible!!!">
					</cfif>
				</cfloop>
			</cfif><!--- reordenamiento --->

	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<cfset parametros = "">
<cfif isdefined("form.Cambio")>
	<cfset parametros = "?arbol_pos=#form.FVid#">
</cfif>
<cflocation url="Vendedores.cfm#parametros#">
</cfoutput>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

