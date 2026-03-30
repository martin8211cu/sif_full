<!--- Cuando hay traerIncial pero se da Back o Forward, se invoca pero no se debe ejecutar --->
<cfif isdefined("url.campoOnTrae") AND url.campoOnTrae EQ "*traerInicial*">
	<cfif Session.Conlises.Conlis[url.c].traerFiltro EQ "">
		<cfabort>
	</cfif>
	<cfset url.campoOnTrae = "">
</cfif>

<cfset Lvar_nRequeridos = 0>
<cfloop list="#Session.Conlises.Conlis[url.c].requeridos#" index="item">
	<cfif item EQ "S">
		<cfset Lvar_nRequeridos = Lvar_nRequeridos + 1>
	</cfif>
</cfloop>
<cfset Lvar_filtro_nuevo = false>
<cfset LvarMostrarFiltro = true>

<cfquery name="conlisQuery" datasource="#Session.Conlises.Conlis[url.c].conexion#">
	
	<cfif #Session.Conlises.Conlis[url.c].maxrowsquery# GT 0>
	<cf_dbrowcount1 rows="#Session.Conlises.Conlis[url.c].maxrowsquery#" datasource="#Session.Conlises.Conlis[url.c].conexion#">
	</cfif>
	
	select 
		<cfset mx = interpreta(Session.Conlises.Conlis[url.c].columnas)>
		<cfloop from="1" to="#ArrayLen(mx)#" index="i">
			<cfset columnas = mx[i].txt>
			#PreserveSingleQuotes(columnas)#
			<cfif len(mx[i].tip) gt 0 and len(mx[i].val) gt 0>
				<cfswitch expression="cf_sql_#mx[i].tip#">
					<cfcase value="cf_sql_date,cf_sql_timestamp">
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#LSParseDateTime(mx[i].val)#">
					</cfcase>
					<cfcase value="cf_sql_decimal,cf_sql_double,cf_sql_float,cf_sql_money,cf_sql_money4,cf_sql_real">
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#Replace(trim(mx[i].val), ',', '','all')#">
					</cfcase>
					<cfdefaultcase>
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#(Trim(mx[i].val))#">
					</cfdefaultcase>
				</cfswitch>
			</cfif>
		</cfloop>
		
		<cfset mx = interpreta(Session.Conlises.Conlis[url.c].tabla)>
		<cfif len(mx[1].txt)>from </cfif>
		<cfloop from="1" to="#ArrayLen(mx)#" index="i">
			<cfset tabla = mx[i].txt>
			#PreserveSingleQuotes(tabla)#
			<cfif len(mx[i].tip) gt 0 and len(mx[i].val) gt 0>
				<cfswitch expression="cf_sql_#mx[i].tip#">
					<cfcase value="cf_sql_date,cf_sql_timestamp">
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#LSParseDateTime(mx[i].val)#">
					</cfcase>
					<cfcase value="cf_sql_decimal,cf_sql_double,cf_sql_float,cf_sql_money,cf_sql_money4,cf_sql_real">
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#Replace(trim(mx[i].val), ',', '','all')#">
					</cfcase>
					<cfdefaultcase>
						<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#(Trim(mx[i].val))#">
					</cfdefaultcase>
				</cfswitch>
			</cfif>
		</cfloop>
		
	<cfsavecontent variable="LvarFiltro">
		where 1=1
		<cfif Session.Conlises.Conlis[url.c].traerFiltro NEQ "">
			<cfset navegacion = "">
			<cfset filtro = Session.Conlises.Conlis[url.c].traerFiltro>
			and #PreserveSingleQuotes(filtro)#
			<cfset Session.Conlises.Conlis[url.c].traerFiltro = "">
		<cfelse>
			<cfset arFormatos = ListtoArray(Session.Conlises.Conlis[url.c].formatos)>
			<cfset arRequeridos = ListtoArray(Session.Conlises.Conlis[url.c].requeridos)>
			<cfset arDesplegar = ListtoArray(Session.Conlises.Conlis[url.c].desplegar)>
			<cfif len(Session.Conlises.Conlis[url.c].filtrar_por)>
				<cfset arFiltrarPor=ListtoArray(Session.Conlises.Conlis[url.c].filtrar_por,Session.Conlises.Conlis[url.c].filtrar_por_delimiters)>
			<cfelse>
				<cfset arFiltrarPor=ListtoArray(Session.Conlises.Conlis[url.c].desplegar)>
			</cfif>
			<cfset navegacion = "">
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
				<cfif temp_value neq htemp_value>
					<cfset Lvar_filtro_nuevo = true>
				</cfif>
				<cfif len(trim(temp_value)) and len(temp_value) gt 0>
					<cfset navegacion = navegacion & "&filtro_" & Trim(arDesplegar[i]) & "=" & temp_value>
					<cfset navegacion = navegacion & "&hfiltro_" & Trim(arDesplegar[i]) & "=" & htemp_value>
					<cfif Arraylen(arFormatos)>
						<cfswitch expression="#trim(arFormatos[i])#">
							<cfcase value="D,DI">
								and <cf_dbfunction name="to_datechar" args="#PreserveSingleQuotes(x)#" datasource="#Session.Conlises.Conlis[url.c].conexion#"> <cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>>=<cfelse>=</cfif> <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(temp_value)#">
							</cfcase>
							<cfcase value="I">
								and #PreserveSingleQuotes(x)# = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(trim(temp_value), ',', '','all')#">
							</cfcase>
							<cfcase value="M,P,R,N,F">
								and #PreserveSingleQuotes(x)# >= <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(trim(temp_value), ',', '','all')#">
							</cfcase>
							<cfdefaultcase>
								<cfif isdefined("url.query")>
									and #PreserveSingleQuotes(x)#
									= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#temp_value#">
								<cfelse>
									and upper(rtrim(<cf_dbfunction name="to_char" args="#PreserveSingleQuotes(x)#" datasource="#Session.Conlises.Conlis[url.c].conexion#"> ))
									like  <cf_jdbcquery_param cfsqltype="cf_sql_char" value="%#Ucase(temp_value)#%">
								</cfif>
							</cfdefaultcase>
						</cfswitch>
					<cfelse>
						<cfif isdefined("url.query")>
							and #PreserveSingleQuotes(x)#
							= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#temp_value#">
						<cfelse>
							and upper(rtrim(<cf_dbfunction name="to_char" args="#PreserveSingleQuotes(x)#" datasource="#Session.Conlises.Conlis[url.c].conexion#"> ))
							like  <cf_jdbcquery_param cfsqltype="cf_sql_char" value="%#temp_value#%">
						</cfif>
					</cfif>
					
				<cfelseif arRequeridos[i] EQ "S">
					and 1 = 2
				</cfif>
	
				<cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>
					<cfset tempPos=ListContainsNoCase(Navegacion,"Filtro_FechasMayores=","&")>
					<cfif tempPos NEQ 0>
					  <cfset Navegacion=ListDeleteAt(Navegacion,tempPos,"&")>
					</cfif>
					<cfset Navegacion=ListAppend(Navegacion,"Filtro_FechasMayores=1","&")>
				</cfif>
	
			</cfloop>
		</cfif>

		<cfset LvarFinWhere = 0>
		<cfset LvarPostWhere = "">
		<cfset LvarTemp = Session.Conlises.Conlis[url.c]>
		<cfif isdefined("LvarTemp.traerFiltroVarios")>
			<cfset LvarMostrarFiltro = false>
			<cfset structDelete(Session.Conlises.Conlis[url.c],"traerFiltroVarios")>
		<cfelse>
			<cfset mx = interpreta(Session.Conlises.Conlis[url.c].filtro)>
			<cfif len(mx[1].txt)>and </cfif>
			<cfloop from="1" to="#ArrayLen(mx)#" index="i">
				<cfset filtro = mx[i].txt>
				<cfif i EQ ArrayLen(mx)>
					<cfset LvarFinWhere = fnFinWhere(filtro)>
					<cfif LvarFinWhere NEQ 0>
						<cfset LvarPostWhere = mid(PreserveSingleQuotes(filtro), LvarFinWhere, len(filtro))>
						<cfset filtro = mid(PreserveSingleQuotes(filtro), 1, LvarFinWhere-1)>
					</cfif>
				</cfif>
				#PreserveSingleQuotes(filtro)#
				<cfif len(mx[i].tip) gt 0 and len(mx[i].val) gt 0>
					<cfswitch expression="cf_sql_#mx[i].tip#">
						<cfcase value="cf_sql_date,cf_sql_timestamp">
							<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#LSParseDateTime(mx[i].val)#">
						</cfcase>
						<cfcase value="cf_sql_decimal,cf_sql_double,cf_sql_float,cf_sql_money,cf_sql_money4,cf_sql_real">
							<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#Replace(trim(mx[i].val), ',', '','all')#">
						</cfcase>
						<cfdefaultcase>
							<cf_jdbcquery_param cfsqltype="cf_sql_#mx[i].tip#" value="#(Trim(mx[i].val))#">
						</cfdefaultcase>
					</cfswitch>
				</cfif>
			</cfloop>
			<cfif #Session.Conlises.Conlis[url.c].maxrowsquery# GT 0>
			<cf_dbrowcount2_a rows="#Session.Conlises.Conlis[url.c].maxrowsquery#" datasource="#Session.Conlises.Conlis[url.c].conexion#">
			#PreserveSingleQuotes(LvarPostWhere)#
			<cf_dbrowcount2_b rows="#Session.Conlises.Conlis[url.c].maxrowsquery#" datasource="#Session.Conlises.Conlis[url.c].conexion#">
			</cfif>
		</cfif>
	</cfsavecontent>
	
	
	#PreserveSingleQuotes(LvarFiltro)#
		<cfif Session.Conlises.Conlis[url.c].debug><cfabort></cfif>
