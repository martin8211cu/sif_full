<!--- Componente de Listas --->
<cfcomponent>
<cfif Not IsDefined('Request.HEAD_PLISTA1_JS')>
	<cfset Request.HEAD_PLISTA1_JS = true>
	<script type="text/javascript" language="JavaScript" src="/cfmx/rh/Reclutamiento/curriculumExterno/js/pLista1.js"></script>
</cfif>
<cf_templatecss />

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_NoSeEncontraronRegistros"
Default="No se encontraron Registros "
XmlFile="/rh/generales.xml"
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
	<cfargument name="alternar" type="boolean" default="yes" required="yes">
	<cfargument name="filtro_nuevo" type="boolean" default="no" required="no">
	<cfargument name="fontsize" type="string" default="" required="no">
	<cfargument name="FilasParaBotonesSuperiores" type="numeric" default="25" required="no">
	<!--- modificado: danim, 14-oct-2005, agregar parametro 'alternar', default=yes
		alternar indica si se deben alternar los colores de la lista o no. --->

	<cfif mostrar_filtro and filtrar_automatico>
	<!--- FILTRO AUTOMATICO --->
		
		<cfquery name="rsLista" datasource="#Conexion#">
			
			<cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount1 rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>
			
			select #PreserveSingleQuotes(columnas)#
			from #PreserveSingleQuotes(tabla)#
			where 1=1
	
    		<cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount2_a rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>
			
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
			
			<cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount2_b rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>

		</cfquery>
		
	<cfelse>
		
		<!--- QUERY --->
		<cfset sql = "select " & columnas & " from " & tabla & " where 1 = 1">
        
		<cfquery name="rsLista" datasource="#Conexion#">
			<cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount1 rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>
			#PreserveSingleQuotes(sql)#	
            <cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount2_a rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>
			<cfif Len(Trim(filtro))>
			 and #PreserveSingleQuotes(filtro)#	
			</cfif>
            <cfif Arguments.MaxRowsQuery GT 0>
			<cf_dbrowcount2_b rows="#Arguments.MaxRowsQuery#" datasource="#Conexion#">
			</cfif>
		</cfquery>
		
		<cfif debug EQ "S">			
			<cfoutput>#sql#<br><br> Columnas --> #rsLista.columnList#<br></cfoutput>
		</cfif>
		
	</cfif>

	<cfinvoke 
		 component="pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		 	<cfinvokeargument name="query" value="#rsLista#">
		 	<cfinvokeargument name="desplegar" value="#Arguments.desplegar#">
		 	<cfinvokeargument name="etiquetas" value="#Arguments.etiquetas#">
		 	<cfinvokeargument name="formatos" value="#Arguments.formatos#">
		 	<cfinvokeargument name="align" value="#Arguments.align#">
		 	<cfinvokeargument name="ajustar" value="#Arguments.ajustar#">
		 	<cfinvokeargument name="irA" value="#Arguments.irA#">
		 	<cfinvokeargument name="checkboxes" value="#Arguments.checkboxes#">
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
	<cfargument name="query" type="query" required="yes"><!--- Datos por desplegar --->
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
	<cfargument name="alternar" type="boolean" default="yes" required="false">
	<cfargument name="debug" type="string" default="N" required="false">
	<cfargument name="FilasParaBotonesSuperiores" type="numeric" default="25" required="no">

	<cfif (lcase(debug) eq 's')>
		<cfdump var="#query#">
	</cfif>

	<cfif incluyeForm><cfoutput><form style="margin:0" action="#irA#" method="#Arguments.form_method#" name="#formName#" id="#formName#" #Arguments.formAttr#></cfoutput></cfif>
	<input type="hidden" name="modo" value="ALTA">
	<input name="columnas" type="hidden" value="<cfoutput>#Trim(Arguments.query.ColumnList)#</cfoutput>" disabled><!--- no enviar este dato --->
	<input name="Ecodigo" type="hidden" value="<cfif isdefined('Session.Ecodigo')><cfoutput>#Session.Ecodigo#</cfoutput></cfif>">
	<cfset columnas=ListtoArray(ucase(Arguments.query.columnList),",")>
	<cfset vis=ListtoArray(desplegar,",")>
	<cfset Longitud=ArrayLen(columnas)>
	<cfset colsp=ListLen(desplegar)>
	<!--- Para los formatos --->
	<cfif Len(Trim(formatos))>
		<cfset fmt=ListtoArray(formatos, ',')>
	</cfif>
	<!--- Para la Justificacion de Columnas --->
	<cfset alin=ListtoArray(align,",")>
	
	<!--- Para llevar los totales --->
	<cfset total_acumulado = StructNew()>
	<cfloop list="#Arguments.totales#" index="columna_para_total">
		<cfset total_acumulado[Trim(columna_para_total)] = 0>
	</cfloop>
	<cfif len(trim(Arguments.pasarTotales))>
		<cfset pTotales = structNew()>
		<cfset misTotales = ListToArray(Arguments.pasarTotales)>
		<cfset iconsec = 1>
		<cfloop list="#Arguments.totales#" index="columna_para_total">
			<cfset pTotales[Trim(columna_para_total)] = misTotales[iconsec]>
			<cfset iconsec = iconsec + 1>
		</cfloop>
	</cfif>

	<!--- Variables para controlar la cantidad de items a desplegar --->
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfif isdefined("Form.Pagina#PageIndex#") and Len(Trim(Form["Pagina"&PageIndex]))>
		<cfset PageNum_lista = Form['Pagina'&PageIndex]>
	<cfelseif isdefined("Url.Pagina#PageIndex#") and Len(Trim(Url["Pagina"&PageIndex]))>
		<cfset PageNum_lista = Url['Pagina'&PageIndex]>
	<cfelseif isdefined("Form.PageNum_lista#PageIndex#") and Len(Trim(Form["PageNum_lista"&PageIndex]))>
		<cfset PageNum_lista = Form['PageNum_lista'&PageIndex]>
	<cfelseif isdefined("Url.PageNum_lista#PageIndex#") and Len(Trim(Url["PageNum_lista"&PageIndex]))>
		<cfset PageNum_lista = Url['PageNum_lista'&PageIndex]>
	<cfelseif isdefined("Form.PageNum#PageIndex#") and Len(Trim(Form["PageNum"&PageIndex]))>
		<cfset PageNum_lista = Form['PageNum'&PageIndex]>
	<cfelseif isdefined("Url.PageNum#PageIndex#") and Len(Trim(Url["PageNum"&PageIndex]))>
		<cfset PageNum_lista = Url['PageNum'&PageIndex]>
	<cfelse>
		<cfset PageNum_lista = 1>
	</cfif>
	<cfoutput>
	</cfoutput>
	<cfif Arguments.filtro_nuevo>
		<cfset PageNum_lista = 1>
	</cfif>
	<cfif PageNum_lista LT 1>
		<cfset PageNum_lista = 1>
	</cfif>
	
	<cfif MaxRows LT 1>
		<cfset MaxRows = Arguments.query.RecordCount>
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows_lista = 1>
	<cfelse>
		<cfset MaxRows_lista = MaxRows>
	</cfif>
	<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(Arguments.query.RecordCount,1))>		
	<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,Arguments.query.RecordCount)>
	<cfset TotalPages_lista = Ceiling(Arguments.query.RecordCount/MaxRows_lista)>
	<cfif len(Trim(Arguments.QueryString_lista)) GT 0>
		<cfset QueryString_lista='&'&Arguments.QueryString_lista>
	<cfelseif Len(Trim(CGI.QUERY_STRING)) GT 0>
		<cfset QueryString_lista='&'&CGI.QUERY_STRING>
	<cfelse>
		<cfset QueryString_lista="">
	</cfif>
	<!---
	<BR><strong>ANTES</strong><BR>
	<cfdump var="#QueryString_lista#">
	--->
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista#PageIndex#=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>
	<cfif Len(Trim(navegacion)) NEQ 0>
		<cfset nav = ListToArray(navegacion, "&")>
		<!---<cfset QueryString_lista = "">--->
		<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
			<cfset tempkey = ListGetAt(nav[nv], 1, "=")>
			<!--- 
				Solución 1 Quitada el 17 de Nov porque los parámetros de la navegación deben prevalecer sobre los parámetros del
				CGI.Query_String, esto bajo el supuesto de que si el programa que utiliza el componente de listas arma una 
				navegación específica es porque esa es la navegación que mas le interesa.
				<cfset tempPos1 = ListContainsNoCase(QueryString_lista,"?" & tempkey & "=")>
				<cfset tempPos2 = ListContainsNoCase(QueryString_lista,"&" & tempkey & "=")>
				Chequear substrings duplicados en el contenido de la llave para agregar solo si no está en el QueryString			
				<cfif tempPos1 EQ 0 and tempPos2 EQ 0>
				  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
				</cfif>
			--->
			<!--- Solución 2 A. Quita de el QueryString_lista todas las incidencias del item que viene en la navegación --->
			<cfset tempPos=ListContainsNoCase(QueryString_lista,tempkey & "=","&")>
			<cfloop condition="tempPos GT 0">
			  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
			  <cfset tempPos=ListContainsNoCase(QueryString_lista,tempkey & "=","&")>
			</cfloop>
			<!--- Solución 2 B. Siempre Agrega el nuevo item que viene en la Navegacion --->
			<cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
		</cfloop>
	</cfif>
	<!---
	<BR><strong>DESPUES</strong><BR>
	<cfdump var="#QueryString_lista#">
	--->
	<!--- Validaciones Generales del Componente --->
	<cfif ArrayLen(alin) NEQ ListLen(desplegar)	or checkboxes EQ ""	or radios EQ "">
		<cfdump var="#pListaRH#">
		<cfexit>
	</cfif>
	<!--- Depura el arreglo de columnas para quitar los ALIAS--->
	<cfset columnas = ListtoArray(Arguments.query.columnList)>
	<!--- Objetos necesarios para el POST --->
	<cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="<cfoutput>#Trim(columnas[i])#</cfoutput>" type="hidden" value=""></cfloop>
	<!--- Inicio de Tabla --->
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="<cfif Arguments.width NEQ ""><cfoutput>#Arguments.width#</cfoutput><cfelse>100%</cfif>">
	<!--- Etiquetas de Encabezados en la Tabla --->
	<cfif len(trim(etiquetas)) GT 0>
		<cfset arEtiquetas=ListtoArray(etiquetas)>
		<tr>
			<cfif ucase(checkboxes) EQ "S" or ucase(radios) EQ "S" or ucase(chkcortes) EQ "S">
				<td class="tituloListas" align="left" width="1%">
					<cfif ucase(chkcortes) EQ "S" and not Arguments.mostrar_filtro>
						<input type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcChkAll(this);">
					</cfif>
				</td>
			</cfif>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechasMayores"
			Default="Fechas Mayores"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_FechasMayores"/>		
			<cfloop index="i" from="1" to=#ArrayLen(arEtiquetas)#>
				<td class="tituloListas" align="<cfoutput>#Trim(alin[i])#</cfoutput>" valign="bottom">
					<cfif i eq ArrayLen(arEtiquetas) and Arguments.mostrar_filtro and (ListFindNoCaseNoSpace(formatos,'D') gt 0 or ListFindNoCaseNoSpace(formatos,'DI') gt 0)>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0">
							<tr>
								<td><strong>#Trim(arEtiquetas[i])#</strong></td>
								<td width="100%" align="right"><input type="checkbox" name="Filtro_FechasMayores" id="Filtro_FechasMayores" <cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>checked</cfif> style="border:none"></td>
								<td style="font-size:xx-small"><cfoutput>#LB_FechasMayores#</td></cfoutput>
							</tr>
						</table>
					<cfelse>
						<strong <cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>#Trim(arEtiquetas[i])#</strong>
					</cfif>
				</td>
			</cfloop>
			<cfif ucase(checkboxes) EQ "D" or ucase(radios) EQ "D">
				<td class="tituloListas" align="left" width="1%"></td>
			</cfif>
		</tr>
	</cfif>
	
	<!--- Campos de filtro --->
	<cfif len(trim(Arguments.desplegar)) and Arguments.mostrar_filtro>
		<cfset arDesplegar=ListtoArray(Arguments.desplegar)>
		<tr>
			<cfif ucase(checkboxes) EQ "S">
				<td class="tituloListas" align="left" width="1%">
						<input 	type="checkbox" name="chkAllItems" value="1"  style="border:none; background-color:inherit;"
								onclick="javascript: funcFiltroChkAll#formName#(this);"
						>
				</td>
			<cfelseif  ucase(radios) EQ "S">
				<td class="tituloListas" align="left" width="1%"></td>
			</cfif>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
			<cfloop index="i" from="1" to=#ArrayLen(arDesplegar)#>
				<td class="tituloListas" align="<cfoutput>#Trim(alin[i])#</cfoutput>">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0"><tr><td width="100%" align="<cfoutput>#Trim(alin[i])#</cfoutput>">
					<cfset LvarFormato = Trim(fmt[i])>
					<cfif isdefined("arguments.rs"&trim(arDesplegar[i]))>
						<cfset LvarFormato = "C"><!--- Formato Combo --->
						<cfset rsname = HTMLEditFormat("arguments.rs"&trim(arDesplegar[i]))>
						<cfset rstemp = Evaluate(rsname)> 
					</cfif>
					<cfset LvarPto = find(" ",LvarFormato)>
					<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
					<cfif     IsDefined('form.filtro_'&Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(form['filtro_'&Trim(arDesplegar[i])])#">
					<cfelseif IsDefined('url.filtro_' &Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(url ['filtro_'&Trim(arDesplegar[i])])#">
					<cfelse><cfset temp_value="">
					</cfif>
					<cfswitch expression="#LvarFormato#">
						<cfcase value="G,U,UD,UDI,UM,UP,UR,UN,UF,UI,US">
							&nbsp;
						</cfcase>
						<cfcase value="C">
							<select name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" onkeypress="javascript:return filtrar#formName#();">
								<cfloop query="rstemp">
									<option value="#rstemp.value#" <cfif rstemp.value eq temp_value>selected</cfif>>#rstemp.description#</option>
								</cfloop>								
							</select>
							<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
						</cfcase>
						<cfcase value="D,DI">
							<cf_sifcalendario name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#" form="#formName#">
							<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
						</cfcase>
						<cfcase value="M,P,R,N,F,I">
							<cfset decimales = 2>
							<cfif LvarFormato eq 'N' or LvarFormato eq 'F'>
								<cfset decimales = 4>
							</cfif>
							<cfif LvarFormato eq 'I'>
								<cfset decimales = 0>
							</cfif>
							<cfif len(temp_value) eq 0 or not isNumeric(replace(temp_value,',','','all'))><cfset temp_value = ""></cfif>
							<cf_inputNumber name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#replace(temp_value,',','','all')#" form="#formName#" decimales="#decimales#" style="width:100%">
							<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#replace(temp_value,',','','all')#">
						</cfcase>
						<cfdefaultcase>
							<input 	type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
							<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
						</cfdefaultcase>
					</cfswitch>
					</td><cfif i eq ArrayLen(arDesplegar)>
					<td>
						<table cellspacing='1' cellpadding='0' >
							<tr>
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Filtrar"
								Default="Filtrar"
								XmlFile="/rh/generales.xml"
								returnvariable="Filtrar"/>
								
								<td><input type="submit" value="<cfoutput>#Filtrar#</cfoutput>" class="btnFiltrar" onclick="javascript:return filtrar#formName#();"></td>
							</tr>
						</table> 
					</td></cfif></tr></table>
				</td>
			</cfloop>
			<cfif ucase(checkboxes) EQ "D" or ucase(radios) EQ "D">
				<td class="tituloListas" align="left" width="1%"></td>
			</cfif>
		</tr>
	</cfif>
	<!--- Fila de Botones Superior --->
	<cfif ListLen(Arguments.botones) GT 0 and mostrar_filtro and Arguments.query.RecordCount GT Arguments.FilasParaBotonesSuperiores and (MaxRows_lista GT Arguments.FilasParaBotonesSuperiores OR MaxRows_lista EQ 0)>
		<cfoutput>
		<tr>
			<td class="listaNon" align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">
				<cf_botones values="#Arguments.botones#">
			</td>
		</tr>
		</cfoutput>
	</cfif>
	
	<!--- Control de Cortes en la Lista --->
	<cfset ColsCorte = ListToArray(Cortes)>
	<cfset DatosCorte = ArrayNew(1)>
	<cfset lCortes = ListLen(Trim(Cortes))>
	<cfif lCortes GT 0>
		<cfset res = ArraySet(DatosCorte,1,lCortes,"")>
	</cfif>
	<cfset col = 1>
	<cfset datosPost ="">

	<!---<cfif isdefined("Form")><cfloop index="cName" list="#ArraytoList(columnas)#"><cftry><cfset datosPost = datosPost & Trim(#Evaluate('Form.#cName#')#)><cfcatch></cfcatch></cftry></cfloop></cfif>--->

	<cfif isdefined("Arguments.keys") and Len(Trim(Arguments.keys))>
		<cfset my_keys = keys>
	<cfelse>
		<cfset my_keys = ArrayToList(columnas)>
	</cfif>
	<cfloop index="cName" list="#my_keys#">
		<cfif isdefined("Form") And StructKeyExists(Form,Trim(cName))>
			<cfset datosPost = datosPost & Trim(Form[Trim(cName)])>
		<cfelseif  isdefined("url") And StructKeyExists(url,Trim(cName))>
			<cfset datosPost = datosPost & Trim(url[Trim(cName)])>
		</cfif>
	</cfloop>

	<cfoutput query="Arguments.query" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">
		<cfloop index="i" from="1" to="#lCortes#">
			<cfif lCortes GT 0>
				<cfif DatosCorte[i] NEQ #Evaluate('Arguments.query.#Trim(ColsCorte[i])#')#>
					<cfset DatosCorte[i] = #Evaluate('Arguments.query.#Trim(ColsCorte[i])#')#>
					<tr class="listaCorte">
						<td class="listaCorte" align="left" width="18" height="17" nowrap>
							<cfif ucase(chkcortes) EQ "S">
								<input type="checkbox" name="chkPadre" value="#Trim(Evaluate('Arguments.query.#Trim(keycorte)#'))#" onclick="javascript: funcChkPadre(this); UpdChkAll(this);">
							</cfif>
						</td>
						<td align="left" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S' or chkcortes EQ 'S', colsp+1, colsp)#"><strong>#DatosCorte[i]#</strong></td>
					</tr>
					<cfloop index="j" from="#i+1#" to="#lCortes#">
						<cfset DatosCorte[j] = "">
					</cfloop>
				</cfif>
			</cfif>	
		</cfloop>
		<!---
			cuando alternar = no, se usa la clase listaNon solamente
		--->
		<cfset LvarListaNon = (CurrentRow MOD 2) or not Arguments.alternar>
		<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
		<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
		<!--- Valores para los checkboxes o radios --->
		<cfif ucase(checkboxes) EQ "S" or ucase(checkboxes) EQ "D" or ucase(radios) EQ "S" or ucase(radios) EQ "D" or ucase(chkcortes) EQ "S">
			<cfset Lista="">
			<cfif Len(Trim(keys))>
				<cfset keys2=ListtoArray(ucase(keys),",")>
				<cfloop index="i" from="1" to="#ArrayLen(keys2)#">
					<cfset Lista = Lista & #Replace(Evaluate('Arguments.query.#Trim(keys2[i])#'),'"',' ','all')# & "|">
				</cfloop>
			<cfelse>
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfset Lista = Lista & #Replace(Evaluate('Arguments.query.#Trim(columnas[i])#'),'"',' ','all')# & "|">
				</cfloop>
			</cfif>
			<cfset Lista = Trim(Mid(Lista,1,len(Lista)-1))>
		</cfif>
		<cfif ucase(checkboxes) EQ "S" or ucase(radios) EQ "S">
			<!--- Checkboxes o Radios a la Izquierda --->
			<td class="#LvarClassName#" align="left" width="1%">
				<input type="<cfif ucase(checkboxes) EQ 'S'>checkbox<cfelse>radio</cfif>" name="chk" value="#Lista#" onclick="javascript: <cfif Len(Trim(Arguments.checkbox_function))>#Arguments.checkbox_function#;</cfif><cfif len(trim(Arguments.desplegar)) and Arguments.mostrar_filtro and ucase(checkboxes) EQ "S">funcFiltroChkThis#formName#(this);</cfif> void(0);" <cfif Len(Trim(checkedcol)) NEQ 0 and Evaluate('Arguments.query.#Trim(checkedcol)#') EQ Lista>checked</cfif> <cfif Len(Trim(inactivecol)) NEQ 0 and Evaluate('Arguments.query.#Trim(inactivecol)#') EQ Lista>disabled</cfif> style="border:none; background-color:inherit;">
			</td>
		<cfelseif ucase(chkcortes) EQ "S">
			<!--- checkboxes para los detalles de los cortes --->
			<td class="#LvarClassName#" align="left" width="1%">
				<input type="checkbox" name="chkHijo_#Trim(Evaluate('Arguments.query.#Trim(keycorte)#'))#" value="#Lista#" onclick="javascript: UpdChkPadre(this);">
			</td>		
		</cfif>
		<!--- Salida de datos --->
		<cfset col = 1>
		<!--- Para poder indicar el ítem seleccionado en la lista --->
		<cfset datosBD ="">
		<cfif Len(Trim(funcion))>
			<cfset invocacion_de_funcion = funcion>
			<cfif Len(Trim(fparams))>
				<cfset invocacion_de_funcion = invocacion_de_funcion & "(">
				<cfloop index="fidx" list="#fparams#">
					<cfif IsBinary(Evaluate('Arguments.query.#Trim(fidx)#'))>
						<cfset ts_temp = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#Evaluate('Arguments.query.#Trim(fidx)#')#" returnvariable="ts_temp"></cfinvoke>
						<cfset invocacion_de_funcion = invocacion_de_funcion & "'" & #HTMLEditFormat(JSStringFormat(ts_temp))# & "', ">
					<cfelse>
						<cfset invocacion_de_funcion = invocacion_de_funcion & "'" & #HTMLEditFormat(JSStringFormat(Evaluate('Arguments.query.#Trim(fidx)#')))# & "', ">
					</cfif>
				</cfloop>
				<cfset invocacion_de_funcion = Left(invocacion_de_funcion, Len(invocacion_de_funcion)-2) & ");">
			</cfif>
		</cfif>

		<!---<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(Evaluate('Arguments.query.#Trim(cName)#'))></cfloop>--->

		<cfif isdefined("keys") and Len(Trim(keys))>
			<cfloop index="cName" list="#keys#"><cfif not IsBinary(Evaluate('Arguments.query.#Trim(cName)#'))><cfset datosBD = datosBD & Trim(#Evaluate('Arguments.query.#Trim(cName)#')#)></cfif></cfloop>
		<cfelse>
			<cfloop index="cName" list="#ArraytoList(columnas)#"><cfif not IsBinary(Evaluate('Arguments.query.#Trim(cName)#'))><cfset datosBD = datosBD & Trim(#Evaluate('Arguments.query.#Trim(cName)#')#)></cfif></cfloop>
		</cfif>


		<cfloop index="cName" list="#desplegar#">
		
					<!--- acumular para el total, si es necesario --->
					<cfset dName = Trim(cName)>
					<cfif ListFind(Arguments.totales, dName)>
						<cfset valor_actual = Arguments.query[dName]>
						<cfif Len(valor_actual) and valor_actual neq 0>
							<cfset total_acumulado[dName] = total_acumulado[dName] + valor_actual>
						</cfif>
					</cfif>
		
					<!--- Para que indique el último seleccionado --->
					<cfif col EQ 1>
						<td align="left" width="18" height="18" nowrap <cfif Len(Trim(funcion))> onclick="javascript: #invocacion_de_funcion#"<cfelseif showLink> onclick="javascript: return Procesar('#Arguments.query.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);"</cfif>>
							<cfif comparenocase(datosBD,datosPost) EQ 0 and not isdefined("Nuevo")>
								<img src="/cfmx/rh/imagenes/addressGo.gif" width="18" height="18"> 
							</cfif>
						</td>
					</cfif>
					<!--- Se genera la Salida de la Lista --->
					<cfset LvarColor = "">
					<cfif trim(Arguments.LineaVerde) NEQ "">
						<cfif evaluate(Arguments.LineaVerde)>
							<cfset LvarColor = "color:##00CC00;">
						</cfif>	
					</cfif>
					<cfif trim(Arguments.LineaRoja) NEQ "">
						<cfif evaluate(Arguments.LineaRoja)>
							<cfset LvarColor = "color:##FF0000;">
						</cfif>	
					</cfif>
					<cfif trim(Arguments.LineaAzul) NEQ "">
						<cfif evaluate(Arguments.LineaAzul)>
							<cfset LvarColor = "color:##0000FF;">
						</cfif>	
					</cfif>
					<td align="#Trim(alin[col])#" class="pStyle_#dName#" 
						<cfset ArrayAjustar = listToArray(ajustar)>
						<cfif ArrayLen(ArrayAjustar) lt col><cfset IdxAjustar = 1><cfelse><cfset IdxAjustar = col></cfif>
						<cfif arrayLen(ArrayAjustar) gte IdxAjustar >
							<cfif ArrayAjustar[IdxAjustar] NEQ "S">nowrap</cfif>
						</cfif>
						<cfif not (isdefined("formatos") and Len(Trim(formatos)) and Trim(fmt[col]) EQ "IMG")>
							<cfif Len(Trim(funcion))> 
								style="padding-right: 3px; cursor: pointer; #LvarColor#" onclick="javascript: #invocacion_de_funcion#" 
							<cfelseif showLink> 
								style="padding-right: 3px; cursor: pointer; #LvarColor#" onclick="javascript: return Procesar('#Arguments.query.CurrentRow#','#ArrayLen(columnas)#','#formName#'
								<cfif not incluyeForm>
									, '#irA#'
								</cfif>
								);"
							<cfelseif LvarColor NEQ "">
								style="#LvarColor#"
							</cfif>
						<cfelseif LvarColor NEQ "">
							style="#LvarColor#"
						</cfif> 
						onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;"
						<cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
						<!---
						Se quito el href, quitar estos comentarios cuando se compruebe que todo funciona bien
						<cfif not (isdefined("formatos") and Len(Trim(formatos)) and Trim(fmt[col]) EQ "IMG")>
							<cfif Len(Trim(funcion))>
								<a href="javascript: #invocacion_de_funcion#" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;" tabindex="-1">
							<cfelseif showLink>
								<a href="javascript:Procesar('#Arguments.query.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
							</cfif>
						</cfif>
						--->
						<!--- indentar cuando hay cortes, esto porque se quitó el text-indent del CSS listaPar y listaNon (danim) --->
						<cfif col EQ 1 and lCortes gt 0>&nbsp;&nbsp;&nbsp;</cfif>
						<cfif trim(ucase(dName)) EQ "CF_CURRENTROW">
							#Arguments.query.currentRow#
						<cfelseif Len(Trim(formatos)) EQ 0>
							#Evaluate('Arguments.query.#dName#')#
						<cfelseif trim(Evaluate('Arguments.query.#dName#')) EQ "">
							<cfset LvarFormato = Trim(fmt[col])>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfswitch expression="#LvarFormato#">
								<!--- Formato de Fecha pero cuando el campo es nulo, se coloca la palabra INDEFINIDO --->
								<cfcase value="DI">
									INDEFINIDO
								</cfcase>
							</cfswitch>
						
						<cfelse>
							<cfset LvarFormato = Trim(fmt[col])>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfswitch expression="#LvarFormato#">
								<cfcase value="P,UP">
									#LsCurrencyFormat(Evaluate('Arguments.query.#dName#'),"none")#%
								</cfcase>
								<cfcase value="M,UM">
									#LsCurrencyFormat(Evaluate('Arguments.query.#dName#'),"none")#
								</cfcase>
								<cfcase value="R,UR">
									<cfif evaluate(mid(Trim(fmt[col]),LvarPto,100))>
										<font color="##FF0000">#LsCurrencyFormat(Evaluate('Arguments.query.#dName#'),"none")#</font>
									<cfelse>
										#LsCurrencyFormat(Evaluate('Arguments.query.#dName#'),"none")#
									</cfif>
								</cfcase>
								<cfcase value="D,UD">
									<cfif Len(Trim(Evaluate('Arguments.query.#dName#')))>#LSDateFormat(Evaluate('Arguments.query.#dName#'),"dd/mm/yyyy")#</cfif>
								</cfcase>
								<!--- IDem cfcase value ="D" --->
								<cfcase value="DI,UDI">
									<cfif Len(Trim(Evaluate('Arguments.query.#dName#')))>#LSDateFormat(Evaluate('Arguments.query.#dName#'),"dd/mm/yyyy")#</cfif>
								</cfcase>
								<cfcase value="I,UI">
									#Evaluate('Arguments.query.#dName#')#
								</cfcase>
								<cfcase value="N,F,UN,UF">
									#LSNumberFormat(Evaluate('Arguments.query.#dName#'),"-__________.____")#
								</cfcase>
								<cfcase value="H">
									<cfif Len(Trim(Evaluate('Arguments.query.#dName#')))>#LSTimeFormat(Evaluate('Arguments.query.#dName#'),"hh:mm tt")#</cfif>
								</cfcase>
								<!--- Formato de Fecha con Hora --->
								<cfcase value="DT">
									<cfif Len(Trim(Evaluate('Arguments.query.#dName#')))>#LSDateFormat(Evaluate('Arguments.query.#dName#'),"dd/mm/yyyy")# #LSTimeFormat(Evaluate('Arguments.query.#dName#'),"hh:mm tt")#</cfif>
								</cfcase>
								<cfdefaultcase>
									#Evaluate('Arguments.query.#dName#')#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<!---
						Se quito el href, quitar estos comentarios cuando se compruebe que todo funciona bien
						<cfif not (isdefined("formatos") and Len(Trim(formatos)) and Trim(fmt[col]) EQ "IMG")>
							<cfif showLink OR Len(Trim(funcion)) NEQ 0></a></cfif>
						</cfif>
						--->
					</td>
					<cfset col = col + 1>
		</cfloop>
		<!--- Checkboxes o Radios a la derecha --->
		<cfif ucase(checkboxes) EQ "D" or ucase(radios) EQ "D">
			<td class="#LvarClassName#" align="center">
				<input type="<cfif ucase(checkboxes) EQ 'D'>checkbox<cfelse>radio</cfif>" name="chk" value="#Lista#"  <cfif Len(Trim(Arguments.checkbox_function))>onClick="javascript: #Arguments.checkbox_function#"</cfif> <cfif Len(Trim(checkedcol)) NEQ 0 and Evaluate('Arguments.query.#Trim(checkedcol)#') EQ Lista>checked</cfif> <cfif Len(Trim(inactivecol)) NEQ 0 and Evaluate('Arguments.query.#Trim(inactivecol)#') EQ Lista>disabled</cfif>>
				<!---<input type="checkbox" name="chk" value="#Lista#">--->
			</td>
		</cfif>
		</tr>
		<tr><td colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#"><cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="#ucase(Trim(ucase(columnas[i])))#_#Arguments.query.CurrentRow#" type="hidden" value="<cfif not ISBinary(Evaluate('Arguments.query.#Trim(columnas[i])#'))>#HTMLEditFormat(Evaluate('Arguments.query.#Trim(columnas[i])#'))#</cfif>"  disabled<!--- no enviar este dato ---> ></cfloop></td></tr>
	</cfoutput>
	
	
<!--- FILA DE TOTALES --->
	<cfif Len(Trim(Arguments.totales))>
		<tr class="listaCorte">
		<!--- Valores para los checkboxes --->
		<cfif ucase(checkboxes) EQ "S" or ucase(radios) EQ "S">
			<td><!--- Checkboxes a la Izquierda --->&nbsp;</td>
		</cfif>
		<td><!--- columna del elemento seleccionado addressGo.gif --->&nbsp;</td>
		<!--- Salida de datos --->
		<cfset col=1>
		<cfloop index="cName" list="#desplegar#">
			<td align="#Trim(alin[col])#" 
				<cfif ajustar NEQ "S">nowrap</cfif>>
				<!--- mostrar el total, si es necesario --->
				<cfset dName = Trim(cName)>
				<cfif ListFind(Arguments.totales, dName)>
					<strong <cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
						<cfif len(trim(arguments.pasarTotales))>
							<cfset total_acumulado[dName]=pTotales[dName]>
						</cfif>
						<cfif Len(Trim(formatos)) EQ 0>
							#total_acumulado[dName]#
						<cfelse>
							<cfset LvarFormato = Trim(fmt[col])>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfswitch expression="#LvarFormato#">
								<cfcase value="P,UP">
									#LsCurrencyFormat(total_acumulado[dName],"none")#%
								</cfcase>
								<cfcase value="M,UM">
									#LsCurrencyFormat(total_acumulado[dName],"none")#
								</cfcase>
								<cfcase value="R,UR">
									#LsCurrencyFormat(total_acumulado[dName],"none")#
								</cfcase>
								<cfcase value="I,UI">
									#total_acumulado[dName]#
								</cfcase>
								<cfcase value="N,F,UN,UF">
									#LSNumberFormat(total_acumulado[dName],"-__________.____")#
								</cfcase>
								<cfdefaultcase>
									#total_acumulado[dName]#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
					</strong>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<cfset col=col+1>
		</cfloop>
		<!--- Checkboxes a la derecha --->
		<cfif ucase(checkboxes) EQ "D" or ucase(radios) EQ "D">
			<td>
				&nbsp;
				<!---<input type="checkbox" name="chk" value="#Lista#">--->
			</td>
		</cfif>
		</tr>	
	
	</cfif><!--- fila de totales --->
	
	
	
	<!--- TOTAL DE TOTALES --->
	<cfif Len(Trim(Arguments.totalgenerales))>
		<!--- Pinta la fila con los totales --->
		<tr class="listaCorte">
		<!--- Valores para los checkboxes --->
		<cfif ucase(checkboxes) EQ "S" or ucase(radios) EQ "S">
			<td><!--- Checkboxes a la Izquierda --->&nbsp;</td>
		</cfif>
		<td><!--- columna del elemento seleccionado addressGo.gif --->&nbsp;</td>
		<!--- Salida de datos --->
		<cfset col=1>
		<cfloop index="cName" list="#desplegar#">
			<td align="#Trim(alin[col])#" 
				<cfif ajustar NEQ "S">nowrap</cfif>>
				<!--- mostrar el total, si es necesario --->
				<cfset dName = Trim(cName)>
				<cfif ListFind(Arguments.totalgenerales, dName)>
					<!--- Query de Queries para calcular totales --->
					<cfquery name="rsTotalGenerales" dbtype="query">
						select sum(#dName#) as #dName#
						from Arguments.query
					</cfquery>
					<cfset valor_actual = Evaluate("rsTotalGenerales.#dName#")>
					<strong <cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
						<cfif Len(Trim(formatos)) EQ 0>
							#valor_actual#
						<cfelse>
							<cfset LvarFormato = Trim(fmt[col])>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfswitch expression="#LvarFormato#">
								<cfcase value="P,UP">
									#LsCurrencyFormat(total_acumulado[dName],"none")#%
								</cfcase>
								<cfcase value="M,UM">
									#LsCurrencyFormat(valor_actual,"none")#
								</cfcase>
								<cfcase value="R,UR">
									#LsCurrencyFormat(valor_actual,"none")#
								</cfcase>
								<cfcase value="I,UI">
									#valor_actual#
								</cfcase>
								<cfcase value="N,F,UN,UF">
									#LSNumberFormat(valor_actual,"-__________.____")#
								</cfcase>
								<cfdefaultcase>
									#valor_actual#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
					</strong>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<cfset col=col+1>
		</cfloop>
		<!--- Checkboxes a la derecha --->
		<cfif ucase(checkboxes) EQ "D" or ucase(radios) EQ "D">
			<td>
				&nbsp;
				<!---<input type="checkbox" name="chk" value="#Lista#">--->
			</td>
		</cfif>
		</tr>	
	
	</cfif><!--- fila de totales --->	
	
	<cfif showEmptyListMsg and Arguments.query.RecordCount lte 0>
		<tr><td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#" class="listaCorte"
				<cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
			#EmptyListMsg#
            </td></tr>
	</cfif>

	<!--- Fila de Botones Inferior --->
	<cfif ListLen(Arguments.botones) GT 0>
		<cfoutput>
		<tr>
			<td class="listaNon" align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">
				<cf_botones values="#Arguments.botones#">
			</td>
		</tr>
		</cfoutput>
	</cfif>

	<cfoutput> 
	<cfif MaxRows GT 0 and MaxRows LT Arguments.query.RecordCount or PageNum_lista NEQ 1>
	<tr><td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
	<cfif Arguments.FinReporte NEQ "" AND PageNum_lista GTE TotalPages_lista>
		<tr>
		  <td align="center" class="listaCorte" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#"
		  <cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
		  #Arguments.FinReporte#
		  </td>
		</tr>
		<tr>
		  <td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">&nbsp;
		  
		  </td>
		</tr>
	</cfif>
	<tr> 
	  <td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="99%" align="center">
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista#PageIndex#=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
				</cfif> 
		  </td>
		  <!--- LINEA DE MAXROWSQUERY QUE INDICA AL USUARIO QUE NO ESTA VIENDO TODOS LOS REGISTROS DE LA BASE DE DATOS  --->
			<cfset Desde = 1>
			<cfif isdefined("PageNum_lista")>
				<cfset Desde = (PageNum_lista*Arguments.maxrows)-Arguments.maxrows+1>
			</cfif>
			<cfset Hasta = Desde + Arguments.maxrows-1>
			<cfif Arguments.maxrowsquery GT 0 and Arguments.maxrowsquery LTE query.recordcount>
				<cfif Hasta GT Arguments.maxrowsquery>
					<cfset Hasta = Arguments.maxrowsquery>
				</cfif>
			<cfelse>
				<cfif Hasta GT query.recordcount>
					<cfset Hasta = query.recordcount>
				</cfif>
			</cfif>
		    <cftry>
			  <cfoutput>
				  <td nowrap align="right" width="1%"
				  <cfif isdefined("Arguments.fontsize") and len(trim(Arguments.fontsize))>style="font-size:#Arguments.fontsize#px"</cfif>>
					<cf_translate XmlFile="/rh/generales.xml" key="LB_VistaActual">Vista Actual</cf_translate> #Desde# - #Hasta# <cf_translate XmlFile="/rh/generales.xml" key="LB_de">de</cf_translate> #query.recordcount# <cfif Arguments.maxrowsquery gt 0 and (Desde LTE Hasta)> (* <cf_translate  XmlFile="/rh/generales.xml" key="LB_ListaLimitada">Lista Limitada</cf_translate>) </cfif>
				  </td>
			  </cfoutput>
			  <cfcatch>
			  </cfcatch>
		    </cftry>
		  </tr>
		</table>
	  </td>
	</tr>
	<!--- AGREGUÉ ESTA LÍNEA PORQUE LA QUITÉ DE ABAJO --->
	<tr><td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
	</cfif>
	</cfoutput>
	<!--- ESTA LINEA LA MOVÍ PARA ARRIBA, DENTRO DE CFIF MaxRows
	<tr><td align="center" colspan="#Iif(checkboxes EQ 'S' or radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
	--->
	</table>
	<cfif Ucase(Trim(irA)) EQ Ucase(Trim(CurrentPage))>
		<input type="hidden" name="StartRow#PageIndex#" value="#StartRow_lista#">
		<input type="hidden" name="PageNum#PageIndex#" value="#PageNum_lista#">
	</cfif>
	
	<cfif incluyeForm><cfoutput></form></cfoutput></cfif>
	
	<cfif Arguments.checkboxes EQ "S">
		<cfoutput>
			<script type="text/javascript" language="JavaScript">
				function fnAlgunoMarcado#Arguments.formName#(){
					if (document.#Arguments.formName#.chk) {
						if (document.#Arguments.formName#.chk.value) {
							return document.#Arguments.formName#.chk.checked;
						} else {
							for (var i=0; i<document.#Arguments.formName#.chk.length; i++) {
								if (document.#Arguments.formName#.chk[i].checked) { 
									return true;
								}
							}
						}
					}
					return false;
				}
			</script>
		</cfoutput>
	</cfif>

	
	<cfif Arguments.mostrar_filtro>
		<cfoutput>
			<script type="text/javascript" language="JavaScript">
				function filtrar#formName#(){
					document.#formName#.action='#CurrentPage#'; 
					if (window.funcFiltrar#PageIndex#) {
						if (funcFiltrar#PageIndex#()) {
							return true;
						}
					} else {
						return true;
					}
					return false;
				}
			</script>
		</cfoutput>
	</cfif>
	
	<cfif len(trim(Arguments.desplegar)) and Arguments.mostrar_filtro and ucase(checkboxes) EQ "S">
		<script type="text/javascript" language="JavaScript">
			<!--//
				function funcFiltroChkAll#formName#(c){
					if (document.<cfoutput>#Arguments.formName#</cfoutput>.chk) {
						if (document.<cfoutput>#Arguments.formName#</cfoutput>.chk.value) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk.disabled) { 
								document.<cfoutput>#Arguments.formName#</cfoutput>.chk.checked = c.checked;
							}
						} else {
							for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>.chk.length; counter++) {
								if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk[counter].disabled) {
									document.<cfoutput>#Arguments.formName#</cfoutput>.chk[counter].checked = c.checked;
								}
							}
						}
					}
				}
				function funcFiltroChkThis#formName#(c){
					checked = true;
					if (document.<cfoutput>#Arguments.formName#</cfoutput>.chk) {
						if (document.<cfoutput>#Arguments.formName#</cfoutput>.chk.value) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk.disabled) { 
								if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk.checked) {
									checked = false;
								}									
							}
						} else {
							for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>.chk.length; counter++) {
								if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk[counter].disabled) {
									if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chk[counter].checked) {
										checked = false;
									}	
								}
							}
						}
					}
					document.<cfoutput>#Arguments.formName#</cfoutput>.chkAllItems.checked = checked;
				}
			//-->
		</script>
	</cfif>
	
	<cfif ucase(chkcortes) EQ "S">
		<script type="text/javascript" language="JavaScript">
			function funcChkAll(c) {
				if (document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre) {
					if (document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.value) {
						if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.disabled) { 
							document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.checked = c.checked;
							funcChkPadre(document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre);
						}
					} else {
						for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.length; counter++) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].disabled) {
								document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].checked = c.checked;
								funcChkPadre(document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter]);
							}
						}
					}
				}
			}
			
			function UpdChkAll(c) {
				var allChecked = true;
				if (!c.checked) {
					allChecked = false;
				} else {
					if (document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.value) {
						if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.disabled) allChecked = true;
					} else {
						for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.length; counter++) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].disabled && !document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].checked) {allChecked=false; break;}
						}
					}
				}
				document.<cfoutput>#Arguments.formName#</cfoutput>.chkAllItems.checked = allChecked;
			}		
			
			function funcChkPadre(c) {
				if (document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value]) {
					if (document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value].value) {
						if (!document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value].disabled) document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value].checked = c.checked;
					} else {
						for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value].length; counter++) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value][counter].disabled) document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+c.value][counter].checked = c.checked;
						}
					}
				}
			}		
			
			function UpdChkPadre(c) {
				var idPadre = "" + c.name.split('_')[1];
				
				var allChecked = true;
	
				if (!c.checked) {
					allChecked = false;
				} else {
					if (document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+idPadre].value) {
						if (!document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+idPadre].disabled) allChecked = true;
					} else {
						for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+idPadre].length; counter++) {
							if (!document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+idPadre][counter].disabled && !document.<cfoutput>#Arguments.formName#</cfoutput>['chkHijo_'+idPadre][counter].checked) {
								allChecked=false; break;
							}
						}
					}
				}
	
				if (document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.value) {
					document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.checked = allChecked;
					UpdChkAll(document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre);
				} else {
					for (var counter = 0; counter < document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre.length; counter++) {
						if (!document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].disabled && document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].value == idPadre) {
							document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter].checked = allChecked; 
							UpdChkAll(document.<cfoutput>#Arguments.formName#</cfoutput>.chkPadre[counter]);
							break;
						}
					}
				}
			}		
		</script>
	</cfif>
	<!--- Para retornar otros valores al programa que utiliza el Componente --->
	<cfset StructNew()>
	<cfreturn Arguments.query.recordCount>	
</cffunction>	
<cffunction name="ListFindNoCaseNoSpace" returntype="numeric">
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
</cfcomponent>
