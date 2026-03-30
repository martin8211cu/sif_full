<!--- /////////////////////////////////// CATALOGOS ///////////////////////////////////---->
<!---1. Instituciones académicas--->
<cfquery name="ExisteInstitucion" datasource="#session.DSNnuevo#">
	select 1 from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteInstitucion.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHInstitucionesA (Ecodigo, CEcodigo, RHIAcodigo, 
									RHIAnombre, RHIAtelefono, RHIAfax, 
									RHIAurl, BMfecha, BMUsucodigo, 
									RHIAcontacto, RHIAtelefonoc, RHIAemailc)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">,
					RHIAcodigo, 
					RHIAnombre, 
					RHIAtelefono, 
					RHIAfax, 
					RHIAurl,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					RHIAcontacto, 
					RHIAtelefonoc, 
					RHIAemailc
			from RHInstitucionesA		
			where Ecodigo = #vn_Ecodigo#				
	</cfquery>
</cfif>

<!---2. Grados Académicos---->
<cfquery name="ExisteGrado" datasource="#session.DSNnuevo#">
	select 1 from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteGrado.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into GradoAcademico (Ecodigo, GAnombre, GAorden, BMUsucodigo)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,				
					GAnombre,
					GAorden,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from GradoAcademico
			where Ecodigo = #vn_Ecodigo#		
	</cfquery>
</cfif>

<!---3.  Areas de capacitación--->
<cfquery name="ExisteArea" datasource="#session.DSNnuevo#">
	select 1 from RHAreasCapacitacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteArea.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHAreasCapacitacion (Ecodigo, RHACcodigo, RHACdescripcion, BMfecha, BMUsucodigo)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					RHACcodigo, 
					RHACdescripcion,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from RHAreasCapacitacion
			where Ecodigo = #vn_Ecodigo#		
	</cfquery>
</cfif>

<!---4. Areas de programa---->
<cfquery name="ExisteGrupo" datasource="#session.DSNnuevo#">
	select 1 from RHAreaGrupoMat
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteGrupo.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHAreaGrupoMat(Ecodigo, RHAGMnombre, BMfecha, BMUsucodigo)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					RHAGMnombre ,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from RHAreaGrupoMat
			where Ecodigo = #vn_Ecodigo#		
	</cfquery>
</cfif>

<!---5. Materias (Se inserta RHACid nulo porque el DATA los RHACid insertados existen pero para otra empresa, es decir otro Ecodigo != 28) --->
<cfquery name="ExisteMateria" datasource="#session.DSNnuevo#">
	select 1 from RHMateria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteMateria.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHMateria (Ecodigo, CEcodigo, RHACid, Mnombre, Msiglas, Mactivo, BMfecha, BMUsucodigo,Mdescripcion)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">,
					null,
					Mnombre,
					Msiglas,
					Mactivo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					Mdescripcion
			from RHMateria	
			where Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSNnuevo#">
		insert into Materia(Ecodigo, Mtipo, Mcodificacion, Mnombre, Mactivo, 
							Mcreditos, MhorasTeorica, MhorasPractica, MhorasEstudio,
							MotrasCarreras, McualquierCarrera, McursoLibre, Madministrativa, 
							Mexterna, EScodigo, GAcodigo, CILcodigo, MtipoCicloDuracion, 
							TRcodigo, PEVcodigo, MtipoCalificacion, MpuntosMax, MunidadMin, 
							Mredondeo, TEcodigo, TTcodigoCurso, Mrequisitos)
		select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				Mtipo, Mcodificacion, Mnombre, Mactivo, 
				Mcreditos, MhorasTeorica, MhorasPractica, MhorasEstudio,
				MotrasCarreras, McualquierCarrera, McursoLibre, Madministrativa, 
				Mexterna, EScodigo, GAcodigo, CILcodigo, MtipoCicloDuracion, 
				TRcodigo, PEVcodigo, MtipoCalificacion, MpuntosMax, MunidadMin, 
				Mredondeo, TEcodigo, TTcodigoCurso, Mrequisitos
		from Materia
		where Ecodigo = #vn_Ecodigo#		
	</cfquery>
</cfif>


