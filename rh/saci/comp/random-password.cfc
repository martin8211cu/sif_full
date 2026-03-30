

<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente que Genera claves aleatorias validas">
	
	<!---data.user.valid.chars			<!---caracteres validos--->
		data.pass.long.max				<!---longitud maxima--->
		data.pass.long.min				<!---longitud minima--->
		data.pass.valida.letras			<!---valida letras--->
		data.pass.valida.digitos		<!---Números--->
		data.pass.valida.simbolos		<!---Símbolos--->
		data.pass.valida.usuario		<!---Comparar contraseña con usuario. --->
		data.pass.valida.diccionario	<!---Validar la contraseña contra un diccionario --->
		data.pass.valida.lista			<!---Evitar que se repitan las últimas contraseñas--->
	--->
	
	
	<!---El siguiente codigo forma un string con los caracteres permitidos segun la configuracion del portal--->
	<!---Los caracteres permitidos para una password se dividen en Letras, Digitos y Simbolos dependiendo de estas diviciones tomaremos los caracteres q seran tomados en cuenta para generar el password aleatoriamente --->
	<cffunction name="Genera_String" output="false" returntype="string" access="remote">
	  <cfargument name="data" 	type="struct"	required="Yes">
	  <cfargument name="datasource"	type="string"	required="No" 	default="#session.DSN#">
	  	
		<cfset string="">
		<cfif isdefined("data.user.valid.chars") and len(trim(data.user.valid.chars))>
			<cfset validos = trim(data.user.valid.chars)>
			
			<cfloop condition="#len(validos)#">
				
					<cfset pos = FindNoCase('-',validos,1)>
					<cfif pos EQ 0> <cfbreak> </cfif>
					<cfif pos LE len(validos)-1>
					
						<cfset cod1 = Asc(Mid(validos, pos-1, 1))>		<cfset cod2 = Asc(Mid(validos, pos+1, 1))>
						<cfif (cod1 GTE 65 and cod1 LTE 90 and cod2 GTE 65 and cod2 LTE 90) or (cod1 GTE 97 and cod1 LTE 122 and cod2 GTE 97 and cod2 LTE 122)>
							<cfif  data.pass.valida.letras EQ 1>			<!---agrega letras--->
								<cfloop index="i" from="#cod1#" to="#cod2#" step="true">
									<cfset string = string & chr(i)>
								</cfloop>
								<cfset validos = RemoveChars(validos, pos-1, 3)>
							</cfif>
						<cfelseif cod1 GTE 48 and cod1 LTE 57 >
							<cfif  data.pass.valida.digitos EQ 1>			<!---agrega numeros--->
								<cfloop index="i" from="#cod1#" to="#cod2#">
									<cfset string = string & chr(i)>
								</cfloop>
								<cfset validos = RemoveChars(validos, pos-1, 3)>
							</cfif>
						<cfelse>
							<cfif  data.pass.valida.simbolos EQ 1>			<!---agrega simbolos--->
								<cfloop index="i" from="#cod1#" to="#cod2#">
									<cfset string = string & chr(i)>
								</cfloop>
								<cfset validos = RemoveChars(validos, pos-1, 3)>
							</cfif>
						</cfif>
						
					<cfelse>
						<cfbreak>
					</cfif>
			</cfloop>
			<cfif trim(len(validos)) and data.pass.valida.simbolos EQ 1>
				<cfset string = string & validos>
			</cfif>
		</cfif>
	  	
		<cfreturn string>
	</cffunction>
	
	<cffunction name="Validaciones_varias" output="false" returntype="boolean" access="remote">
	  <cfargument name="clave" 		type="string"	required="Yes">							<!---clave a validar--->
	  <cfargument name="login" 		type="string"	required="No" default="">				<!---login--->
	  <cfargument name="LGnumero" 	type="numeric"	required="No" default="-1">				<!---id del login--->
	  <cfargument name="data" 		type="struct"	required="Yes">							<!---Structura que contiene las politicas del portal sobre las contraseñas, (retornada por component="home.Componentes.Politicas" method="trae_parametros_cuenta")--->
	  <cfargument name="datasource"	type="string"	required="No" 	default="#session.DSN#"><!---datasource--->
	
		<cfif Arguments.LGnumero EQ -1 and not len(trim(Arguments.login))>
			<cfthrow message="Atención: el componente que valida passwords en el metodo 'Validaciones_varias' necesita ya sea el login o el id del login">
		</cfif>
	
		<cfset repetidos = data.pass.valida.lista>		
		<cfset novalida= true>
		
		<cfif Arguments.LGnumero NEQ -1>
			<cfif len(trim(clave)) and len(trim(data.pass.valida.lista))>				<!---Evitar que se repitan las últimas n contraseñas--->
				<cfquery name="rsUltimosLogines" datasource="#Arguments.datasource#">
					select distinct  Top #repetidos# BLpasswordHash
					from ISBbitacoraLogin
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					order by BLfecha
				</cfquery>
				<cfset claveHash = Hash(Arguments.LGnumero &'-'& clave)>
				<cfloop query="rsUltimosLogines">
					<cfif claveHash EQ rsUltimosLogines.BLpasswordHash>
						<cfset clave="">
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfif len(trim(clave)) and len(trim(data.pass.valida.diccionario))>			<!---Validar contra diccionario--->
			<cfquery name="rsDiccionario" datasource="asp">
				select count(1) as existe
				from PalabrasComunes
				where upper(palabra)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(clave)#">
			</cfquery>
			<cfif rsDiccionario.existe GT 0>
				<cfset clave="">
			</cfif>
		</cfif>
		
		<cfif Arguments.LGnumero NEQ -1>
			<cfif len(trim(clave)) and len(trim(data.pass.valida.usuario))>				<!---Validar contra usuario ATENCION: existe una funcion que ya valida esto(DPA) en los componentes de home, revisar para ver si nos sirve y si sirve, reemplazar este codigo por la función--->
				<cfquery name="rsUsuario" datasource="#Arguments.datasource#">
					select count(1) as existe
					from ISBlogin
					where  ltrim(rtrim(upper(LGlogin)))like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ucase(clave))#%">
					and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				</cfquery>
				<cfif rsUsuario.existe GT 0>
					<cfset clave="">
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="rsLogin" datasource="#Arguments.datasource#">
				select ltrim(rtrim(upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">))) as log
			</cfquery>
			<cfquery name="rsUsuario" dbtype="query">
				select count(1) as existe 
				from rsLogin
				where log like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(Arguments.login))#%">
			</cfquery>
			<cfif rsUsuario.existe GT 0>
				<cfset clave="">
			</cfif>
		</cfif>
		
		<cfif len(trim(clave))>
			<cfset novalida= false>
		</cfif>
		
		<cfreturn novalida>
	</cffunction>

	
	<cffunction name="Generar" output="false" returntype="string" access="remote">
	  <cfargument name="LGnumero" 	type="numeric"	required="Yes">
	  <cfargument name="CEcodigo" 	type="string"	required="No" 	default="#session.CEcodigo#">
	  <cfargument name="datasource"	type="string"	required="No" 	default="#session.DSN#">
	  
		<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data" CEcodigo="#Arguments.CEcodigo#"/>
		
		<cfinvoke component="saci.comp.random-password" method="Genera_String" returnvariable="string">
			<cfinvokeargument name="data" value="#data#">
		</cfinvoke>
		
		<cfif len(trim(string))>															<!---Si existe string de caracteres validos--->
			<cfset repetidos = data.pass.valida.lista>		
			<cfset clave="">
			<cfset novalida= true>
			<cfloop condition="#novalida#">													<!--- Mientras que no hay encontrado un password valido--->
			
				<cfinvoke component="saci.comp.random-password" method="__randomPassword" 	<!---Obtenter un random con los caracteres validos--->
					returnvariable="clave">
					<cfinvokeargument name="init" 		value="#data.pass.long.min#">
					<cfinvokeargument name="end" 		value="#data.pass.long.max#">
					<cfif len(trim(string))>
						<cfinvokeargument name="validChars" value="#string#">
					</cfif>
				</cfinvoke>
				
				<cfinvoke component="saci.comp.random-password" method="Validaciones_varias" 	<!--- retorna true si el nuevo password es valido o false de lo contrario--->
					returnvariable="valida">
					<cfinvokeargument name="clave" value="#clave#">
					<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
					<cfinvokeargument name="data" value="#data#">
				</cfinvoke>
				
				<cfif len(trim(valida))>
					<cfset novalida= false>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn clave>
	</cffunction>
	
	<cffunction name="__randomPassword" access="public" returntype="string" output="false">
		<cfargument name="init" 		type="numeric" required="yes">
		<cfargument name="end" 			type="numeric" required="yes">
		<cfargument name="validChars" 	type="string" required="no"default="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789">
		
		<cfset var SALT_DIGITS = Arguments.validChars.toCharArray()>
		<cfset size= RandRange(Arguments.init,Arguments.end)>
			
		<cfset ch = "">
		<cfloop from="1" to="#size#" index="n">
			<cfset ch = ch & SALT_DIGITS[Rand() * ArrayLen(SALT_DIGITS) + 1] >
		</cfloop>
	  		
		<cfreturn ch>
	</cffunction>
		
</cfcomponent>