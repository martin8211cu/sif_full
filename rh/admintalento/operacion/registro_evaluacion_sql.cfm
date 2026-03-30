<cfset params = 'sel=2'>
<cfif not isdefined("Form.Nuevo")>
	<!---=================== ALTA ===================----->
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="rh.admintalento.Componentes.RH_EstructuraOrg" method="init" returnvariable="estructura" />

		<!--- Determina el centro funcional de la persona --->
		<!--- se hace aqui pues dentro de la transaction da error de dataspurces diferentes --->
		<!--- recupera centro funcional del empleado --->
		<cfset rs_datosempl = estructura.obtenerCFEmpleado(form.DEid) >
		<!--- obtiene datos del centro funcional --->		
		<cfset v_CFid = 0 > 
		<cfif len(trim(rs_datosempl.CFid))>
			<cfset v_CFid = rs_datosempl.CFid >
		</cfif>
		<!--- determina el jefe del empleado--->
		<cfset jefe = estructura.obtenerJefe(v_CFid) >

		<cftransaction>
			<!----Inserta la evaluacion---->
			<cfquery name="insertRHRelacionSeguimiento" datasource="#session.DSN#">
				insert into RHRelacionSeguimiento(Ecodigo, RHRSdescripcion, RHRStipo, 
												RHRSestado, RHRSinicio, RHRSfin, 
												RHRStipofrecuencia, RHRSfrecuencia, RHRScantidad, 
												RHRSdiashabil, RHRS360, BMUsucodigo, 
												BMfechaalta, RHGNid)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHRSdescripcion, 1, 255)#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHRStipo#">,
						10,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHRSinicio)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHRSfin)#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHRStipofrecuencia#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRSfrecuencia#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRScantidad#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRSdiashabil#">,
						<cfif isdefined("form.RHRS360")>
							1,
						<cfelse>
							0,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfif isdefined("form.RHGNid") and len(trim(form.RHGNid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
						<cfelse>
							null
						</cfif>
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="insertRHRelacionSeguimiento" datasource="#Session.DSN#" returnvariable="RHRSid">
			<!----Inserta el empleado a evaluar----->
			<cfquery datasource="#session.DSN#" name="insEvaluado">
				insert into RHEvaluados(Ecodigo, RHRSid, DEid, BMUsucodigo, BMfechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHRSid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="insEvaluado" datasource="#Session.DSN#" >
			
			<!--- Proceso que inserta los evaluadores de la persona seleccionada --->
			
			<!--- si el empleado tiene jefe inserta el registro --->
			<!--- jefe se define antes de la transaccion --->
			<cfif isdefined("jefe") and len(trim(jefe)) and jefe neq 0 and jefe neq form.DEid >
				<cfquery datasource="#session.DSN#">
					insert into RHEvaluadores( Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta )
					values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe#">,
							'J',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
				</cfquery>
			</cfif>

			<!--- inserta autoevaluacion --->
			<cfquery datasource="#session.DSN#">
				insert into RHEvaluadores( Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta )
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						'A',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
			</cfquery>

			<!--- si evaluacion es 360 inserta subordinados y companeros --->
			<cfif isdefined("form.RHRS360")>
				
				<!--- 	inserta compañeros de un empleado
						Los compañeros son los que estan en el mismo centro funcional.
						Se excluye el empleado a evaluar y el jefe, si lo tuviera. 
						Por defecto el jefe	tiene valor de cero
				--->
					
				<cfset tipo = 'C' >
				<cfif jefe eq form.DEid>
					<cfset tipo = 'S' >
				</cfif>
				
				<!--- hay dos casos para este insert (est einsert solo toma en cuenta en centro funcional del empleado y solo por plaza responsable ) --->
				<!--- caso 1: si plaza del empleado no es la responsable del cf, inserta todos los compañeros del empleado (empleados en mismo cf )  --->
				<!--- caso 2: si plaza del empleado es la responsable del cf, inserta todos los subordinados del empleado (todos los empleados del cf ) --->
				<cfquery datasource="#session.DSN#">
					insert into RHEvaluadores( Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta )
					select 	lt.Ecodigo, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#">,
							lt.DEid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					
					from LineaTiempo lt, RHPlazas p, CFuncional cf
					where p.RHPid = lt.RHPid
					 and cf.CFid = p.CFid
					 and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_CFid#">
					 and lt.DEid not in ( #form.DEid#, #jefe#  )		<!--- ni autoevaluacion, ni jefe --->
					 and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
					order by lt.DEid
				</cfquery>
				
				<!--- si el empleado es jefe, se insertan todos los subordinados del empleado en cuestion, incluyendo si hay centros funcionales
					  dependientes del cf del empleado cuyo jefe sigue siendo el mismo empleado en cuestion. Se asuem ke la funcion esta correcta --->
				<!--- si es jefe se insertan todos los subordinados
					  Excluye lo sque ya estan insertados
					  lo hace uno por uno para aprovechar la funcion que devuelve los subordinados de RH_Funciones --->
				<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaSubOrd" returnvariable="subordinados">
					<cfinvokeargument name="DEid" value="#form.DEid#">
					<cfinvokeargument name="fecha" value="#now()#">
				</cfinvoke>
				
				<cfquery name="rs_evaluadores" datasource="#session.DSN#">
					select a.DEid
					from RHEvaluadores a, RHEvaluados b
					where b.RHEid=a.RHEid
					and b.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHRSid#">
				</cfquery>
				<cfset lista_deid = valuelist(rs_evaluadores.DEid) >
				<cfif not len(trim(lista_deid)) >
					<cfset lista_deid = 0 >
				</cfif>
				<cfloop query="subordinados">
					<cfif not listfind(lista_deid, subordinados.DEid) >
						<!--- inserta evaluaciones --->
						<cfquery datasource="#session.DSN#">
							insert into RHEvaluadores( Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta )
							values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#subordinados.DEid#">,
									'S',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
						</cfquery>
					</cfif>
				</cfloop>
				
				<!--- 	caso especial: si el empleado es usuario responsable de un centro funcional deben incluirse los subordinados.
						pues las funciones anteriores solo consideran jefatura por plaza responsable
						Igual se valida que no exista ya el evaluador insertado
				--->
				<!--- insertar los empleados de cada centro, solo a 1 nivel --->
				<cfquery name="rs_uresponsable" datasource="#session.DSN#">
					<!---insert into RHEvaluadores( Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta )--->
					select 	lt.Ecodigo,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#">,
							lt.DEid,
							'S',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">							

					from LineaTiempo lt, RHPlazas p
					
					where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
					  and p.CFid in ( 	select cf.CFid
										from CFuncional cf, UsuarioReferencia b
										where b.Usucodigo=cf.CFuresponsable
										and cf.RHPid is null
										and b.STabla = 'DatosEmpleado'
										and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
										and <cf_dbfunction name="to_number" args="b.llave"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					 				)
					  and lt.DEid not in ( 	select DEid 
					  						from RHEvaluadores 
											where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insEvaluado.identity#"> )
					  and p.RHPid = lt.RHPid
					
				</cfquery>

				<!--- los compañerios de jefes no se com dse sacan--->
			</cfif>

		</cftransaction>
		<cfset params = params & '&modo=CAMBIO&RHRSid=#RHRSid#'>
	<!---=================== BAJA ===================----->
	<cfelseif isdefined("Form.Baja")>	
		<cfinvoke component="rh.admintalento.Componentes.RH_EliminarRelacion" method="init" returnvariable="eliminar"/>		
		<cfset eliminar.funcBorrarTodaRelacion(form.RHRSid)>		
	<!---=================== CAMBIO ===================----->
	<cfelseif isdefined("Form.Cambio")>

		<!--- si se cambiaron fechas, o frecuencia, se eliminan las instancias a programadas a futuro --->
		<cfif trim(form.RHRSinicio) neq trim(form.RHRSinicio_BD) 
		  or (isdefined("form.RHRSfin") and isdefined("form.RHRSfin_BD") and trim(form.RHRSfin) neq trim(form.RHRSfin_BD))
		  or trim(form.RHRSfrecuencia) neq trim(form.RHRSfrecuencia_BD)
		  or trim(form.RHRStipofrecuencia) neq trim(form.RHRStipofrecuencia_BD) >

			<cfinvoke component="rh.admintalento.Componentes.RH_PublicarRelacion" method="init" returnvariable="eliminar" />
			<cfif eliminar.tieneInstancias(form.RHRSid) >
				<cfset eliminar.eliminarInstanciaPorRelacion(form.RHRSid) >
			</cfif>
		</cfif>	

		<cfquery datasource="#session.DSN#">
			update RHRelacionSeguimiento
				set RHRSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.RHRSdescripcion, 1, 255)#">,
					RHRSinicio = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHRSinicio)#">,
					RHRSfin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHRSfin)#">,
					RHRStipofrecuencia = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHRStipofrecuencia#">,
					RHRSfrecuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRSfrecuencia#">,
					RHRScantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRScantidad#">,
					RHRSdiashabil = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHRSdiashabil#">,
					RHRS360 = <cfif isdefined("form.RHRS360")>1,<cfelse>0,</cfif>
					RHGNid = <cfif isdefined("form.RHGNid") and len(trim(form.RHGNid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
							<cfelse>
								null
							</cfif>
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
		</cfquery>
		<!---Modifica el empleado a evaluar---->
		<cfquery datasource="#session.DSN#">
			update RHEvaluados
				set DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
		</cfquery>
		<cfset params = params & '&modo=CAMBIO&RHRSid=#form.RHRSid#'>
	</cfif>
<cfelse>
	<cfset params = params & '&modo=ALTA&Nuevo=#form.Nuevo#'>
</cfif>
<cfoutput>
	<cflocation url="registro_evaluacion.cfm?#params#">
</cfoutput>
