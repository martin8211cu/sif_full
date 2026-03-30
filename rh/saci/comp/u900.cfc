<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBprepago">

<cffunction name="traeMotivo" output="true" returntype="string" access="remote">
	<cfargument name="conCompromiso" type="boolean" required="No" default="0" displayname="ConCompromiso">
	<cfargument name="Empresa" type="numeric" required="No" default="#session.Ecodigo#" displayname="Empresa">
	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">	
	<cfset codMotivo = '-1'>
	<cfset conCompro = 0>
	<cfset sinCompro = 1>
	<cfif Arguments.conCompromiso EQ 1>
		<cfset conCompro = 1>
		<cfset sinCompro = 0>
	</cfif>
	
	<cfquery name="rsMotivo" datasource="#Arguments.conexion#">
		Select min(MBmotivo) as MBmotivo
		from ISBmotivoBloqueo 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
			and MBsinCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#sinCompro#">
			and MBconCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#conCompro#">	
	</cfquery>	
	<cfif isdefined('rsMotivo') and rsMotivo.recordCount GT 0>
		<cfset codMotivo = rsMotivo.MBmotivo>
	</cfif>
	
	<cfreturn codMotivo>
</cffunction>

<cffunction name="existeMedio" output="true" returntype="numeric" access="remote">
	<cfargument name="MDref" type="string" required="Yes"  displayname="Cuenta_900">
	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
	
	<cfset minCia = -1>
	
	<cfquery name="rsCia" datasource="#Arguments.conexion#">
		select MDbloqueado
		from ISBmedio
		where MDref=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.MDref)#">
	</cfquery>	
	
	<cfif isdefined('rsCia') and rsCia.recordCount GT 0>
		<cfif rsCia.MDbloqueado EQ 1>
			<cfset minCia = 1>
		<cfelse>
			<cfset minCia = 0>
		</cfif>
	</cfif>
	
	<cfreturn minCia>
</cffunction>

<cffunction name="retMinCia" output="true" returntype="numeric" access="remote">
	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
	<cfargument name="Ecodigo" type="numeric" required="No" default="#session.Ecodigo#" displayname="Empresa">	
	<cfset varMinCia = -1>
	
	<cfquery name="rsCia" datasource="#Arguments.conexion#">
		select min(EMid) as EMid
		from ISBmedioCia 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">	
	</cfquery>
	
	<cfif isdefined('rsCia') and rsCia.EMid NEQ ''>
		<cfset varMinCia = rsCia.EMid>
	</cfif>
	
	<cfreturn varMinCia>
