<cfcomponent output="no">
	<cfset GvarTS = getTickCount()>
	<cffunction name="start" output="false" returntype="void" access="public">
		<cfargument name="tipo"		type="string"	required="yes">

		<cfset LvarErr = expandPath("/mig/operacion/#Arguments.tipo#_err.txt")>
		<cfset LvarErrD = expandPath("/mig/operacion/Dimensiones_err.txt")>
		<cflock name="mig_prcs" throwontimeout="yes" timeout="5">
			<cfif isdefined("application.mig_prcs")>
				<cfthrow message="Existe un proceso de carga en ejecución...">
			</cfif>
			<cfif Arguments.Tipo NEQ "Dimensiones" AND fileexists(LvarErrD)>
				<cfthrow message="Existen Errores en la carga de dimensiones que deben ser corregidos">
			</cfif>

			<cfif fileexists(LvarErr)>
				<cffile action="delete" file="#LvarErr#">
			</cfif>
			<cfset Application.mig_prcs = structNew()>
			<cfset Application.mig_prcs.Inicio	= now()>
			<cfset Application.mig_prcs.Activ	= now()>
			<cfset Application.mig_prcs.Tipo	= Arguments.Tipo>
			<cfset Application.mig_prcs.subTipos= arrayNew(1)>
			<cfset Application.mig_prcs.stN		= 0>
			<cfset Application.mig_prcs.Err		= LvarErr>
			<cfset Application.mig_prcs.TS		= GvarTS>
		</cflock>
	</cffunction>

	<cffunction name="end" output="false" returntype="void" access="public">
		<cflock name="mig_prcs" throwontimeout="yes" timeout="5">
			<cfif NOT isdefined("application.mig_prcs")>
				<cfthrow message="No existe ningún proceso de carga en ejecución...">
			</cfif>

			<cfset LvarHtml = expandPath("/mig/operacion/#Application.mig_prcs.Tipo#.html")>
			<cffile action="write" file="#LvarHtml#" output="#sbPintarResultado(true)#">
			<cfset Application.mig_prcs = structNew()>
			<cfset structDelete(Application,"mig_prcs")>
		</cflock>
	</cffunction>
	
	<cffunction name="cancel" output="false" returntype="void" access="public">
		<cflock name="mig_prcs" throwontimeout="yes" timeout="5">
			<cfif NOT isdefined("application.mig_prcs")>
				<cfthrow message="No existe ningún proceso de carga en ejecución...">
			</cfif>

			<cffile action="append" file="#Application.mig_prcs.Err#" output="Proceso de Carga Cancelado por #session.Usulogin#, #DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:MM:SS")#" addnewline="yes">

			<cfset Application.mig_prcs = structNew()>
			<cfset structDelete(Application,"mig_prcs")>
		</cflock>
	</cffunction>
	
	<cffunction name="toCube" output="false" returntype="string" access="public">
		<cfargument name="query"		type="query"	required="yes">
		<cfargument name="tipo"			type="string"	required="yes">
		<cfargument name="subTipo"		type="string"	required="yes">
		<cfargument name="table"		type="string"	required="yes">
		<cfargument name="PK"			type="string"	required="yes">
		<cfargument name="codigos"		type="string"	required="yes">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">

		<cfargument name="table_ori"		type="string"	default="">
		<cfargument name="PK_ori"			type="string"	default="">
		
		<cfset rsDATOS = Arguments.query>
		<cfif Arguments.tipo EQ "Dimensiones">
			<cfset LvarErrorEnc = "ERRORES AL CARGAR DATOS DE: Dimension='#Arguments.subTipo#', tabla='#Arguments.table#', dsn='#Arguments.dsn#'">
		<cfelse>
			<cfset LvarErrorEnc = "ERRORES AL CARGAR DATOS DE: Hechos='#Arguments.subTipo#', tabla='#Arguments.table#', dsn='#Arguments.dsn#'">
		</cfif>
		<cftry>
			<cfif NOT fnAvance(Arguments.Tipo, Arguments.subTipo, -1)>
				<cfreturn>
			</cfif>
	
			<cf_dbstruct name="#Arguments.table#" datasource="#Arguments.dsn#" returnVariable="rsStruct">
			<cfif rsStruct.recordCount EQ 0>
				<cfthrow message="Tabla #Arguments.Table# no esta definida">
			</cfif>

			<cfif Arguments.PK EQ "">
				<cfthrow message="Falta indicar columna PK">
			</cfif>
			
			<cfset LvarQCols = query.columnList>
			<cfif Arguments.PK EQ "">
				<cfthrow message="Falta indicar columna PK">
			</cfif>
			<cfset LvarPK	= listFindNoCase(LvarQCols,Arguments.PK)>
			<cfif LvarPK EQ 0>
				<cfthrow message="Falta columna PK='#Arguments.PK#' en query">
			</cfif>

			<cfif Arguments.tipo NEQ "Dimensiones">
				<cfif Arguments.PK_ori EQ "">
					<cfthrow message="Falta indicar columna PK_ori">
				</cfif>
				<cfset LvarPK_ori = listFindNoCase(LvarQCols,Arguments.PK_ori)>
				<cfif LvarPK_ori EQ 0>
					<cfthrow message="Falta columna PK_ori='#Arguments.PK_ori#' en query">
				</cfif>
			</cfif>
			
			<cfset LvarTCols = "">
			<cfset LvarSCols = arrayNew(1)>
			<cfset LvarPK = 0>
			<cfset LvarPK_ori = 0>
			<cfset LvarC = 0>
			<cfloop query="rsStruct">
				<cfif rsStruct.name EQ Arguments.PK>
					<cfset LvarPK = 1>
					<cfset LvarPK_cf_sql_type = rsStruct.cf_sql_type>
				<cfelse>
					<cfset LvarTCols = ListAppend(LvarTCols,rsStruct.name)>
					<cfset LvarC ++>
					<cfset LvarSCols[LvarC]				= structNew()>
					<cfset LvarSCols[LvarC].name		= rsStruct.name>
					<cfset LvarSCols[LvarC].cf_sql_type = rsStruct.cf_sql_type>
					<cfset LvarSCols[LvarC].decs 		= rsStruct.dec>
					<cfif not isnumeric(LvarSCols[LvarC].decs)>
						<cfset LvarSCols[LvarC].decs = "0">
					</cfif>
					<cfset LvarSCols[LvarC].mandatory	= rsStruct.mandatory>
				</cfif>
				<cfif not listFindNoCase(LvarQCols,rsStruct.name)>
					<cfthrow message="Falta columna en query: TABLA: #Arguments.table#, COL: #rsStruct.name#">
				</cfif>
			</cfloop>
			<cfif LvarPK EQ 0>
				<cfthrow message="Columna PK indicada '#Arguments.PK#' no pertenece a tabla '#Arguments.table#'">
			</cfif>

			<cfset LvarN = rsDATOS.recordCount>
			<cfset Application.mig_prcs.subTipos[stN].tots = LvarN>
			<cfloop query="rsDATOS">
				<cfif NOT fnAvance(Arguments.Tipo, Arguments.subTipo, rsDATOS.currentRow/LvarN)>
					<cfreturn>
				</cfif>
	
				<cfif evaluate("rsDATOS.#Arguments.PK#") EQ "" OR evaluate("rsDATOS.#Arguments.PK#") EQ "-1">
					<cftry>
						<cfquery datasource="#Arguments.dsn#">
							insert into #Arguments.table# (#LvarTCols#)
							values (
							<cfloop index="i" from="1" to="#arrayLen(LvarSCols)#">
								<cfset LvarValor = trim(evaluate("rsDATOS.#LvarSCols[i].name#"))>
								<cfset LvarCFsqlType = LvarSCols[i].cf_sql_type>
								<cfif i NEQ 1>
									,
								</cfif>
								<cfif LvarSCols[i].mandatory>
									<cfset LvarNull = false>
								<cfelse>
									<cfset LvarNull = (LvarValor EQ "")>
								</cfif>
								<cfif LvarCFsqlType EQ "cf_sql_numeric" AND LvarSCols[i].decs GT 0>
									<cfqueryparam cfsqltype="#LvarCFsqlType#" value="#LvarValor#" null="#LvarNULL#" scale="#LvarSCols[i].decs#">
								<cfelse>
									<cfqueryparam cfsqltype="#LvarCFsqlType#" value="#LvarValor#" null="#LvarNULL#">
								</cfif>
							</cfloop>
							)
						</cfquery>
						<cfset Application.mig_prcs.subTipos[stN].news ++>
					<cfcatch type="database">
						<cfset sbErrorDatos("INSERT", Arguments.PK, Arguments.codigos, "#cfcatch.Message# #cfcatch.Detail#")>
						<cfset Application.mig_prcs.subTipos[stN].errN ++>
					</cfcatch>
					</cftry>
				<cfelse>
					<cftry>
						<cfquery datasource="#Arguments.dsn#" timeout="1">
							update #Arguments.table#
							set
							<cfloop index="i" from="1" to="#arrayLen(LvarSCols)#">
								<cfset LvarValor = trim(evaluate("rsDATOS.#LvarSCols[i].name#"))>
								<cfset LvarCFsqlType = LvarSCols[i].cf_sql_type>
								<cfif i NEQ 1>
									,
								</cfif>
								#LvarSCols[i].name# = 
								<cfif LvarSCols[i].mandatory>
									<cfset LvarNull = false>
								<cfelse>
									<cfset LvarNull = (LvarValor EQ "")>
								</cfif>
								<cfif LvarCFsqlType EQ "cf_sql_numeric" AND LvarSCols[i].decs GT 0>
									<cfqueryparam cfsqltype="#LvarCFsqlType#" value="#LvarValor#" null="#LvarNULL#" scale="#LvarSCols[i].decs#">
								<cfelse>
									<cfqueryparam cfsqltype="#LvarCFsqlType#" value="#LvarValor#" null="#LvarNULL#">
								</cfif>
							</cfloop>
							where #Arguments.PK# = <cfqueryparam cfsqltype="#LvarPK_cf_sql_type#" value="#evaluate("rsDATOS.#Arguments.PK#")#">
						</cfquery>
						<cfset Application.mig_prcs.subTipos[stN].olds ++>
					<cfcatch type="database">
						<cfset sbErrorDatos("UPDATE", Arguments.PK, Arguments.codigos, "#cfcatch.Message# #cfcatch.Detail#")>
						<cfset Application.mig_prcs.subTipos[stN].errO ++>
					</cfcatch>
					<cfcatch type="any">
						<cfrethrow>
					</cfcatch>
					</cftry>
				</cfif>
				<cfif Arguments.tipo NEQ "Dimensiones">
					<cfquery datasource="#Arguments.dsn#" timeout="1">
						update #Arguments.table_ori#
						   set control = 4
						 where #Arguments.PK_ori# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("rsDATOS.#Arguments.PK_ori#")#">
					</cfquery>
				</cfif>
			</cfloop>
			<cfset fnAvance(Arguments.Tipo, Arguments.subTipo, 1)>
		<cfcatch type="any">
			<cfif isdefined("cfcatch.TagContext")>
				<cfset LvarError = cfcatch.TagContext[1].Template>
				<cfset LvarError = REReplace(mid(LvarError,find(expandPath("/"),LvarError),100),"[/\\]","/ ","ALL") & ": " & cfcatch.TagContext[1].Line>
			</cfif>
			<cffile action="append" file="#Application.mig_prcs.Err#" output="Proceso de Carga cancelado por un Error de Ejecución, #DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:MM:SS")#" addnewline="yes">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="#cfcatch.Message#: #cfcatch.Detail# #LvarError#" addnewline="yes">
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="sbErrorDatos" output="false" returntype="string" access="private">
		<cfargument name="tipo"			type="string"	required="yes">
		<cfargument name="PK"			type="string"	required="yes">
		<cfargument name="codigos"		type="string"	required="yes">
		<cfargument name="msg"		type="string"	required="yes">

		<cfif LvarErrorEnc NEQ "">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="" addnewline="yes">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="**********************************************************************************************" addnewline="yes">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="#LvarErrorEnc#" addnewline="yes">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="**********************************************************************************************" addnewline="yes">
			<cfset LvarErrorEnc = "">
		</cfif>
		<cfset LvarError = "#Arguments.tipo#: ">
		<cfif Arguments.tipo EQ "UPDATE">
			<cfset LvarError &= "#Arguments.PK#='#evaluate("rsDATOS.#Arguments.PK#")#', ">
		</cfif>
		<cfset LvarError &= "Códigos: ">
		<cfloop list="#Arguments.codigos#" index="LvarCol">
			<cfset LvarError &= "#LvarCol#='#evaluate("rsDATOS.#LvarCol#")#', ">
		</cfloop>
		<cfset LvarError &= "ERROR: #Arguments.msg#">
		<cffile action="append" file="#Application.mig_prcs.Err#" output="#LvarError#" addnewline="yes">
	</cffunction>
	
	<cffunction name="fnAvance" output="false" returntype="boolean" access="private">
		<cfargument name="tipo"		type="string"	required="yes">
		<cfargument name="subTipo"	type="string"	required="yes">
		<cfargument name="avance" 	type="numeric"	required="yes">

		<cflock name="mig_prcs" throwontimeout="yes" timeout="5">
			<cfif 	NOT isdefined("application.mig_prcs") OR 
					Application.mig_prcs.Tipo 	NEQ Arguments.Tipo OR
					Application.mig_prcs.TS		NEQ GvarTS
			>
				<cfreturn false>
			<cfelseif Arguments.Avance EQ -1>
				<cfset Application.mig_prcs.stN ++>
				<cfset stN = Application.mig_prcs.stN>
				<cfset Application.mig_prcs.subTipos[stN]= structNew()>
				<cfset Application.mig_prcs.subTipos[stN].name		= Arguments.subTipo>
				<cfset Application.mig_prcs.subTipos[stN].news		= 0>
				<cfset Application.mig_prcs.subTipos[stN].tots		= 0>
				<cfset Application.mig_prcs.subTipos[stN].olds		= 0>
				<cfset Application.mig_prcs.subTipos[stN].errN		= 0>
				<cfset Application.mig_prcs.subTipos[stN].errO		= 0>
				<cfset Application.mig_prcs.subTipos[stN].Avance	= 0>
			<cfelse>
				<cfset Application.mig_prcs.subTipos[Application.mig_prcs.stN].Avance = Arguments.Avance>
			</cfif>
			<cfset Application.mig_prcs.Activ = now()>
		</cflock>

		<cfreturn true>
	</cffunction>

	<cffunction name="DimensionPeriodo" output="false" returntype="void" access="public">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">
		
		<cfif NOT fnAvance("Dimensiones", "PERIODO", -1)>
			<cfreturn>
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.dsn#">
			select count(1) as cantidad
			  from D_PERIODO
		</cfquery>
		<cfif rsSQL.cantidad NEQ 11324>
			<cfquery datasource="#Arguments.dsn#">
				delete from D_PERIODO
			</cfquery>
			<cfif fileExists("#expandPath("/mig/operacion/D_PERIODO.xml")#")>
				<cffile action = "delete" file="#expandPath("/mig/operacion/D_PERIODO.xml")#">
			</cfif>
			<cfzip action = "unzip" destination = "#expandPath("/mig/operacion")#" file = "#expandPath("/mig/operacion/D_PERIODO.zip")#">

			<cfset sbGeneraXMLtoTabla(expandPath("/mig/operacion/D_PERIODO.xml"),"PERIODO",Arguments.dsn)>

			<cffile action = "delete" file="#expandPath("/mig/operacion/D_PERIODO.xml")#">
		<cfelse>
			<cfset Application.mig_prcs.subTipos[Application.mig_prcs.stN].tots = rsSQL.cantidad>
		</cfif>
		<cfset fnAvance("Dimensiones", "PERIODO", 1)>
	</cffunction>

