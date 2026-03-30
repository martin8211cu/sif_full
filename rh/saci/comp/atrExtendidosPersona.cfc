<!------------------------------------------------ Agrega Atributos Extendidos Persona --------------------------------------------->
<!--- NOTA IMPORTANTE: Este componente esta muy relacionado con el tag de atrExtendidos, que pinta los campos de donde tomamos los valores para 
agregarlos y modificarlos en este componente.El atributo sufijo debe ser el mismo que el argumento sufijo del componente atrExtendidosPersona---> 


<cffunction name="Alta_Cambio" output="false" returntype="void" access="remote">
  	<cfargument 	name="tipo" 			type="string" 	required="Yes" 	default="1">					<!--- Tipo persona fisica=1,persona juridica=2,agente=3,cuenta=4)--->
	<cfargument 	name="id" 				type="string" 	required="Yes">									<!--- id de la Persona (Pquien)--->
  	<cfargument 	name="identificacion" 	type="string" 	required="Yes">									<!--- identificacion de la Persona (Pid)--->
  	<cfargument 	name="form" 			type="struct"	required="yes">									<!--- form que contiene todo los valores de los campos de los atributos extendidos --->
	<cfargument 	name="sufijo" 			type="string"	required="No" 	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
	<cfargument 	name="Usuario" 			type="string" 	required="No" 	default="#session.Usucodigo#">	<!--- Usuario --->
  	<cfargument 	name="Ecodigo" 			type="string" 	required="No" 	default="#session.Ecodigo#">	<!--- Empresa --->
  	<cfargument 	name="Conexion" 		type="string" 	required="No" 	default="#Session.DSN#">		<!--- Conexion --->
	
	<cfif Arguments.tipo EQ "1" or Arguments.tipo EQ "2">
		<cfset tabla = "ISBpersonaAtributo"> <!--- Persona Fisica o Juridica --->
		<cfset campos_tabla = "Aid,Pquien,PAvalor,BMUsucodigo">
		<cfset id_tabla = "Pquien">
		<cfif Arguments.tipo EQ "1">
			<cfset letra = "F_">
		<cfelse>
			<cfset letra = "J_">
		</cfif>
		
	<cfelseif Arguments.tipo EQ "3">
		<cfset tabla ="ISBagenteAtributo"><!--- Agente --->
		<cfset campos_tabla="Aid,AGid,AAvalor,BMUsucodigo">
		<cfset id_tabla="AGid">
		<cfset letra = "A_">
		
	<cfelseif Arguments.tipo EQ "4">
		<cfset tabla ="ISBcuentaAtributo"><!--- Vendedor-Cuenta --->
		<cfset campos_tabla="Aid,CTid,VALOR,BMUsucodigo">
		<cfset id_tabla="CTid">
		<cfset letra = "C_">
	
	<cfelse>
		<cfset letra = "">
		
	</cfif>
	
	<!--- Consulta de Atributos Extendidos--->
	<cfquery datasource="#Arguments.Conexion#" name="rsCampos">
		select Aid, Aetiq, AtipoDato 
		from ISBatributo
		where Habilitado = 1
			<cfif Arguments.tipo EQ "1">
				and AapFisica = 1
			<cfelseif Arguments.tipo EQ "2">
				and AapJuridica = 1
			<cfelseif Arguments.tipo EQ "3">
				and AapAgente = 1
			<cfelseif Arguments.tipo EQ "4">
				and AapCuenta = 1
			</cfif>
		order by Aorden
	</cfquery>

	<cfif rsCampos.RecordCount gt 0>
		
		<!--- Borra los valores para los atributos extendidos de la persona segun el tipo --->
		<cfquery datasource="#Arguments.Conexion#" name="rsAtrExiste">
			Delete #tabla#
			where #id_tabla# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id#">
		</cfquery>
		
		<cfset index = 1>
		
		<cfloop query="rsCampos">
			<cfset nomCampo = letra & rsCampos.Aid & Arguments.sufijo >			<!--- nombre del campo--->
			<cfif isdefined("form.#nomCampo#") and len(trim(Form[nomCampo]))>						<!--- ESTO NO ES CORRECTO PERO POR AHORA LO VOY A DEJAR ASI --->				
				<!--- Agrega el valor existente para el atributo extendido de esa persona --->				
				<cfquery datasource="#Arguments.Conexion#" name="rsAtrAlta">
					insert into #tabla#(#campos_tabla#)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.Aid#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form[nomCampo]#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
					)
				</cfquery>
			</cfif>
			<cfset index = index+1>
		</cfloop>
	</cfif>
</cffunction>