<!---//////////////////// Programacion de cursos ///////////////////////////// ---->
<!---6. Grupos de materias--->
<cfquery name="ExisteGMaterias" datasource="#session.DSNnuevo#">
	select 1 from RHGrupoMaterias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteGMaterias.RecordCount EQ 0>
	<cfquery name="rsGrupoMat" datasource="#session.DSNnuevo#"><!---Traer todos los grupos de materias de la empresa DATA--->
		select a.RHGMcodigo, a.Descripcion, b.RHAGMnombre, a.RHGMperiodo
		from RHGrupoMaterias a
			left outer join  RHAreaGrupoMat b
				on a.Ecodigo = b.Ecodigo
				and a.RHAGMid = b.RHAGMid
		where a.Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfloop query="rsGrupoMat"><!---Para c/grupo de DATA insertarlo en empresa nueva---->
		<cfset vsRHAGMnombre= rsGrupoMat.RHAGMnombre><!---Variable string con la descripcion del RHAreaGrupoMat--->	
		<cfif len(trim(vsRHAGMnombre))>
			<cfquery name="rsArea" datasource="#session.DSNnuevo#"><!----Obtener el RHAGMid de la nueva empresa----->
				select RHAGMid from RHAreaGrupoMat
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHAGMnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsRHAGMnombre#">
			</cfquery>	
		</cfif>
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar los grupos de materias---->
			insert into RHGrupoMaterias (RHAGMid, RHGMcodigo, Descripcion, Ecodigo, BMfecha, BMUsucodigo, RHGMperiodo)
				values(	<cfif isdefined("rsArea") and rsArea.RecordCount NEQ 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsArea.RHAGMid#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupoMat.RHGMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGrupoMat.Descripcion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
						<cfif len(trim(rsGrupoMat.RHGMperiodo))><cfqueryparam cfsqltype="cf_sql_integer" value="#rsGrupoMat.RHGMperiodo#"><cfelse>null</cfif>
					   )
		</cfquery>
		<cfset vsRHAGMnombre = ''>
		<cfset rsArea = querynew('RHAGMid')><!---Crea de nuevo el query rsArea para que quede limpio al entrar de nuevo al ciclo--->
	</cfloop>
</cfif>

<!---7. RHMateriasGrupo----->	
<cfquery name="ExisteMateriasG" datasource="#session.DSNnuevo#">
	select 1 from RHMateriasGrupo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteMateriasG.RecordCount EQ 0>
	<cfquery name="rsMateriasGrupo" datasource="#session.DSNnuevo#">
		select b.RHGMcodigo,c.Msiglas,a.RHMGperiodo, a.RHMGimportancia, a.RHMGsecuencia
		from RHMateriasGrupo a
			inner join RHGrupoMaterias b
				on a.RHGMid = b.RHGMid
				and a.Ecodigo = b.Ecodigo
			inner join RHMateria c
				on a.Ecodigo = c.Ecodigo
				and a.Mcodigo = c.Mcodigo
		where a.Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfloop query="rsMateriasGrupo">
		<cfset vsGrupo = rsMateriasGrupo.RHGMcodigo><!---Variable string con el codigo del grupo en empresa DATA--->
		<cfset vsSiglas = rsMateriasGrupo.Msiglas><!---Variable string con las siglas de la materia en empresa DATA---->
		<cfquery name="rsGrupoMaterias" datasource="#session.DSNnuevo#"><!---Obenter la llave (RHGMid) asignada a ese grupo en la empresa nueva---->
			select RHGMid from RHGrupoMaterias
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHGMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsGrupo#">
		</cfquery>
		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Obenter la llave (Mcodigo) asignada a esa materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsSiglas#">
		</cfquery>
		<cfquery datasource="#session.DSNnuevo#">
			insert into RHMateriasGrupo (Mcodigo, RHGMid, Ecodigo, 
										BMfecha, BMUsucodigo, RHMGperiodo, 
										RHMGimportancia, RHMGsecuencia)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrupoMaterias.RHGMid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfif len(trim(rsMateriasGrupo.RHMGperiodo))><cfqueryparam cfsqltype="cf_sql_integer" value="#rsMateriasGrupo.RHMGperiodo#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMateriasGrupo.RHMGimportancia#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMateriasGrupo.RHMGsecuencia#">
					)							
		</cfquery>
	</cfloop>
