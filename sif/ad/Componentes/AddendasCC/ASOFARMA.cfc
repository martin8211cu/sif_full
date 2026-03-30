<cfcomponent extends="sif.ad.Componentes.AD_Addenda">
				<cffunction name="init" access="private" returntype="ADDENDAEJEMPLO"> 
					<cfargument name="DSN" 	   type="string" default="minisif" >
					<cfargument name="Ecodigo" type="string" default="1" >		
					<cfset Super.init(arguments.DSN, arguments.Ecodigo)>
					<cfreturn this>
				</cffunction>	

				<cffunction name="fnGeneraXML" access="public" output="yes" returntype="xml">
					<cfargument name="HXML" type="xml" required="true" /><!--- xml sin nodo --->
					<cfargument name="ADDid" type="numeric" required="true" /><!--- xml sin nodo --->
					<cfargument name="addDetStruct"    type="struct"   required="no" default="#StructNew()#">
					<cfargument name="ordCompra" type="string" required="false" /><!--- xml sin nodo --->

					<cfset LvarADDid =arguments.ADDid>
					<cfset struHXML = StructNew()>
					<cfset struHXML = leeXML(HXML)>
					<cfset TamDet= #ArrayLen(struHXML.Comprobante.Conceptos)#>

					<!--- Plantilla Addenda 
					<cfxml variable="xmlobject">
						<ASONIOSCOC folio="#struHXML.Comprobante.Atributos.Folio#" noProveedor="#addDetStruct.noProveedor#" ordenCompra="#addDetStruct.ordenCompra#" serie="#addDetStruct.serie#" tipoProveedor="#addDetStruct.tipoProveedor#">
						<Partidas> 
							<Partida Otros="" ivaAcreditable="#addDetStruct.ivaAcreditable#" ivaDevengado="0.00" noPartida="0"/>
						</Partidas>
						</ASONIOSCOC> 
					</cfxml>
					--->
					<!--- Numero socio de negocio --->

					
					<!--- <cfquery name="rsNumPro" datasource="#Session.DSN#">
						select substring(SNidentificacion2,(CHARINDEX( '-', SNidentificacion2, 1)+1),50) as tipoPro,
						substring(SNidentificacion2,1,(CHARINDEX( '-', SNidentificacion2, 1)-1)) as numPro
						 from SNegocios 
						 where SNnombre like '%#struHXML.Comprobante.Receptor.Atributos.Nombre#%'
						 AND SNidentificacion = rtrim(ltrim('#struHXML.Comprobante.Receptor.Atributos.Rfc#'))
					</cfquery>	 --->
					<cfset resNumpro = structnew() >
					<cfset resNumpro = get_NumPro(struHXML.Comprobante.Receptor.Atributos.Nombre,struHXML.Comprobante.Receptor.Atributos.Rfc) >
					
					<!--- <cfdump var="#resultado#">
					<cfdump var="#struHXML#"> --->
						<cfxml variable="xmlobject">
							<ASONIOSCOC folio="#struHXML.Comprobante.Atributos.Folio#" 
							noProveedor="#this.get_AddaValue(LvarADDid,'noProveedor')#" 
							ordenCompra="#addDetStruct.ordenCompra#" 
							serie="#struHXML.Comprobante.Atributos.Serie#" 
							tipoProveedor="#this.get_AddaValue(LvarADDid,'tipoProveedor')#">
							<Partidas>
								<cfloop index="i" from="1" to="#TamDet#" >
									<Partida Otros="#struHXML.Comprobante.Conceptos[i].Concepto.Atributos.ClaveProdServ#" 
									ivaAcreditable="#struHXML.Comprobante.Conceptos[i].Concepto.Impuestos.Traslados[1].Importe#" 
									ivaDevengado="0.00" noPartida="#i#"/>
								</cfloop>
							</Partidas>
							</ASONIOSCOC> 
						</cfxml>

							 <!--- <cf_dump var="#xmlobject#"> 
							 --->
							
							
					<cfreturn xmlobject>       
			    </cffunction>

			    <!--- Funcion que regresa Estructura del XML --->
			    <cffunction name="leeXML" access="public" output="yes" returntype="struct">
					<cfargument name="xmlNode" type="string" required="true" />
						
			    	<cfset objUxml = createObject( "component","home.public.api.components.utils2")>
					<cfset  stru = StructNew()>

					<cfset  stru = objUxml.CFDIToStruct(Arguments.xmlNode,StructNew())>
					<cfreturn stru>
				</cffunction>
			</cfcomponent>
