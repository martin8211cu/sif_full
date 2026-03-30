<cfcomponent>
<cffunction name="PlistaJQuery" access="public" returntype="string" output="true">
    <cfargument name="caption" 	  		type="string" 	required="no"  	default="Listado" hint="Titulo del grid">
    <cfargument name="etiquetas"  		type="string" 	required="yes" 	hint="Titulo de cada una de las colunas">
    <cfargument name="formato"    		type="string" 	required="yes" 	hint="Formato">
    <cfargument name="columnas"   		type="string" 	required="yes" 	hint="Columnas">
    <cfargument name="tabla"   	  		type="string" 	required="yes" 	hint="Tablas">
    <cfargument name="filtro"     		type="string" 	required="no" 	hint="Filtro">
    <cfargument name="where"     		type="string" 	required="no" 	hint="Where">
    <cfargument name="desplegar"  		type="string" 	required="yes" 	hint="Columnas a mostrar">
    <cfargument name="width"   	  		type="string" 	required="no"  	default="#RepeatString('170,',ListLen(Arguments.desplegar))#">
    <cfargument name="rowList"    		type="string" 	required="no"  	default="10,20,30" hint="Listado de Opciones de registros por Pagina">
    <cfargument name="key"   	  		type="string" 	required="no"  	default="-1" hint="llave">
    <cfargument name="keyValue" 		type="string"   required="no">
    <cfargument name="recordtext" 		type="string" 	required="no"  	default="Total de Registros" hint="Leyenda 'Total de ... '">
    <cfargument name="sortname"  		type="string" 	required="no"  	default="1"  hint="Colunma que por defecto va a Ordenar'">
    <cfargument name="sortorder"  		type="string" 	required="no"  	default="asc" hint="Metodo por defecto va a Ordenar'">
    <cfargument name="Param"  	  		type="string"  	required="no"  	default="" hint="Parametros del metodo que se pasaran por URL">
    <cfargument name="PageIndex"  		type="string"  	required="no" 	default="" hint="Sufijo para cuando hay mas de una lista en un mismo Request">
    <cfargument name="rowNum"     		type="numeric" 	required="no" 	default="-1" hint="Número de registros que desea mostrar por página">
    <cfargument name="ItemGroup"  		type="string"  	required="no" 	hint="SI se envia 'Item(s)' mostraria 'nombreGrupo 5 - item(s)'">
    <cfargument name="fnClick"    		type="string"  	required="no" 	hint="Funciona al presionar una fila">
    <cfargument name="btnTitulo"   		type="string"  	required="no" 	hint="Etiqueta del boton">
    <cfargument name="btnFuncion" 		type="string"  	required="no" 	hint="Funcion para los botones">
    <cfargument name="ModoProgramador" 	type="boolean"	required="no" 	default="false" hint="Funcion solo para programadores, en el cliente debe de estar false, cuando se programe debe de estar true"><!--- Permite la creacion de los ficheros y archivos aunque esto ya existan--->
    <cfargument name="mostrarFiltro" 	type="boolean" 	required="no"	default="true">
    <cfargument name="mostrarFiltroColumnas"    type="string" 	required="no" default="#mid(RepeatString('true,',ListLen(Arguments.desplegar)),1,len(RepeatString('true,',ListLen(Arguments.desplegar)))-1)#">
    <cfargument name="align" 			type="string" 	required="no">
    <cfargument name="noSubmit" 		type="boolean" 	required="no" default="false">
    <cfargument name="ElementExtra" 	type="string" 	required="no" default="">
    <cfargument name="conexion" 		type="string" 	required="yes" default="">
    <cfargument name="dateseparator" 	type="string" 	required="yes" default="/">
    <cfargument name="filtroExtraAjax" 	type="string" 	required="no" default="" hint="Este parametro permite enviar por javascript datos al componente remoto para realizar filtro de datos ">
	<cfargument name="onLoadComplete" 	type="string" 	required="no">
	<cfset Arguments.desplegar = replace(Arguments.desplegar,' ','','ALL')>
    <cfset lvarLen = ListLen(Arguments.desplegar)>
    <cfif ListLen(Arguments.etiquetas) neq lvarLen>
    	El grid no se puede procesar debido a que no la longuitud del atributo etiquetas no coincide con la longuitud del atributo desplegar, ambos deben de tener la misma longuitud.
    </cfif>
    <cfif Arguments.key EQ -1>
		<cfset tempC 		 = ListToArray(columnas)>
        <cfset Arguments.key = tempC[1]>
    </cfif>
    <cfif not isdefined('Arguments.keyValue') and ListLen(Arguments.key) eq 1 and isdefined('form.#Arguments.key#')>
    	<cfset Arguments.keyValue = evaluate('form.#Arguments.key#')>
    </cfif>
    <cfif Arguments.rowNum EQ -1>
		<cfset tempN 		    = ListToArray(rowList)>
        <cfset Arguments.rowNum = tempN[1]>
    </cfif>
    <cfset lvarRoot = GetContextRoot()><!--- Root cfmx--->
    <cfset LvarSlash = CreateObject("java","java.lang.System").getProperty("file.separator")><!--- separador / \--->
    <cfset CurrentPage = replace(replace(cgi.SCRIPT_NAME,lvarRoot,''),'.','','all')><!--- Ruta de pagina--->
    <cfset lvarComponentes = replace(ExpandPath(lvarRoot),replace(lvarRoot,'/',LvarSlash,'all'),'','all') & LvarSlash & "gridsComponents">
    <cfset lvarFGrid = lvarComponentes & replace(CurrentPage,'/',LvarSlash,'all') & LvarSlash & "Grid#Arguments.PageIndex#.cfc">
   	<cfset lvarComponenteJSON = lvarRoot & "/gridsComponents" & CurrentPage & "/Grid#Arguments.PageIndex#.cfc?method=getJson">      
    <cfset lvarComponenteSFJSON = lvarComponenteJSON>

	<cfif len(trim(arguments.conexion))><!----- escoge si se trabaja con la conexxion de sesion o la especificada por el usuario----->
    	<cfset LvarCon1 = arguments.conexion>
		<cfset LvarCon2 = arguments.conexion>
    <cfelse>    
    	<cfset LvarCon1 = session.dsn>
		<cfset LvarCon2 = '##session.dsn##'>
    </cfif>
    
    <cfif isdefined('Arguments.filtro') and len(trim(Arguments.filtro))>
    	<cfset Arguments.filtro = replace(Arguments.filtro,"'","|","ALL")>
    	<cfset lvarComponenteJSON  = lvarComponenteJSON & "&filtro=" & Arguments.filtro> 
    </cfif>
	<cfif Arguments.ModoProgramador and FileExists(lvarFGrid)>
    	<cffile file="#lvarFGrid#" action="delete">
    </cfif>

    <cfquery name="rsQuery" datasource="#LvarCon1#">
        select #preservesinglequotes(Arguments.columnas)# 
        from #preservesinglequotes(Arguments.tabla)# 
        where 1=2 
    </cfquery>
        
    <cfif not Arguments.mostrarFiltro>
    	<cfset Arguments.mostrarFiltroColumnas = mid(RepeatString('false,',ListLen(Arguments.desplegar)),1,len(RepeatString('false,',ListLen(Arguments.desplegar)))-1)>
    </cfif>
    <cfset lvarColumnas = Arguments.desplegar>
    <cfloop from="1" to = "#ListLen(rsQuery.columnList)#" index="col">
        <cfif not ListFindNoCase(Arguments.desplegar,ListGetAt(rsQuery.columnList,col))>
            <cfset lvarColumnas = lvarColumnas & "," & ListGetAt(rsQuery.columnList,col)>
            <cfset Arguments.width = Arguments.width & ",0">
            <cfset Arguments.formato = Arguments.formato & ",string">
            <cfset Arguments.etiquetas = Arguments.etiquetas & ", ">
           	<cfset Arguments.mostrarFiltroColumnas = Arguments.mostrarFiltroColumnas & ',false'>
        </cfif>
    </cfloop>
    <cfif not FileExists(lvarFGrid)>
    	<cfset lvarTextApp = '<cfsetting enablecfoutputonly="yes"><cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="##CreateTimeSpan(0,10,0,0)##">'>
		<cfif not DirectoryExists(lvarComponentes)>
            <cfdirectory directory="#lvarComponentes#" action="create">
            <cffile file="#lvarComponentes##LvarSlash#Application.cfm" action="Append" output="#lvarTextApp#">
        </cfif>
        <cfif not FileExists("#lvarComponentes##LvarSlash#Application.cfm")>
            <cffile file="#lvarComponentes##LvarSlash#Application.cfm" action="Append" output="#lvarTextApp#">
        </cfif>
        <cfloop from="1" to = "#ListLen(CurrentPage,'/')#" index="list">
            <cfset lvarComponentes = lvarComponentes & LvarSlash & ListGetAt(CurrentPage,list,'/')>
            <cfif not DirectoryExists(lvarComponentes)>
                <cfdirectory directory="#lvarComponentes#" action="create">
            </cfif>
        </cfloop>
        <cfset lvarKey = "">
        <cfif Listlen(Arguments.key) gt 1>
            <cfset lvarKey = "#Arguments.key#">
        </cfif>
        <cfset columnasProcesadas=Arguments.columnas>
        <cfif isdefined("arguments.columnasReplace") and isArray(arguments.columnasReplace) and Arraylen(arguments.columnasReplace)>
        	 <cfloop from="1" to="#arraylen(arguments.columnasReplace)#" index="i">
                <cfset columnasProcesadas = replace(columnasProcesadas,arguments.columnasReplace[i].valor1,arguments.columnasReplace[i].valor2,'ALL')>
             </cfloop>
        </cfif>
 
		<cfset lvarContenido = '
            <cfcomponent>
                <cffunction name="getJson" access="remote" returnformat="json">
                    <cfargument name="page" required="no" default="1" hint="Page user is on">
                    <cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
                    <cfargument name="sidx" required="no" default="1" hint="Sort Column">
                    <cfargument name="sord" required="no" default="DESC" hint="Sort Order">
					<cfargument name="filtro" required="no" hint="Filtro">
                    <cfset var arraydata = ArrayNew(1)>
                    <cfquery name="seldata" datasource="#LvarCon2#">
                        select #columnasProcesadas# 
                        from #Arguments.tabla#
						where 1=1
						<cfif isdefined("Arguments.filtro") and len(trim(Arguments.filtro))>
                        	and ##replace(Arguments.filtro,"|","''","ALL")##
						</cfif>
						<cfif isdefined("Arguments.filters")>
							<cfset structF = DeserializeJSON(Arguments.filters)>'>

       	<cfloop from="1" to = "#ListLen(Arguments.desplegar)#" index="i">
            <cfif ListGetAt(Arguments.mostrarFiltroColumnas,i)>
            	<cfset cDesplegar = trim(ListGetAt(Arguments.desplegar,i))>
                <cfset lvarPreFiltro = "">
                <cfset lvarPostFiltro = "">
                <cfset lvarFiltro = ""> 
            	<cfif isdefined('Arguments.PreFiltro#cDesplegar#')>
                	<cfset lvarPreFiltro = evaluate('Arguments.PreFiltro#cDesplegar#')>
                </cfif>
                <cfif isdefined('Arguments.PostFiltro#cDesplegar#')>
                	<cfset lvarPostFiltro = evaluate('Arguments.PostFiltro#cDesplegar#')>
                </cfif>
                <cfif len(trim(lvarPreFiltro)) eq 0 and len(trim(lvarPostFiltro)) eq 0 >
                	<cfset lvarFiltro = cDesplegar>
                </cfif>
				<cfset lvarContenido = lvarContenido & '
                        <cfset lvarDato = fnGetDato(structF.rules,"#cDesplegar#")>
                        <cfif len(trim(lvarDato))>'>
                <cfswitch expression="#ListGetAt(Arguments.formato,i)#">
                	<!---- tipos de filtro por fecha---> 
                    <cfcase value="date">
                   		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & '<cfif ListLen(lvarDato,"/") eq 3 and len(lvarDato) eq 10> and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_timestamp" value="##LsParseDateTime(lvarDato)##"> #lvarPostFiltro#</cfif>'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="##LsParseDateTime(lvarDato)##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="dateMMDDYYYY">
                   		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & '<cfif ListLen(lvarDato,"/") eq 3 and len(lvarDato) eq 10> and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_timestamp" value="##LsParseDateTime(lvarDato)##"> #lvarPostFiltro#</cfif>'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="##lvarDato##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="dateDDMMYY">
                   		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & '<cfif ListLen(lvarDato,"/") eq 3 and len(lvarDato) eq 10> and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_timestamp" value="##LsParseDateTime(lvarDato)##"> #lvarPostFiltro#</cfif>'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="##lvarDato##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="dateMMDDYY">
                   		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & '<cfif ListLen(lvarDato,"/") eq 3 and len(lvarDato) eq 10> and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_timestamp" value="##LsParseDateTime(lvarDato)##"> #lvarPostFiltro#</cfif>'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="##lvarDato##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="int"> 
                        <cfset lvarContenido &='<cfif IsNumeric("##lvarDato##")>'>
                       		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
    							<cfset lvarContenido = lvarContenido & 'and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_numeric" value="##lvarDato##"> #lvarPostFiltro#'>
                            <cfelse>
                                <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# = <cfqueryparam cfsqltype="cf_sql_numeric" value="##lvarDato##">'>
                            </cfif> 
                        <cfset lvarContenido &='</cfif>'>  
                    </cfcase>
                    <cfcase value="integer">
                   		<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & 'and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_numeric" value="##lvarDato##"> #lvarPostFiltro#'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# = <cfqueryparam cfsqltype="cf_sql_numeric" value="##lvarDato##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="money">
                    	<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & 'and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_money" value="##replace(lvarDato,'','','''',''all'')##"> #lvarPostFiltro#'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# >= <cfqueryparam cfsqltype="cf_sql_money" value="##replace(lvarDato,'','','''',''all'')##">'>
                        </cfif>
                    </cfcase>
                    <cfcase value="porcentaje">  
                    	<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & 'and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_decimal" value="##lvarDato##"> #lvarPostFiltro#'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and #lvarFiltro# = <cfqueryparam cfsqltype="cf_sql_decimal" value="##lvarDato##">'>
                        </cfif>
                    </cfcase>
                    <cfdefaultcase>
                    	<cfif len(trim(lvarPreFiltro)) gt 0 or len(trim(lvarPostFiltro)) gt 0 >
							<cfset lvarContenido = lvarContenido & 'and #lvarPreFiltro# <cfqueryparam cfsqltype="cf_sql_varchar" value="%##Ucase(lvarDato)##%"> #lvarPostFiltro#'>
                        <cfelse>
                            <cfset lvarContenido = lvarContenido & 'and upper(#lvarFiltro#) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%##Ucase(lvarDato)##%">'>
                        </cfif>
                   </cfdefaultcase>
                </cfswitch>
                <cfset lvarContenido = lvarContenido & '</cfif>'>
        	</cfif>
        </cfloop>
        <cfif isdefined("arguments.filtroExtraAjax") and len(trim(arguments.filtroExtraAjax))>
    	<cfset lvarContenido = lvarContenido & '
                    #preservesinglequotes(arguments.filtroExtraAjax)#
                    '>
		</cfif>
    	<cfset lvarContenido = lvarContenido & '
                    </cfif>
					ORDER BY ##Arguments.sidx## ##Arguments.sord##
					</cfquery>
                    <cfset start = ((arguments.page-1)*arguments.rows)+1>
                    <cfset end = (start-1) + arguments.rows>
                    <cfset i = 1>
                    <cfset lvarListColumn = "#lvarColumnas#">
                    <cfloop query="seldata" startrow="##start##" endrow="##end##">
                        <cfloop from="1" to = "##ListLen(lvarListColumn)##" index="col">
                            <cfset lvarColsValue[col] = evaluate("seldata.##ListGetAt(lvarListColumn,col)##")>
                        </cfloop>
                        <cfset lvarKey = "#lvarKey#">
                        <cfif len(trim(lvarKey))>
                            <cfset lvarValueKey = "">
                            <cfloop from="1" to = "##ListLen(lvarKey)##" index="idx">
                                <cfset lvarValueKey = lvarValueKey & evaluate("seldata.##ListGetAt(lvarKey,idx)##")>
                                <cfif idx lt ListLen(lvarKey)>
                                    <cfset lvarValueKey = lvarValueKey & "|">
                                </cfif>
                            </cfloop>
                            <cfset lvarColsValue[ListLen(lvarListColumn) + 1] = lvarValueKey>
                        </cfif>
                        <cfset arraydata[i] = lvarColsValue>
                        <cfset i = i + 1>
                    </cfloop>
                    <cfset totalPages = Ceiling(seldata.recordcount/arguments.rows)>
                    <cfset stcReturn = {total=totalPages,page=Arguments.page,records=seldata.recordcount,rows=arraydata}>
                    
                    <cfreturn stcReturn>
                </cffunction>
				
				<cffunction name="fnGetDato" access="private" returntype="string">
                	<cfargument name="Arreglo" 	type="array" 	required="yes">
                    <cfargument name="Llave"  	type="string" 	required="yes">
                    <cfloop from = "1" to = "##ArrayLen(Arguments.Arreglo)##" index = "i">
                    	<cfset stct = Arguments.Arreglo[i]>
                        <cfif stct.field eq Arguments.Llave>
                        	<cfreturn stct.data>
                        </cfif>
                    </cfloop>
                    <cfreturn "">
                </cffunction>
            </cfcomponent>'>
           <cffile file="#lvarFGrid#" action="Append" output="#lvarContenido#">
    </cfif>
    <cfif Listlen(Arguments.key) gt 1>
        <cfset lvarColumnas = lvarColumnas & ",IDGrid">
		<cfset Arguments.width = Arguments.width & ",0">
        <cfset Arguments.formato = Arguments.formato & ",string">
        <cfset Arguments.etiquetas = Arguments.etiquetas & ",">
        <cfset Arguments.key = "IDGrid">
        <cfset Arguments.mostrarFiltroColumnas = Arguments.mostrarFiltroColumnas & ',false'>
    </cfif>
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
    </script>
	<cfset LvarIdiomaJQgrid ='es'>
    <cfif isdefined("session.idioma") and trim(session.idioma) eq 'en'>
        <cfset LvarIdiomaJQgrid ='en'>
    </cfif>
	<cfif NOT isdefined('request.Scrip_jqueryIdioma')>
        <script src="/cfmx/jquery/jquery-grid/js/i18n/grid.locale-#LvarIdiomaJQgrid#.js" type="text/javascript"></script>
        <cfset request.Scrip_jqueryIdioma = true>
    </cfif>
	<cfif NOT isdefined('request.Scrip_jqueryload')>
		<script src="/cfmx/jquery/librerias/jquery-migrate-1.0.0.min.js" 	type="text/javascript"></script>
        <script src="/cfmx/jquery/librerias/jquery.jqGrid.min.js" 	type="text/javascript"></script>
        <script src="/cfmx/jquery/jquery-grid/src/grid.grouping.js" type="text/javascript"></script>
		<script src="/cfmx/jquery/librerias/jquery.meio.mask.js"	type="text/javascript"></script>
        <script src="/cfmx/jquery/jquery-grid/js/jquery.ui.datepicker-#LvarIdiomaJQgrid#.js" type="text/javascript"></script>
		
        <cfset request.Scrip_jqueryload = true>
    </cfif>
    
	<table id="list#Arguments.PageIndex#"></table>
    <div id="plist#Arguments.PageIndex#"></div>
    <script language="javascript" type="text/javascript">
		function fnsetFiltroAndReloadGrid<cfoutput>#Arguments.PageIndex#</cfoutput>(filtro){
			$("##list#Arguments.PageIndex#").setGridParam({ 
			  url: "<cfoutput>#lvarComponenteSFJSON#</cfoutput>&filtro=" + filtro.replace(/'/g,"|")
			}).trigger("reloadGrid"); 
		}

		defaultGrid<cfoutput>#Arguments.PageIndex#</cfoutput> = true; 
		$("##list#Arguments.PageIndex#").jqGrid({
			url:'#lvarComponenteJSON#', //CFC retornara los datos
			datatype: 'json', //Se especifica que el tipo de datos que utilizaremos será JSON
			height:'auto', //I like auto, so there is no blank space between. Using a fixed height can mean either a scrollbar or a blank space before the pager
			rowNum:#Arguments.rowNum#, //Numero de registros a mostrar por pagina
			rowList:[#Arguments.rowList#], //Lista de registros, para permitir al usuario seleccionar el número de registros que desea ver por página
			colNames:['#replace(Arguments.etiquetas,",","','","all")#'], //Nombre de las columnas
			//El modelo de columna para definir los datos. 
			colModel :[
				<cfloop from="1" to = "#ListLen(lvarColumnas)#" index="ListItem">
					<cfset cDesplegar = ListGetAt(lvarColumnas,ListItem)>
					<cfset cValor = "">
					<cfif isdefined('Arguments.align')>
						<cfset cAlign = ListGetAt(Arguments.align,ListItem)>
					</cfif>
					<cfif isdefined('Arguments.DefaultValue#cDesplegar#')>
						<cfset cValor = evaluate('Arguments.DefaultValue#cDesplegar#')>
					</cfif>
					{name:'#cDesplegar#',
					 index:'#cDesplegar#',
					 width:#ListGetAt(Arguments.width,ListItem)#,
					 <cfif not ListGetAt(Arguments.mostrarFiltroColumnas,ListItem)>
					 search:false,
					 </cfif>
					 editable:true,
					 <cfif isdefined('Arguments.rs#trim(ListGetAt(lvarColumnas,ListItem))#')>
						stype:'select'
						<cfset lvarValues = "">
						<cfset lvarQuery = evaluate('Arguments.rs#ListGetAt(lvarColumnas,ListItem)#')>
						<cfloop query="lvarQuery">
							<cfif isdefined('lvarQuery.selected') and lvarQuery.selected eq 1>
								<cfset defaultValue = '#lvarQuery.value#'>
							</cfif>
							<cfset lvarValues = lvarValues & lvarQuery.value & ":" & lvarQuery.description>
							<cfif lvarQuery.recordcount neq lvarQuery.currentrow><cfset lvarValues = lvarValues & ";"></cfif>
						</cfloop>
						,editoptions:{value:"#lvarValues#",defaultValue:"#cValor#"}
						,searchoptions:{defaultValue:"#cValor#",dataInit:function (elem) {$(elem).val('#cValor#')}}
						,align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"center"</cfif>
					 <cfelseif listfindnocase('money',ListGetAt(Arguments.formato,ListItem))>
						formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2},
						align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"right;padding-right:10px;"</cfif>,
						searchoptions:{defaultValue:"#cValor#",dataInit:function(elem){$(elem).setMask({mask:'99.999,999,999,999',type:'reverse'}).val('');$(elem).val('#cValor#');}}
					 <cfelseif listfindnocase('int,integer',ListGetAt(Arguments.formato,ListItem))>
						formatter:'integer', formatoptions: {thousandsSeparator: "", defaultValue: '0'},
						align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"right;padding-right:10px;"</cfif>,
						searchoptions:{defaultValue:"#cValor#",dataInit:function(elem){$(elem).setMask({mask:'999999',type:'reverse'}).val('');$(elem).val('#cValor#');}}
					<cfelseif listfindnocase('porcentaje',ListGetAt(Arguments.formato,ListItem))>
						formatter:'currency', formatoptions:{decimalSeparator:"", thousandsSeparator: "", decimalPlaces: 2, prefix: "", suffix:" %"},
						align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"right;padding-right:10px;"</cfif>,
						searchoptions:{defaultValue:"#cValor#",dataInit:function (elem) {$(elem).datepicker({dateFormat:'yy-mm-dd'}); $(elem).setMask({mask:'99.999999999999',type:'reverse'}).val('');$(elem).val('#cValor#');}}
					<cfelseif findnocase('date',ListGetAt(Arguments.formato,ListItem))>
						<cfset LvarDateType =  ListGetAt(Arguments.formato,ListItem)>

						<cfset LvarFormatDate='d/m/Y'> <!--- formato estandar DD-MM-YYYY---->
						<cfset LvarDateFormatFilter='dd/mm/yy'>
						 <cfif len(trim(LvarDateType)) gt 4><!---- si es mas grande que date, la fcha debe venir en formato YYYYMMDD ---->
							<cfset LvarFormatSRC='Y/m/d'>
							formatter:'date',
							 <cfif ucase(LvarDateType) eq 'DATEDDMMYY'>
								<cfset LvarFormatDate='d/m/y'><!--- formato estandar DD-MM-YY---->
							 <cfelseif ucase(LvarDateType) eq 'DATEMMDDYY'>
								<cfset LvarFormatDate='m/d/y'><!--- formato estandar MM-DD-YY---->
							 <cfelseif ucase(LvarDateType) eq 'DATEMMDDYYYY'>
								<cfset LvarFormatDate='m/d/Y'> <!--- formato estandar MM-DD-YYYY ---->
							 </cfif> 
							 <cfif arguments.dateseparator neq '/'>
							 	<cfset LvarFormatDate = replace(LvarFormatDate,'/',arguments.dateseparator,'ALL')>
							 </cfif>
							formatoptions: { srcformat:'#LvarFormatSRC#', newformat:'#LvarFormatDate#' },
						<cfelse>
							formatter:'text',
						</cfif>
						align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"right"</cfif>,
						searchoptions:{defaultValue:"#cValor#",
									   dataInit:function(elem){
										   $(elem).datepicker({
											   	dateFormat:'#LvarDateFormatFilter#',
												onSelect: function(dateText, inst){
													$(inst).datepicker("hide");
													$('##list#Arguments.PageIndex#').trigger('triggerToolbar');
												}
											});
											$(elem).setMask({mask:'39/19/9999'}).val('');
											$(elem).val('#cValor#');
											$(elem).attr("readonly",true);
											$(elem).keydown(function() {
											  $(elem).datepicker("hide");
											});
										}},
						searchrules: {date:true}
					<cfelse>
						formatter:"text",
						align:<cfif isdefined('cAlign')>"#cAlign#"<cfelse>"left"</cfif>,
						searchoptions:{defaultValue:"#cValor#",dataInit:function(elem){$(elem).val('#cValor#');}}
					</cfif>
					<cfif not ListFindNoCase(Arguments.desplegar,ListGetAt(lvarColumnas,ListItem))>
						,hidden:true
					</cfif>
					<cfif Arguments.key eq ListGetAt(lvarColumnas,ListItem)>
						,key:true
					</cfif>
					<!---sorttype:"varchar"--->}
					<cfif ListItem LT ListLen(lvarColumnas)> , </cfif>
				</cfloop>
			],
			pager: $('##plist#Arguments.PageIndex#'), //El div que hemos especificado, para el jqGrid dónde colocar el localizador
			viewrecords: true, //Shows the nice message on the pager
			sortorder: "#Arguments.sortorder#", //Ordenamiento por defecto
			sortname: "#Arguments.sortname#", //Columna a ordernar por defecto
			recordtext:'{0}–{1} de {2}' , //On the demo you will notice "7 Total Records" - The Total Reocrds text comes from here
			pgtext:'/',//You notice the 1/3, you can change the /. You can make it say 1 of 3
			editurl:"Users.cfc?method=getUsers",//Not used right now.
			toolbar:[false,"top"],//Shows the toolbar at the top. I will decide if I need to put anything in there later.
			//The JSON reader. This defines what the JSON data returned from the CFC should look like
			<cfif not Arguments.noSubmit>
			onSelectRow: function(IDkey) {
				<cfif isdefined('Arguments.keyValue')>
				if(IDkey != "#Arguments.keyValue#")
					$("###Arguments.keyValue#").removeClass("ui-state-highlight");
				</cfif>
				<cfif isdefined('Arguments.fnClick')>
						#Arguments.fnClick#(IDkey);
				</cfif>
				},
			</cfif>
			loadComplete:function() {
			<cfif isdefined("arguments.onLoadComplete")>
				<cfoutput>#arguments.onLoadComplete#</cfoutput>
			</cfif>
			<cfif isdefined('Arguments.keyValue')>
				$("###Arguments.keyValue#").addClass("ui-state-highlight");
			</cfif>
			},
			beforeRequest:function(){
				if(defaultGrid<cfoutput>#Arguments.PageIndex#</cfoutput>){
					colModel = $("##list#Arguments.PageIndex#").jqGrid('getGridParam','colModel');
					fields = "";
					for(i = 0; i < colModel.length;i++){
						if(colModel[i].searchoptions){
							valueCol = colModel[i].searchoptions.defaultValue; 
							if(valueCol && trim(valueCol).length != 0)
								fields += (fields.length == 0 ? "" : ",") + createField(colModel[i].name, "eq", valueCol);
						}
					}
					if(fields.length != 0){
						filters = '{\"groupOp\":\"AND\",\"rules\":[' + fields + ']}';
						$("##list#Arguments.PageIndex#").jqGrid('setGridParam', { search: true, postData: { "filters": filters} });
					}
					defaultGrid<cfoutput>#Arguments.PageIndex#</cfoutput> = false;
				}
			},
			<cfif isdefined("arguments.filtroExtraAjax") and len(trim(arguments.filtroExtraAjax))>
			postData: {
				filtroExtraAjax: function() {
					return fnFiltroExtraAjax#Arguments.PageIndex#(); // or other method which read the value
				}
			},
			</cfif>
			
			<cfif isdefined('Arguments.Group')>
			grouping:true, 
			groupingView : { groupField : ['#Arguments.Group#'], 
							 groupColumnShow : [false], 
							 groupText : ['<b>{0}<cfif isdefined('Arguments.ItemGroup')> - {1} #Arguments.ItemGroup#</cfif></b>'] },
			</cfif>
			jsonReader: {
				root: "ROWS",
				page: "PAGE",
				total: "TOTAL",
				records:"RECORDS",
				cell: "",
				id: "0"
				},
			caption:'#Arguments.caption#'
			,loadError : function(xhr,st,err) { alert("Error al procesar JSon.\nType: "+st+"; Response: "+ xhr.status + " "+xhr.statusText +"\nError: "+err); }
		});
		<cfif Arguments.mostrarFiltro>
			$("##list#Arguments.PageIndex#").jqGrid('filterToolbar',{autosearch: true, stringResult: true,searchOnEnter : false});
		</cfif>
		$("##list#Arguments.PageIndex#").navGrid('##plist#Arguments.PageIndex#',{edit:false,add:false,del:false,search:false,refresh:true})
			<cfif isdefined('Arguments.btnTitulo') and ListLen(Arguments.btnTitulo) gt 0>
				<cfloop from="1" to = "#ListLen(Arguments.btnTitulo)#" index="listBtn">
				.navButtonAdd('##plist#Arguments.PageIndex#',{
				   caption:"", 
				   title:"#ListGetAt(Arguments.btnTitulo,listBtn)#",
				   buttonicon:"ui-icon-newwin", 
				   onClickButton: function(){ 
					  #ListGetAt(Arguments.btnFuncion,listBtn)#;
				   }, 
				   position:"first"})
				</cfloop>
			</cfif>
			;
       	<cfif Arguments.noSubmit>
			<!---cursor: default;--->
		</cfif>
		$("##gs_Busqueda_list<cfoutput>#Arguments.PageIndex#</cfoutput>").html('<cfoutput>#Arguments.ElementExtra#</cfoutput>');
		
        function fnGridReload<cfoutput>#Arguments.PageIndex#</cfoutput>(){
            $('##list#Arguments.PageIndex#').trigger('reloadGrid');
        }
		
		function createField(name, op, data) {
			return '{\"field\":\"' + name + '\",\"op\":\"' + op + '\",\"data\":\"' + data + '\"}';
		}

		function trim(s){
			return s.replace(/^\s+|\s+$/g,"");	
		}
    </script>
    <style type="text/css">
    .ui-icon-del{
        background:url(../../rh/imagenes/Ancho.gif);
        }
    </style>
