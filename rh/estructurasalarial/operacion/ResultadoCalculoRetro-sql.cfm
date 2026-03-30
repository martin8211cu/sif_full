
<cfif isdefined ('form.butAjuste')>
	<cfquery name="rsSalario" datasource="#session.dsn#">
		select SEliquido from SalarioEmpleado where DEid=#form.DEid#
	</cfquery>
	
	 <cfquery name="rsParametro" datasource="#session.dsn#">
		select Pvalor from RHParametros where Pcodigo=2027 and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif rsParametro.Pvalor eq 0>
		<cfset msg = "No se ha definido el concepto de pago para el ajuste de salario negativo en Parámetros Generales">
		<cfthrow message="#msg#">
		<cfabort>
	</cfif>
				
	<cfset CIid = rsParametro.Pvalor>
	
	<cfquery name="rsIncidenciaP" datasource="#session.dsn#">
		select CIid,CIcodigo,CIdescripcion from CIncidentes  where CIid=#CIid#
	</cfquery>
	
	<cfquery name="rsNomina" datasource="#session.dsn#">
		select RCdesde from RCalculoNomina where RCNid=#form.RCNid#
	</cfquery>
	
	<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
		insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
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
				RCNid = "#Form.RCNid#"
				Tcodigo = "#Form.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#"
				pDEid = "#Form.DEid#" />
				
	<!---Para sacar la fecha de la siguiente incidencia--->
	<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
		select 
			a.CPcodigo, 
			a.CPid, 
			rtrim(a.Tcodigo) as Tcodigo, 
			a.CPdesde, 
			a.CPhasta,
			case when a.CPtipo = 0 then 'Normal'
				when a.CPtipo = 2 then 'Anticipo' end as TipoCalendario
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
		and Tcodigo='#form.Tcodigo#'
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
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
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

</cfif>

<cfsetting requesttimeout="3600">
<cfset Acciones = ''>
<cfif isDefined("Form.chk") or isDefined("Form.butRecalcular") or isDefined("Form.butRestaurar")>
<cftry>
	<cfif isDefined("Form.butRestaurar")>
		<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Tcodigo = "#Form.Tcodigo#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#"
			pDEid = "#Form.DEid#" />
		<cfset Acciones = "Restaurar">
	<cfelseif isDefined("Form.chk")>
		
		<cfset vchk = ListToArray(Form.chk)>
			<!--- CUANDO ES UNA NOMINA DE ANTICIPO, SE TIENE QUE ELIMINAR LA INCIDENCIA DE PAGO DE ANTICIPO
				PARA QUE LA VUELVA A GENERAR --->
			<!--- TRAE EL CONCEPTO DE PAGO DEFINIDO PARA ANTICIPO DE SALARIO --->
            <cfquery name="rsCalendario" datasource="#session.DSN#">
            	select CPtipo from CalendarioPagos where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            </cfquery>
            <cfif rsCalendario.CPtipo EQ 2>
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" Ecodigo="#Session.Ecodigo#" Pvalor="730" default="" returnvariable="CIidAnticipo"/>
                <cfif Not Len(CIidAnticipo)>
                    <cf_errorCode	code="52146" msg="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!">
                </cfif>
                <cfquery name="deleteAnticipo" datasource="#session.DSN#">
                    delete from IncidenciasCalculo
                    where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                </cfquery>	
            </cfif>
			<!--- FIN DE ELIMINACION DE INCIDENCIA DE PAGO DE ANTICIPO --->
			<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
				<cfset dato = ListToArray(vchk[i],'|')>
				
				<cfif dato[1] eq 'I'>
				
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from IncidenciasCalculo
					where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					</cfquery>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfset Acciones = Acciones & 'Elimna Incidencia:' & dato[2] & ', '>
				<cfelseif dato[1] eq 'C'>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from CargasCalculo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfset Acciones = Acciones & 'Elimna Carga:' & dato[2] & ', '>
				<cfelseif dato[1] eq 'D'>
			
					<cfquery name="rsDeduccion" datasource="#session.DSN#">
						select t.TDley from DeduccionesCalculo a
							inner join DeduccionesEmpleado  b
									inner join TDeduccion t
									on t.TDid=b.TDid
								on a.DEid=b.DEid
								and a.Did=b.Did
						where a.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						and a.Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
						and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
					</cfquery>
					<cfif rsDeduccion.TDley gt 0>
						<cfset err='No se puede eliminar una deducción de ley'>
						<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
					<cfelse>
						<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
						delete from DeduccionesCalculo
						where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
						and RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						</cfquery>
						<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
						update SalarioEmpleado set SEcalculado = 0
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						</cfquery>
						<cfset Acciones = Acciones & 'Elimna Deduccion:' & dato[2] & ', '>
					</cfif>
				</cfif>
			</cfloop>

		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#"
			pDEid = "#form.DEid#" />
		<cfset Acciones = Acciones & 'Recalcular.'>
	<cfelseif isDefined("Form.butRecalcular")>
		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#" />
		<cfset Acciones = Acciones & 'Recalcular.'>
	</cfif>
<cfcatch type="any">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
</cfif>

<form action="ResultadoCalculoRetro.cfm" method="post" name="sql">
	<cfoutput>
		<input name="RCNid" type="hidden" value="#Form.RCNid#">
		<input name="DEid" type="hidden" value="#Form.DEid#">
		<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>


<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>

<!---
<cfoutput>#Acciones#</cfoutput>
<cfdump var="#Form#">
<a href="javascript:document.forms[0].submit();">Continuar</a>
--->
</body>
</HTML>