</cfquery>
<cfif find('c',CGI.QUERY_STRING,1) eq 0>
	<cf_throw message="Error en Conlis. Argumentos Requeridos Son Incorrectos!" errorcode="3040">
</cfif>
<cfset QueryString_lista = CGI.QUERY_STRING>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"filtro_","&")>
<cfloop condition="tempPos GT 0">
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
  <cfset tempPos=ListContainsNoCase(QueryString_lista,"filtro_","&")>
</cfloop>
<cfoutput>
<cfif not isdefined("scriptmontodefinition")>
	<cfset scriptmontodefinition = 1>
	<script language="javascript" type="text/javascript" src="/cfmx/rh/Reclutamiento/curriculumExterno/js/utilesMonto.js"></script>
</cfif>

<!--- 
	Concatena los Parametros de Asignar con Fparams y los deja de la siguiente manera:
		LvarAsignarFparams: Para la definición de la Función
		LvarPlistaFparams:	Para la invocación de la Función en Plista
--->
<cfset LvarAsignarFparams = Session.Conlises.Conlis[url.c].asignar>
<cfset LvarPlistaFparams = Session.Conlises.Conlis[url.c].asignarCols>
<cfif len(trim(Session.Conlises.Conlis[url.c].fparams))>
	<cfset arFparams = ListToArray(Session.Conlises.Conlis[url.c].fparams)>
	<cfloop from="1" to="#ArrayLen(arFparams)#" index="item">
		<cfif listFindNoCase(LvarAsignarFparams,arFparams[item]) EQ 0>
			<cfset LvarAsignarFparams 	= listAppend(LvarAsignarFparams,arFparams[item])>
			<cfset LvarPlistaFparams 	= listAppend(LvarPlistaFparams,arFparams[item])>
		</cfif>
	</cfloop>
