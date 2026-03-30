<cfcomponent output="no">
	<cfset Fecha  = DateFormat(now(),'YYYYMMDD') >
	<cfset Hora  = TimeFormat(now(),'HHmmss') >

	<cfset Lvarbuffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 32768 ))>
	<cfset temporaryFileName = "">
	<cfset LvarVariable = "">
	<cfset newline = Chr(13) & Chr(10)>
	<cfset LvarLine = "">
	<cfset LvarFechaIni = createdate(year(now()), month(now()), day(now()))>
	<cflock name="QPconsecutivo#Session.Ecodigo#" timeout="3" type="exclusive">
		<cfquery name="newLista" datasource="#session.dsn#">
			select coalesce(max(Consecutivo),0) as Consecutivo
			from QPassListaConsecutivo
			where Ecodigo = #session.Ecodigo#
			  and BMfecha between #LvarFechaIni# and #now()#
		</cfquery>
		
		<cfif newLista.Consecutivo neq ''>
			<cfset Cons = newLista.Consecutivo + 1>
		<cfelse>
			<cfset Cons = 1>
		</cfif>
	
		<cfquery name="insertConsecutivo" datasource="#session.dsn#">
			insert into QPassListaConsecutivo 
			(
				Consecutivo, 
				Ecodigo, 
				BMfecha, 
				BMUsucodigo
			)
			values
			(
				#Cons#,
				#session.Ecodigo#,
				#now()#,
				#session.Usucodigo#
			)
		</cfquery>
	</cflock>
	<cfset consecutivo  = RepeatString("0", 5-len(trim(Cons)) ) & "#trim(Cons)#">
    <cfset Entidad = 'HSBC'>
	<cfset LvarArchivo = "#Entidad##Fecha##Hora##consecutivo#">

	<cffunction name="write_to_buffer" access="private" output="false">
		<cfargument name="contents" type="string" required="yes">
		<cfargument name="flush" type="boolean" default="no">
		<cfset Lvarbuffer.append(javacast("string",Arguments.contents))>
		<cfif Arguments.flush Or (Lvarbuffer.length() GE 28000)>
			<cffile action="append" file="#temporaryFileName#" output="#Lvarbuffer.toString()#" addnewline="no">
			<cfset Lvarbuffer.setLength(0)>
		</cfif>
	</cffunction>

	<cffunction name="fnGeneraArchivo" access="public" output="false" hint="Genera Archivos Planos para Conexion a Autopistas del Sol">
		<cfargument name="Empresa" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">
		<cfargument name="TipoLista" type="string" required="yes">
		<cfargument name="Argpath" 	type="string" required="yes">
	
		<cfset LvarExtension = "L#Arguments.TipoLista#">
		<cfif not DirectoryExists(Arguments.Argpath)>
			<!--- If true, crea el directorio. --->
			<cfdirectory action = "create" directory = "#Arguments.Argpath#" >
		</cfif>		

		<cfset temporaryFileName = Arguments.Argpath & "/#LvarArchivo#.#LvarExtension#">
	
		<cfset fnGeneraLista(Arguments.Empresa, '#Arguments.TipoLista#',Conexion)>
	</cffunction>	
	
	<cffunction name="fnGeneraLista" access="private" output="false" hint="Genera El Archivo de la Lista">
		<cfargument name="ArgEmpresa" 		type="numeric" required="yes">
		<cfargument name="ArgLista" 		type="string" required="yes">
		<cfargument name="Conexion" 		type="string" required="yes">
		
		<cfif #Arguments.ArgLista#	eq 'B'>	
			<cfquery name="rsListaTag" datasource="#Arguments.conexion#">
				select
					QPTPAN
				from QPassTag 
				where Ecodigo = #Arguments.ArgEmpresa# 
				and (QPTlista = '#Arguments.ArgLista#'
					or QPTlista is null)
			</cfquery>
		<cfelse>
			<cfquery name="rsListaTag" datasource="#Arguments.conexion#">
				select
					QPTPAN
				from QPassTag 
				where Ecodigo = #Arguments.ArgEmpresa# 
				and QPTlista = '#Arguments.ArgLista#'
			</cfquery>
		</cfif>
		<cfset fnprocesaLista(rsListaTag)>
		<cfset write_to_buffer("", true)>
	</cffunction>

	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsListaTag" type="query" required="yes">
		<!---Registro Encabezado --->
		<cfset ContadorRegistro  = "00001">
		<cfset LvarTipoRegistro = "00HSBC#Fecha##Hora##ContadorRegistro#"> 
		<cfset write_to_buffer(LvarTipoRegistro & newline, false)>
		<!---Registro Detalle --->
		        
		<cfloop query="rsListaTag">
			<cfset write_to_buffer("10#trim(QPTPAN)#" & RepeatString(" ", 20-len(trim(QPTPAN))) & newline, false)>
		</cfloop>
		<!---Registro Totalizador --->
		<cfset LvarTotalizador = "90"& RepeatString("0", 12-len(trim(rsListaTag.recordcount))) & "#trim(rsListaTag.recordcount)#" >
		<cfset write_to_buffer(LvarTotalizador & newline, false)>
	</cffunction>
</cfcomponent>

