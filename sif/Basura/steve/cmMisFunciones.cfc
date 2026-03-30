<cfcomponent displayname="misFunciones" output="yes">
	<!--- Devuelve una o todas las monedas --->
	<cffunction name="fnVerMonedas" access="public" output="true" returntype="query">
		<cfargument name="id" type="numeric" required="no">
		<cfargument name="top" type="numeric" required="no">
		
		<cfquery name="qRs" datasource="minisif">
			select 
				<cfif isDefined("top")>
					top #top#					
				</cfif>
				Ecodigo, 
				Mnombre, 
				Msimbolo
			from Monedas
			<cfif isDefined("id")>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
			</cfif>			
		</cfquery>				
		<cfreturn qRs>
	</cffunction>	

	<!--- Borra la tabla temporal --->
	<cffunction name="tmp_BorrarTabla" output="true" returntype="boolean">
		<cftry>
			<cfquery datasource="minisif">
				drop table ##miTabla
			</cfquery>		
			<cfreturn true>
			<cfcatch type="database">
				<cfreturn false>
			</cfcatch>
		</cftry>	
	</cffunction>

	<!--- Crea la tabla temporal --->
	<cffunction name="tmp_CrearTabla" output="true" returntype="boolean">
		<cftry>
			<cfquery datasource="minisif">
				create table ##miTabla (
					cedula varchar(20),
					nombre varchar(30),
					apellidos varchar(30),
					direccion varchar(100),
					telefono varchar(9),
					nacionalidad varchar(3))
			</cfquery>
			<cfreturn true>
			<cfcatch type="database">
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>		

	<!--- Llena la tabla temporal --->
	<cffunction name="tmp_LlenarTabla" output="true" returntype="boolean">
		<cftry>
			<cfquery datasource="minisif">
				<cfloop list="5,10,15,20,25" index="i">
					insert into ##miTabla values ('#i#','Steve_#i#','Apellido_#i#','Direccion_#i#','442-48-4#i#','CRC')
				</cfloop>
			</cfquery>
			<cfreturn true>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Llena la tabla temporal (valores reales )--->
	<cffunction name="tmp_LlenarTablaReales" output="true" returntype="boolean">
		<cftry>
			<cfquery datasource="minisif">
				insert into ##miTabla values ('0','STEVE','VADO RODRIGUEZ','ALAJUELA','442-48-42','CRC')
				insert into ##miTabla values ('1','DAVINSSON','NUNJAR FLORES','SAN JOSE','297-01-41','GUA')
				insert into ##miTabla values ('2','NILA','NUNJAR FLORES','SAN JOSE','297-01-41','GUA')
				insert into ##miTabla values ('3','JONATHAN','SANCHEZ VASQUEZ','CARRISAL','443-53-41','CRC')
				insert into ##miTabla values ('4','MARIANA','HIDALGO','DESAMPARADOS','442-48-42','HON')
				insert into ##miTabla values ('5','VIVIAN','QUIROS SOTO','MONTECILLOS','442-48-42','ESA')
				insert into ##miTabla values ('6','PABLO','QUESADA QUIROS','EL CARMEN','442-48-42','ESA')
				insert into ##miTabla values ('7','CARLOS','CHACON','CARRISAL','442-48-42','NIC')
				insert into ##miTabla values ('8','SOFIA','VERGARA','ALAJUELA','442-48-42','CRC')
				insert into ##miTabla values ('9','ADRIANA','QUIROS SOTO','LA GARITA','442-48-42','PAN')
			</cfquery>
			<cfreturn true>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<!--- Inserta en la tabla temporal --->
	<cffunction name="tmp_InsertarTabla" output="true" returntype="boolean">
	<cfargument name="cedula" type="string" required="yes">
	<cfargument name="nombre" type="string" required="yes">
	<cfargument name="apellidos" type="string" required="yes">
	<cfargument name="direccion" type="string" required="yes">
	<cfargument name="telefono" type="string" required="yes">
	<cfargument name="nacionalidad" type="string" required="yes">
		<cftry>
			<cfquery datasource="minisif">
				insert into ##miTabla values ('#cedula#','#nombre#','#apellidos#','#direccion#','#telefono#','#nacionalidad#')
			</cfquery>
			<cfreturn true>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Actualiza en la tabla temporal --->
	<cffunction name="tmp_ActualizarTabla" output="true" returntype="boolean">
	<cfargument name="cedula" type="string" required="yes">
	<cfargument name="nombre" type="string" required="yes">
	<cfargument name="apellidos" type="string" required="yes">
	<cfargument name="direccion" type="string" required="yes">
	<cfargument name="telefono" type="string" required="yes">
	<cfargument name="nacionalidad" type="string" required="yes">
		<cftry>
			<cfquery datasource="minisif">
				update ##miTabla
				set nombre = '#nombre#',
					apellidos = '#apellidos#',
					direccion = '#direccion#',
					telefono = '#telefono#',
					nacionalidad = '#nacionalidad#'
				where cedula = '#cedula#'
			</cfquery>
			<cfreturn true>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Borra en la tabla temporal --->
	<cffunction name="tmp_BorrarEnTabla" output="true" returntype="boolean">
	<cfargument name="cedula" type="string" required="yes">
		<cftry>
			<cfquery datasource="minisif">
				delete from ##miTabla
				where cedula = '#cedula#'
			</cfquery>
			<cfreturn true>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Muestra el contenido de la tabla temporal --->
	<cffunction name="tmp_MostrarTabla" output="true" returntype="query">
		<cfargument name="CEDULA" type="string" required="no">
		<cftry>
			<cfquery name="rs" datasource="minisif">
				select cedula,nombre,apellidos,direccion,telefono,nacionalidad
				from ##miTabla
				<cfif isDefined("CEDULA")>
					where cedula = '#CEDULA#'
				</cfif>
			</cfquery>		
			<cfreturn rs>
			<cfcatch>
			</cfcatch>
		</cftry>
	</cffunction>	
	
	<!--- Devuelve el siguiente consecutivo de la tabla temporal --->
	<cffunction name="tmp_DemeConsecutivo" output="true" returntype="numeric">
		<cftry>
			<cfquery name="rs" datasource="minisif" maxrows="1">
				select (max(cast(cedula as int))+1) as consecutivo
				from ##miTabla
			</cfquery>
			<cfreturn #rs.consecutivo#>
			<cfcatch>
				<cfreturn -1>
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>