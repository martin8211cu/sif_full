<cfset cont = 0>
<cfset params = '?REid=#form.REid#&SEL=5&Estado=#form.Estado#'>
<cfif isdefined('form.BOTON')>
	<cfif form.BOTON EQ 'Generar'>
		<cfquery name="rsAplicaJefe" datasource="#session.DSN#">
			select REaplicajefe as AplicaJefe 
			from RHRegistroEvaluacion a
			where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- ELIMINA TODOS LOS QUE NO HAN SIDO CALIFICADOS --->
		<cfquery datasource="#Session.DSN#">
			delete from RHEmpleadoRegistroE		
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and REid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			  and not exists (select   DEid
						 from RHRegistroEvaluadoresE a
						 where a.DEid = RHEmpleadoRegistroE.DEid
						   and RHEmpleadoRegistroE.REid = a.REid
						   and a.REEfinalj = 1
						)
			  and not exists (select   DEid
						 from RHRegistroEvaluadoresE a
						 where a.DEid = RHEmpleadoRegistroE.DEid
						   and RHEmpleadoRegistroE.REid = a.REid
						   and a.REEfinale = 1
						)
		</cfquery>

		<cfquery name="valores" datasource="#Session.DSN#">
			Select gr.REid
				, de.DEid
				, gr.Ecodigo
				,rel.REaplicajefe
			from RHGruposRegistroE gr
				inner join RHCFGruposRegistroE gcf
					on gcf.Ecodigo = gr.Ecodigo
					and gcf.GREid = gr.GREid
					
				inner join RHRegistroEvaluacion rel
					on rel.REid = gr.REid
					
				inner join RHPlazas rhp
					on rhp.Ecodigo = gcf.Ecodigo
					and rhp.CFid = gcf.CFid	
			
				inner join CFuncional cf
					on cf.Ecodigo=rhp.Ecodigo
					and cf.CFid=rhp.CFid
			
				inner join LineaTiempo lt
					on lt.Ecodigo = rhp.Ecodigo
					and lt.RHPid = rhp.RHPid
					and getDate() between lt.LTdesde and lt.LThasta
			
				inner join RHPuestos rhpu
					on rhpu.Ecodigo = lt.Ecodigo
					and rhpu.RHPcodigo = lt.RHPcodigo
			
				inner join DatosEmpleado de
					on de.Ecodigo = rhpu.Ecodigo
						and de.DEid = lt.DEid
						and de.DEid not in (
									Select ee.DEid
									from RHEmpleadoRegistroE ee
									where ee.REid = gr.REid
										and ee.Ecodigo = gr.Ecodigo
											)
			where gr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and gr.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		</cfquery>
		<cfset jefe="">
		<cfloop query="valores">
			<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe"
					DEid = #valores.DEid#
					fecha = '#Now()#'
					returnvariable="esjefe">
			 <cfquery  name="insertvalores" datasource="#Session.DSN#">
				insert into RHEmpleadoRegistroE 
					(REid, DEid, Ecodigo, EREnoempleado,EREnojefe,EREjefeEvaluador, BMfalta, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#valores.Ecodigo#">,
					0,
					0,
					<cfif esjefe.jefe>1<cfelse>0</cfif>,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)	
			</cfquery> 
			<cfset jefe="">
			<!--- EN CASO DE QUE LA RELACION ESTE PUBLICADA ENTONCES DEBE CREAR LOS EVALUADORES Y CONCEPTOS 
				  PARA LOS EMPLEADOS QUE SE AGREGAN, EN CASO DE Q NO HAYAN SIDO CALIFICADOS
			--->
			<cfif form.Estado EQ 1>
				<!--- BUSCA LOS EVALUADORES PARA LUEGO ELIMINAR LOS CONCEPTOS A EVALUAR --->
				<cfquery name="rsREEid" datasource="#session.DSN#">
					select REEid 
					from RHRegistroEvaluadoresE
					where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and not exists (select   DEid
								 from RHRegistroEvaluadoresE a
								 where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
								   and RHRegistroEvaluadoresE.REid = a.REid
								   and a.REEfinalj = 1
								)
					  and not exists (select   DEid
								 from RHRegistroEvaluadoresE a
								 where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
								   and RHRegistroEvaluadoresE.REid = a.REid
								   and a.REEfinale = 1
								)
				</cfquery>
				<cfif rsREEid.RecordCount>
					<!--- ELIMINA LOS CONCEPTOS --->
					<cfquery datasource="#session.DSN#">
						delete from RHConceptosDelEvaluador
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and REEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREEid.REEid#">
						  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					</cfquery>
				</cfif>			
				<!--- ELIMINA LOS EVALUADORES DE LA RELACION --->	
				<cfquery datasource="#Session.DSN#">
					delete from RHRegistroEvaluadoresE		
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and REid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
					  and not exists (select   DEid
								 from RHRegistroEvaluadoresE a
								 where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
								   and RHRegistroEvaluadoresE.REid = a.REid
								   and a.REEfinalj = 1
								)
					  and not exists (select   DEid
								 from RHRegistroEvaluadoresE a
								 where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
								   and RHRegistroEvaluadoresE.REid = a.REid
								   and a.REEfinale = 1
								)
				</cfquery>
				<!---  --->
				<cfset Empleado = valores.DEid>
				<cfinclude template="listaEmpl_evaluacionAgregaP.cfm">
			</cfif>
		</cfloop>
		<!--- ACTUALIZA LOS JEFES A EVALUAR --->
		<cfloop Query="valores">
			<cfset jefe = ''>
			<cfif isdefined('rsAplicaJefe.Aplicajefe') and rsAplicaJefe.Aplicajefe eq 1>
				<cfset jefeEvaluador = jefe_usuario(valores.DEid)>
				<cfif LEN(TRIM(jefeEvaluador))>
				<cfquery name="VerifJefe" datasource="#session.DSN#">
					select 1
					from RHEmpleadoRegistroE
					where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#jefeEvaluador#">
					  and EREjefeEvaluador = 1
				</cfquery>
				</cfif>
				<cfif isdefined('VerifJefe') and VerifJefe.RecordCount GT 0>
					<cfset jefe = jefeEvaluador>
				</cfif>
			</cfif>
			<cfquery name="rsUpdateJefe" datasource="#session.DSN#">
				update RHEmpleadoRegistroE
				set DEidjefe = <cfif isdefined('rsAplicaJefe.Aplicajefe') and rsAplicaJefe.Aplicajefe eq 1>
							  		<cfif isdefined('jefe') and len(trim(jefe))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe#">
									<cfelse>
										null
									</cfif>
								<cfelse>
									null
								</cfif>	
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfloop>
	<cfelseif form.BOTON EQ 'Borrar'>
		<cfif isdefined('form.DEid') and len(trim(form.DEid))>
			<!--- CUANDO ELIMINA UN EMPLEADO DE LA RELACION DEBE ELIMINAR LOS REGISTROS DE  --->
			<!--- RHConceptosDelEvaluador,RHRegistroEvaluadoresE,RHEmpleadoRegistroE  --->
			<!--- Y DEBE LIMPIAR EL CAMPO DEidjefe DE LOS EMPLEADOS QUE TENGAN ASIGNADO COMO JEFE 
				  QUE EVALUA EN CASO QUE SEA UN JEFE EVALUADOR  --->
			<cfquery name="rsREEid" datasource="#session.DSN#">
				select REEid 
				from RHRegistroEvaluadoresE
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="rsDEidjefe" datasource="#session.DSN#">
				select EREjefeEvaluador
				from RHEmpleadoRegistroE
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsREEid.RecordCount>
				<cfquery datasource="#session.DSN#">
					delete from RHConceptosDelEvaluador
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and REEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREEid.REEid#">
					  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				</cfquery>
			</cfif>
			<cfquery datasource="#session.DSN#"	>
				delete from RHRegistroEvaluadoresE 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			</cfquery>			
			<cfquery datasource="#Session.DSN#">
				delete from RHEmpleadoRegistroE		
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			</cfquery>
			<cfif rsDEidjefe.RecordCount GT 0 and rsDEidjefe.EREjefeEvaluador EQ 1>
				<cfquery name="UpdateDEidJefe" datasource="#session.DSN#">
					update RHEmpleadoRegistroE
					set DEidjefe = null
					where DEidjefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>
			
		</cfif>
	<cfelseif form.BOTON EQ 'Agregar'>

		<!--- VERIFICA QUE EL EMPLEADO NO EXISTA EN LA LISTA, SI NO EXISTE LO INSERTA --->
		<cfquery name="rsVerificaEmp" datasource="#session.DSN#">
			select 1
			from RHEmpleadoRegistroE
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
		</cfquery>
		<cfif isdefined('rsVerificaEmp') and not rsVerificaEmp.RecordCount>
			<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe"
					DEid = #form.LDEid#
					fecha = '#Now()#'
					returnvariable="esjefe">
			<cfquery  name="insertvalores" datasource="#Session.DSN#">
				insert into RHEmpleadoRegistroE 
					(REid, DEid, Ecodigo, EREnoempleado,EREnojefe,EREjefeEvaluador, BMfalta, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					0,
					0,
					<cfif isdefined('form.EREjefeEvaluador') and form.EREjefeEvaluador EQ 'on'>
						1
					<cfelse>
						<cfif esjefe.jefe>1<cfelse>0</cfif>
					</cfif>
					,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)	
			</cfquery>
			<!--- MISMO PROCESO DE PUBLICAR LA RELACION PERO PARA SOLO UN EMPLEADO --->
			<cfif form.Estado EQ 1>
				<cfset Empleado = form.LDEid>
				<cfinclude template="listaEmpl_evaluacionAgregaP.cfm">
			</cfif>
		</cfif>
	<cfelseif form.BOTON EQ 'Modificar'>
		<!--- EL PROCESO DE MODIFICAR DEBE DE SEGUIR LOS SIGUIENTES PASOS
			SI ASIGNA AL EMPLEADO COMO JEFE
				MODIFICAR LA TABLA RHEmpleadoRegistroE DEL INDICADOR DE EREjefeEvaluador = 1
			SI LO DESASIGNA COMO JEFE
				MODIFICAR LA TABLA RHEmpleadoRegistroE 
					INDICADOR EREjefeEvaluador = 1
					DEidjefe = NULL EN EL CASO QUE ALGUNO DE LOS EMPLEADOS TENGA COMO JEFE EVALUADOR ESE EMPLEADO
					EN EL CASO QUE LA RELACION ESTE PUBLICADA SE DEBEN ELIMINAR LOS REGISTROS DE LA TABLA
					DE RHConceptosDelEvaluador PARA EL JEFE QUE SE ESTÁ DESASIGNANDO.
		 --->
		 <!--- SI SE ESTA DESASIGNANDO COMO JEFE EVALUADOR --->
		<cfif isdefined('form.EREjefeEvaluador') and form.EREjefeEvaluador EQ ''>
			<!--- LIMPIA LAS RESPUESTAS A LOS CONCEPTOS EN CASO QUE SEA UN NUEVO EVALUADOR --->
			<cfquery name="updateConceptosAEvaluar" datasource="#session.DSN#">
				update RHConceptosDelEvaluador
				set CDENotaj = 0,
					CDERespuestaj = null
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				  and REEid in (select REEid
								from RHRegistroEvaluadoresE ree
								inner join RHEmpleadoRegistroE ere
									on ere.REid = ree.REid
									and ere.DEid = ree.DEid
									and DEidjefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
								where ree.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
								  and ree.REid = RHConceptosDelEvaluador.REid)
				  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">			
			</cfquery>
			<cfquery name="UpdateDEidJefe" datasource="#session.DSN#">
				update RHEmpleadoRegistroE
				set DEidjefe = null
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and DEidjefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
			</cfquery>
			<cfif form.Estado EQ 1>
				<cfquery datasource="#session.DSN#">
					delete from RHConceptosDelEvaluador  where 
					CDEid  in (
					select  CDEid  
							from RHRegistroEvaluadoresE a 
							inner join RHConceptosDelEvaluador b
								on   a.REid = b.REid
								and  a.REEid = b.REEid
							inner join RHIndicadoresRegistroE c
								on   b.IREid  = c.IREid 
								and  (c.IREevaluasubjefe = 1
									or c.IREevaluasubjefe = 1)
							inner join RHIndicadoresAEvaluar d
								on c.IAEid  = d.IAEid 
								and  d.IAEtipoconc = 'T'
							where  a.REid = RHConceptosDelEvaluador.REid
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">)
					and RHConceptosDelEvaluador.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				</cfquery>
			</cfif>
		<cfelse>
			<!--- TRAER EL INDICADOR DE JEFE EVALUADOR PARA VERIFICAR QUE NO SE INSERTEN DOS VECES 
				LOS ITEMES A EVALUAR PARA UN JEFE --->
			<cfquery name="rsVerifiJefe" datasource="#session.DSN#">
				select EREjefeEvaluador
				from RHEmpleadoRegistroE
				where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			 	 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 	 and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
			</cfquery>
			<cfif rsVerifiJefe.EREjefeEvaluador EQ 0>
				<cfif form.Estado EQ 1>
					<!--- SI LA RELACION ESTA PUBLICADA Y SE ASGINA UN EMPLEADO COMO JEFE EVALUADOR, 
							ENTONCES TIENE INSERTARSE LOS CAMPOS DENTRO DE RHConceptosDelEvaluador 
							PARA QUE SE CALIFIQUE COMO JEFE--->
					<cfquery name="rsREEid" datasource="#session.DSN#">
						select REEid
						from RHRegistroEvaluadoresE
						where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
					</cfquery>
					<cfquery name="rsconceptos" datasource="#session.dsn#">
						select IREid
						from RHIndicadoresRegistroE 
						where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and IREevaluasubjefe = 1 
					</cfquery>
					<cfloop query="rsconceptos">
						<cfquery name="Insert_conceptos" datasource="#session.dsn#">
							insert into RHConceptosDelEvaluador (
								Ecodigo
								,IREid 
								,REEid
								,REid
								,CDENotae
								,CDENotaj
								,CDERespuestae
								,CDERespuestaj
								,BMfechaalta
								,BMUsucodigo
							 )
							 values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsconceptos.IREid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREEid.REEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
								0,
								0,
								null,
								null,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							 )
						</cfquery>
					</cfloop>	
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="UpdateJefe" datasource="#session.DSN#">
			update RHEmpleadoRegistroE
			set EREjefeEvaluador = <cfif isdefined('form.EREjefeEvaluador') and form.EREjefeEvaluador EQ 'on'>1<cfelse>0</cfif>
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LDEid#">
		</cfquery>
	</cfif>
