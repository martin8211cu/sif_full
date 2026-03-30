<!---
	Descripcion: Componente para Aplicar la Importación de Reglas para Cuentas Contables
	Hecho por: Yu Hui
	Este componente requiere que NO se invoque dentro de un <CFTRANSACTION>
--->

<cfcomponent>
	<!---
		Función para validacion de reglas.
	--->
	<cffunction name="CG_AplicaImportacionReglas" access="public" returntype="boolean">
		<cfargument name="PCREIid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" default="#Session.Ecodigo#" required="no">
		<cfargument name="Conexion" type="string" default="#Session.DSN#" required="no">
		
		<cfset isOk = true>
		<cfset isOk = validacionRegistros(Arguments.PCREIid, Arguments.Ecodigo, Arguments.Conexion)>
		<cfif isOk>
			<cfset isOk = importarRegistros(Arguments.PCREIid, Arguments.Conexion)>
		</cfif>
		
		<cfreturn isOk>
	</cffunction>
	
	<!--- *************************************************************************************************************** --->
	<cffunction name="validacionRegistros" access="public" returntype="boolean">
		<cfargument name="PCREIid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" default="#Session.Ecodigo#" required="no">
		<cfargument name="Conexion" type="string" default="#Session.DSN#" required="no">
		
		<!--- Establecer estado del Lote como Aplicando para que no pueda ser modificado --->
		<cfquery datasource="#Arguments.Conexion#">
			update PCReglasEImportacion set
				PCREestado = 5
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
		</cfquery>
		
		<!--- Resetear errores --->
		<cfquery datasource="#Arguments.Conexion#">
			update PCReglasDImportacion set 
				PCRerror1 = '0', 
				PCRerror2 = '0', 
				PCRerror3 = '0', 
				PCRerror4 = '0', 
				PCRerror5 = '0', 
				PCRerror6 = '0', 
				PCRerror7 = '0', 
				PCRerror8 = '0', 
				PCRerror9 = '0', 
				PCRerror10 = '0'
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
		</cfquery>
        
        <cftry>
			<cftransaction>
				<!--- Chequear existencia de Oficinas --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror1 = '1'
					where PCREIid = #Arguments.PCREIid#
					  and Oformato is not null
					  and not exists(
						select 1
						from Oficinas o
						where o.Ecodigo = PCReglasDImportacion.Ecodigo
						  and <cf_dbfunction name="like"	args="o.Oficodigo , PCReglasDImportacion.Oformato">)
				</cfquery>
		
				<!--- Chequear existencias de cuentas de mayor --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror2 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and not exists(
						select 1
						from CtasMayor cm
						where cm.Ecodigo = PCReglasDImportacion.Ecodigo
						  and cm.Cmayor  = PCReglasDImportacion.Cmayor
						)
				</cfquery>
		
				<!--- Actualiza formato máscara y Codigo mascara para las que tienen nulo o fueron digitadas desde la pantalla --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion
					set Cmascara = (select CPVformatoF
									from CPVigencia m
									where m.Ecodigo = PCReglasDImportacion.Ecodigo
									  and m.Cmayor = PCReglasDImportacion.Cmayor
									  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between m.CPVdesde and m.CPVhasta
									),
						PCEMid = (	select PCEMid
									from CPVigencia m
									where m.Ecodigo = PCReglasDImportacion.Ecodigo
									  and m.Cmayor = PCReglasDImportacion.Cmayor
									  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between m.CPVdesde and m.CPVhasta
									)
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and (PCEMid is null
						or Cmascara is null)
				</cfquery>
		
				<!--- Chequear que el campo Cmascara no esté en blanco --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror3 = (case when Cmascara is null then '1' else '0' end)
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
				</cfquery>
		
				<!--- Chequear existencia de mascaras para la cuenta mayor --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror3 = (case when
										(select count(1) 
										 from CPVigencia x
										 where x.Ecodigo = PCReglasDImportacion.Ecodigo
										 and x.Cmayor = PCReglasDImportacion.Cmayor
										 and x.PCEMid = PCReglasDImportacion.PCEMid
										 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between x.CPVdesde and x.CPVhasta
										 ) = 0 then '1' 
										 else '0' 
									end)
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRerror3 = '0'
				</cfquery>
			
				<!--- Chequear si el tamaño de la regla es igual al tamaño de la máscara de la cuenta mayor --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror3 = (case when <cf_dbfunction name="length"	args="rtrim(Cmascara)"> <> <cf_dbfunction name="length"	args="rtrim(PCRregla)"> then '1' else '0' end)
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRerror3 = '0'
				</cfquery>
				
				<!--- Chequear que la fecha desde no esté vacía --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror4 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and PCRdesde is null
				</cfquery>
		
				<!--- Chequear que la fecha hasta no esté vacía --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror4 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRerror4 = '0'
					and PCRhasta is null
				</cfquery>
		
				<!--- Chequear si fecha de inicio es menor que fecha fin --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror4 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRerror4 = '0'
					and PCRdesde > PCRhasta
				</cfquery>
					
				<!--- 
					Chequear validez de referencias, 
					adicionalmente debe cumplirse que cualquier regla de nivel 2 
					tenga una oficina consistente de acuerdo a la especificada en la regla de nivel 1 
				--->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror5 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and PCRref is not null
					  and not exists(
						select 1
						from PCReglasDImportacion x
						where x.PCREIid = PCReglasDImportacion.PCREIid
						  and x.PCRid   = PCReglasDImportacion.PCRref
						  and <cf_dbfunction name="like" args="PCReglasDImportacion.PCRregla , x.PCRregla"> 
						  and <cf_dbfunction name="like" args="PCReglasDImportacion.Oformato , x.Oformato">
						 )
				</cfquery>
		
				<!--- 
					Chequear validez de referencias, debe cumplirse que cualquier regla de nivel 2 
					debe tener la misma oficina que la regla de nivel 1 y la regla debe estar contenida en la regla de inclusion o exclusion
				--->
				<cfquery datasource="#Arguments.Conexion#">
                        update PCReglasDImportacion set
                            PCRerror5 = '1'
                        where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
                          and PCRerror5 = '0'
                          and PCRrefsys is not null
                          and not exists(
                            select 1
                            from PCReglas x
                            where x.PCRid = PCReglasDImportacion.PCRrefsys
                              and <cf_dbfunction name="like" args="PCReglasDImportacion.PCRregla , x.PCRregla">
                              and <cf_dbfunction name="like" args="PCReglasDImportacion.Oformato , x.OficodigoM">
                             )
				</cfquery>
					
				<!--- Chequear reglas duplicadas dentro del mismo archivo --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror6 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and PCRref is null
					  and exists (
						select 1
						from PCReglasDImportacion x 
						where x.PCREIid    = PCReglasDImportacion.PCREIid
						  and x.Cmayor     = PCReglasDImportacion.Cmayor
						  and x.Oformato   = PCReglasDImportacion.Oformato
						  and x.PCRregla   = PCReglasDImportacion.PCRregla
						  and x.PCRvalida  = PCReglasDImportacion.PCRvalida
						  and x.PCRref     is null
						  and x.PCRid      <> PCReglasDImportacion.PCRid
						  )
				</cfquery>
		
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror6 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and PCRref is not null
					  and PCRerror6 = '0'
					  and exists (
						select 1
						from PCReglas x 
						where x.Ecodigo   = PCReglasDImportacion.Ecodigo
						  and x.Cmayor    = PCReglasDImportacion.Cmayor
						  and x.OficodigoM  = PCReglasDImportacion.Oformato
						  and x.PCRregla  = PCReglasDImportacion.PCRregla
						  and x.PCRvalida = (case when PCReglasDImportacion.PCRvalida = 'S' then 1 else 0 end)
						  and x.PCRref    is null
						  )
				</cfquery>
											
				<!--- Chequear reglas duplicadas dentro del sistema  para el mismo grupo de Excepciones --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror6 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRerror6 = '0'
					and PCRref is not null
					and exists(
						select 1
						from PCReglasDImportacion x
						where x.PCREIid    = PCReglasDImportacion.PCREIid
						  and x.PCRref   is not null
						  and x.PCRref     = PCReglasDImportacion.PCRref 
						  and x.Cmayor     =  PCReglasDImportacion.Cmayor
						  and <cf_dbfunction name="like" args="x.Oformato , PCReglasDImportacion.Oformato">
						  and x.PCRregla   =  PCReglasDImportacion.PCRregla
						  and x.PCRid      <> PCReglasDImportacion.PCRid
						 )
				</cfquery>
				
				<!--- Verificar que solo existan 2 niveles en las reglas que apuntan a reglas dentro del mismo archivo --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion
					set PCRerror7 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRref is not null
					and exists(
						select 1
						from PCReglasDImportacion x
						where x.PCREIid = PCReglasDImportacion.PCREIid
						  and x.PCRid = PCReglasDImportacion.PCRref
						  and (x.PCRref is not null or x.PCRrefsys is not null)
						  )
				</cfquery>
						
				<!--- Verificar que solo existan 2 niveles en las reglas que apuntan a reglas del sistema --->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion
					set PCRerror7 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and PCRerror7 = '0'
					  and PCRrefsys is not null
					  and exists(
						select 1
						from PCReglas x
						where x.PCRid =  PCReglasDImportacion.PCRrefsys
						  and x.PCRref is not null
						)
				</cfquery>
                
                  <!--- 
				  		»»Chequear existencias del grupo de reglas«« 
					--->
				<cfquery datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRerror8 = '1'
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and not exists(
						select 1
						from PCReglaGrupo gr
						where gr.Ecodigo = PCReglasDImportacion.Ecodigo
						  and gr.PCRGcodigo  = PCReglasDImportacion.PCRGcodigo
                          and Cmayor = PCReglasDImportacion.Cmayor
						)
				</cfquery>
			</cftransaction>
			
		<cfcatch type="any">
			<cf_errorCode	code = "51031" msg = "Error en proceso de Validación.">
			<cfquery datasource="#Arguments.Conexion#">
				update PCReglasEImportacion set
					PCREestado = 0
				where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
			</cfquery>
			<cftransaction action="rollback"/>
		</cfcatch>
	</cftry>
		
	<!--- Averiguar si existen errores o inconsistencias dentro de las reglas --->
	<cfquery name="reglasInvalidas" datasource="#Arguments.Conexion#">
		select count(1) as cant
		from PCReglasDImportacion
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
		and (
			PCRerror1 = '1' or
			PCRerror2 = '1' or
			PCRerror3 = '1' or
			PCRerror4 = '1' or
			PCRerror5 = '1' or
			PCRerror6 = '1' or
			PCRerror7 = '1' or
			PCRerror8 = '1' or
			PCRerror9 = '1' or
			PCRerror10 = '1'
		)
	</cfquery>

	<!--- Liberar el acceso al Lote --->
	<cfquery name="updLote" datasource="#Arguments.Conexion#">
		update PCReglasEImportacion set
			PCREestado = 0
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
	</cfquery>

	<cfreturn (reglasInvalidas.cant EQ 0)>
