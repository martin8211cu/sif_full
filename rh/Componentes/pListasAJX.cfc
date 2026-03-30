<!--- Liberación del Plistas con Ajax:	3/NOV/2008 --->
<cfcomponent extends="ajax">

	<cffunction name="write_to_buffer" output="no" access="private">
		<cfargument name="contents" type="string" required="yes">
		<cfset bufferAjax.append(JavaCast("string", Arguments.contents))>
	</cffunction>

	<cffunction name="doQuery" output="no" access="remote">
		<cfargument name="IDs" 			type="string" required="Yes">		
		<cfargument name="PageNum" 		type="numeric" required="Yes">
		<cfargument name="Usucodigo" 	type="numeric" required="no">
		<cfargument name="filtro_nuevo" type="boolean" default="no" required="no">
		<cfif not isdefined('session.Usucodigo') and isdefined('Arguments.Usucodigo')>
			<cfset session.Usucodigo = Arguments.Usucodigo>
		</cfif>
		<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "bufferAjax">
		<cfset fnPreparaDatos(Arguments.IDs, Arguments.PageNum, Arguments.Filtro_nuevo)>
		<cfset x=fnPreparaHTML1()>
		<cfif x>
			<cfset x=fnPreparaHTML2(x)>
		</cfif>
        <cfreturn bufferAjax.toString()>
	</cffunction>

	<cffunction name="fnPreparaHTML1" access="private" output="no"  returntype="boolean" hint="Prepara las instrucciones HTML para el manejo de Listas usando AJAX. Funcion No. 1">
			<cfif isdefined("session.Ecodigo")>
				<cfset LvarEcodigo = session.Ecodigo>
			<cfelse>
				<cfset LvarEcodigo = "">
			</cfif>
			<cfif params.incluyeForm EQ true>
				<cfset write_to_buffer('<form style="margin:0"  action="#params.irA#" method="#params.form_method#" name="#params.formName#" id="#params.formName#" #params.formAttr#>')>
			</cfif>
			<cfsavecontent variable="_LvarBotones"><cf_botones values="#params.botones#"></cfsavecontent>
			<cfset write_to_buffer('<input type="hidden" name="modo" value="ALTA"> <input name="columnas" type="hidden" value="#Trim(rsLista.ColumnList)#" disabled> <input name="Ecodigo" type="hidden" value="#LvarEcodigo#"> ')>
			
			<!--- Objetos necesarios para el POST --->
			<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
				<cfset write_to_buffer('<input name="#Trim(columnas[i])#" type="hidden" value="">')>
			</cfloop>
			<!--- Inicio de Tabla --->
			<cfset write_to_buffer('
			<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="100%">')>
			<!--- Etiquetas de Encabezados en la Tabla --->
			<cfset write_to_buffer(' <thead> ')>
			<cfif len(trim(params.etiquetas)) GT 0>
				<cfset arEtiquetas=ListtoArray(params.etiquetas)>
				<cfset write_to_buffer(' <tr> ')>
					<cfif ucase(params.checkboxes) EQ "S" or ucase(params.radios) EQ "S" or ucase(params.chkcortes) EQ "S">
						<cfset write_to_buffer('<th class="tituloListas" align="left" width="1%">')>
							<cfif ucase(params.chkcortes) EQ "S" and not params.mostrar_filtro eq 'true'>
								<cfset write_to_buffer('<input type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcChkAll(this);">')>
							<cfelseif ucase(params.checkboxes) EQ "S" AND  not params.mostrar_filtro eq 'true' AND ucase(params.checkall) EQ "S">
								<cfset write_to_buffer('
								<input 	type="checkbox" name="chkAllItems" value="1"  style="border:none; background-color:inherit;"
										onclick="javascript: funcFiltroChkAll#params.formName#(this);"
								>')>
							</cfif>
						<cfset write_to_buffer('</th>')>
					</cfif>
					<cfset write_to_buffer('<th class="tituloListas" align="left" width="18" height="17" nowrap></th> ')>
					<cfloop index="i" from="1" to=#ArrayLen(arEtiquetas)#>
						<cfset write_to_buffer('<th class="tituloListas" align="#Trim(alin[i])#" valign="bottom">')>
							<cfif i eq ArrayLen(arEtiquetas) and params.mostrar_filtro eq 'true' and (ListFindNoCaseNoSpace(params.formatos,'D') gt 0 or ListFindNoCaseNoSpace(params.formatos,'DI') gt 0)>
								<cfset write_to_buffer(' <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0">')>
								<cfset write_to_buffer('
									<tr>
										<td><strong>#Trim(arEtiquetas[i])#</strong></td>
										<td width="100%" align="right"><input type="checkbox" name="Filtro_FechasMayores" id="Filtro_FechasMayores"
								')>
								<cfif isdefined("Form.Filtro_FechasMayores") or isdefined("Url.Filtro_FechasMayores")>
									<cfset write_to_buffer('checked')>
								</cfif>
								<cfset write_to_buffer('
								 	style="border:none"></td>
										<td style="font-size:xx-small">#LB_FechasMayores#</td>
									</tr>
								</table>
								')>
							<cfelse>
								<cfset write_to_buffer(' <strong ')>
								<cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
									<cfset write_to_buffer('style="font-size:#params.fontsize#px"')>
								</cfif>
                                <cfset write_to_buffer(' > ')>
								<cfset write_to_buffer('#Trim(arEtiquetas[i])#</strong>')>
							</cfif>
						<cfset write_to_buffer(' </th> ')>
					</cfloop>
					<cfif ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "D">
						<cfset write_to_buffer('<th class="tituloListas" align="left" width="1%"></th>')>
					</cfif>
					<cfif len(trim(params.desplegar)) and params.mostrar_filtro eq 'true'>
						<cfset write_to_buffer('<th>&nbsp;</th>')>
					</cfif>
				<cfset write_to_buffer('</tr> ')>
			</cfif>
			<cfset write_to_buffer('</thead>')>
			<!--- Campos de filtro --->
			<cfif len(trim(params.desplegar)) and params.mostrar_filtro eq 'true'>
				<cfset arDesplegar=ListtoArray(params.desplegar)>
				<cfset write_to_buffer('<tr> ')>
					<cfif ucase(params.checkboxes) EQ "S">
						<cfset write_to_buffer(' <td class="tituloListas" align="left" width="1%"> <input 	type="checkbox" name="chkAllItems" value="1"  style="border:none; background-color:inherit;" onclick="javascript: funcFiltroChkAll#params.formName#(this);"	> </td>')>
					<cfelseif  ucase(params.radios) EQ "S">
						<cfset write_to_buffer('<td class="tituloListas" align="left" width="1%"></td>')>
					</cfif>
					<cfset write_to_buffer('<td class="tituloListas" align="left" width="18" height="17" nowrap></td>')>
					<cfloop index="i" from="1" to="#ArrayLen(arDesplegar)#">
						<cfset write_to_buffer(' <td class="tituloListas" align="#Trim(alin[i])#"> ')>
							<cfset write_to_buffer(' <table width="100%"  border="0" cellspacing="0" cellpadding="0"><tr><td width="100%" align="#Trim(alin[i])#">')>
							<cfset LvarFormato = Trim(fmt[i])>
							<cfif isdefined("params.rs"&trim(arDesplegar[i]))>
								<cfset LvarFormato = "C"><!--- Formato Combo --->
								<cfset rsname = HTMLEditFormat("params.rs"&trim(arDesplegar[i]))>
								<cfset rstemp = Evaluate(rsname)> 
							</cfif>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfif     IsDefined('form.filtro_'&Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(form['filtro_'&Trim(arDesplegar[i])])#">
							<cfelseif IsDefined('url.filtro_' &Trim(arDesplegar[i]))><cfset temp_value="#HTMLEditFormat(url ['filtro_'&Trim(arDesplegar[i])])#">
							<cfelse>
								<cfset temp_value="">
							</cfif>
							<cfswitch expression="#LvarFormato#">
								<cfcase value="G,U,UD,UDI,UM,UP,UR,UN,UF,UI,US">
									<cfset write_to_buffer(' &nbsp; ')>
								</cfcase>
								<cfcase value="C">
									<cfset write_to_buffer('<select name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" onkeypress="javascript:return filtrar_Plista#params.PageIndex#();">')>
										<cfloop query="rstemp">
											<cfset write_to_buffer('<option value="#rstemp.value#"')>
											<cfif rstemp.value eq temp_value>
												<cfset write_to_buffer('selected')>
											</cfif>
											<cfset write_to_buffer('>#rstemp.description#</option>')>
										</cfloop>								
									<cfset write_to_buffer('</select>')>
									<cfset write_to_buffer('<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">')>
								</cfcase>
								<cfcase value="L">
									<cfset write_to_buffer('<select name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" onkeypress="javascript:return filtrar_Plista#params.PageIndex#();">')>
											<cfset write_to_buffer('<option value=""></option>')>
											<cfset write_to_buffer('<option value="1"')>
											<cfif temp_value EQ "1">
												<cfset write_to_buffer('selected')>
											</cfif>
											<cfset write_to_buffer('>SI</option>')>
											<cfset write_to_buffer('<option value="0"')>
											<cfif temp_value EQ "0">
												<cfset write_to_buffer('selected')>
											</cfif>
											<cfset write_to_buffer('>NO</option>')>
									<cfset write_to_buffer('</select>')>
									<cfset write_to_buffer('<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">')>
								</cfcase>
								<cfcase value="D,DI">
									<cfsavecontent variable="_LvarFiltroFecha"><cf_sifcalendario name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#" form="#params.formName#"></cfsavecontent>
									<cfset write_to_buffer(' #_LvarFiltroFecha# ')>
								</cfcase>
								<cfcase value="M,P,R,N,F,I">
									<cfset decimales = 2>
                                     <cfset LvarEnteros = 10>
									<cfif LvarFormato eq 'N' or LvarFormato eq 'F'>
										<cfset decimales = 4>
                                        <cfset LvarEnteros = 10>
									</cfif>
									<cfif LvarFormato eq 'I'>
										<cfset decimales = 0>
                                        <cfset LvarEnteros = 20>                                        
									</cfif>
									<cfif len(temp_value) eq 0 or not isNumeric(replace(temp_value,',','','all'))><cfset temp_value = ""></cfif>
                                    <cfsavecontent variable="_LvarinputNumber"><cf_inputNumber name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#replace(temp_value,',','','all')#" form="#params.formName#" enteros="#LvarEnteros#" decimales="#decimales#" style="width:100%"></cfsavecontent>
                                    <cfset write_to_buffer('#_LvarinputNumber#')>
									<cfset write_to_buffer('<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#replace(temp_value,',','','all')#">')>
								</cfcase>
								<cfdefaultcase>
									<cfset write_to_buffer('
									<input 	type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
										name="filtro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
									<input type="hidden" name="hfiltro_#HTMLEditFormat(Trim(arDesplegar[i]))#" value="#temp_value#">
									')>
								</cfdefaultcase>
							</cfswitch>
							<cfset write_to_buffer('</td>')>
							<cfif i eq ArrayLen(arDesplegar)>
								<cfset write_to_buffer('
								<td>
								<table cellspacing="1" cellpadding="0" >
									<tr>
										<td><input type="submit" value="#Filtrar#" class="btnFiltrar" onclick="javascript:return filtrar_Plista#params.PageIndex#();"></td>
									</tr>
								</table> 
								</td>
								')>
							</cfif>
							<cfset write_to_buffer('</tr>')>
							<cfset write_to_buffer('</table> ')>
						<cfset write_to_buffer('</td>')>
					</cfloop>
					<cfif ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "D">
						<cfset write_to_buffer('<td class="tituloListas" align="left" width="1%"></td>')>
					</cfif>
				<cfset write_to_buffer('</tr>')>
			</cfif>
			<!--- Fila de Botones Superior --->
			<cfif ListLen(params.botones) GT 0 and params.mostrar_filtro  eq 'true' and rsLista.RecordCount GT params.FilasParaBotonesSuperiores and (MaxRows_lista GT params.FilasParaBotonesSuperiores OR MaxRows_lista EQ 0)>
				<cfset write_to_buffer('<tr>')>
					<cfset write_to_buffer('<td class="listaNon" align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#">')>
						<cfset write_to_buffer('#_LvarBotones#')>
					<cfset write_to_buffer('</td>')>
				<cfset write_to_buffer('</tr>')>
			</cfif>

			<cfset  ArraykeyCorte = ListToArray(params.keyCorte)>
			<cfloop query="rsLista" startrow="#StartRow_lista#" endrow="#StartRow_lista + MaxRows_lista-1#">
				<cfloop index="i" from="1" to="#lCortes#">
					<cfif lCortes GT 0>
						<cfif DatosCorte[i] NEQ #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
							<cfset DatosCorte[i] = #Evaluate('rsLista.#Trim(ColsCorte[i])#')#>
							<cfset write_to_buffer('<tr class="listaCorte"> <td class="listaCorte" align="left" width="18" height="17" nowrap>')>
							<cfif ucase(params.chkcortes) EQ "S">
								<cfif ArrayLen(ArraykeyCorte) LT i>
									<cfset keyCorte = Trim(ArraykeyCorte[1])>
								<cfelse>
									<cfset keyCorte = Trim(ArraykeyCorte[i])>
								</cfif>
								<cfset write_to_buffer('<input type="checkbox" name="chkPadre" value="#Trim(Evaluate('rsLista.#keyCorte#'))#" onclick="javascript: funcChkPadre(this); UpdChkAll(this);">')>
							</cfif>
							<cfset write_to_buffer('</td> <td align="left" colspan="#Iif(params.checkboxes EQ "S" or params.radios EQ "S" or params.chkcortes EQ "S", colsp+1, colsp)#"><strong>#DatosCorte[i]#</strong></td> </tr>')>
							<cfloop index="j" from="#i+1#" to="#lCortes#">
								<cfset DatosCorte[j] = "">
							</cfloop>
						</cfif>
					</cfif>	
				</cfloop>
				<!---
					cuando alternar = no, se usa la clase listaNon solamente
				--->
				<cfset LvarListaNon = (CurrentRow MOD 2) or not params.alternar eq  'true'>
				<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>

				<cfset write_to_buffer('<tr class="#LvarClassName#" ')>
				<cfset write_to_buffer('onmouseover="this.className=')>
				<cfset write_to_buffer("'#LvarClassName#Sel';")>
				<cfset write_to_buffer('" onmouseout="this.className=')>
				<cfset write_to_buffer("'#LvarClassName#';")>
				<cfset write_to_buffer('">')>

				<!--- Valores para los params.checkboxes o params.radios --->
				<cfif ucase(params.checkboxes) EQ "S" or ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "S" or ucase(params.radios) EQ "D" or ucase(params.chkcortes) EQ "S">
					<cfset Lista="">
					<cfif Len(Trim(params.keys))>
						<cfset keys2=ListtoArray(ucase(params.keys),",")>
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
				<cfif ucase(params.checkboxes) EQ "S" or ucase(params.radios) EQ "S">
					<!--- params.checkboxes o params.radios a la Izquierda --->
					<cfset write_to_buffer('<td class="#LvarClassName#" align="left" width="1%">')>
					<cfset write_to_buffer('<input type="')>
					<cfif ucase(params.checkboxes) EQ 'S'>
						<cfset write_to_buffer('checkbox"')>
					<cfelse>
						<cfset write_to_buffer('radio"')>
					</cfif>
					<cfset write_to_buffer(' name="chk" value="#Lista#" onclick="javascript: ')> 
					<cfif Len(Trim(params.checkbox_function))>
						<cfset write_to_buffer('#params.checkbox_function#;')>
					</cfif>
					<cfif len(trim(params.desplegar)) and params.mostrar_filtro  eq 'true' and ucase(params.checkboxes) EQ "S">
						<cfset write_to_buffer('funcFiltroChkThis#params.formName#(this);')>
					</cfif>
					<cfset write_to_buffer(' void(0);"')>
					<cfif Len(Trim(params.checkedCol)) NEQ 0 and (Evaluate('rsLista.#Trim(params.checkedCol)#') EQ Lista OR lcase(Evaluate('rsLista.#Trim(params.checkedCol)#')) EQ "checked")>
						<cfset write_to_buffer(' checked')>
					</cfif>
					<cfset ListaPrimerVal = listFirst(Lista,"|")>
					<cfif Len(Trim(params.inactiveCol)) NEQ 0 and Evaluate('rsLista.#Trim(params.inactiveCol)#') EQ ListaPrimerVal>
						<cfset write_to_buffer(' disabled')>
					</cfif>
					<cfset write_to_buffer(' style="border:none; background-color:inherit;">')>
					<cfset write_to_buffer('</td>')>
				<cfelseif ucase(params.chkcortes) EQ "S">
					<!--- params.checkboxes para los detalles de los cortes --->
					<cfset write_to_buffer(' <td class="#LvarClassName#" align="left" width="1%"> ')>
					<cfset write_to_buffer('<input type="checkbox" name="chkHijo_#Trim(Evaluate('rsLista.#Trim(params.keyCorte)#'))#" value="#Lista#" ')>
					<cfset write_to_buffer('onclick="javascript: UpdChkPadre(this);"> ')>
				</cfif>
				<!--- Salida de datos --->
				<cfset col = 1>
				<!--- Para poder indicar el ítem seleccionado en la lista --->
				<cfset datosBD ="">
				<cfif Len(Trim(params.funcion))>
					<cfset invocacion_de_funcion = params.funcion>
					<cfif Len(Trim(params.fparams))>
						<cfset invocacion_de_funcion = invocacion_de_funcion & "(">
						<cfloop index="fidx" list="#params.fparams#">
							<cfif IsBinary(Evaluate('rsLista.#Trim(fidx)#'))>
								<cfset ts_temp = "">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#Evaluate('rsLista.#Trim(fidx)#')#" returnvariable="ts_temp"></cfinvoke>
								<cfset invocacion_de_funcion = invocacion_de_funcion & "'" & #HTMLEditFormat(JSStringFormat(ts_temp))# & "', ">
							<cfelse>
								<cfset invocacion_de_funcion = invocacion_de_funcion & "'" & #HTMLEditFormat(JSStringFormat(Evaluate('rsLista.#Trim(fidx)#')))# & "', ">
							</cfif>
						</cfloop>
						<cfset invocacion_de_funcion = Left(invocacion_de_funcion, Len(invocacion_de_funcion)-2) & ");">
					</cfif>
				</cfif>
		
				<!---<cfloop index="cName" list="#ArraytoList(columnas)#"><cfset datosBD = datosBD & Trim(Evaluate('rsLista.#Trim(cName)#'))></cfloop>--->
				<cfif isdefined("params.keys") and Len(Trim(params.keys))>
					<cfloop index="cName" list="#params.keys#"><cfif not IsBinary(Evaluate('rsLista.#Trim(cName)#'))><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfif></cfloop>
				<cfelse>
					<cfloop index="cName" list="#ArraytoList(columnas)#"><cfif not IsBinary(Evaluate('rsLista.#Trim(cName)#'))><cfset datosBD = datosBD & Trim(#Evaluate('rsLista.#Trim(cName)#')#)></cfif></cfloop>
				</cfif>

				<cfloop index="cName" list="#params.desplegar#">
					<!--- acumular para el total, si es necesario --->
					<cfset dName = Trim(cName)>
					<cfset valor_actual = Evaluate('rsLista.#dName#')>
					<cfif find(chr(128),valor_actual)>
						<cfset valor_actual = replace(Trim(valor_actual),chr(128),chr(8364),"ALL")>
                    </cfif>
					<cfif ListFind(params.totales, dName)>
						<cfif Len(valor_actual) and valor_actual neq 0>
							<cfset total_acumulado[dName] = total_acumulado[dName] + valor_actual>
						</cfif>
					</cfif>
					<!--- Para que indique el último seleccionado --->
					<cfif col EQ 1>
						<cfset write_to_buffer(' <td align="left" width="18" height="18" nowrap')>
						<cfif Len(Trim(params.funcion))> 
							<cfset write_to_buffer(' onclick="javascript: #invocacion_de_funcion#"')>
						<cfelseif params.showLink eq 'true'>
							<cfset write_to_buffer(' onclick="javascript: ')>
							<cfset write_to_buffer("return Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#params.formName#'")>
							<cfif not params.incluyeForm>
								<cfset write_to_buffer(", '#params.irA#'")>
							</cfif>
							<cfset write_to_buffer(');"')>
						</cfif>
                        <cfset write_to_buffer('>')>
						<cfif comparenocase(datosBD,datosPost) EQ 0 and not isdefined("Nuevo")>								
							  <cfset write_to_buffer(' <img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18">')> 
						</cfif>
						<cfset write_to_buffer(' </td>')>
					</cfif>
					<!--- Se genera la Salida de la Lista --->
					<cfset LvarColor = "">
					<cfif trim(params.LineaVerde) NEQ "">
						<cfif evaluate(params.LineaVerde)>
							<cfset LvarColor = "color:##00CC00;">
						</cfif>	
					</cfif>
					<cfif trim(params.LineaRoja) NEQ "">
						<cfif evaluate(params.LineaRoja)>
							<cfset LvarColor = "color:##FF0000;">
						</cfif>	
					</cfif>
					<cfif trim(params.LineaAzul) NEQ "">
						<cfif evaluate(params.LineaAzul)>
							<cfset LvarColor = "color:##0000FF;">
						</cfif>	
					</cfif>
					<cfset write_to_buffer('<td align="#Trim(alin[col])#" class="pStyle_#dName#"')>
					<cfset ArrayAjustar = listToArray(params.ajustar)>
					<cfif ArrayLen(ArrayAjustar) lt col><cfset IdxAjustar = 1><cfelse><cfset IdxAjustar = col></cfif>
					<cfif arrayLen(ArrayAjustar) gte IdxAjustar >
						<cfif ArrayAjustar[IdxAjustar] NEQ "S"><cfset write_to_buffer(' nowrap ')></cfif>
					</cfif>
					<cfif not (isdefined("params.formatos") and Len(Trim(params.formatos)) and Trim(fmt[col]) EQ "IMG")>
						<cfif Len(Trim(params.funcion))> 
							<cfset write_to_buffer('style="padding-right: 3px; cursor: pointer; #LvarColor#" onclick="javascript: #invocacion_de_funcion#"')>
						<cfelseif params.showLink eq 'true'>
							<cfset write_to_buffer('style="padding-right: 3px; cursor: pointer; #LvarColor#"')>
							<cfset write_to_buffer(' onclick="javascript: ')>
							<cfset write_to_buffer("return Procesar('#rsLista.CurrentRow#','#ArrayLen(columnas)#','#params.formName#'")>
							<cfif not params.incluyeForm>
								<cfset write_to_buffer(", '#params.irA#'")>
							</cfif>
							<cfset write_to_buffer(');"')>
						<cfelseif LvarColor NEQ "">
							<cfset write_to_buffer('style="#LvarColor#"')>
						</cfif>
					<cfelseif LvarColor NEQ "">
						<cfset write_to_buffer('style="#LvarColor#"')>
					</cfif>
					<cfset write_to_buffer(' onmouseover="javascript: ')>
					<cfset write_to_buffer(" window.status = ''; ")>
					<cfset write_to_buffer(' return true;" onmouseout="javascript: ')>
					<cfset write_to_buffer(" window.status = ''; ")>
					<cfset write_to_buffer(' return true;"')>

					<cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
						<cfset write_to_buffer(' style="font-size:#params.fontsize#px"')>
					</cfif>
                    <cfset write_to_buffer('>')>
					<cfif trim(alin[col]) EQ "right">
	                    <cfset write_to_buffer('&nbsp;')>
					</cfif>
					<!--- indentar cuando hay cortes, esto porque se quitó el text-indent del CSS listaPar y listaNon (danim) --->
					<cfif col EQ 1 and lCortes gt 0>
						<cfset write_to_buffer('&nbsp;&nbsp;&nbsp;')>
					</cfif>
					<cfif trim(ucase(dName)) EQ "CF_CURRENTROW">
						<cfset write_to_buffer('#rsLista.currentRow#')>
					<cfelseif Len(Trim(params.formatos)) EQ 0>
						<cfset write_to_buffer('#valor_actual#')>
					<cfelseif trim(valor_actual) EQ "">
						<cfset LvarFormato = Trim(fmt[col])>
						<cfset LvarPto = find(" ",LvarFormato)>
						<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
						<cfswitch expression="#LvarFormato#">
							<!--- Formato de Fecha pero cuando el campo es nulo, se coloca la palabra INDEFINIDO --->
							<cfcase value="DI">
								<cfset write_to_buffer('INDEFINIDO')>
							</cfcase>
						</cfswitch>
					<cfelse>
						<cfset LvarFormato = Trim(fmt[col])>
						<cfset LvarPto = find(" ",LvarFormato)>
						<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
						<cfswitch expression="#LvarFormato#">
							<cfcase value="P,UP">
								<cfset write_to_buffer('#LsCurrencyFormat(valor_actual,"none")#%')>
							</cfcase>
							<cfcase value="M,UM">
								<cfset write_to_buffer('#LsCurrencyFormat(valor_actual,"none")#')>
							</cfcase>
							<cfcase value="R,UR">
								<cfif evaluate(mid(Trim(fmt[col]),LvarPto,100))>
									<cfset write_to_buffer('<font color="##FF0000">#LsCurrencyFormat(valor_actual,"none")#</font>')>
								<cfelse>
									<cfset write_to_buffer('#LsCurrencyFormat(valor_actual,"none")#')>
								</cfif>
							</cfcase>
							<cfcase value="D,UD">
								<cfif Len(Trim(valor_actual))>
									<cfinvoke component="locale" method="date" returnvariable="LvarLocaleDate">
										<cfinvokeargument name="value"		value="#valor_actual#">
									</cfinvoke>
									<cfset write_to_buffer('#LvarLocaleDate#')>
								</cfif>
							</cfcase>
							<!--- IDem cfcase value ="D" --->
							<cfcase value="DI,UDI">
								<cfif Len(Trim(valor_actual))>
									<cfset write_to_buffer('#LSDateFormat(valor_actual,"dd/mm/yyyy")#')>
								</cfif>
							</cfcase>
							<cfcase value="I,UI">
								<cfset write_to_buffer('#valor_actual#')>
							</cfcase>
							<cfcase value="L">
								<cfif Evaluate('rsLista.#dName#') EQ 1>
									<cfset write_to_buffer('SI')>
								</cfif>
							</cfcase>
							<cfcase value="N,F,UN,UF">
								<cfset write_to_buffer('#LSNumberFormat(valor_actual,"-__________.____")#')>
							</cfcase>
							<cfcase value="H">
								<cfif Len(Trim(valor_actual))>
									<cfset write_to_buffer('#LSTimeFormat(valor_actual,"hh:mm tt")#')>
								</cfif>
							</cfcase>
							<!--- Formato de Fecha con Hora --->
							<cfcase value="DT">
								<cfif Len(Trim(valor_actual))>
									<cfset write_to_buffer('#LSDateFormat(valor_actual,"dd/mm/yyyy")# #LSTimeFormat(valor_actual,"hh:mm tt")#')>
								</cfif>
							</cfcase>
							<cfdefaultcase>
								<cfset write_to_buffer('#valor_actual#')>
							</cfdefaultcase>
						</cfswitch>
					</cfif>
					<!---
					Se quito el href, quitar estos comentarios cuando se compruebe que todo funciona bien
					<cfif not (isdefined("formatos") and Len(Trim(formatos)) and Trim(fmt[col]) EQ "IMG")>
						<cfif showLink eq 'true' OR Len(Trim(funcion)) NEQ 0></a></cfif>
					</cfif>
					--->
					<cfif trim(alin[col]) EQ "left">
	                    <cfset write_to_buffer('&nbsp;')>
					</cfif>
					<cfset write_to_buffer('</td>')>
					<cfset col = col + 1>
				</cfloop>
				<!--- params.checkboxes o params.radios a la derecha --->
				<cfif ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "D">
					<cfset write_to_buffer('<td class="#LvarClassName#" align="center"> ')>
					<cfset write_to_buffer('<input type=" ')>
					<cfif ucase(params.checkboxes) EQ 'D'>
						<cfset write_to_buffer('checkbox')>
					<cfelse>
						<cfset write_to_buffer('radio')>
					</cfif>
					<cfset write_to_buffer('" name="chk" value="#Lista#" ')>
					<cfif Len(Trim(params.checkbox_function))>
						<cfset write_to_buffer('onClick="javascript: #params.checkbox_function#" ')>
					</cfif>
					<cfif Len(Trim(params.checkedCol)) NEQ 0 and (Evaluate('rsLista.#Trim(params.checkedCol)#') EQ Lista OR lcase(Evaluate('rsLista.#Trim(params.checkedCol)#')) EQ "checked")>
						<cfset write_to_buffer('checked ')>
					</cfif>
					<cfset ListaPrimerVal = listFirst(Lista,"|")>
					<cfif Len(Trim(params.inactiveCol)) NEQ 0 and Evaluate('rsLista.#Trim(params.inactiveCol)#') EQ ListaPrimerVal>
						<cfset write_to_buffer('disabled ')>
					</cfif>>
					<cfset write_to_buffer('</td>')>
				</cfif>
				<cfset write_to_buffer('</tr>')>
				
				<cfset write_to_buffer('<tr> ')>
				<cfset write_to_buffer('<td colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#"> ')>
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfset write_to_buffer('<input name="#ucase(Trim(ucase(columnas[i])))#_#rsLista.CurrentRow#" type="hidden" ')>
					<cfset write_to_buffer('value="')>
					<cfif not ISBinary(Evaluate('rsLista.#Trim(columnas[i])#'))>
						<cfset write_to_buffer('#HTMLEditFormat(Evaluate("rsLista.#Trim(columnas[i])#"))#')>
					</cfif>
					<cfset write_to_buffer('" disabled> ')> 
				</cfloop>
			</cfloop>
			<!--- FILA DE TOTALES --->
			<cfif Len(Trim(params.totales))>
				<cfset write_to_buffer('<tr>')>
				<!--- Valores para los params.checkboxes --->
				<cfif ucase(params.checkboxes) EQ "S" or ucase(params.radios) EQ "S">
					<cfset write_to_buffer('<td>&nbsp;</td>')><!--- params.checkboxes a la Izquierda --->
				</cfif>
				<cfset write_to_buffer('<td>&nbsp;</td>')><!--- columna del elemento seleccionado addressGo.gif --->
				<!--- Salida de datos --->
				<cfset col=1>
				<cfloop index="cName" list="#params.desplegar#">
					<cfset write_to_buffer('<td class="tituloListas" align="#Trim(alin[col])#" ')> 
					<cfif params.ajustar NEQ "S">
						<cfset write_to_buffer(' nowrap >')>
					</cfif>
					<!--- mostrar el total, si es necesario --->
					<cfset dName = Trim(cName)>
                    
					<cfif ListFind(params.totales, dName)>
						<cfset write_to_buffer('<strong ')> 
						<cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
							<cfset write_to_buffer('style="font-size:#params.fontsize#px"')>
						</cfif>
						<cfset write_to_buffer('>&nbsp;&nbsp;')>
						<cfif len(trim(params.pasarTotales))>
							<cfset total_acumulado[dName]=pTotales[dName]>
						</cfif>
						<cfif Len(Trim(params.formatos)) EQ 0>
							<cfset write_to_buffer('#total_acumulado[dName]#')>
						<cfelse>
							<cfset LvarFormato = Trim(fmt[col])>
							<cfset LvarPto = find(" ",LvarFormato)>
							<cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
							<cfswitch expression="#LvarFormato#">
								<cfcase value="P,UP">
									<cfset write_to_buffer('#LsCurrencyFormat(total_acumulado[dName],"none")#%')>
								</cfcase>
								<cfcase value="M,UM">
									<cfset write_to_buffer('#LsCurrencyFormat(total_acumulado[dName],"none")#')>
								</cfcase>
								<cfcase value="R,UR">
									<cfset write_to_buffer('#LsCurrencyFormat(total_acumulado[dName],"none")#')>
								</cfcase>
								<cfcase value="I,UI">
									<cfset write_to_buffer('#total_acumulado[dName]#')>
								</cfcase>
								<cfcase value="N,F,UN,UF">
									<cfset write_to_buffer('#LSNumberFormat(total_acumulado[dName],"-__________.____")#')>
								</cfcase>
								<cfdefaultcase>
									<cfset write_to_buffer('#total_acumulado[dName]#')>
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfset write_to_buffer(' </strong> ')>
					<cfelse>
						<cfset write_to_buffer(' &nbsp; ')>
					</cfif>
					<cfset write_to_buffer('</td>')>
					<cfset col=col+1>
				</cfloop>
				<!--- params.checkboxes a la derecha --->
				<cfif ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "D">
					<cfset write_to_buffer('<td>&nbsp;</td>')>
				</cfif>
				<cfset write_to_buffer('</tr>')>
			</cfif><!--- fila de totales --->


			<!--- TOTAL DE TOTALES --->
			<cfif Len(Trim(params.totalgenerales))>
				<!--- Pinta la fila con los totales --->
				<cfset write_to_buffer('<tr class="listaCorte">')>
				<!--- Valores para los params.checkboxes --->
				<cfif ucase(params.checkboxes) EQ "S" or ucase(params.radios) EQ "S">
					<!--- params.checkboxes a la Izquierda --->
					<cfset write_to_buffer('<td>&nbsp;</td>')>
				</cfif>
				<!--- columna del elemento seleccionado addressGo.gif --->
   				<cfset write_to_buffer('<td>&nbsp;</td>')>
				<!--- Salida de datos --->
				<cfset col=1>
				<cfloop index="cName" list="#params.desplegar#">
					<cfset write_to_buffer('<td align="#Trim(alin[col])#"')> 
					<cfif params.ajustar NEQ "S">
						<cfset write_to_buffer(' nowrap ')>
                    </cfif>>
					<cfset write_to_buffer('>')>
                    <!--- mostrar el total, si es necesario --->
                    <cfset dName = Trim(cName)>
                    <cfif ListFind(params.totalgenerales, dName)>
                        <!--- Query de Queries para calcular totales --->
                        <cfquery name="rsTotalGenerales" dbtype="query">
                            select sum(#dName#) as #dName#
                            from rsLista
                        </cfquery>
                        <cfset Tvalor_actual = Evaluate("rsTotalGenerales.#dName#")>
                        <cfset write_to_buffer('<strong ')>
                        <cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
                            <cfset write_to_buffer('style="font-size:#params.fontsize#px"')>
                        </cfif>
                        <cfset write_to_buffer('>')>                            
                        <cfif Len(Trim(params.formatos)) EQ 0>
                            <cfset write_to_buffer('#Tvalor_actual#')>
                        <cfelse>
                            <cfset LvarFormato = Trim(fmt[col])>
                            <cfset LvarPto = find(" ",LvarFormato)>
                            <cfif LvarPto GT 0><cfset LvarFormato = mid(LvarFormato,1,LvarPto-1)></cfif>
                            <cfswitch expression="LvarFormato">
                                <cfcase value="P,UP">
                                    <cfset write_to_buffer('#LsCurrencyFormat(total_acumulado[dName],"none")#%')>
                                </cfcase>
                                <cfcase value="M,UM">
                                    <cfset write_to_buffer('#LsCurrencyFormat(Tvalor_actual,"none")#')>
                                </cfcase>
                                <cfcase value="R,UR">
                                    <cfset write_to_buffer('#LsCurrencyFormat(Tvalor_actual,"none")#')>
                                </cfcase>
                                <cfcase value="I,UI">
                                    <cfset write_to_buffer('#Tvalor_actual#')>
                                </cfcase>
                                <cfcase value="N,F,UN,UF">
                                    <cfset write_to_buffer('#LSNumberFormat(Tvalor_actual,"-__________.____")#')>
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset write_to_buffer('#NumberFormat(Tvalor_actual, ",9.00")#')>
                                </cfdefaultcase>
                            </cfswitch>
                        </cfif>
                        <cfset write_to_buffer('</strong>')>
                    <cfelse>
                        <cfset write_to_buffer('&nbsp;')>
                    </cfif>
					<cfset write_to_buffer('</td>')>
					<cfset col=col+1>
				</cfloop>
				<!--- params.checkboxes a la derecha --->
				<cfif ucase(params.checkboxes) EQ "D" or ucase(params.radios) EQ "D">
					<cfset write_to_buffer('<td>&nbsp;</td>')><!---<input type="checkbox" name="chk" value="#Lista#">--->
				</cfif>
				<cfset write_to_buffer('</tr>')>
			</cfif><!--- fila de totales --->
			<cfif params.showEmptyListMsg eq 'true' and rsLista.RecordCount lte 0>
				<cfset write_to_buffer('<tr>')>
					<cfset write_to_buffer('<td align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#" class="listaCorte"')>
						<cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
							<cfset write_to_buffer('style="font-size:#params.fontsize#px"')>
				</cfif>
				<cfset write_to_buffer('>')>
						<cfset write_to_buffer('#params.EmptyListMsg#')>
					<cfset write_to_buffer('</td>')>
				<cfset write_to_buffer('</tr>')>
			</cfif>

			<cfif params.MaxRows GT 0 and params.MaxRows LT rsLista.RecordCount or PageNum_lista NEQ 1>
				<cfset fnPreparaHTMLFin()>
			</cfif>
			<!--- Fila de Botones Inferior --->
			<cfif ListLen(params.botones) GT 0>
				<cfset write_to_buffer('<tr>')>
				<cfset write_to_buffer('<td class="listaNon" align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#"> ')>
				<cfset write_to_buffer('#_LvarBotones#')>
				<cfset write_to_buffer('</td>')>
				<cfset write_to_buffer('</tr>')>
			</cfif>
			
			<cfset write_to_buffer('</table>')>

			<cfset write_to_buffer('<input type="hidden" name="PageNum#params.PageIndex#" value="#PageNum_lista#">')>

			<cfif params.incluyeForm>
				<cfset write_to_buffer('</form>')>
			</cfif>

			<cfreturn true>
	</cffunction>
	
	<cffunction name="fnPreparaHTML2" access="private" output="no" hint="Prepara los JavaScript Necesarios para el manejo de Listas usando AJAX. Funcion No. 3">
		<cfargument name="Continuar" type="boolean" required="yes">
		<cfif params.checkboxes EQ "S">
			<cfset write_to_buffer('<script type="text/javascript" language="JavaScript">
				function fnAlgunoMarcado#params.formName#(){
					if (document.#params.formName#.chk) {
						if (document.#params.formName#.chk.value) {
							return document.#params.formName#.chk.checked;
						} else {
							for (var i=0; i<document.#params.formName#.chk.length; i++) {
								if (document.#params.formName#.chk[i].checked) { 
									return true;
								}
							}
						}
					}
					return false;
				}</script>
			')>
		</cfif>
		<cfif params.mostrar_filtro eq 'true'>
			<cfset write_to_buffer('<script type="text/javascript" language="JavaScript"> ')>
			<cfset write_to_buffer('function filtrar_Plista#params.PageIndex#(){ ')>	
			<cfset write_to_buffer("document.#params.formName#.action='#CurrentPage#'; ")>		
			<cfset write_to_buffer('if (window.funcFiltrar#params.PageIndex#) { ')>
			<cfset write_to_buffer('if (funcFiltrar#params.PageIndex#()) { return true; } ')>
			<cfset write_to_buffer('} else { return true; } ')>
			<cfset write_to_buffer('return false; } ')>
			<cfset write_to_buffer('</script> ')>
		</cfif>
		<cfif len(trim(params.desplegar)) and ucase(params.checkboxes) EQ "S">
			<cfset write_to_buffer(' 
			<script type="text/javascript" language="JavaScript">
				<!--//
					function funcFiltroChkAll#params.formName#(c){
						if (document.#params.formName#.chk) {
							if (document.#params.formName#.chk.value) {
								if (!document.#params.formName#.chk.disabled) { 
									document.#params.formName#.chk.checked = c.checked;
								}
							} else {
								for (var counter = 0; counter < document.#params.formName#.chk.length; counter++) {
									if (!document.#params.formName#.chk[counter].disabled) {
										document.#params.formName#.chk[counter].checked = c.checked;
									}
								}
							}
						}
					}
					function funcFiltroChkThis#params.formName#(c){
						checked = true;
						if (document.#params.formName#.chk) {
							if (document.#params.formName#.chk.value) {
								if (!document.#params.formName#.chk.disabled) { 
									if (!document.#params.formName#.chk.checked) {
										checked = false;
									}									
								}
							} else {
								for (var counter = 0; counter < document.#params.formName#.chk.length; counter++) {
									if (!document.#params.formName#.chk[counter].disabled) {
										if (!document.#params.formName#.chk[counter].checked) {
											checked = false;
										}	
									}
								}
							}
						}
						document.#params.formName#.chkAllItems.checked = checked;
					}
				//-->
			</script>
			')>
		</cfif>
		<cfif ucase(params.chkcortes) EQ "S">
			<cfset write_to_buffer('<script type="text/javascript" language="JavaScript"> ')>
			<cfset write_to_buffer('
				function funcChkAll(c) {
					if (document.#params.formName#.chkPadre) {
						if (document.#params.formName#.chkPadre.value) {
							if (!document.#params.formName#.chkPadre.disabled) { 
								document.#params.formName#.chkPadre.checked = c.checked;
								funcChkPadre(document.#params.formName#.chkPadre);
							}
						} else {
							for (var counter = 0; counter < document.#params.formName#.chkPadre.length; counter++) {
								if (!document.#params.formName#.chkPadre[counter].disabled) {
									document.#params.formName#.chkPadre[counter].checked = c.checked;
									funcChkPadre(document.#params.formName#.chkPadre[counter]);
								}
							}
						}
					}
				}
			')>
			<cfset write_to_buffer('
				function UpdChkAll(c) {
					var allChecked = true;
					if (!c.checked) {
						allChecked = false;
					} else {
						if (document.#params.formName#.chkPadre.value) {
							if (!document.#params.formName#.chkPadre.disabled) allChecked = true;
						} else {
							for (var counter = 0; counter < document.#params.formName#.chkPadre.length; counter++) {
								if (!document.#params.formName#.chkPadre[counter].disabled && !document.#params.formName#.chkPadre[counter].checked) {allChecked=false; break;}
							}
						}
					}
					document.#params.formName#.chkAllItems.checked = allChecked;
				}		
			')>
			<cfset write_to_buffer("
				function funcChkPadre(c) {
					if (document.#params.formName#['chkHijo_'+c.value]) {
						if (document.#params.formName#['chkHijo_'+c.value].value) {
							if (!document.#params.formName#['chkHijo_'+c.value].disabled) document.#params.formName#['chkHijo_'+c.value].checked = c.checked;
						} else {
							for (var counter = 0; counter < document.#params.formName#['chkHijo_'+c.value].length; counter++) {
								if (!document.#params.formName#['chkHijo_'+c.value][counter].disabled) document.#params.formName#['chkHijo_'+c.value][counter].checked = c.checked;
							}
						}
					}
				}
			")>
			<cfset write_to_buffer("
				function UpdChkPadre(c) {
					var idPadre = '' + c.name.split('_')[1];
					var allChecked = true;
					if (!c.checked) {
						allChecked = false;
					} else {
						if (document.#params.formName#['chkHijo_'+idPadre].value) {
							if (!document.#params.formName#['chkHijo_'+idPadre].disabled) allChecked = true;
						} else {
							for (var counter = 0; counter < document.#params.formName#['chkHijo_'+idPadre].length; counter++) {
								if (!document.#params.formName#['chkHijo_'+idPadre][counter].disabled && !document.#params.formName#['chkHijo_'+idPadre][counter].checked) {
									allChecked=false; break;
								}
							}
						}
					}
					if (document.#params.formName#.chkPadre.value) {
						document.#params.formName#.chkPadre.checked = allChecked;
						UpdChkAll(document.#params.formName#.chkPadre);
					} else {
						for (var counter = 0; counter < document.#params.formName#.chkPadre.length; counter++) {
							if (!document.#params.formName#.chkPadre[counter].disabled && document.#params.formName#.chkPadre[counter].value == idPadre) {
								document.#params.formName#.chkPadre[counter].checked = allChecked; 
								UpdChkAll(document.#params.formName#.chkPadre[counter]);
								break;
							}
						}
					}
				}		
			")>
			<cfset write_to_buffer('</script> ')>
		</cfif>
		<cfif not Arguments.Continuar>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="fnPreparaHTMLFin" access="private" output="no" hint="Prepara el final de la pagina ( Area de Botones y Gráficos">
		<!--- LINEA DE MAXROWSQUERY QUE INDICA AL USUARIO QUE NO ESTA VIENDO TODOS LOS REGISTROS DE LA BASE DE DATOS  --->
		<cfset Desde = 1>
		<cfif isdefined("PageNum_lista")>
			<cfset Desde = (PageNum_lista*params.maxrows)-params.maxrows+1>
		</cfif>
		<cfset Hasta = Desde + params.maxrows-1>
		<cfif params.maxrowsquery GT 0 and params.maxrowsquery LTE rsLista.recordcount>
			<cfif Hasta GT params.maxrowsquery>
				<cfset Hasta = params.maxrowsquery>
			</cfif>
		<cfelse>
			<cfif Hasta GT rsLista.recordcount>
				<cfset Hasta = rsLista.recordcount>
			</cfif>
		</cfif>

		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VistaActual" Default="Vista Actual" XmlFile="/rh/generales.xml" Idioma="" returnvariable="_LvarVistaActual"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_de"          Default="de" XmlFile="/rh/generales.xml" Idioma="" returnvariable="_LvarDe"/>
		
		<cfset _LvarListaLimitada = "">
		<cfif params.maxrowsquery gt 0 and (Desde LTE Hasta)>
			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaLimitada" Default="Lista Limitada" XmlFile="/rh/generales.xml" Idioma="" returnvariable="_LvarListaLimitada"/>
			<cfset _LvarListaLimitada = "(* #_LvarListaLimitada#)">
		</cfif>
				
		<cfset _LvarStyle = "">
		<cfif isdefined("params.fontsize") and len(trim(params.fontsize))>
			<cfset _LvarStyle = 'style="font-size:#params.fontsize#px"'>
		</cfif>
		
		<cfset write_to_buffer('<tr><td align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr> ')>
			
		<cfif params.FinReporte NEQ "" AND PageNum_lista GTE TotalPages_lista>
			<cfset write_to_buffer(' 
				<tr>
				<td align="center" class="listaCorte" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#" 
				#_LvarStyle#
				#params.FinReporte#
				</td>
				</tr>
				<tr>
				<td align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td>
				</tr>
			')>
		</cfif>

		<cfset write_to_buffer('
			<tr> 
			<td align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="99%" align="center">
		')>

		<cfif params.usaAJAX>
			<cfif PageNum_lista GT 1>
				<cfset write_to_buffer('<a href="javascript:doQuery_Plista#params.PageIndex#(1)" tabindex="-1"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="18" border=0> ')>
			</cfif>
			<cfif PageNum_lista GT 1>
				<cfset write_to_buffer('<a href="javascript:doQuery_Plista#params.PageIndex#(#Max(DecrementValue(PageNum_lista),1)#)" tabindex="-1"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="14" border=0> ')>
			</cfif>
			<cfif PageNum_lista LT TotalPages_lista>
				<cfset write_to_buffer('<a href="javascript:doQuery_Plista#params.PageIndex#(#Min(IncrementValue(PageNum_lista),TotalPages_lista)#)" tabindex="-1"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="14" border=0> ')>
			</cfif>
			<cfif PageNum_lista LT TotalPages_lista>
				<cfset write_to_buffer('<a href="javascript:doQuery_Plista#params.PageIndex#(#TotalPages_lista#)" tabindex="-1"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="18" border=0> ')>
			</cfif> 
		<cfelse>
			<!---Primera pagina--->
			<cfif PageNum_lista GT 1>
				<cfset write_to_buffer('<a href="javascript: if(!window.FuncPlistasChangePage) window.location.href=''#CurrentPage#?PageNum_lista#params.PageIndex#=1#QueryString_lista#''; else FuncPlistasChangePage(''#CurrentPage#'',''#params.PageIndex#'',''1'',''#QueryString_lista#'');" tabindex="-1"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="18" border=0> ')>
			</cfif>
			<!---Pagina Anterior--->
			<cfif PageNum_lista GT 1>
				<cfset write_to_buffer('<a href="javascript: if(!window.FuncPlistasChangePage) window.location.href=''#CurrentPage#?PageNum_lista#params.PageIndex#=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#''; else FuncPlistasChangePage(''#CurrentPage#'',''#params.PageIndex#'',''#Max(DecrementValue(PageNum_lista),1)#'',''#QueryString_lista#'');" tabindex="-1"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="14" border=0> ')>
			</cfif>
			<!---Pagina Siguiente--->
			<cfif PageNum_lista LT TotalPages_lista>
				<cfset write_to_buffer('<a  href="javascript: if(!window.FuncPlistasChangePage) window.location.href=''#CurrentPage#?PageNum_lista#params.PageIndex#=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#''; else FuncPlistasChangePage(''#CurrentPage#'',''#params.PageIndex#'',''#Min(IncrementValue(PageNum_lista),TotalPages_lista)#'',''#QueryString_lista#'');" tabindex="-1"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="14" border=0> ')>
			</cfif>
			<!---Ultima Pagina--->
			<cfif PageNum_lista LT TotalPages_lista>
				<cfset write_to_buffer('<a href="javascript: if(!window.FuncPlistasChangePage) window.location.href=''#CurrentPage#?PageNum_lista#params.PageIndex#=#TotalPages_lista##QueryString_lista#''; else FuncPlistasChangePage(''#CurrentPage#'',''#params.PageIndex#'',''#TotalPages_lista#'',''#QueryString_lista#'');" tabindex="-1"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> ')>
			<cfelse>
				<cfset write_to_buffer('<img src="/cfmx/rh/imagenes/c2.gif" width="18" border=0> ')>
			</cfif> 
		</cfif>
		<cfset write_to_buffer('
			</td>
			<td nowrap align="right" width="1%" #_LvarStyle#>  #_LvarVistaActual# #Desde# - #Hasta# #_LvarDe# #rsLista.recordcount# #_LvarListaLimitada# </td>
			</tr>
			</table>
			</td>
			</tr>
			<tr><td align="center" colspan="#Iif(params.checkboxes EQ 'S' or params.radios EQ 'S', colsp+2, colsp+1)#">&nbsp;</td></tr>
		')>
	</cffunction>
	
	<cffunction name="fnPreparaDatos" output="no" access="private">
		<cfargument name="IDs" 			type="string" required="Yes">		
		<cfargument name="PageNum" 		type="numeric" required="Yes">
		<cfargument name="filtro_nuevo" type="boolean" required="Yes">
		<cfset LvarID = listGetAt(Arguments.IDs,1,"|")>
		<cfif NOT isnumeric(LvarID)>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_jPlistas7"
			Default="ID debe ser numerico"
			returnvariable="LB_jPlistas7"/> 
			<cf_throw message="#LB_jPlistas7#" errorCode="12070">
		</cfif>
		<cfset LvarIDs  = listGetAt(Arguments.IDs,2,"|")>
	
		<cfset Request.TemplateCSS = true>
		<cfset params = getQuery(LvarID, LvarIDs)>
		<cfset rsLista = params.query.rsSQL>
		<cfset columnas=ListtoArray(ucase(rsLista.columnList),",")>
		<cfset vis=ListtoArray(params.desplegar,",")>
		<cfset Longitud=ArrayLen(columnas)>
		<cfset colsp=ListLen(params.desplegar)>
		<!--- Para los formatos --->
		<cfif Len(Trim(params.formatos))>
			<cfset fmt=ListtoArray(params.formatos, ',')>
		</cfif>

		<!--- Para la Justificacion de Columnas --->
		<cfset alin=ListtoArray(params.align,",")>
		
		<!--- Para llevar los totales --->
		<cfset total_acumulado = StructNew()>
		<cfloop list="#params.totales#" index="columna_para_total">
			<cfset total_acumulado[Trim(columna_para_total)] = 0>
		</cfloop>
		<cfif len(trim(params.pasarTotales))>
			<cfset pTotales = structNew()>
			<cfset misTotales = ListToArray(params.pasarTotales)>
			<cfset iconsec = 1>
			<cfloop list="#params.totales#" index="columna_para_total">
				<cfset pTotales[Trim(columna_para_total)] = misTotales[iconsec]>
				<cfset iconsec = iconsec + 1>
			</cfloop>
		</cfif>
		<!--- Variables para controlar la cantidad de items a desplegar --->
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cfset PageNum_lista = Arguments.PageNum>
		<cfif params.MaxRows LT 1>
			<cfset params.MaxRows = rsLista.RecordCount>
		</cfif>
		<cfif params.MaxRows LT 1>
			<cfset MaxRows_lista = 1>
		<cfelse>
			<cfset MaxRows_lista = params.MaxRows>
		</cfif>
		<cfset StartRow_lista=Min((PageNum_lista-1) * MaxRows_lista + 1, Max(rsLista.RecordCount , 1))>
		<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,rsLista.RecordCount)>
		<cfset TotalPages_lista = Ceiling(rsLista.RecordCount/MaxRows_lista)>

		<cfif Arguments.Filtro_nuevo eq  'true'>
			<cfset PageNum_lista = 1>
		</cfif>
		<cfif PageNum_lista LT 1>
			<cfset PageNum_lista = 1>
		</cfif>

		<cfif len(Trim(params.QueryString_lista)) GT 0>
			<cfset QueryString_lista='&'&params.QueryString_lista>
		<cfelseif Len(Trim(CGI.QUERY_STRING)) GT 0>
			<cfset QueryString_lista='&'&CGI.QUERY_STRING>
		<cfelse>
			<cfset QueryString_lista="">
		</cfif>

		<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista#params.PageIndex#=","&")>
		<cfif tempPos NEQ 0>
		  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>

		<cfif Len(Trim(params.navegacion)) NEQ 0>
			<cfset nav = ListToArray(params.navegacion, "&")>
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
		<!--- Depura el arreglo de columnas para quitar los ALIAS--->
		<cfset columnas = ListtoArray(rsLista.columnList)>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_FechasMayores"
			default="Fechas Mayores"
			xmlfile="/rh/generales.xml"
			returnvariable="LB_FechasMayores"/>
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="BTN_Filtrar"
			default="Filtrar"
			xmlfile="/rh/generales.xml"
			returnvariable="Filtrar"/>

		<!--- Control de Cortes en la Lista --->
		<cfset ColsCorte = ListToArray(params.Cortes)>
		<cfset DatosCorte = ArrayNew(1)>
		<cfset lCortes = ListLen(Trim(params.Cortes))>
		<cfif lCortes GT 0>
			<cfset res = ArraySet(DatosCorte,1,lCortes,"")>
		</cfif>
		<cfset col = 1>
		<cfset datosPost ="">

		<cfif isdefined("params.keys") and Len(Trim(params.keys))>
			<cfset my_keys = params.keys>
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
	</cffunction>

	<cffunction name="ListFindNoCaseNoSpace" returntype="numeric">
		<cfargument name="List" required="yes">
		<cfargument name="Value" required="yes">
		<cfargument name="Delimiters" required="no" default=",">
		<cfset count = 0>
		<cfloop list="#List#" index="Item" delimiters="#Delimiters#">
			<cfset count = count + 1>
			<cfif trim(lcase(Item)) eq trim(lcase(Value))>
				<cfreturn count>
			</cfif>
		</cfloop>
		<cfreturn 0>
	</cffunction>

	<cffunction name="getQuery" output="no" access="private">
		<cfargument name="ID" 		 type="numeric" required="Yes">
		<cfargument name="IDs" 		 type="string" required="Yes">
	
		<cfset var LvarParametros = "">
		
		<cfif LvarID EQ -1>
			<cfset LvarParametros				= request.Plista_server.parametros>
			<cfset LvarParametros.query.rsSQL	= request.Plista_server.rsSQL>
		<cfelse>
			<cfif NOT find(",#Arguments.ID#,",",#Arguments.IDs#")>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_jPlistas5"
					Default="IDs debe contener ID"
					returnvariable="LB_jPlistas5"/> 
					<cf_throw message="#LB_jPlistas5#" errorCode="12060">
			</cfif>
			<cfquery name="rsSQL" datasource="sifcontrol">
				SELECT PlistaID, PlistaPRM 
				  FROM Plista 
				 WHERE PlistaID		= #Arguments.ID#
				   AND Usucodigo	= #session.Usucodigo#
			</cfquery>
			<cfif rsSQL.PlistaID EQ "">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_jPlistas6"
				Default="La pantalla ha expirado, favor refrescar de nuevo"
				returnvariable="LB_jPlistas6"/> 
				<cf_throw message="#LB_jPlistas6#" errorCode="12065">
			
			</cfif>
			<cfset updateTS(Arguments.IDs)>
			<!---
			<cfset LvarParametros = createobject("component","rh.Componentes.json").decode(rsSQL.PlistaPRM)>
			--->
			<cfwddx action="wddx2cfml" input="#rsSQL.PlistaPRM#" output="LvarParametros">
			<cfquery name="rsSQL" datasource="#LvarParametros.conexion#">
				#PreserveSingleQuotes(LvarParametros.query.SQL)#
			</cfquery>
			<cfset LvarParametros.query.rsSQL = rsSQL>
		</cfif>
	
		<cfreturn LvarParametros>
	</cffunction>
	<cffunction name="updateTS" output="no" access="remote">
		<cfargument name="IDs" 		 type="string" required="Yes">
	
		<cfif mid(Arguments.IDs,len(Arguments.IDs),1) EQ ",">
			<cfset LvarIDs = mid(Arguments.IDs,1,len(Arguments.IDs)-1)>
		<cfelse>
			<cfset LvarIDs = Arguments.IDs>
		</cfif>
		
		<cfquery datasource="sifcontrol">
			UPDATE Plista
			   SET PlistaTS	= {fn now()}
			 WHERE PlistaID		in (#LvarIDs#)
			   AND Usucodigo	= #session.Usucodigo#
		</cfquery>
	</cffunction>
</cfcomponent>