<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPuedeEstarLaborandoActualmenteEnLaMismaEmpresaMasDeUnaVez"
	Default="No puede estar laborando actualmente en la misma empresa más de una vez"
	returnvariable="MSG_NoPuedeEstarLaborandoActualmenteEnLaMismaEmpresaMasDeUnaVez"/>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_nombre_de_la_empresa_ya_fue_registrado"
	Default="El nombre de la empresa ya fue registrado"
	returnvariable="MSG_El_nombre_de_la_empresa_ya_fue_registrado"/>


<cfset modoExperiencia = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfquery name="rsValidaActual" datasource="#session.DSN#">
		select Count(1) as cont
		from RHExperienciaEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			</cfif>	
			and RHEEnombreemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEnombreemp#">
			<cfif isdefined("form.Actualmente")>
				and Actualmente = 1
			<cfelse>
				and Actualmente = 0
			</cfif>
			and RHEEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">
			and RHEEfecharetiro = 	<cfif isdefined("form.Actualmente")>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#">
									</cfif>
			and 1=2 <!---- fcastro 2014-04-10, se suigiere que esta validacion no es necesaria por parte de Juan antonio en la implantacion ------>
	</cfquery>
	
	<cfif isdefined("Form.Alta")>
		<cfif isdefined("rsValidaActual") and rsValidaActual.cont EQ 0>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHExperienciaEmpleado (DEid, RHOid, Ecodigo, RHEEnombreemp, RHEEtelemp,RHEEAnnosLab,RHOPid, RHEEpuestodes, RHEEfechaini, RHEEfecharetiro, Actualmente, RHEEfunclogros, BMUsucodigo, BMfecha, RHEEmotivo,RHEEestado,
					RHEEDV1,RHEEDV2,RHEEDV3,RHEEDV4,RHEEDV5,RHEEDV6,RHEEDV7,RHEEDV8,RHEEDV9,RHEEDV10,RHEEobservacion
				)
				values(	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfelse>
							null,
						</cfif>	
						<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHEEnombreemp,1,80)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHEEtelemp,1,35)#"  null="#not Len(Trim(Form.RHEEtelemp))#">,
					    <cfif isdefined("form.RHEEAnnosLab") and len(trim(form.RHEEAnnosLab))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEEAnnosLab, ',','','all')#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHOPDescripcion,1,60)#">,
						
						
						
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
						<cfif isdefined("form.Actualmente")><cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#"></cfif>,
						<cfif isdefined("form.Actualmente")>1<cfelse>0</cfif>,
						<cfif isdefined("form.RHEEfunclogros") and len(trim(form.RHEEfunclogros))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHEEfunclogros#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfif isdefined("form.RHEEmotivo") and len(trim(form.RHEEmotivo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEmotivo#"><cfelse>50</cfif>,
                        <cfif isdefined('Lvar_EducAuto')>0<cfelse>1</cfif>,
						<cfif isdefined('form.RHEEDV1')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV1#" null="#Len(Trim(Form.RHEEDV1)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV2')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV2#" null="#Len(Trim(Form.RHEEDV2)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV3')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV3#" null="#Len(Trim(Form.RHEEDV3)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV4')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV4#" null="#Len(Trim(Form.RHEEDV4)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV5')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV5#" null="#Len(Trim(Form.RHEEDV5)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV6')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV6#" null="#Len(Trim(Form.RHEEDV6)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV7')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV7#" null="#Len(Trim(Form.RHEEDV7)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV8')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV8#" null="#Len(Trim(Form.RHEEDV8)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV9')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV9#" null="#Len(Trim(Form.RHEEDV9)) EQ 0#"><cfelse>null</cfif>,
						<cfif isdefined('form.RHEEDV10')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEDV10#" null="#Len(Trim(Form.RHEEDV10)) EQ 0#"><cfelse>null</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEobservacion#">
						)
			</cfquery>
			<cfset modoExperiencia="ALTA">
		<cfelse>
			<cfif isdefined("form.Actualmente")>
				<cf_throw message="#MSG_NoPuedeEstarLaborandoActualmenteEnLaMismaEmpresaMasDeUnaVez#" errorcode="10030">
			<cfelse>
				<cf_throw message="#MSG_El_nombre_de_la_empresa_ya_fue_registrado#" errorcode="10035">
			</cfif>

		</cfif>	
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHExperienciaEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
				</cfif>	
		</cfquery>  
		<cfset modoExperiencia="ALTA">

	<cfelseif isdefined("Form.Cambio")>			
		<cfif isdefined("form.Actualmente")>
			<cfquery name="rsValidaUpdate" datasource="#session.DSN#">
				select *
				from RHExperienciaEmpleado
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
						and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
					</cfif>	
					and RHEEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#" >
					<cfif isdefined("form.Actualmente")>
						and Actualmente = 1
					<cfelse>
						and Actualmente = 0
					</cfif>
					and RHEEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">
					and RHEEfecharetiro = 	<cfif isdefined("form.Actualmente")>
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">
											<cfelse>
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#">
											</cfif>
					and 1=2 <!---- fcastro 2014-04-10, se suigiere que esta validacion no es necesaria por parte de Juan antonio en la implantacion ------>						
			</cfquery>
			<cfif rsValidaUpdate.recordcount gt 0 >
				<cfif isdefined("form.Actualmente")>
					<cf_throw message="#MSG_NoPuedeEstarLaborandoActualmenteEnLaMismaEmpresaMasDeUnaVez#" errorcode="10030">
				<cfelse>
					<cf_throw message="#MSG_El_nombre_de_la_empresa_ya_fue_registrado#" errorcode="10035">
				</cfif>
			</cfif>			
		</cfif> 
		
			<cf_dbtimestamp datasource="#session.dsn#"
							table="RHExperienciaEmpleado"
							redirect="experiencia.cfm"
							timestamp="#form.ts_rversion#"				
							field1="Ecodigo" 
							type1="integer" 
							value1="#session.Ecodigo#"
							field2="RHEEid" 
							type2="numeric" 
							value2="#form.RHEEid#">
	
			<cfquery name="update" datasource="#Session.DSN#">
				update RHExperienciaEmpleado
				set	RHEEnombreemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHEEnombreemp,1,80)#">,
					RHEEtelemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHEEtelemp,1,35)#"  null="#not Len(Trim(Form.RHEEtelemp))#">,
					RHOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPid#">,
					RHEEAnnosLab  = <cfif isdefined("form.RHEEAnnosLab") and len(trim(form.RHEEAnnosLab))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEEAnnosLab, ',','','all')#"><cfelse>null</cfif>,
					RHEEpuestodes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHOPDescripcion,1,60)#">,
					RHEEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
					RHEEfecharetiro = <cfif isdefined("form.Actualmente")><cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#"></cfif>,
					Actualmente = <cfif isdefined("form.Actualmente")>1<cfelse>0</cfif>,
					RHEEfunclogros = <cfif isdefined("form.RHEEfunclogros") and len(trim(form.RHEEfunclogros))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHEEfunclogros#"><cfelse>null</cfif>,
					RHEEmotivo = <cfif isdefined("form.RHEEmotivo") and len(trim(form.RHEEmotivo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEmotivo#"><cfelse>50</cfif>
					,RHEEDV1 	= <cfif isdefined('form.RHEEDV1')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV1#" null="#Len(Trim(Form.RHEEDV1)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV2 	= <cfif isdefined('form.RHEEDV2')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV2#" null="#Len(Trim(Form.RHEEDV2)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV3 	= <cfif isdefined('form.RHEEDV3')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV3#" null="#Len(Trim(Form.RHEEDV3)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV4 	= <cfif isdefined('form.RHEEDV4')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV4#" null="#Len(Trim(Form.RHEEDV4)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV5 	= <cfif isdefined('form.RHEEDV5')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV5#" null="#Len(Trim(Form.RHEEDV5)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV6 	= <cfif isdefined('form.RHEEDV6')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV6#" null="#Len(Trim(Form.RHEEDV6)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV7 	= <cfif isdefined('form.RHEEDV7')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV7#" null="#Len(Trim(Form.RHEEDV7)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV8 	= <cfif isdefined('form.RHEEDV8')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV8#" null="#Len(Trim(Form.RHEEDV8)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV9 	= <cfif isdefined('form.RHEEDV9')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV9#" null="#Len(Trim(Form.RHEEDV9)) EQ 0#"><cfelse>null</cfif>
					,RHEEDV10 	= <cfif isdefined('form.RHEEDV10')><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEEDV10#" null="#Len(Trim(Form.RHEEDV10)) EQ 0#"><cfelse>null</cfif>
                    ,RHEEobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEobservacion#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#" >
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
						and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
					</cfif>				
			</cfquery> 
			<cfset modoExperiencia="CAMBIO">
	</cfif>
</cfif>

<cfoutput>

<!---- <cfif isdefined("form.DEid") and len(trim(form.DEid))>expediente.cfm<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>../../Reclutamiento/catalogos/OferenteExterno.cfm</cfif> ----->
<form action="<cfif isdefined("form.DEid") and len(trim(form.DEid))><cfif isdefined('Lvar_EducAuto')>../../autogestion/autogestion.cfm<cfelse>expediente.cfm</cfif><cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>../../Reclutamiento/catalogos/OferenteExterno.cfm</cfif>" method="post" name="sqlExperiencia">
	<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input name="RHOid" type="hidden" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
	<cfif isdefined('Lvar_EducAuto')>
		<input type="hidden" name="tab" value="7">
	<cfelse>
		<input type="hidden" name="tab" value="3">
	</cfif>
	<input name="o" type="hidden" value="2">			
	<input name="sel" type="hidden" value="1">
	<cfif isdefined("form.Cambio")>
		<input name="RHEEid" type="hidden" value="#form.RHEEid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
