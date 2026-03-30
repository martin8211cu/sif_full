<cfsetting requesttimeout="86400">
<cfset Action="ResultadoCalculo-lista.cfm">
<cfif isdefined("Url.RCNid")>
	<cftry>
		<!---************************************************************--->
		<!---/               En caso de algun salario negativo          /--->
		<!---************************************************************--->
		<cfif Url.Accion eq "Aplicar">
				<cfquery name="rsDE" datasource="#session.dsn#">
					select DEid from SalarioEmpleado where RCNid=#url.RCNid# and SEcalculado <> 1
				</cfquery>
				<cfquery name="rsCN" datasource="#session.dsn#">
					select Tcodigo from RCalculoNomina where RCNid=#url.RCNid#
				</cfquery>
				<cfif rsDE.recordcount gt 0>
					<cfloop query="rsDE">
				<cfquery name="rsSalario" datasource="#session.dsn#">
					select SEliquido from SalarioEmpleado where DEid=#rsDE.DEid#
				</cfquery>
				
				 <cfquery name="rsParametro" datasource="#session.dsn#">
					select Pvalor from RHParametros where Pcodigo=2027 and Ecodigo=#session.Ecodigo#
				</cfquery>
				
				<cfset CIid = rsParametro.Pvalor>
				
				<cfquery name="rsIncidenciaP" datasource="#session.dsn#">
					select CIid,CIcodigo,CIdescripcion from CIncidentes  where CIid=#CIid#
				</cfquery>
				
				<cfquery name="rsNomina" datasource="#session.dsn#">
					select RCdesde from RCalculoNomina where RCNid=#url.RCNid#
				</cfquery>
				
				<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
					insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDE.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIid#">, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsNomina.RCdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rsSalario.SEliquido#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						null
						)
				</cfquery>
					<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
							datasource="#session.dsn#"
							Ecodigo = "#Session.Ecodigo#"
							RCNid = "#url.RCNid#"
							Tcodigo = "#rsCN.Tcodigo#"
							Usucodigo = "#Session.Usucodigo#"
							Ulocalizacion = "#Session.Ulocalizacion#"
							pDEid = "#rsDE.DEid#" />
							
				<!---Para sacar la fecha de la siguiente incidencia--->
				<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
					select 
						rtrim(a.Tcodigo) as Tcodigo, 
						a.CPdesde, 
						a.CPhasta
					from CalendarioPagos a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.CPfenvio is null
					and a.CPtipo in (0,2)
					and not exists (
						select 1
						from RCalculoNomina h
						where a.Ecodigo = h.Ecodigo
						and a.Tcodigo = h.Tcodigo
						and a.CPdesde = h.RCdesde
						and a.CPhasta = h.RChasta
						and a.CPid = h.RCNid
					)
					and not exists (
						select 1
						from HERNomina i
						where a.Tcodigo = i.Tcodigo
						and a.Ecodigo = i.Ecodigo
						and a.CPdesde = i.HERNfinicio
						and a.CPhasta = i.HERNffin
						and a.CPid = i.RCNid
					)
					and Tcodigo='#rsCN.Tcodigo#'
					order by CPhasta
				</cfquery>
				<cfquery name="MinFechasNomina" dbtype="query">
					select Tcodigo, min(CPdesde) as CPdesde
					from PaySchedAfterRestrict
					group by Tcodigo
				</cfquery>
				<cfquery name="rsCalendarios" dbtype="query">
					select *
					from PaySchedAfterRestrict
					where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
					and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPdesde#">
					order by CPdesde
				</cfquery>
				<cfset Ivalor=rsSalario.SEliquido*-1>
				<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
					insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDE.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIid#">, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsCalendarios.CPdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Ivalor#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						null
						)
				</cfquery>
			</cfloop>					
			</cfif>
		</cfif>
		<!---                 Fin de Salario negativo                    --->
		<cfif Url.Accion eq "Aplicar">
			<!--- Aplicar Relación de Cálculo --->
			<cfset Action="ResultadoCalculo-aplicar.cfm">
		<cfelseif Url.Accion eq "Recalcular">
			<!--- Regenerar Relación de Cálculo --->
			<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Url.RCNid#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#" />
		<cfelseif Url.Accion eq "Restaurar">
			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Url.RCNid#"
				Tcodigo = "#Url.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#" />
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#Action#" method="post" name="sql">
	<input name="RCNid" type="hidden" value="<cfif isdefined("Url.RCNid")>#Url.RCNid#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
