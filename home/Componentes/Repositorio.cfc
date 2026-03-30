<cfcomponent>
	<cffunction name="administracioArchivos" access="public" returntype="void">
		<cfset local.baseWebPath = ExpandPath( "../../sif/ce/Empresas/" ) />

		<cfdirectory action="list" directory="#local.baseWebPath#" name="listdir" type="dir">

		<cfloop index="idir" from="1" to="#listdir.RecordCount#">
			<cfdirectory action="list" directory="#listdir.Directory[idir]#\#listdir.Name[idir]#" name="listFilesxml" type="file" filter="*.xml">
		    <cfdirectory action="list" directory="#listdir.Directory[idir]#\#listdir.Name[idir]#" name="listFilespdf" type="file" filter="*.pdf">
		    <cfset directorio = #listdir.Name[idir]#>
			<cfset arrayDirectorio = ListToArray(#directorio#, "_")>
			<cfset idEmpresa = #arrayDirectorio[2]#>
			<cfquery name="rs" datasource="asp">
				select rep.CDataSource from CachesRep rep inner join CacheRepo repo on rep.CidR=repo.CidR
                inner join Empresa em on em.Cid=repo.Cid and em.Ereferencia = #idEmpresa#
			</cfquery>
			<cfset dataSource = #rs.CDataSource#>

			<cfloop index = "ixml" from = "1" to = "#listFilesxml.RecordCount#">
				<cfset archivoxml = #listFilesxml.Name[ixml]#>
				<cfset arrayArchivoxml = ListToArray(#archivoxml#, ".")>
				<cfset nombrexml = #arrayArchivoxml[1]#>

				<cffile action="read" variable="filecontents" file="#listFilesxml.Directory[ixml]#\#listFilesxml.Name[ixml]#">
				<cffile action="readbinary" variable="filecontentbinary" file="#listFilesxml.Directory[ixml]#\#listFilesxml.Name[ixml]#">

				<cfset xmlFile = XmlParse(filecontents)>
				<cfset timbre = xmlFile.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
				<cfset tipo = xmlFile.Comprobante.XmlAttributes.tipoDeComprobante>
				<cfset total = xmlFile.Comprobante.XmlAttributes.total>

				<cfif #UCase(tipo)# eq 'INGRESO'>
					<cfset rfc = xmlFile.Comprobante.Emisor.XmlAttributes.rfc>
				</cfif>
				<cfif #UCase(tipo)# eq 'EGRESO'>
					<cfset rcf = xmlFile.Comprobante.Receptor.XmlAttributes.rfc>
				</cfif>
				<cfif #UCase(tipo)# eq 'TRASLADO'>
				</cfif>

				<cfquery name="rsVal" datasource="#dataSource#">
					select IdRep, archivoXML from CERepositorio where timbre = <cfqueryparam value="#timbre#" cfsqltype="cf_sql_varchar"/>
				</cfquery>

				<cfif #rsVal.RecordCount# gt 0 and #rsVal.archivoXML# eq ''>
					<cfquery name="rsxmlup" datasource="#dataSource#">
						update CERepositorio set
						archivoXML = <cfqueryparam value='#CharsetEncode(filecontentbinary,"ISO-8859-1")#' cfsqltype="cf_sql_varchar"/>,
						nombreArchivo = <cfqueryparam value="#nombrexml#" cfsqltype="cf_sql_varchar"/>,
						xmlTimbrado = <cfqueryparam value="#filecontents#" cfsqltype="cf_sql_varchar"/>,
						rfc = <cfqueryparam value="#rfc#" cfsqltype="cf_sql_varchar"/>,
						total = <cfqueryparam value="#total#" cfsqltype="cf_sql_money4"/>
						where timbre = <cfqueryparam value="#timbre#" cfsqltype="cf_sql_varchar"/>
					</cfquery>

						<cfoutput>
							<cfscript>
								filedelete("#listFilesxml.Directory[ixml]#\#listFilesxml.Name[ixml]#");
							</cfscript>
						</cfoutput>
					<cfelse>
					<cfquery name="rsxml" datasource="#dataSource#">
						insert into CERepositorio (timbre, archivoXML, nombreArchivo,xmlTimbrado,rfc,total) values (
						<cfqueryparam value="#timbre#" cfsqltype="cf_sql_varchar"/>,
						<cfqueryparam value='#CharsetEncode(filecontentbinary,"ISO-8859-1")#' cfsqltype="cf_sql_varchar"/>,
						<cfqueryparam value="#nombrexml#" cfsqltype="cf_sql_varchar"/>,
						<cfqueryparam value="#filecontents#" cfsqltype="cf_sql_varchar"/>,
						<cfqueryparam value="#rfc#" cfsqltype="cf_sql_varchar"/>,
						<cfqueryparam value="#total#" cfsqltype="cf_sql_money"/>)
					</cfquery>
					<cfoutput>
						<cfscript>
							filedelete("#listFilesxml.Directory[ixml]#\#listFilesxml.Name[ixml]#");
						</cfscript>
					</cfoutput>
				</cfif>

				<cfloop index = "ipdf" from = "1" to = "#listFilespdf.RecordCount#">
					<cfset archivopdf = #listFilespdf.Name[ipdf]#>
					<cfset arrayArchivopdf = ListToArray(#archivopdf#, ".")>
					<cfset nombrepdf = #arrayArchivopdf[1]#>

					<cfif #nombrexml# eq #nombrepdf#>
						<cffile action="readbinary" variable="filepdfbinary" file="#listFilespdf.Directory[ipdf]#\#listFilespdf.Name[ipdf]#">
						<cfquery name="rspdf" datasource="#dataSource#">
							update CERepositorio set
							archivo = <cfqueryparam value='#CharsetEncode(filecontentbinary,"ISO-8859-1")#' cfsqltype="cf_sql_varchar"/>,
							extension = <cfqueryparam value="pdf" cfsqltype="cf_sql_varchar"/>
							where timbre = <cfqueryparam value="#timbre#" cfsqltype="cf_sql_varchar"/>
						</cfquery>
						<cfoutput>
							<cfscript>
								filedelete("#listFilespdf.Directory[ipdf]#\#listFilespdf.Name[ipdf]#");
							</cfscript>
						</cfoutput>
						<cfbreak >
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
	</cffunction>

	<cffunction name="getnameDB" access="public" returntype="Any">
		<cfargument name="idEmpresa" type="numeric" required="true">
		<cfquery name="rsVal" datasource="asp">
			select cr.CidR from CacheRepo cr
			inner join Empresa em on cr.Cid = em.Cid and em.Ereferencia =  #arguments.idEmpresa#
		</cfquery>
		<cfif #rsVal.CidR# eq -1>
			<cfset DataSource = #Session.DSN#>
			<cfelse>
			<cfquery name="rs" datasource="asp">
				select rep.CDataSource from CachesRep rep inner join CacheRepo repo on rep.CidR=repo.CidR
           		 inner join Empresa em on em.Cid=repo.Cid and em.Ereferencia = #arguments.idEmpresa#
			</cfquery>
			<cfset DataSource = #rs.CDataSource#>

		</cfif>

		<cflock name="serviceFactory" type="exclusive" timeout="10">
			<cfscript>
				factory = CreateObject("java", "coldfusion.server.ServiceFactory");
				ds_service = factory.datasourceservice;
   			</cfscript>
		</cflock>
		<cfset caches = ds_service.getNames()>
		<cftry>
			<cfset databaseName = "ds_service.getDataSources()." & #DataSource# & ".urlmap.database" >
			<cfset nameDB = #Evaluate(databaseName)#>
			<cfreturn #nameDB#>
			<cfcatch type="any">
				<cfset error = StructNew()>
				<cfset error.Type = #cfcatch.Type#>
				<cfset error.message = #cfcatch.message#>
				<cfset error.Detail = #cfcatch.Detail#>
				<cfreturn error>
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getDataSource" access="public" returntype="Any">
		<cfargument name="idEmpresa" type="numeric" required="true">
		<cftry>
			<cfquery name="rsVal" datasource="asp">
				select cr.CidR from CacheRepo cr
				inner join Empresa em on cr.Cid = em.Cid and em.Ereferencia =  #arguments.idEmpresa#
			</cfquery>
			<cfif #rsVal.CidR# eq -1>
				<cfset DataSource = #Session.DSN#>
			<cfelse>
				<cfquery name="rs" datasource="asp">
					select rep.CDataSource from CachesRep rep inner join CacheRepo repo on rep.CidR=repo.CidR
           		 	inner join Empresa em on em.Cid=repo.Cid and em.Ereferencia = #arguments.idEmpresa#
				</cfquery>
				<cfset DataSource = #rs.CDataSource#>
			</cfif>
		    <cfreturn #DataSource#>
			<cfcatch type="any">
				<cfset error = StructNew()>
				<cfset error.Type = #cfcatch.Type#>
				<cfset error.message = #cfcatch.message#>
				<cfset error.Detail = #cfcatch.Detail#>
				<cfreturn error>
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>