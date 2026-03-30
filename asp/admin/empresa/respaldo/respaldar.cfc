<cfcomponent output="false" extends="ShellService">
	<cfset This.datasource = "">
	<cfset This.EcodigoSDC = 0>
	<cfset This.Ecodigo = 0>
	<cfset This.CEcodigo = 0>
	
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	
	<!---
		opciones del BCP:
		-T 512000 : Establece a 512000 el máximo exportado para un campo image/text
		-E : Obliga a usar el valor identity del archivo (bcp in solamente)
				La opción -E solamente se pone si hay campo identity
		-L 1000: Se detiene en el registro número 1000 (solamente pruebas)
	--->
	<cfset This.bcptool = Politicas.trae_parametro_global('respaldo.bcp.tool', 'c:\sybase\OCS-15_0\bin\bcp.exe')>
	<cfset This.ruta = Politicas.trae_parametro_global('respaldo.path', '/tmp')>
	<cfset This.dbserver = Politicas.trae_parametro_global('respaldo.bcp.server', 'MINISIF')>
	<cfset This.bcpopt = Politicas.trae_parametro_global('respaldo.bcp.opt', '-c -t$@!\t$@! -r$@!\r\n -T 512000')>
	<cfset This.bcpoptin = Politicas.trae_parametro_global('respaldo.bcp.in', '')>
	<cfset This.bcpoptout = Politicas.trae_parametro_global('respaldo.bcp.out', '')>
	<cfset This.bcpidentity = Politicas.trae_parametro_global('respaldo.bcp.id', '-E')>
	<cfset This.bcpurl = Politicas.trae_parametro_global('respaldo.bcp.user', '-Usa -Pasp128')>
	
	<cfset This.startTime = GetTickCount()>
	<cfset This.totalRows = 0>

<!--- activarEmpresa --->
<cffunction name="activarEmpresa" output="false" returntype="void" access="private">
	<cfargument name="motivo" type="string" required="yes">
	<cfargument name="activa" type="boolean" default="false">
	<cfquery datasource="asp">
		update Empresa
		set Eactiva = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.activa#">,
		EactivaMotivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.motivo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.EcodigoSDC#">
	</cfquery>
</cffunction>
<!---preparar_dirs--->
<cffunction name="preparar_dirs">
	<cftry><cfif DirectoryExists("#This.ruta#data/")>
		<cfdirectory action="delete" directory="#This.ruta#data/" recurse="yes">
		</cfif><cfcatch type="any"></cfcatch></cftry>
	<cftry><cfif DirectoryExists("#This.ruta#metadata/")>
		<cfdirectory action="delete" directory="#This.ruta#metadata/" recurse="yes">
		</cfif><cfcatch type="any"></cfcatch></cftry>
	<cftry><cfif not DirectoryExists("#This.ruta#data/")>
		<cfdirectory action="create" directory="#This.ruta#data/">
		</cfif><cfcatch type="any"></cfcatch></cftry>
	<cftry><cfif not DirectoryExists("#This.ruta#metadata/")>
		<cfdirectory action="create" directory="#This.ruta#metadata/">
		</cfif><cfcatch type="any"></cfcatch></cftry>

	<cfif not DirectoryExists("#This.ruta#data/")>
		<cfthrow message="No se puede crear el directorio #This.ruta#data/">
	</cfif>
	<cfif not DirectoryExists("#This.ruta#metadata/")>
		<cfthrow message="No se puede crear el directorio #This.ruta#metadata/">
	</cfif>
</cffunction>
<!--- preparar_respaldar --->
<cffunction name="preparar_respaldar" output="false" returntype="void" access="public">
	<cfset preparar_dirs()>
	<cfset This.logfile = This.ruta & 'respaldar.log'>
	<cffile action="write" file="#This.logfile#" output="Iniciando operación de respaldo #Now()#">
	<cffile action="write" file="#This.logfile#" output="datasource: #This.datasource#">
	<cffile action="write" file="#This.logfile#" output="Ecodigo: #This.Ecodigo#">
	<cffile action="write" file="#This.logfile#" output="ruta: #This.ruta#">
	<cfset activarEmpresa('Respaldo de información')>
	<cfset desconectar_usuarios()>
