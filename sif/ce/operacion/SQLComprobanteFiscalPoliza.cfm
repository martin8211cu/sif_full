

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
<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio NEQ "1">
	<cfthrow
	    errorCode = "850001"
	    message = "No hay un repositorio de CFDI configurado"
	>
</cfif>


<!--- se obtiene la moneda local --->
<cfquery name="rsMonMiso" datasource="#Session.DSN#">
	SELECT  e.Mcodigo,m.Miso4217 FROM Empresas e, Monedas m
	where e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
		and e.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset lVarMon = "">
<cfset lVarIDMon = "">

<cfset paso =1>
<!--- <cf_dump var="#form#"> --->
<cfif isdefined('form.EliminarComprobante')>
	<cfquery datasource="#session.dsn#" name="rsTimbre">
        select timbre from CERepositorio
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDContable#">
			and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dlinea#">
    </cfquery>
	<cfquery datasource="#session.dsn#">
        delete CERepositorio
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDContable#">
			and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dlinea#">
    </cfquery>
	<cfquery datasource="#session.dsn#">
        delete CERepositorio
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTimbre.timbre#">
	</cfquery>
</cfif>

<cfquery name="getDoc"  datasource="#session.dsn#">
	select * from CERepositorio
    where Ecodigo  = #session.Ecodigo#
    	and IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDContable#">
		and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dlinea#">
</cfquery>

<cfif isdefined ('form.afimagen') and LEN(TRIM('form.afimagen'))>
	<cfset ArchivoXml=form.afimagen>
</cfif>
<cfset ext = replace(afnombreimagen,".","")>

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
			        <cfelse>
			        	<!--- <cfquery name="rsMonMiso" datasource="#Session.DSN#">
							SELECT  e.Mcodigo,m.Miso4217
							FROM    Empresas e, Monedas m
							where e.Ecodigo = m.Ecodigo
							and e.Mcodigo = m.Mcodigo
						</cfquery> --->
						<cfset lVarMiso4217 = "">
			        </cfif>
		        	<cfif isdefined("archXML.Comprobante.XmlAttributes.TipoCambio") and archXML.Comprobante.XmlAttributes.TipoCambio NEQ 0>
	                	<cfset lVarTCambio = archXML.Comprobante.XmlAttributes.TipoCambio>
	                <cfelse>
	                	<cfset lVarTCambio = "">
	                </cfif>
                	<cfquery name="rsMcodigo" datasource="#Session.DSN#">
						select top 1 Mcodigo from Monedas where Miso4217 = '#lVarMiso4217#'
					</cfquery>
					 <cfset lVarMcodigo = rsMcodigo.Mcodigo>
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
                <cfset ArchivoXml = #getDoc.nombreArchivo#>
                <cfset lVarRFCemisor="">
                <cfset lVarRFCreceptor="">
	                 <cfif valMON EQ "N" and valMON EQ "S">
		                <cfset lVarTotal = LSParseNumber(form.montoT)>
		                <cfset lVarMcodigo = LSParseNumber(form.Mcodigo)>
	                	<cfset lVarTCambio = LSParseNumber(form.tipoCambio)>
	                	<cfquery name="rsMiso4217" datasource="#Session.DSN#">
							select top 1 Miso4217 from Monedas where Mcodigo = #lVarMcodigo#
						</cfquery>
						<cfset lVarMiso4217 = #rsMiso4217.Miso4217#>
					<cfelse>
						<cfset lVarTotal = "">
		                <cfset lVarMcodigo = "">
	                	<cfset lVarTCambio = "">
	                	<cfset lVarMiso4217 = "">
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
 <!--- <cfif  trim(lVarRFCemisor) NEQ  trim(getSocio.SNidentificacion) and lVarRFCemisor NEQ "" and (Form.Origen EQ "CPFC" or Form.Origen EQ "TES")>
 	<script language="JavaScript1.2" type="text/javascript">
       alert('El RFC del CFDI no  corresponde con  el Socio del Documento!!!');
    </script>
	<cfset paso="NO">
 </cfif>
  <cfif  trim(lVarRFCemisor) NEQ  trim(getSocio.SNidentificacion) and lVarRFCreceptor NEQ "" and  Form.Origen EQ "CCFC">
 	<script language="JavaScript1.2" type="text/javascript">
       alert('El RFC del CFDI no  corresponde con  el Socio del Documento!!!');
    </script>
	<cfset paso="NO">
 </cfif> --->
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

