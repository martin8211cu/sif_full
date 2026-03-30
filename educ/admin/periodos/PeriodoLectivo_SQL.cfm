<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo")>
	<cfquery name="rsCIE" datasource="#Session.DSN#">
		select convert(varchar,CIEcodigo) as CIEcodigo, CIEnombre, CIEcorto , CIEextraordinario, 
		convert(varchar,CIEsemanas) as CIEsemanas, convert(varchar,CIEvacaciones) as CIEvacaciones,
		ts_rversion, CIEsecuencia
		from CicloEvaluacion		
		where CILcodigo=<cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">
		order by CIEsecuencia
	</cfquery>
	
	
	<cftry>	
		<cfquery name="abc_CiclosLectivos" datasource="#session.DSN#">
			set nocount on
			declare @id numeric, @Inicio datetime, @Final datetime 
			<cfif isdefined("form.ALTA")>				
				
				insert PeriodoLectivo 
				(Ecodigo, PLnombre, CILcodigo, PLinicio, PLfinal, PLcorto)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PLnombre#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.PLinicio,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.PLfinal,'YYYYMMDD')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PLcorto#">)
				
				select @id = @@identity
				select @Inicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.PLinicio,'YYYYMMDD')#">
				<cfoutput query="rsCIE">
					select @Final = dateadd(wk,#rsCIE.CIEsemanas#, @Inicio)
					
					insert into PeriodoEvaluacion(Ecodigo, PLcodigo, CIEcodigo, PEnombre, PEcorto, PEinicio, PEfinal)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
						@id, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCIE.CIEcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCIE.CIEnombre#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCIE.CIEcorto#">, 
						@Inicio, 
						@Final)
							
					<cfif rsCIE.CIEvacaciones NEQ "">
					select @Final = dateadd(wk,#rsCIE.CIEvacaciones#, @Final)
					</cfif>
					select @Inicio = dateadd(dd,1, @Final)
		
				</cfoutput>
			
				
									
			<cfelseif isdefined("form.CAMBIO") >
				update PeriodoLectivo	set 
					PLnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PLnombre#">, 
					PLcorto  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PLcorto#">,
					PLinicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.PLinicio,'YYYYMMDD')#">,
					PLfinal  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.PLfinal,'YYYYMMDD')#">
				where PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
				  and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  
	
				<cfset modo = "CAMBIO">
				
			<cfelseif isdefined("form.BAJA")>
				
				delete PeriodoEvaluacion 
				where PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
					
				delete PeriodoLectivo 
				where PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
				  and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
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
<form action="PeriodoLectivo.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevo")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.PLcodigo") and Len(Trim(Form.PLcodigo)) NEQ 0>
		<cfif isdefined("Form.Nuevo")>
			<input type="hidden" name="PLcodigo" value="">
		<cfelse>
			<input type="hidden" name="PLcodigo" value="#Form.PLcodigo#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.CILcodigo") and Len(Trim(Form.CILcodigo)) NEQ 0>
		<input type="hidden" name="CILcodigo" value="#Form.CILcodigo#">
	</cfif>
	<cfif isdefined("Form.CIEsemanas") and Len(Trim(Form.CIEsemanas)) NEQ 0>
		<input type="hidden" name="CIEsemanas" value="#Form.CIEsemanas#">
	</cfif>
	<cfif isdefined("Form.CIEvacaciones") and Len(Trim(Form.CIEvacaciones)) NEQ 0>
		<input type="hidden" name="CIEvacaciones" value="#Form.CIEvacaciones#">
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