</cffunction>
<!--- preparar_borrar --->
<cffunction name="preparar_borrar" output="false" returntype="void" access="public">
	<cfset preparar_dirs()>
	<cfset This.logfile = This.ruta & 'borrar.log'>
	<cffile action="write" file="#This.logfile#" output="Iniciando operación de borrado #Now()#">
	<cffile action="write" file="#This.logfile#" output="datasource: #This.datasource#">
	<cffile action="write" file="#This.logfile#" output="Ecodigo: #This.Ecodigo#">
	<cffile action="write" file="#This.logfile#" output="ruta: #This.ruta#">
	<cfset activarEmpresa('Borrado de información')>
	<cfset desconectar_usuarios()>
</cffunction>
<!--- preparar_cargar --->
<cffunction name="preparar_cargar" output="false" returntype="void" access="public">
	<cfset preparar_dirs()>
	<cfset This.logfile = This.ruta & 'cargar.log'>
	<cfset deszipear()>
	<cffile action="write" file="#This.logfile#" output="Iniciando operación de carga #Now()#">
	<cffile action="write" file="#This.logfile#" output="datasource: #This.datasource#">
	<cffile action="write" file="#This.logfile#" output="Ecodigo: #This.Ecodigo#">
	<cffile action="write" file="#This.logfile#" output="ruta: #This.ruta#">
	<cfset activarEmpresa('Carga de respaldo')>
	<cfset desconectar_usuarios()>
</cffunction>
<!--- terminar_respaldo --->
<cffunction name="terminar_respaldo" output="false" returntype="void" access="public">
	<cffile action="append" file="#This.logfile#" output="Respaldo terminado #Now()#">
	<cfset zipear()>
	<cfif DirectoryExists(This.ruta)>
		<cfdirectory action="delete" recurse="yes" directory="#This.ruta#">
		<!--- No puede haber más appends a #This.logfile# a partir de aquí --->
	</cfif>
	<cfset activarEmpresa('Respaldo terminado')>
</cffunction>
<!--- terminar_borrado --->
<cffunction name="terminar_borrado" output="false" returntype="void" access="public">
	<cffile action="append" file="#This.logfile#" output="Borrado terminado #Now()#">
	<cfset activarEmpresa('Borrado terminado')>
</cffunction>
<!--- terminar_carga --->
<cffunction name="terminar_carga" output="false" returntype="void" access="public">
	<cffile action="append" file="#This.logfile#" output="Carga terminada #Now()#">
	<cfif DirectoryExists(This.ruta)>
		<cfdirectory action="delete" recurse="yes" directory="#This.ruta#">
		<!--- No puede haber más appends a #This.logfile# a partir de aquí --->
	</cfif>
	<cfset activarEmpresa('Carga terminada')>
</cffunction>
<!--- respaldar_tabla --->
<cffunction name="respaldar_tabla" output="false" returntype="void" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<cfset var action = ''>
	<cfset var errorline = ''>
	<cfset var stack = ''>
	<cftry>
		<cfif generar_metadato (tabla, join, modo)>
			<cfset crear_vista (tabla, join, modo)>
			<cfset hacer_bcp_out (tabla)>
			<cfset destruir_vista (tabla)>
		</cfif>
	<cfcatch type="any">
		<cfloop to="1" from="#ArrayLen(cfcatch.TagContext)#" index="i" step="-1">
			<cfset errorline = GetFileFromPath(cfcatch.TagContext[i].Template) & ':' & cfcatch.TagContext[i].Line>
			<cfset stack = ' ' & errorline & stack>
		</cfloop>
		<cffile action="append" file="#This.logfile#" output="Error en #tabla# (#modo#): #cfcatch.Message# #cfcatch.Detail#">
		<cffile action="append" file="#This.logfile#" output="#DateFormat(Now(),'yyyy-mm-dd')# #TimeFormat(Now(), 'hh:mm:ss')# at #stack#">
	</cfcatch>
	</cftry>
