<cfparam name="modo" default="CAMBIO">
<cfparam name="modoDet" default="ALTA">

<cfif not isdefined("form.Nuevo")>
		<!--- Agregar Jornada --->
		<cfif isdefined("form.Alta")>
			<cfset comportamiento = Mid(Form.RHCJcomportamiento, 1, 1)>
			<cfset momento = Mid(Form.RHCJcomportamiento, 2, 1)>
			<cfquery name="ABC_Comportamiento" datasource="#Session.DSN#">
				if not exists (
					select 1
					from RHComportamientoJornada
					where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
					and RHCJcomportamiento = <cfqueryparam cfsqltype="cf_sql_char" value="#comportamiento#">
					and RHCJmomento = <cfqueryparam cfsqltype="cf_sql_char" value="#momento#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfrige)#"> between RHCJfrige and RHCJfhasta
				)
				insert into RHComportamientoJornada (RHJid, RHCJcomportamiento, RHCJmomento, RHCJperiodot, RHCJfrige, RHCJfhasta)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#comportamiento#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#momento#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#RHCJperiodot#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfrige)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfhasta)#">
				)
			</cfquery>
				
		<!--- Actualizar una Jornada --->
		<cfelseif isdefined("form.Cambio")>
			<cfset comportamiento = Mid(Form.RHCJcomportamiento, 1, 1)>
			<cfset momento = Mid(Form.RHCJcomportamiento, 2, 1)>
			<cf_dbtimestamp
				datasource="#Session.DSN#"
				table="RHComportamientoJornada" 
				redirect="JornadasComp.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHJid,numeric,#Form.RHJid#"
				field2="RHCJid,numeric,#Form.RHCJid#">

			<cfquery name="ABC_Comportamiento" datasource="#Session.DSN#">
				if not exists (
					select 1
					from RHComportamientoJornada
					where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
					and RHCJcomportamiento = <cfqueryparam cfsqltype="cf_sql_char" value="#comportamiento#">
					and RHCJmomento = <cfqueryparam cfsqltype="cf_sql_char" value="#momento#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfrige)#"> between RHCJfrige and RHCJfhasta
					and RHCJid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCJid#">
				)
				update RHComportamientoJornada 
				set RHCJcomportamiento = <cfqueryparam cfsqltype="cf_sql_char" value="#comportamiento#">,
					RHCJmomento = <cfqueryparam cfsqltype="cf_sql_char" value="#momento#">,
					RHCJperiodot = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCJperiodot#">,
					RHCJfrige = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfrige)#">,
					RHCJfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHCJfhasta)#">
				where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
				and RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid#">
			</cfquery>
				  
		<!--- Borrar una Jornada --->
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_Comportamiento" datasource="#session.DSN#">
				delete from RHComportamientoJornada
				where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
				and RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCJid#">
			</cfquery>
		</cfif>
</cfif>	

<cfoutput>
<form action="JornadasComp.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<input name="RHJid" type="hidden" value="#form.RHJid#">
	</cfif>
	<cfif modoDet eq 'CAMBIO'>
		<input name="RHCJid" type="hidden" value="#form.RHCJid#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>