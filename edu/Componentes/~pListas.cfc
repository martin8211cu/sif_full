<cfcomponent>
<cfinclude template="../Utiles/general.cfm">
<script type="text/javascript" language="JavaScript" src="/cfmx/edu/js/pLista1.js"></script>
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
<cffunction name="pListaEdu" access="public" returntype="string" output="true">
	<cfargument name="tabla" type="string" required="true" default="<!--- Nombre de la Tabla --->">
	<cfargument name="columnas" type="string" required="true" default="<!--- Lista de las columnas para el POST--->">
	<cfargument name="desplegar" type="string" required="true" default="<!--- Columnas a desplegar en la Lista--->">
	<cfargument name="etiquetas" type="string" required="true" default="<!--- Título de las columnas --->">
	<cfargument name="formatos" type="string" required="true" default="<!--- Formato para cada columna (M,D,I,N,F)--->">
	<cfargument name="filtro" type="string" required="true" default="<!--- condiciones para el Where --->">
	<cfargument name="align" type="string" required="true" default="<!--- Tipo de Justiticación (left, center, right, justify) --->">
	<cfargument name="ajustar" type="string" required="true" default="S<!--- Ajusta la columna (S,N)--->">
	<cfargument name="irA" type="string" required="true" default="_self">
	<cfargument name="checkboxes" type="string" required="false" default="N">
	<cfargument name="debug" type="string" required="false" default="N<!--- Activa el Debug (S,N)--->">
	<cfargument name="MaxRows" type="numeric" required="false" default="20">
	<cfargument name="Nuevo" type="string" required="false" default="">
	<cfargument name="Cortes" type="string" required="false" default="">
	<cfargument name="navegacion" type="string" required="false" default="">
	<cfargument name="botones" type="string" required="false" default="">
	<cfargument name="incluyeForm" type="string" required="false" default="true">
	<cfargument name="formName" type="string" required="false" default="lista">
	<cfargument name="keys" type="string" required="false" default="">
	<cfargument name="checkedcol" type="string" required="false" default="">
	<cfargument name="Conexion" type="string" required="false" default="#Session.DSN#">
	<cfargument name="funcion" type="string" required="false" default="">
	<cfargument name="fparams" type="string" required="false" default="">
	<!--- QUERY --->
	<cfset sql = "select " & columnas & " from " & tabla >
	<cfif filtro NEQ "">
		<cfset sql = sql & " where " & filtro>
	</cfif>
	<cfquery name="rsLista" datasource="#Conexion#">
		#PreserveSingleQuotes(sql)#
	</cfquery>
	<cfif debug EQ "S">
		<cfoutput>#sql#<br><br> Columnas --> #rsLista.columnList#<br></cfoutput>
	</cfif>
	<cfif incluyeForm><cfoutput><form action="#irA#" method="post" name="#formName#" id="#formName#"></cfoutput></cfif>
	<input type="hidden" name="modo" value="ALTA">
	<input name="columnas" type="hidden" value="<cfoutput>#Trim(rsLista.ColumnList)#</cfoutput>">
	<input name="CEcodigo" type="hidden" value="<cfoutput>#Session.CEcodigo#</cfoutput>">
	<cfset columnas=ListtoArray(ucase(columnas),",")>
	<cfset vis=ListtoArray(desplegar,",")>
	<cfset Longitud=ArrayLen(columnas)>
	<cfset botones=ucase(botones)>
	<!--- Para los formatos --->
	<cfif formatos NEQ "">
		<cfset fmt=ListtoArray(formatos)>
	</cfif>
	<!--- Para la Justificacion de Columnas --->
	<cfset alin=ListtoArray(align,",")>
	<!--- Variables para controlar la cantidad de items a desplegar --->
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
		<cfparam name="PageNum_lista" default="#Form.Pagina#">
	<cfelse>
		<cfparam name="PageNum_lista" default="1">
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows = rsLista.RecordCount>
	</cfif>
	<cfset MaxRows_lista=MaxRows>
	<cfif isdefined("Form.StartRow") and Form.StartRow NEQ "">
		<cfset StartRow_lista = Form.StartRow>
		<cfset PageNum_lista = Form.PageNum>
	<cfelse>
		<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(rsLista.RecordCount,1))>		
	</cfif>
	<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,rsLista.RecordCount)>
	<cfset TotalPages_lista=Ceiling(rsLista.RecordCount/MaxRows_lista)>
	<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>
	<cfif Len(Trim(navegacion)) NEQ 0>
		<cfset nav = ListToArray(navegacion, "&")>
		<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
			<cfset tempPos=ListContainsNoCase(QueryString_lista,nav[nv])>
			<cfif tempPos EQ 0>
			  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
			</cfif>
		</cfloop>
	</cfif>
	<!--- Validaciones Generales del Componente --->
	<cfif ArrayLen(alin) NEQ ListLen(desplegar)	or checkboxes EQ "">
		<cfdump var="#pLista#">
		<cfexit>
	</cfif>
	<!--- Depura el arreglo de columnas para quitar los ALIAS--->
	<cfset columnas = ListtoArray(rsLista.columnList)>
	<!--- Objetos necesarios para el POST --->
	<cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="<cfoutput>#Trim(columnas[i])#</cfoutput>" type="hidden" value=""></cfloop>
	<!--- Inicio de Tabla --->
	<table border="0" cellspacing="0" cellpadding="0" width="100%">		
	<!--- Etiquetas de Encabezados en la Tabla --->
	<cfif len(trim(etiquetas)) GT 0>
		<cfset arEtiquetas=ListtoArray(etiquetas)>
		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
			<cfif ucase(checkboxes) EQ "S">
				<td class="tituloListas" align="left" width="1%"></td>
			</cfif>
			<cfloop index="i" from="1" to=#ArrayLen(arEtiquetas)#><td class="tituloListas" align="<cfoutput>#Trim(alin[i])#</cfoutput>"><strong>#Trim(arEtiquetas[i])#</strong></td></cfloop>
			<cfif ucase(checkboxes) EQ "D">
				<td class="tituloListas" align="left" width="1%"></td>
			</cfif>
		</tr>
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
	<cfif isdefined("Form")><cfloop index="cName" list="#ArraytoList(columnas)#"><cftry><cfset datosPost = datosPost & Trim(#Evaluate('Form.#cName#')#)><cfcatch></cfcatch></cftry></cfloop></cfif>
	<cfoutput query="rsLista" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">
		<cfloop index="i" from="1" to="#lCortes#">
			<cfif lCortes GT 0>
				<cfif DatosCorte[i] NEQ #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
					<cfset DatosCorte[i] = #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
					<cfset colsp=ListLen(desplegar)>
					<tr class="tituloCorte">
						<td class="tituloCorte" align="left" width="18" height="17" nowrap></td>
						<td colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#"><strong>#DatosCorte[i]#</strong></td>
					</tr>
					<cfloop index="j" from="#i+1#" to="#lCortes#">
						<cfset DatosCorte[j] = "">
					</cfloop>
				</cfif>
			</cfif>	
		</cfloop>
		<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<!--- Valores para los checkboxes --->
		<cfif ucase(checkboxes) EQ "S">
			<cfset Lista="">
			<cfif keys NEQ "">
				<cfset keys2=ListtoArray(ucase(keys),",")>
				<cfloop index="i" from="1" to="#ArrayLen(keys2)#">
					<cfset Lista = Lista & #Replace(Evaluate('rsLista.#Trim(keys2[i])#'),'"',' ','all')# & "|">
				</cfloop>
			<cfelse>
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfset Lista = Lista & #Replace(Evaluate('rsLista.#Trim(columnas[i])#'),'"',' ','all')# & "|">
				</cfloop>
			</cfif>
			<cfset Lista = Trim(Mid(Lista,1,len(Lista)-1))>
			<!--- Checkboxes a la Izquierda --->
			<td align="left" width="1%">
				<input type="checkbox" name="chk" value="#Lista#" <cfif Len(Trim(checkedcol)) NEQ 0 and Evaluate('rsLista.#Trim(checkedcol)#') EQ Lista>checked</cfif>>
			</td>
		</cfif>
		<!--- Salida de datos --->
		<cfset col = 1>
		<!--- Para poder indicar el ítem seleccionado en la lista --->
		<cfset datosBD ="">
		<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(Evaluate('rsLista.#Trim(cName)#'))></cfloop>
		<cfloop index="cName" list="#desplegar#">
					<!--- Para que indique el último seleccionado --->
					<cfif col EQ 1>
						<td align="left" width="18" height="18" nowrap>
							<cfif datosBD EQ datosPost>
								<img src="/cfmx/edu/Imagenes/addressGo.gif" width="18" height="18"> 
							</cfif>
						</td>
					</cfif>
					<!--- Se genera la Salida de la Lista --->
					<td align="#Trim(alin[col])#" <cfif ajustar NEQ "S">nowrap</cfif>>
					    <cfif funcion NEQ "">
							<cfset f = funcion>
							<cfif fparams NEQ "">
								<cfset f = f & "(">
								<cfloop index="fidx" list="#fparams#">
									<cfset f = f & "'" & #Evaluate('rsLista.#Trim(fidx)#')# & "', ">
								</cfloop>
								<cfset f = Left(f, Len(f)-2) & ");">
							</cfif>
							<a href="javascript: #f#" tabindex="-1">
						<cfelse>
							<cfif checkboxes NEQ "S">
							    <a href="javascript:Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);" tabindex="-1">
							</cfif>
						</cfif>
						<cfif formatos EQ "">
							#Evaluate('rsLista.#Trim(cName)#')#
						<cfelse>
							<cfswitch expression="#Trim(fmt[col])#">
								<cfcase value="M">#LsCurrencyFormat(Evaluate('rsLista.#Trim(cName)#'),"none")#</cfcase>
								<cfcase value="D">#DateFormat(Evaluate('rsLista.#Trim(cName)#'),"dd/mmm/yyyy")#</cfcase>
								<cfcase value="I">#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'))#</cfcase>
								<cfcase value="N,F">#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'),"-__________.____")#</cfcase>
								<cfdefaultcase>#Evaluate('rsLista.#Trim(cName)#')#</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfif checkboxes NEQ "S" OR funcion NEQ ""></a></cfif>
					</td>
					<cfset col = col + 1>
		</cfloop>
		<cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="#ucase(Trim(ucase(columnas[i])))#_#rsLista.CurrentRow#" type="hidden" value="#Evaluate('rsLista.#Trim(columnas[i])#')#"></cfloop>
		<!--- Checkboxes a la derecha --->
		<cfif ucase(checkboxes) EQ "D">
			<td class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar" </cfif> align="center">
				<input type="checkbox" name="chk" value="#Lista#">
			</td>
		</cfif>
		</tr>
	</cfoutput>
	<cfif ucase(checkboxes) NEQ "N">
		<tr>
			<td class="listaNon" align="center" colspan="#Longitud + 1#">
				<input type="submit" name="Aplicar" value="Aplicar" >
				<!--- <input type="reset" name="Limpiar" value="Limpiar"> --->
				<cfif Len(Trim(Nuevo)) GT 0>
					<input type="submit" name="NuevoL" value="Nuevo" onclick="javascript:document.lista.submit();" >
				</cfif>
			</td>
		</tr>
	</cfif>
<cfoutput> 
<tr><td align="center" colspan="#Longitud + 2#">&nbsp;</td></tr>
<tr> 
  <td align="center" colspan="#Longitud + 2#">
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/edu/Imagenes/First.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/edu/Imagenes/Previous.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/edu/Imagenes/Next.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/edu/Imagenes/Last.gif" border=0></a> 
	</cfif> 
</td>
</tr>
</cfoutput> 
<cfif Len(Trim(botones)) GT 0>
  <cfif FindNoCase("Nuevo", botones) NEQ 0>
	<tr><td align="center" colspan="#Longitud + 2#">&nbsp;</td></tr>
	<tr> 
	  <td align="center" colspan="#Longitud + 2#">
		 <input type="submit" name="btnNuevo" value="Nuevo">
	</td>
	</tr>
  </cfif>
</cfif>
<tr><td align="center" colspan="#Longitud + 2#">&nbsp;</td></tr>
</table>
<cfif Ucase(Trim(irA)) EQ Ucase(Trim(CurrentPage))>
	<input type="hidden" name="StartRow" value="#StartRow_lista#">
	<input type="hidden" name="PageNum" value="#PageNum_lista#">
</cfif>
<cfif incluyeForm></form></cfif>
</cffunction>
	
</cfcomponent>