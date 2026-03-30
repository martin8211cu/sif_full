<!--- 
Archivo: FilmRotationCFC.cfc
Proposito: Ejemplo de un componente
--->

<cfcomponent>
	<!--- inicio de la incializacion del codigo --->
	<cfset this.ActivosList = RandomizedAcitvosList()>
	<cfset this.CurrentListPos = 1>
	<cfset this.RotationInterval = 5>
	<cfset this.CurrentUntil = DateAdd("s",this.RotationInterval,Now())>
	<!--- fin de la inicializacion del codigo --->
	
	<!--- funcion privada: RandomizedActivosList() --->
	<cffunction name="RandomizedActivosList" 
				returntype="string" 
				access="Private" 
				hint="Para uso Interno. Retorna una lista de todos los Id's de los Activos, en orden aleatorio">

		<!--- esta variable es solo para uso de esta funcion --->
		<cfset var GetActivoIds = "">
		<!--- crea una lista a partir de una consulta a la base de datos --->
		<cfquery name="GetActivosIDs" datasource="minisif" 
						cachedwithin="#CreateTimeSpan(0,1,0,0)#">
				Select Aid
				From Activos
				order by Adescripcion
		</cfquery>
		
		<!--- Retorma la lista de activos --->
		<cfreturn ListRandomized(ValueList(GetActivoIds))>
	</cffunction>
	
	<!--- funcion privada: ListRandomized --->
	<cffunction name="ListRandomize" returntype="string" hint="Ordena aleatoriamente una lista separada por comas.">
		<!--- lista de argumentos --->
		<cfargument name="Lista" type="string" required="yes" hint="el string que se quiere ordenar aleatoriamente">
		
		<!--- variables qe solamente se utilizan en esta funcion --->
		<cfset var Result = "">
		<cfset var RandPos = "">
		
		<!--- mientras que hayan elementos en la lista  --->
		<cfloop condition="ListLen(arguments.Lista) gt 0">
			<!--- selecciona una posicion aleatoria en la lista --->
			<cfset RandPos = RandRange(1,ListLen(arguments.Lista))>
			<!--- agrega el item seleccionado a la lista Result --->
			<cfset Result = ListAppend(Result,ListGetAt(arguments.Lista,RandPos))>
			<!--- Elimina el item de la lista original (lista) --->
			<cfset arguments.Lista = ListDeleteAt(arguments.Lista,RandPos)>
		</cfloop>
		
		<cfreturn Result>
	</cffunction>
	
	<!--- Metodo Privado: IsActivosNeedingRotation() --->
	<cffunction name="IsActivosNeedingRotation" access="private" returntype="boolean" hint="para uso interno. retorna true si el activo debe rotarse ahora">
		<!--- compara el la hora actual con la hora que se encuentra en this.currentuntil --->
		<!--- si el tiempo no ha pasado entonces DateCompare() retorna 1 --->
		<cfset var DateComparison= DateCompare(this.CurrentUntil, Now())>
		
		<!--- retorna true si el activo esta actualizado --->
		<cfreturn DateComparison neq 1>
	</cffunction>
	
	<!--- Metodo RotateActivo --->
	<cffunction name="RotateActivo" access="private" hint="para uso interno. modifica el activo actual">
		<cfif IsActivosNeedingRotation()>
			<!--- incrementa en uno la instacion de this.currentlistpos --->
			<cfset this.CurrentListPos = this.CurrentListPos + 1>
			<!--- si es mayor que la cantidad de elementos en la lista --->
			<!--- empieza desde el principio de la lista --->		
			<cfif this.CurrentListPos gt ListLen(this.ActivosList)>
				<cfset this.CurrentListPos = 1>
			</cfif>
			
			<!--- asigna el tiempo de la siguiente rotacion --->
			<cfset this.CurrentUntil = DateAdd("s", this.RotationInterval, Now())>
		</cfif>
	</cffunction>
	
	<!--- Metodo Privado: CurrentActivoID --->
	<cffunction name="CurrentActivoID" access="private" returntype="numeric" hint="para uso interno. Retorna el Id del activo actual.">
		<!--- retorna el Aid de la fila actual de la consulta GetActivosIDs --->
		<cfreturn ListGetAt(this.ActivosList, this.CurrentListPos)>
	</cffunction>

	<!--- Metodo Publico: GetCurrentActivoID --->
	<cffunction name="GetCurrentActivoID" access="public" returntype="numeric" hint="Retorna el numero del actual activo">
		<!--- Primero, rota el actual activo --->
		<cfset RotateActivo()>
		
		<!--- retorna el ID del actual activo --->
		<cfreturn CurrentFilmID()>
	</cffunction>

	<!--- Metodo publico: GetCurrentActivoData --->
	<cffunction name="GetCurrentActivoData" access="remote" hint="retorna un dato estructurado acerca del activo actual">
		<!--- variable local --->
		<cfset var CurrentActivoData = "">
		
		<!--- invoca el metodo GetCurrentActivoID (en componentes separados) --->
		<!--- Retorna una estructura --->
		<cfinvoke component="ActivosDataCFC2" method="GetActivoData" ActivoID ="#GetCurrentActivoID#" returnvariable="CurrentActivoData">
		
		<!--- retorna la estructura --->
		<cfreturn CurrentActivoData>
	</cffunction>
	
</cfcomponent>