</cffunction>
<!--- cargar_tabla --->
<cffunction name="cargar_tabla" output="false" returntype="void" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<cfset var action = ''>
	<cfset var errorline = ''>
	<cfset var stack = ''>
	<cftry>
		<cfset hacer_bcp_in (tabla)>
	<cfcatch type="any">
		<cfloop to="1" from="#ArrayLen(cfcatch.TagContext)#" index="i" step="-1">
			<cfset errorline = GetFileFromPath(cfcatch.TagContext[i].Template) & ':' & cfcatch.TagContext[i].Line>
			<cfset stack = ' ' & errorline & stack>
		</cfloop>
		<cffile action="append" file="#This.logfile#" output="Error en #tabla#: #cfcatch.Message# #cfcatch.Detail#">
		<cffile action="append" file="#This.logfile#" output="#DateFormat(Now(),'yyyy-mm-dd')# #TimeFormat(Now(), 'hh:mm:ss')# at #stack#">
	</cfcatch>
	</cftry>
</cffunction>
<!--- generar_metadato --->
<cffunction name="generar_metadato" output="false" returntype="boolean" access="private">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	
	<cfquery datasource="#This.datasource#" name="cols">
		exec sp_columns <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#"	>
	</cfquery>
	<cfif cols.RecordCount is 0>
		<cffile action="append" file="#This.logfile#" output="#tabla##RepeatString(' ', 31-Len(tabla))# no existe">
	<cfelseif (Len(Arguments.join) or
		( Modo is 'emp' and ListFind(ValueList(cols.column_name), 'Ecodigo')) or
		( Modo is 'ce' and ListFind(ValueList(cols.column_name), 'CEcodigo')))>
		<cfif tiene_datos (tabla, join, modo)>
			<cfsavecontent variable="tablemd">
				<cfoutput><?xml version="1.0"?>
				<table>
					<table_name># XMLFormat( Arguments.tabla )#</table_name>
					<sp_columns>
					<cfloop query="cols">
						<column>
							<column_name>#XMLFormat(cols.column_name)#</column_name>
							<type_name>#XMLFormat(cols.type_name)#</type_name>
							<precision>#XMLFormat(cols.precision)#</precision>
							<length>#XMLFormat(cols.length)#</length>
							<scale>#XMLFormat(cols.scale)#</scale>
							<nullable>#XMLFormat(cols.nullable)#</nullable>
						</column>
					</cfloop>
					</sp_columns>
				</table></cfoutput>
			</cfsavecontent>
			<cfset tablemd = Replace(tablemd, Chr(9), '', 'all')>
			<cffile file="#This.ruta#metadata/#tabla#.metadata.xml" action="write" output="#tablemd#">
			<cfreturn TRUE><!--- SI SE PONE FALSE, NO RESPALDA NUNCA NADA --->
		<cfelse>
			<cffile action="append" file="#This.logfile#" output="#tabla##RepeatString(' ', 31-Len(tabla))# no tiene datos">
		</cfif>
	<cfelse>
		<cfif TRUE><!--- FALSE = NO HAGA NADA, POR SI DURA MUCHO. --->
			<!--- solo sybase.  buscar si tiene padres con Ecodigo --->
			<cfset ancestros = ''>
			<cfset ancestros_msg = ''>
			<cfloop from="1" to="3" index="nivel">
				<cfset ancestro_q = QueryAncestros(tabla, nivel, ancestros, 'Ecodigo,CEcodigo')>
				<cfif ancestro_q.RecordCount>
					<cfset ancestros_msg = ListAppend(ancestros_msg, '@' & nivel)>
					<cfset ancestros_msg = ancestros_msg & ValueList(ancestros_q.JOIN_CLAUSE, ';')>
					<cfset ancestros = ListAppend(ancestros, ValueList(ancestro_q.name))>
				</cfif>
			</cfloop>
			<cfif Len(ancestros_msg) is 0>
				<cfset ancestros_msg = 'ninguno'>
			</cfif>
			<cffile action="append" file="#This.logfile#" output="#tabla##RepeatString(' ', 31-Len(tabla))# no tiene Ecodigo. #Trim(ancestros_msg)#">
		<cfelse>
			<cffile action="append" file="#This.logfile#" output="#tabla##RepeatString(' ', 31-Len(tabla))# no tiene Ecodigo">
		</cfif>
	</cfif>
	<cfreturn false>
