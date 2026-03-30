<cfcomponent>
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/pBuzon.js"></script>
<link href="/cfmx/sif/css/edu.css" rel="stylesheet" type="text/css">
<cffunction name="pListaBuzon" access="public" returntype="string" output="true">
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
	<cfargument name="Conexion" type="string" required="false" default="#Session.DSN#">
	<cfargument name="funcion" type="string" required="false" default="">
	<cfargument name="fparams" type="string" required="false" default="">
	<cfargument name="showLink" type="boolean" required="false" default="true">
	<cfargument name="showEmptyListMsg" type="boolean" required="false" default="false">
	<cfargument name="EmptyListMsg" type="string" required="false" default="--- No se encontraron Registros ---">
	<cfargument name="checkAll" type="boolean" required="false" default="false">

	<!--- Funcion para chequear todos los checkbox --->
	<cfif checkAll>
		<cfoutput>
		<script type="text/javascript" language="JavaScript">
			function funcChkAll(c) {
				if (document.#formName#.chk) {
					if (document.#formName#.chk.value) {
						if (!document.#formName#.chk.disabled) document.#formName#.chk.checked = c.checked;
					} else {
						for (var counter = 0; counter < document.#formName#.chk.length; counter++) {
							if (!document.#formName#.chk[counter].disabled) document.#formName#.chk[counter].checked = c.checked;
						}
					}
				}
			}

			function UpdChkAll(c) {
				var allChecked = true;
				if (!c.checked) {
					allChecked = false;
				} else {
					if (document.#formName#.chk.value) {
						if (!document.#formName#.chk.disabled) allChecked = true;
					} else {
						for (var counter = 0; counter < document.#formName#.chk.length; counter++) {
							if (!document.#formName#.chk[counter].disabled && !document.#formName#.chk[counter].checked) {allChecked=false; break;}
						}
					}
				}
				document.#formName#.chkAllItems.checked = allChecked;
			}
		</script>
		</cfoutput>
	</cfif>

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
	<cfif incluyeForm><cfoutput><form style="margin: 0" action="#irA#" method="post" name="#formName#" id="#formName#" #formAttr#></cfoutput></cfif>
	<input type="hidden" name="modo" value="ALTA">
	<input name="columnas" type="hidden" value="<cfoutput>#Trim(rsLista.ColumnList)#</cfoutput>">
<!---	<input name="CEcodigo" type="hidden" value="<cfoutput>#Session.CEcodigo#</cfoutput>"> --->

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
                  <cfset tempkey = ListGetAt(nav[nv], 1, "=")>
                  <cfset tempPos=ListContainsNoCase(QueryString_lista,tempkey & "=")>
                  <cfif tempPos EQ 0>
                    <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
                  </cfif>
            </cfloop>
      </cfif>
	<!--- Validaciones Generales del Componente --->
	<cfif ArrayLen(alin) NEQ ListLen(desplegar) or Len(Trim(checkboxes)) EQ 0>
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
				<td class="tituloListas" align="center" width="1%"><cfif checkAll><input class="tituloListas" type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcChkAll(this);"></cfif></td>
			</cfif>
			<cfloop index="i" from="1" to=#ArrayLen(arEtiquetas)#><td class="tituloListas" align="<cfoutput>#Trim(alin[i])#</cfoutput>"><strong>#Trim(arEtiquetas[i])#</strong></td></cfloop>
			<cfif ucase(checkboxes) EQ "D">
				<td class="tituloListas" align="center" width="1%"><cfif checkAll><input class="tituloListas" type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcChkAll(this);"></cfif></td>
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
				<cfif DatosCorte[i] NEQ #JSStringFormat(Evaluate('rsLista.#Trim(ColsCorte[i])#'))#>
					<cfset DatosCorte[i] = #JSStringFormat(Evaluate('rsLista.#Trim(ColsCorte[i])#'))#>
					<tr class="tituloCorte">
						<td class="tituloCorte" align="left" width="18" height="17" nowrap></td>
						<td colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#"><strong>#DatosCorte[i]#</strong></td>
					</tr>
					<cfloop index="j" from="#i+1#" to="#lCortes#">
						<cfset DatosCorte[j] = "">
					</cfloop>
				</cfif>
			</cfif>	
		</cfloop>
		<tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<!--- Valores para los checkboxes --->
		<cfif ucase(checkboxes) EQ "S" or ucase(checkboxes) EQ "D">
			<cfset Lista="">
			<cfif keys NEQ "">
				<cfset keys2=ListtoArray(ucase(keys),",")>
				<cfloop index="i" from="1" to="#ArrayLen(keys2)#">
					<cfset Lista = Lista & #JSStringFormat(Replace(Evaluate('rsLista.#Trim(keys2[i])#'),'"',' ','all'))# & "|">
				</cfloop>
			<cfelse>
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfset Lista = Lista & #JSStringFormat(Replace(Evaluate('rsLista.#Trim(columnas[i])#'),'"',' ','all'))# & "|">
				</cfloop>
			</cfif>
			<cfset Lista = Trim(Mid(Lista,1,len(Lista)-1))>
		</cfif>
		<!--- Para poder indicar el ítem seleccionado en la lista --->
		<cfset datosBD ="">
		<cfif funcion NEQ "">
			<cfset f = funcion>
			<cfif fparams NEQ "">
				<cfset f = f & "(">
				<cfloop index="fidx" list="#fparams#">
					<cfset f = f & "'" & #JSStringFormat(Evaluate('rsLista.#Trim(fidx)#'))# & "', ">
				</cfloop>
				<cfset f = Left(f, Len(f)-2) & ");">
			</cfif>
		</cfif>
		<cfif isdefined("keys") and Len(Trim(keys)) NEQ 0>
			<cfloop index="cName" list="#Replace(keys, ' ', '', 'all')#"><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfloop>
		<cfelse>
			<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfloop>
		</cfif>
		<!--- Para que indique el último seleccionado --->
		<td align="left" width="18" height="18" nowrap onclick="javascript: <cfif funcion NEQ "">#f#<cfelseif showLink>Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);</cfif>">
			<cfif datosBD EQ datosPost>
				<img src="/cfmx/sif/Imagenes/addressGo.gif" width="18" height="18"> 
			</cfif>
		</td>
		<!--- Checkboxes a la Izquierda --->
		<cfif ucase(checkboxes) EQ "S">
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="center" width="1%">
				<input type="checkbox" name="chk" value="#Lista#" onclick="javascript: if (window.UpdChkAll) UpdChkAll(this);" <cfif Len(Trim(checkedcol)) NEQ 0 and JSStringFormat(Evaluate('rsLista.#Trim(checkedcol)#')) EQ Lista>checked</cfif>>
			</td>
		</cfif>
		<cfset col = 1>
		<cfloop index="cName" list="#desplegar#">
					<!--- Se genera la Salida de la Lista --->
					<td align="#Trim(alin[col])#" <cfif ajustar NEQ "S">nowrap</cfif> onclick="javascript: <cfif funcion NEQ "">#f#<cfelseif showLink>Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);</cfif>">
					    <cfif funcion NEQ "">
							<a href="javascript: #f#" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;" tabindex="-1">
						<cfelseif showLink>
							<a href="javascript:Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#formName#'<cfif not incluyeForm>, '#irA#'</cfif>);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
						</cfif>
						<cfif Len(Trim(formatos)) EQ 0>
							#Evaluate('rsLista.#Trim(cName)#')#
						<cfelse>
							<cfswitch expression="#Trim(fmt[col])#">
								<cfcase value="M">
									#LsCurrencyFormat(Evaluate('rsLista.#Trim(cName)#'),"none")#
								</cfcase>
								<cfcase value="D">
									#LSDateFormat(Evaluate('rsLista.#Trim(cName)#'),"dd/mm/yyyy")#
								</cfcase>
								<cfcase value="I">
									#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'))#
								</cfcase>
								<cfcase value="N,F">
									#LSNumberFormat(Evaluate('rsLista.#Trim(cName)#'),"-__________.____")#
								</cfcase>
								<cfcase value="IMG">
									<img src="#Evaluate('rsLista.#Trim(cName)#')#" border="0">
								</cfcase>
								<cfdefaultcase>
									#Evaluate('rsLista.#Trim(cName)#')#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfif showLink OR funcion NEQ ""></a></cfif>
					</td>
					<cfset col = col + 1>
		</cfloop>
		<!--- Checkboxes a la derecha --->
		<cfif ucase(checkboxes) EQ "D">
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="center" width="1%">
				<input type="checkbox" name="chk" value="#Lista#" onclick="javascript: if (window.UpdChkAll) UpdChkAll(this);" <cfif Len(Trim(checkedcol)) NEQ 0 and JSStringFormat(Evaluate('rsLista.#Trim(checkedcol)#')) EQ Lista>checked</cfif>>
			</td>
		</cfif>
		</tr>
		<tr><td colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#"><cfloop index="i" from="1" to="#ArrayLen(columnas)#"><input name="#ucase(Trim(ucase(columnas[i])))#_#rsLista.CurrentRow#" type="hidden" value="#JSStringFormat(Evaluate('rsLista.#Trim(columnas[i])#'))#"></cfloop></td></tr>
	</cfoutput>
	<cfif showEmptyListMsg and rsLista.RecordCount lte 0>
		<tr><td align="center" colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#" class="listaCorte">
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
		<cfset botonesarry = ListtoArray(botones,",")>
		<tr><td colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#">&nbsp;</td></tr>
		<tr>
			<td class="listaNon" align="center" colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#">
				<input type="hidden" name="pListaBtnSel" value="">
			<cfloop from="1" to="#ArrayLen(botonesarry)#" index="btidx">
				<input type="submit" name="btn#Trim(botonesarry[btidx])#" value="#Trim(botonesarry[btidx])#" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.func#Trim(botonesarry[btidx])#) return func#Trim(botonesarry[btidx])#(); ">
			</cfloop>
			</td>
		</tr>
	</cfif>	
<cfoutput> 
<tr><td align="center" colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#">&nbsp;</td></tr>
<tr> 
  <td align="center" colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#">
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/Imagenes/First.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista GT 1>
	  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/Imagenes/Previous.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/Imagenes/Next.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/Imagenes/Last.gif" border=0></a> 
	</cfif> 
</td>
</tr>
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
<tr><td align="center" colspan="#Iif(ucase(checkboxes) EQ 'S' or ucase(checkboxes) EQ 'D', colsp+2, colsp+1)#">&nbsp;</td></tr>
</table>
<cfif Ucase(Trim(irA)) EQ Ucase(Trim(CurrentPage))>
	<input type="hidden" name="StartRow" value="#StartRow_lista#">
	<input type="hidden" name="PageNum" value="#PageNum_lista#">
</cfif>

<cfif incluyeForm><cfoutput></form></cfoutput></cfif>

<cfreturn rsLista.recordCount>
</cffunction>
	
</cfcomponent>