</cfif>

<!--- INICIO FUNCIONES PARA BUSCAR EL JEFE DE UN EMPLEADO --->
<cffunction name="jefe_usuario" access="package" output="false" returntype="any">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfquery datasource="#session.dsn#" name="cf">
		select cf.CFid as CFpk, cf.CFidresp as CFpkresp, lt.RHPid as plaza_usuario, cf.RHPid as plaza_jefe_cf
		from LineaTiempo lt
			join RHPlazas pl
				on pl.RHPid = lt.RHPid
				and pl.Ecodigo = lt.Ecodigo
			join CFuncional cf
				on cf.CFid = pl.CFid
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DEid#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
	</cfquery>
	<cfif cf.RecordCount>
	    <cfif (cf.plaza_usuario Is cf.plaza_jefe_cf) And Len(cf.CFpkresp)>
			<cfset real_users = jefe_cf(cf.CFpkresp)>
		<cfelse>
			<cfset real_users = jefe_cf(cf.CFpk)>
		</cfif>
		<cfreturn real_users>
	</cfif>
	
	<cfset real_users = "">

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoSeEncontroElUsuario"
		Default="no se encontró el usuario"
		returnvariable="MSG_NoSeEncontroElUsuario"/>	
	<cflog file="workflow" text="jefe_usuario(): #MSG_NoSeEncontroElUsuario#">
	<cfreturn real_users>
