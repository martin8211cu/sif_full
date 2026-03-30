<cfcomponent extends="taffy.core.resource" taffy_uri="/cxp">

    <cffunction name="post" access="public" output="false">
        <cfargument  name="Ecodigo" type="string" required="true">
		<cfargument  name="xmlFile" required="true">
		<cfargument  name="user" required="true">

		<cfset status = 200>
		<cfscript>
			result=StructNew();
		</cfscript>
		<!--- Upload File --->
		<cfif len(trim(xmlFile))>
			<cfif !DirectoryExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp")>
				<cfdirectory action="create" directory="#GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp"#">
			</cfif>
			<cffile action="upload"
			   fileField="xmlFile"
			   result="xmlName"
			   nameconflict="makeunique"			   
			   destination="#GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp"#">
		</cfif>
		<!--- Read File--->
	    <cfif fileExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\" & xmlName.SERVERFILE)>
			<cffile action="read" charset="utf-8" variable="xml" file="#GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\"##xmlName.SERVERFILE#">
			<cfset objUxml = createObject( "component","home.public.api.components.utils")>
			<cfset xml_parsed = objUxml.CFDIToStruct(xml,StructNew())>
		</cfif>

		<!--- Obtener atributos para validar la informacion --->
		<cfset objQuery = createObject("component","sif.api.components.consultacxp")>
		<cftry>		
			<cfset dsn = 'minisif'><!--- objQuery.getDSN(Ecodigo=arguments.Ecodigo)--->
			<cfset rfc = xml_parsed.Comprobante.Emisor.Atributos.Rfc>
			<cfset rsSocioNegocio = objQuery.getSocioNegocio(Ecodigo=arguments.Ecodigo,SNidentificacion=rfc,dsn=dsn)>
			<cfset rsOficina = objQuery.getOficina(Ecodigo=arguments.Ecodigo,dsn=dsn)>
			<cfset rsCuenta = objQuery.getCuenta(Ecodigo=arguments.Ecodigo,SNcodigo=rsSocioNegocio.SNcodigo,dsn=dsn)>
			<cfset rsEmpresa = objQuery.getEmpresa(Ecodigo=arguments.Ecodigo,dsn=dsn)>
			<cfset rsDireccion = objQuery.getDireccion(Ecodigo=arguments.Ecodigo,SNid=rsSocioNegocio.SNid,dsn=dsn)>
			<cfset CPTcodigo ='FC'>
			<cfset EDfecha=xml_parsed.TimbreFiscalDigital.Atributos.FechaTimbrado>
			<cfset TimbreFiscal = xml_parsed.TimbreFiscalDigital.Atributos.UUID> 
			<cfset TotalCFDI = xml_parsed.Comprobante.Atributos.Total>
			<cfset EDdocumento = objQuery.getEdocumento(Ecodigo=arguments.Ecodigo,code=CPTcodigo,date=#LSDateFormat(EDfecha,'yyyymmdd')#,dsn=dsn)>
		<cfcatch type="any">
			<cfset result["resultado"] =  false> 
			<cfset result["message"] =  cfcatch.message> 
			<cfreturn representationOf(result).withStatus(500) />
		</cfcatch>
		</cftry>


		<cfset Edocument = objQuery.insertDocumentoCxP(Ecodigo= arguments.Ecodigo,
													  CPTcodigo= CPTcodigo,
													  EDdocumento= EDdocumento,
													  Mcodigo= rsEmpresa.Mcodigo,
													  SNcodigo= rsSocioNegocio.SNcodigo,
													  Ocodigo= rsOficina.Ocodigo,
													  Ccuenta= rsCuenta.Ccuenta,
													  id_direccion= rsDireccion.id_direccion,
													  EDtipocambio= 1,
													  EDfecha= EDfecha,
													  EDusuario= arguments.user,
													  EDselect= 0,
													  interfaz= 1,
													  EDvencimiento= '#Now()#',<!--- sumar SNvencompras --->
													  TESRPTCietu= 1,
													  EDAdquirir= 1,
													  EDexterno= 1,
													  dsn=dsn)>
		<cfset RepoTMP = objQuery.insertRepoTMP(Ecodigo= arguments.Ecodigo,
											 	TimbreFiscal=TimbreFiscal,
											 	ID_Documento=Edocument.IDdocumento,
											 	Documento=Edocument.EDdocumento,
											 	Origen='CPFC',
											 	NomArchXML=xmlName.SERVERFILE,
											 	TotalCFDI=TotalCFDI,
											 	TipoComprobante=1,
											 	BMUsucodigo=0,
											 	Mcodigo=rsEmpresa.Mcodigo,
											 	TipoCambio=1,
											 	dsn=dsn )>

		<!--- Delete File --->
		<cfset fileST = fileExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\" & xmlName.SERVERFILE)>
		<cfset fileDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\" & xmlName.SERVERFILE>
		<cfif fileExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\" & xmlName.SERVERFILE)>
			<cffile action = "delete" file = "#GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp\\"##xmlName.SERVERFILE#">
		</cfif>
		
		<cfset result["result"] =  true> 
		<cfset consultaCxp["Edocument.IDdocumento"] = Edocument.IDdocumento>
		<cfset consultaCxp["Edocument.EDdocumento"] = Edocument.EDdocumento>
		<cfset consultaCxp["RepoTMP.CEfileId"] = RepoTMP.CEfileId>
		<cfset result["data"] =  consultaCxp> 
		<cfset result["message"] =  "XML registrado correctamente."> 

        <cfreturn representationOf(result).withStatus(status) />
	</cffunction>
</cfcomponent>
