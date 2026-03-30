<!---
	Creado por: Jeremias Ceciliano
	Fecha: 09/03/2015
	Descripcion:
			Componente encargado de todos los procesos relacionados a
			administracion y consulta sobre preferencias de usuario
--->
<cfcomponent output="false" hint="Preferencias por Usualrio" namespace="http://sif.WS">


	<!--- Guarda una nueva preferencia o actualiza una existente --->
	<!---
		llave: identificador unico por para un tipo de preferencia, generalmente se usa componente.RutaDelFuente, por ejemplo (cc.ConsultaDocumentos.cfm)
		 modo:
		 				  Alta: Guarda un nuevo registrof
		 	  			Cambio: Actualiza la preferencia que envian
	  			CambioConCopia: Aun no implementado, la idea es guardar la preferencia y generar una copia de la anterior
		 Tipo:  Categoria, puede ser Reporte | o cualquier otra q ocupemos a futuro.
		 Ecodigo: obvio
		 Usucodigo: obvio tambien.
		 si _resultado.MSG es distinto de OK es porque ocurrio un error el cual se indica en esa misma variable
	--->
	<cffunction name="savePreferenciaUsuario" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="llave"     type="string"  required="true"  hint="llave unica por cada tipo de preferencia">
		<cfargument name="modo"      type="string"  required="true"  hint="Alta|Cambio|CambioConCopia">
		<cfargument name="datos"     type="string"  required="true"  hint="datos a almacenar, json|xml|html">
		<cfargument name="Tipo"      type="string"  required="true"  hint="reporte|general|etc...">
		<cfargument name="nombre"    type="string"  required="false"  default=" - " hint="Nombre del historico">
		<cfargument name="descripcion" type="string" required="false" default=" - " hint="Descripcio">
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#session.Usucodigo#">
		<cfargument name="idDPreferencias" type="numeric" required="false" default="-1"> <!--- en caso de cambio debe venir pues es el id a modificar --->

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>
		<cfset _resultado.idDPreferencias = -1>

		<cftry>
			<!--------------------------------------------------------------------------------------------->

			<!--- Valida que el Arguments.Modo sea valido --->
			<cfif not listFind('Alta,Cambio,CambioConCopia',Arguments.modo)>
				<cfset _resultado.MSG = 'Se debe indicar un modo Alta,Cambio,CambioConCopia.'>
				<cfreturn _resultado>
			</cfif>

			<!--- Si es cambio debe venir definido el idDPreferencias a modificar --->
			<cfif listFind('Cambio,CambioConCopia',Arguments.modo)>
				<cfif not isDefined('Arguments.idDPreferencias')>
					<cfset _resultado.MSG = 'En modo cambio se debe definir el id de la preferencia a modificar. Arguments.idDPreferencias'>
					<cfreturn _resultado>
				</cfif>
			</cfif>

			<!--------------------------------------------------------------------------------------------->
			<!--- Arguments.Modo EQ Alta --->
			<cfif Arguments.modo EQ 'Alta'>
				<cfquery name="rsInsert" datasource="asp">
					insert into DPreferencias(Ecodigo,Usucodigo,llave,Tipo,nombre,descripcion,data,FechaModificacion)
					values(
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.llave#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.descripcion#">
							,<cfqueryparam cfsqltype="cf_sql_BLOB"    value="#CharsetDecode(Arguments.datos,'utf-8')#">
							,#Now()#
						  )
					<cf_dbidentity1 datasource="asp">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" datasource="asp" returnvariable="rsidDPreferencias">
				<cfset _resultado.idDPreferencias = rsidDPreferencias> <!--- id generado --->
			<!--- Cambio --->
			<cfelseif Arguments.modo EQ 'Cambio'>
				<cfquery datasource="asp">
					update DPreferencias
						set data = <cfqueryparam cfsqltype="cf_sql_BLOB"    value="#CharsetDecode(Arguments.datos,'utf-8')#">
							,FechaModificacion = #Now()#
					where idDPreferencias = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDPreferencias#">
				</cfquery>
			<!--- Cambio con Copia --->
			<cfelseif Arguments.modo EQ 'CambioConCopia'>
				<cfset _resultado.MSG = 'Funcionalidad aun no implementada!!!'>
				<cfreturn _resultado>
			</cfif>
			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>
		<cfreturn _resultado>
	</cffunction> <!--- fin de: savePreferenciaUsuario --->

	<!---
		Consulta Las preferencias del usuario en la empresa y Tipo especificado, devuelve unicamente valores generales
		como nombre y descripcion, si se desea obtener el contenido de dicha preferencia se debe invocar la funcion
		getPreferenciaUsuario() que es para ello.

		Ecodigo: obvio
		Usucodigo: mas que obvio
		llave: llave a la cual queremos consultar
		filtro_nombre: substring por el cual filtraremos la columna de nombre
		filtro_descripcion: substring por el cual filtraremos la columna de descripcion,
		cantidadMaximaResultados: Cantidad maxima de resultados a obtener.
		return Lista {
						MSG: string OK es todo bien.
						ListaPreferencias:
										[
											[idDPreferencias,nombre,descripcion]
											[idDPreferencias,nombre,descripcion]
											[idDPreferencias,nombre,descripcion]
										]
		}
		si _resultado.MSG es distinto de OK es porque ocurrio un error el cual se indica en esa misma variable
	--->
	<cffunction name="consultaPreferenciasUsuario" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="llave"                    type="string"  required="true"  hint="llave unica por cada tipo de preferencia">
		<cfargument name="Tipo"                     type="string"  required="true"  hint="reporte|general|etc...">
		<cfargument name="filtro_nombre"            type="string"  required="false" hint="filtro para el campo nombre">
		<cfargument name="filtro_descripcion"       type="string"  required="false" hint="filtro para el campo nombre">
		<cfargument name="cantidadMaximaResultados" type="numeric" required="false" default="10" hint="Maxima cantidad de resultados (top x)">
		<cfargument name="Ecodigo"                  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="Usucodigo"                type="numeric" required="false" default="#session.Usucodigo#">

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>
		<cfset _resultado.Lista = arrayNew(1)>

		<cftry>
			<cfquery name="rs" datasource="asp">
				select top #Arguments.cantidadMaximaResultados#
					   dp.idDPreferencias,
				       dp.nombre,
				       dp.descripcion,
				       dp.FechaModificacion
				from DPreferencias dp
				where dp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and dp.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				  and dp.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.llave#">
				  and dp.Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
				  <cfif Len(Trim(Arguments.filtro_nombre))>
				  	and dp.nombre like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.filtro_nombre#%">
				  </cfif>
				  <cfif Len(Trim(Arguments.filtro_descripcion))>
				  	and dp.descripcion like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.filtro_descripcion#%">
				  </cfif>
			</cfquery>
			<cfloop query="rs">
				<cfset res = structNew()>
				<cfset res.idDPreferencias = rs.idDPreferencias>
				<cfset res.nombre = rs.nombre>
				<cfset res.descripcion = rs.descripcion>
				<cf_locale name="date" value="#rs.FechaModificacion#" returnvariable="LvarFechaEN"/>
				<cfset res.FechaModificacion = LvarFechaEN&' '&LSDateFormat(rs.FechaModificacion,'hh:mm')>
				<cfset arrayAppend(_resultado.Lista,res)>
			</cfloop>
			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>
		<cfreturn _resultado>
	</cffunction> <!--- fin de: consultaPreferenciasUsuario --->


	<!---
		Obtiene Todos los valores de una Preferencia de Usuario, incluyendo la data que es un poco pesada
		idDPreferencias: id de la preferencia  cargar
		return un Struct Json con la dat y todo lo demas
		si _resultado.MSG es distinto de OK es porque ocurrio un error el cual se indica en esa misma variable.
	--->
	<cffunction name="getPreferenciaUsuario" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="idDPreferencias" type="numeric" required="true" hint="id de la preferencia a obtener">

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>

		<cftry>
			<cfquery name="rs" datasource="asp">
				select dp.idDPreferencias,
				       dp.nombre,
				       dp.descripcion,
				       dp.data,
				       dp.FechaModificacion
				from DPreferencias dp
				where dp.idDPreferencias = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDPreferencias#">
			</cfquery>
			<cfif not rs.recordCount>
				<cfset _resultado.MSG = 'No se encontro ninguna preferencia con el idDPreferencias indicado'>
				<cfreturn _resultado>
			</cfif>
			<!--- asignamos valores ---->
			<cfset _resultado.idDPreferencias = rs.idDPreferencias>
			<cfset _resultado.nombre = rs.nombre>
			<cfset _resultado.descripcion = rs.descripcion>
			<cfset _resultado.data = CharsetEncode(rs.data, 'utf-8')>
			<cfset _resultado.FechaModificacion = LSDateFormat(rs.FechaModificacion,'dd/mm/yyyy hh:mm')>
			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>

		<cfreturn _resultado>
	</cffunction> <!--- fin de: getPreferenciaUsuario --->


	<!---
		deletePreferenciaUsuario borra una preferencia de usuario
		idDPreferencias: id que se desea borrar
		si _resultado.MSG es distinto de OK es porque ocurrio un error el cual se indica en esa misma variable.
	--->
	<cffunction name="deletePreferenciaUsuario" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="idDPreferencias" type="numeric" required="true" hint="id de la preferencia que se desea borrar">

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>

		<cftry>
			<cfquery datasource="asp">
				delete from DPreferencias
				where idDPreferencias = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDPreferencias#">
			</cfquery>
			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>

		<cfreturn _resultado>
	</cffunction> <!--- fin de: deletePreferenciaUsuario --->



	<cffunction name="setFavorites" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="datos"     type="string"  required="true"  hint="datos a almacenar, json|xml|html">
		<cfargument name="Usucodigo"     type="numeric"  required="true"  default="#session.Usucodigo#">
		<cfargument name="Ecodigo"     type="numeric"  required="true"  default="#session.Ecodigo#">

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>

		<cftry>
			<cfquery name="rsInsert" datasource="asp">
				select count(1) as valor from DPreferencias
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
			<cfif rsInsert.valor>
				<cfif !len(trim(arguments.datos))>
					<cfquery datasource="asp">
						delete DPreferencias
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
							and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							and llave='NavLeftFavorites'
					</cfquery>
				<cfelse>
					<cfquery datasource="asp">
						update DPreferencias
							set data = <cfqueryparam cfsqltype="cf_sql_BLOB"    value="#CharsetDecode(Arguments.datos,'utf-8')#">
								,FechaModificacion = #Now()#
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
							and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							and llave='NavLeftFavorites'
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="rsInsert" datasource="asp">
					insert into DPreferencias(Ecodigo,Usucodigo,llave,Tipo,nombre,descripcion,data,FechaModificacion)
					values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="NavLeftFavorites">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="NavLeftFavorites">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="NavLeftFavorites">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="NavLeftFavorites">
							,<cfqueryparam cfsqltype="cf_sql_BLOB"    value="#CharsetDecode(Arguments.datos,'utf-8')#">
							,#Now()#
						  )
				</cfquery>
			</cfif>

			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>
		<cfreturn _resultado>
	</cffunction> <!--- fin de: savePreferenciaUsuario --->


	<!---
		Obtiene Todos los valores de una Preferencia de Usuario, incluyendo la data que es un poco pesada
		idDPreferencias: id de la preferencia  cargar
		return un Struct Json con la dat y todo lo demas
		si _resultado.MSG es distinto de OK es porque ocurrio un error el cual se indica en esa misma variable.
	--->
	<cffunction name="getFavorites" access="remote"  output="false" returntype="Struct" returnformat="JSON">
		<cfargument name="Usucodigo"     type="numeric"  required="true"  default="#session.Usucodigo#">
		<cfargument name="Ecodigo"     type="numeric"  required="true"  default="#session.Ecodigo#">

		<cfset _resultado = structNew()>
		<cfset _resultado.MSG = 'OK'>

		<cftry>
			<cfquery name="rs" datasource="asp">
				select dp.data
				from DPreferencias dp
				where dp.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
						and dp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and dp.llave='NavLeftFavorites'
			</cfquery>
			<cfif not rs.recordCount>
				<cfset _resultado.MSG = 'OK'>
				<cfset _resultado.DATA = 0>
				<cfreturn _resultado>
			</cfif>
			<!--- asignamos valores ---->
			<cfset _resultado.data = CharsetEncode(rs.data, 'utf-8')>

			<cfset arrayProcesos= arrayNew(1)>

			<cfloop list="#_resultado.data#" index="i">
				<cfset e=StructNew()>
				<cfset e.code=trim(ucase(i))>
					<cfquery datasource="asp" name="rsProcesos">
						select SScodigo, SMcodigo, SPcodigo,SPhomeuri,SPdescripcion
						from SProcesos
						where  upper(SScodigo) = '#trim(ucase(listGetAt(i,1,'.')))#'
							and upper(SMcodigo) = '#trim(ucase(listGetAt(i,2,'.')))#'
							and upper(SPcodigo) = '#trim(ucase(listGetAt(i,3,'.')))#'
					</cfquery>
				<cfset e.descr=rsProcesos.SPdescripcion>
				<cfset e.uri='/cfmx'&rsProcesos.SPhomeuri>

				<cfset arrayAppend(arrayProcesos, e)>
			</cfloop>
			<cfset _resultado.data=arrayProcesos>
			<cfcatch type="any">
				<cfset _resultado.MSG = cfcatch.message & " - " & cfcatch.detail>
				<cfreturn _resultado>
			</cfcatch>
		</cftry>

		<cfreturn _resultado>
	</cffunction> <!--- fin de: getPreferenciaUsuario --->




</cfcomponent>