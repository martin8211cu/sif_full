<cfcomponent>
	
	<cffunction name="ALTA" access="public" returntype="query" >
		<cfargument name="Edescripcion" type="string" required="yes"/>
		<cfargument name="Ecodigo" type="string" required="yes"/> 	
		<cfargument name="Efax" type="string" required="no"/> 
		<cfargument name="Etelefono1" type="string" required="no" default=""/> 
		<cfargument name="Edireccion1" type="string" required="no" default=""/> 
		<cfargument name="Eciudad" type="string" required="no" default=""/> 
		<cfargument name="Eprovincia" type="string" required="no" default=""/> 
		<cfargument name="Ppais" type="string" required="yes"/> 
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>
		
		
	
		<cfquery name="rs" datasource="#arguments.conexion2#">
		insert into Equipo (Ecodigo, Edescripcion, Etelefono1, Efax, Edireccion1, Eciudad, Eprovincia, Ppais, BMfalta, BMUsucodigo)
			values(	'#arguments.Ecodigo#', '#arguments.Edescripcion#', 
			'#arguments.Etelefono1#', '#arguments.Efax#', '#arguments.Edireccion1#', '#arguments.Eciudad#', '#arguments.Eprovincia#', '#arguments.Ppais#',					
						#arguments.BMfalta#, 
						#arguments.BMUsucodigo#
									  )
		
	<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rs">

		<!--- <cfquery name="rs" datasource="#arguments.conexion2#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>  --->
		<cfreturn rs>
	</cffunction>
	
<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="EDid" type="numeric" required="yes"/>
		<cfargument name="Edescripcion" type="string" required="yes"/>
		<cfargument name="Ecodigo" type="string" required="yes"/>
		<cfargument name="Etelefono1" type="string" required="no" default=""/> 
		<cfargument name="Efax" type="string" required="no" default=""/> 
		<cfargument name="Edireccion1" type="string" required="no" default=""/> 
		<cfargument name="Eciudad" type="string" required="no" default=""/> 
		<cfargument name="Eprovincia" type="string" required="no" default=""/> 
		<cfargument name="Ppais" type="string" required="yes"/>  	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no"/>
		 
		<cfquery datasource="#session.dsn#">
		update Equipo
		set Edescripcion = '#arguments.Edescripcion#', 
		    Ecodigo = '#arguments.Ecodigo#',
			Etelefono1 = '#arguments.Etelefono1#',
			Efax = '#arguments.Efax#',
			Edireccion1 = '#arguments.Edireccion1#',
			Eciudad = '#arguments.Eciudad#',
			Eprovincia = '#arguments.Eprovincia#',
			Ppais = '#arguments.Ppais#'
			
		where EDid = #arguments.EDid#
			
	</cfquery>
		<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>--->
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete Equipo
		where EDid = #arguments.EDid#
	</cfquery>	
	<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid# 
		</cfquery>--->
		<cfreturn 1> 
	</cffunction>
</cfcomponent>
