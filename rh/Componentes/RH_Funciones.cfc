<!--- Componente: RH_Funciones  --->
<!--- Creado por: Ana Villavicencio --->
<!--- Fecha de Creación: 25/09/2006 --->
<cfcomponent>
<cffunction name="init" access="public">
		<cfreturn this>
	</cffunction>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_ElUsuarioNoEsResponsableDeUnCentroFuncionalPorLoTantoNoTieneSubordinados"
	default="El usuario no es responsable de un Centro Funcional. Por lo tanto no tiene Colaboradores asignados."
	returnvariable="MSG_ElUsuarioNoEsResponsableDeUnCentroFuncionalPorLoTantoNoTieneSubordinados"/>	
	<!--- FUNCION QUE DETERMINA LAS DEPENDECIAS DE UN CENTRO FUNCIONAL --->
	<cffunction name="CFDependencias" returntype="query" access="public" output="true">
		<cfargument name="CFid" type="numeric" 	required="yes">
		<cfargument name="Nivel" type="numeric" required="no" default="3">
		<cfquery name="rsPath" datasource="#session.DSN#">
			select CFpath, CFnivel
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		<cfset vPath = rsPath.CFpath>
		<cfset vNivel = rsPath.CFnivel + Nivel>
		<cfquery name="rsDepend" datasource="#session.DSN#">
			select CFid
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and upper(CFpath) like '#ucase(vPath)#/%'
			  and CFnivel <= <cfqueryparam cfsqltype="cf_sql_integer" value="#vNivel#">
			union 
			select CFid
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>

		<cfreturn rsDepend> 
	</cffunction>
	

	<!--- FUNCION QUE DETERMINA SI UN EMPLEADO ES JEFE --->
	<cffunction name="DeterminaJefe" returntype="struct">
		<cfargument name="DEid" type="numeric" 	required="yes"> <!--- EMPLEADO A DETERMINAR SI ES JEFE --->
		<cfargument name="fecha" type="date" 	required="yes">	<!--- FECHA CORTE PARA DETERMINAR SI ES JEFE --->
		
		<cfset var LvarJefe = structNew()>
		<cfquery name="rsCFPlaza" datasource="#session.DSN#">
			select a.RHPid, CFid,ur.Usucodigo  
			from LineaTiempo a
			inner join RHPlazas b
			   on b.RHPid = a.RHPid
			inner join UsuarioReferencia ur
				on <cf_dbfunction name="to_number" args="llave"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and ur.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
		</cfquery>
		<!--- <cfdump var="#rsCFPlaza#" label="CENTRO FUNCIONAL Y PLAZA, ACTUALES DEL USUARIO"> --->
		<cfif isdefined("rsCFPlaza") and rsCFPlaza.RecordCount>
			<!--- VERIFICAR SI LA PLAZA DEL USUARIO ESTA MARCADA COMO RESPONSABLE DE ALGUN CENTRO FUNCIONAL --->
			<cfquery name="rsResponsablePlaza" datasource="#session.DSN#">
				select CFid, RHPid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFPlaza.RHPid#">
			</cfquery>
			<!--- <cfdump var="#rsResponsablePlaza#" label="PLAZA RESPONSABLE DEL CENTRO FUNCIONAL"> --->
			<!--- VERIFICAR SI EL USUARIO ES RESPONSABLE DE ALGUN CENTRO FUNCIONAL --->
			<cfquery name="rsResponsableCF" datasource="#session.DSN#">
				select min(CFid) as CFid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and CFuresponsable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFPlaza.Usucodigo#">
			</cfquery>
			<!---VERIFICAR SI EL USUARIO ES AUTORIZADO EN ALGUN CENTRO FUNCIONAL--->
			<cfquery name="rsAuto" datasource="#session.dsn#">
				select min(CFid) as CFid
				from CFautoriza
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFPlaza.Usucodigo#">
			</cfquery>
			<cfif rsResponsablePlaza.REcordCount>
				<cfset CentroF = rsResponsablePlaza.CFid>
				<cfset Plaza = rsResponsablePlaza.RHPid>
			<cfelseif rsResponsableCF.CFid GT 0>
				<cfset CentroF = rsResponsableCF.CFid>
				<cfset Plaza = 0>
			<cfelseif rsAuto.CFid GT 0>
				<cfset CentroF = rsAuto.CFid>
				<cfset Plaza = 0>
			</cfif>
			<!--- <cfdump var="#rsResponsableCF#" Label="RESPONSABLE DEL CENTRO FUNCIONAL"> --->
			<cfif isdefined('CentroF') and isdefined('Plaza')>
				<cfset LvarJefe.CFid  = CentroF>
				<cfset LvarJefe.RHPid = Plaza>
				<cfset LvarJefe.Jefe  = arguments.DEid>
			<cfelse>
				<cfset LvarJefe.Jefe = 0>	
			</cfif>
		<cfelse>
			<cfset LvarJefe.Jefe = 0>	
		</cfif>
		<!--- <cf_dump var="#LvarJefe#">	 --->	
		<cfreturn LvarJefe> 
	</cffunction>

	<!--- FUNCION QUE DETERMINA LOS SUBORDINADOS DE UN JEFE --->
	<cffunction name="DeterminaSubOrd" returntype="query">
		<cfargument name="DEid" type="numeric"  required="yes">
		<cfargument name="fecha" type="date" 	required="yes">
		<cfargument name="Nivel" type="numeric" required="no" default="3">
		
		<cfset rsJefe = DeterminaJefe(arguments.DEid,arguments.fecha)>
		<cfif rsJefe.Jefe>
			<cfset Centros = CFDependencias(rsJefe.CFid,arguments.Nivel)>
			<cfset CentrosLista = ValueList(Centros.CFid)>
			<cfquery name="rsSubordinados" datasource="#session.DSN#">
				select DEid
				from LineaTiempo a
				inner join RHPlazas b
				   on b.RHPid = a.RHPid
				  and b.CFid in (#CentrosLista#)
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
				  and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJefe.Jefe#">
				order by a.DEid
			</cfquery>
			<cfreturn rsSubordinados>
		<cfelse>
			<cfthrow message="#MSG_ElUsuarioNoEsResponsableDeUnCentroFuncionalPorLoTantoNoTieneSubordinados#">
			<cfreturn rsSubordinados.MSG>
		</cfif>
	</cffunction>
	
	<!--- FUNCION QUE DETERMINA responsable de un centro funcional --->
	<cffunction name="DeterminaResponsableCF" returntype="numeric">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="fecha" type="date" 	required="no" default="#now()#">
		<cfset UsuarioResponsable = -1>
		<cfquery name="rsUsuarioAut" datasource="#session.dsn#">
			select Usucodigo
			from CFautoriza
			where CFid=#arguments.CFid#
			and Ecodigo=#session.Ecodigo#
			and Usucodigo=#session.Usucodigo#
		</cfquery>
		<cfif isdefined('rsUsuarioAut') and rsUsuarioAut.recordCount gt 0 and len(trim(rsUsuarioAut.Usucodigo)) gt 0>
			<cfreturn rsUsuarioAut.Usucodigo>
		</cfif>
		<cfquery name="rsCF" datasource="#session.DSN#">
			select RHPid,CFuresponsable 
			from CFuncional 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		<cfif rsCF.recordCount GT 0>
			<cfif isdefined("rsCF.CFuresponsable") and len(trim(rsCF.CFuresponsable)) and isdefined("rsCF.RHPid") and len(trim(rsCF.RHPid)) eq 0 >
				<cfreturn rsCF.CFuresponsable>	
			<cfelseif isdefined("rsCF.RHPid") and len(trim(rsCF.RHPid))>
				<cfquery name="rsPlaza" datasource="#session.DSN#">
					select DEid from LineaTiempo a
					inner join RHPlazas  b
						on a.RHPid = b.RHPid
						and a.Ecodigo = b.Ecodigo
					where <cfqueryparam value="#arguments.fecha#" cfsqltype="cf_sql_timestamp">  between LTdesde and LThasta
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.RHPid#">			
				</cfquery>
				<cfif rsPlaza.recordCount GT 0>
					<cfquery name="RSusuario" datasource="#session.DSN#">
						select Usucodigo
						from UsuarioReferencia
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
						and STabla = 'DatosEmpleado'
						and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPlaza.DEid#">
					</cfquery>
					<cfif RSusuario.recordCount GT 0>
						<cfreturn RSusuario.Usucodigo>
					<cfelse>
						<cfreturn UsuarioResponsable>
					</cfif>
				<cfelse>
					<cfreturn UsuarioResponsable>
				</cfif>
			<cfelse>
				<cfreturn UsuarioResponsable>
			</cfif>	
		<cfelse>
			<cfreturn UsuarioResponsable>
		</cfif>		
	</cffunction>
	<cffunction name="DeterminaDEidResponsableCF" returntype="any">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="fecha" type="date" 	required="no" default="#now()#">
		<cfset UsuarioResponsable = -1>
		<cfquery name="rsCF" datasource="#session.DSN#">
			select 
			RHPid,CFuresponsable from CFuncional 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		<cfif rsCF.recordCount GT 0>
			<cfif isdefined("rsCF.CFuresponsable") and len(trim(rsCF.CFuresponsable)) and isdefined("rsCF.RHPid") and len(trim(rsCF.RHPid)) eq 0 >
				<cfquery name="RSusuario" datasource="#session.DSN#">
					select llave
					from UsuarioReferencia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
					and STabla = 'DatosEmpleado'
					and Usucodigo = #rsCF.CFuresponsable#
				</cfquery>
				<cfreturn RSusuario.llave>	
			<cfelseif isdefined("rsCF.RHPid") and len(trim(rsCF.RHPid))>
				<cfquery name="rsPlaza" datasource="#session.DSN#">
					select DEid from LineaTiempo a
					inner join RHPlazas  b
						on a.RHPid = b.RHPid
						and a.Ecodigo = b.Ecodigo
					where <cfqueryparam value="#arguments.fecha#" cfsqltype="cf_sql_timestamp">  between LTdesde and LThasta
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.RHPid#">			
				</cfquery>
				<cfif rsPlaza.recordCount GT 0>
					<cfreturn rsPlaza.DEid>
				<cfelse>
					<cfreturn UsuarioResponsable>
				</cfif>
			<cfelse>
				<cfreturn UsuarioResponsable>
			</cfif>	
		<cfelse>
			<cfreturn UsuarioResponsable>
		</cfif>		
	</cffunction>
		
	<cffunction name="DeterminaPermisoOpcion" returntype="query">
		<cfargument name="Usuario" type="numeric" required="yes">
		<cfargument name="Sistema" type="string" required="no">
		<cfargument name="Modulo" type="string" required="no">
		<cfargument name="Proceso" type="string" required="no">
		<cfquery name="rs" datasource="asp">
			select distinct s.SSorden, p.SPorden, s.SSdescripcion as nombre_sistema, p.SPdescripcion as nombre_servicio, 
							rtrim(s.SScodigo) as sistema, rtrim (p.SPcodigo) as servicio,
							m.SMcodigo as modulocod, m.SMdescripcion as Modulodes
			from SSistemas s, SProcesos p, vUsuarioProcesos sr, SModulos m
			where sr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usuario#">
			  <cfif isdefined('arguments.Sistema')>
			  and s.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Sistema)#">
			  </cfif>
			  <cfif isdefined('arguments.Proceso')>
			  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Proceso)#">
			  </cfif>
			  <cfif isdefined('arguments.Modulo')>
			  and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Modulo)#">
			  </cfif>
			  and sr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			  and m.SScodigo = sr.SScodigo 
			  and m.SMcodigo = sr.SMcodigo 
			  and sr.SScodigo = p.SScodigo 
			  and sr.SMcodigo = p.SMcodigo 
			  and sr.SPcodigo = p.SPcodigo 
			  and sr.SScodigo = s.SScodigo  
		
		union
		
		select distinct s.SSorden, p.SPorden, s.SSdescripcion as nombre_sistema, p.SPdescripcion as nombre_servicio, 
							rtrim(s.SScodigo) as sistema, rtrim (p.SPcodigo) as servicio,
							m.SMcodigo as modulocod, m.SMdescripcion as Modulodes
			from UsuarioRol ur, SProcesosRol pr, SSistemas s, SProcesos p, SModulos m
			where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usuario#">
			  <cfif isdefined('arguments.Sistema')>
			  and s.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Sistema)#">
			  </cfif>
			  <cfif isdefined('arguments.Proceso')>
			  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Proceso)#">
			  </cfif>
			  <cfif isdefined('arguments.Modulo')>
			  and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.Modulo)#">
			  </cfif>
			  and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			  and pr.SScodigo = ur.SScodigo
			  and pr.SRcodigo = ur.SRcodigo
			
			  and s.SScodigo  = pr.SScodigo
			
			  and p.SScodigo  = pr.SScodigo
			  and p.SMcodigo  = pr.SMcodigo
			  and p.SPcodigo  = pr.SPcodigo
			
			  and m.SScodigo = p.SScodigo 
			  and m.SMcodigo = p.SMcodigo 
		</cfquery>
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="salarioTipoNomina" returntype="any">
		<cfargument name="salario" 		type="any"  required="yes">
		<cfargument name="Tcodigo"   type="string" 	required="yes">
		<cfargument name="Ecodigo" type="numeric" default="#Session.Ecodigo#" required="no">
			<cfset var_salarioTipoNomina= salario>
			<cfquery name="RSTipoNomina" datasource="#session.DSN#">
				select Ttipopago,FactorDiasSalario
				from TiposNomina 
				where 
				Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">     
				and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
			</cfquery>
			<cfif RSTipoNomina.recordCount GT 0>
				<cfswitch expression="#RSTipoNomina.Ttipopago#">
					<cfcase value="0">
						<cfset var_salarioTipoNomina= (arguments.salario*12) / 52><!--- Este lleva un calculo especial --->
					</cfcase>
					<cfcase value="1">
						<cfset var_salarioTipoNomina=  (arguments.salario*12) / 26><!--- Este lleva un calculo especial --->
					</cfcase>
					<cfcase value="2">
						<cfset var_salarioTipoNomina= arguments.salario / 2>
					</cfcase>
					<cfcase value="3">
						<cfset var_salarioTipoNomina= arguments.salario >
					</cfcase>
				</cfswitch>
			</cfif>
			<cfreturn var_salarioTipoNomina>
	</cffunction>
	
	<!--- Ejemplo de como se invoca 
	
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="salarioTipoNomina"
		salario = "100000.00"
		Tcodigo = "02"
		returnvariable="var_salarioTipoNomina">

<cfdump var="#var_salarioTipoNomina#">

	
	 --->	
</cfcomponent>