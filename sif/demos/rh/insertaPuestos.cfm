<cfquery name="rsPuestos" datasource="#session.DSNnuevo#"><!---Obtener lod puestos seleccionados de la empresa DATA---->	
	select * 
	from RHPuestos a		
	where a.Ecodigo = #vn_Ecodigo#
	<!---and a.RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
</cfquery>

<cfloop query="rsPuestos"><!---Cada puesto de DATA se inserta en la empresa nueva, así como los datos de las demas tablas relacionadas----->
	<cfset vspuesto = rsPuestos.RHPcodigo >		<!----Variable String (vs) con el codigo del puesto (RHPcodigo)---->
	<cfset vsRHTPid = rsPuestos.RHTPid>			<!----Variable String (vs) con el tipo de puesto (RHTPid)---->
	<cfset vsRHPEid = rsPuestos.RHPEid>			<!----Variable String (vs) con el puesto externo (RHPEid)---->
	
	<cfquery name="rsVerificaExiste" datasource="#session.DSNnuevo#"><!----Si ya existe el Puesto se asume que todas las tablas relacionadas ya estan llenas---->
		select 1 from RHPuestos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
	</cfquery>

	<cfif rsVerificaExiste.RecordCount EQ 0><!--No existe ya el puesto---->
		<!----1. Inserta en RHPuestos---->
		<cfquery name="RHPuestos" datasource="#session.DSNnuevo#">
			insert into RHPuestos (Ecodigo, RHPcodigo, RHOcodigo, 
									RHTPid, RHPEid, RHGMid, 
									RHPdescpuesto, BMusuario, BMfecha, 
									BMusumod, BMfechamod, HYLAcodigo, 
									HYMgrado, HYIcodigo, HYHEcodigo, 
									HYHGcodigo, HYIHgrado, HYCPgrado, 
									HYMRcodigo, ptsHabilidad, porcSP, 
									ptsSP, ptsResp, ptsTotal, 
									HYperfilnivel, HYperfilvalor, CFid, 
									BMUsucodigo, DEidaprueba, RHPfechaaprob, 
									RHPactivo, RHPfactiva, FLval, 
									FRval, BLval, BRval, 
									FLtol, FRtol, BLtol,
									BRtol,extravertido,introvertido,
									balanceado,ubicacionMuneco)

			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, 
					RHPcodigo, 
					null, 
					null, 
					null, 
					null, 
					RHPdescpuesto, 
					BMusuario, 
					BMfecha, 
					BMusumod, 
					BMfechamod, 
					HYLAcodigo, 
					HYMgrado, 
					HYIcodigo, 
					HYHEcodigo, 
					HYHGcodigo, 
					HYIHgrado, 
					HYCPgrado, 
					HYMRcodigo, 
					ptsHabilidad, 
					porcSP, 
					ptsSP, 
					ptsResp, 
					ptsTotal, 
					HYperfilnivel, 
					HYperfilvalor, 
					null, 
					BMUsucodigo, 
					DEidaprueba, 
					RHPfechaaprob, 
					RHPactivo, 
					RHPfactiva, 
					FLval, 
					FRval, 
					BLval, 
					BRval, 
					FLtol, 
					FRtol, 
					BLtol,	
					BRtol,
					extravertido,
					introvertido,
					balanceado,
					ubicacionMuneco
			from RHPuestos
			where Ecodigo = #vn_Ecodigo#
			  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
		</cfquery>	
		<!---2. Inserta en RHTPuestos (Tipo de puesto)---->
		<cfif len(trim(vsRHTPid))><!---Si el puesto en DATA tiene un tipo de puesto---->				
			<cfquery name="rsExisteTipo" datasource="#session.DSNnuevo#"><!---Verificar si ya existe el tipo de puesto en la empresa nueva---->
				select 1 from RHTPuestos 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHTPcodigo  = (select RHTPcodigo from RHTPuestos 
										where Ecodigo = #vn_Ecodigo#
											and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vsRHTPid#">	
										)
			</cfquery>
			<cfif rsExisteTipo.RecordCount EQ 0>	
				<cfquery name="selectInsertaTipo" datasource="#session.DSNnuevo#">
					select  	RHTPcodigo, 
								RHTPdescripcion, 
								RHTinfo							
						from RHTPuestos
						where Ecodigo = #vn_Ecodigo#
							and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vsRHTPid#">
				</cfquery>
				<cfquery name="InsertaTipo" datasource="#session.DSNnuevo#">
					insert into RHTPuestos (Ecodigo, RHTPcodigo, RHTPdescripcion, 
											BMusuario, BMfecha, RHTinfo, 
											BMusumod, BMfechamod, BMUsucodigo)
								VALUES(
									   #session.EcodigoNuevo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectInsertaTipo.RHTPcodigo#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#selectInsertaTipo.RHTPdescripcion#" voidNull>,
									   #session.UsucodigoNuevo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_clob"              value="#selectInsertaTipo.RHTinfo#"         voidNull>,
									   #session.UsucodigoNuevo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
									   #session.UsucodigoNuevo#
								)
					<cf_dbidentity1 datasource="#session.DSNnuevo#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSNnuevo#" name="InsertaTipo">
				
				<!----3. Update del tipo en RHPuestos de la empresa nueva---->
				<cfquery datasource="#session.DSNnuevo#"	>
					update RHPuestos 
					set RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaTipo.identity#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
				</cfquery>
			</cfif>
		</cfif>	
		<!----3. Inserta en RHPuestosExternos--->
		<cfif len(trim(vsRHPEid))><!---Si el puesto en la empresa DATA tiene un puesto externo ---->
			<cfquery name="rsExistePext" datasource="#session.DSNnuevo#"><!----Verificar si ya existe el puesto externo---->
				select 1 from RHPuestosExternos
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHPEcodigo  = (select RHPEcodigo from RHPuestosExternos 
										where Ecodigo = #vn_Ecodigo#
											and RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vsRHPEid#">	
										)
			</cfquery>
			<cfif rsExistePext.RecordCount EQ 0>	
				<cfquery name="SelectInsertaPexternos" datasource="#session.DSNnuevo#">
					select 		RHPEcodigo,
								RHPEdescripcion,
						from RHPuestosExternos
						where Ecodigo = #vn_Ecodigo#
							and RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vsRHPEid#">
				</cfquery>			
				<cfquery name="InsertaPexternos" datasource="#session.DSNnuevo#">
					insert into RHPuestosExternos (Ecodigo, RHPEcodigo, RHPEdescripcion, BMUsucodigo)
						VALUES(
						   #session.EcodigoNuevo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#SelectInsertaPexternos.RHPEcodigo#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectInsertaPexternos.RHPEdescripcion#" voidNull>,
						   #session.UsucodigoNuevo#
					)
											
					<cf_dbidentity1 datasource="#session.DSNnuevo#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSNnuevo#" name="InsertaPexternos">
				<!----Update del puesto externo en RHPuestos---->
				<cfquery datasource="#session.DSNnuevo#"	>
					update RHPuestos 
					set RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaPexternos.identity#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
				</cfquery>
			</cfif>
		</cfif>
		<!---4. Inserta en  RHDescriptivoPuesto---->
		<cfquery name="InsertaDescriptivo" datasource="#session.DSNnuevo#">
			insert into RHDescriptivoPuesto (RHPcodigo, Ecodigo, BMusuario, 
											BMfecha, BMusumod, BMfechamod, 
											RHDPmision, RHDPobjetivos, RHDPespecificaciones, 
											BMUsucodigo)
				select 	<cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						RHDPmision,
						RHDPobjetivos,
						RHDPespecificaciones,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
				from RHDescriptivoPuesto
				where Ecodigo = #vn_Ecodigo#
					and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
		</cfquery>		
		<!----5. Inserta en RHValoresPuesto---->		
		<cfquery name="rsRHValoresPuesto" datasource="#session.DSNnuevo#"><!----Trae todos los valores de la tabla RHValoresPuesto en DATA---> 
			select b.RHECGcodigo,b.RHECGid, c.RHDCGcodigo, c.RHDCGid
			from RHValoresPuesto a
				inner join RHECatalogosGenerales b
					on a.RHECGid = b.RHECGid
					and a.Ecodigo = b.Ecodigo
				inner join RHDCatalogosGenerales c
					on a.RHDCGid = c.RHDCGid
					and a.Ecodigo = c.Ecodigo
			where a.Ecodigo = #vn_Ecodigo# 
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
		</cfquery>			
		<cfloop query="rsRHValoresPuesto">		
			<!---Para c/u de los valores se obtiene el Id de RHECatalogosGenerales y RHDCatalogosGenerales en la nueva empresa--->
			<cfquery name="rsValores" datasource="#session.DSNnuevo#">
				select a.RHECGid, b.RHDCGid
				from RHECatalogosGenerales a
					inner join RHDCatalogosGenerales b
						on a.RHECGid = b.RHECGid
						and a.Ecodigo = b.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and a.RHECGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHValoresPuesto.RHECGcodigo#"> 
					and b.RHDCGcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHValoresPuesto.RHDCGcodigo#"> 
			</cfquery>
			
			<cfif rsValores.RecordCount NEQ 0><!---Se inserta en la tabla intermedia los valores con los ID's de la nueva empresa---->
				<cfquery datasource="#session.DSNnuevo#">
					insert into RHValoresPuesto(RHPcodigo, Ecodigo, RHDCGid, RHECGid, BMUsucodigo)
					values(<cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValores.RHDCGid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValores.RHECGid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
						)
				</cfquery>
			</cfif>
		</cfloop>
		<!----6. Inserta RHHabilidadesPuesto (Habilidades del puesto)----->
		<cfquery name="rsHabilidades" datasource="#session.DSNnuevo#">
			select b.RHHcodigo, a.RHNnotamin, a.RHHtipo, a.RHHpeso, a.ubicacionB, a.PCid, c.RHNcodigo
			from RHHabilidadesPuesto a
				inner join RHHabilidades b
					on a.RHHid = b.RHHid
					and a.Ecodigo = b.Ecodigo
				left outer join RHNiveles c
					on a.RHNid = c.RHNid
					and a.Ecodigo = c.Ecodigo
			where a.Ecodigo = #vn_Ecodigo#
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">
		</cfquery>		
		<cfloop query="rsHabilidades"><!---- Insertar cada habilidad ----->
			<cfquery name="Habilidad" datasource="#session.DSNnuevo#"><!---Traer el RHHid (Id) de la habilidad en la empresa nueva---->
				select RHHid from RHHabilidades
				where RHHcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsHabilidades.RHHcodigo#">	
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">		
			</cfquery>
			<cfquery name="rsNivel" datasource="#session.DSNnuevo#"><!---Traer el RHNid (Id) del nivel en la empresa nueva---->
				select RHNid from RHNiveles
				where RHNcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsHabilidades.RHNcodigo#">	
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">		
			</cfquery>			
			<cfif Habilidad.RecordCount NEQ 0>
				<cfquery datasource="#session.DSNnuevo#">
					insert into RHHabilidadesPuesto (RHHid, RHPcodigo, Ecodigo, 
													RHNid, RHNnotamin, RHHtipo, 
													RHHpeso, ubicacionB, BMUsucodigo, 
													PCid)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Habilidad.RHHid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
							<cfif isdefined("rsNivel") and len(trim(rsNivel.RHNid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNivel.RHNid#"><cfelse>null</cfif>,
							<cfif isdefined("rsHabilidades") and len(trim(rsHabilidades.RHNnotamin))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabilidades.RHNnotamin#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsHabilidades.RHHtipo#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#rsHabilidades.RHHpeso#">,
							<cfif isdefined("rsHabilidades") and len(trim(rsHabilidades.ubicacionB))><cfqueryparam cfsqltype="cf_sql_char" value="#rsHabilidades.ubicacionB#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
							<cfif isdefined("rsHabilidades") and len(trim(rsHabilidades.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabilidades.PCid#"><cfelse>null</cfif>
						)				
				</cfquery>
			</cfif>	
		</cfloop>		
		<!----7.  Inserta en RHConocimientosPuesto---->
		<cfquery name="rsConocimientos" datasource="#session.DSNnuevo#"><!---Obtiene los conocimientos en la empresa DATA--->
			select b.RHCcodigo,a.RHCnotamin, a.RHCtipo, a.RHCpeso, c.RHNcodigo
			from RHConocimientosPuesto a
					inner join RHConocimientos b
						on a.RHCid = b.RHCid
						and a.Ecodigo = b.Ecodigo
					left outer join RHNiveles c
						on a.RHNid = c.RHNid
						and a.Ecodigo = c.Ecodigo
			where a.Ecodigo = #vn_Ecodigo#
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#"> 
		</cfquery>
		<cfloop query="rsConocimientos"><!---- Insertar cada conocimiento ----->
			<cfquery name="Conocimiento" datasource="#session.DSNnuevo#"><!---Traer el RHCid (Id) del conocimiento en la empresa nueva---->
				select RHCid from RHConocimientos
				where RHCcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsConocimientos.RHCcodigo#">	
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">		
			</cfquery>
			<cfquery name="rsNivel" datasource="#session.DSNnuevo#"><!---Traer el RHNid (Id) del nivel en la empresa nueva---->
				select RHNid from RHNiveles
				where RHNcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsConocimientos.RHNcodigo#">	
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">		
			</cfquery>
			<cfif Conocimiento.RecordCount NEQ 0><!---Si el conocimiento existe en la nueva empresa---->
				<cfquery datasource="#session.DSNnuevo#"><!---Lo inserta en la relación con el puesto----->
					insert into RHConocimientosPuesto (RHPcodigo, Ecodigo, RHCid, 
														RHNid, RHCnotamin, RHCtipo, 
														RHCpeso, BMUsucodigo)
					values(	<cfqueryparam cfsqltype="cf_sql_char" value="#vspuesto#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Conocimiento.RHCid#">,
							<cfif isdefined("rsNivel") and len(trim(rsNivel.RHNid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNivel.RHNid#"><cfelse>null</cfif>,
							<cfif isdefined("rsConocimientos") and len(trim(rsConocimientos.RHCnotamin))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConocimientos.RHCnotamin#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConocimientos.RHCtipo#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#rsConocimientos.RHCpeso#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
						)			
				</cfquery>			
			</cfif>	
		</cfloop>
	</cfif>	
</cfloop>
