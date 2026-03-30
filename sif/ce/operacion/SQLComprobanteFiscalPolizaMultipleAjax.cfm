<cfquery name="getContE" datasource="#Session.DSN#">
select ERepositorio from Empresa
where Ereferencia = #Session.Ecodigo#
</cfquery>

<cfset totalFiles = 0>
<cfset succesFiles = 0>

<cfset arrErros=ArrayNew(1)>
<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio NEQ "1">
	<cfset ArrayAppend(arrErros, "No hay un repositorio de CFDI configurado")>
<cfelse>
<cfset idx = 0>
	<cfloop collection="#form#" item="vArchivo">
		<cfif Left(vArchivo,4) EQ "file">
			<cfset vIDFile = "file#idx#">
			<cfset totalFiles = totalFiles +1>
			<cfset vFile = "name#Mid(vArchivo,5,Len(vArchivo)-4)#">
			<cfset vExt = "#Right(form[vFile],3)#">
			<cfif Ucase(vExt) EQ "XML">
				<cfset paso="true">
				<cftry>
		            <CFFILE ACTION="READ" FILE="#form[vArchivo]#" VARIABLE="xmlCode">
		            <CFSET archXML = XmlParse(xmlCode)>
		             <cfset lVarTotal=archXML.Comprobante.XmlAttributes.total>
		             <cfset lVarRFCemisor=archXML.Comprobante.Emisor.XmlAttributes.rfc>
		             <cfset lVarRFCreceptor=archXML.Comprobante.Receptor.XmlAttributes.rfc>
		             <cfset lVarTimbre = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
		             <cfset lVarXmlTimbrado = replace("#xmlCode#","""","\""","All")>
		        	 <cfset lVarXmlTimbrado = replace("#xmlCode#","'","''","All")>
		        	 <cftry>
						<cfset vMoneda=archXML.Comprobante.XmlAttributes.Moneda>
						<cfset vTipoCambio=archXML.Comprobante.XmlAttributes.TipoCambio>
						<cfquery name="getMoneda" datasource="#Session.DSN#">
							select m.Mcodigo, m.Mnombre, m.Miso4217
							from Monedas m
							where upper(ltrim(rtrim(m.Miso4217))) = upper('#trim(vMoneda)#')
						</cfquery>
						<cfif getMoneda.recordcount GT 0 >
							<cfset vMcodigo = #getMonLocal.Mcodigo#>
						<cfelse>
							<cfquery name="getMonLocal" datasource="#Session.DSN#">
								select m.Mcodigo, m.Mnombre, m.Miso4217 from Empresas e
								inner join Monedas m
									on e.Mcodigo = m.Mcodigo
									and e.Ecodigo = m.Ecodigo
								where e.Ecodigo = #Session.Ecodigo#
							</cfquery>
							<cfset vMcodigo = #getMonLocal.Mcodigo#>
						</cfif>
						<cfcatch type="any">
							<cfquery name="getMonLocal" datasource="#Session.DSN#">
								select m.Mcodigo, m.Mnombre, m.Miso4217 from Empresas e
								inner join Monedas m
									on e.Mcodigo = m.Mcodigo
									and e.Ecodigo = m.Ecodigo
								where e.Ecodigo = #Session.Ecodigo#
							</cfquery>
							<cfset vMcodigo = #getMonLocal.Mcodigo#>
							<cfset vTipoCambio="1.00">
						</cfcatch>
						</cftry>
						<cfif vTipoCambio EQ "0"><cfset vTipoCambio="1.00"></cfif>
						<cfquery name="getMiso4217" datasource="#Session.DSN#">
							select m.Mcodigo, m.Mnombre, m.Miso4217 from Monedas m
								where  m.Mcodigo = #vMcodigo#
								and m.Ecodigo = #Session.Ecodigo#
						</cfquery>
						<cfset vMiso4217 = #getMiso4217.Miso4217#>
		            <cfcatch>
			            <cfset ArrayAppend(arrErros, "#form[vFile]# : El  archivo no  es un CFDI v&aacute;lido")>
			            <cfset paso="false">
		            </cfcatch>
		        </cftry>

				<cfif paso>
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
				        select count(timbre) existe, timbre
				        from #dbreponame#CERepositorio
				        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				        and timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
						group by timbre
				     </cfquery>
				     <cfquery name="existeCFDI" datasource="#session.dsn#">
				        select count(TimbreFiscal) existe,TimbreFiscal
				        from CERepoTMP
				        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				        and TimbreFiscal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
						group by TimbreFiscal
				     </cfquery>
					 <cfif (existeCFDI.existe GT 0 and existeCFDI.TimbreFiscal NEQ "") OR (existeCFDIrep.existe GT 0 and existeCFDIrep.timbre NEQ "")>
				        <cfset ArrayAppend(arrErros, "#form[vFile]# : Ya existe un  Documento relacionado con el Timbre #lVarTimbre#")>
				        <cfset paso ="false">
				     </cfif>
				    <cfif paso>
					    <cfquery name="insCFDI" datasource="#session.dsn#">
							insert into CERepositorio(IdContable,linea,timbre,xmlTimbrado,archivoXML,Ecodigo,
								total,Mcodigo,TipoCambio,Miso4217,BMUsucodigo)
					        values(
					        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDContable#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.IDlinea#">,
					        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
					        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
					        <!--- <cf_dbupload filefield="#vArchivo#" accept="text/xml" datasource="#session.dsn#">, --->
					        <cfqueryparam cfsqltype="cf_sql_blob" value="#FileReadBinary(form[vIDFile])#">,
					        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					        <cfqueryparam cfsqltype="cf_sql_money" value="#lVarTotal#">,
					        <cfqueryparam cfsqltype="cf_sql_integer" value="#vMcodigo#">,
					        <cfqueryparam cfsqltype="cf_sql_money" value="#vTipoCambio#">,
					        <cfqueryparam cfsqltype="cf_sql_varchar" value="#vMiso4217#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">

					        )
					    </cfquery>
					    <cfset succesFiles = succesFiles + 1>
					</cfif>

				</cfif>
			<cfelse>
				<cfset ArrayAppend(arrErros, "#form[vFile]# : El archivo no es un XML")>
			</cfif>

			<cfset idx = idx+1>
		</cfif>
	</cfloop>
</cfif>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<b>Proceso Finalizado
			<cfif ArrayLen(arrErros) GT 0>
				con errores</b> &nbsp;<button onclick="printDiv('printArea')">Imprimir</button>
			</cfif>
				&nbsp;<button onclick="Finalizar()">Finalizar</button>
			<cfoutput><br><b>Se agregaron #succesFiles# de #totalFiles# archivos</cfoutput>
			</b>
		</td>
	</tr>
	<cfif ArrayLen(arrErros) GT 0>
		<tr>
			<td align="center">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<div id="printArea">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center">
								<b>Errores</b>
							</td>
						</tr>
						<cfloop from="1" to="#ArrayLen(arrErros)#" index="i">
							<cfoutput>
								<tr
								<cfif i MOD 2>
									bgcolor="##E8E8E8"
								<cfelse>
									bgcolor="white"
								</cfif>
								>
								<td>
									#arrErros[i]#
								</td>
								</tr>
							</cfoutput>
						</cfloop>
					</table>
				</div>
			</td>
		</tr>
	</cfif>
</table>