</cffunction>			

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="MDref" type="string" required="Yes"  displayname="Cuenta_900">
  <cfargument name="MDbloqueado" type="numeric" required="Yes"  displayname="Estado_Cuenta_900">
  <cfargument name="EMid" type="numeric" required="no" displayname="EmpresaDistribuidora">
  <cfargument name="MBmotivo" type="string" required="no"  displayname="Motivo_Bloqueo">  
  <cfargument name="BTobs" type="string" required="no" default=""  displayname="Observaciones_Bloqueo">    
  <cfargument name="Habilitado" type="numeric" required="no"  default="1" displayname="Habilitado">    
  <cfargument name="MDlimite" type="numeric" required="no"  default="36" displayname="Max_Horas_Conex"> 
  <cfargument name="verifExiste" type="boolean" required="no" default="false" displayname="Verificacion_si_existe_el_medio">  
  <cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
  
	<cfset existe = false>
	<cfif verifExiste>
		<cfif existeMedio(Arguments.MDref,session.dsn) NEQ -1>
			<cfset existe = true>
		</cfif>
	</cfif>

	<cfif not existe>
		<cfset valEMid = -1>
		<cfif isdefined('Arguments.EMid') and Arguments.EMid NEQ '' and Arguments.EMid NEQ -1>
			<cfset valEMid = Arguments.EMid>
		<cfelse>
			<cfset valEMid = retMinCia(session.dsn,session.Ecodigo)>
		</cfif>
		<cfset varMotivo = "-1">
		<cfif isdefined('Arguments.MBmotivo') and Arguments.MBmotivo NEQ ''>
			<cfset varMotivo = Arguments.MBmotivo>
		<cfelse>
			<!--- Trae el primer motivo de bloqueo que se encuentre --->
			<cfset varMotivo = traeMotivo(0,session.Ecodigo,session.dsn)>
		</cfif>  
		
		<cfif valEMid NEQ -1>
			<cfquery datasource="#Arguments.conexion#">
				insert ISBmedio 
					(MDref, MDbloqueado, EMid, MBmotivo, Habilitado, BMUsucodigo, MDlimite)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MDbloqueado#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#valEMid#">
					<cfif Arguments.MDbloqueado EQ 1>
						<cfif varMotivo NEQ '-1'>
							, <cfqueryparam cfsqltype="cf_sql_char" value="#varMotivo#">			
						<cfelse>
							, null
						</cfif>
					<cfelse>
						, null
					</cfif>				
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Habilitado#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MDlimite#" null="#Len(Arguments.MDlimite) Is 0#">)  
			</cfquery>
	
			<cfset Mensaje = "Alta de un nuevo Medio">
			<!--- Observaciones del usuario para el bloqueo --->
			<cfif Arguments.BTobs NEQ ''>
				<cfset Mensaje = Mensaje & " *** " & Arguments.BTobs>
			</cfif>			
	
			<!--- Insercion en la bitacora de Medios --->
			<cfinvoke component="saci.comp.ISBbitacoraMedio"
				method="Alta">
				<cfinvokeargument name="MDref" value="#Arguments.MDref#">
				<cfinvokeargument name="EMid" value="#valEMid#">
				<cfinvokeargument name="BTobs" value="#Mensaje#">
			</cfinvoke> 				
		</cfif>
	<cfelse>
		<cfthrow message="Error, el medio ya existe en la base de datos, por favor digitar uno diferente">
	</cfif>
</cffunction>

