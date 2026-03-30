<cfset params = '?REid=#form.REid#&SEL=6&Estado=#form.Estado#'>
<cfif isdefined('form.BOTON')>
	<cfif form.BOTON EQ 'Generar'>
		<cfquery  name="valores" datasource="#Session.DSN#">
			Select 	ere.DEid,REaplicajefe
			from RHEmpleadoRegistroE  ere 
			inner join RHRegistroEvaluacion rel
			 	on rel.REid= ere.REid 
			where ere.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ere.REid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		</cfquery>
		<cfset jefe="">
		<cfloop query="valores">
			<cfif isdefined('valores.REaplicajefe') and valores.REaplicajefe eq 1>
				<cfset jefe = jefe_usuario(valores.DEid)>
			</cfif>
			<cfquery  name="updatevalores" datasource="#Session.DSN#">
				update RHEmpleadoRegistroE set 
				<cfif isdefined('jefe') and len(trim(jefe))>
					DEidjefe =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe#">
				<cfelse>
					DEidjefe =  null
				</cfif>
				where REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and   DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.DEid#">
			</cfquery>
		</cfloop>
	<cfelseif form.BOTON EQ 'Modificar'>
		<cftransaction>
			<!--- ACTUALIZA EL REGISTRO DEL EMPLEADO --->
			<cfquery  name="updatevalores" datasource="#Session.DSN#">
				update RHEmpleadoRegistroE set 
				<cfif isdefined('form.EREnojefe')>
					EREnojefe =  1,
				<cfelse>
					EREnojefe =  0,
				</cfif>
				<cfif isdefined('form.EREnoempleado')>
					EREnoempleado =  1,
				<cfelse>
					EREnoempleado =  0,
				</cfif>
				DEidjefe = 	<cfif isdefined("Form.deidjefe") and len(trim(Form.deidjefe))> 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.deidjefe#">
							<cfelse>
								null
							</cfif>
				where REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
			<cfif form.Estado EQ 1><!--- SI LA RELACION ESTA PUBLICADA --->
				<!--- BUSCA SI EL EMPLEADO TIENE REGISTRADO UN EVALUADOR --->
				<cfquery name="rsREEid" datasource="#session.DSN#">
					select REEid,REEevaluadorj
					from RHRegistroEvaluadoresE
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
					  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">			
				</cfquery>
				<!--- CONSULTA DEL JEFE ACTUAL DEL EMPLEADO --->
				<cfquery name="TieneJefeA" datasource="#session.DSN#">
					select DEidjefe
					from RHEmpleadoRegistroE
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
					  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfquery>
				<cfif isdefined('TieneJefeA') and TieneJefeA.RecordCount GT 0>
					<cfset TieneJefeAsignado = TieneJefeA.DEidjefe>
				</cfif>
				<cfif not LEN(TRIM(form.DEidjefe))> <!--- SI SE ELIMINA EL JEFE DEL EMPLEADO --->
					<cfif rsREEid.RecordCount NEQ 0>
						<!--- ELIMINA EL REGISTRO DEL EVALUADOR PARA ESTE EMPLEADO YA QUE SE QUITO EL EVALUADOR --->
						<cfquery name="UpdateEval" datasource="#session.DSN#">
							update RHRegistroEvaluadoresE
							set REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
							  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">			
						</cfquery>
					</cfif>
				<cfelse>
					<cfif rsREEid.RecordCount NEQ 0>
						<cfif form.DEidjefe NEQ rsREEid.REEevaluadorj> <!--- SI CAMBIA DE JEFE --->
							<!--- SE MODIFICA EL REGISTRO DEL EVALUADOR DEL EMPLEADO Y SE LIMPIAN LAS NOTAS --->
							<cfquery name="updateDatosEvaluador" datasource="#session.DSN#">
								update RHRegistroEvaluadoresE
								set REENotaj = 0,
									REEfinalj = 0,
									REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.deidjefe#">
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
								  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
								  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">			
							</cfquery>
							<!--- LIMPIA LAS RESPUESTAS A LOS CONCEPTOS EN CASO QUE SEA UN NUEVO EVALUADOR --->
							<cfquery name="updateConceptosAEvaluar" datasource="#session.DSN#">
									update RHConceptosDelEvaluador
								set CDENotaj = 0,
									CDERespuestaj = null
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
								  and REEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsREEid.REEid#">
								  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">			
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cftransaction>
		<cfset params = '?REid=#form.REid#&SEL=6&DEidlista=#form.DEid#&Estado=#form.Estado#'>
	<cfelseif form.BOTON EQ 'Borrar'>
		<cfquery  name="updatevalores" datasource="#Session.DSN#">
			update RHEmpleadoRegistroE set 
			<cfif isdefined('form.POSICION') and len(trim(form.POSICION)) and form.POSICION eq 1>
				EREnojefe =  1
			<cfelse>
				EREnoempleado =  1
			</cfif>
			where REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			and   DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
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
	<cflog file="workflow" text="jefe_usuario(): no se encontro el usuario">
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

<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.pagina2 = url.Pagina2>
</cfif>	
<cfif isdefined("url.DEidFILTRO") and len(trim(url.DEidFILTRO))>
	<cfset form.DEidFILTRO = url.DEidFILTRO>
</cfif>	
<cfif isdefined("url.DEIDFILTRO2") and len(trim(url.DEIDFILTRO2))>
	<cfset form.DEIDFILTRO2 = url.DEIDFILTRO2>
</cfif>	
<cfif isdefined("url.Indicadores") and len(trim(url.Indicadores))>
	<cfset form.Indicadores = url.Indicadores>
</cfif>	

<cfparam name="form.pagina2" default="1">
<cfparam name="form.DEidFILTRO" default="">
<cfparam name="form.DEIDFILTRO2" default="">
<cfparam name="form.Indicadores" default="">
<cfset params=params&"&pagina2="&form.pagina2>
<cfset params=params&"&DEidFILTRO="&form.DEidFILTRO>
<cfset params=params&"&DEIDFILTRO2="&form.DEIDFILTRO2>
<cfset params=params&"&Indicadores="&form.Indicadores>
<cflocation url="registro_evaluacion.cfm#params#">
