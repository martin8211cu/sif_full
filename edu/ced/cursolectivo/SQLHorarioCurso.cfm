<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_HorarioGuia" datasource="#Session.Edu.DSN#">
				set nocount on
				if not exists (
					select 1
					from HorarioGuia a, Horario b
					where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
					  and a.Rconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo#">
					  and a.HRdia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.HRdia#">
					  and a.Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">
					  and a.Hbloque = b.Hbloque
					  and a.Hcodigo = b.Hcodigo
				)
				insert into HorarioGuia(Ccodigo, Rconsecutivo, HRdia, Hbloque, Hcodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.HRdia#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">,
					Hcodigo
				from Horario
				where Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">
				set nocount off
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_HorarioGuia" datasource="#Session.Edu.DSN#">
				set nocount on
				update HorarioGuia
				set Rconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo#">,
				    HRdia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.HRdia#">,
					Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">,
					Hcodigo = (select Hcodigo from Horario where Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">)
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and HRdia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.HRdia_Ant#">
				and Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque_Ant#">
				and Rconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo_Ant#">
				set nocount off
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_HorarioGuia" datasource="#Session.Edu.DSN#">
				set nocount on
				delete HorarioGuia
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and HRdia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.HRdia_Ant#">
				and Hbloque = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque_Ant#">
				and Rconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo_Ant#">
				set nocount off
			</cfquery>
			<cfset modo="ALTA">
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="HorarioCurso.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ccodigo" type="hidden" value="<cfif isdefined("Form.Ccodigo")><cfoutput>#Form.Ccodigo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
