<cfif isdefined("Form.Guardar")>	
	<cfif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'C'>
		<cfquery name="data" datasource="#session.DSN#"><!--- COMPORTAMIENTO /HABILIDAD --->
			select a.RHERid,a.RHIEid,g.RHCOid
			from RHRSEvaluaciones z
			inner join  RHRERespuestas a
				on a.RHRSEid = z.RHRSEid 
			inner join RHDRelacionSeguimiento b
				on z.RHDRid= b.RHDRid
			inner join RHRelacionSeguimiento c
				on b.RHRSid = c.RHRSid
			inner join RHEvaluados d
				on c.RHRSid = d.RHRSid
				and a.DEid  = d.DEid 
			inner join RHItemEvaluar e 
				on d.RHEid = e.RHEid
				and e.RHHid  is not null
			inner join RHComportamiento g
				on e.RHHid = g.RHHid
			where z.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
		</cfquery>
	<cfelseif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'O'>
		<cfquery name="data" datasource="#session.DSN#"> <!--- OBJETIVOS --->
			select a.RHERid,e.RHIEid
			from RHRSEvaluaciones z
			inner join  RHRERespuestas a
				on a.RHRSEid = z.RHRSEid
				<!--- and coalesce(a.RHIEestado,0) = 0  --->
			inner join RHDRelacionSeguimiento b
				on z.RHDRid= b.RHDRid
			inner join RHRelacionSeguimiento c
				on b.RHRSid = c.RHRSid
			inner join RHItemEvaluar e 
				on a.RHIEid = e.RHIEid
				and e.RHOSid is not null
				<!--- and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between e.RHIEfinicio and e.RHIEffin --->
			inner join RHObjetivosSeguimiento f
				on e.RHOSid = f.RHOSid
			where z.RHRSEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
	</cfquery>
	</cfif>
	<cftransaction>
		<cfquery name="borraRespuestas" datasource="#session.DSN#">
			delete from RHRespuestas  
			where exists (select 1  from RHRSEvaluaciones z
									inner join  RHRERespuestas a
									on a.RHRSEid = z.RHRSEid 
									where  a.RHERid = RHRespuestas.RHERid
									and z.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
									 )
		</cfquery>
		<cfif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'C'>
			<cfset RHDGNid  = "">
			<cfloop query="data">
				<cfif isdefined("form.CMB_#data.RHIEid#_#data.RHCOid#")> 
					<cfset RHDGNid = Evaluate("form.CMB_#data.RHIEid#_#data.RHCOid#")>
					<cfif isdefined("RHDGNid") and len(trim(RHDGNid))>
						<cfquery name="peso" datasource="#session.DSN#">
							select RHDGNpeso from RHDGrupoNivel
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and RHDGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDGNid#">
						</cfquery>
						
						<cfquery name="rsinsert" datasource="#session.DSN#"> 
							insert into RHRespuestas 
								(RHERid, Ecodigo, RHDGNid, RHIEid, RHCOid, DEid, DEideval, RHRpeso, BMUsucodigo, BMfechaalta)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHERid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDGNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHIEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHCOid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#peso.RHDGNpeso#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)							
						</cfquery>
					</cfif>
				</cfif>	
			</cfloop>
		<cfelseif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'O'>
			<cfset RHDGNid  = "">
			
			<cfloop query="data">
				<cfif isdefined("form.CMB_#data.RHIEid#")> 
					<cfset RHDGNid = Evaluate("form.CMB_#data.RHIEid#")>
					<cfif isdefined("RHDGNid") and len(trim(RHDGNid))>
						<cfquery name="peso" datasource="#session.DSN#">
							select RHDGNpeso from RHDGrupoNivel
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and RHDGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDGNid#">
						</cfquery>
						<cfquery name="rsinsert" datasource="#session.DSN#"> 
							insert into RHRespuestas 
								(RHERid, Ecodigo, RHDGNid, RHIEid, RHCOid, DEid, DEideval, RHRpeso, BMUsucodigo, BMfechaalta)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHERid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDGNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHIEid#">,
								null,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#peso.RHDGNpeso#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)							
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>	
		</cfif>
	</cftransaction>
</cfif>
<cfoutput>
<form action="evaluar_des.cfm" method="post" name="sql">
	<input type="hidden" name="RHRSEid" value="#form.RHRSEid#">
	<input type="hidden" name="tipo" value="#form.tipo#">
	<input type="hidden" name="TipoEval" value="#form.TipoEval#">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>