</cfif>

<!--- <cfif isdefined("url.query")><cfdump var="#url.query#"></cfif> --->
<script language="javascript">
	<!--//
	<cfif isdefined("url.query")>
		<cfset LvarWindow = "window.parent">
		<cfif conlisQuery.recordcount EQ 1>
			<cfset sbAsignaValores()>
			// Indica que ya terminó el TRAEdato
			<cf_IFramesStatus form="#Session.Conlises.Conlis[url.c].form#" action="jsIFrameEnd">
		<cfelseif conlisQuery.recordcount eq 0>
			<cfset sbLimpiaCampos()>
			// Indica que ya terminó el TRAEdato
			<cf_IFramesStatus form="#Session.Conlises.Conlis[url.c].form#" action="jsIFrameEnd">
		<cfelseif conlisQuery.recordcount GT 1>
			<!--- 
				Cuando se encuentra más de un registro, 
				abre el CONLIS unicamente con esos registros
			--->
			// Indica que el TRAEdato queda pendiente, si hay submit en la pantalla principal se cancela
			<cf_IFramesStatus form="#Session.Conlises.Conlis[url.c].form#" action="jsIFrameEnd" IFramePending="yes">
			#LvarWindow#.document.getElementById("frame#Session.Conlises.Conlis[url.c].sufijoFuncion#").src="about:blank";
			<cfset sbLimpiaCampos()>
			if (confirm("Se encontró más de un dato. ¿Desea seleccionar uno?"))
			{
				<cfset Session.Conlises.Conlis[url.c].traerFiltro = mid(LvarFiltro,find("and",LvarFiltro)+3,4096)>
				<cfset Session.Conlises.Conlis[url.c].traerFiltroVarios = true>
				#LvarWindow#.doConlis#Session.Conlises.Conlis[url.c].sufijoFuncion#(true);
			}
			else
			{
				// Indica que ya terminó el TRAEdato
				<cf_IFramesStatus form="#Session.Conlises.Conlis[url.c].form#" action="jsIFrameEnd">
			}
		</cfif>
	<cfelse>
		<cfset LvarWindow = "window.opener">
		function funcFiltrar(){
			var errores = "";
			<cfset arRequeridos = ListtoArray(Session.Conlises.Conlis[url.c].requeridos)>
			<cfset arDesplegar = ListtoArray(Session.Conlises.Conlis[url.c].desplegar)>
			<cfset arEtiquetas = ListtoArray(Session.Conlises.Conlis[url.c].etiquetas)>
			<cfloop from="1" to="#ArrayLen(arRequeridos)#" index="i">
				<cfif trim(arRequeridos[i]) EQ "S">
					document.lista.filtro_#Trim(arDesplegar[i])#.alt = '#Trim(arEtiquetas[i])#';
					if (document.lista.filtro_#Trim(arDesplegar[i])#.value == '') {
						errores = errores + " - El campo #Trim(arEtiquetas[i])# es requerido.\n";
					}
				</cfif>
			</cfloop>
			if (errores.length) {
				alert('Se presentaron los siguientes errores:\n\n'+errores);
				return false;
			}
			document.lista.action="ConlisPopUp.cfm?#QueryString_lista#";
			return true;
		}
	</cfif>

	function asignar(#LvarAsignarFparams#)
	{
<!--- Delay para pruebas
<cfobject type = "Java"	action = "Create" class = "java.lang.Thread" name = "LobjThread">
<cfset LobjThread.sleep(2000)>
--->
		<cfset arAsignar = ListToArray(Session.Conlises.Conlis[url.c].asignar)>
		<cfset arAsignarFormatos = ListToArray(Session.Conlises.Conlis[url.c].asignarformatos)>
		<cfloop from="1" to="#ArrayLen(arAsignar)#" index="item">
			if (#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#)
			<cfswitch expression="#arAsignarFormatos[item]#">
				<cfcase value="C">
				{
					combo = #LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#;
					for (var cont=0;cont<combo.length;cont++){
						if (combo.options[cont].value==rtrim(#trim(htmleditformat(arAsignar[item]))#)) {
							combo.options[cont].selected=true;
						} else {
							combo.options[cont].selected=false;
						}
					}
				}
				</cfcase>
				<cfcase value="M,P,R">
				{
					#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = rtrim(#trim(htmleditformat(arAsignar[item]))#);
					#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = fm(#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value,2);
				}
				</cfcase>
				<cfcase value="N,F">
				{
					#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = rtrim(#trim(htmleditformat(arAsignar[item]))#);
					#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = fm(#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value,4);
				}
				</cfcase>
				<cfdefaultcase>
					#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = rtrim(#trim(htmleditformat(arAsignar[item]))#);
				</cfdefaultcase>
			</cfswitch>
		</cfloop>

		<cfif len(trim(Session.Conlises.Conlis[url.c].funcion))>
			if (#LvarWindow#.#Session.Conlises.Conlis[url.c].funcion#) 
			{
				#LvarWindow#.#Session.Conlises.Conlis[url.c].funcion#(#Session.Conlises.Conlis[url.c].fparams#);
			}
		</cfif>

		<cfif LvarWindow EQ "window.opener">
		</cfif>

		window.close();
	}
	
	function rtrim(sString) 
	{
		if (sString == "")
			return "";
		while (sString.substring(sString.length-1, sString.length) == ' ')
			sString = sString.substring(0,sString.length-1);
		return sString;
	}
	//-->
</script>
</cfoutput>
<!--- <cfif isdefined("url.query")>
	<cfdump var="#conlisQuery#">
	<cfabort>
</cfif> --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cfoutput>#Session.Conlises.Conlis[url.c].title#</cfoutput></title>
</head>
<body>
<link href="/cfmx/plantillas/soinasp01/css/soinasp01_azul.css" rel="stylesheet" type="text/css">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" class="tituloAlterno"><cfoutput>#Session.Conlises.Conlis[url.c].title#</cfoutput></td>
	</tr>
</table>
<cfinvoke  
	component="rh.Reclutamiento.curriculumExterno.pListas" 
	method="pListaQuery"
	returnvariable="retListaQuery"
	query="#conlisQuery#"
	desplegar="#Session.Conlises.Conlis[url.c].desplegar#"
	etiquetas="#Session.Conlises.Conlis[url.c].etiquetas#"
	formatos="#Session.Conlises.Conlis[url.c].formatos#"
	align="#Session.Conlises.Conlis[url.c].align#"
	maxrows="#Session.Conlises.Conlis[url.c].maxrows#"
	maxrowsquery="#Session.Conlises.Conlis[url.c].maxrowsquery#"
	cortes="#Session.Conlises.Conlis[url.c].Cortes#"
	totales="#Session.Conlises.Conlis[url.c].totales#"
	totalgenerales="#Session.Conlises.Conlis[url.c].totalgenerales#"
	mostrar_filtro="#LvarMostrarFiltro#"
	filtro_nuevo="#Lvar_filtro_nuevo#"
	navegacion="#navegacion#"
	ira="ConlisPopUp.cfm?#QueryString_lista#"
	funcion="asignar"
	fparams="#LvarPlistaFparams#"
	debug="#Session.Conlises.Conlis[url.c].debug#"
	conexion="#Session.Conlises.Conlis[url.c].conexion#"
	showemptylistmsg="#Session.Conlises.Conlis[url.c].showEmptyListMsg#"
 	emptylistmsg="#Session.Conlises.Conlis[url.c].EmptyListMsg#"
	/>
	
</body>
</html>
<cffunction name="interpreta" returntype="array"> 
	<cfargument name="data" required="yes">
	<cfset start = 1>
	<cfset arr = ArrayNew(1)>
	<cfloop from="1" to="10" index="xxxx">
		<cfif Session.Conlises.Conlis[url.c].debug><cfoutput>start = #start# <br></cfoutput></cfif>
		<cfset algo = ReFind("\$([^,$]+),([a-z]+)\$",data,start,1)>
		<cfif Session.Conlises.Conlis[url.c].debug><cfdump var="#algo#"></cfif>
		<cfset struct = StructNew()>
		<cfif arraylen(algo.pos) GTE 3>
			<cfset StructInsert(struct, "txt", mid(data,start,algo.pos[1]-start))>
			<cfset StructInsert(struct, "val", HTMLEditFormat(url [trim(mid(data,algo.pos[2],algo.len[2]))]))>
			<cfset StructInsert(struct, "tip", trim(mid(data,algo.pos[3],algo.len[3])))>
		<cfelse>
			<cfset StructInsert(struct, "txt", mid(data,start,len(data)-start+1))>
			<cfset StructInsert(struct, "val", "")>
			<cfset StructInsert(struct, "tip", "")>
		</cfif>
		<cfif Session.Conlises.Conlis[url.c].debug><cfdump var="#struct#"></cfif>
		<cfset ArrayAppend(arr,struct)>
		<cfif arraylen(algo.pos) LT 3><cfbreak></cfif>
		<cfset start=algo.pos[1]+algo.len[1]>
	</cfloop>
	<cfreturn arr>
</cffunction>

<cffunction name="sbAsignaValores" output="yes">
	<!---
		Invoca la asignación y la función con los valores del registro seleccionado
	--->
	<cfset invocacion_de_asignar_y_funcion = "asignar (">
	<cfloop index="fidx" list="#LvarPlistaFparams#">
		<cfif IsBinary(Evaluate('conlisQuery.#Trim(fidx)#'))>
			<cfset ts_temp = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#Evaluate('conlisQuery.#Trim(fidx)#')#" returnvariable="ts_temp"></cfinvoke>
			<cfset invocacion_de_asignar_y_funcion = invocacion_de_asignar_y_funcion & "'" & #HTMLEditFormat(JSStringFormat(ts_temp))# & "', ">
		<cfelse>
			<cfset invocacion_de_asignar_y_funcion = invocacion_de_asignar_y_funcion & "'" & #HTMLEditFormat(JSStringFormat(trim(Evaluate('conlisQuery.#Trim(fidx)#'))))# & "', ">
		</cfif>
	</cfloop>
	<cfset invocacion_de_asignar_y_funcion = Left(invocacion_de_asignar_y_funcion, Len(invocacion_de_asignar_y_funcion)-2) & ");">
	#invocacion_de_asignar_y_funcion#
</cffunction>

<cffunction name="sbLimpiaCampos" output="yes">
	<cfif not isdefined("url.permiteNuevo")>
		<!---
			Limpia los Campos
			únicamente cuando no se está en un formulario de alta 
		--->
		<cfset arAsignar = ListToArray(Session.Conlises.Conlis[url.c].asignar)>
		<cfloop from="1" to="#ArrayLen(arAsignar)#" index="item">
			if (#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#)
				#LvarWindow#.document.#Session.Conlises.Conlis[url.c].form#.#trim(arAsignar[item])#.value = "";
		</cfloop>
	</cfif>
	<cfif len(trim(Session.Conlises.Conlis[url.c].funcionValorEnBlanco))>
		<!---
			Invoca funcionValorEnBlanco
		--->
		<cfset LvarFuncionValorEnBlanco = Session.Conlises.Conlis[url.c].funcionValorEnBlanco>
		<cfset LvarPto = find("(",LvarFuncionValorEnBlanco)>
		<cfif LvarPto EQ 0>
			<cfset LvarPto = len(LvarFuncionValorEnBlanco) + 1>
			<cfset LvarFuncionValorEnBlanco = LvarFuncionValorEnBlanco & "()">
		</cfif>
		if (#LvarWindow#.#mid(LvarFuncionValorEnBlanco,1,LvarPto-1)#) 
		{
			#LvarWindow#.#LvarFuncionValorEnBlanco#;
		}
	</cfif>
</cffunction>

<cffunction name="fnFinWhere" output="no" returntype="numeric">
	<cfargument name="sql" type="string" required="yes">
	<cfset var LvarPto = 0>
	<cfset LvarPto = REfindNoCase ("\sgroup\s+by\s",         " " & SQL)>
	<cfif LvarPto EQ 0>
		<cfset LvarPto = REfindNoCase ("\shaving\s+",   " " & SQL)>
	</cfif>
	<cfif LvarPto EQ 0>
		<cfset LvarPto = REfindNoCase ("\sorder\s+by\s", " " & SQL)>
	</cfif>
	<cfreturn LvarPto>
</cffunction>