<!---
	<cfset LvarOBJ=createObject("component", "mig.componentes.utils")>
	<cfset LvarOBJ.sbGeneraTablaToXML("D_PERIODO","","/mig/operacion/D_PERIODO.xml","ASP_KPI")>
--->
	<cffunction name="sbGeneraTablaToXML" access="public" output="no" returntype="void">
		<cfargument name="table" 		type="string" required="yes">
		<cfargument name="where" 		type="string" required="yes">
		<cfargument name="file" 		type="string" required="yes">
		<cfargument name="dsn" 			type="string" required="yes">
	
		<cfset LobjXML = "">
		<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "LobjXML">
		<cffile action="write" file="#Arguments.File#" output="">
	
		<cf_dbstruct name="#Arguments.table#" datasource="#Arguments.dsn#">
		<cfif rsStruct.recordCount EQ 0>
			<cfthrow message="Tabla #Arguments.table# no esta definida">
		</cfif>

		<cfset LvarCampos 	= valueList(rsStruct.name)>
		<cfset LvarCFtypes 	= valueList(rsStruct.cf_type)>
		<cfset LvarCrLn = chr(13) & chr(10)>

		<cfset LobjXML.append ('<tabledata name="#Arguments.Table#">').append(LvarCrLn)>
		<cfset LobjXML.append ('  <dbstruct>').append(LvarCrLn)>
		<cfloop query="rsStruct">
			<cfset LobjXML.append ('    <column name="#rsStruct.name#" type="#rsStruct.cf_type#" len="#rsStruct.len#" ent="#rsStruct.ent#" dec="#rsStruct.dec#" mandatory="#rsStruct.mandatory#"/>').append(LvarCrLn)>
		</cfloop>
		<cfset LobjXML.append ('  </dbstruct>').append(LvarCrLn)>

		<cfquery name="rsSQL" datasource="#Arguments.dsn#">
			select * from #Arguments.table#
			<cfif Arguments.Where NEQ "">
			 	#Arguments.where#
			</cfif>
		</cfquery>

		<cfset LobjXML.append ('  <resultset rows="#rsSQL.recordCount#">').append(LvarCrLn)>

		<cfloop query="rsSQL">
			<cfset LobjXML.append ('    <row>').append(LvarCrLn)>
			<cfset LvarPto = 0>
			<cfloop index="LvarCampo" list="#LvarCampos#">
				<cfset LvarPto = LvarPto + 1>
				<cfset LvarCFType = listGetAt(LvarCFtypes,LvarPto)>
				<cfset LvarValor  = rsSQL[LvarCampo]>
				<cfif LvarCFType EQ "B">
					<cfset LvarValor = ToBase64(LvarValor)>
				<cfelseif LvarCFType EQ "D">
					<cfset LvarValor = "#DateFormat(LvarValor,"YYYY-MM-DD")# #TimeFormat(LvarValor,"HH:mm:ss")#">
				<cfelseif LvarCFType NEQ "N">
					<cfset LvarValor = XMLformat(trim(LvarValor))>
				</cfif>
				<cfset LobjXML.append ('      <#LvarCampo#>#LvarValor#</#LvarCampo#>').append(LvarCrLn)>
			</cfloop>
			<cfset LobjXML.append ('    </row>').append(LvarCrLn)>
			<cffile action="append" file="#Arguments.File#" output="#LobjXML.toString()#">
			<cfset LobjXML.setLength (0)>
		</cfloop>
		<cfset LobjXML.append ('  </resultset>').append(LvarCrLn)>
		<cfset LobjXML.append ('</tabledata>').append(LvarCrLn)>
		<cffile action="append" file="#Arguments.File#" output="#LobjXML.toString()#">
	</cffunction>

	<cffunction name="sbGeneraXMLtoTabla" access="private" output="no">
		<cfargument name="file" 		type="string" required="yes">
		<cfargument name="dimension" 	type="string" required="yes">
		<cfargument name="dsn" 			type="string" required="yes">

		<cfset LvarFIL = createObject("java","java.io.File").init(Arguments.file)>
		<cfset LvarFR = createObject("java","java.io.FileReader").init(LvarFIL)>
		<cfset LvarBR = createObject("java","java.io.BufferedReader").init(LvarFR)>

		<cftry>
			<cfset LvarLLen	= 0>
			<cfset LvarN	= LvarFIL.length()>

			<cfset LvarLin = LvarBR.readLine()>
			<cfif NOT FIND("<tabledata ", LvarLin)>
				<cfthrow message="No se puede importar un XML que no sea tabledata">
			</cfif>
			<cfset LvarTable = replace(LvarLin, '<tabledata name="', "")>
			<cfset LvarTable = replace(LvarTable, '">', "")>
	
			<cf_dbstruct name="#LvarTable#" datasource="#Arguments.dsn#">
			<cfif rsStruct.recordCount EQ 0>
				<cfthrow message="Tabla #LvarTable# no esta definida">
			</cfif>
			<cfset LvarNames = "">
			<cfset LvarDBStruct = ArrayNew(2)>
			<cfset LvarDBStructI = 1>
			<cfloop query="rsStruct">
				<cfset LvarName = rsStruct.name>
				<cfif LvarName NEQ "ts_rversion">
					<cfif LvarDBStructI EQ 1>
						<cfset LvarNames = LvarName>
					<cfelse>
						<cfset LvarNames = LvarNames & ", " & LvarName>
					</cfif>
					<cfset LvarDBStruct[LvarDBStructI][1] = rsStruct.name>
					<cfset LvarDBStruct[LvarDBStructI][2] = rsStruct.cf_type>
					<cfset LvarDBStruct[LvarDBStructI][3] = rsStruct.cf_sql_type>
					<cfset LvarDBStructI = LvarDBStructI + 1>
				</cfif>
			</cfloop>
	
			<cfloop condition="isdefined('LvarLin') AND NOT find('<resultset ',LvarLin)">
				<cfset LvarLLen += len(LvarLin)+2>
				<cfset LvarLin = LvarBR.readLine()>
			</cfloop>
				
			<cfif isdefined('LvarLin') AND find('<resultset ',LvarLin)>
				<cfif Arguments.Dimension NEQ "">
					<cfset LvarRows = replace(LvarLin, '<resultset rows="', "")>
					<cfset LvarRows = replace(LvarRows, '">', "")>
					<cfset Application.mig_prcs.subTipos[Application.mig_prcs.stN].tots = LvarRows>
				</cfif>
				<cfset LvarLin = LvarBR.readLine()>
				<cfloop condition="isdefined('LvarLin') AND NOT find('</resultset>',LvarLin)">
					<cfset LvarConta = 0>
					<cfset LvarXMLtxt = "<subset>">
					<cfloop condition="isdefined('LvarLin') AND NOT find('</resultset>',LvarLin) AND LvarConta LTE 10">
						<cfset LvarXMLtxt &= LvarLin>
						<cfset LvarLLen += len(LvarLin)+2>
						<cfif find("</row>", LvarLin)>
							<cfset LvarConta ++>
						</cfif>
						<cfset LvarLin = LvarBR.readLine()>
					</cfloop>
					<cfset LvarXMLtxt &= "</subset>">
					<cfif LvarConta EQ 0>
						<cfbreak>
					</cfif>
	
					<cfset LvarXML = structNew()>
					<cfset LvarXML = XmlParse(LvarXMLtxt)>

					<cfloop index="i" from="1" to="#LvarConta#"> 
						<cfif Arguments.Dimension NEQ "" AND NOT fnAvance("Dimensiones", Arguments.dimension, LvarLLen/LvarN)>
							<cfreturn>
						</cfif>
						<cfset LvarXMLrow = LvarXML.subset.row[i]>
						<cfset LvarXMLrowVals = LvarXMLrow.XmlChildren>
						<cfquery datasource="#Arguments.dsn#">
							insert into #LvarTable# (#LvarNames#)
							values (
							<cfloop index="LvarDBStructI" from="1" to="#arrayLen(LvarDBStruct)#">
								<cfset LvarName = LvarDBStruct[LvarDBStructI][1]>
								<cfif i  EQ 1>
									<cfset LvarPos = XmlChildPos(LvarXMLrow,LvarName, 1)>
									<cfset LvarDBStruct[LvarDBStructI][4] = LvarPos>
								<cfelse>
									<cfset LvarPos = LvarDBStruct[LvarDBStructI][4]>
									<cfif LvarPos GT arrayLen(LvarXMLrow) OR LvarXMLrow[LvarPos].XmlName NEQ LvarName>
										<cfset LvarPos = XmlChildPos(LvarXMLrow,LvarName, 1)>
									</cfif>
								</cfif>
								<cfif LvarPos EQ -1>
									<cfthrow message="No existe valor en el XML para el Campo '#LvarName#' en la linea #i#">
								<cfelse>
									<cfset LvarValue = LvarXMLrowVals[LvarPos].XmlText>
			
									<cfset LvarCFType = LvarDBStruct[LvarDBStructI][2]>
									<cfif LvarCFType EQ "B">
										<cfset LvarValue = ToBinary(LvarValue)>
									<cfelseif LvarCFType EQ "D">
									<cfelseif LvarCFType EQ "N">
										<cfset LvarValue = replace(LvarValue,",","","ALL")>
									<cfelseif LvarCFType EQ "S">
									</cfif>
								</cfif>
			
								<cfif LvarDBStructI GT 1>
									,
								</cfif>
								<cfif LvarValue EQ ''><cfset LvarValue=-1></cfif>
								<cfqueryparam cfsqltype="#LvarDBStruct[LvarDBStructI][3]#" value="#LvarValue#" null="#trim(LvarValue) eq ''#">
							</cfloop>
							)
						</cfquery>
						<cfif Arguments.Dimension NEQ "">
							<cfset stN = Application.mig_prcs.stN>
							<cfset Application.mig_prcs.subTipos[stN].news ++>
						</cfif>
					</cfloop> 
				</cfloop> 
			</cfif>
			<cfset LvarBR.close()>
		<cfcatch type="any">
			<cfif isdefined("LvarBR")>
				<cfset LvarBR.close()>
			</cfif>
			<cfrethrow>
		</cfcatch>
		</cftry> 
	</cffunction>

	<cffunction name="sbPintarResultado" returntype="string">
		<cfargument name="end" default="false" type="boolean">

		<cfsavecontent variable="LvarTxt">
		<cfoutput>
		<table align="center" border="0">
			<tr>
				<td>Cargando Datos:</td>
				<td colspan="5">#application.mig_prcs.Tipo#</td>
			</tr>
			<tr>
				<td>Inicio de carga:</td>
				<td colspan="5">#DateFormat(application.mig_prcs.Inicio,"DD/MM/YYYY")# #TimeFormat(application.mig_prcs.Inicio,"HH:MM:SS")#</td>
			</tr>
		<cfif application.mig_prcs.stN EQ 0>
			<tr>
				<td colspan="6">
					<div style="position:relative;top:0px;left:0px;width:400px; height:20px; border:solid ##CCCCCC 1px; overflow:hidden">
						<div style="position:relative;top:0px;left:0px;width:0px; height:20px; border:none; background-color:##CCCCCC;">
						</div>
						<div style="position:relative;top:-19px;left:0px;width:400px; height:20px; border:none; overflow:hidden; text-align:center;">
						INICIANDO...
						</div>
					</div>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td rowspan="2" align="center" valign="middle"><strong>Nombre</strong></td>
				<td rowspan="2" align="center" valign="middle"><strong>Totales</strong></td>
				<td colspan="2" align="center" style="border-bottom:solid 1px ##CCCCCC"><strong>Nuevos</strong></td>
				<td colspan="2" align="center" style="border-bottom:solid 1px ##CCCCCC"><strong>Modificados</strong></td>
			</tr>
			<tr>
				<td align="center"><strong>OKs</strong></td>
				<td align="center"><strong>ERRs</strong></td>
				<td align="center"><strong>OKs</strong></td>
				<td align="center"><strong>ERRs</strong></td>
			</tr>
			<cfloop index="i" from="1" to="#application.mig_prcs.stN#">
			<tr>
				<td>#application.mig_prcs.subTipos[i].name#</td>
				<td align="center">#application.mig_prcs.subTipos[i].tots#</td>
				<td align="center">#application.mig_prcs.subTipos[i].news#</td>
				<td align="center"><font color="##FF0000">#application.mig_prcs.subTipos[i].errN#</font></td>
				<td align="center">#application.mig_prcs.subTipos[i].olds#</td>
				<td align="center"><font color="##FF0000">#application.mig_prcs.subTipos[i].errO#</font></td>
			</tr>
			</cfloop>
			<tr>
				<td colspan="6">
					<cfset LvarAvance = round(application.mig_prcs.subTipos[application.mig_prcs.stN].Avance*100)>
					<div style="position:relative;top:0px;left:0px;width:400px; height:20px; border:solid ##CCCCCC 1px; overflow:hidden">
						<div style="position:relative;top:0px;left:0px;width:#4 * LvarAvance#px; height:20px; border:none; background-color:##CCCCCC;">
						</div>
						<div style="position:relative;top:-19px;left:0px;width:400px; height:20px; border:none; overflow:hidden; text-align:center;">
						#LvarAvance#%
						</div>
					</div>
				</td>
			</tr>
			</cfif>
			<tr>
			<cfif Arguments.end>
				<td>Final de carga:</td>
			<cfelse>
				<td>Ultima actividad:</td>
			</cfif>
				<td colspan="5">#DateFormat(application.mig_prcs.Activ,"DD/MM/YYYY")# #TimeFormat(application.mig_prcs.Activ,"HH:MM:SS")#</td>
			</tr>
			<cfif not Arguments.end and datediff("s",application.mig_prcs.Activ,now()) GT 120>
			<tr>
				<td colspan="6" align="center">
					<font color="##FF0000"><strong>PROCESO DORMIDO:</strong></font> (más de 2 minutos sin actividad)
				</td>
			</tr>
			</cfif>
			<tr>
				<td colspan="6" align="center">
					<br>
					<form action="cargarCubo_sql.cfm" method="post">
				<cfif Arguments.end>
						<input type="button" value="Regresar" onclick="history.back();" />
				<cfelse>
						<input type="submit" value="Cancelar" name="btnCANCEL" onclick="return confirm('¿Desea Cancelar el proceso de carga?');" />
				</cfif>
					</form>
				</td>
			</tr>
		</table>
		</cfoutput>
		</cfsavecontent>
		<cfreturn LvarTxt>
	</cffunction>

	<cffunction name="sbCalcularAcumulados" returntype="void" output="no">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">

 		<!--- 
			CAMPO CONTROL:
				1 = Datos Nuevos o Actualizados
				2 = Calculos en progreso
				3 = Calculos realizados
				4 = Datos cargados en Multidimensional
		--->
		<cfquery name="rsSQL" datasource="#Arguments.dsn#">
			select 	count(1) as cantidad
			  from	F_Datos
			 where	control < 3
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfreturn>
		</cfif>

		<cf_dbfunction2 name="date_part" args="YYYY,F_Datos.Pfecha" datasource="#Arguments.dsn#" returnVariable="ANNO_ACTUAL">
		<cfset ANNO_ANTERIOR	= "(#ANNO_ACTUAL#-1)">
		<cfset ANNO_ACTUAL		= "(#ANNO_ACTUAL#)">
		<cfset YYYY000_ACTUAL	= "(#ANNO_ACTUAL#*1000)">
		<cfset YYYY000_ANTERIOR = "(#ANNO_ANTERIOR#*1000)">

		<cfset DIA_ANTERIOR	= "to_number(to_char((F_Datos.PFECHA - 1), 'DDD'))">

		<!--- Marcar como Actualizados los periodos posteriores o iguales a períodos modificados --->
		<cfquery datasource="#Arguments.dsn#" name="periodosXmodificar">
			select f.id_datos 
    			from F_Datos pasado
       				inner join F_Datos f 
         				on pasado.MIGMid 		    		    = f.MIGMid
					   and pasado.Dcodigo					= f.Dcodigo
					   and pasado.Periodo	      	           <= f.Periodo
					   and pasado.Periodo_Tipo                  = f.Periodo_Tipo
					   and COALESCE(pasado.MIGProid,-1)		    = COALESCE(f.MIGProid,-1)
					   and COALESCE(pasado.MIGCueid,-1)		    = COALESCE(f.MIGCueid,-1)
					   and COALESCE(pasado.id_moneda,-1)		= COALESCE(f.id_moneda,-1)
					   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(f.id_moneda_origen,-1)
					   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(f.id_atr_dim4,'*')
					   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(f.id_atr_dim5,'*')
					   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(f.id_atr_dim6,'*')  
					   and pasado.Ecodigo			            = f.Ecodigo
					   and pasado.control 		                < 3
		</cfquery>
		<cfloop query="periodosXmodificar">
			<cfquery datasource="#Arguments.dsn#">
				Update 	F_Datos
				   set 	control  = 1,
						controlr = 1
				where id_datos = #periodosXmodificar.ID_DATOS#
			</cfquery>
		</cfloop>
		<!---<cfquery datasource="#Arguments.dsn#">
			Update 	F_Datos
			   set 	control = 1,
			   		controlr = 1
			 where (
					select count(1)
					  from F_Datos pasado
					 where pasado.Ecodigo						= F_Datos.Ecodigo
					   and pasado.MIGMid						= F_Datos.MIGMid
					   and pasado.Dcodigo						= F_Datos.Dcodigo
					   and COALESCE(pasado.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
					   and COALESCE(pasado.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
					   and COALESCE(pasado.id_moneda,-1)		= COALESCE(F_Datos.id_moneda,-1)
					   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
					   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
					   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
					   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')

					   and pasado.Periodo_Tipo  	= F_Datos.Periodo_Tipo 
					   and pasado.Periodo		<= F_Datos.Periodo
					   and pasado.control 		< 3
					) > 0
		</cfquery>--->

		<!--- Calcular acumulado de valores del inicio de año al período actual --->
		<cfquery datasource="#Arguments.dsn#">
			Update 	F_Datos
			   set 	control = 2,
					acumulado =
						(
							Select Sum(COALESCE(valor,0)) 
							  From F_Datos acum
							 where acum.Ecodigo							= F_Datos.Ecodigo
							   and acum.MIGMid							= F_Datos.MIGMid
							   and acum.Dcodigo							= F_Datos.Dcodigo
							   and COALESCE(acum.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
							   and COALESCE(acum.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
							   and COALESCE(acum.id_moneda,-1)			= COALESCE(F_Datos.id_moneda,-1)
							   and COALESCE(acum.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
							   and COALESCE(acum.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
							   and COALESCE(acum.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
							   and COALESCE(acum.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')
		
							   and acum.Periodo_Tipo 	= F_Datos.Periodo_Tipo
							   and acum.Periodo 		>= #preserveSingleQuotes(YYYY000_ACTUAL)#
							   and acum.Periodo 		<= F_Datos.Periodo
						)
			 where 	control = 1
		</cfquery>

		<!--- Obtener valores ya calculados del pasado:
				valor_periodo_anterior 			= Valor de "VALOR" del Periodo Anterior
				
				valor_anno_anterior				= Valor de "VALOR" del mismo Periodo del Año Anterior
				valor_acumulado_anno_anterior	= Valor de "ACUMULADO" del mismo Periodo del Año Anterior
				valor_per_ant_anno_anterior		= Valor de "VALOR_PERIODO_ANTERIOR" del mismo Periodo del Año Anterior

				Periodo Anterior:
					si no es primer periodo = 1: 	Periodo -1
					si es primer periodo = 1:		Ultimo Periodo Año Anterior o (Año-1)
				Mismo Periodo del Año Anterior:
					si no es diario, es Periodo-1000 (mismo periodo un año atras)
					si es diario hay problemas con los biciestos, por lo que se calcula el periodo para (Año-1)*1000 + datepart(fecha - 1 año) (OJO: 29/FEB obtiene 28/FEB/AnoAnterior)
		--->
		<cfquery datasource="#Arguments.dsn#">
			Update 	F_Datos
			   set 	control = 3,
					valor_periodo_anterior =
						COALESCE((
							Select valor 
							  from F_Datos pasado
							 where pasado.Ecodigo						= F_Datos.Ecodigo
							   and pasado.MIGMid						= F_Datos.MIGMid
							   and pasado.Dcodigo						= F_Datos.Dcodigo
							   and COALESCE(pasado.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
							   and COALESCE(pasado.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
							   and COALESCE(pasado.id_moneda,-1)		= COALESCE(F_Datos.id_moneda,-1)
							   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
							   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
							   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
							   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')
		
								<cf_dbfunction2 name="dateadd"		args="-1,F_Datos.Pfecha,DD"		datasource="#Arguments.dsn#" returnVariable="ULTIMO_DIA_ANNO">
								<cf_dbfunction2 name="date_part"	args="DY;#ULTIMO_DIA_ANNO#"	datasource="#Arguments.dsn#" returnVariable="PART_D_ULTIMO_DIA" delimiters=";">
							   and pasado.Periodo_Tipo = F_Datos.Periodo_Tipo
							   and pasado.Periodo =
									case 
										<!--- Periodo <> YYYY001: Periodo Anterior del Año Actual --->
										when F_Datos.Periodo - #preserveSingleQuotes(YYYY000_ACTUAL)# > 1 then F_Datos.Periodo - 1
										<!--- Periodo =  YYYY001: Ultimo Periodo del Año Anterior (en caso de periodicidad D=diario puede ser 365 o 366 por años biciestos)--->
										when F_Datos.Periodo_Tipo = 'D' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + #preserveSingleQuotes(PART_D_ULTIMO_DIA)#
										when F_Datos.Periodo_Tipo = 'W' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + 52
										when F_Datos.Periodo_Tipo = 'M' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + 12
										when F_Datos.Periodo_Tipo = 'T' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + 4
										when F_Datos.Periodo_Tipo = 'S' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + 2
										when F_Datos.Periodo_Tipo = 'A' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + 1
									end
						),0),
					valor_anno_anterior =
						COALESCE((
							Select valor 
							  from F_Datos pasado
							 where pasado.Ecodigo						= F_Datos.Ecodigo
							   and pasado.MIGMid						= F_Datos.MIGMid
							   and pasado.Dcodigo						= F_Datos.Dcodigo
							   and COALESCE(pasado.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
							   and COALESCE(pasado.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
							   and COALESCE(pasado.id_moneda,-1)		= COALESCE(F_Datos.id_moneda,-1)
							   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
							   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
							   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
							   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')
		
								<!--- Mismo Periodo Año Anterior --->
								<cf_dbfunction2 name="dateadd"		args="-1,F_Datos.Pfecha,YYYY"	datasource="#Arguments.dsn#" returnVariable="DIA_ANNO_ANTERIOR">
								<cf_dbfunction2 name="date_part"	args="DY;#DIA_ANNO_ANTERIOR#"	datasource="#Arguments.dsn#" returnVariable="PART_D_DIA_ANNO_ANTERIOR" delimiters=";">
							   and pasado.Periodo_Tipo = F_Datos.Periodo_Tipo
							   and pasado.Periodo =
									case 
										<!--- en caso de periodicidad D=diario:  Se recalcula Ano Anterior * 1000 + numero días de (fecha - 1 año) --->
										when F_Datos.Periodo_Tipo = 'D' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + #preserveSingleQuotes(PART_D_DIA_ANNO_ANTERIOR)#
										<!--- en caso de otra periodicidad:  Periodo menos 1 año (1*1000) --->
										else F_Datos.Periodo-1000
									end
						),0),

					valor_acumulado_anno_anterior =
						COALESCE((
							Select acumulado 
							  from F_Datos pasado
							 where pasado.Ecodigo						= F_Datos.Ecodigo
							   and pasado.MIGMid						= F_Datos.MIGMid
							   and pasado.Dcodigo						= F_Datos.Dcodigo
							   and COALESCE(pasado.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
							   and COALESCE(pasado.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
							   and COALESCE(pasado.id_moneda,-1)		= COALESCE(F_Datos.id_moneda,-1)
							   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
							   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
							   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
							   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')
		
							   and pasado.Periodo_Tipo = F_Datos.Periodo_Tipo
							   and pasado.Periodo =
									case 
										when F_Datos.Periodo_Tipo = 'D' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + #preserveSingleQuotes(PART_D_DIA_ANNO_ANTERIOR)#
										else F_Datos.Periodo-1000
									end
						),0),
					valor_per_ant_anno_anterior =
						COALESCE((
							Select valor_periodo_anterior 
							  from F_Datos pasado
							 where pasado.Ecodigo						= F_Datos.Ecodigo
							   and pasado.MIGMid						= F_Datos.MIGMid
							   and pasado.Dcodigo						= F_Datos.Dcodigo
							   and COALESCE(pasado.MIGProid,-1)			= COALESCE(F_Datos.MIGProid,-1)
							   and COALESCE(pasado.MIGCueid,-1)			= COALESCE(F_Datos.MIGCueid,-1)
							   and COALESCE(pasado.id_moneda,-1)		= COALESCE(F_Datos.id_moneda,-1)
							   and COALESCE(pasado.id_moneda_origen,-1)	= COALESCE(F_Datos.id_moneda_origen,-1)
							   and COALESCE(pasado.id_atr_dim4,'*')		= COALESCE(F_Datos.id_atr_dim4,'*')
							   and COALESCE(pasado.id_atr_dim5,'*')		= COALESCE(F_Datos.id_atr_dim5,'*')
							   and COALESCE(pasado.id_atr_dim6,'*')		= COALESCE(F_Datos.id_atr_dim6,'*')
		
							   and pasado.Periodo_Tipo = F_Datos.Periodo_Tipo
							   and pasado.Periodo =
									case 
										when F_Datos.Periodo_Tipo = 'D' then #preserveSingleQuotes(YYYY000_ANTERIOR)# + #preserveSingleQuotes(PART_D_DIA_ANNO_ANTERIOR)#
										else F_Datos.Periodo-1000
									end
						),0)
			 where control = 2
		</cfquery>
	</cffunction>

	<cffunction name="fnDSNdestino" returntype="string" output="no" access="public">
		<cfset DSNdestino	= "#session.dsn#">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor from Parametros where Pcodigo = 2000
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "">
			<cfset DSNdestino = rsSQL.Pvalor>
		</cfif>
		<cfreturn DSNdestino>
	</cffunction>
	
	<cffunction name="fnPeriodoConversion" returntype="struct" output="no" access="public">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">
		<cfargument name="Tipo_ORI"		type="string">
		<cfargument name="Valor_ORI"	type="numeric">
		<cfargument name="Tipo_DST"		type="string">

		<cfset var rsPER = "">
		<cfquery name="rsPER" datasource="#Arguments.dsn#">
			select '#Arguments.Tipo_DST#' as tip, min(PERIODO_#Arguments.Tipo_DST#) as ini, max(PERIODO_#Arguments.Tipo_DST#) as fin
			  from D_PERIODO
			 where PERIODO_#Arguments.Tipo_ORI# = #Arguments.Valor_ORI#
		</cfquery>
		<cfset LvarPer = structNew()>
		<cfset LvarPer.tip = rsPER.tip>
		<cfset LvarPer.ini = rsPER.ini>
		<cfset LvarPer.fin = rsPER.fin>
		<cfreturn LvarPER>
	</cffunction>

	<cffunction name="fnPeriodoToFecha" returntype="struct" output="no" access="public">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">
		<cfargument name="Tipo_ORI"		type="string">
		<cfargument name="Valor_ORI"	type="numeric">

		<cfset var rsPER = "">
		<cfquery name="rsPER" datasource="#Arguments.dsn#">
			select '#Arguments.Tipo_ORI#' as tip, #Arguments.Valor_ORI# as val, min(FECHA) as ini, max(FECHA) as fin
			  from D_PERIODO
			 where PERIODO_#Arguments.Tipo_ORI# = #Arguments.Valor_ORI#
		</cfquery>
		<cfset LvarPer = structNew()>
		<cfset LvarPer.tip = Arguments.Tipo_ORI>
		<cfset LvarPer.per = Arguments.Valor_ORI>
		<cfset LvarPer.ini = rsPER.ini>
		<cfset LvarPer.fin = rsPER.fin>
		<cfreturn LvarPER>
	</cffunction>

	<cffunction name="fnFechaToPeriodo" returntype="struct" output="no" access="public">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">
		<cfargument name="Fecha_ORI"	type="date">
		<cfargument name="Tipo_DST"		type="string">

		<cfset var rsPER = "">
		<cfquery name="rsPER" datasource="#Arguments.dsn#">
			select PERIODO_#Arguments.Tipo_DST# as per
			  from D_PERIODO
			 where FECHA = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha_ORI#">
		</cfquery>
		<cfset LvarPer = structNew()>
		<cfset LvarPer.fec = Arguments.Fecha_ORI>
		<cfset LvarPer.tip = Arguments.Tipo_DST>
		<cfset LvarPer.per = rsPER.per>
		<cfreturn LvarPER>
	</cffunction>

	<cffunction name="sbCalcularResumenes" returntype="void" output="no">
		<cfargument name="dsn"			type="string"	default="#session.dsn#">

		<!--- Verificar que todos los datos se hayan resumido --->
		<cfquery name="rsSQL" datasource="#Arguments.dsn#">
			select 	count(1) as cantidad
			  from	F_Datos
			 where	control < 3
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfthrow message="Se encontraron datos que requieren el proceso de calcular Resumenes">
			<cfinvoke component="calculadora" method="CalcularResumenes" dsn="#Arguments.dsn#">
		</cfif>
	</cffunction>
</cfcomponent>
