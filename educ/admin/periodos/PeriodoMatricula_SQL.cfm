<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo")>
	<cfquery name="qryPMsecuencia" datasource="#Session.DSN#">
		select (max(PMsecuencia) + 1) as PMsecuencia
		from PeriodoMatricula		
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
		  and PLcodigo=<cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
		  <cfif form.CILtipoCicloDuracion NEQ 'L'>
			  and PEcodigo=<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
		  </cfif>
	</cfquery>
	<cfif isdefined('qryPLcodigo') and qryPLcodigo.recordCount GT 0 and qryPLcodigo.PLcodigo GT 0>
		<cfset varPMsecuencia = qryPMsecuencia.PMsecuencia>
	<cfelse>
		<cfset varPMsecuencia = 1>	
	</cfif>
	
	<cftry>	
		<cfquery name="abc_CiclosLectivos" datasource="#session.DSN#">
			set nocount on
			declare @id numeric, @Inicio datetime
			<cfif isdefined("form.ALTA")>				
				insert PeriodoMatricula
				(Ecodigo, PLcodigo, 
				 <cfif form.CILtipoCicloDuracion NEQ 'L'>
					PEcodigo, 
				</cfif>
				PMsecuencia, PMtipo, PMinicio, PMfinal)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">, 
					<cfif form.CILtipoCicloDuracion NEQ 'L'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">, 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#varPMsecuencia#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.PMtipo#">, 					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PMinicio,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PMfinal,'YYYYMMDD')#">)
				
				select @id = @@identity
				select @Inicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PMinicio,'YYYYMMDD')#">
									
			<cfelseif isdefined("form.CAMBIO") >
				update PeriodoMatricula	set 
					PMtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.PMtipo#">, 
					PMinicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PMinicio,'YYYYMMDD')#">,
					PMfinal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PMfinal,'YYYYMMDD')#">
				where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and PLcodigo=<cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
				  <cfif form.CILtipoCicloDuracion NEQ 'L'>
						and PEcodigo=<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
				  </cfif>
				  and PMsecuencia =<cfqueryparam value="#form.PMsecuencia#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  
	
				<cfset modo = "CAMBIO">
				
			<cfelseif isdefined("form.BAJA")>
			
				delete PeriodoMatricula 
				where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and PLcodigo=<cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
				  <cfif form.CILtipoCicloDuracion NEQ 'L'>
					  and PEcodigo=<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
				  </cfif>
				  and PMsecuencia =<cfqueryparam value="#form.PMsecuencia#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
									  
			</cfif>
			set nocount off
		</cfquery>
		<cfcatch type="any">
			<cfinclude template="/educ/errorpages/BDerror.cfm">		
			<cfabort>
		</cfcatch>
	</cftry>
	
</cfif>

<cfoutput>
<form action="PeriodoMatricula.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevo")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
		<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
	</cfif>
	<cfif isdefined("Form.PLcodigo") and Len(Trim(Form.PLcodigo)) NEQ 0>
		<input type="hidden" name="PLcodigo" value="#Form.PLcodigo#">
	</cfif>
	<cfif isdefined("Form.CILcodigo") and Len(Trim(Form.CILcodigo)) NEQ 0>
		<input type="hidden" name="CILcodigo" value="#Form.CILcodigo#">
	</cfif>
	<cfif isdefined("Form.CIEsemanas") and Len(Trim(Form.CIEsemanas)) NEQ 0>
		<input type="hidden" name="CIEsemanas" value="#Form.CIEsemanas#">
	</cfif>
	<cfif isdefined("Form.CILtipoCicloDuracion") and Len(Trim(Form.CILtipoCicloDuracion)) NEQ 0>
		<input type="hidden" name="CILtipoCicloDuracion" value="#Form.CILtipoCicloDuracion#">
	</cfif>
	<cfif isdefined("Form.PMsecuencia") and Len(Trim(Form.PMsecuencia)) NEQ 0>
		<input type="hidden" name="PMsecuencia" value="#Form.PMsecuencia#">
	</cfif>
	
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