</cffunction>

<!--------------------------------------------------------------------------
	Funcion de importacion de registros, esta funcion pasa lo importado y 
	validado a la tabla PCReglas. 
  ----------------------------------------------------------------------- --->
<cffunction name="importarRegistros" access="private" returntype="boolean">
		<cfargument name="PCREIid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" default="#Session.DSN#" required="no">
        
        <cfset LvarPCRGid = "">
		
		<!--- Establecer estado del Lote como Aplicando para que no pueda ser modificado --->
		<cfquery name="updLote" datasource="#Arguments.Conexion#">
			update PCReglasEImportacion set
				PCREestado = 5
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
		</cfquery>
        <cfquery name="rsIdGrupoReglas" datasource="#session.dsn#">
        		SELECT PCRGid
                FROM PCReglaGrupo
                WHERE PCRGcodigo = 
                										(SELECT DISTINCT PCRGcodigo
                                                          FROM PCReglasDImportacion rdi
                                                          WHERE rdi.PCREIid = #Arguments.PCREIid#)
        </cfquery>
		
		<cftry>
			<cftransaction>
				<!--- Insertar todas las reglas que no hacen referencia a reglas del lote de importacion:  PCRref is null --->
				<cfquery name="insReglasRefSistema" datasource="#Arguments.Conexion#">
					insert into PCReglas (
														Ecodigo, 			
                                                        Cmayor, 
                                                        PCEMid, 				
                                                        OficodigoM, 
														PCRref, 				
                                                        PCRdescripcion, 
                                                        PCRregla, 			
                                                        PCRvalida, 
                                                        PCRdesde, 		
                                                        PCRhasta, 
                                                        Usucodigo, 		
                                                        Ulocalizacion, 
                                                        BMUsucodigo, 	
                                                        BMfechaalta, 
                                                        PCRGid)
					select 
                    			a.Ecodigo, 							
                                a.Cmayor, 
                                a.PCEMid,				 			
                                a.Oformato, 
						   		a.PCRrefsys, 						
                                a.PCRdescripcion, 
						   		a.PCRregla, 						
                                case when a.PCRvalida = 'S' then 1 else 0 end, 
						   		a.PCRdesde,				 		
                                a.PCRhasta,
						   		#Session.Usucodigo#,		
                                '00', 
						   		#Session.Usucodigo#,		
                                <cf_dbfunction name="now">,
                           		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdGrupoReglas.PCRGid#">
					from PCReglasDImportacion a
					where a.PCREIid = #Arguments.PCREIid#
					and a.PCRaplicada = 0
					and a.PCRref is null
				</cfquery>
				
				<!--- Marcar la regla como aplicada --->
				<cfquery name="updRegla" datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRaplicada = 10
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRaplicada = 0
					and PCRref is null
				</cfquery>				
			</cftransaction>

			<cfcatch type="any">
				<cf_errorCode	code = "51032" msg = "Error en proceso de Importación.">
				<cftransaction action="rollback"/>
			</cfcatch>
		</cftry>
					
		
			<cftransaction>
				<cfquery name="updLlaves" datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRrefsys = (
							select min(PCRid)
							from PCReglas x
							where x.Ecodigo     = PCReglasDImportacion.Ecodigo
							  and x.Cmayor      = PCReglasDImportacion.Cmayor
							  and x.PCEMid      = PCReglasDImportacion.PCEMid
							  and x.OficodigoM  = PCReglasDImportacion.Oformato
							  and x.PCRregla    = PCReglasDImportacion.PCRregla
							  and x.PCRdesde    = PCReglasDImportacion.PCRdesde
							  and x.PCRhasta    = PCReglasDImportacion.PCRhasta
                              and x.PCRhasta    = PCReglasDImportacion.PCRhasta
                              and x.PCRGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdGrupoReglas.PCRGid#">
						)
					where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and PCRaplicada = 10
					and PCRref is null
				</cfquery>
	
				<!--- Insertar las reglas de nivel 2 que apuntan a reglas en el archivo --->
				<cfquery name="insReglasNivel2" datasource="#Arguments.Conexion#">
					insert into PCReglas (
						Ecodigo, Cmayor, PCEMid, OficodigoM, 
						PCRref, PCRdescripcion, PCRregla, 
						PCRvalida, PCRdesde, PCRhasta, 
						Usucodigo, Ulocalizacion, BMUsucodigo, BMfechaalta, PCRGid)
					select a.Ecodigo, 
						   a.Cmayor, 
						   a.PCEMid, 
						   a.Oformato, 
						   b.PCRrefsys, 
						   a.PCRdescripcion, 
						   a.PCRregla, 
						   case when a.PCRvalida = 'S' then 1 else 0 end, 
						   a.PCRdesde, 
						   a.PCRhasta,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						   '00', 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				  		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdGrupoReglas.PCRGid#">
					from PCReglasDImportacion a
						inner join PCReglasDImportacion b
							on b.PCREIid = a.PCREIid
							and b.PCRid = a.PCRref
							and b.PCRrefsys is not null
					where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					and a.PCRaplicada = 0
					and a.PCRref is not null
				</cfquery>
				
                
				<!---►►Marcar la reglas de nivel 2 como aplicadas◄◄--->
				<cfquery name="preupdRegla" datasource="#Arguments.Conexion#">
					select a.PCREIid, a.PCRid 
					 from PCReglasDImportacion a
					  inner join PCReglasDImportacion b
						 on b.PCREIid = a.PCREIid
						and b.PCRid   = a.PCRref
						and b.PCRrefsys is not null
					where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and a.PCRaplicada = 0
					  and a.PCRref is not null					
				</cfquery>
                <cfloop query="preupdRegla">
                	<cfquery name="updRegla" datasource="#Arguments.Conexion#">
                        update PCReglasDImportacion set
                            PCRaplicada = 10
                       where PCREIid = #preupdRegla.PCREIid#
                         and PCRid   = #preupdRegla.PCRid#	
                    </cfquery>
                </cfloop>
	
				<!--- Insertar las reglas de nivel 2 que apuntan a reglas en el archivo --->
				<cfquery name="insReglasNivel2" datasource="#Arguments.Conexion#">
					insert into PCReglas (
						Ecodigo, Cmayor, PCEMid, OficodigoM, 
						PCRref, PCRdescripcion, PCRregla, 
						PCRvalida, PCRdesde, PCRhasta, 
						Usucodigo, Ulocalizacion, BMUsucodigo, BMfechaalta, PCRGid)
					select a.Ecodigo, 
						   a.Cmayor, 
						   a.PCEMid, 
						   a.Oformato, 
						   a.PCRrefsys, 
						   a.PCRdescripcion, 
						   a.PCRregla, 
						   case when a.PCRvalida = 'S' then 1 else 0 end, 
						   a.PCRdesde, 
						   a.PCRhasta,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						   '00', 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdGrupoReglas.PCRGid#">
					from PCReglasDImportacion a
					where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and a.PCRaplicada = 0
					  and a.PCRref is null
					  and a.PCRrefsys is not null
				</cfquery>
				
				<!--- Marcar la reglas de nivel 2 como aplicadas --->
				<cfquery name="updRegla" datasource="#Arguments.Conexion#">
					update PCReglasDImportacion set
						PCRaplicada = 10
					from PCReglasDImportacion a
					where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					  and a.PCRaplicada = 0
					  and a.PCRref is null
					  and a.PCRrefsys is not null
				</cfquery>
			</cftransaction>
		
		
		<!--- 
		Liberar el acceso al Lote 
		--->

		<cfquery name="updLote" datasource="#Arguments.Conexion#">
			update PCReglasEImportacion set
				PCREestado = 0
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
		</cfquery>

		<!--- Eliminar reglas del Importador --->
		<cfquery name="chkNotApplied" datasource="#Arguments.Conexion#">
			select count(1) as cant
			from PCReglasDImportacion
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
			and PCRaplicada = 0
		</cfquery>

		<cfif chkNotApplied.cant EQ 0>
			<cftry>
				<cftransaction>
					<cfquery name="delReglas" datasource="#Arguments.Conexion#">
						delete from PCReglasDImportacion
						where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					</cfquery>
					
					<cfquery name="delReglas" datasource="#Arguments.Conexion#">
						delete from PCReglasEImportacion
						where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCREIid#">
					</cfquery>				
				</cftransaction>
				
				<cfcatch type="any">
					<cf_errorCode	code = "51032" msg = "Error en proceso de Importación.">
					<cftransaction action="rollback"/>
				</cfcatch>							
			</cftry>
		</cfif>

		<cfreturn (chkNotApplied.cant EQ 0)>
	</cffunction>
</cfcomponent>


