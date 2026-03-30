<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Monedas" datasource="#Session.DSN#">
				insert INTO Monedas (Ecodigo, Mnombre, Msimbolo, Miso4217,ClaveSAT)
				values(
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Mnombre)#">,
					 #fnSetMsimbolo(Form.Msimbolo)#,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.Miso4217)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CSATcodigo)#">
				)
			</cfquery>

			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="Monedas" datasource="#Session.DSN#">
				delete from Monedas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>

				  <cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
				<cf_dbtimestamp
				    datasource="#session.dsn#"
					table="Monedas"
					redirect="Monedas.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="Mcodigo,numeric,#form.Mcodigo#">
				<cfquery name="Monedas" datasource="#Session.DSN#">
					update Monedas set
						Msimbolo = #fnSetMsimbolo(Form.Msimbolo)#,
						Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.Miso4217)#">,
						ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CSATcodigo)#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cftransaction>

			<cfset modo="CAMBIO">
		</cfif>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Monedas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")><cfoutput>#Form.Mcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction name="fnSetMsimbolo" returntype="string" output="false">
	<cfargument name="simbolo">
	<cfif find(Application.dsinfo[session.dsn].type,"sybase,xxx")>
    	<cfif trim(arguments.simbolo) EQ "€">
        	<cfreturn "char(128)">
		</cfif>
    </cfif>
    <cfreturn "'#trim(arguments.simbolo)#'">
</cffunction>

<cffunction name="fnGetMsimbolo" returntype="string" output="false">
	<cfargument name="simbolo">
	<cfif find(Application.dsinfo[session.dsn].type,"sybase,xxx")>
    	<cfif asc(arguments.simbolo) EQ 128>
        	<cfreturn "€">
		</cfif>
    </cfif>
    <cfreturn "#trim(arguments.simbolo)#">
</cffunction>