</cfif>

<!---///////////////////////////////////////////////// ---->
<!---8. Conocimientos por materia---->
<!----
<cfquery name="ExisteConocimMteria" datasource="#session.DSNnuevo#">
	select 1 from RHConocimientosMaterias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteConocimMteria.RecordCount EQ 0>
	<cfquery name="rsConocimientosMat" datasource="#session.DSNnuevo#">
		select a.RHCMfalta, a.RHCMestado, b.Msiglas, c.RHCcodigo
		from RHConocimientosMaterias a
			inner join RHMateria b
				on a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			inner join RHConocimientos c
				on a.Ecodigo = c.Ecodigo
				and a.RHCid = c.RHCid
		where a.Ecodigo = #vn_Ecodigo#	
	</cfquery>

	<cfloop query="rsConocimientosMat">
		<cfset vsMsiglas = rsConocimientosMat.Msiglas><!---Variable con la codificacion de la materia en la empresa DATA---->
		<cfset vsRHCcodigo = rsConocimientosMat.RHCcodigo><!---Variable con el codigo del conocimiento en DATA--->
		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
		</cfquery>
		<cfquery name="rsConocimientos" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHCid) del conocimiento en la empresa nueva--->
			select RHCid from RHConocimientos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHCcodigo#">
		</cfquery>
		<cfif isdefined("rsMateria") and rsMateria.RecordCount NEQ 0 and isdefined("rsConocimientos") and rsConocimientos.RecordCount neq 0>
			<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
				insert into RHConocimientosMaterias (Ecodigo, Mcodigo, RHCid, 
													Usucodigo, RHCMfalta, RHCMestado, 
													BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConocimientos.RHCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsConocimientosMat.RHCMfalta#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConocimientosMat.RHCMestado#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
						)									
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
---->

<!---9. Habilidades por materia--->
<cfquery name="ExisteHabMteria" datasource="#session.DSNnuevo#">
	select 1 from RHHabilidadesMaterias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteHabMteria.RecordCount EQ 0>
	<cfquery name="rsHabilidadesMat" datasource="#session.DSNnuevo#">
		select a.RHHMfalta, a.RHHMestado, b.Msiglas, c.RHHcodigo
		from RHHabilidadesMaterias a
			inner join RHMateria b
				on a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			inner join RHHabilidades c
				on a.Ecodigo = c.Ecodigo
				and a.RHHid = c.RHHid
		where a.Ecodigo = #vn_Ecodigo#	
			and c.RHHubicacionB is not null
	</cfquery>
	<cfloop query="rsHabilidadesMat">
		<cfset vsMsiglas = rsHabilidadesMat.Msiglas><!--Variable con la sigla de la materia en la empresa DATA---->
		<cfset vsRHHcodigo = rsHabilidadesMat.RHHcodigo><!---Variable con el codigo de la habilidad en DATA--->
		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
		</cfquery>
		<cfquery name="rsHabilidades" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHHid) de la habilidad en la empresa nueva--->
			select RHHid from RHHabilidades
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHHcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHHcodigo#">
		</cfquery>
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHHabilidadesMaterias (Ecodigo, Mcodigo, RHHid, 
												Usucodigo, RHHMfalta, RHHMestado, 
												BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabilidades.RHHid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsHabilidadesMat.RHHMfalta#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsHabilidadesMat.RHHMestado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
					)													
		</cfquery>
	</cfloop>
</cfif>	

<!----10. Tipos de curso---->
<cfquery name="ExisteTipo" datasource="#session.DSNnuevo#">
	select 1 from RHTipoCurso
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteTipo.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHTipoCurso(RHTCdescripcion, Ecodigo, BMfecha, BMUsucodigo)
			select 	RHTCdescripcion,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from RHTipoCurso
			where Ecodigo = #vn_Ecodigo# 		
	</cfquery>
</cfif>

