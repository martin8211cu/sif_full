<!--- Liberación del Plistas con Ajax:	3/NOV/2008 --->
<!--- Componente de Listas --->
<cfcomponent>
	<cfif Not IsDefined('Request.HEAD_PLISTA1_JS')>
		<cfset Request.HEAD_PLISTA1_JS = true>
		<script type="text/javascript" language="JavaScript" src="/cfmx/commons/js/pLista1.js"></script>
	</cfif>
	<cf_templatecss />
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NoSeEncontraronRegistros"
		Default="No se encontraron Registros "
		XmlFile="/commons/generales.xml"
		returnvariable="LB_NoSeEncontraronRegistros"/> 

<cffunction name="pListaRH" access="public" returntype="string" output="true">
	<cfargument name="tabla" type="string" required="true" default="<!--- Nombre de la Tabla --->">
	<cfargument name="columnas" type="string" required="true" default="<!--- Lista de las columnas para el POST--->">
	<cfargument name="desplegar" type="string" required="true" default="<!--- Columnas a desplegar en la Lista--->">
	<cfargument name="etiquetas" type="string" required="true" default="<!--- Título de las columnas --->">
	<cfargument name="formatos" type="string" required="true" default="<!--- Formato para cada columna (M,D,I,N,F)--->">
	<cfargument name="lineaRoja" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="lineaAzul" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="lineaVerde" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="filtro" type="string" required="true" default="<!--- condiciones para el Where --->">
	<cfargument name="align" type="string" required="true" default="<!--- Tipo de Justiticación (left, center, right, justify) --->">
	<cfargument name="ajustar" type="string" required="true" default="S"> <!--- Ajusta la columna (S,N)--->
	<cfargument name="irA" type="string" required="true" default="_self">
	<cfargument name="checkboxes" type="string" required="false" default="N">
	<cfargument name="checkall" type="string" required="false" default="N">
	<cfargument name="chkcortes" type="string" required="false" default="N"> 
	<cfargument name="keycorte" type="string" required="false" default="">
	<cfargument name="radios" type="string" required="false" default="N">
	<cfargument name="debug" type="string" required="false" default="N"> <!--- Activa el Debug (S,N)--->
	<cfargument name="MaxRows" type="numeric" required="false" default="20">
	<cfargument name="MaxRowsQuery" type="numeric" required="false" default="0">
	<cfargument name="Cortes" type="string" required="false" default="">
	<cfargument name="navegacion" type="string" required="false" default="">
	<cfargument name="botones" type="string" required="false" default="">
	<cfargument name="incluyeForm" type="string" required="false" default="true">
	<cfargument name="formName" type="string" required="false" default="lista">
	<cfargument name="formAttr" type="string" required="false" default="">
	<cfargument name="keys" type="string" required="false" default="">
	<cfargument name="checkedcol" type="string" required="false" default="">
	<cfargument name="inactivecol" type="string" required="false" default="">
	<cfargument name="Conexion" type="string" required="false" default="#Session.DSN#">
	<cfargument name="funcion" type="string" required="false" default="">
	<cfargument name="fparams" type="string" required="false" default="">
	<cfargument name="showLink" type="boolean" required="false" default="true">
	<cfargument name="showEmptyListMsg" type="boolean" required="false" default="false">
	<cfargument name="EmptyListMsg" type="string" required="false" default="--- #LB_NoSeEncontraronRegistros# ---">
	<cfargument name="PageIndex" type="string" required="false" default="">
	<cfargument name="totales" type="string" required="false" default="" hint="Columnas por totalizar">
	<cfargument name="totalgenerales" type="string" required="false" default="" hint="Columnas de totales generales">
	<cfargument name="pasarTotales" type="string" required="false" default="" hint="Totales a Escribir en las columnas indicadas">
	<cfargument name="form_method" type="string" required="false" default="post" hint="Metodo para el form: GET o POST">
	<cfargument name="checkbox_function" type="string" required="false" default="" hint="Funcion para el checkbox o radio">
	<cfargument name="mostrar_filtro" type="boolean" required="false" default="no" hint="Mostrar cajas de filtro">
	<cfargument name="filtrar_automatico" type="boolean" required="false" default="no" hint="Filtrar Automáticamente, especial para las cajas de filtro">
	<cfargument name="filtrar_por" type="string" required="false" default="" hint="Columnas para Filtrar Automáticamente">
	<cfargument name="filtrar_por_delimiters" type="string" required="false" default="," hint="Delimitador para filtrar_por, default=','">
	<cfargument name="filtrar_por_array" type="array" required="false" default="#ArrayNew(1)#" hint="Columnas para Filtrar Automáticamente">
	<cfargument name="width" type="string" default="" required="false">
	<cfargument name="finReporte" type="string" default="" required="false">
	<cfargument name="QueryString_lista" type="string" default="" required="false">
	<cfargument name="alternar" type="boolean" default="true" required="yes">
	<cfargument name="filtro_nuevo" type="boolean" default="no" required="no">
	<cfargument name="fontsize" type="string" default="" required="no">
	<cfargument name="FilasParaBotonesSuperiores" type="numeric" default="25" required="no">

	<!--- modificado: danim, 14-oct-2005, agregar parametro 'alternar', default=yes
		alternar indica si se deben alternar los colores de la lista o no. --->
	<cfif Arguments.MaxRowsQuery GT 0>
        <cfset LvarMaxRowsQuery 		= Arguments.MaxRowsQuery>
    <cfelse>
        <cfset Arguments.MaxRowsQuery 	= 0>
        <cfset LvarMaxRowsQuery 		= -1>
    </cfif>		
	<cfif mostrar_filtro and filtrar_automatico>
		<!--- FILTRO AUTOMATICO --->
		<cfquery name="rsLista" result="rsResult" datasource="#Conexion#" maxrows="#LvarMaxRowsQuery#">
			select #PreserveSingleQuotes(columnas)#
			from #PreserveSingleQuotes(tabla)#
			where 1=1
			<cfset arFormatos = ListtoArray(Arguments.formatos)>
			<cfset arDesplegar=ListtoArray(Arguments.desplegar)>
			<cfif ArrayLen(Arguments.filtrar_por_array)>
				<cfset arFiltrarPor=Arguments.filtrar_por_array>
			<cfelseif len(Arguments.filtrar_por)>
				<cfset arFiltrarPor=ListtoArray(Arguments.filtrar_por, filtrar_por_delimiters)>
			<cfelse>
				<cfset arFiltrarPor=ListtoArray(Arguments.desplegar)>
			</cfif>
			<cfloop from="1" to="#ArrayLen(arDesplegar)#" index="i">
				<cfif     IsDefined('form.filtro_'&Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(form['filtro_'&Trim(arDesplegar[i])])#">
				<cfelseif IsDefined('url.filtro_' &Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(url ['filtro_'&Trim(arDesplegar[i])])#">
				<cfelse><cfset temp_value="">
				</cfif>
				<cfif     IsDefined('form.hfiltro_'&Trim(arDesplegar[i]))><cfset htemp_value="#HTMLEditFormat(form['hfiltro_'&Trim(arDesplegar[i])])#">
				<cfelseif IsDefined('url.hfiltro_' &Trim(arDesplegar[i]))><cfset htemp_value="#HTMLEditFormat(url ['filtro_'&Trim(arDesplegar[i])])#">
				<cfelse><cfset htemp_value="">
				</cfif>
				<cfset x = Replace(arFiltrarPor[i],"''","'","all")>
				<cfif (temp_value neq htemp_value) and ((len(trim(temp_value)) and temp_value gte 0) 
						or len(trim(htemp_value)) and htemp_value gte 0)>
					<cfset Arguments.filtro_nuevo = true>
				</cfif>
				<cfif len(trim(temp_value)) and temp_value gte 0>
					<cfset tempPos=ListContainsNoCase(Arguments.Navegacion,"filtro_" & Trim(arDesplegar[i]) & "=","&")>
					<cfif tempPos NEQ 0>
					  <cfset Arguments.Navegacion=ListDeleteAt(Arguments.Navegacion,tempPos,"&")>
					</cfif>
					<cfset Arguments.Navegacion=ListAppend(Arguments.Navegacion,"filtro_" & Trim(arDesplegar[i]) & "=" & JSStringFormat(temp_value),"&")>
					<cfset Arguments.Navegacion=ListAppend(Arguments.Navegacion,"hfiltro_" & Trim(arDesplegar[i]) & "=" & JSStringFormat(htemp_value),"&")>
					<cfif Arraylen(arFormatos)>
						<cfset LvarFormato = trim(arFormatos[i])>
						<cfif isdefined("arguments.rs"&trim(arDesplegar[i]))>
							<cfset LvarFormatoCombo = LvarFormato>
							<cfset LvarFormato = "C"><!--- Formato Combo --->
						</cfif>
						<cfswitch expression="#LvarFormato#">
							<cfcase value="C">
								<cfswitch expression="#LvarFormatoCombo#">
									<cfcase value="D,DI">
										and <cf_dbfunction name="to_datechar" args="#PreserveSingleQuotes(x)#" datasource="#Conexion#"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(temp_value)#">
									</cfcase>
									<cfcase value="M,P,R,N,F,I">
										and #PreserveSingleQuotes(x)# = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(trim(temp_value), ',', '','all')#">
									</cfcase>
									<cfdefaultcase>
										and upper(rtrim(<cf_dbfunction name="to_char" args="#PreserveSingleQuotes(x)#" datasource="#Conexion#">)) =  <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(temp_value))#">
									</cfdefaultcase>
								</cfswitch>
							</cfcase>
							<cfcase value="D,DI">
								and <cf_dbfunction name="to_datechar" args="#PreserveSingleQuotes(x)#" datasource="#Conexion#"> <cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>>=<cfelse>=</cfif> <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(temp_value)#">
							</cfcase>
							<cfcase value="I">
								and #PreserveSingleQuotes(x)# >= <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(trim(temp_value), ',', '','all')#">
							</cfcase>
							<cfcase value="M,P,R,N,F">
								and #PreserveSingleQuotes(x)# >= <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(trim(temp_value), ',', '','all')#">
							</cfcase>
							<cfcase value="S">
								and upper(#PreserveSingleQuotes(x)#) like  <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(temp_value))#%">
							</cfcase>
							<cfdefaultcase>
								and upper(rtrim(<cf_dbfunction name="to_char" args="#PreserveSingleQuotes(x)#" datasource="#Conexion#">)) like  <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(temp_value))#%">
							</cfdefaultcase>
						</cfswitch>
					<cfelse>
						and upper(rtrim(<cf_dbfunction name="to_char" args="#PreserveSingleQuotes(x)#" datasource="#Conexion#">)) like  <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(temp_value))#%">
					</cfif>
				</cfif>
			</cfloop>
			<cfif Len(Trim(filtro))>
				and #PreserveSingleQuotes(filtro)#
			</cfif>
			
			<cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>
				<cfset tempPos=ListContainsNoCase(Arguments.Navegacion,"Filtro_FechasMayores=","&")>
				<cfif tempPos NEQ 0>
				  <cfset Arguments.Navegacion=ListDeleteAt(Arguments.Navegacion,tempPos,"&")>
				</cfif>
				<cfset Arguments.Navegacion=ListAppend(Arguments.Navegacion,"Filtro_FechasMayores=1","&")>
			</cfif>
			<cfif debug EQ "S">			
				<cfabort>
			</cfif>	
		</cfquery>
	<cfelse>
		<!--- QUERY --->
		<cfset sql = "select " & columnas & " from " & tabla & " where 1 = 1">
		<cfquery name="rsLista" result="rsResult" datasource="#Conexion#" maxrows="#LvarMaxRowsQuery#">
			#PreserveSingleQuotes(sql)#	
			<cfif Len(Trim(filtro))>
			 and #PreserveSingleQuotes(filtro)#	
			</cfif>
		</cfquery>
		<cfif debug EQ "S">			
			<cfoutput>#sql#<br><br> Columnas --> #rsLista.columnList#<br></cfoutput>
		</cfif>
	</cfif>
	<cfset LvarUsaAJAX = NOT filtrar_automatico>

	<cfinvoke 
		 component="pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		 	<cfinvokeargument name="usaAJAX" value="#LvarUsaAJAX#">
		 	<cfinvokeargument name="query" value="#rsLista#">
		 	<cfinvokeargument name="queryResult" value="#rsResult#">
		 	<cfinvokeargument name="conexion" value="#Arguments.conexion#">

		 	<cfinvokeargument name="desplegar" value="#Arguments.desplegar#">
		 	<cfinvokeargument name="etiquetas" value="#Arguments.etiquetas#">
		 	<cfinvokeargument name="formatos" value="#Arguments.formatos#">
		 	<cfinvokeargument name="align" value="#Arguments.align#">
		 	<cfinvokeargument name="ajustar" value="#Arguments.ajustar#">
		 	<cfinvokeargument name="irA" value="#Arguments.irA#">
		 	<cfinvokeargument name="checkboxes" value="#Arguments.checkboxes#">
		 	<cfinvokeargument name="checkall" value="#Arguments.checkall#">
			<cfinvokeargument name="chkcortes" value="#Arguments.chkcortes#">
			<cfinvokeargument name="keycorte" value="#Arguments.keycorte#">		
		 	<cfinvokeargument name="lineaRoja" value="#Arguments.lineaRoja#">
		 	<cfinvokeargument name="lineaVerde" value="#Arguments.lineaVerde#">
		 	<cfinvokeargument name="lineaAzul" value="#Arguments.lineaAzul#">
		 	<cfinvokeargument name="radios" value="#Arguments.radios#">
		 	<cfinvokeargument name="MaxRows" value="#Arguments.MaxRows#">
			<cfinvokeargument name="MaxRowsQuery" value="#Arguments.MaxRowsQuery#">
		 	<cfinvokeargument name="Cortes" value="#Arguments.Cortes#">
		 	<cfinvokeargument name="navegacion" value="#Arguments.navegacion#">
		 	<cfinvokeargument name="botones" value="#Arguments.botones#">
		 	<cfinvokeargument name="incluyeForm" value="#Arguments.incluyeForm#">
		 	<cfinvokeargument name="formName" value="#Arguments.formName#">
		 	<cfinvokeargument name="formAttr" value="#Arguments.formAttr#">
		 	<cfinvokeargument name="keys" value="#Arguments.keys#">
		 	<cfinvokeargument name="checkedcol" value="#Arguments.checkedcol#">
		 	<cfinvokeargument name="inactivecol" value="#Arguments.inactivecol#">
		 	<cfinvokeargument name="funcion" value="#Arguments.funcion#">
		 	<cfinvokeargument name="fparams" value="#Arguments.fparams#">
		 	<cfinvokeargument name="showLink" value="#Arguments.showLink#">
		 	<cfinvokeargument name="showEmptyListMsg" value="#Arguments.showEmptyListMsg#">
		 	<cfinvokeargument name="EmptyListMsg" value="#Arguments.EmptyListMsg#">
		 	<cfinvokeargument name="PageIndex" value="#Arguments.PageIndex#">
			<cfinvokeargument name="totales" value="#Arguments.totales#">
			<cfinvokeargument name="totalgenerales" value="#Arguments.totalgenerales#">
			<cfinvokeargument name="pasarTotales" value="#Arguments.pasarTotales#">
			<cfinvokeargument name="form_method" value="#Arguments.form_method#">
			<cfinvokeargument name="checkbox_function" value="#Arguments.checkbox_function#">
			<cfinvokeargument name="mostrar_filtro" value="#Arguments.mostrar_filtro#">
			<cfinvokeargument name="filtro_nuevo" value="#Arguments.filtro_nuevo#">
			<cfinvokeargument name="fontsize" value="#Arguments.fontsize#">
			<cfinvokeargument name="width" value="#Arguments.width#">
			<cfinvokeargument name="finReporte" value="#Arguments.finReporte#">
			<cfinvokeargument name="QueryString_lista" value="#Arguments.QueryString_lista#">
			<cfinvokeargument name="alternar" value="#Arguments.alternar#">
			<cfinvokeargument name="FilasParaBotonesSuperiores" value="#Arguments.FilasParaBotonesSuperiores#">
			<cfloop index = "ColumnName" list = "#Arguments.desplegar#"> 
				<cfif isdefined("arguments.rs#trim(ColumnName)#")>
					<cfinvokeargument name="rs#trim(ColumnName)#" value="#Evaluate('arguments.rs#trim(ColumnName)#')#">
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif IsDefined('pListaRet')>
			<cfreturn pListaRet>
		<cfelse>
			<cfreturn ''>
		</cfif>
	<!--- fin del procesamiento del query --->