<cffunction name="CambioEstado" output="false" returntype="void" access="remote">
  	<cfargument name="MDref" type="string" required="Yes"  displayname="Cuenta_900">
  	<cfargument name="MDbloqueado" type="numeric" required="Yes"  displayname="Estado_Cuenta_900">
  	<cfargument name="MBmotivo" type="string" required="no"  displayname="Motivo_Bloqueo">  
  	<cfargument name="BTobs" type="string" required="no" default=""  displayname="Observaciones_Bloqueo">  	
  	<cfargument name="MDlimite" type="numeric" required="no" default="36" displayname="Max_Horas_Conex">    
  	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">  
 
 	<cfset estadoAct = existeMedio(Arguments.MDref,session.dsn)>
 
  	<cfif estadoAct NEQ -1>
		<!--- El telefono existe en ISBmedio --->
		<cfif estadoAct NEQ Arguments.MDbloqueado>
			<cfset varMotivo = "-1">
			<cfif Arguments.MDbloqueado EQ 1>
				<cfif isdefined('Arguments.MBmotivo') and Arguments.MBmotivo NEQ ''>
					<cfset varMotivo = Arguments.MBmotivo>
				<cfelse>
					<!--- Trae el primer motivo que se encuentre --->
					<cfset varMotivo = traeMotivo(0,session.Ecodigo,session.dsn)>
				</cfif>
			</cfif>
										
			<cfquery datasource="#Arguments.conexion#">
				update ISBmedio
					set MDbloqueado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MDbloqueado#">
						<cfif Arguments.MDbloqueado EQ 1>
							<cfif varMotivo NEQ '-1'>
								, MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#varMotivo#">			
							<cfelse>
								, MBmotivo = null
							</cfif>
						<cfelse>
							, MBmotivo = null
						</cfif>
						, MDlimite = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MDlimite#">									
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">
			</cfquery>	
			
			<!--- Realiza en query para averiguar el EMid de la Empresa del medio --->
			<cfquery name="rsEMid" datasource="#Arguments.conexion#">
				Select EMid
				from ISBmedio
				where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">
			</cfquery>
			
			<cfif isdefined('rsEMid') and rsEMid.recordCount GT 0>
				<cfif Arguments.MDbloqueado EQ 1>
					<cfset Mensaje = "Bloqueo por parte del usuario">
				<cfelseif Arguments.MDbloqueado EQ 0>
					<cfset Mensaje = "Desbloqueo por parte del usuario">
				</cfif>
				<!--- Observaciones del usuario para el bloqueo --->
				<cfif Arguments.BTobs NEQ ''>
					<cfset Mensaje = Mensaje & " *** " & Arguments.BTobs>
				</cfif>				
				
				<!--- Insercion en la bitacora de Medios --->
				<cfinvoke component="saci.comp.ISBbitacoraMedio"
					method="Alta">
					<cfinvokeargument name="MDref" value="#Arguments.MDref#">
					<cfinvokeargument name="EMid" value="#rsEMid.EMid#">
					<cfinvokeargument name="BTobs" value="#Mensaje#">
				</cfinvoke> 		
			</cfif>
		
		</cfif>
	<cfelse>
		<!--- El telefono no existe en ISBmedio, por eso se inserta --->
		<cfset tmpMotivo = "">
		<cfif isdefined('Arguments.MBmotivo') and Arguments.MBmotivo NEQ ''>
			<cfset tmpMotivo = Arguments.MBmotivo>
		</cfif>

		<cfset Alta(  Arguments.MDref
					, Arguments.MDbloqueado
					, -1
					, tmpMotivo
					, Arguments.BTobs
					, 1
					, Arguments.MDlimite
					, false
					, Arguments.conexion)>			
	</cfif>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  	<cfargument name="MDref" type="string" required="Yes"  displayname="Cuenta_900">
  	<cfargument name="EMid" type="numeric" required="yes"  displayname="Compania">    		
	<cfargument name="BTobs" type="string" required="no" default=""  displayname="Observaciones_Bloqueo">  	
  	<cfargument name="MDlimite" type="numeric" required="no"  displayname="Max_Horas_Conex">    
  	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">  
  
	<cfquery datasource="#Arguments.conexion#">
		update ISBmedio
			set MDlimite = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MDlimite#" null="#Len(Arguments.MDlimite) Is 0#">						
			, EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">
	</cfquery>
	
	<cfset Mensaje = "Cambio del límite de tiempo de conexión y compañía por parte del usuario">
	<!--- Observaciones del usuario para el bloqueo --->
	<cfif Arguments.BTobs NEQ ''>
		<cfset Mensaje = Mensaje & " *** " & Arguments.BTobs>
	</cfif>				
	
	<!--- Insercion en la bitacora de Medios --->
	<cfinvoke component="saci.comp.ISBbitacoraMedio"
		method="Alta">
		<cfinvokeargument name="MDref" value="#Arguments.MDref#">
		<cfinvokeargument name="EMid" value="#Arguments.EMid#">
		<cfinvokeargument name="BTobs" value="#Mensaje#">
	</cfinvoke> 		
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  	<cfargument name="MDref" type="string" required="Yes"  displayname="Cuenta_900">
  	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion"> 
	
	<cfquery name="rsDelBitMedio" datasource="#Arguments.conexion#">
		Select 1
		from ISBbitacoraMedio
		where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">
	</cfquery>	
	<cfif rsDelBitMedio.recordCount EQ 0>
		<cfquery datasource="#Arguments.conexion#">
			Delete ISBmedio
			where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">	
		</cfquery>		
	<cfelse>
		<cfthrow message="Error, este teléfono ya tiene registrado historial en la bitácora, por tal motivo no se permite su eliminación.">
	</cfif>
</cffunction>

</cfcomponent>

