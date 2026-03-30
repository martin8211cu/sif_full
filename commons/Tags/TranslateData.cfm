<cfparam name="name"  			type="string" default="">
<cfparam name="tabla"  			type="string" default="">
<cfparam name="col"  			type="string" default="">
<cfparam name="valor"  			type="string" default="">
<cfparam name="idioma" 			type="string" default="">
<cfparam name="filtro" 			type="string" default="">
<cfparam name="Ecodigo" 		type="string" default="">
<cfparam name="conexion" 		type="string" default="">
<cfparam name="alias" 			type="string" default="">
<cfparam name="returnvariable" 	type="string" default="">

<cfsilent>
	<!----- VALIDACIONES GENERALES---->
	<!---- verifica la indicacion de un idioma--->
	<cfif isdefined("Attributes.idioma") and len(trim(Attributes.idioma))>
		<cfset suffix		= '_'&Attributes.idioma>
	<cfelseif isdefined("session.idioma")>
		<cfset suffix = '_'&session.idioma>
	<cfelse>
		<cf_throw message="No existe definido Idioma en session">
	</cfif>
	
	<cfif isdefined("attributes.conexion") and len(trim(attributes.conexion))>
		<cfset dsn = attributes.conexion>
	<cfelseif isdefined("session.dsn")>
		<cfset dsn = session.dsn>
	<cfelse>
		<cf_throw message="No existe definido base datos para traduccion">
	</cfif>
	<cfif not isdefined("attributes.name")>
		<cf_throw message="Debe definir una funcion a utilizar: get, set, validar">
	</cfif>	
	<cfif not isdefined("attributes.tabla")>
		<cf_throw message="No sea a definido el atributo tabla">
	</cfif>
	<cfif not isdefined("attributes.col") and not findnocase(attributes.name,'validar,listCols')>
		<cf_throw message="No sea a definido el atributo Columna">
	</cfif>

	<cfif not findnocase(attributes.name,'get,set,validar,listCols')>
		<cf_throw message="Funciones Permitidas: get,set,validar,listCols">
	</cfif>

	<!---- la validacion no necesita columnas---->
	<cfif not findnocase(attributes.name,'validar,listCols')>
			<!--- crea nueva columna para la busqueda--->
			<cfset columna = trim(attributes.col)>
			
			<!--- guarda el alias de la tabla en el caso que tenga---->
			<cfset alias=''>
			<!----- si posee alias se quita el alias y se separa de la columnas---->
			 
			<cfif find(".",columna)><!--- se asume que los alias son los separadores--->
				<cfset alias = listgetAt(columna,1,".")>
				<cfset columna = listgetAt(columna,2,".")>
			</cfif>
			
			<!---- la nueva columna --->
			<cfset columnaNueva = trim(columna)&trim(suffix)>
			
			<cfif len(trim(columnaNueva)) gt 30>
				<cf_throw message="La Columna a Crear es mayor al tamano permitido #columna#">
			</cfif>
	</cfif>

	<cfif not isdefined("request.useTranslateData")>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" returnvariable="lvarParam">
			<cfinvokeargument name="Pvalor" value="2700">
			<cfinvokeargument name="default" value="0">
			<cfif isdefined("attributes.Ecodigo") and len(trim(attributes.ecodigo))>	
				<cfinvokeargument name="Ecodigo" value="#attributes.Ecodigo#">
			</cfif>		
		</cfinvoke>	
		<cfset request.useTranslateData = lvarParam>
		<cfset request.tdata =  createobject("component","commons.Componentes.TraduccionData")>
	</cfif>		
	<!---- SI USA O NO TRADUCCION DE DATOS----->
	<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
			<cfif attributes.name eq 'get'>
				<!---- busca la columna, si no la encuentra la crea, puesto que será necesaria posteriormente--->
				<cftry>
					<cfquery datasource="#dsn#">
						select #columnaNueva#
						from #attributes.tabla#
						where 1=2
					</cfquery>
					<cfcatch type="database">
						<cf_throw message="Es necesario Crear la tabla de Traduccion para el Presente Idioma: #trim(suffix)#">
					</cfcatch>	
				</cftry>
				<!---- obtiene la forma del coalesce para el campo necesario--->
				<cfset LvarRetornoString = getCoalesceString(attributes.tabla,columna, columnaNueva,alias,dsn)>	
				<!--- retorna a la variable el coalesce---->
				<cfset Caller[Attributes.returnvariable] = LvarRetornoString>
				
			<cfelseif attributes.name eq 'set'>	
				<cfif not isdefined("attributes.filtro")>
					<cf_throw message="Debe indicar el filtro para validar el campo">
				</cfif>
				<cfif not isdefined("attributes.valor")>
					<cf_throw message="Debe indicar un valor en el parametro 'valor' para guardar en Traduccion">
				</cfif>
					<cfif request.tdata.validaColumna(attributes.tabla,columna,dsn)>
						<cftry>	
							<cfset infoColumna = request.tdata.getMetaDataTable(attributes.tabla, columnaNueva, dsn)>
							<cfquery datasource="#dsn#" name="rsValidar">
								update #attributes.tabla#
								set #columnaNueva# = 	<cfif len(trim(attributes.valor)) > 
															<cfif infoColumna.tipo eq 'text'>
																<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.valor#">
															<cfelse>
																<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.valor#">
															</cfif>	
														<cfelse>
															null	
														</cfif>		
								where #preservesinglequotes(attributes.filtro)#
							</cfquery>	
							<cfcatch type="database">
								<cf_throw message="No se ha logrado actualizar el registro en el Idioma Actual">
							</cfcatch>	
						</cftry>
					</cfif>	
							
			<cfelseif attributes.name eq 'validar'>	
				<cfif not isdefined("attributes.filtro")>
					<cf_throw message="Debe indicar el filtro para validar el campo">
				</cfif>
				<cftry>
					<cfset LvarColumnas = request.tdata.getTablas(attributes.tabla,dsn)>
					<cfif not ArrayLen(LvarColumnas)>
						<cf_throw message="No se ha configurado la tabla: #attributes.tabla# como elemento válido">
					</cfif>
					<cfset columnasRevision=''>
					<cfloop list="#LvarColumnas[1].cols#" index="j">
						<cfset columnasRevision = ListAppend(columnasRevision,j&suffix)>
					</cfloop>
					<cfquery datasource="#dsn#" name="rsValidar">
						select #columnasRevision#
						from #attributes.tabla#
						where #preservesinglequotes(attributes.filtro)#
					</cfquery>
					<cfif rsValidar.recordcount gt 1>
						<cf_throw message="El filtro para validación utilizado devuelve más de un registro">
					</cfif>
					<cfset cantColumnasVacias=0>
					<cfloop list="#columnasRevision#" index="j">
						<cfif evaluate("not len(trim(rsValidar.#j#))")><cfset cantColumnasVacias=cantColumnasVacias+1></cfif>
					</cfloop>
					<cfif cantColumnasVacias gt 0>
						<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSJ_TranslateUno" xmlFile="/rh/generales.xml"
							default="Este Registro No posee ninguna traducción en el idioma actual" returnvariable="MSJ_TranslateUno">
						<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSJ_TranslateDos" xmlFile="/rh/generales.xml"
							default="Este Registro Posee una traducción parcial en el idioma actual" returnvariable="MSJ_TranslateDos">
						<cfsavecontent variable="ThisTag.GeneratedContent">
						<table width="100%" align="center"><tr><td align="center">
						<cfif ListLen(columnasRevision) eq cantColumnasVacias>
							<cfoutput><font color="FF0000">#MSJ_TranslateUno#</font></cfoutput>
						<cfelseif cantColumnasVacias lt columnasRevision>
							<cfoutput><font color="FF0000">#MSJ_TranslateDos#</font></cfoutput>
						</cfif>
						</td></tr></table>
						</cfsavecontent>
					</cfif>			
					<cfcatch type="database">
						<cf_throw message="Problema encontrado al validar la tabla: '#attributes.tabla#' de Traduccion para el Presente Idioma">
					</cfcatch>	
				</cftry>

			<cfelseif attributes.name eq 'listCols'>
				<!---- obtiene las columnas traduccion habilitadas para la traduccion en la tabla seleccionada--->
				<cfset LvarRetornoString=''>
				<cftry>
					<cfset LvarColumnas = request.tdata.getTranslatedataCols(attributes.tabla,dsn)>
					<cfif len(trim(LvarColumnas))>
						<cfset LvarRetornoString=','&LvarColumnas>
					</cfif>
					<cfif isDefined("attributes.alias") and len(trim(attributes.alias))>
						<cfset LvarRetornoString=replace(LvarRetornoString,',',',#attributes.alias#.','ALL')>	
					</cfif>
					<cfcatch type="database">
						<cf_throw message="No se logró obtener las columnas para la tabla: #attributes.tabla#">
					</cfcatch>	
				</cftry>
				<cfset Caller[Attributes.returnvariable] = LvarRetornoString>
			</cfif>
	
	<cfelse><!---- en el caso que no usa traduccion--->
			<cfif attributes.name eq 'get'>
			<cfset Caller[Attributes.returnvariable] = attributes.col>
			<cfelseif attributes.name eq 'set'>
			<cfelseif attributes.name eq 'validar'>
			<cfelseif attributes.name eq 'listCols'>
			<cfset Caller[Attributes.returnvariable] = ''>
			</cfif>
	</cfif><!---- fin de si usa traduccion de datos---->
</cfsilent>

	
<cffunction name="getCoalesceString">
	<cfargument name="tabla" 	type="string" required="yes">
	<cfargument name="ColOri" 	type="string" required="yes">
	<cfargument name="Col" 		type="string" required="yes">
	<cfargument name="alias" 	type="string" required="yes">
	<cfargument name="dsn" 		required="yes" type="string">
	
	<cfset MetaTable = request.tdata.getMetaDataTable(arguments.tabla, arguments.colOri, arguments.dsn)>

	<!--- si es tipo text no se puede hacer coalesce y se devuelve la columna no el sufijo y el alias--->
	<cfset alias = arguments.alias >
	<cfif len(trim(alias))>
		<cfset alias= trim(alias)&'.'>
	</cfif>
	
	<cfif findnocase('text',MetaTable.tipo)>
		<cfset retornoString = alias&arguments.Col>
	<cfelse>
		<cfset retornoString = 'coalesce('& alias & arguments.Col &','& alias & arguments.ColOri &')'>
	</cfif>
	
	<cfreturn retornoString> 
</cffunction>


