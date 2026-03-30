<cfsilent>
	<cfset t = createObject("component", "sif.Componentes.Translate")>

	<!--- Etiquetas de traducción --->
	<cfset LB_InfoConcurso = t.translate('LB_InfoConcurso','Información del Concurso','/rh/generales.xml')>
	<cfset LB_AdministradorPortal = t.translate('LB_AdministradorPortal','Administrador del Portal','/rh/generales.xml')>
	<cfset lvarResult = '' >

	<!--- opcion(1) > ALL Concursantes, opcion(2) > Concursantes Descalificados, opcion(3) > Concursantes NO Seleccionados opcion(4) > Concursantes NO Seleccionados --->
	<cfif isdefined("form.opcion") and len(trim(form.opcion))> 
		<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
		<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
		<cfquery name="rsCorreoConcursantes" datasource="#session.dsn#">	
			select de.DEidentificacion as identificacion, de.DEapellido1 as apellido1, de.DEapellido2 as apellido2, 
			de.DEnombre as nombre, de.DEemail as email, rhc.RHCconcurso, rhcc.RHCcodigo, #LvarRHCdescripcion# as concurso, 
			#LvarRHPdescpuesto# as puesto
			from RHConcursantes rhc
			inner join RHConcursos rhcc
				on rhc.RHCconcurso = rhcc.RHCconcurso
				inner join RHPuestos rhp
					on rhcc.RHPcodigo = rhp.RHPcodigo
					and rhcc.Ecodigo = rhp.Ecodigo
			inner join DatosEmpleado de
				on rhc.DEid = de.DEid
	    	where rhc.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">	
	    		<cfif form.opcion eq 2>
	    			and rhc.RHCdescalifica = 1
	    		<cfelseif form.opcion eq 3>
	    			and rhc.DEid not in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = rhc.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)	
	    			and rhc.RHCdescalifica = 0
	    		<cfelseif form.opcion eq 4>
	    			and rhc.DEid in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = rhc.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)	
	    			and rhc.RHCdescalifica = 0
	    		</cfif>	
	    	union

	    	select do.RHOidentificacion as identificacion, do.RHOapellido1 as apellido1, do.RHOapellido2 as apellido2,
	    	do.RHOnombre as nombre, do.RHOemail as email, rhc.RHCconcurso, rhcc.RHCcodigo, #LvarRHCdescripcion# as concurso, 
			#LvarRHPdescpuesto# as puesto
			from RHConcursantes rhc
			inner join RHConcursos rhcc
				on rhc.RHCconcurso = rhcc.RHCconcurso
				inner join RHPuestos rhp
					on rhcc.RHPcodigo = rhp.RHPcodigo
					and rhcc.Ecodigo = rhp.Ecodigo
			inner join DatosOferentes do	
				on rhc.RHOid = do.RHOid
			where rhc.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				<cfif form.opcion eq 2>
	    			and rhc.RHCdescalifica = 1
	    		<cfelseif form.opcion eq 3>
	    			and rhc.DEid not in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = rhc.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)	
	    			and rhc.RHCdescalifica = 0
	    		<cfelseif form.opcion eq 4>
	    			and rhc.DEid in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = rhc.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)	
	    			and rhc.RHCdescalifica = 0
	    		</cfif>	
		</cfquery>
	</cfif>

	<cfif isdefined("rsCorreoConcursantes") and rsCorreoConcursantes.RecordCount>
		<cfif form.opcion eq 1>
			<cfset vPcodigo = 2712 >  <!--- All Concursantes --->
		<cfelseif form.opcion eq 2> 
			<cfset vPcodigo = 2713 >  <!--- Concursantes Descalificados --->
		<cfelseif form.opcion eq 3>
			<cfset vPcodigo = 2714 >  <!--- Concursantes NO Seleccionados --->
		<cfelseif form.opcion eq 4>
			<cfset vPcodigo = 2728 >  <!--- Concursantes  Seleccionados --->
		</cfif>

		<cfquery name="rsFormatCorreo" datasource="#session.DSN#" maxrows="1">
			select df.DFtexto, ef.EFid as EFid
			from RHParametros rhp
			inner join EFormato ef
					on rhp.Pvalor = ef.EFid
				inner join DFormato df 
					on ef.EFid = df.EFid
			where rhp.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPcodigo#">
			and rhp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsFormatCorreo.RecordCount and len(trim(rsFormatCorreo.DFtexto))>
			<cfloop query="rsCorreoConcursantes">
				<cfif len(trim(email)) gt 0>
					<cfset email_subject = "#LB_InfoConcurso#: #RHCconcurso# - #concurso#">
					<cfset email_from = "">
					<cfset email_to = '#email#'> 
					<cfset email_cc = '#LB_AdministradorPortal#'>

					<cfsavecontent variable="email_body">
						<html>
						<head></head>
						<body>
							<!--- Inicio del cuerpo del correo --->
							<cfset salida = replace(rsFormatCorreo.DFtexto, '##Apellido##', apellido1, 'all')>
							<cfset salida = replace(salida, '##NoConcurso##', RHCcodigo, 'all')>
							<cfset salida = replace(salida, '##Cargo##', puesto, 'all')>
							<cfset salida = replace(salida, '##', '', 'all')>
							<cfoutput>#salida#</cfoutput>
							<!--- Fin del cuerpo del correo --->
						</body>
						</html>
					</cfsavecontent>

					<cftransaction isolation="read_uncommitted">
						<cfquery datasource="minisif">
							insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
							values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1
								)
						</cfquery>
					</cftransaction>	
				</cfif>	
			</cfloop>
			<cfset lvarResult = 'RS' > <!--- Resultado Satisfactorio --->	
		<cfelse>
			<cfset lvarResult = 'NF' > <!--- Ningun Formato de Correo asociado --->	
		</cfif>	
	<cfelse>
		<cfset lvarResult = 'NC' > <!--- Ningun Concursante asociado --->	
	</cfif>
</cfsilent>
<cfoutput>#lvarResult#</cfoutput>