<cfif Form.modo EQ "CAMBIO" and paso EQ 1 and not isdefined('form.EliminarComprobante')>
<!--- <cf_dump var = "#lVarXmlTimbrado#"> --->
	<cfquery name="updCFDI" datasource="#session.dsn#">
        update CERepositorio
        set timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
        	xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
        	<cfif isDefined("Form.AFimagen")>
        		archivoXML= <cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagen)#">,
        	</cfif>
		<!--- <cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#"> --->
		archivo = <cfif len(FORM.AFimagenPDF) NEQ 0><cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagenPDF)#"><cfelse>null</cfif>,
        <!--- archivo = <cf_dbupload filefield="AFimagenPDF" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
        <!--- NomArchXML = <cfif isdefined('form.AFnombre') and len(trim(form.AFnombre)) GT 0>
        				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">
                     <cfelse>
                     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArchivoXml#">
                     </cfif>, --->
        nombreArchivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#archSoporte#">,
        extension = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extSoporte#">,
        <!--- >TotalCFDI = <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">,--->
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
				<cfif lVarTotal NEQ "">
				,total = <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">
				</cfif>
			</cfif>
			<cfif form.opttipocomprobante EQ "3">
				,Serie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tSerie#" >
			</cfif>
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDContable#">
			and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dlinea#">
    </cfquery>
</cfif>

<cfif Form.modo EQ "ALTA" and paso EQ 1>
	<cfif isdefined("form.AFNombreSoporte") and len(trim(form.AFNombreSoporte)) GT 0>
		<cfset nomFile = listToArray(form.AFNombreSoporte,".")>
	</cfif>
	<cfquery name="insCFDI" datasource="#session.dsn#">
		insert into CERepositorio(IdContable,linea,timbre,xmlTimbrado,archivoXML,
					archivo,
					<cfif isdefined("form.AFNombreSoporte") and len(trim(form.AFNombreSoporte)) GT 0>
						nombreArchivo,extension,
					</cfif>
					Ecodigo,BMUsucodigo,TipoComprobante
					<cfif valMON EQ "N">,Miso4217,Mcodigo,TipoCambio,total</cfif>
	        			<cfif form.opttipocomprobante EQ "3">,Serie</cfif>)
        values(
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IDContable#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dlinea#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
        <!--- <cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
		<cfif len(FORM.AFimagen) NEQ 0><cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagen)#"><cfelse>null</cfif>,
        <!--- <cf_dbupload filefield="AFimagenPDF" accept="image/*,text/*,application/*" datasource="#session.dsn#">, --->
		<cfif len(FORM.AFimagenPDF) NEQ 0><cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(FORM.AFimagenPDF)#"><cfelse>null</cfif>,
        <cfif isdefined("form.AFNombreSoporte") and len(trim(form.AFNombreSoporte)) GT 0>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#nomFile[1]#">,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#nomFile[2]#">,
        </cfif>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.optTipoComprobante#">

			<cfif valMON EQ "N">
				,<cfif lVarMiso4217 NEQ ""><cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarMiso4217#"><cfelse>null</cfif>
				,<cfif lVarMcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#lVarMcodigo#"><cfelse>null</cfif>
				,<cfif lVarTCambio NEQ 0 and lVarTCambio NEQ ''><cfqueryparam cfsqltype="cf_sql_money" value="#lVarTCambio#"><cfelse>1</cfif>
				,<cfif lVarTotal NEQ 0 and lVarTotal NEQ ''><cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#"><cfelse>0</cfif>
			</cfif>
			<cfif form.opttipocomprobante EQ "3">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tSerie#" >
			</cfif>
        )
    </cfquery>
</cfif>
<!---<cf_dump var = "stop">--->
<cfoutput>
<script language="JavaScript" type="text/javascript">
	if (window.opener.funcRefrescar) {
		window.opener.funcRefrescar();
	}
	if (window.opener.funcClick) {
		window.opener.funcClick();
	}
	window.close();
</script>
</cfoutput>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">window.close();document.forms[0].submit();</script>
	</body>
</html>