<cfcomponent>
     <cffunction name="RepositorioCFDIs" access="public" output="no">
    	<cfargument name='idDocumento' 	type='numeric' 	required='false' default="-1">	 <!--- ID Documento ---->
        <cfargument name='idContable'	type='numeric' 	required='true'>	 <!--- ID Contable ---->
        <cfargument name='Origen'		type='string' 	required='true'>	 <!--- Origen ---->
        <cfargument name='idLinea' 		type='numeric' 	required='false' default="-1">	 <!--- ID Linea ---->
		<cfargument name='idLineaP' 	type='numeric' 	required='false' >	 <!--- ID Linea Poliza ---->
        <cfargument name='dbRepoName' 	type='string' 	required='false' default=""> <!--- Identifica Repositorio   --->
		<cfargument name='borrar'	 	type='string' 	required='false' default="S"> <!--- Identifica si se borra del repositorio temporal   --->
		<cfargument name='tipoLinea' 	type='numeric' 	required='false' default="-1">	 <!--- Tipo de LInea ---->
        <cfargument name='documentoOri'	type='string' 	required='false' default="">	 <!--- Nombre del Documento ---->
        <cfargument name='tranOri'		type='string' 	required='false' default="">	 <!--- trnsaccion ---->
        <cfargument name='SNB' 			type='numeric' 	required='false' default="-1">
		<cfargument name='MetPago' 		type='string' 	required='false' default="">
		<cfargument name='rfc' 			type='string' 	required='false' default="">
		<cfargument name='total' 		type='string' 	required='false' default="">
		<cfargument name='idDocumentoH' type='numeric' 	required='false' default="-1">

        <cfif isdefined('Arguments.dbRepoName') and LEN('Arguments.dbRepoName') and Arguments.dbRepoName NEQ "RepNoDef">
			<cfset repositorio = "#Arguments.dbRepoName#..">
		<cfelse>
			<cfset repositorio ="">
        </cfif>
        <cfquery name="datosCFDI" datasource="#session.dsn#">
	        	select distinct rt.TimbreFiscal from CERepoTMP rt
	        	<cfif Arguments.Origen EQ "TES">
	        	inner join TESdetallePago ds
					on rt.ID_Linea = ds.TESDPid
				inner join TESsolicitudPago eds
					on eds.TESSPid = ds.TESSPid
				</cfif>
	            where Ecodigo = #session.Ecodigo#
	            and rt.Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
	           	<cfif Arguments.Origen EQ "TES">
	            	and (rt.ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
	            		or (rt.ID_Linea <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
							and ds.TESDPdocumentoOri = (select TESDPdocumentoOri from TESdetallePago where TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
						)
					)
					and (
						eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
						or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
					)
				union all
				select distinct timbre as TimbreFiscal from #repositorio#CERepositorio rt
				inner join TESdetallePago ds
					on rt.IdDocumento = ds.TESDPid
					and rt.origen = 'TES'
				inner join TESsolicitudPago eds
					on eds.TESSPid = ds.TESSPid
				where rt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ds.TESDPdocumentoOri = (select TESDPdocumentoOri from TESdetallePago where TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
					and (
						eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
						or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
					)
				<cfelseif Arguments.Origen EQ "TSGS">
					and ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
					and rt.Origen = 'TSGS'
				<cfelse>
					and ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
	            </cfif>
	        </cfquery>

	        <cfif isdefined('datosCFDI') and datosCFDI.RecordCount GT 0>

                <cfquery  name="insRepo" datasource="#session.dsn#">
                    insert into CERepositorio(IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
                    archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,CEtipoLinea,CEdocumentoOri,CEtranOri,CESNB,
					<cfif Arguments.MetPago NEQ "">
						CEMetPago,
					</cfif>
					TipoComprobante,Serie,
					Mcodigo,TipoCambio,rfc,total,Miso4217)
					select #Arguments.idContable#,
						<cfif Arguments.Origen EQ "TES">
							#Arguments.idLinea#
						<cfelse>
							<cfif Arguments.idDocumentoH NEQ -1>
								#Arguments.idDocumentoH#
							<cfelse>
								#Arguments.idDocumento#
							</cfif>
						</cfif>,
						rt.Documento, rt.Origen, #idLineaP#, rt.TimbreFiscal,rt.xmlTimbrado, rt.xml, rt.docAdicional, rt.NomArchSoporte,
                     	rt.ExtArchSoporte, #session.Ecodigo#,#session.Usucodigo#,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.tipoLinea#" null="#trim(Arguments.tipoLinea) EQ ''#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="#Arguments.documentoOri#" null="#trim(Arguments.documentoOri) EQ ''#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="#Arguments.tranOri#" null="#trim(Arguments.tranOri) EQ ''#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.SNB#" null="#trim(Arguments.SNB) EQ '-1'#">
						<cfif Arguments.MetPago NEQ "">
							,<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MetPago#" null="#Len(trim(Arguments.MetPago)) Is 0#">
						</cfif>
						,rt.TipoComprobante,rt.Serie,
						rt.Mcodigo,rt.TipoCambio,
						<cfqueryparam cfsqltype="cf_sql_char" value="#replace(Arguments.rfc,'-','','all')#" null="#Len(trim(Arguments.rfc)) Is 0#">,
						rt.TotalCFDI,
						<!---
			            <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.total#" null="#Len(trim(Arguments.total)) Is 0#">, --->
			            (select Miso4217 from Monedas where Mcodigo = rt.Mcodigo)
						from (
							select distinct #Arguments.idContable# idContable,min(CEfileId) CEfileId,
								<cfif Arguments.Origen EQ "TES"> #Arguments.idLinea# <cfelse> #Arguments.idDocumento#</cfif> id,
								#idLineaP# linea
		                    from CERepoTMP rt
							<cfif Arguments.Origen EQ "TES">
					        	inner join TESdetallePago ds
									on rt.ID_Linea = ds.TESDPid
								inner join TESsolicitudPago eds
									on eds.TESSPid = ds.TESSPid
							</cfif>
		                    where Ecodigo = #session.Ecodigo#
					            and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
				           	<cfif Arguments.Origen EQ "TES">
					            	and (rt.ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
					            		or (rt.ID_Linea <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
											and ds.TESDPdocumentoOri = (select TESDPdocumentoOri from TESdetallePago where TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
										)
									)
									and (
										eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
										or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
									)
							<cfelseif Arguments.Origen EQ "TSGS">
								and ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
								and rt.Origen = 'TSGS'
							<cfelse>
								and ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
				            </cfif>
						) LRep
						inner join CERepoTMP rt
							on rt.CEfileId = LRep.CEfileId
							<!--- union all
							select #Arguments.idContable#,CEfileId,
								<cfif Arguments.Origen EQ "TES"> #Arguments.idLinea# <cfelse> #Arguments.idDocumento#></cfif> idDoc,
								#idLineaP# idLineaP
							from(
								select min(IdRep) IdRep
			                    from #repositorio#CERepositorio rt
								inner join TESdetallePago ds
									on rt.IdDocumento = ds.TESDPid
									and rt.origen = 'TES'
								inner join TESsolicitudPago eds
									on eds.TESSPid = ds.TESSPid
								where rt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and ds.TESDPdocumentoOri = (select TESDPdocumentoOri from TESdetallePago where TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
									and (
										eds.SNcodigoOri = (select a.SNcodigoOri from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
										or eds.TESBid = (select a.TESBid from TESsolicitudPago a inner join TESdetallePago b on a.TESSPid = b.TESSPid where b.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">)
									)
							) a
							inner join #repositorio#CERepositorio rt
								on a.IdRep = rt.IdRep --->

                </cfquery>

				<cfif Arguments.borrar EQ "S">
	                <cfquery  name="delRepoTmp" datasource="#session.dsn#">
	                	delete  from CERepoTMP
	                    where Ecodigo = #session.Ecodigo#
			            and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
			           	<cfif Arguments.Origen EQ "TES" or Arguments.Origen EQ "TSGS">
			            	and ID_Linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
						<cfelse>
							and ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
			            </cfif>
	                </cfquery>
				</cfif>
			</cfif>
	</cffunction>

	<cffunction name="getInfoXML" access="public" output="false">
		<cfargument name='idRepo' 	type='numeric' 	required='true'>
		<cfargument name='Ecodigo' 	type='string' 	required='false' default ="#session.Ecodigo#">
		<cfargument name='temp' 	type='boolean' 	default='false'> <!--- define si se toman los datos de la tabla temporal --->
		<!--- Ejemplo de uso --->
		<!---
			<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
				<cfset axml = LobjRepo.getInfoXML(3)>
			<cf_dump var="#axml#">
		--->

		<!--- Si existe configurado un Repositorio de CFDIs --->
		<cfquery name="getContE" datasource="#Session.DSN#">
			select ERepositorio from Empresa
			where Ereferencia = #Session.Ecodigo#
		</cfquery>

		<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
			<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
			<cfset repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>
			<cfset dbreponame = "">
		<cfelse>
			<cfset dbreponame = "">
		</cfif>


		<cfif arguments.temp>
			<cfquery name="getDoc"  datasource="#session.dsn#">
				select CEfileId IdRep,Ecodigo,TimbreFiscal timbre,xmlTimbrado,xml archivoXML,docAdicional archivo
				      ,ID_Documento IdDocumento,Documento numDocumento,ID_Linea linea,Origen origen,NomArchXML
				      ,NomArchSoporte nombreArchivo,ExtArchSoporte extension,TotalCFDI total,TipoComprobante
				      ,Mcodigo,TipoCambio,Serie,Miso4217,REPref
					case
						when docAdicional is not null then  1
						else 0
					end ExisteSoporte,
					NomArchSoporte + '.' + ExtArchSoporte archivoSoporte
				from CERepoTMP
			    where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
			   	and CEfileId = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.idRepo#">
			</cfquery>
		<cfelse>
			<cfquery name="getDoc"  datasource="#session.dsn#">
				select *,
					case
						when archivo is not null then  1
						else 0
					end ExisteSoporte,
					nombreArchivo + '.' + extension archivoSoporte
				from #dbreponame#CERepositorio
			    where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
			   	and IdRep = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.idRepo#">
			</cfquery>
		</cfif>

		<cfset strXML = StructNew()>
		<cfset strXML.SubTotal=0>
		<cfset strXML.Impuesto=0>
		<cfset strXML.RFCemisor="">
		<cfif getDoc.recordCount GT 0>
			<cfset strXML.ExisteSoporte = getDoc.ExisteSoporte>
			<cfset strXML.ArchivoSoporte = getDoc.archivoSoporte>
			<cfset strXML.UUID = getDoc.timbre>
			<cfset strXML.Tipo = "">
		</cfif>

		<cfif getDoc.recordCount GT 0>
			<cfif getDoc.xmlTimbrado NEQ "">
			<cfset xmlCode = #getDoc.xmlTimbrado#>
				<cfset xmlCode = ReplaceNoCase(xmlCode,"''", '"',"all")>
			<cfset archXML = XmlParse(xmlCode)>

			<cfset strXML.Tipo = archXML.Comprobante.XmlAttributes.tipoDeComprobante>

			<cfset strXML.UUID = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>

			<cftry>
				<cfset strXML.NombreEmisor=archXML.Comprobante.Emisor.XmlAttributes.nombre>
			<cfcatch type="any">

			</cfcatch>
			</cftry>
			<cfset strXML.RFCemisor=archXML.Comprobante.Emisor.XmlAttributes.rfc>

			<cftry>
			<cfset strXML.NombreReceptor=archXML.Comprobante.Receptor.XmlAttributes.nombre>
			<cfcatch type="any">

			</cfcatch>
			</cftry>
			<cfset strXML.RFCreceptor=archXML.Comprobante.Receptor.XmlAttributes.rfc>

            <cfset ECalleNodes = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Emisor/cfdi:DomicilioFiscal')>
            <cfif arraylen(ECalleNodes) GT 0>
				<cftry>
					<cfset strXML.PaisEmisor=archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.pais>
	                <cfset strXML.DireccionEmisor="Calle: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.calle#">
	                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# No.: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.noExterior#">
	                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# Colonia: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.colonia#">
	                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# CP: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.codigoPostal#">
	                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# Delegcion o Muncipio: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.municipio#">
				<cfcatch type="any">
					<cfset strXML.Impuesto = 0>
				</cfcatch>
				</cftry>
            </cfif>

			<cfset ConceptoNodes = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto')>
			<cfset strXML.SubTotal=0>
			<cfset aConceptos = ArrayNew(1)>
			<cfloop from="1" to="#arraylen(ConceptoNodes)#" index="i">
				<cfset stConcepto = StructNew()>
			   	<cfset ConceptoXML = xmlparse(ConceptoNodes[i])>
				<cfset currentrow = i>
			    <cfset stConcepto.Cantidad = "#ConceptoXML.Concepto.XmlAttributes.cantidad#">
			    <cfset stConcepto.Descripcion = "#ConceptoXML.Concepto.XmlAttributes.descripcion#">
			    <cfset stConcepto.Importe = "#LSParseNumber(ConceptoXML.Concepto.XmlAttributes.importe)#">
			    <cfset strXML.SubTotal= strXML.SubTotal + stConcepto.Importe>
			    <cfset arrayappend(aConceptos ,stConcepto)>
			</cfloop>
            <cfset strXML.Conceptos = aConceptos>

			<cfset EImpuestos = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Impuestos')>
			<cfif arraylen(EImpuestos) GT 0>
				<cftry>
					<cfset strXML.Impuesto = LSParseNumber(archXML.Comprobante.Impuestos.XmlAttributes.totalImpuestosTrasladados)>
				<cfcatch type="any">
					<cfset strXML.Impuesto = 0>
				</cfcatch>
				</cftry>
			<cfelse>
				<cfset strXML.Impuesto = 0>
			</cfif>
			<cfelse>
				<cfset strXML.RFCemisor=replace(getDoc.rfc,'-','','all')>
				<cfset strXML.TipoCambio = getDoc.TipoCambio>
				<cfset strXML.Miso4217 = getDoc.Miso4217>
				<cfset strXML.SubTotal = getDoc.total>
		</cfif>

		<cfset strXML.TipoComprobante = getDoc.TipoComprobante>
			<cfset strXML.RFCemisor=replace(strXML.RFCemisor,'-','','all')>
		<cfset strXML.Serie = getDoc.Serie>
		</cfif>

		<cfset strXML.MetPago = "">
		<cfif isdefined("getDoc.CEMetPago") and getDoc.CEMetPago NEQ "">
			<cfquery name="rsClave" datasource="#Session.dsn#">
				select Clave from CEMtdoPago a
				inner join TEStipoMedioPago b
					on a.Clave = b.TESTMPMtdoPago
					and b.TESTMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getDoc.CEMetPago#">
			</cfquery>

			<cfif rsClave.recordCount and rsClave.Clave NEQ "">
				<cfset strXML.MetPago = rsClave.Clave>
			</cfif>

		</cfif>
		<cfreturn strXML />
    </cffunction>

	<cffunction name="getArchivoAdicional" access="public" output="false" >
		<cfargument name='idRepo' 	type='numeric' 	required='true'>
		<cfargument name='Ecodigo' 	type='string' 	required='false' default ="#session.Ecodigo#">

		<!--- Ejemplo de uso --->
		<!---
			<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
				<cfset axml = LobjRepo.getArchivoAdicional(4)>
			<cf_dump var="#axml#">
		 --->

	    <!--- Si existe configurado un Repositorio de CFDIs --->
		<cfquery name="getContE" datasource="#Session.DSN#">
			select ERepositorio from Empresa
			where Ereferencia = #Session.Ecodigo#
		</cfquery>

		<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
			<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
			<cfset repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>
		</cfif>

		<cfset dbreponame = "">

		<cfquery name="getFile"  datasource="#session.dsn#">
	        SELECT archivo,replace(nombreArchivo,' ','_') nombreArchivo,extension from #dbreponame#CERepositorio
	        where IdRep = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.idRepo#">
	    </cfquery>

		<cfheader name="Content-Disposition" value="attachment; filename=#getFile.nombreArchivo#.#getFile.extension#">
		<cfcontent variable="#getFile.archivo#" reset="true" type="application/#getFile.extension# " />
	</cffunction>

	<cffunction name="AsignaCFDI" access="public" output="false">
		<cfargument name="cod" 			type="string" 	required='false' default = "">
		<cfargument name="Documento" 	type="string" 	required='false' default = "">
		<cfargument name="idDocumento" 	type="numeric" 	required='true'>
		<cfargument name="origen" 		type="string" 	required='true'>
		<cfargument name="idLinea" 		type="numeric" 	required='false' default="-1">
		<cfargument name="SNcodigo" 	type="numeric" 	required='false' default="-1">
		<cfquery name="rsValMON" datasource="#Session.DSN#">
			SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset valMON = "N">
		<cfif #rsValMON.RecordCount#  neq 0>
			<cfset valMON = rsValMON.Pvalor>
		</cfif>

		<cfquery name="rsValores" datasource="#Session.DSN#">
			SELECT Pvalor FROM Parametros WHERE Pcodigo = 200089 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset valValores = "N">
		<cfif #rsValores.RecordCount#  neq 0>
			<cfset valValores = rsValores.Pvalor>
		</cfif>

		<cfset paso =1>

		<cfif Arguments.SNcodigo NEQ "-1">
			<cfif Arguments.origen EQ "TES">
			    <cfquery name="getSocio" datasource="#session.dsn#">
			        select Replace(isnull(SNidentificacion,TESBeneficiarioId),'-','') SNidentificacion
					from TESsolicitudPago sp
					left join SNegocios snOri
						on sp.EcodigoOri = snOri.Ecodigo
						and sp.SNcodigoOri = snOri.SNcodigo
					left join (select TESBid, TESBeneficiarioId, TESBeneficiario
								from TESbeneficiario
								where CEcodigo = #session.CEcodigo#
					            and TESBactivo = 1
					) bn
						on sp.TESBid = bn.TESBid
			        where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			        	and TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
				</cfquery>
			<cfelse>
				<cfquery name="getSocio" datasource="#session.dsn#">
			        select Replace(Ltrim(Rtrim(SNidentificacion)),'-','') as SNidentificacion from SNegocios
			        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			    </cfquery>
			</cfif>
		</cfif>

		<cfquery name="getDoc"  datasource="#session.dsn#">
			select top 1 * from CERepoTMP
		    where (<cfif Arguments.cod NEQ "">
					REPref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cod#">
					or
					</cfif>
		    		(
						ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumento#">
						<cfif Arguments.idLinea NEQ "-1">
						and ID_Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idLinea#">
						</cfif>
					)
		    	)
				and Ecodigo = #Session.Ecodigo#
				and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.origen#">
		</cfquery>

		<cfif getDoc.recordCount GT 0>
			<cfif trim(getDoc.xmlTimbrado) NEQ "">
				<cftry>
                	<cfset stringXML = toString(getDoc.xml)>
					<!---Leer primero la XML--->
                    <cfif isdefined('stringXML') and stringXML NEQ "">
                        <cfscript>
                            /*binencode=BinaryEncode(binimage, Form.binEncoding); */
                            bindecode=BinaryDecode(toString(getDoc.xml), 'Hex');
                        </cfscript>
                        <!---Write the converted results to a file. --->
                        <cfset tempfile = GetTempDirectory()>
                        <cffile action="write" file="#tempfile#archivoXML#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#.xml" output="#getDoc.xml#" addnewline="No" >
                        <cffile action="read" file="#tempfile#archivoXML#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#.xml" variable="varXML">
                    </cfif>
					<cfset xmlCode = #varXML#>                    
					<!---<cfset xmlCode = replace("#xmlCode#","k",'"',"All")>--->
		            <CFSET archXML = XmlParse(xmlCode)>
		             <cfset lVarTotal=archXML.Comprobante.XmlAttributes.total>
		             <cfset lVarRFCemisor=replace(archXML.Comprobante.Emisor.XmlAttributes.rfc,'-','','all')>
		             <cfset lVarRFCreceptor=replace(archXML.Comprobante.Receptor.XmlAttributes.rfc,'-','','all')>
		             <cfset lVarTimbre = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
		            <!--- <cfset lVarXmlTimbrado = replace("#xmlCode#","""","\""","All")>
		        	 <cfset lVarXmlTimbrado = replace("#xmlCode#","'","''","All")>--->
                     <!---<cffile action="delete" file="#tempfile#archivoXML#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#.xml">--->
				<cfcatch>
		                <cfthrow message = "Error el  Archivo: #getDoc.NomArchXML# no  es un   CFDI v&aacute;lido">
		        </cfcatch>
		        </cftry>

				<cfif Arguments.origen NEQ "TES" or Arguments.origen NEQ "TSGS" or (Arguments.origen EQ "TES" and  valTES EQ "N")>
					<cfif isdefined("getSocio.SNidentificacion")>
						<cfif  trim(lVarRFCemisor) NEQ  trim(Replace(getSocio.SNidentificacion, "-", "" ,"all")) and lVarRFCemisor NEQ "" and (Arguments.origen EQ "CPFC" or Arguments.origen EQ "TES")>
							<cfif Arguments.cod NEQ "">
							<cfset refE = trim(Replace(getSocio.SNidentificacion, "-", "'" ,"all"))>
							<cf_errorCode	code = "800027"
								msg  = "El RFC @errorDat_1@ del CFDI no  corresponde con  el Socio del Documento @errorDat_2@"
								errorDat_1="#lVarRFCemisor#"
								errorDat_2="#refE#"
							>
							<cfset paso="NO">
						</cfif>
						</cfif>

						<cfif  trim(lVarRFCemisor) NEQ  trim(Replace(getSocio.SNidentificacion, "-", "" ,"all")) and lVarRFCreceptor NEQ "" and  Arguments.origen EQ "CCFC">
							<cfif Arguments.cod NEQ "">
							<cfset refR = trim(Replace(getSocio.SNidentificacion, "-", "'" ,"all"))>
							<cf_errorCode	code = "800027"
								msg  = "El RFC @errorDat_1@ del CFDI no  corresponde con  el Socio del Documento @errorDat_2@"
								errorDat_1="#lVarRFCreceptor#"
								errorDat_2="#refR#"
							>
							<cfset paso="NO">
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			<cfelse>
				<cfset lVarTimbre = getDoc.TimbreFiscal>
			</cfif>

			<cfif paso EQ 1>
				<!--- <cfquery name="getContE" datasource="asp">
					select ERepositorio from Empresa
					where Ereferencia = #Session.Ecodigo#
				</cfquery>

				<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
					<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
					<cfset repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>

					<cfset dbreponame = "">
				<cfelse>
					<cfset dbreponame = "">
				</cfif> --->

			     <cfquery name="existeCFDIrep" datasource="#Session.Dsn#">
			        select distinct timbre, numDocumento,origen
			        from CERepositorio
			        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			        	and timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
				        and numDocumento is not null
				        and isnull(TipoComprobante,1) = 1
					group by timbre,numDocumento,origen
			    	union all
					select distinct TimbreFiscal timbre,Documento numDocumento, Origen origen
			        from CERepoTMP
			        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				        and TimbreFiscal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
						and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.origen#">
						and isnull(TipoComprobante,1) = 1
						and Documento is not null
						and Documento <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">
					group by TimbreFiscal,Documento,Origen
			     </cfquery>
				 <cfif existeCFDIrep.recordCount GT 0>
					<cfif Arguments.cod NEQ "">
					<cfset msgd = "">
					<cfloop query="existeCFDIrep">
						<cfset ListAppend(msgd,"#numDocumento# (#origen#)",",")>
					</cfloop>
					<cf_errorCode	code = "800027"
						msg  = "El CFDI ya esta relacionado con los Documentos: @errorDat_1@"
						errorDat_1="#msgd#"
					>
			        <cfset paso ="NO">
			     </cfif>
			 </cfif>
			 </cfif>

			<cfif trim(getDoc.xmlTimbrado) EQ "">
			<cfset lVarTotal = 0>
			</cfif>
            <cfset lVarMcodigo = "">
           	<cfset lVarTCambio = 0>
			<cfset lVarMiso4217 = "">

			<cfif valMON EQ "N">
				<cfif (valValores EQ "N" or valValores EQ "S") and trim(getDoc.xmlTimbrado) EQ ""> <!--- No importa el valor del parametro, entra si no hay CFDI --->
					<cfif Arguments.Origen EQ "TES">
						<cfif isdefined("Arguments.idDocumento") and isdefined("Arguments.idLinea")>
							<cfquery name="rsDocumento" datasource="#Session.DSN#">
								select linea.TESDPid, linea.TESSPid,linea.Mcodigo, linea.tc,agr.total from (
									SELECT td.TESSPid, td.TESDPid,t.McodigoOri Mcodigo,t.TESSPtipoCambioOriManual tc, td.TESDPdocumentoOri
									FROM    TESsolicitudPago t
									inner join TESdetallePago td
										on t. TESSPid = td.TESSPid
									Where t.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and t.TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
										and td.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idLinea#">
								) linea
								inner join (
									SELECT td.TESSPid, sum(td.TESDPmontoSolicitadoOri) total,td.TESDPdocumentoOri
									FROM    TESsolicitudPago t
									inner join TESdetallePago td
										on t. TESSPid = td.TESSPid
									Where t.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and t.TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
									group by td.TESSPid,td.TESDPdocumentoOri
								) agr
									on linea.TESSPid = agr.TESSPid
									and linea.TESDPdocumentoOri = agr.TESDPdocumentoOri
							</cfquery>
						</cfif>
					<cfelseif Arguments.Origen EQ "CPFC">
						<cfif isdefined("Arguments.idDocumento")>
							<cfquery name="rsDocumento" datasource="#Session.DSN#">
								SELECT  IDdocumento,Mcodigo,EDtipocambio tc,EDtotal total
								FROM    EDocumentosCxP
								where IDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
						</cfif>
					<cfelseif Arguments.Origen EQ "CCFC">
						<cfif isdefined("Arguments.idDocumento")>
							<cfquery name="rsDocumento" datasource="#Session.DSN#">
								SELECT  EDid,Mcodigo,EDtipocambio tc,EDtotal total
								FROM    EDocumentosCxC
								where EDid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idDocumento#">
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
						</cfif>
					<cfelseif Arguments.Origen EQ "TSGS">
						<cfif isdefined("Arguments.idDocumento") and isdefined("Arguments.idLinea")>
							<cfquery name="rsDocumento" datasource="#Session.DSN#">
								select linea.Mcodigo,agr.total,linea.GELGtipoCambio tc from (
									select lg.GELid,lg.GELGnumeroDoc, lg.SNcodigo, lg.GELGtipoCambio, lg.Mcodigo
									from GEliquidacionGasto lg
									where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumento#">
										and lg.GELGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idLinea#">
										and lg.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								) linea
								inner join (
									select lg.GELid,lg.Mcodigo,sum(lg.GELGtotalOri) total,lg.GELGnumeroDoc, lg.SNcodigo
									from GEliquidacionGasto lg
									where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumento#">
										and lg.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									group by lg.GELid,lg.Mcodigo,lg.GELGnumeroDoc, lg.SNcodigo
								) agr
									on linea.GELid = agr.GELid
									and linea.GELGnumeroDoc = agr.GELGnumeroDoc
							</cfquery>
						</cfif>
					</cfif>
					<cfif isdefined("rsDocumento") and rsDocumento.recordCount GT 0 and isdefined("rsDocumento.Mcodigo")>
						<cfquery name="rsMisoMoneda" datasource="#Session.DSN#">
							select Miso4217 from Monedas
							where Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.Mcodigo#">
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
					</cfif>
					<cfif isdefined("rsDocumento") and rsDocumento.recordCount GT 0>
						<cfset lVarTotal = rsDocumento.total>
						<cfset lVarTCambio = rsDocumento.tc>
						<cfset lVarMiso4217 = rsMisoMoneda.Miso4217>
						<cfset lVarMcodigo = rsDocumento.Mcodigo>
					</cfif>
				</cfif>
			</cfif>
			<cfif  paso EQ 1>
				<cfquery name="updRepo" datasource="#Session.DSN#">
					update CERepoTMP set
						<cfif Arguments.Documento NEQ "">
						Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">,
						</cfif>
						ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumento#">
						<cfif Arguments.idLinea NEQ "-1">
						,ID_Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idLinea#">
						</cfif>
						<cfif valMON EQ "N">
							<cfif (valValores EQ "N" or valValores EQ "S") and trim(getDoc.xmlTimbrado) EQ ""> <!--- No importa el valor del parametro, entra si no hay CFDI --->
								<cfif lVarTotal NEQ 0>
						        	,TotalCFDI = <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">
						        </cfif>
					        	<cfif lVarMiso4217 NEQ "">
						        	,Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarMiso4217#" >
						        </cfif>
						        <cfif lVarMcodigo NEQ "">
									,Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lVarMcodigo#">
								</cfif>
								<cfif lVarTCambio NEQ "">
									,TipoCambio = <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTCambio#" >
								</cfif>
							</cfif>
						</cfif>
					where ( <cfif Arguments.cod NEQ "">
							REPref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cod#">
							or
							</cfif>
				    		(
								ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumento#">
								<cfif Arguments.idLinea NEQ "-1">
								and ID_Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idLinea#">
								</cfif>
							)
				    	)
						and Ecodigo = #Session.Ecodigo#
						and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.origen#">
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="GeneraSelloDigital" access="public" returntype="string">
    	<cfargument name="cadenaOriginal" 	type="string" 	required="yes">
		<cfargument name="archivoKey" 		type="string" 	required="yes">
		<cfargument name="clave" 			type="string" 	required="yes">

        <!--- para instanciar la Clase GeneraCSD --->
		<cfobject type="java" class="generacsd.GeneraCSD" name="myGeneraCSD">
		<cfset selloDigital = myGeneraCSD.getSelloDigital(cadenaOriginal,archivoKey,clave)>

		<cfif selloDigital EQ "FileNotFoundException">
			<cf_errorCode	code = "80009" msg = "No se pudo leer el archivo llave.">
		<cfelseif selloDigital EQ "BadPaddingException">
			<cf_errorCode	code = "80010" msg = "La clave es incorrecta.">
		<cfelseif FindNoCase('parse failure',selloDigital) GT 0>
			<cf_errorCode	code = "80011" msg = "Archivo llave invalido.">
		</cfif>

        <cfreturn selloDigital>
    </cffunction>

	<cffunction name="ObtenerCertificado" access="public">
    	<cfargument name="archivoCer" 		type="string" 	required="yes">
        <!--- para instanciar la Clase GeneraCSD --->
		<cfobject type="java" class="generacsd.GeneraCSD" name="myGeneraCSD">
		<cftry>
			<cfset certificado = myGeneraCSD.getCertificado(archivoCer)>
		<cfcatch type="java.security.cert.CertificateException">
			<cf_errorCode	code = "80012" msg = "Archivo certificado invalido.">
		</cfcatch>
			<!--- <cfset dateIni = LSparseDateTime(vCertificado.getNotBefore()) />
			<cfset dateFin = LSparseDateTime(vCertificado.getNotAfter()) /> --->
			<!--- <cf_dump var="#TestdateFrom# - #vCertificado.getNotBefore()#"> --->
		</cftry>

        <cfreturn certificado>
    </cffunction>

</cfcomponent>