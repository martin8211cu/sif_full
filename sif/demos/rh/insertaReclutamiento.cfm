<cfset session.LvarOferentes = structnew() >	

<cfquery name="data" datasource="#session.DSNnuevo#">
	select * 
	from DatosOferentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif data.RecordCount EQ 0>
	<cfquery name="oferentes" datasource="#session.DSNnuevo#" >
		select *
		from DatosOferentes
		where Ecodigo = #vn_Ecodigo#
	</cfquery>

	<cfloop query="oferentes">
		<cfset LvarRHOid = oferentes.RHOid >
		<cfset LvarIdentificacion = oferentes.RHOidentificacion>
		<!---Inserta DatosOferentes---->
		<cfquery name="selectI_oferente" datasource="#session.DSNnuevo#">
			select	(select min(NTIcodigo) from NTipoIdentificacion ) as NTIcodigo, 
					RHOidentificacion,
					RHOnombre,
					RHOapellido1, RHOapellido2, RHOdireccion, RHOtelefono1, RHOtelefono2, 
					RHOemail, RHOcivil, RHOfechanac, RHOsexo, RHOobs1,
					RHOobs2, RHOobs3, RHOdato1, RHOdato2, RHOdato3, 
					RHOdato4, RHOdato5, RHOinfo1, RHOinfo2, RHOinfo3, 
					RHOregistrado, Ppais, 
					null as DEid, 
					RHOfechaRecep, RHOfechaIngr,  
					RHOPrenteInf, RHOPrenteSup, RHOPosViajar,RHOPosTralado, RHORefValida, 
					RHOEntrevistado, RHOfechaEntrevista, RHORealizadaPor, RHOLengOral1, RHOLengOral2, 
					RHOLengOral3, RHOLengEscr1, RHOLengEscr2, RHOLengEscr3, RHOLengLect1, 
					RHOLengLect2, RHOLengLect3, RHOIdioma1, RHOIdioma2, RHOIdioma3, 
					RHOMonedaPrt, 
					id_direccion, 
					RHPassword, RHPregunta, RHRespuesta, RHAprobado, RHAutentificar
			from DatosOferentes a				
			where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHOid#">
		</cfquery>
		<cfquery name="i_oferente" datasource="#session.DSNnuevo#">
			insert into DatosOferentes (Ecodigo, NTIcodigo, RHOidentificacion, RHOnombre, 
										RHOapellido1, RHOapellido2, RHOdireccion, RHOtelefono1, RHOtelefono2, 
										RHOemail, RHOcivil, RHOfechanac, RHOsexo, RHOobs1, 
										RHOobs2, RHOobs3, RHOdato1, RHOdato2, RHOdato3, 
										RHOdato4, RHOdato5, RHOinfo1, RHOinfo2, RHOinfo3, 
										RHOregistrado, Ppais, DEid, RHOfechaRecep, RHOfechaIngr, 
										RHOPrenteInf, RHOPrenteSup, RHOPosViajar,RHOPosTralado, RHORefValida, 
										RHOEntrevistado, RHOfechaEntrevista, RHORealizadaPor, RHOLengOral1, RHOLengOral2, 
										RHOLengOral3, RHOLengEscr1, RHOLengEscr2, RHOLengEscr3, RHOLengLect1, 
										RHOLengLect2, RHOLengLect3, RHOIdioma1, RHOIdioma2, RHOIdioma3, 
										RHOMonedaPrt, id_direccion, RHPassword, RHPregunta, RHRespuesta, 
										RHAprobado, RHAutentificar)
						VALUES(
							   #session.EcodigoNuevo#,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectI_oferente.NTIcodigo#"          voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#selectI_oferente.RHOidentificacion#"  voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHOnombre#"          voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#selectI_oferente.RHOapellido1#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#selectI_oferente.RHOapellido2#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectI_oferente.RHOdireccion#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOtelefono1#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOtelefono2#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120" value="#selectI_oferente.RHOemail#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOcivil#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectI_oferente.RHOfechanac#"        voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectI_oferente.RHOsexo#"            voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectI_oferente.RHOobs1#"            voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectI_oferente.RHOobs2#"            voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectI_oferente.RHOobs3#"            voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOdato1#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOdato2#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOdato3#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOdato4#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectI_oferente.RHOdato5#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHOinfo1#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHOinfo2#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHOinfo3#"           voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOregistrado#"      voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectI_oferente.Ppais#"              voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectI_oferente.DEid#"               voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectI_oferente.RHOfechaRecep#"      voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectI_oferente.RHOfechaIngr#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOPrenteInf#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOPrenteSup#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOPosViajar#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOPosTralado#"      voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHORefValida#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOEntrevistado#"    voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectI_oferente.RHOfechaEntrevista#" voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHORealizadaPor#"    voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengOral1#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengOral2#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengOral3#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengEscr1#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengEscr2#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengEscr3#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengLect1#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengLect2#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectI_oferente.RHOLengLect3#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOIdioma1#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOIdioma2#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHOIdioma3#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="3"   value="#selectI_oferente.RHOMonedaPrt#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectI_oferente.id_direccion#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="128" value="#selectI_oferente.RHPassword#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHPregunta#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectI_oferente.RHRespuesta#"        voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHAprobado#"         voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectI_oferente.RHAutentificar#"     voidNull>
						)			
			<cf_dbidentity1 datasource="#session.DSNnuevo#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSNnuevo#" name="i_oferente">
	
		<cfset structInsert(session.LvarOferentes, LvarRHOid, i_oferente.identity) >
		
		<!----Inserta Experiencia Laboral--->
		<cfquery datasource="#session.DSNnuevo#">
			insert into RHExperienciaEmpleado (DEid, Ecodigo, RHOid, 
											RHEEnombreemp, RHEEtelemp, RHEEpuestodes, 
											RHEEfechaini, RHEEfecharetiro, Actualmente, 
											RHEEfunclogros, RHEEmotivo, BMUsucodigo, 
											BMfecha,  RHEEAnnosLab, RHOPid)
			select 	null as DEid,
					#session.EcodigoNuevo# as Ecodigo,
					#session.LvarOferentes[LvarRHOid]# as RHOid,
					RHEEnombreemp, 
					RHEEtelemp, 
					RHEEpuestodes, 							
					RHEEfechaini, 
					RHEEfecharetiro, 
					Actualmente, 
					RHEEfunclogros, 
					RHEEmotivo, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#"> as BMUsucodigo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as BMfecha,
					RHEEAnnosLab, 
					RHOPid
			from RHExperienciaEmpleado	
			where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHOid#">
		</cfquery>
		
		<!---Inserta la educacion--->
		<cfquery name="rsEducacion" datasource="#session.DSNnuevo#"><!---Educacion del oferente en minisif_base---->			
			select b.RHIAcodigo, c.GAnombre, a.RHEElinea
			from RHEducacionEmpleado a
				inner join RHInstitucionesA b
					on a.RHIAid = b.RHIAid	
				inner join GradoAcademico c
					on a.GAcodigo = c.GAcodigo			
			where a.Ecodigo = #vn_Ecodigo#
				and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHOid#">			 
		</cfquery>
		
		<cfloop query="rsEducacion">
			<!---Obtener el ID de la institucion---->
			<cfquery name="rsInst" datasource="#session.DSNnuevo#">
				select RHIAid 
				from RHInstitucionesA
				where RHIAcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEducacion.RHIAcodigo#">
					and Ecodigo = #session.EcodigoNuevo#
			</cfquery>
			<!---Obtener el ID del grado academico--->
			<cfquery name="rsGAcam" datasource="#session.DSNnuevo#">
				select GAcodigo
				from GradoAcademico
				where GAnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEducacion.GAnombre#">
					and Ecodigo = #session.EcodigoNuevo#
			</cfquery>			
			<cfif rsInst.RecordCount NEQ 0 and len(trim(rsInst.RHIAid))>
				<cfquery datasource="#session.DSNnuevo#">
					insert into RHEducacionEmpleado (DEid, Ecodigo, RHIAid, 
													GAcodigo, RHOid, RHEotrains, 
													RHEtitulo, RHEfechaini, RHEfechafin, 
													RHEsinterminar, BMUsucodigo, BMfecha, 
													RHOTid, RHECapNoFormal, RHEestado)
					select	null as DEid,
							#session.EcodigoNuevo# as Ecodigo,
							#rsInst.RHIAid# as RHIAid,
							#rsGAcam.GAcodigo# as GAcodigo,
							#session.LvarOferentes[LvarRHOid]# as RHOid,
							RHEotrains,
							RHEtitulo, 
							RHEfechaini, 
							RHEfechafin, 
							RHEsinterminar,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#"> as BMUsucodigo,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as BMfecha,
							RHOTid,
							RHECapNoFormal, 
							RHEestado							
					from RHEducacionEmpleado
					where RHEElinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEducacion.RHEElinea#">
				</cfquery>		
			</cfif>
		</cfloop><!----Loop de instituciones---->
	</cfloop><!----Loop de oferentes---->
</cfif>
