<cfcomponent>
	<cffunction name="fnListaMetodos" returntype="array">
		<cfargument name="WS" type="struct" required="yes">
	
		<cfset var LvarMethods = ArrayNew(1)>
	
		<cfif trim(Arguments.WS.proxyPort) EQ "">
			<cfset Arguments.WS.proxyPort = "1">
		</cfif>
		<cftry>
			<cfhttp method="GET" 
				url="#Arguments.WS.url#" 
				proxyserver="#Arguments.WS.proxyServer#"
				proxyport="#Arguments.WS.proxyPort#"
				username="#Arguments.WS.uid#"
				password="#Arguments.WS.pwd#"
				resolveurl="Yes" 
				throwOnError="Yes"
			/>
		<cfcatch type="any">
			<cfthrow message="ERROR DE COMUNICACION: #cfcatch.Message#">
		</cfcatch>
		</cftry>
		
		<cfset LvarXMLdoc 		=	XmlParse(CFHTTP.FileContent)>
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//*")>
		<cfset LvarPrefijoWSDL = LvarDefXML[1].XmlName>
		<cfset LvarPto = find(":",LvarPrefijoWSDL)>
		<cfif LvarPto EQ 0>
			<cfset LvarPrefijoWSDL = ":">
		<cfelse>
			<cfset LvarPrefijoWSDL = mid(LvarPrefijoWSDL,1,LvarPto)>
		</cfif>

		<cfset LvarOperations	=	XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#portType/#LvarPrefijoWSDL#operation/@name")>
	
		<cfloop from=1 to=#ArrayLen(LvarOperations)# index=i>
			<cfset ArrayAppend(LvarMethods, LvarOperations[i].xmlValue)>
		</cfloop>
		
		<cfreturn LvarMethods>
	</cffunction>
	
	<cffunction name="fnObtieneMetodo" returntype="struct">
		<cfargument name="WS" 		type="struct" required="yes">
		<cfargument name="metodo" 	type="string" required="yes">
	
		<cfif trim(Arguments.WS.proxyPort) EQ "">
			<cfset Arguments.WS.proxyPort = "1">
		</cfif>
		<cftry>
			<cfhttp method="GET" 
				url="#Arguments.WS.url#" 
				proxyserver="#Arguments.WS.proxyServer#"
				proxyport="#Arguments.WS.proxyPort#"
				username="#Arguments.WS.uid#"
				password="#Arguments.WS.pwd#"
				resolveurl="Yes" 
				throwOnError="Yes"
			/>
		<cfcatch type="any">
			<cfthrow message="ERROR DE COMUNICACION: #cfcatch.Message#">
		</cfcatch>
		</cftry>
		
		<cfset LvarXMLdoc 		=	XmlParse(CFHTTP.FileContent)>
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//*")>

		<cfset LvarPrefijoWSDL = LvarDefXML[1].XmlName>
		<cfset LvarPto = find(":",LvarPrefijoWSDL)>
		<cfif LvarPto EQ 0>
			<cfset LvarPrefijoWSDL = ":">
		<cfelse>
			<cfset LvarPrefijoWSDL = mid(LvarPrefijoWSDL,1,LvarPto)>
		</cfif>
	
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#types")>
	
		<cfif arrayLen(LvarDefXML) EQ 0>
			<cfset LvarPrefijoSchema = "">
		<cfelse>
			<cfset LvarPrefijoSchema = LvarDefXML[1].XmlChildren[1].XmlName>
			<cfset LvarPto = find(":",LvarPrefijoSchema)>
			<cfif LvarPto EQ 0>
				<cfset LvarPrefijoSchema = "xsd:">
			<cfelse>
				<cfset LvarPrefijoSchema = mid(LvarPrefijoSchema,1,LvarPto)>
			</cfif>
		</cfif>
		
		<cfset LvarMetodo = structNew()>
		<cfset LvarMetodo.Nombre = Arguments.Metodo>
		
		<!--- Obtiene los Parametros --->
		<cfset sbObtieneTipos(LvarMetodo,"input")>
		<!--- Obtiene los Resultados --->
		<cfset sbObtieneTipos(LvarMetodo,"output")>
		
		<cfreturn LvarMetodo>
	</cffunction>
	
	<cffunction name="fnClase" returntype="struct">
		<cfargument name="Tipo" type="string" required="yes">
		
		<cfset LvarRet = StructNew()>
		<cfset LvarTipoOri = fnQuitaPrefijo(Arguments.Tipo)>
		<cfset LvarTipo = lcase(LvarTipoOri)>
		<cfif listfind("double,float,integer", LvarTipo) GT 0>
			<cfset LvarRet.Clase = "D">
			<cfset LvarRet.Tipo = "N">
		<cfelseif LvarTipo EQ "boolean">
			<cfset LvarRet.Clase = "D">
			<cfset LvarRet.Tipo = "B">
		<cfelseif LvarTipo EQ "string">
			<cfset LvarRet.Clase = "D">
			<cfset LvarRet.Tipo = "S">
		<cfelseif LvarTipo EQ "base64binary">
			<cfset LvarRet.Clase = "D">
			<cfset LvarRet.Tipo = "I">
		<cfelseif LvarTipo EQ "datetime">
			<cfset LvarRet.Clase = "D">
			<cfset LvarRet.Tipo = "F">

		<cfelseif mid(LvarTipo,1,7) EQ "arrayof">
			<cfset LvarRet.Clase = "A">
			<cfset LvarRet.Tipo = mid(LvarTipoOri,8,100)>
		<cfelse>
			<cfset LvarRet.Clase = "S">
			<cfset LvarRet.Tipo = LvarTipoOri>
		</cfif>
		<cfreturn LvarRet>
	</cffunction>
	
	<cffunction name="sbObtieneTipos" output="true">
		<cfargument name="Metodo" 		type="struct">
		<cfargument name="Direccion" 	type="string">
	
		<cfset LvarDefXML = fnObtenerDatosNivel_1(Arguments.Metodo.Nombre, Arguments.Direccion)>
		<cfset Arguments.Metodo["#Direccion#Datos"] = ArrayNew(1)>
		<cfif ArrayLen(LvarDefXML) EQ 0>
			<cfset Arguments.Metodo["clase_#Direccion#"] = "N">
		<cfelse>
			<cfif Arguments.Direccion EQ "output">
				<cfset LvarNombreOriginal = "RESULTADO">
			<cfelse>
				<cfset LvarNombreOriginal = LvarDefXML[1].xmlAttributes.name>
			</cfif>
			<cfset LvarTipoOriginal = LvarDefXML[1].xmlAttributes.type>
			<cfset LvarClase = fnClase(LvarTipoOriginal)>
			<cfset LvarClaseOriginal = LvarClase.Clase>
			<cfif LvarClase.Clase NEQ "D" and ArrayLen(LvarDefXML) GT 1>
				<cfset Arguments.Metodo["clase_#Direccion#"] = "E">
				<cfset Arguments.Metodo["#Direccion#Datos"][1] = StructNew()>
				<cfset Arguments.Metodo["#Direccion#Datos"][1].Nombre = LvarNombreOriginal>
				<cfset Arguments.Metodo["#Direccion#Datos"][1].Tipo = LvarTipoOriginal>
				<cfset Arguments.Metodo["#Direccion#Datos"][1].Clase = "E">
			<cfelse>
				<cfset Arguments.Metodo["clase_#Direccion#"] = LvarClase.Clase>
				<cfif LvarClase.Clase NEQ "D">
					<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#types/descendant::*[@name='#LvarClase.Tipo#']/descendant::#LvarPrefijoSchema#sequence[position()=last()]/#LvarPrefijoSchema#element")>
				</cfif>
				<cfif ArrayLen(LvarDefXML) EQ 0>
					<cfset Arguments.Metodo["clase_#Direccion#"] = "E">
					<cfset Arguments.Metodo["#Direccion#Datos"][1] = StructNew()>
					<cfset Arguments.Metodo["#Direccion#Datos"][1].Nombre = LvarNombreOriginal>
					<cfset Arguments.Metodo["#Direccion#Datos"][1].Tipo = LvarTipoOriginal>
					<cfset Arguments.Metodo["#Direccion#Datos"][1].Clase = "E">
				</cfif>
				<cfloop from=1 to=#ArrayLen(LvarDefXML)# index=k>
					<cfparam name="LvarDefXML[k].xmlAttributes.type" default="#LvarTipoOriginal#">
					<cfparam name="LvarDefXML[k].xmlAttributes.name" default="#LvarNombreOriginal#">
					<cfset LvarClase = fnClase(LvarDefXML[k].xmlAttributes.type)>
					<cfset Arguments.Metodo["#Direccion#Datos"][k] = LvarClase>
					<cfif LvarClase.Clase NEQ "D">
						<cfset Arguments.Metodo["clase_#Direccion#"] = "E">
						<cfset Arguments.Metodo["#Direccion#Datos"][k].Clase = "E">
					</cfif>
					<cfif LvarClaseOriginal EQ "D" AND Arguments.Direccion EQ "output">
						<cfset Arguments.Metodo["#Direccion#Datos"][k].Nombre = "RESULTADO">
					<cfelse>
						<cfset Arguments.Metodo["#Direccion#Datos"][k].Nombre = LvarDefXML[k].xmlAttributes.name>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="fnQuitaPrefijo" output="false" returntype="string">
		<cfargument name="Valor" required="yes" type="string">
		
		<cfset LvarPto = find(":", Arguments.Valor)>
		<cfif LvarPto GT 0>
			<cfreturn mid(Arguments.Valor,LvarPto+1,100)>
		<cfelse>
			<cfreturn Arguments.Valor>
		</cfif>
	</cffunction>
	
	<cffunction name="fnObtenerDatosNivel_1" output="false" returntype="array">
		<cfargument name="Metodo" required="yes" type="string">
		<cfargument name="Direccion" required="yes" type="string">
	
		<cfset var LvarDefXML = ArrayNew(1)>
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#portType/#LvarPrefijoWSDL#operation[@name='#Arguments.Metodo#']")>
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#portType/#LvarPrefijoWSDL#operation[@name='#Arguments.Metodo#']/#LvarPrefijoWSDL##Arguments.direccion#/@name")>
		<cfif ArrayLen(LvarDefXML) EQ 0>
			<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#portType/#LvarPrefijoWSDL#operation[@name='#Arguments.Metodo#']/#LvarPrefijoWSDL##Arguments.direccion#/@message")>
		</cfif>
		<cfset LvarDefXML=XmlSearch(LvarXMLdoc, "//#LvarPrefijoWSDL#message[@name='#fnQuitaPrefijo(LvarDefXML[1].xmlValue)#']/#LvarPrefijoWSDL#part")>
		<cfloop index=i from=1 to=#ArrayLen(LvarDefXML)#>
			<cfset LvarItem = LvarDefXML[i]>
			<cfif not isdefined("LvarItem.xmlAttributes.type")>
				<cfset LvarDefXML[i].xmlAttributes.type = LvarDefXML[i].xmlAttributes.element>
			</cfif>
		</cfloop>
		
		<cfreturn LvarDefXML>
	</cffunction>
	
	<cffunction name="fnInvocaMetodo" returntype="any">
		<cfargument name="WS" 		type="struct" required="yes">
		<cfargument name="metodo" 	type="struct" required="yes">
		
		<cfif trim(Arguments.WS.proxyPort) EQ "">
			<cfset Arguments.WS.proxyPort = "1">
		</cfif>
		<cftry>
			<cfhttp method="GET" 
				url="#Arguments.WS.url#" 
				proxyserver="#Arguments.WS.proxyServer#"
				proxyport="#Arguments.WS.proxyPort#"
				username="#Arguments.WS.uid#"
				password="#Arguments.WS.pwd#"
				resolveurl="Yes" 
				throwOnError="Yes"
			/>
		<cfcatch type="any">
			<cfthrow message="ERROR DE COMUNICACION: #cfcatch.Message#" detail="#cfcatch.Detail#" type="WScomm">
		</cfcatch>
		</cftry>

		<cftry>
			<cfif Arguments.Metodo.clase_output EQ "N">
				<cfinvoke 
					webservice="#Arguments.WS.url#"
					method="#Arguments.metodo.Nombre#"
					proxyserver="#Arguments.WS.proxyServer#"
					proxyport="#Arguments.WS.proxyPort#"
					username="#Arguments.WS.uid#"
					password="#Arguments.WS.pwd#"
				>
				<cfloop from="1" to="#ArrayLen(Arguments.Metodo.inputDatos)#" index="i">
					<cfparam name="Arguments.Metodo.inputDatos[i].Valor" default="0">
					<cfset LvarValor  = Arguments.Metodo.inputDatos[i].Valor>
					<cfif Arguments.Metodo.inputDatos[i].Tipo EQ "F">
						<cftry>
							<cfset LvarValor = createDate(mid(LvarValor,7,4),mid(LvarValor,4,2),mid(LvarValor,1,2))>
						<cfcatch type="any">
							<cfthrow message="El formato de la fecha no es correcto">
						</cfcatch>
						</cftry>
					</cfif>
					<cfinvokeargument	name="#Arguments.Metodo.inputDatos[i].Nombre#"	value="#LvarValor#">
				</cfloop>
				</cfinvoke>
			<cfelse>
				<cfinvoke 
					webservice="#Arguments.WS.url#"
					method="#Arguments.metodo.Nombre#"
					proxyserver="#Arguments.WS.proxyServer#"
					proxyport="#Arguments.WS.proxyPort#"
					username="#Arguments.WS.uid#"
					password="#Arguments.WS.pwd#"
					
					returnvariable="LvarRet"
				>
				<cfloop from="1" to="#ArrayLen(Arguments.Metodo.inputDatos)#" index="i">
					<cfparam name="Arguments.Metodo.inputDatos[i].Valor" default="0">
					<cfset LvarValor  = Arguments.Metodo.inputDatos[i].Valor>
					<cfif Arguments.Metodo.inputDatos[i].Tipo EQ "F">
						<cftry>
							<cfset LvarValor = createDate(mid(LvarValor,7,4),mid(LvarValor,4,2),mid(LvarValor,1,2))>
						<cfcatch type="any">
							<cfthrow message="El formato de la fecha no es correcto">
						</cfcatch>
						</cftry>
					</cfif>
					<cfinvokeargument	name="#Arguments.Metodo.inputDatos[i].Nombre#"	value="#LvarValor#">
				</cfloop>
				</cfinvoke>
			</cfif>
		<cfcatch type="any">
			<cfset LvarMSG = cfcatch.Detail>
			<cfset LvarPTO = find("WSERRTOC(",LvarMSG)>
			<cfif LvarPTO>
				<cfset LvarMSG = mid(LvarMSG, LvarPTO+9, 1024)>
				<cfset LvarPTO = find(")WSERRTOC",LvarMSG)>
				<cfif LvarPTO>
					<cfset LvarMSG = mid(LvarMSG, 1, LvarPTO-1)>
					<cfthrow message="ERROR DE LA APLICACION REMOTA: #LvarMSG#" type="WSapp">
				</cfif>
			</cfif>
			<cfthrow message="ERROR DE INVOCACION: #cfcatch.Message#" detail="#cfcatch.Detail#" type="WSinv">
		</cfcatch>
		</cftry>
	
		<cftry>
			<cfif Arguments.Metodo.clase_output EQ "N">
				<cfset rsQuery = QueryNew("")>
			<cfelseif Arguments.Metodo.clase_output EQ "D">
				<cfset rsQuery = QueryNew("RESULTADO")>
				<cfset QueryAddRow(rsQuery)>
				<!--- Llena el único campo --->
				<cfset LvarValue = LvarRet>
				<cfif Arguments.Metodo.outputDatos[1].Tipo EQ "F">
					<cfset LvarValue = createDate(
										LvarValue.getTime().getYear()+1900, 
										LvarValue.getTime().getMonth()+1,
										LvarValue.getTime().getDate()
									)
					>
				</cfif>
				<cfset QuerySetCell(rsQuery, "RESULTADO", LvarValue)>
			<cfelseif Arguments.Metodo.clase_output EQ "S">
				<cfset LvarCols = "">
				<cfloop from="1" to="#ArrayLen(Arguments.Metodo.outputDatos)#" index="i">
					<cfset LvarCols = LvarCols & Arguments.Metodo.outputDatos[i].Nombre & ",">
				</cfloop>
				<cfset LvarCols = mid(LvarCols,1,len(LvarCols)-1)>
				<cfset rsQuery = QueryNew(LvarCols)>
		
				<!--- Llena cada campo de la estructura --->
				<cfset QueryAddRow(rsQuery)>
				<cfloop index="LvarCol" from="1" to="#ArrayLen(Arguments.Metodo.outputDatos)#">
					<cfset LvarValue = evaluate("LvarRet.get#Arguments.Metodo.outputDatos[LvarCol].Nombre#()")>
					<cfif Arguments.Metodo.outputDatos[LvarCol].Tipo EQ "F">
						<cfset LvarValue = createDate(
											LvarValue.getTime().getYear()+1900, 
											LvarValue.getTime().getMonth()+1,
											LvarValue.getTime().getDate()
										)
						>
					</cfif>
					<cfset QuerySetCell(rsQuery, Arguments.Metodo.outputDatos[LvarCol].Nombre, LvarValue)>
				</cfloop>
			<cfelseif Arguments.Metodo.clase_output EQ "A">
				<cfset LvarCols = "">
				<cfloop from="1" to="#ArrayLen(Arguments.Metodo.outputDatos)#" index="i">
					<cfset LvarCols = LvarCols & Arguments.Metodo.outputDatos[i].Nombre & ",">
				</cfloop>
				<cfset LvarCols = mid(LvarCols,1,len(LvarCols)-1)>
				<cfset rsQuery = QueryNew(LvarCols)>
		
				<!--- Llena cada campo de la estructura de cada linea del arreglo --->
				<cfloop index="LvarRow" from="1" to="#ArrayLen(LvarRet)#">
					<cfset QueryAddRow(rsQuery)>
					<cfloop index="LvarCol" from="1" to="#ArrayLen(Arguments.Metodo.outputDatos)#">
						<cfset LvarValue = evaluate("LvarRet[#LvarRow#].get#Arguments.Metodo.outputDatos[LvarCol].Nombre#()")>
						<cfif Arguments.Metodo.outputDatos[LvarCol].Tipo EQ "F">
							<cfset LvarValue = createDate(
												LvarValue.getTime().getYear()+1900, 
												LvarValue.getTime().getMonth()+1,
												LvarValue.getTime().getDate()
											)
							>
						</cfif>

						<cfset QuerySetCell(rsQuery, Arguments.Metodo.outputDatos[LvarCol].Nombre, LvarValue)>
					</cfloop>
				</cfloop>
			</cfif>
		<cfcatch type="any">
			<cfthrow message="ERROR AL INTERPRETAR LOS RESULTADOS DEL WEBSERVICE: #cfcatch.Message#<BR>#cfcatch.Detail#" type="WSres">
		</cfcatch>
		</cftry>
		<cfreturn rsQuery>
	</cffunction>
</cfcomponent>
