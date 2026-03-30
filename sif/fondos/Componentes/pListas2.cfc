<cfcomponent>
<script type="text/javascript" language="JavaScript" src="../js/pLista1.js"></script>
<link href="/cfmx/sif/fondos/css/sif.css" rel="stylesheet" type="text/css">
<cffunction name="pLista" access="public" returntype="string" output="true">
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
	<cfargument name="EmptyListMsg" type="string" required="false" default="--- No se encontraron Registros ---">
	<cfargument name="PageIndex" type="string" required="false" default="">

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
	<cfif incluyeForm><cfoutput><form style="margin:0" action="#irA#" method="post" name="#formName#" id="#formName#" #formAttr#></cfoutput></cfif>
	<input type="hidden" name="modo" value="ALTA">
	<input name="columnas" type="hidden" value="<cfoutput>#Trim(rsLista.ColumnList)#</cfoutput>">
	<input name="Ecodigo" type="hidden" value="<cfif isdefined('Session.Ecodigo')><cfoutput>#Session.Ecodigo#</cfoutput></cfif>">
	<cfset columnas=ListtoArray(ucase(columnas),",")>
	<cfset vis=ListtoArray(desplegar,",")>
	<cfset Longitud=ArrayLen(columnas)>
	<cfset colsp=ListLen(desplegar)>
	<!--- <cfset botones=ucase(botones)> --->
	<!--- Para los formatos --->
	<cfif formatos NEQ "">
		<cfset fmt=ListtoArray(formatos)>
	</cfif>
	<!--- Para la Justificacion de Columnas --->
	<cfset alin=ListtoArray(align,",")>
	<!--- Variables para controlar la cantidad de items a desplegar --->
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfif isdefined("Form.Pagina#PageIndex#") and Form["Pagina"&PageIndex] NEQ "">
		<cfset PageNum_lista = Form['Pagina'&PageIndex]>
	<cfelseif isdefined("Url.Pagina#PageIndex#") and Url["Pagina"&PageIndex] NEQ "">
		<cfset PageNum_lista = Url['Pagina'&PageIndex]>
	<cfelseif isdefined("Form.PageNum_lista#PageIndex#") and Form["PageNum_lista"&PageIndex] NEQ "">
		<cfset PageNum_lista = Form['PageNum_lista'&PageIndex]>
	<cfelseif isdefined("Url.PageNum_lista#PageIndex#") and Url["PageNum_lista"&PageIndex] NEQ "">
		<cfset PageNum_lista = Url['PageNum_lista'&PageIndex]>
	<cfelseif isdefined("Form.PageNum#PageIndex#") and Form["PageNum"&PageIndex] NEQ "">
		<cfset PageNum_lista = Form['PageNum'&PageIndex]>
	<cfelseif isdefined("Url.PageNum#PageIndex#") and Url["PageNum"&PageIndex] NEQ "">
		<cfset PageNum_lista = Url['PageNum'&PageIndex]>
	<cfelse>
		<cfset PageNum_lista = 1>
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows = rsLista.RecordCount>
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows_lista = 1>
	<cfelse>
		<cfset MaxRows_lista = MaxRows>
	</cfif>
	<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(rsLista.RecordCount,1))>		
	<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,rsLista.RecordCount)>
	<cfset TotalPages_lista = Ceiling(rsLista.RecordCount/MaxRows_lista)>
	<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista#PageIndex#=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>
	<cfif Len(Trim(navegacion)) NEQ 0>
		<cfset nav = ListToArray(navegacion, "&")>
		<!---<cfset QueryString_lista = "">--->
		<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
			<cfset tempkey = ListGetAt(nav[nv], 1, "=")>
			<cfset tempPos=ListContainsNoCase(QueryString_lista,tempkey & "=")>
			<!--- 
				Chequear substrings duplicados en el contenido de la llave
			--->
			<cfif tempPos EQ 0>
			  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
			</cfif>
		</cfloop>
	</cfif>
	<!--- Validaciones Generales del Componente --->
	<cfif ArrayLen(alin) NEQ ListLen(desplegar)	or checkboxes EQ "">
		<cfdump var="#pListaRH#">
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

	<!---<cfif isdefined("Form")><cfloop index="cName" list="#ArraytoList(columnas)#"><cftry><cfset datosPost = datosPost & Trim(#Evaluate('Form.#cName#')#)><cfcatch></cfcatch></cftry></cfloop></cfif>--->

	<cfif isdefined("Form")>
		<cfif isdefined("keys") and Len(Trim(keys)) NEQ 0>
			<cfloop index="cName" list="#Replace(keys, ' ', '', 'all')#"><cftry><cfset datosPost = datosPost & Trim(#Evaluate('Form.#cName#')#)><cfcatch></cfcatch></cftry></cfloop>
		<cfelse>
			<cfloop index="cName" list="#ArraytoList(columnas)#"><cftry><cfset datosPost = datosPost & Trim(#Evaluate('Form.#cName#')#)><cfcatch></cfcatch></cftry></cfloop>
		</cfif>
	</cfif>


	<cfoutput query="rsLista" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">
		<cfloop index="i" from="1" to="#lCortes#">
			<cfif lCortes GT 0>
				<cfif DatosCorte[i] NEQ #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
					<cfset DatosCorte[i] = #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
					<tr class="tituloCorte">
						<td class="tituloCorte" align="left" width="18" height="17" nowrap></td>
						<td align="left" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#"><strong>#DatosCorte[i]#</strong></td>
					</tr>
					<cfloop index="j" from="#i+1#" to="#lCortes#">
						<cfset DatosCorte[j] = "">
					</cfloop>
				</cfif>
			</cfif>	
		</cfloop>
		<cfset LvarListaNon = (CurrentRow MOD 2)>
		<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="<cfif NOT LvarListaNon>LvarListaNonColor = style.backgroundColor;</cfif>style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor=<cfif CurrentRow MOD 2>'##FFFFFF'<cfelse>LvarListaNonColor</cfif>;">
		<!--- Valores para los checkboxes --->
		<cfif ucase(checkboxes) EQ "S" or ucase(checkboxes) EQ "D">
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
		</cfif>
		<cfif ucase(checkboxes) EQ "S">
			<!--- Checkboxes a la Izquierda --->
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="1%">
				<input type="checkbox" name="chk" value="#Lista#" <cfif Len(Trim(checkedcol)) NEQ 0 and Evaluate('rsLista.#Trim(checkedcol)#') EQ Lista>checked</cfif> <cfif Len(Trim(inactivecol)) NEQ 0 and Evaluate('rsLista.#Trim(inactivecol)#') EQ Lista>disabled</cfif>>
			</td>
		</cfif>
		<!--- Salida de datos --->
		<cfset col = 1>
		<!--- Para poder indicar el ítem seleccionado en la lista --->
		<cfset datosBD ="">
		<cfif funcion NEQ "">
			<cfset f = funcion>
			<cfif fparams NEQ "">
				<cfset f = f & "(">
				<cfloop index="fidx" list="#fparams#">
					<cfset f = f & "'" & #HTMLEditFormat(JSStringFormat(Evaluate('rsLista.#Trim(fidx)#')))# & "', ">
				</cfloop>
				<cfset f = Left(f, Len(f)-2) & ");">
			</cfif>
		</cfif>

		<!---<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(Evaluate('rsLista.#Trim(cName)#'))></cfloop>--->

		<cfif isdefined("keys") and Len(Trim(keys)) NEQ 0>
			<cfloop index="cName" list="#Replace(keys, ' ', '', 'all')#"><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfloop>
		<cfelse>
			<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfloop>
		</cfif>

		<cfloop index="cName" list="#desplegar#">
					<!--- Para que indique el último seleccionado --->
					<cfif col EQ 1>
						<td align="left" width="18" height="18" nowrap <cfif funcion NEQ ""> onclick="javascript: #f#"<cfelseif showLink> onclick="javascript: Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);"</cfif>>
							<cfif comparenocase(datosBD,datosPost) EQ 0 and not isdefined("Nuevo")>
								<img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18"> 
							</cfif>
						</td>
					</cfif>
					<!--- Se genera la Salida de la Lista --->
					<td align="#Trim(alin[col])#" <cfif ajustar NEQ "S">nowrap</cfif> <cfif funcion NEQ ""> onclick="javascript: #f#"<cfelseif showLink> onclick="javascript: Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);"</cfif>>
						<cfif not (isdefined("fmt") and Trim(fmt[col]) EQ "IMG")>
							<cfif funcion NEQ "">
								<a href="javascript: #f#" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;" tabindex="-1">
							<cfelseif showLink>
								<a href="javascript:Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
							</cfif>
						</cfif>
						<cfif Len(Trim(formatos)) EQ 0>
							#Evaluate('rsLista.#Trim(cName)#')#
						<cfelse>
							<cfswitch expression="#Trim(fmt[col])#">
								<cfcase value="M">
									#LsCurrencyFormat(Evaluate('rsLista.#Trim(cName)#'),"none")#
								</cfcase>
								<cfcase value="D">
									<cfif Len(Trim(Evaluate('rsLista.#Trim(cName)#')))>#LSDateFormat(Evaluate('rsLista.#Trim(cName)#'),"dd/mm/yyyy")#</cfif>
								</cfcase>
								<cfcase value="I">
									#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'))#
								</cfcase>
								<cfcase value="N,F">
									#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'),"-__________.____")#
								</cfcase>
								<cfcase value="H">
									<cfif Len(Trim(Evaluate('rsLista.#Trim(cName)#')))>#LSTimeFormat(Evaluate('rsLista.#Trim(cName)#'),"hh:mm tt")#</cfif>
								</cfcase>
								<cfdefaultcase>
									#Evaluate('rsLista.#Trim(cName)#')#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfif not (isdefined("fmt") and Trim(fmt[col]) EQ "IMG")>
							<cfif showLink OR Len(Trim(funcion)) NEQ 0></a></cfif>
						</cfif>
					</td>
					<cfset col = col + 1>
		</cfloop>
		<!--- Checkboxes a la derecha --->
		<cfif ucase(checkboxes) EQ "D">
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="center">
				<input type="checkbox" name="chk" value="#Lista#" <cfif Len(Trim(checkedcol)) NEQ 0 and Evaluate('rsLista.#Trim(checkedcol)#') EQ Lista>checked</cfif> <cfif Len(Trim(inactivecol)) NEQ 0 and Evaluate('rsLista.#Trim(inactivecol)#') EQ Lista>disabled</cfif>>
				<!---<input type="checkbox" name="chk" value="#Lista#">--->
			</td>
		</cfif>
		</tr>
		<tr><td colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#"><cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="#ucase(Trim(ucase(columnas[i])))#_#rsLista.CurrentRow#" type="hidden" value="#Evaluate('rsLista.#Trim(columnas[i])#')#"></cfloop></td></tr>
	</cfoutput>
	<cfif showEmptyListMsg and rsLista.RecordCount lte 0>
		<tr><td align="center" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#" class="listaCorte">
			#EmptyListMsg#
            </td></tr>
	</cfif>
	<!---
	<cfif ucase(checkboxes) NEQ "N">
		<tr>
			<td class="listaNon" align="center" colspan="#Longitud + 1#">
				<input type="submit" name="Aplicar" value="Aplicar" >
				<input type="reset" name="Limpiar" value="Limpiar" >
				<cfif Len(Trim(Nuevo)) GT 0>
					<input type="submit" name="NuevoL" value="Nuevo" onclick="javascript:document.lista.submit();" >
				</cfif>
			</td>
		</tr>
	</cfif>
	--->
	<cfif botones NEQ "">
		<cfoutput>
		<cfset botonesarry = ListtoArray(botones,",")>
		<tr><td colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
		<tr>
			<td class="listaNon" align="center" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#">
				<input type="hidden" name="pListaBtnSel" value="">
			<cfloop from="1" to="#ArrayLen(botonesarry)#" index="btidx">
				<input type="submit" name="btn#Trim(botonesarry[btidx])#" value="#Trim(botonesarry[btidx])#" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.func#Trim(botonesarry[btidx])#) return func#Trim(botonesarry[btidx])#();">
			</cfloop>
			</td>
		</tr>
		</cfoutput>
	</cfif>	
<cfoutput> 
<tr><td align="center" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
<cfif MaxRows GT 0>
<tr> 
  <td align="center" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#">
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista#PageIndex#=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista#PageIndex#=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
	</cfif> 
</td>
</tr>
</cfif>
</cfoutput>
<!---
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
--->
<tr><td align="center" colspan="#Iif(checkboxes EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
</table>
<cfif Ucase(Trim(irA)) EQ Ucase(Trim(CurrentPage))>
	<input type="hidden" name="StartRow#PageIndex#" value="#StartRow_lista#">
	<input type="hidden" name="PageNum#PageIndex#" value="#PageNum_lista#">
</cfif>

<cfif incluyeForm><cfoutput></form></cfoutput></cfif>

<cfreturn rsLista.recordCount>
</cffunction>

</cfcomponent>
