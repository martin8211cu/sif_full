
<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select ZCSNcodigo
			from ZonaCobroSNegocios
			where Ecodigo 	 = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and ZCSNcodigo = <cfqueryparam value="#Form.ZCSNcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		
		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="ZonaCobroSN" datasource="#Session.DSN#">
				insert into ZonaCobroSNegocios (Ecodigo, ZCSNcodigo, ZCSNdescripcion,DEidCobrador,BMUsucodigo)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ZCSNcodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ZCSNdescripcion)#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Form.DEid)#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ZonaCobroSN" datasource="#Session.DSN#">
		delete from ZonaCobroSNegocios
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and ZCSNid    = <cfqueryparam value="#Form.ZCSNid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		  <cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="ZonaCobroSNegocios"
			redirect="ZonaCobro.cfm"
			timestamp="#form.ts_rversion#"				
			field1="Ecodigo" type1="integer" value1="#session.Ecodigo#"
			field2="ZCSNcodigo" type2="char" value2="#form.ZCSNcodigo#">
				
		<cfquery name="ZonaCobroSN" datasource="#Session.DSN#">
			update ZonaCobroSNegocios set 
				ZCSNcodigo 	  	= rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ZCSNcodigo#">)),
				ZCSNdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ZCSNdescripcion#">)),
				DEidCobrador 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Form.DEid)#">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Ecodigo 	 = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and ZCSNcodigo = <cfqueryparam value="#Form.ZCSNcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		  <cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="ZonaCobro.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="ZCSNcodigo" type="hidden" 
		value="<cfif isdefined("Form.ZCSNcodigo") and modo NEQ 'ALTA'>#Form.ZCSNcodigo#</cfif>">
    <input type="hidden" name="Pagina" 
	value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
	</cfoutput>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>