</cffunction>
<!--- crear_vista --->
<cffunction name="crear_vista" output="false" returntype="void" access="private">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	
	<cfset destruir_vista (tabla) >
	<!--- sintaxis de sybase solamente --->
	<!---
	<cffile action="append" file="#This.logfile#" output="create view #calc_vista(Arguments.tabla)# as select #tabla#.* from #tabla# #join# where Ecodigo = #This.Ecodigo#">
	--->
	<cfquery datasource="#This.datasource#">
		create view #calc_vista(Arguments.tabla)#
		as select #tabla#.* from #tabla# #join#
		<cfif modo is 'emp'>
		where Ecodigo = #This.Ecodigo#
		<cfelseif modo is 'ce'>
		where CEcodigo = #This.CEcodigo#
		<cfelse>
			<cfthrow message="Modo inválido: #modo#">
		</cfif>
	</cfquery>
</cffunction>
<!--- anular_referencias --->
<cffunction name="anular_referencias" output="false" returntype="numeric" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<cfargument name="anular" type="string" required="yes">
	<!--- poner referencias en NULL a otras tablas --->
	<cfif Len(anular)>
		<cfset anularArray = ListToArray(anular)>
		<cfquery datasource="#This.datasource#" name="actualizados">
			update #tabla#
			<cfloop from="1" to="#ArrayLen(anularArray)#" index="anularIndex">
				#IIF(anularIndex is 1, "'SET'", "','")# #anularArray[anularIndex]# = NULL
			</cfloop>
			<cfif Len(join)>
			from #tabla# #join# </cfif>
			<cfif modo is 'emp'>where Ecodigo = #This.Ecodigo#
			<cfelseif modo is 'ce'>where CEcodigo = #This.CEcodigo#
			<cfelse><cfthrow message="Modo inválido: #modo#">
			</cfif>
			AND (
			<cfloop from="1" to="#ArrayLen(anularArray)#" index="anularIndex">
				#IIF(anularIndex GT 1, "'OR'", "''")# #anularArray[anularIndex]# IS NOT NULL
			</cfloop> )
			select @@rowcount as cant
		</cfquery>
		<cfreturn actualizados.cant>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