</cffunction>

<cffunction name="pListaQuery" access="public" returntype="string" output="true">
	<cfargument name="usaAJAX" type="boolean" required="no">
	<cfargument name="query" type="query" required="yes"><!--- Datos por desplegar --->
	<cfargument name="queryResult" type="struct" required="no"><!--- SQL por desplegar --->
	<cfargument name="Conexion" type="string" required="false" default="">
	<cfargument name="desplegar" type="string" required="true" default="<!--- Columnas a desplegar en la Lista--->">
	<cfargument name="etiquetas" type="string" required="true" default="<!--- Título de las columnas --->">
	<cfargument name="formatos" type="string" required="true" default="<!--- Formato para cada columna (M,D,I,N,F)--->">
	<cfargument name="lineaRoja" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="lineaAzul" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="lineaVerde" type="string" required="false" default=""> <!--- Condicion --->
	<cfargument name="align" type="string" required="true" default="<!--- Tipo de Justiticación (left, center, right, justify) --->">
	<cfargument name="ajustar" type="string" required="true" default="S<!--- Ajusta la columna (S,N)--->">
	<cfargument name="irA" type="string" required="true" default="_self">
	<cfargument name="checkboxes" type="string" required="false" default="N">
	<cfargument name="checkall" type="string" required="false" default="N">
	<cfargument name="chkcortes" type="string" required="false" default="N"><!--- Para cuando se realizan cortes con checks en el corte (padre) y los detalles por corte (hijos) --->
	<cfargument name="keycorte" type="string" required="false" default=""><!--- Llave del corte (padre) para cuando se realizan cortes con checks --->
	<cfargument name="radios" type="string" required="false" default="N">
	<cfargument name="MaxRows" type="numeric" required="false" default="20">
	<cfargument name="MaxRowsQuery" type="numeric" required="false" default="0">
	<cfargument name="Cortes" type="string" required="false" default="">
	<cfargument name="navegacion" type="string" required="false" default="">
	<cfargument name="botones" type="string" required="false" default="">
	<cfargument name="incluyeForm" type="string" required="false" default="true">
	<cfargument name="formName" type="string" required="false" default="lista">
	<cfargument name="formAttr" type="string" required="false" default="">
	<cfargument name="keys" type="string" required="false" default=""><!--- Para cuando existe cortes con checks tambi[en se utiliza este parametro para especificar el valor que van a contener los checks hijos --->
	<cfargument name="checkedcol" type="string" required="false" default="">
	<cfargument name="inactivecol" type="string" required="false" default="">
	<cfargument name="funcion" type="string" required="false" default="">
	<cfargument name="fparams" type="string" required="false" default="">
	<cfargument name="showLink" type="boolean" required="false" default="true">
	<cfargument name="showEmptyListMsg" type="boolean" required="false" default="false">
	<cfargument name="EmptyListMsg" type="string" required="false" default="--- #LB_NoSeEncontraronRegistros#---">
	<cfargument name="PageIndex" type="string" required="false" default="">
	<cfargument name="totales" type="string" required="false" default="" hint="Columnas por totalizar">
	<cfargument name="totalgenerales" type="string" required="false" default="" hint="Columnas para totales generales">
	<cfargument name="pasarTotales" type="string" required="false" default="" hint="Totales a Pasar a las columnas indicadas">
	<cfargument name="form_method" type="string" required="false" default="post" hint="Metodo para el form: GET o POST">
	<cfargument name="checkbox_function" type="string" required="false" default="" hint="Funcion para el checkbox o radio">
	<cfargument name="mostrar_filtro" type="boolean" required="false" default="false" hint="Mostrar cajas de filtro">
	<cfargument name="filtro_nuevo" type="boolean" required="false" default="false" hint="Filtró de nuevo el ususario">
	<cfargument name="fontsize" type="string" default="" required="no">
	<cfargument name="width" type="string" default="" required="false">
	<cfargument name="finReporte" type="string" default="" required="false">
	<cfargument name="QueryString_lista" type="string" default="" required="false">
	<cfargument name="alternar" type="boolean" default="true" required="false">
	<cfargument name="debug" type="string" default="N" required="false">
	<cfargument name="FilasParaBotonesSuperiores" type="numeric" default="25" required="no">
	<!--- **************************************************************************************** --->
	<cfset var LvarReturn = Arguments.query.recordCount>	
	<!--- Establece si usaAJAX:
		En desarrollo va a haber un default de true, pero fallarían los que usan un datasource diferente a #dsn#
		Si se indica usaAJAX=yes es requerido atributo Conexion (y en coldfusion 7, el atributo resultQuery).
	 --->
	<cfif isdefined("Arguments.usaAJAX")>
		<cfif Arguments.usaAJAX AND Arguments.conexion EQ "">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_jPlistas1"
			Default="Plistasquery con usaAJAX requiere atributo Conexion"
			returnvariable="LB_jPlistas1"/> 
			<cf_throw message="#LB_jPlistas1#" errorCode="12040">
		</cfif>
		<cfset LvarVerificarQueryResult = true>
	<cfelse>
		<cf_navegacion name="usaAJAX" session="PlistasAJX" default="#CGI.SERVER_NAME EQ "localhost" OR CGI.SERVER_NAME EQ "desarrollo"#">
		<cfset Arguments.usaAJAX = session.navegacion.PlistasAJX.usaAJAX>
		<cfif Arguments.usaAJAX AND Arguments.conexion EQ "">
			<cfset Arguments.conexion = #session.dsn#>
		</cfif>
	</cfif>
	<cfif Arguments.usaAJAX>
		<cfif isdefined("Arguments.queryResult")>
			<cfset LvarMD = Arguments.queryResult>
		<cfelse>
			<cftry>
				<cfset LvarMD = Arguments.query.getMetaData().getExtendedMetaData()>
				<cfset Arguments.queryResult = LvarMD>
			<cfcatch type="any">
				<cfif isdefined("LvarVerificarQueryResult")>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_jPlistas2"
					Default="listasquery con usaAJAX requiere atributo queryResult en Colfusion 7"
					returnvariable="LB_jPlistas2"/> 
					<cf_throw message="#LB_jPlistas2#" errorCode="12045">
				</cfif>
				<cfset Arguments.usaAJAX = false>
			</cfcatch>
			</cftry>
		</cfif>
	</cfif>
	<cfset LvarExpiraInactivos_Min = 30>
	<cfparam name="request.Plistas" default=",">
	<cfset Arguments.PageIndex = trim(Arguments.PageIndex)>
	<cfif find(",Plista_#Arguments.PageIndex#", request.Plistas)>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_jPlistas3"
		Default="Argumento PageIndex debe ser único por REQUEST: 'Arguments.PageIndex'"
		returnvariable="LB_jPlistas3"/> 
		<cf_throw message="#LB_jPlistas3#" errorCode="12050">
		<cfset request.Plistas = request.Plistas & "Plista_#Arguments.PageIndex#,">
	</cfif>
	<cfset request.Plista_server 			= structNew()>
	<cfset request.Plista_server.parametros	= arguments>
	<cfset request.Plista_server.rsSQL		= arguments.query>
	<cfset structdelete(request.Plista_server.Parametros,"query")>
	<cfif isdefined("Form.Pagina#arguments.PageIndex#") and Len(Trim(Form["Pagina"&arguments.PageIndex]))>
		<cfset PageNum_lista = Form['Pagina'&arguments.PageIndex]>
	<cfelseif isdefined("Url.Pagina#arguments.PageIndex#") and Len(Trim(Url["Pagina"&arguments.PageIndex]))>
		<cfset PageNum_lista = Url['Pagina'&arguments.PageIndex]>
	<cfelseif isdefined("Form.PageNum_lista#arguments.PageIndex#") and Len(Trim(Form["PageNum_lista"&arguments.PageIndex]))>
		<cfset PageNum_lista = Form['PageNum_lista'&arguments.PageIndex]>
	<cfelseif isdefined("Url.PageNum_lista#arguments.PageIndex#") and Len(Trim(Url["PageNum_lista"&arguments.PageIndex]))>
		<cfset PageNum_lista = Url['PageNum_lista'&arguments.PageIndex]>
	<cfelseif isdefined("Form.PageNum#arguments.PageIndex#") and Len(Trim(Form["PageNum"&arguments.PageIndex]))>
		<cfset PageNum_lista = Form['PageNum'&arguments.PageIndex]>
	<cfelseif isdefined("Url.PageNum#arguments.PageIndex#") and Len(Trim(Url["PageNum"&arguments.PageIndex]))>
		<cfset PageNum_lista = Url['PageNum'&arguments.PageIndex]>
	<cfelse>
		<cfset PageNum_lista = 1>
	</cfif>
	<cfif Arguments.usaAJAX>
		<cfif NOT isdefined("request.Plista_AJAX")>
			<script type='text/javascript'>_ajaxConfig = {'_cfscriptLocation':'/cfmx/commons/Componentes/pListasAJX.cfc', '_jsscriptFolder':'/cfmx/commons/Componentes/ajax_js'};</script>
			<script type='text/javascript' src='/cfmx/commons/Componentes/ajax_js/ajax.js'></script>
			<script language="javascript">
				<cfset LvarMiliseg = int((LvarExpiraInactivos_Min-2)/2 * 60000)>
				var Plistas_conAjax = "", Plistas_conAjaxTS = new Date().getTime();
				setTimeout ("fnPlistas_conAjax(true);",#LvarMiliseg#);
				function fnPlistas_conAjax(Automatic)
				{
					LvarNow = new Date().getTime();
					if (LvarNow - Plistas_conAjaxTS >= #LvarMiliseg#)
					{
						document.getElementById("ifrPlistas_conAjax").src = "/cfmx/commons/Componentes/pListasAJX.cfc?METHOD=updateTS&IDs=" + escape(Plistas_conAjax);
						Plistas_conAjaxTS = LvarNow;
						LvarEspera = #LvarMiliseg#;
					}
					else
						LvarEspera = #LvarMiliseg# - (LvarNow - Plistas_conAjaxTS);
					setTimeout ("fnPlistas_conAjax(true);", LvarEspera);
				}
			</script>
			<iframe id="ifrPlistas_conAjax" frameborder="0" width="0" height="0"></iframe>
			<cfset request.Plista_AJAX = true>
		</cfif>
		<cfset LvarPlistaID	= fnGuardarQuery(Arguments, LvarMD)>
		<cfinvoke component="pListasAJX" method="doQuery" returnvariable="CodGenerado">
			<cfinvokeargument name="IDs"		value="-1|-1">
			<cfinvokeargument name="PageNum"	value="#PageNum_lista#">
		</cfinvoke>
		<script type="text/javascript">
			<cfoutput>
			Plistas_conAjax += '#LvarPlistaID#,'
			var pagina_Plista#Arguments.PageIndex# = 0;
			function doQuery_Plista#Arguments.PageIndex#(PlistaPage)
			{
				// send data to CF
				pagina_Plista#Arguments.PageIndex# = PlistaPage;
				DWRUtil.useLoadingMessage();
				DWREngine._execute(_ajaxConfig._cfscriptLocation, null, 'doQuery', '#LvarPlistaID#|'+Plistas_conAjax , PlistaPage, doQueryResults_Plista#Arguments.PageIndex#);
				// /cfmx/commons/Componentes/pListasAJX.cfc?METHOD=doQuery&IDs=#LvarPlistaID#|#LvarPlistaID#,
			}
	
			// call back function
			function doQueryResults_Plista#Arguments.PageIndex# (html) {
				Plistas_conAjaxTS = new Date().getTime();
				try{
					$('div_Plista#Arguments.PageIndex#').innerHTML = html;
				} catch (e) {
					html = html.replace(/<form /g, "<label "); 
					html = html.replace(/<\/form>/g, "</label>"); 
					$('div_Plista#Arguments.PageIndex#').innerHTML = html;
				}

				if (document.#Arguments.formName#)
				{
					if (document.#Arguments.formName#.Pagina#Arguments.PageIndex#)
						document.#Arguments.formName#.Pagina#Arguments.PageIndex#.value = pagina_Plista#Arguments.PageIndex#;
					if (document.#Arguments.formName#.PageNum_lista#Arguments.PageIndex#)
						document.#Arguments.formName#.PageNum_lista#Arguments.PageIndex#.value = pagina_Plista#Arguments.PageIndex#;
					if (document.#Arguments.formName#.PageNum#Arguments.PageIndex#)
						document.#Arguments.formName#.PageNum#Arguments.PageIndex#.value = pagina_Plista#Arguments.PageIndex#;
				}
			}
			</cfoutput>
		</script>
		<table width="100%">
			<tr><td><div id="div_Plista#Arguments.PageIndex#"><cfoutput>#CodGenerado#</cfoutput></div></td></tr>	
		</table>
	<cfelse>
		<cfinvoke component="pListasAJX" method="doQuery" returnvariable="CodGenerado">
			<cfinvokeargument name="IDs"			value="-1|-1">
			<cfinvokeargument name="PageNum"	value="#PageNum_lista#">
		</cfinvoke>
		<cfoutput>#CodGenerado#</cfoutput>
	</cfif>
	<cfreturn LvarReturn>	
</cffunction>	
<!--- **************************************************************************************** --->

<cffunction name="ListFindNoCaseNoSpace" returntype="numeric" output="no">
	<cfargument name="List" required="yes">
	<cfargument name="Value" required="yes">
	<cfargument name="Delimiters" required="no" default=",">
	<cfset count = 0>
	<cfloop list="#Arguments.List#" index="Item" delimiters="#Arguments.Delimiters#">
		<cfset count = count + 1>
		<cfif trim(lcase(Item)) eq trim(lcase(Arguments.Value))>
			<cfreturn count>
		</cfif>
	</cfloop>
	<cfreturn 0>
</cffunction>

<cffunction name="fnGuardarQuery" returntype="numeric" access="private" output="no">
	<cfargument name="parametros" required="yes">
	<cfargument name="metadata" required="yes">

	<cfset arguments.parametros.query = structNew()>
	<cfset arguments.parametros.query.SQL = fnCompletaSQL(Arguments.metadata)>
<!---
	<cfset LvarParametrosJSON = createobject("component","sif.rh.Componentes.json").encode(arguments.parametros)>
--->	
	<cfwddx action="cfml2wddx" input="#arguments.parametros#" output="LvarParametrosJSON">
	<cflock scope="application" throwontimeout="yes" timeout="5000">
		<cfparam name="server.plista_timestamp" default="0">
		<cfset LvarTiempo			= structNew()>
		<cfset LvarTiempo.Nuevo		= fnNow()>
		<cfset LvarTiempo.Espera	= LvarExpiraInactivos_Min>
		<cfset LvarTiempo.Viejos	= dateadd("n", -LvarTiempo.Espera, LvarTiempo.Nuevo)>
		<cfset LvarTiempo.Anterior	= server.plista_timestamp>

		<cfif datediff("n", server.plista_timestamp, LvarTiempo.Nuevo) GTE LvarTiempo.Espera>
			<cfset fnBorrarQueries(LvarTiempo.Viejos)>
			<cfset server.plista_timestamp = LvarTiempo.Nuevo>
			<cfset server.plista_timestamp_ajuste = 0>
		</cfif>
		<cfquery name="rsSQL" datasource="sifcontrol">
			INSERT INTO Plista 
			(
				PlistaPRM, PlistaTS, Usucodigo
			) 
			VALUES 
			(
				 <cfqueryparam cfsqltype="cf_sql_clob" value="#LvarParametrosJSON#">
				,{fn Now()}
				,#session.Usucodigo#
			)
			<cf_dbidentity1 name="rsSQL" datasource="sifcontrol" returnvariable="LvarID" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 name="rsSQL" datasource="sifcontrol" returnvariable="LvarID" verificar_transaccion="no">
	</cflock>

	<cfreturn LvarID>
</cffunction>

<cffunction name="fnNow" output="no">
	<cfparam name="server.plista_timestamp_ajuste" default="0">
	<cfif server.plista_timestamp_ajuste EQ 0>
		<cfquery name="rsSQL" datasource="sifcontrol">
			SELECT <cf_dbfunction name="now" datasource="sifcontrol"> as now 
			<cfif application.dsinfo.sifcontrol.type EQ "oracle" or application.dsinfo.sifcontrol.type EQ "db2">
			FROM DUAL
			</cfif>
		</cfquery>
		<cfset server.plista_timestamp_ajuste = datediff("s",now(),rsSQL.now)>
	</cfif>
	<cfset LvarNow = dateadd("s",server.plista_timestamp_ajuste,now())>
	<cfreturn LvarNow>
</cffunction>

<cffunction name="fnBorrarQueries" returntype="void" access="private" output="no">
	<cfargument name="viejos" required="yes" type="date">
	
	<cftry>
		<cfquery datasource="sifcontrol">
			DELETE FROM Plista 
			 WHERE PlistaTS <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Viejos#">
		</cfquery>
	<cfcatch type="database">
		<cf_dbtemp temp="false" name="Plista" datasource="sifcontrol">
			<cf_dbtempcol name="PlistaID"	type="numeric(18,0)"	mandatory="true" identity="true">
			<cf_dbtempcol name="PlistaPRM"	type="text" 			mandatory="true">
			<cf_dbtempcol name="Usucodigo"	type="numeric(18,0)"	mandatory="true">
			<cf_dbtempcol name="PlistaTS"	type="datetime"			mandatory="true">
			<cf_dbtempkey cols="PlistaID">
		</cf_dbtemp>
		<cfquery name="rsSQL" datasource="asp">
			select count(1) as cantidad
			  FROM SComponentes
			 WHERE SScodigo	= 'sys'
			   AND SMcodigo	= 'public'
			   AND SPcodigo	= 'tags'
			   AND SCuri	= '/commons/Componentes/pListasAJX.cfc'
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfquery name="rsSQL" datasource="asp">
				insert into SComponentes 
					(SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
				values ('sys', 'public', 'tags', '/commons/Componentes/pListasAJX.cfc', 'P', 0, {fn Now()}, 1)
			</cfquery>
			<cfquery name="rsSQL" datasource="asp">
				insert into SComponentes 
					(SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
				values ('sys', 'public', 'tags', '/commons/Componentes/ajax.cfc', 'P', 0, {fn Now()}, 1)
			</cfquery>
		</cfif>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnCompletaSQL" returntype="string" access="private" output="no">
	<cfargument name="metaData" required="yes">
	<cfif isdefined("Arguments.metaData.SQLParameters")>
		<cfset LvarSQL = Arguments.metaData.SQL>
		<cfset LvarSQL1 = "">
		<cfset LvarPRMs = Arguments.metaData.SQLParameters>
		<cfset LvarPOSant = 0>
		<cfloop index="i" from="1" to="#arrayLen(LvarPRMs)#">
			<cfset LvarPRMtype = LvarPRMs[i].getClass().getName()>
			<cfset LvarPOS = fnSiguientePRM()>
			<cfset LvarSQL1 = LvarSQL1 & mid(LvarSQL,LvarPOSant+1,LvarPOS-LvarPOSant-1)>
			<cfif LvarPRMtype EQ "java.lang.String">
				<cfset LvarSQL1 = LvarSQL1 & "'" & replace(LvarPRMs[i],"'","''","ALL") & "'">
			<cfelseif LvarPRMtype EQ "java.lang.Boolean">
				<cfif LvarPRMs[i]>
					<cfset LvarSQL1 = LvarSQL1 & "1">
				<cfelse>
					<cfset LvarSQL1 = LvarSQL1 & "0">
				</cfif>
			<cfelseif find(LvarPRMtype, "java.lang.Long,java.math.BigDecimal,java.lang.Double,java.lang.Integer,java.lang.Float")>
				<cfset LvarSQL1 = LvarSQL1 & LvarPRMs[i]>
			<cfelseif LvarPRMtype EQ "java.sql.Date">
				<cfset LvarSQL1 = LvarSQL1 & createODBCdate(LvarPRMs[i])>
			<cfelseif LvarPRMtype EQ "java.sql.Time">
				<cfset LvarSQL1 = LvarSQL1 & createODBCtime(LvarPRMs[i])>
			<cfelseif LvarPRMtype EQ "java.sql.Timestamp">
				<cfset LvarSQL1 = LvarSQL1 & createODBCdatetime(LvarPRMs[i])>
			<cfelseif LvarPRMtype EQ "[B">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_jPlistas4"
				Default="No se permiten datos binarios"
				returnvariable="LB_jPlistas4"/> 
				<cf_throw message="#LB_jPlistas4#" errorCode="12055">
				
			</cfif>
			<cfset LvarPOSant = LvarPOS>
		</cfloop>
		<cfset LvarLEN = len(LvarSQL)>
		<cfif LvarPOSant LT LvarLEN>
			<cfset LvarSQL1 = LvarSQL1 & mid(LvarSQL,LvarPOSant+1,LvarLEN)>
		</cfif>
		<cfreturn LvarSQL1>
	<cfelse>
		<cfreturn Arguments.metaData.SQL>
	</cfif>
</cffunction>

<cffunction name="fnSiguientePRM" returntype="string" access="private" output="no">
	<cfset var LvarPos = 0>
	<cfset var LvarPos0 = LvarPOSant>
	<cfset var LvarPos1 = 0>
	<cfset var LvarPos2 = 0>
	<cfloop condition = "true">
		<cfset LvarPos  = find("?", LvarSQL,LvarPOS0+1)>
		<cfset LvarPos1 = find("'", LvarSQL,LvarPOS0+1)>
		<cfset LvarPos2 = find("'", LvarSQL,LvarPOS1+1)>
		<cfif LvarPos EQ 0 OR LvarPos LT LvarPos1 OR LvarPos GT LvarPos2>
			<cfbreak>
		</cfif>
		<cfset LvarPOS0 = LvarPos2>
	</cfloop>
	<cfreturn LvarPos>
</cffunction>
</cfcomponent>

<!---
# type class value sqltype 
1 IN java.lang.Long 1 cf_sql_bigint   
2 IN java.lang.Boolean true cf_sql_bit   
3 IN java.lang.String 1 cf_sql_char   
4 IN java.sql.Date 1899-12-31 cf_sql_date   
5 IN java.math.BigDecimal 1 cf_sql_decimal , scale='0' 
6 IN java.lang.Double 1.0 cf_sql_double   
7 IN java.lang.Double 1.0 cf_sql_float   
8 IN java.lang.Integer 1 cf_sql_integer   
9 IN java.lang.String 1 cf_sql_longvarchar   
10 IN java.lang.Double 1.0 cf_sql_money   
11 IN java.lang.Double 1.0 cf_sql_money4   
12 IN java.math.BigDecimal 1 cf_sql_numeric , scale='0' 
13 IN java.lang.Float 1.0 cf_sql_real   
14 IN java.lang.Integer 1 cf_sql_smallint   
15 IN java.sql.Time 00:00:00 cf_sql_time   
16 IN java.sql.Timestamp 1899-12-31 00:00:00.0 cf_sql_timestamp   
17 IN java.lang.Integer 1 cf_sql_tinyint   
18 IN java.lang.String 1 cf_sql_varchar   
19 IN [B [B@2b1108 cf_sql_binary   
20 IN [B [B@16b296f cf_sql_varbinary   
21 IN [B [B@6d3f58 cf_sql_blob   
22 IN java.lang.String 1 cf_sql_clob   
--->
