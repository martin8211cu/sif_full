<cfcomponent output="no" hint="Tarea de Retiro de Servicios">
	<cffunction name="ejecutar" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="TPid" type="numeric" required="yes">
		<cfargument name="CTid" type="numeric" required="yes">
		<cfargument name="Contratoid" type="numeric" required="yes">
		<cfargument name="LGnumero" type="numeric" required="no">
		<cfargument name="TPxml" type="xml" required="yes">
		
		<cfinvoke component="saci.comp.ISBtareaProgramadaRS" method="RetiroServicioProgramado">		<!--- ejecutar la tarea programada --->
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		  	<cfinvokeargument name="Contratoid" value="#Arguments.Contratoid#">
		  	<cfinvokeargument name="MRid" value="#TPxml.retiroServicio.motivoRetiro.codigoMotivo.XmlText#">
		</cfinvoke>
		
	</cffunction>
	
	<cffunction name="RetiroServicioProgramado" access="public" returntype="void" output="false">
		<cfargument name="datasource" 	type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Contratoid" 	type="numeric" 	required="yes">
		<cfargument name="fecha" 		type="date" 	required="no" default="#now()#"> 
		<cfargument name="MRid" 		type="string" 	required="yes">
		
		<cfinvoke component="saci.comp.ISBproducto" method="RetirarProducto">
			<cfinvokeargument name="datasource"value="#Arguments.datasource#">
		  	<cfinvokeargument name="Contratoid" value="#Arguments.Contratoid#">
		  	<cfinvokeargument name="MRid" value="#Arguments.MRid#">
			<cfinvokeargument name="fecha" value="#Arguments.fecha#">
		</cfinvoke>
		
	</cffunction>
	
</cfcomponent>