<!--- borrar_datos --->
<cffunction name="borrar_datos" output="false" returntype="numeric" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<cffile action="append" file="#This.logfile#" output="borrando #Arguments.tabla#">
	<cftry>
		<cfset total_borrados = 0>
		<cfset dependientes_q = QueryAncestros(tabla, -1, '', '')>
		<cfloop condition="true">
			<cfquery datasource="#This.datasource#" name="borrados">
				set rowcount 10000
				delete from #tabla#<cfif Len(join)>
				from #tabla# #join# </cfif>
				<cfif modo is 'emp'>where Ecodigo = #This.Ecodigo#
				<cfelseif modo is 'ce'>where CEcodigo = #This.CEcodigo#
				<cfelse><cfthrow message="Modo inválido: #modo#">
				</cfif>
				<cfloop query="dependientes_q" endrow="20">
				and not exists (
					select 1 # 
						REReplace( REReplace( JOIN_CLAUSE, 
							'JOIN ', 'FROM ', 'one'),
							' ON ', ' WHERE ', 'one')# )
				</cfloop>
				select @@rowcount as cant
				set rowcount 0
			</cfquery>
			<cfif borrados.cant is 0>
				<cfbreak>
			</cfif>
			<cfset total_borrados = total_borrados + borrados.cant>
			<cffile action="append" file="#This.logfile#" output="borrado  #Arguments.tabla# (#borrados.cant# registros)">
		</cfloop>
		<cfif total_borrados GT 10000>
			<cffile action="append" file="#This.logfile#" output="TOTAL    #Arguments.tabla# #total_borrados# registros borrados">
		</cfif>
		<cfreturn total_borrados>
	<cfcatch type="database">
		<cffile action="append" file="#This.logfile#" output="oops! #cfcatch.Message# #cfcatch.Detail#">
		<cfrethrow>
	</cfcatch></cftry>
</cffunction>
<!--- hacer_bcp_out --->
<cffunction name="hacer_bcp_out" output="true" returntype="void" access="private">
	<cfargument name="tabla" type="string" required="yes">
	
	<cffile action="append" file="#This.logfile#" output="">
	<cffile action="append" file="#This.logfile#" output="# RepeatString('=', 9+Len(Arguments.tabla))#">
	<cffile action="append" file="#This.logfile#" output=" Tabla: #Arguments.tabla# ">
	<cffile action="append" file="#This.logfile#" output="# RepeatString('=', 9+Len(Arguments.tabla))#">
	<cfif FileExists("#This.ruta#data/#tabla#.txt")>
		<cffile action="delete" file="#This.ruta#data/#tabla#.txt">
	</cfif>
	<cfset cmd = This.bcptool &
			' #Application.dsinfo[This.datasource].schema#..#calc_vista(Arguments.tabla)# out #This.ruta#data/#tabla#.txt ' &
			' #This.bcpopt# #This.bcpoptout# #This.bcpurl# -S#This.dbserver#'>

	<cffile action="append" file="#This.logfile#" output="#cmd#">
	<cfset shellExecute (cmd)>
	<cfif Len(This.stdout)>
		<cffile action="append" file="#This.logfile#" output="#This.stdout#">
		<cfset rowcount = REFind('\d+ rows copied', This.stdout)>
		<cfif Len(rowcount)>
			<cfset This.totalRows = This.totalRows + ListFirst(rowcount, ' ')>
		</cfif>
	</cfif>
	<cfif Len(This.stderr)>
		<cffile action="append" file="#This.logfile#" output="#This.stderr#">
	</cfif>
	<cfif Not FileExists("#This.ruta#data/#tabla#.txt")>
		<cffile action="append" file="#This.logfile#" output="Archivo #tabla#.txt no generado">
	<cfelse>
		<cfdirectory directory="#This.ruta#data/" filter="#tabla#.txt" name="buscar">
		<cffile action="append" file="#This.logfile#" output="Archivo generado: #buscar.size# bytes">
	</cfif>
	<cfset dump(Arguments.tabla)>
</cffunction>
<!--- hacer_bcp_in --->
<cffunction name="hacer_bcp_in" output="true" returntype="void" access="private">
	<cfargument name="tabla" type="string" required="yes">
	
	<cffile action="append" file="#This.logfile#" output="">
	<cffile action="append" file="#This.logfile#" output="# RepeatString('=', 9+Len(Arguments.tabla))#">
	<cffile action="append" file="#This.logfile#" output=" Tabla: #Arguments.tabla# ">
	<cffile action="append" file="#This.logfile#" output="# RepeatString('=', 9+Len(Arguments.tabla))#">
	<cfif Not FileExists("#This.ruta#data/#tabla#.txt")>
		<cffile action="append" file="#This.logfile#" output="Archivo #tabla#.txt no existe">
		<cfreturn>
	</cfif>
	<cfdirectory directory="#This.ruta#data/" filter="#tabla#.txt" name="buscar">
	<cffile action="append" file="#This.logfile#" output="Archivo #tabla#.txt: #buscar.size# bytes">
	<cfif tiene_identity(tabla)>
		<cfset extra = This.bcpidentity>
	<cfelse>
		<cfset extra = ''>
	</cfif>
	<cfset cmd = This.bcptool &
			' #Application.dsinfo[This.datasource].schema#..#Arguments.tabla# in #This.ruta#data/#tabla#.txt ' &
			' #This.bcpopt# #This.bcpoptin# #extra# #This.bcpurl# -S#This.dbserver#'>

	<cffile action="append" file="#This.logfile#" output="#cmd#">
	<cfset shellExecute (cmd)>
	<cfif Len(This.stdout)>
		<cffile action="append" file="#This.logfile#" output="#This.stdout#">
	</cfif>
	<cfif Len(This.stderr)>
		<cffile action="append" file="#This.logfile#" output="#This.stderr#">
	</cfif>
	<cfset dump(Arguments.tabla)>
</cffunction>
<!--- tiene_datos --->
<cffunction name="tiene_datos" output="false" returntype="boolean" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<!--- Verificar si hay datos, si no no se hace el bcp --->
	<cfquery datasource="#This.datasource#" name="ver_si_hay_q" maxrows="1">
		select top 1 1
		from #tabla# #join# 
		<cfif modo is 'emp'>
		where Ecodigo = #This.Ecodigo#
		<cfelseif modo is 'ce'>
		where CEcodigo = #This.CEcodigo#
		<cfelse><cfthrow message="Modo inválido: #modo#">
		</cfif>
	</cfquery>
	<cfreturn ver_si_hay_q.RecordCount GT 0>
	<cfreturn true>
</cffunction>
<!--- contar_datos --->
<cffunction name="contar_datos" output="false" returntype="numeric" access="public">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="join" type="string" required="yes">
	<cfargument name="modo" type="string" required="yes">
	<!--- Verificar si hay datos, si no no se hace el bcp --->
	<cfquery datasource="#This.datasource#" name="contar_datos_q">
		select count(1) as cnt
		from #tabla# #join# 
		<cfif modo is 'emp'>
		where Ecodigo = #This.Ecodigo#
		<cfelseif modo is 'ce'>
		where CEcodigo = #This.CEcodigo#
		<cfelse><cfthrow message="Modo inválido: #modo#">
		</cfif>
	</cfquery>
	<cfreturn contar_datos_q.cnt>
	<cfreturn true>
</cffunction>
<!--- destruir_vista --->
<cffunction name="destruir_vista" output="false" returntype="void" access="private">
	<cfargument name="tabla" type="string" required="yes">

	<!--- sintaxis de sybase solamente --->
	<cfquery datasource="#This.datasource#">
		if object_id('#calc_vista(Arguments.tabla)#') is not null
			drop view #calc_vista(Arguments.tabla)#
	</cfquery>
</cffunction>
<!--- calc_vista --->
<cffunction name="calc_vista" output="false" returntype="string" access="private">
	<cfargument name="tabla" type="string" required="yes">
	<cfreturn 'bkv_' & Left(Arguments.tabla, 26)>
</cffunction>
<!--- QueryAncestros --->
<cffunction name="QueryAncestros" returntype="query" output="false">
	<cfargument name="tabla" type="string" required="yes">
	<cfargument name="nivel" type="numeric" required="yes">
	<cfargument name="excluir" type="string" default="">
	<cfargument name="buscarColumnas" type="string" default="">
	
	<cfif nivel is 0><cfthrow message="Nivel no debe ser 0"></cfif>
	<cfset tableid = IIF(nivel GT 0, DE('tableid'), DE('reftabid'))>
	<cfset reftabid = IIF(nivel GT 0, DE('reftabid'), DE('tableid'))>
	<cfset fokey = IIF(nivel GT 0, DE('fokey'), DE('refkey'))>
	<cfset refkey = IIF(nivel GT 0, DE('refkey'), DE('fokey'))>
	<cfset nivel = Abs(nivel)>
	<cfquery datasource="#This.datasource#" name="QueryAncestros_Q">
		select distinct 
		<cfloop from="1" to="#nivel#" index="niv2">
			<cfif niv2 gt 1> + </cfif>
			' JOIN ' + object_name ( r#niv2#.#reftabid# ) + ' t#niv2# ON '
			<cfloop from="1" to="16" index="colid">
				+ case when r#niv2#.#fokey##colid# !=0 and r#niv2#.#refkey##colid# !=0 then
					<cfif colid GT 1>' AND ' + </cfif>
					<cfif niv2 is 1>
					object_name ( r#niv2#.#tableid# ) <cfelse> 't#niv2-1#'</cfif> + '.' +
					col_name( r#niv2#.#tableid#, r#niv2#.#fokey##colid# ) + ' = ' + 
					't#niv2#.' +
					col_name( r#niv2#.#reftabid#, r#niv2#.#refkey##colid# )
				else NULL end
			</cfloop>
		</cfloop>
				as JOIN_CLAUSE
		<cfif Len(buscarColumnas)>, c.name as colname</cfif>
		<cfloop from="1" to="#nivel#" index="niv2">
			, object_name ( r#niv2#.#reftabid# ) as table#niv2#
		</cfloop>
		from
			<cfloop from="1" to="#nivel#" index="niv2">sysreferences r#niv2#, </cfloop>
			sysobjects o<cfif Len(buscarColumnas)>, syscolumns c</cfif>
		where r1.pmrydbname is NULL
		  and r1.frgndbname is NULL
		  and r1.#tableid# = object_id (<cfqueryparam cfsqltype="cf_sql_varchar" value="#tabla#">)
		<cfif nivel GT 1><cfloop from="1" to="#nivel - 1#" index="niv2">
		  and r#niv2#.#reftabid# = r#niv2+1#.#tableid#
		  and r#niv2#.pmrydbname is NULL
		  and r#niv2#.frgndbname is NULL
		</cfloop></cfif>
		  and r#nivel#.#reftabid# = o.id
		  <cfif Len(buscarColumnas)>
		  and c.id = o.id
		  and c.name in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#buscarColumnas#" list="yes">)
		  </cfif>
		  <cfif Len(excluir)>
		  and o.name not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#excluir#" list="yes">)
		  </cfif>
		order by upper(o.name), r#nivel#.#fokey#1
	</cfquery>
	<cfreturn QueryAncestros_Q>
</cffunction>
<!--- tabla_existe --->
<cffunction name="tabla_existe" output="false" returntype="boolean">
	<cfargument name="tabla" type="string" required="yes">

	<cfquery datasource="#This.datasource#" name="tabla_existe_q">
		select object_id (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">) as oid
	</cfquery>
	<cfreturn Len(tabla_existe_q.oid) GT 0>
</cffunction>
<!--- tiene_identity --->
<cffunction name="tiene_identity" output="false" returntype="boolean">
	<cfargument name="tabla" type="string" required="yes">
	<cfquery datasource="#This.datasource#" name="campo_identity">
		select name
		from syscolumns
		where id = object_id ('Empresa')
		  and status & 0x80 != 0
	</cfquery>
	<cfreturn campo_identity.RecordCount NEQ 0>
</cffunction>
<!--- guardar_info --->
<cffunction name="guardar_info" output="false" returntype="void">
	<cfargument name="REobservaciones" type="string" required="yes">
	
	<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>
	<cfquery datasource="asp">
		insert into RespaldoEmpresa (
			Ecodigo, CEcodigo, REfecha, REhost,
			REusuario, REduracion, RErows, REfullpath,
			REobservaciones)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#This.EcodigoSDC#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#This.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#(GetTickCount() - This.startTime) / 1000#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#This.totalRows#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.ruta#">,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.REobservaciones#">
		)
	</cfquery>
</cffunction>
<!---zipear--->
<cffunction name="zipear" output="false" access="private" returntype="void">
	<!--- se requiere GNU tar para usar la opción -z --->
	<cfset dirname = REReplace(This.ruta, '[\\/]+$', '')>
	<cfinvoke component="asp.parches.comp.jar" method="jar"
		zipfile="#dirname#.zip" fullpath="#dirname#"/>
	<cffile action="append" file="#This.logfile#" output="zipear: #dirname#.zip">
</cffunction>
<!---deszipear--->
<cffunction name="deszipear" output="false" access="private" returntype="void">
	<!--- se requiere GNU tar para usar la opción -z --->
	<cfset dirname = REReplace(This.ruta, '[\\/]+$', '')>
	<cfset pathname = GetDirectoryFromPath( dirname ) >
	<cfif Not FileExists('#dirname#.zip')>
		<cfthrow message="Archivo no existe: #dirname#.zip">
	</cfif>
	<cfif Not DirectoryExists(dirname)>
		<cfdirectory action="create" directory="#dirname#">
	</cfif>
	<cfinvoke component="asp.parches.comp.jar" method="unjar"
		jarfile="#dirname#.zip" destdir="#dirname#"/>
	<cffile action="append" file="#This.logfile#" output="deszipear: #dirname#.zip">
</cffunction>
<!--- desconectar_usuarios --->
<cffunction name="desconectar_usuarios" output="false" access="private" returntype="void">
	<cfset duracion_default = Politicas.trae_parametro_global("sesion.duracion.default")>
	<cfset duracion_modo = Politicas.trae_parametro_global("sesion.duracion.modo")>
	<cfquery datasource="aspmonitor" name="usuarios_conectados_q">
		select sessionid, srvprocid
		from MonProcesos mp
		where mp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.EcodigoSDC#">
		and mp.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.CEcodigo#">
		and mp.cerrada = 0
		and mp.<cfif duracion_modo is '1'>desde<cfelse>acceso</cfif>
			>= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', -duracion_default, Now())#">
	</cfquery>
	<cfloop query="usuarios_conectados_q">
		<cfinvoke component="home.Componentes.aspmonitor" method="MonitoreoLogout"
			reason="K" sessionid="#sessionid#" srvprocid="#srvprocid#" />
	</cfloop>
</cffunction>
</cfcomponent>