<!---/////////////////////////////////// OPERACION ///////////////////////////////////---->
<!--- 1. Oferta interna---->
<cfquery name="ExisteOfertas" datasource="#session.DSNnuevo#">
	select 1 from RHOfertaAcademica
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteOfertas.RecordCount EQ 0>
	<cfquery name="rsOfertaInterna" datasource="#session.DSNnuevo#">
		select a.RHOAactivar, b.Msiglas,c.RHIAcodigo 
		from RHOfertaAcademica a
			inner join RHMateria b
				on a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			inner join RHInstitucionesA c
				on a.Ecodigo = c.Ecodigo
				and a.RHIAid = c.RHIAid
		where a.Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfloop query="rsOfertaInterna">
		<cfset vsMsiglas = rsOfertaInterna.Msiglas><!---Variable con la sigla de la materia en la empresa DATA---->
		<cfset vsRHIAcodigo = rsOfertaInterna.RHIAcodigo><!---Variable con el codigo de la institucion en DATA--->
		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
		</cfquery>
		<cfquery name="rsInstituciones" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHIAid) de la institucion en la empresa nueva--->
			select RHIAid from RHInstitucionesA
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHIAcodigo#">
		</cfquery>
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHOfertaAcademica (RHIAid, Mcodigo, RHOAactivar, 
											CEcodigo, Ecodigo, BMfecha, 
											BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInstituciones.RHIAid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOfertaInterna.RHOAactivar#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
					)									
		</cfquery>
	</cfloop>
</cfif>	

<!---- 2. Cursos (RHCursos, instancia de cursos)---->
<cfquery name="ExisteCursos" datasource="#session.DSNnuevo#">
	select 1 from RHCursos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExisteCursos.RecordCount EQ 0>
	<cfset estructCursos = structnew()><!--Estructura con los cursos, por ejemplo estructCursos[RHCid_en_DATA] = RHCid_en_nueva_empresa--->
	<cfquery name="rsRHCursos" datasource="#session.DSNnuevo#">
		select 	b.RHTCdescripcion, c.Msiglas, d.RHIAcodigo, a.RHCcodigo, a.RHCfdesde, 
				a.RHCfhasta, a.RHCprofesor, a.RHCcupo, a.RHCautomat, a.RHECtotempresa, 
				a.RHECtotempleado, a.idmoneda, a.RHECcobrar, a.RHCnombre, a.RHCid
		from RHCursos a
			inner join RHTipoCurso b
				on a.Ecodigo = b.Ecodigo
				and a.RHTCid = b.RHTCid
			inner join RHMateria c
				on a.Ecodigo = c.Ecodigo
				and a.Mcodigo = c.Mcodigo
			inner join RHInstitucionesA d
				on a.Ecodigo = d.Ecodigo
				and a.RHIAid = d.RHIAid
		where a.Ecodigo = #vn_Ecodigo#
	</cfquery>
	<cfset estructCursos.lista = valuelist(rsRHCursos.RHCid) ><!--Cargar la estructura con las llaves de los cursos (RHCid)--->
	<cfloop query="rsRHCursos">
		<cfset vsMsiglas = rsRHCursos.Msiglas><!--Variable con la sigla de la materia en la empresa DATA---->
		<cfset vsRHIAcodigo = rsRHCursos.RHIAcodigo><!---Variable con el codigo de la institucion en DATA--->
		<cfset vsTipo = rsRHCursos.RHTCdescripcion><!---Variable con la descripcion del tipo de curso en DATA--->
		<cfset vnRHCid = rsRHCursos.RHCid><!---Variable con la llave de cursos (RHCid)--->

		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
		</cfquery>
		<cfquery name="rsInstituciones" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHIAid) de la institucion en la empresa nueva--->
			select RHIAid from RHInstitucionesA
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHIAcodigo#">
		</cfquery>
		<cfquery name="rsTipo" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHTCid) del tipo de curso de la empresa nueva--->
			select RHTCid from RHTipoCurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHTCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsTipo#">
		</cfquery>

		<cfquery  name="insertaCursos" datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHCursos (RHIAid, Mcodigo, RHTCid, 
									RHCcodigo, Ecodigo, RHCfdesde, 
									RHCfhasta, RHCprofesor, RHCcupo, 
									RHCautomat, RHECtotempresa, RHECtotempleado, 
									idmoneda, RHECcobrar, BMfecha, 
									BMUsucodigo, RHCnombre)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInstituciones.RHIAid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipo.RHTCid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsRHCursos.RHCcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsRHCursos.RHCfdesde#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsRHCursos.RHCfhasta#">,
					<cfif len(trim(rsRHCursos.RHCprofesor))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHCursos.RHCprofesor#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRHCursos.RHCcupo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRHCursos.RHCautomat#">,
					<cfif len(trim(rsRHCursos.RHECtotempresa))><cfqueryparam cfsqltype="cf_sql_money"  value="#rsRHCursos.RHECtotempresa#"><cfelse>null</cfif>,
					<cfif len(trim(rsRHCursos.RHECtotempleado))><cfqueryparam cfsqltype="cf_sql_money"  value="#rsRHCursos.RHECtotempleado#"><cfelse>null</cfif>,
					<cfif len(trim(rsRHCursos.idmoneda))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCursos.idmoneda#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#rsRHCursos.RHECcobrar#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHCursos.RHCnombre#">
					)	
				<cf_dbidentity1 datasource="#session.DSNnuevo#">	
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSNnuevo#" name="insertaCursos">
				
		<cfset structInsert(estructCursos, vnRHCid, insertaCursos.identity) ><!---Carga el valor del nuevo ID en la estructuta --->
	</cfloop>
