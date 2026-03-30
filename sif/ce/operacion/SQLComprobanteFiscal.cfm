<!--- <cf_dump var="#form#"> --->
<cfset paso =1>
<cfquery name="getContE" datasource="#Session.DSN#">
	select ERepositorio from Empresa
	where Ereferencia = #Session.Ecodigo#
</cfquery>

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

<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio NEQ "1">
	<cfthrow
	    errorCode = "850001"
	    message = "No hay un repositorio de CFDI configurado"
	>
</cfif>

<cfif isdefined('form.EliminarComprobante')>
	<!---Eliminar Asociacion Manualmente y Relación de un XML--->
		<cfquery name="rsExisteDBitacoraDescargaSAT" datasource="#session.DSN#">
			select Relacionado ,UUID_Factura from DBitacoraDescargaSAT
			where Ecodigo  =  #Session.Ecodigo#
			and UUID_Factura=<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.TimbreFiscal#">
		</cfquery>
		<cfif rsExisteDBitacoraDescargaSAT.recordCount GT 0>
				<cfquery datasource="#session.DSN#">
						update DBitacoraDescargaSAT
						set Relacionado = null
						where Ecodigo  	=  #Session.Ecodigo#
						and UUID_Factura=<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.TimbreFiscal#">
				</cfquery>
		</cfif>
	<cfquery datasource="#session.dsn#">
        delete from CERepoTMP
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Origen#">
        and  (CEfileId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.idRep#">)
    </cfquery>
<cfelse>
	<cfset paso =1>
	<!--- <cf_dump var="#form#"> --->
	<cfif not isdefined('form.SubirComprobante')>
	<cfif isdefined('form.SNcodigo')>
		<cfif Form.Origen EQ "TES">
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
		        	and TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">
			</cfquery>
		<cfelse>
			<cfquery name="getSocio" datasource="#session.dsn#">
		        select Replace(Ltrim(Rtrim(SNidentificacion)),'-','') as SNidentificacion from SNegocios
		        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		    </cfquery>
		</cfif>
	</cfif>
	</cfif>

	<cfif not isdefined('form.SubirComprobante')>
	<cfquery name="getDoc"  datasource="#session.dsn#">
		select * from CERepoTMP
	    where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	    and Origen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Origen#">
	    and ID_Documento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.docID#">
		<cfif Form.modo EQ "CAMBIO">
		and  (CEfileId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.idRep#">)
		</cfif>
	</cfquery>
	</cfif>
	<cfif isdefined ('form.afimagen') and LEN(TRIM('form.afimagen'))>
		<cfset ArchivoXml=form.afimagen>
	</cfif>
	<cfset ext = replace(afnombreimagen,".","")>
		<!--- se obtiene la moneda local --->
		<cfquery name="rsMonMiso" datasource="#Session.DSN#">
			SELECT  e.Mcodigo,m.Miso4217 FROM Empresas e, Monedas m
			where e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
				and e.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfset lVarMon = "">
		<cfset lVarIDMon = "">

		<cfif isdefined('Form.AFnombre') and LEN(TRIM('Form.AFnombre')) and Form.AFnombre NEQ "" and FORM.OPTTIPOCOMPROBANTE EQ 1>
	        <cftry>
	            <CFFILE ACTION="READ" FILE="#ArchivoXml#" VARIABLE="xmlCode">
	            <CFSET archXML = XmlParse(xmlCode)>
	            <cfset lVarTotal=archXML.Comprobante.XmlAttributes.total>
	            <cfset lVarRFCemisor=archXML.Comprobante.Emisor.XmlAttributes.rfc>
	            <cfset lVarRFCreceptor=archXML.Comprobante.Receptor.XmlAttributes.rfc>
	            <cfset lVarTimbre = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
	            <cfset lVarXmlTimbrado = replace("#xmlCode#","""","\""","All")>
	            <cfset lVarXmlTimbrado = replace("#xmlCode#","'","''","All")>
	            <cfset lVarMiso4217 = lVarMon>
	            <cfif valMON EQ "N">
	            	<cfif isdefined("archXML.Comprobante.XmlAttributes.Moneda")>
	            		<cfset lVarMiso4217 = archXML.Comprobante.XmlAttributes.Moneda>
	            		<cfif uCase(lVarMiso4217) EQ "MXN">
							<cfset lVarMiso4217="MXP">
						</cfif>
	            	</cfif>
	            	<cfif isdefined("archXML.Comprobante.XmlAttributes.TipoCambio") and archXML.Comprobante.XmlAttributes.TipoCambio NEQ 0>
	            		<cfset lVarTCambio = archXML.Comprobante.XmlAttributes.TipoCambio>
	            		<cfif lVarTCambio EQ "">
		            		<cfset lVarTCambio = 1>
	            		</cfif>
	            	<cfelse>
	            		<cfset lVarTCambio = 1>
	            	</cfif>
	            	<cfquery name="rsMcodigo" datasource="#Session.DSN#">
    					select top 1 Mcodigo from Monedas where Miso4217 = '#lVarMiso4217#'
    				</cfquery>
					<cfif rsMcodigo.recordCount GT 0>
	            		<cfset lVarMcodigo = rsMcodigo.Mcodigo>
	            	</cfif>
	            </cfif>
				<cfcatch>
	                <cfthrow message = "Error el  Archivo: #Form.AFnombre# no  es un   CFDI v&aacute;lido">
	            </cfcatch>
	        </cftry>
	    <cfelse>
	    		<cfif Form.modo EQ "CAMBIO">
	    			<cfif form.opttipocomprobante EQ "3">
	            		<cfset lVarTimbre = form.tFolio>
	            	<cfelse>
	            		<cfset lVarTimbre = form.TimbreFiscal>
	            	</cfif>
	                <cfset lVarXmlTimbrado = #getDoc.xmlTimbrado#>
	                <cfif isdefined("ArchivoXml") and ArchivoXml NEQ "">
						<CFFILE ACTION="READ" FILE="#ArchivoXml#" VARIABLE="xmlCode">
		            	<CFSET archXML = XmlParse(xmlCode)>
		            	<cfset lVarTotal=archXML.Comprobante.XmlAttributes.total>
		            	<cfset lVarMiso4217 = archXML.Comprobante.XmlAttributes.Moneda>
		            	<cfif uCase(lVarMiso4217) EQ "MXN">
							<cfset lVarMiso4217="MXP">
						</cfif>
			        	<cfif isdefined("archXML.Comprobante.XmlAttributes.TipoCambio") and archXML.Comprobante.XmlAttributes.TipoCambio NEQ 0>
		                	<cfset lVarTCambio = archXML.Comprobante.XmlAttributes.TipoCambio>
		                	<cfif lVarTCambio EQ "">
			            		<cfset lVarTCambio = 1>
		            		</cfif>
		                <cfelse>
		                	<cfset lVarTCambio = 1>
		                </cfif>
		            <cfelse>
		            	<cfset lVarTotal = 0>
		            	<cfset lVarMiso4217 = "">
		            	<cfset lVarTCambio = 1>
					</cfif>
	                <cfset ArchivoXml = #getDoc.NomArchXML#>
	                <cfset lVarRFCemisor="">
	                <cfset lVarRFCreceptor="">

	                 <cfif valMON EQ "N">

	                	<cfquery name="rsMcodigo" datasource="#Session.DSN#">
							select top 1 Mcodigo from Monedas where Miso4217 = '#lVarMiso4217#'
						</cfquery>
						 <cfset lVarMcodigo = rsMcodigo.Mcodigo>
					</cfif>
	            <cfelse>
					<cfif form.opttipocomprobante EQ "3">
	            		<cfset lVarTimbre = form.tFolio>
	            	<cfelse>
	            		<cfset lVarTimbre = form.TimbreFiscal>
	            	</cfif>
	                <cfset lVarXmlTimbrado = "" ><!---#getDoc.xmlTimbrado#--->
	                <cfset ArchivoXml = ""> <!---#getDoc.NomArchXML#--->
	                <cfset lVarRFCemisor="">
	                <cfset lVarRFCreceptor="">

	                <cfif valMON EQ "N" and valMON EQ "S">
		                <cfset lVarTotal = LSParseNumber(form.montoT)> <!---#getDoc.TotalCFDI#--->
		                <cfset lVarMcodigo = LSParseNumber(form.Mcodigo)>
	                	<cfset lVarTCambio = LSParseNumber(form.tipoCambio)>
	                	<cfquery name="rsMiso4217" datasource="#Session.DSN#">
							select top 1 Miso4217 from Monedas where Mcodigo = #lVarMcodigo#
						</cfquery>
						<cfset lVarMiso4217 = #rsMiso4217.Miso4217#>
	                <cfelse>
	                	<cfset lVarTotal = 0>
		                <cfset lVarMcodigo = "">
	                	<cfset lVarTCambio = 0>
		            </cfif>
	           </cfif>
	    </cfif>
	<cfif not isdefined("lVarMiso4217")>
		<cfset lVarMiso4217 = "">
	</cfif>
	<cfquery name="rsExisteMiso4217" datasource="#Session.DSN#">
		select top 1 Miso4217 from Monedas where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarMiso4217#">
	</cfquery>
	<cfif rsExisteMiso4217.recordcount EQ 0>
		<cfset lVarMiso4217 = lVarMon>
		<cfset lVarMcodigo = lVarIDMon>
	</cfif>

	<cfquery name="validarTest" datasource="#Session.DSN#">
		SELECT Pvalor FROM Parametros WHERE Pcodigo = 200082 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfif validarTest.RecordCount GT 0>
		<cfset valTES = validarTest.Pvalor>
	<cfelse>
		<cfset valTES = 'N'>
	</cfif>

	<cfif not isdefined('form.SubirComprobante')>
	
	<cfif (Form.Origen NEQ "TES" AND Form.Origen NEQ "TSGS") or (Form.Origen EQ "TES" and  valTES EQ "N")>
		<cfif  trim(lVarRFCemisor) NEQ  trim(Replace(getSocio.SNidentificacion, "-", "" ,"all")) and lVarRFCemisor NEQ "" and (Form.Origen EQ "CPFC" or Form.Origen EQ "TES")>
			<script language="JavaScript1.2" type="text/javascript">
			<cfoutput>alert('El RFC #lVarRFCemisor# del CFDI no  corresponde con  el Socio del Documento #trim(Replace(getSocio.SNidentificacion, "-", "" ,"all"))#');</cfoutput>
		   </script>
			<cfset paso="NO">
		</cfif>
		<cfif  trim(lVarRFCreceptor) NEQ  trim(Replace(getSocio.SNidentificacion, "-", "" ,"all")) and lVarRFCreceptor NEQ "" and  Form.Origen EQ "CCFC">
			<script language="JavaScript1.2" type="text/javascript">
		      <cfoutput>alert('El RFC #lVarRFCreceptor# del CFDI no  corresponde con  el Socio del Documento #trim(Replace(getSocio.SNidentificacion, "-", "" ,"all"))#');</cfoutput>
		   </script>
			<cfset paso="NO">
			</cfif>
		</cfif>
	</cfif>


	 <cfif paso EQ 1>
			<cfquery name="getContE" datasource="asp">
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

	     <cfquery name="existeCFDIrep" datasource="#Session.Dsn#">
	        select distinct timbre, numDocumento,origen
	        from CERepositorio
	        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
		        and numDocumento is not null
			group by timbre,numDocumento,origen
	    	union all
			select distinct TimbreFiscal timbre,Documento numDocumento, Origen origen
	        from CERepoTMP
	        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and TimbreFiscal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
			and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Origen#">
				and Documento is not null
			<cfif isdefined("form.CambiarComprobante")>
				<cfif form.Origen EQ "TES">
					and ID_Linea <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IDlinea#">
				<cfelse>
					and ID_Documento <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">
				</cfif>
			</cfif>
	        group by TimbreFiscal,Documento,Origen
	     </cfquery>
		 <cfif existeCFDIrep.recordCount GT 0>
			<cfset msg = "El CFDI ya esta relacionado con los Documentos: \n">
			<cfset msgd = "">
			<cfloop query="existeCFDIrep">
				<cfset msgd = "   - #numDocumento# (#origen#) \n">
			</cfloop>
	        <script language="JavaScript1.2" type="text/javascript">
		       <cfoutput>
	           alert('#msg##msgd#');
	           </cfoutput>
	        </script>
	        <cfset paso ="NO">
	     </cfif>
	 </cfif>

	<cfif isdefined('Form.AFnombreSoporte') and Form.AFnombreSoporte NEQ "">
	    <cfset archSoporte = Replace('#Form.AFnombreSoporte#','#Form.AFnombreImagenSoporte#',"")>
	    <cfset archSoporte = Replace(archSoporte,".","")>
	<cfelseif isdefined('Form.NomArchSoporte') and Form.NomArchSoporte NEQ "">
		<cfset archSoporte = #Form.NomArchSoporte#>
	<cfelse>
	    <cfset archSoporte ="">
	</cfif>

	<cfif isdefined('Form.AFnombreImagenSoporte') and Form.AFnombreImagenSoporte NEQ "">
	    <cfset extSoporte = #trim(Form.AFnombreImagenSoporte)#>
	<cfelseif isdefined('Form.ExtArchSoporte') and Form.ExtArchSoporte NEQ "">
		<cfset extSoporte = #Form.ExtArchSoporte#>
	<cfelse>
	    <cfset extSoporte ="">
	</cfif>

	<cfif valMON EQ "N">
		<cfif valValores EQ "N" and valValores EQ "S"> <!--- No es necesario entrar aqui --->
			<cfif Form.Origen EQ "TES">
				<cfif isdefined("Form.docID") and isdefined("Form.IDlinea")>
					<cfquery name="rsDocumento" datasource="#Session.DSN#">
						SELECT  t.McodigoOri Mcodigo,t.TESSPtotalPagarOri total,t.TESSPtipoCambioOriManual tc
						FROM    TESsolicitudPago t
						inner join TESdetallePago td
							on t. TESSPid = td.TESSPid
						Where t.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and t.TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">
							and td.TESDPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IDlinea#">
					</cfquery>
				</cfif>
			<cfelseif Form.Origen EQ "CPFC">
				<cfif isdefined("Form.docID")>
					<cfquery name="rsDocumento" datasource="#Session.DSN#">
						SELECT  IDdocumento,Mcodigo,EDtipocambio tc,EDtotal total
						FROM    EDocumentosCxP
						where IDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				</cfif>
			<cfelseif Form.Origen EQ "CCFC">
				<cfif isdefined("Form.docID")>
					<cfquery name="rsDocumento" datasource="#Session.DSN#">
						SELECT  EDid,Mcodigo,EDtipocambio tc,EDtotal total
						FROM    EDocumentosCxC
						where EDid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				</cfif>
			<cfelseif Form.Origen EQ "TSGS">
				<cfif isdefined("Form.docID") and isdefined("Form.IDlinea")>
					<cfquery name="rsDocumento" datasource="#Session.DSN#">
						select 	lg.Mcodigo,lg.GELGtotalOri total,lg.GELGtipoCambio tc
					  	from GEliquidacionGasto lg
						where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.docID#">
						   and lg.GELGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDlinea#">
						   and lg.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("rsDocumento.Mcodigo")>
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

	<cfif Form.modo EQ "CAMBIO" and paso EQ 1 and not isdefined('form.EliminarComprobante')>
		<!--- <cf_dump var = "#form#"> --->
		<cfquery name="updCFDI" datasource="#session.dsn#">
	        update CERepoTMP
	        set TimbreFiscal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
	        xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
	        <!---xml=<cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,--->
	        <cfif len(FORM.AFimagenPDF) NEQ 0>
	        	docAdicional = <cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagenPDF)#">,
			</cfif>
	        <!--- <cf_dbupload filefield="AFimagenPDF" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
	        NomArchXML = <cfif isdefined('form.AFnombre') and len(trim(form.AFnombre)) GT 0>
	        				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">
	                     <cfelse>
	                     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArchivoXml#">
	                     </cfif>,
	        NomArchSoporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#archSoporte#">,
	        ExtArchSoporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extSoporte#">,
	        <cfif lVarTotal NEQ 0>
	        	TotalCFDI = <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">,
	        </cfif>
	        TipoComprobante = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.opttipocomprobante#">
	        <cfif valMON EQ "N">
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
			<cfif form.opttipocomprobante EQ "3">
				,Serie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tSerie#" >
			</cfif>
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Origen#">
		        and  (CEfileId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.idRep#">)
	    </cfquery>
	</cfif>

	<cfif Form.modo EQ "ALTA" and paso EQ 1>

		<cfquery name="insCFDI" datasource="#session.dsn#">
	    	insert into CERepoTMP (Ecodigo,TimbreFiscal,xmlTimbrado,xml,docAdicional,
	    	<cfif not isdefined('form.SubirComprobante')>ID_Documento,Documento,</cfif>
	    	Origen,
	    	<cfif not isdefined('form.SubirComprobante')>
			<cfif isdefined("form.IDlinea") and form.IDlinea NEQ "-1">ID_Linea, </cfif>
			</cfif>
	        NomArchXML,NomArchSoporte,ExtArchSoporte,TotalCFDI,TipoComprobante,BMUsucodigo
	        <cfif valMON EQ "N">,Miso4217,Mcodigo,TipoCambio</cfif>
	        <cfif form.opttipocomprobante EQ "3">,Serie</cfif>
	        <cfif isdefined('form.SubirComprobante')>,REPref</cfif>)
	        values(
	        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
	        <!--- <cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
	        <cfif len(FORM.AFimagen) NEQ 0><cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagen)#"><cfelse>null</cfif>,
	        <cfif len(FORM.AFimagenPDF) NEQ 0><cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagenPDF)#"><cfelse>null</cfif>,
			<!--- <cf_dbupload filefield="AFimagenPDF" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
	        <cfif not isdefined('form.SubirComprobante')>
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.docID#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.documento#">,
	        </cfif>
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.origen#">,
	        <cfif not isdefined('form.SubirComprobante')>
			<cfif isdefined("form.IDlinea") and form.IDlinea NEQ "-1"><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDlinea#">, </cfif>
	        </cfif>
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#archSoporte#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombreImagenSoporte#">,
	        <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">,
	        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.opttipocomprobante#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
			<cfif valMON EQ "N">
				,<cfif lVarMiso4217 NEQ ""><cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarMiso4217#"><cfelse>null</cfif>
				,<cfif lVarMcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#lVarMcodigo#"><cfelse>null</cfif>
				,<cfif lVarTCambio NEQ 0><cfqueryparam cfsqltype="cf_sql_money" value="#lVarTCambio#"><cfelse>null</cfif>
			</cfif>
			<cfif form.opttipocomprobante EQ "3">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tSerie#" >
			</cfif>
			<cfif isdefined('form.SubirComprobante')>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_xTMP#" ></cfif>
	        )
	    <cf_dbidentity1 datasource="#session.dsn#" name="insCFDI" verificar_transaccion= "false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insCFDI" returnvariable="LvarIdRep" verificar_transaccion= "false">

	</cfif>
</cfif>
<!---<cf_dump var = "stop">--->
<cfoutput>
<script language="JavaScript" type="text/javascript">
	<cfif isdefined("paso") and paso EQ 1 >
		<cfif Form.modo EQ "ALTA" and isdefined("form.mform")>
			try {
				<cfoutput>
			    window.opener.document.#form.mform#.#form.nombre#.value = '#lVarTimbre#';
			    </cfoutput>
			}
			catch(err) {

			}
		</cfif>


			try{
				if (window.opener.funcRefrescar#form.nombre#) {
					window.opener.funcRefrescar#form.nombre#(<cfif form.Origen eq 'CPFC' and Form.modo EQ "ALTA"><cfoutput>'#lVarTimbre#'</cfoutput></cfif>)
				}
				if (window.opener.funcClick#form.nombre#) {
					window.opener.funcClick#form.nombre#()
				}
			}
			catch(err) {

			}
		

	<cfelse>
		<cfif isdefined('form.SubirComprobante')>
			window.opener.document.#form.mform#.ce_nombre_xTMP.value = "";
			window.opener.document.#form.mform#.#form.nombre#.value = "";
		</cfif>
	</cfif>
	window.close();
</script>
</cfoutput>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>