</cffunction>

<cffunction name="jefe_cf" access="package" output="false" returntype="any">
	<cfargument name="centro_funcional" type="numeric" required="yes">
	
	<cfset centro_funcional_actual = Arguments.centro_funcional>
	<cfloop condition="Len(centro_funcional_actual)">
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select cf.Ecodigo, CFuresponsable, lt.DEid as DEid_jefe, CFidresp
			from CFuncional cf
			left join RHPlazas pl
				on cf.RHPid = pl.RHPid
			left join LineaTiempo lt
				on lt.RHPid = pl.RHPid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between LTdesde and LThasta
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#centro_funcional_actual#">
			and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif buscar_cf.RecordCount>
			<cfif buscar_cf.RecordCount and len(trim(buscar_cf.DEid_jefe))>
				<cfreturn buscar_cf.DEid_jefe>
			</cfif>
			<cfif Len(buscar_cf.CFuresponsable)>
				<cfquery datasource="#session.dsn#" name="real_users">
					select ur.llave as jefe
					from Usuario u
					join UsuarioReferencia ur
						on ur.Usucodigo = u.Usucodigo
						and ur.STabla = 'DatosEmpleado'
					join DatosPersonales dp
						on dp.datos_personales = u.datos_personales
					where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_cf.CFuresponsable#">
					and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				</cfquery>
				<cfif real_users.RecordCount and len(trim(real_users.jefe))>
					<cfreturn real_users.jefe> 
				</cfif>
			</cfif>
		</cfif>
		<cfset centro_funcional_actual = buscar_cf.CFidresp>
	</cfloop>
	<cfset real_users = "">
	<cfreturn real_users>
</cffunction>
<!--- FIN FUNCIONES PARA BUSCAR EL JEFE DE UN EMPLEADO --->

<cflocation url="registro_evaluacion.cfm#params#">