</cfif>   	


<!---2.1 Programacion de cursos--->
<cfquery name="rsProgramacion" datasource="#session.DSNnuevo#">
	select a.RHPCfdesde, a.RHPCfhasta, c.RHACcodigo, d.Msiglas, e.RHIAcodigo, a.DEid, a.RHCid, a.RHIAid, a.RHACid, a.Mcodigo
	from RHProgramacionCursos a
		left outer join RHAreasCapacitacion c
			on a.Ecodigo = c.Ecodigo
			and a.RHACid = c.RHACid	
		left outer join RHMateria d
			on a. Ecodigo = d.Ecodigo
			and a.Mcodigo = d.Mcodigo
		left outer join RHInstitucionesA e
			on a.Ecodigo = e.Ecodigo
			and a.RHIAid = e.RHIAid 
		where a.Ecodigo = #vn_Ecodigo#
			<!----and a.DEid in (#session.LvarEmpleados.lista#)----->
</cfquery>

<cfloop query="rsProgramacion">
	<cfset vsMsiglas = rsProgramacion.Msiglas><!--Variable con la sigla de la materia en la empresa DATA---->
	<cfset vsRHACcodigo = rsProgramacion.RHACcodigo>
	<cfset vsRHIAcodigo = rsProgramacion.RHIAcodigo><!---Variable con el codigo de la institucion en DATA--->
	<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
		select Mcodigo from RHMateria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
	</cfquery>
	<cfquery name="rsAreaCap" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
		select RHACid from RHAreasCapacitacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			and RHACcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsRHACcodigo#">
	</cfquery>
	<cfquery name="rsInstituciones" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHIAid) de la institucion en la empresa nueva--->
		select RHIAid from RHInstitucionesA
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHIAcodigo#">
	</cfquery>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHProgramacionCursos(Ecodigo, DEid, RHCid, 
					RHACid, RHIAid, Mcodigo, 
					RHPCfdesde, RHPCfhasta, BMUsucodigo, 
					BMfecha)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsProgramacion.DEid]#">,
				<cfif len(trim(rsProgramacion.RHCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#estructCursos[rsProgramacion.RHCid]#"><cfelse>null</cfif>,
				<cfif len(trim(rsProgramacion.RHACid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAreaCap.RHACid#"><cfelse>null</cfif>,
				<cfif len(trim(rsProgramacion.RHIAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInstituciones.RHIAid#"><cfelse>null</cfif>,
				<!---<cfif len(trim(rsProgramacion.Mcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInstituciones.Mcodigo#"><cfelse>null</cfif>,--->
				null,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsProgramacion.RHPCfdesde#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsProgramacion.RHPCfhasta#">,		
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)				
	</cfquery>
</cfloop>
<!--- 3. Horarios de cursos (RHHorarioCurso)No hay horarios por curso establecidos en DATA--->
<!---4. Cursos por empleado(RHEmpleadoCurso)--->
<cfquery name="ExisteEmpCurso" datasource="#session.DSNnuevo#">
	select 1 from RHEmpleadoCurso
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif ExisteEmpCurso.RecordCount EQ 0>
	<cfquery name="rsCursosEmpleados" datasource="#session.DSNnuevo#">
		select 	b.RHCcodigo, c.Msiglas, a.RHEMnotamin, a.RHEMnota, 
				a.RHECtotempresa, a.RHECtotempleado, a.idmoneda, a.RHECcobrar, 
				a.RHEMestado, a.RHECfdesde, a.RHECfhasta, a.DEid, a.RHCid
		from RHEmpleadoCurso 	a
			inner join RHCursos b
				on a.Ecodigo = b.Ecodigo
				and a.RHCid = b.RHCid
			inner join RHMateria c
				on a.Ecodigo = c.Ecodigo
				and a.Mcodigo = c.Mcodigo
		where a.Ecodigo = #vn_Ecodigo#
			<!---and a.DEid in  (#session.LvarEmpleados.lista#)--->
	</cfquery>

	<cfloop query="rsCursosEmpleados">
		<cfset vsMsiglas = rsCursosEmpleados.Msiglas><!--Variable con la sigla de la materia en la empresa DATA---->
		<cfquery name="rsMateria" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (Mcodigo) de la materia en la empresa nueva---->
			select Mcodigo from RHMateria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and Msiglas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vsMsiglas#">
		</cfquery>
		
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHEmpleadoCurso (DEid, RHCid, Ecodigo, 
										Mcodigo, RHEMnotamin, RHEMnota, 
										RHECtotempresa, RHECtotempleado, idmoneda, 
										RHECcobrar, RHEMestado, BMfecha, 
										BMUsucodigo, RHECfdesde, RHECfhasta)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsCursosEmpleados.DEid]#">,
					<cfif len(trim(rsCursosEmpleados.RHCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#estructCursos[rsCursosEmpleados.RHCid]#"><cfelse>null</cfif>, 	<!---value="#rsCursos.RHCid#">,---->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCursosEmpleados.RHEMnotamin#">,
					<cfif len(trim(rsCursosEmpleados.RHEMnota))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCursosEmpleados.RHEMnota#"><cfelse>null</cfif>,
					<cfif len(trim(rsCursosEmpleados.RHECtotempresa))><cfqueryparam cfsqltype="cf_sql_money"  value="#rsCursosEmpleados.RHECtotempresa#"><cfelse>null</cfif>,
					<cfif len(trim(rsCursosEmpleados.RHECtotempleado))><cfqueryparam cfsqltype="cf_sql_money"  value="#rsCursosEmpleados.RHECtotempleado#"><cfelse>null</cfif>,
					<cfif len(trim(rsCursosEmpleados.idmoneda))><cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsCursosEmpleados.idmoneda#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#rsCursosEmpleados.RHECcobrar#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCursosEmpleados.RHEMestado#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfif len(trim(rsCursosEmpleados.RHECfdesde))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCursosEmpleados.RHECfdesde#"><cfelse>null</cfif>,
					<cfif len(trim(rsCursosEmpleados.RHECfhasta))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCursosEmpleados.RHECfhasta#"><cfelse>null</cfif>
					)														
		</cfquery>
	</cfloop>
</cfif>

<!---5. Competencias por empleado---->
<cfquery name="ExisteEmpComp" datasource="#session.DSNnuevo#">
	select 1 from RHCompetenciasEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif ExisteEmpComp.RecordCount EQ 0>
	<cfquery name="rsCompetencias" datasource="#session.DSNnuevo#">
		select 	b.RHHcodigo , b.RHHid,  null as RHCcodigo, null as RHCid,
				a.idcompetencia, a.tipo, a.RHCEfdesde, a.RHCEfhasta, a.RHCEdominio,
				a.RHCEjustificacion, a.DEid, a.RHCEid
		from RHCompetenciasEmpleado a			
			inner join RHHabilidades b
				on a.Ecodigo = b.Ecodigo
				and a.idcompetencia = b.RHHid
				and b.RHHubicacionB is not null
		where a.Ecodigo =#vn_Ecodigo#
			and a.DEid is not null
			<!---and a.DEid in (#session.LvarEmpleados.lista#)--->

		union

		select 	null as RHHcodigo, null as RHHid, c.RHCcodigo as codigo, c.RHCid as id, 
				a.idcompetencia, a.tipo, a.RHCEfdesde, a.RHCEfhasta, a.RHCEdominio,
				a.RHCEjustificacion, a.DEid, a.RHCEid
		from RHCompetenciasEmpleado a				
			inner join RHConocimientos c
				on a.Ecodigo = c.Ecodigo
				and a.idcompetencia = c.RHCid
		where a.Ecodigo =#vn_Ecodigo#
			and a.DEid is not null
			<!----and a.DEid in (#session.LvarEmpleados.lista#)---->
	</cfquery>
	
	<cfloop query="rsCompetencias">
		<cfif rsCompetencias.tipo EQ 'H'>
			<cfquery name="rsHabilidad" datasource="#session.DSNnuevo#">
				select RHHid from RHHabilidades
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHHcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCompetencias.RHHcodigo#">
			</cfquery>
		<cfelseif rsCompetencias.tipo EQ 'C'>									
			<cfquery name="rsConocimiento" datasource="#session.DSNnuevo#">
				select RHCid from RHConocimientos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCompetencias.RHCcodigo#">
			</cfquery>
		</cfif>
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHCompetenciasEmpleado(DEid, Ecodigo, RHOid, 
						idcompetencia, tipo, RHCEfdesde, 
						RHCEfhasta, RHCEdominio, RHCEjustificacion, 
						BMUsucodigo, BMfecha)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsCompetencias.DEid]#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					null,
					<cfif rsCompetencias.tipo EQ 'H'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabilidad.RHHid#">
					<cfelseif rsCompetencias.tipo EQ 'C'>						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConocimiento.RHCid#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsCompetencias.tipo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCompetencias.RHCEfdesde#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCompetencias.RHCEfhasta#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetencias.RHCEdominio#">,
					<cfif len(trim(rsCompetencias.RHCEjustificacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCompetencias.RHCEjustificacion#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
		</cfquery>
	</cfloop>
</cfif>	

<!--6. Experiencia empleados--->
<cfquery name="ExisteExpericiencia" datasource="#session.DSNnuevo#">
	select 1 from RHExperienciaEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif ExisteExpericiencia.RecordCount EQ 0>	
	<cfquery name="rsExpericia" datasource="#session.DSNnuevo#">
		select 	a.RHEEnombreemp, a.RHEEtelemp, a.RHEEpuestodes, a.RHEEfechaini, a.RHEEfecharetiro, a.Actualmente,
				a.RHEEfunclogros, a.RHEEmotivo, a.DEid
		from RHExperienciaEmpleado a
		where a.Ecodigo = #vn_Ecodigo#
			and a.DEid is not null
			<!---and a.DEid in (#session.LvarEmpleados.lista#)---->
	</cfquery>
	<cfloop query="rsExpericia">
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHExperienciaEmpleado(DEid, Ecodigo, RHOid, 
						RHEEnombreemp, RHEEtelemp, RHEEpuestodes, 
						RHEEfechaini, RHEEfecharetiro, Actualmente, 
						RHEEfunclogros, RHEEmotivo, BMUsucodigo, BMfecha)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsExpericia.DEid]#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsExpericia.RHEEnombreemp#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsExpericia.RHEEtelemp#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsExpericia.RHEEpuestodes#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsExpericia.RHEEfechaini#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsExpericia.RHEEfecharetiro#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#rsExpericia.Actualmente#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#rsExpericia.RHEEfunclogros#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsExpericia.RHEEmotivo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
		</cfquery>
	</cfloop>
</cfif>	

<!------*********************************** ERROR  CAMPO RHEestado de la tabla RHEducacionEmpleado ***********************************
<!---7. Educacion empleados---->
<cfquery name="ExisteEducacion" datasource="#session.DSNnuevo#">
	select 1 from RHEducacionEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif ExisteEducacion.RecordCount EQ 0>
	<cfquery name="rsEducacion" datasource="#session.DSNnuevo#">
		select 	RHEotrains,RHEtitulo,RHEfechaini,RHEfechafin,RHEsinterminar,
				b.RHIAcodigo,c.GAnombre, a.DEid
		from RHEducacionEmpleado a
			left outer join RHInstitucionesA b
				on a.Ecodigo = b.Ecodigo
				and a.RHIAid = b.RHIAid
			left outer join GradoAcademico c
				on a.Ecodigo = c.Ecodigo
				and a.GAcodigo = c.GAcodigo
		where a.Ecodigo = #vn_Ecodigo#
			and a.DEid is not null
			<!---and a.DEid in (#session.LvarEmpleados.lista#)---->
	</cfquery>

	<cfloop query="rsEducacion">
		<cfset vsRHIAcodigo = rsEducacion.RHIAcodigo><!---Variable con el codigo de la institucion en DATA--->
		<cfset vsGrado = rsEducacion.GAnombre><!---Variable con el nombre del grado academico en DATA--->
		<cfquery name="rsInstituciones" datasource="#session.DSNnuevo#"><!---Seleccionar la llave (RHIAid) de la institucion en la empresa nueva--->
			select RHIAid from RHInstitucionesA
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vsRHIAcodigo#">
		</cfquery>
		<cfquery name="rsGrado" datasource="#session.DSNnuevo#"><!---Obtener la llave (GAcodigo) del grado academico en la empresa nueva--->
			select GAcodigo from GradoAcademico
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				and GAnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#vsGrado#">
		</cfquery>
		<cfquery datasource="#session.DSNnuevo#"><!---Insertar en la nueva empresa--->
			insert into RHEducacionEmpleado (DEid, Ecodigo, RHIAid, 
											GAcodigo, RHOid, RHEotrains, 
											RHEtitulo, RHEfechaini, RHEfechafin, 
											RHEsinterminar, BMUsucodigo, BMfecha)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEducacion.DEid]#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<!----<cfif rsInstituciones.RecordCount NEQ 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInstituciones.RHIAid#"><cfelse>null</cfif>,
					<cfif rsGrado.RecordCount NEQ 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrado.GAcodigo#"><cfelse>null</cfif>,---->
					null,
					null,
					
					null,
					<!----<cfif len(trim(rsEducacion.RHEotrains))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEducacion.RHEotrains#"><cfelse>null</cfif>,--->
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEducacion.RHEtitulo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEducacion.RHEfechaini#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEducacion.RHEfechafin#">,
					<!---<cfqueryparam cfsqltype="cf_sql_bit" value="#rsEducacion.RHEsinterminar#">,---->
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
		</cfquery>

	</cfloop>
	
</cfif>
------>
<!---8. Planes de sucesion---->
<cfquery name="ExistePlan" datasource="#session.DSNnuevo#">
	select 1 from RHPlanSucesion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExistePlan.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHPlanSucesion (RHPcodigo, Ecodigo, PSporcreq, BMUsucodigo, fechaalta)
			select 	RHPcodigo,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					PSporcreq,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from RHPlanSucesion 
			where Ecodigo = #vn_Ecodigo#
				<!---and RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
	</cfquery>
</cfif>

<cfquery name="ExistePlanEmp" datasource="#session.DSNnuevo#">
	select 1 from RHEmpleadosPlan
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif ExistePlanEmp.RecordCount EQ 0>
	<cfquery name="rsEmpleadosPlan" datasource="#session.DSNnuevo#">
		select a.RHPcodigo, a.DEid
		from RHEmpleadosPlan a			
		where a.Ecodigo = #vn_Ecodigo#
			<!---and  a.RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')---->
			<!---and  a.DEid in (#session.LvarEmpleados.lista#)---->
	</cfquery>
	<cfloop query="rsEmpleadosPlan">
		<cfquery datasource="#session.DSNnuevo#">
			insert into RHEmpleadosPlan (RHPcodigo, Ecodigo, DEid, BMUsucodigo, fechaalta)			
			values(	<cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpleadosPlan.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpleadosPlan.DEid]#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
		</cfquery>
	</cfloop>
</cfif>	