</cffunction>
<!------------------------------------------------------------------------------------>
<cffunction name="JqGridLocal" access="public" returntype="string" output="true">
    <cfargument name="etiquetas"  		type="string" 	required="yes" 	hint="Titulo de cada una de las colunas">
    <cfargument name="columnas"   		type="string" 	required="yes" 	hint="Columnas">
    <cfargument name="formato"    		type="string" 	required="yes" 	hint="Formato">
    <cfargument name="key"    			type="string" 	required="no" 	hint="llave" default="-1">
    <cfargument name="desplegar"  		type="string" 	required="yes" 	hint="Columnas a mostrar" default="#Arguments.columnas#">    
    <cfargument name="width"   	  		type="string" 	required="no"  	default="#RepeatString('170,',ListLen(Arguments.columnas))#">
    <cfargument name="Query"    		type="query" 	required="yes" 	hint="Query">
    <cfargument name="fnClick"    		type="string"  	required="no" 	hint="Funciona al presionar una fila">
    <cfargument name="PageIndex"  		type="string"  	required="no" 	default="" hint="Sufijo para cuando hay mas de una lista en un mismo Request">
    
   
	<cfif NOT isdefined('request.CSS_jqueryBase')>
	  <link rel="stylesheet" type="text/css" media="screen" href="/cfmx/jquery/jquery-ui/css/pepper-grinder/jquery-ui-1.8.9.custom.css" /> 
	  <link rel="stylesheet" type="text/css" media="screen" href="/cfmx/jquery/jquery-grid/css/ui.jqgrid.css" /> 
	  <cfset request.CSS_jqueryBase = true>
    </cfif>
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
    </script>
	<cfif NOT isdefined('request.Scrip_jqueryIdioma')>
        <script src="/cfmx/jquery/jquery-grid/js/i18n/grid.locale-es.js" type="text/javascript"></script>
        <cfset request.Scrip_jqueryIdioma = true>
    </cfif>
	<cfif NOT isdefined('request.Scrip_jqueryload')>
        <script src="/cfmx/jquery/jquery-grid/src/grid.loader.js" 	type="text/javascript"></script>
        <script src="/cfmx/jquery/librerias/jquery.jqGrid.min.js" 	type="text/javascript"></script>
        <script src="/cfmx/jquery/jquery-grid/src/grid.grouping.js" type="text/javascript"></script>
		<script src="/cfmx/jquery/librerias/jquery.meio.mask.js"	type="text/javascript"></script>
        <cfset request.Scrip_jqueryload = true>
    </cfif>
    <cfset Arguments.desplegar = trim(Arguments.desplegar)>
    <cfset lvarLen = ListLen(Arguments.desplegar)>
    <cfif ListLen(Arguments.etiquetas) neq lvarLen>
    	El grid no se puede procesar debido a que no la longuitud del atributo etiquetas no coincide con la longuitud del atributo desplegar, ambos deben de tener la misma longuitud.
    </cfif>
    <cfif Arguments.key EQ -1>
		<cfset tempC 		 = ListToArray(columnas)>
        <cfset Arguments.key = tempC[1]>
    </cfif>
    <cfset lvarColumnas = Arguments.desplegar>
    <cfloop from="1" to = "#ListLen(Arguments.Columnas)#" index="col">
        <cfif not ListFindNoCase(Arguments.desplegar,ListGetAt(Arguments.Columnas,col))>
            <cfset lvarColumnas = lvarColumnas & "," & ListGetAt(Arguments.Columnas,col)>
            <cfset Arguments.width = Arguments.width & ",0">
            <cfset Arguments.formato = Arguments.formato & ",string">
            <cfset Arguments.etiquetas = Arguments.etiquetas & ", ">
           	<!---<cfset Arguments.mostrarFiltroColumnas = Arguments.mostrarFiltroColumnas & ',false'>--->
        </cfif>
    </cfloop>
    <cfset Arguments.Columnas = lvarColumnas>
	<table id="list#PageIndex#"></table>
    <div id="plist#Arguments.PageIndex#"></div>
    <script language="javascript" type="text/javascript">
		jQuery("##list#PageIndex#").jqGrid({ 
		datatype: "local",
		height: 100, 
		pgbuttons: false, 
		pgtext: false,
		pginput:false,
		pager: $('##plist#Arguments.PageIndex#'),
		colNames:['#replace(Arguments.etiquetas,",","','","all")#'], //Nombre de las columnas
		colModel:[ 
			<cfloop from="1" to = "#ListLen(Arguments.columnas)#" index="ListItem">
				{name:'#ListGetAt(Arguments.columnas,ListItem)#',index:'#ListGetAt(Arguments.columnas,ListItem)#',width:#ListGetAt(Arguments.width,ListItem)#,
				 <cfif listfindnocase('money',ListGetAt(Arguments.formato,ListItem))>
						formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2},
						align:"right",
						searchoptions:{dataInit:function (elem) {
													$(elem).setMask({mask:'99.999,999,999,999',type:'reverse',defaultValue : '+'}).val('');
												}
										}
					 <cfelseif listfindnocase('int,integer',ListGetAt(Arguments.formato,ListItem))>
						formatter:'integer', formatoptions:{thousandsSeparator: ""},
						align:"right",
						searchoptions:{dataInit:function (elem) {
													$(elem).setMask({mask:'99.999999999999',type:'reverse',defaultValue : '+'}).val('');
												}
										}
					<cfelseif listfindnocase('porcentaje',ListGetAt(Arguments.formato,ListItem))>
						formatter:'currency', formatoptions:{decimalSeparator:"", thousandsSeparator: "", decimalPlaces: 2, prefix: "", suffix:" %"},
						align:"right",
						searchoptions:{dataInit:function (elem) {$(elem).setMask({mask:'99.999999999999',type:'reverse'}).val('');}}
					<cfelseif findnocase('date',ListGetAt(Arguments.formato,ListItem))>
						formatter:'text', 
						align:"left",
						editrules : {date:true},
						searchoptions:{dataInit:function (elem) {$(elem).setMask({mask:'39/19/9999'}).val('');}}
					<cfelse>
						formatter:"text",
						align:"left"
					</cfif>
					<cfif not ListFindNoCase(Arguments.desplegar,ListGetAt(Arguments.columnas,ListItem))>
						,hidden:true
					</cfif>
					<cfif Arguments.key eq ListGetAt(lvarColumnas,ListItem)>
						,key:true
					</cfif>
					<!---sorttype:"varchar"--->}
						<cfif ListItem LT ListLen(Arguments.columnas)> , </cfif>
			</cfloop>
		 		], 
		multiselect: false, //The JSON reader. This defines what the JSON data returned from the CFC should look like
                onSelectRow: function(IDkey) {
					<cfif isdefined('Arguments.keyValue')>
					if(IDkey != "#Arguments.keyValue#")
						$("###Arguments.keyValue#").removeClass("ui-state-highlight");
					</cfif>
                    <cfif isdefined('Arguments.fnClick')>
                            #Arguments.fnClick#(mydata[IDkey-1].DEid);
                    </cfif>
                    },
            	loadComplete:function() {               
					<cfif isdefined('Arguments.keyValue')>
						$("###Arguments.keyValue#").addClass("ui-state-highlight");
					</cfif>
                    }
		}); 
		
		$("##list#PageIndex#").jqGrid('filterToolbar',{stringResult: true,searchOnEnter : false});
		
		var mydata = [ 
			<cfloop query="Arguments.query">
				{DEid:"#Arguments.query.DEid#",DEidentificacion:"#Arguments.query.DEidentificacion#",Empleado:"#Arguments.query.NombreCompleto#"},
			</cfloop>
		 ]; 
		 for(var i=0;i<=mydata.length;i++) jQuery("##list#PageIndex#").jqGrid('addRowData',i+1,mydata[i]);
    </script>
</cffunction>
</cfcomponent>
