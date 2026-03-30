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
					<cfargument name="ordCompra" type="string" required="true" /><!--- xml sin nodo --->
					
					<cfset LvarADDid =arguments.ADDid>
					<cfset struHXML = StructNew()>
					<cfset struHXML = leeXML(HXML)>
					<cfset TamDet=#ArrayLen(struHXML.Comprobante.Conceptos)#>
					<cfset TamDet=TamDet>

					<cfset TotalIMP=0>
					<cfloop index="i" from="1" to="#TamDet#" >
						<cfset TotalIMP=TotalIMP+struHXML.Comprobante.Conceptos[i].Concepto.Impuestos.Traslados[1].Importe>
					</cfloop>

					<!--- Numero socio de negocio --->
					<cfset resNumpro = structnew() >
					<cfset resNumpro = get_NumPro(struHXML.Comprobante.Receptor.Atributos.Nombre,struHXML.Comprobante.Receptor.Atributos.Rfc) >
				<!--- Plantilla Addenda --->
			    <cfxml variable="xmlobject">
				<sanofi:sanofi xmlns:sanofi="https://mexico.sanofi.com/schemas" version="1.0" xmlns:xsi="https://mexico.sanofi.com/schemas https://mexico.sanofi.com/schemas/sanofi.xsd">
      			<sanofi:Documento> 
							<sanofi:header> 
								<sanofi:TIPO_DOCTO>#this.get_AddaValue(LvarADDid,'TIPO_DOCTO')#</sanofi:TIPO_DOCTO> 
								<sanofi:NUM_ORDEN>#addDetStruct.NUM_ORDEN#</sanofi:NUM_ORDEN> 
								<sanofi:NUM_PROVEEDOR>#this.get_AddaValue(LvarADDid,'NUM_PROVEEDOR')#</sanofi:NUM_PROVEEDOR> 
								<sanofi:FCTCONV>#this.get_AddaValue(LvarADDid,'FCTCONV')#</sanofi:FCTCONV> 
								<sanofi:MONEDA>MXN</sanofi:MONEDA> 
								<sanofi:IMP_RETENCION>#this.get_AddaValue(LvarADDid,'IMP_RETENCION')#</sanofi:IMP_RETENCION>
								<sanofi:IMP_TOTAL>#TotalIMP#</sanofi:IMP_TOTAL> 
								<sanofi:OBSERVACIONES>#addDetStruct.OBSERVACIONES#</sanofi:OBSERVACIONES> 
								<sanofi:CTA_CORREO>#this.get_AddaValue(LvarADDid,'CTA_CORREO')#</sanofi:CTA_CORREO> 
								<sanofi:DISPONIBLE_1>0.00</sanofi:DISPONIBLE_1> 
								<sanofi:DISPONIBLE_2>0.00</sanofi:DISPONIBLE_2> 
								<sanofi:DISPONIBLE_3>0.00</sanofi:DISPONIBLE_3> 
								<sanofi:DISPONIBLE_4>0.00</sanofi:DISPONIBLE_4> 
								<sanofi:CORREO_SANOFI>#addDetStruct.CORREO_SANOFI#</sanofi:CORREO_SANOFI> 
							</sanofi:header> 
							<cfset varNumLinea=0>
							<cfloop index="i" from="1" to="#TamDet#" >
								<cfset varNumLinea=varNumLinea+10>
								<sanofi:details> 
									<sanofi:NUM_LINEA>#numberFormat(varNumLinea,'0000')#</sanofi:NUM_LINEA> 
									<sanofi:NUM_ENTRADA>0000000000</sanofi:NUM_ENTRADA> 
									<sanofi:UNIDADES>#struHXML.Comprobante.Conceptos[i].Concepto.Atributos.Cantidad#</sanofi:UNIDADES> 
									<sanofi:PRECIO_UNITARIO>#struHXML.Comprobante.Conceptos[i].Concepto.Atributos.ValorUnitario#</sanofi:PRECIO_UNITARIO> 
									<sanofi:IMPORTE>#struHXML.Comprobante.Conceptos[i].Concepto.Atributos.Importe#</sanofi:IMPORTE> 
									<sanofi:UNIDAD_MEDIDA>#struHXML.Comprobante.Conceptos[i].Concepto.Atributos.Unidad#</sanofi:UNIDAD_MEDIDA> 
									<sanofi:TASA_IVA>#struHXML.Comprobante.Conceptos[i].Concepto.Impuestos.Traslados[1].TasaOCuota * 100.00 #</sanofi:TASA_IVA> 
									<sanofi:IMPORTE_IVA>#struHXML.Comprobante.Conceptos[i].Concepto.Impuestos.Traslados[1].Importe#</sanofi:IMPORTE_IVA> 
									<sanofi:DISPONIBLE_1>0.00</sanofi:DISPONIBLE_1> 
									<sanofi:DISPONIBLE_2>0.00</sanofi:DISPONIBLE_2> 
									<sanofi:DISPONIBLE_3>0.00</sanofi:DISPONIBLE_3> 
									<sanofi:DISPONIBLE_4>0.00</sanofi:DISPONIBLE_4> 
									<sanofi:DISPONIBLE_5>0.00</sanofi:DISPONIBLE_5> 
									<sanofi:DISPONIBLE_6>0.00</sanofi:DISPONIBLE_6> 
								</sanofi:details>
							</cfloop>
						</sanofi:Documento> 
						</sanofi:sanofi>
        </cfxml>

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
