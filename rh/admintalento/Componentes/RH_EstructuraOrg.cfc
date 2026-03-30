<!--- Componente que determina algunas caracteristicas de la estructura organizacional de la empresa --->
<cfcomponent>
	<!--- 	RESULTADO 
			Devuelve instancia del componente 
	--->
	<cffunction name="init">
		<cfreturn this >
	</cffunction>
	
	
	<!--- 	RESULTADO	
			Obtiene informacion de un centro funcional
	--->
	<cffunction name="obtenerCF" access="public" returntype="query" >
		<cfargument name="CFid" 	type="string" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">
	
		<cfquery name="rs_centro" datasource="#arguments.DSN#">
			select cf.CFid, cf.CFpath, cf.CFnivel, cf.CFuresponsable, cf.CFidresp
			from CFuncional cf
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		<cfreturn rs_centro >	
	</cffunction>

	<!--- 	RESULTADO	
			Obtiene el centro funcional de un empeado 
	--->
	<cffunction name="obtenerCFEmpleado" access="public" returntype="query" >
		<cfargument name="DEid" 	type="string" 	required="yes" >
		<cfargument name="fecha" 	type="date" 	required="no" default="#now()#" >
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">
	
		<cfquery name="rs_cfempleado" datasource="#arguments.DSN#">
			select cf.CFid, cf.CFpath, cf.CFnivel, cf.CFuresponsable, cf.CFidresp
			from LineaTiempo lt, RHPlazas p, CFuncional cf
			where p.RHPid = lt.RHPid
			 and cf.CFid = p.CFid
			 and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between lt.LTdesde and lt.LThasta
		</cfquery>
		<cfreturn rs_cfempleado >	
	</cffunction>

	<!--- 	RESULTADO	
			Obtiene la plaza responsable de un centro funcional. 
			Ademas tambien devuelve el empleado activo que ocupa la plaza.

	--->
	<cffunction name="obtenerPlazaResp" access="public" returntype="struct" >
		<cfargument name="CFid" 	type="string" 	required="yes" >
		<cfargument name="fecha" 	type="date" 	required="no" default="#now()#" >
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">
		
		<cfset struct_resultado = structnew() >	
		<cfset struct_resultado.RHPid = '' >
		<cfset struct_resultado.DEid = '' >

		<cfquery name="rs_plazaresponsable" datasource="#arguments.DSN#">
			select RHPid
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		
		<!--- determina la persona que esta ocupando la plaza --->
		<cfif len(trim(rs_plazaresponsable.RHPid))>
			<cfquery name="rs_cfempleado" datasource="#arguments.DSN#">
				select lt.DEid
				from LineaTiempo lt, RHPlazas p
				where p.RHPid = lt.RHPid
				 and lt.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_plazaresponsable.RHPid#">
				 and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between lt.LTdesde and lt.LThasta
			</cfquery>
			
			<cfif len(trim(rs_cfempleado.DEid))>
				<cfset struct_resultado.RHPid = rs_plazaresponsable.RHPid >
				<cfset struct_resultado.DEid = rs_cfempleado.DEid >
			</cfif>
		</cfif>
		<cfreturn struct_resultado >	
	</cffunction>

	<!--- 	RESULTADO 
			Determina quien es el jefe de un centro funcional
			El ejefe de un cf es:
				1. El empleado que tenga la plaza marcada como responsable del Centro Funcional.
				2. Si 1 no se cumple, el jefe seria la persona marcada en el campo CFuresponsable.
				3. Si 1 y 2 no se cumple, el jefe debe determinarse subiendo en la jerarquia del arbol, repitiendo pasos 1 y 2.
	--->
	<cffunction name="obtenerJefe" access="public" returntype="string">
		<cfargument name="CFid" 	type="string" 	required="yes" >
		<cfargument name="fecha" 	type="date" 	required="no" default="#now()#" >
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">

		<!--- obtiene informacion del centro funcional de un empleado --->
		<cfset v_datoscf_empleado = this.obtenerCF(arguments.CFid ) >
		
		<cfif len(trim(v_datoscf_empleado.CFid)) >
			<!--- obtiene la plaza responsable del centro funcional y el empleado que la ocupa (debe estar activo) --->
			<cfset v_plaza_resp = this.obtenerPlazaResp(v_datoscf_empleado.CFid) >
			
			<!--- si se encontraron datos, se devuelve el DEid del jefe --->
			<cfif len(trim(v_plaza_resp.DEid))>
				<cfreturn v_plaza_resp.DEid >
			</cfif>
			
			<!--- si no hay plaza responsable, se busca el usuario responable del cf del empleado(CFuresponsable) --->
			<cfif len(trim(v_datoscf_empleado.CFuresponsable))>
				<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="rsDEid">
					<cfinvokeargument name="Usucodigo" 	value="#v_datoscf_empleado.CFuresponsable#">
					<cfinvokeargument name="Ecodigo" 	value="#session.EcodigoSDC#">
					<cfinvokeargument name="Tabla" 		value="DatosEmpleado">
				</cfinvoke>	
				<cfif len(trim(rsDEid.llave))>
					<cfreturn rsDEid.llave >
				</cfif>
			</cfif>
			
			<!--- si la recursividad llego al nodo raiz, se devuelve --->
			<cfif not len(trim(v_datoscf_empleado.CFidresp))>
				<cfreturn 0>
			<cfelse>
				<!--- si no hay plaza responsable ni usuario responsable, debe buscar en el padre del cf (invocar esta misma funcion )--->
				<cfreturn this.obtenerJefe(v_datoscf_empleado.CFidresp, arguments.fecha)>
			</cfif>
		</cfif>

	</cffunction>
	
</cfcomponent>