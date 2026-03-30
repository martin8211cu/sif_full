<cfcomponent displayName="GenReportes" hint="Reportes Genericos">
	<cfsetting enablecfoutputonly="yes">
	<cffunction name="TirarReporte" displayName="Tirar Reporte" access="public" output="yes">
		<cfargument name="Ecodigo" 		displayName="Empresa" 	type="numeric" 	required="no" default="#Session.Ecodigo#">
		<cfargument name="Conexion" 	displayName="Conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="FMT01COD" 	displayName="Formato" 	type="string" 	required="true">
		<cfargument name="paramsRep" 	displayName="paramsRep" type="string" 	required="true">
		<!--- paramsRep = "NOMBRE=VALOR&NOMBRE=VALOR..." --->

		<cfargument name="sendToEmail" 	displayName="eMail" 	type="boolean" 	required="false" default="no">

		<!--- DATOS del Encabezado --->
		<cfquery name="rsFMT001" datasource="#Conexion#">
			select fi.FMT01DES, fi.FMT01TXT, tfi.FMT01SQL, tfi.FMT00COD
			  FROM FMT001 fi
				inner join FMT000 tfi
					 on tfi.FMT00COD=fi.FMT01TIP
			 where fi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
			   and fi.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FMT01COD#">
		</cfquery>

		<cfif rsFMT001.recordCount eq 0>
			<cf_errorCode	code = "51257"
							msg  = "El Formato de Impresión '@errorDat_1@' no existe o está asociado a un Tipo de Formato de Impresión que no existe"
							errorDat_1="#FMT01COD#"
			>
		</cfif>

		<!--- Campos potenciales --->
		<cfquery name="rsCampos" datasource="#Conexion#">
			select upper(FMT011.FMT11NOM) AS FMT11NOM, FMT02FMT, rtrim(FMT02PRE) as FMT02PRE, rtrim(FMT02SUF) as FMT02SUF, FMT11CNT
			  from FMT011
				left join FMT002
					on upper(FMT002.FMT11NOM) = upper(FMT011.FMT11NOM)
					and FMT002.FMT02TIP = 2
					and FMT002.FMT01COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FMT01COD#">
			 where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer"    value="#rsFMT001.FMT00COD#">
		</cfquery>

		<!--- Campo de Corte de Control --->
		<cfquery name="rsCNT" dbtype="query">
			select FMT11NOM
			  from rsCampos
			 where FMT11CNT = 1
		</cfquery>
		<cfset LvarCONTROL = rsCNT.FMT11NOM>
		
		<cfset LvarCartaE = rsFMT001.FMT01TXT>
		<cfset LvarCartaD = "">
		<cfif LvarCONTROL NEQ "">
			<cfset LvarPTO1 = findNoCase('<A href="detalle">',LvarCartaE)>
			<cfset LvarPTO2 = 0>
			<cfif LvarPTO1 NEQ 0>
				<cfset LvarPTO2 = findNoCase('</A>',LvarCartaE,LvarPTO1)>
				<cfif LvarPTO2 NEQ 0>
					<cfset LvarCartaE = mid(LvarCartaE,1,LvarPto1-1) & mid(LvarCartaE,LvarPTO2+4,len(LvarCartaE))>
					<cfloop condition="LvarPTO1 GT 0 AND ucase(mid(LvarCartaE,LvarPto1,3)) NEQ '<TR'">
						<cfset LvarPTO1 -= 1>
					</cfloop>
					<cfif LvarPTO1 NEQ 0>
						<cfset LvarPTO2 = findNoCase('</TR>',LvarCartaE,LvarPTO1)>
					</cfif>
				</cfif>
			</cfif>
			<cfif LvarPTO1 EQ 0 OR LvarPTO2 EQ 0>
				<cfthrow message="#LvarPTO1# #LvarPTO2# Formato de Carta posee Campo de Control pero NO tiene definida una línea de detalle">
			</cfif>
			<cfset LvarCartaD = mid(LvarCartaE,LvarPTO1, LvarPTO2-LvarPTO1 + 5)>
			<cfset LvarCartaE = mid(LvarCartaE,1,LvarPTO1-1) & "<DETALLE>" & mid(LvarCartaE,LvarPTO2+5,len(LvarCartaE))>
			<cfif findNoCase('<A href="detalle">',LvarCartaE)>
				<cfthrow message="Formato de Carta no debe tener definido más de una línea de detalle">
			</cfif>
		<cfelseif findNoCase('<A href="detalle">',LvarCartaE)>
			<cfthrow message="Formato de Carta NO posee Campo de Control pero tiene definida una línea de detalle">
		</cfif>

		<!--- Sustituye parametros --->
		<cfset LvarSQL = trim(rsFMT001.FMT01SQL)>
		<cfif LvarSQL eq "">
			<cf_errorCode	code = "51258"
							msg  = "El Formato de Impresión '@errorDat_1@' está asociado a un Tipo de Formato de Impresión que no tiene definido un SQL"
							errorDat_1="#FMT01COD#"
			>
		</cfif>

		<cfloop list="#Arguments.paramsRep#" index="LvarPar" delimiters="&"> 
			<cfset LvarParametro = listToArray(LvarPar,"=")>
			<cfset LvarCampo = LvarParametro[1]>
			<cfset LvarValor = LvarParametro[2]>
			<cfset LvarSQL = ReplaceNoCase(LvarSQL, "###LvarCampo###", "#LvarValor#", "ALL")>
		</cfloop>
		<cfset LvarPTO1 = Find("##",LvarSQL)>
		<cfloop condition="LvarPTO1 GT 0">
			<cfset LvarPTO2 = Find("##", LvarSQL, LvarPTO1+1)>
			<cfif LvarPTO2 GT 0>
				<cfset LvarPTO3 = Find("'", LvarSQL, LvarPTO1+1)>
				<cfif LvarPTO3 EQ 0 or LvarPTO3 GT LvarPTO2>
					<cf_errorCode	code = "51259"
									msg  = "Falta enviar el parametro @errorDat_1@"
									errorDat_1="#mid(LvarSQL,LvarPTO1,LvarPTO2-LvarPTO1+1)#"
					>
				</cfif>
			</cfif>
			<cfset LvarPTO1 = Find("##", LvarSQL, LvarPTO1+1)>
		</cfloop>

		<!--- Ejecuta el SQL --->
		<cfquery name="rsDatos" datasource="#session.dsn#">
			#preservesinglequotes(LvarSQL)#
		</cfquery>

		<cfif rsDatos.recordCount eq 0>
			<cf_errorCode	code = "51260" msg = "El SQL no generó datos para imprimir">
		</cfif>
		
		<cfset LvarCampos  = "">
		<cfset LvarCamposE = "">
		<cfset LvarCamposD = "">
		<cfloop list="#rsDatos.columnList#" index="LvarCampo">
			<cfset LvarCampos = ListAppend(LvarCampos,LvarCampo)>
			<cfif FindNoCase("###LvarCampo###",LvarCartaE)>
				<cfset LvarCamposE = ListAppend(LvarCamposE,LvarCampo)>
			</cfif>
			<cfif FindNoCase("###LvarCampo###",LvarCartaD)>
				<cfset LvarCamposD = ListAppend(LvarCamposE,LvarCampo)>
			</cfif>
		</cfloop>
		
		<cfset LvarEmail = false>
		<cfset LvarEmailMSG = "">
		<cfset LvarEmailSMTP = 0>
		<cfset LvarEmailHTML = 0>
		<cfif Arguments.sendToEmail>
			<cfset LvarEmail = true>
			<cfif NOT listFindNoCase(LvarCampos, "EMAIL")>
				<cfset LvarEmailMSG &= "- Error en la definición del Tipo de Formato de Impresión: no se incluyó el Campo 'eMail' como destino del correo\n">
				<cfset LvarEmail = false>
			</cfif>
			<!--- Obtiene datos del Usuario --->
			<cfquery name="rsFrom" datasource="#session.dsn#">
				select Pemail1 as correo
				  from Usuario a 
					inner join DatosPersonales b on a.datos_personales = b.datos_personales
				 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
			</cfquery>
			<cfset LvarEmailFROM = rsFrom.correo>
			<cfif NOT find("@",LvarEmailFROM)>
				<cfset LvarEmailMSG &= "- Error en la definición del Usuario '#session.Usulogin#: falta registrar el 'eMail'\n">
				<cfset LvarEmail = false>
			</cfif>
		</cfif>

		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>#rsFMT001.FMT01DES#</title>
		<style type="text/css">
			@media print {
				.noprint 
				{
					display: none;
				}
				.Corte_Pagina
				{
					PAGE-BREAK-AFTER: always
				}
			}
			@media screen {
				.Corte_Pagina
				{
					border:dotted 1px ##FF0000;
					margin-top:20px;
					margin-bottom:20px;
				}
			}
		</style>
	</head>
	<body>
		<a onClick="window.print();">		<img src="/cfmx/sif/imagenes/impresora.gif"	border="0" style="cursor:pointer" class="noprint" title="Imprimir"></a>
		</cfoutput>
		
		<!--- Genera una carta por registro o por Corte de Control --->
		<cfif LvarCONTROL EQ "">
			<cfoutput query="rsDatos">

				<cfset LvarCarta = fnSustituyeValores(LvarCartaE,LvarCamposE,rsCampos)>

				<cfif LvarEmail AND find("@",rsDatos.eMail)>
					<cfset LvarEmailSMTP += 1>
					<cfquery datasource="#session.dsn#">
						insert into SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
						 values(
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#LvarEmailFROM#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsDatos.email#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsFMT001.FMT01DES#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar"	value="#LvarCarta#">,
							1)
					</cfquery>
				<cfelse>
					<cfset LvarEmailHTML += 1>
					<cfif rsDatos.currentRow GT 1><div class="Corte_Pagina"></div></cfif>
					#LvarCarta#
				</cfif>

			</cfoutput>
		<cfelse>
			<cfset LvarCONTROLant = "">
			<cfset LvarCONTROLcnt = 0>
			<cfoutput query="rsDatos" group="#LvarCONTROL#">
				<cfset LvarCarta = fnSustituyeValores(LvarCartaE,LvarCamposE)>
				<cfset LvarCONTROLcnt += 1>
				<cfoutput>
					<cfset LvarCarta = replace(LvarCarta,"<DETALLE>", fnSustituyeValores(LvarCartaD,LvarCamposD) & "<DETALLE>")>
				</cfoutput>
				<cfset LvarCarta = replace(LvarCarta,"<DETALLE>", "")>

				<cfif LvarEmail AND find("@",rsDatos.eMail)>
					<cfset LvarEmailSMTP += 1>
					<cfquery datasource="#session.dsn#">
						insert into SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
						 values(
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#LvarEmailFROM#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsDatos.email#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsFMT001.FMT01DES#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar"	value="#LvarCarta#">,
							1)
					</cfquery>
				<cfelse>
					<cfset LvarEmailHTML += 1>
					<cfif LvarCONTROLcnt GT 1><div class="Corte_Pagina"></div></div></cfif>
					#LvarCarta#
				</cfif>

			</cfoutput>
		</cfif>

		<cfoutput>
			<cfif Arguments.sendToEmail>
				<cfif LvarEmailHTML GT 0>
					<cfif LvarEmailMSG NEQ "">
						<cfset LvarEmailMSG = "No se enviaron correos electrónicos porque se encontró:\n" & LvarEmailMSG>
						<cfset LvarEmailMSG &= "\nSe generaron #LvarEmailHTML# cartas para imprimir.">
					<cfelse>
						<cfset LvarEmailMSG &= "Se generaron #LvarEmailHTML# cartas para imprimir porque no se encontró eMail destino\n\n">
						<cfset LvarEmailMSG &= "Se enviaron #LvarEmailSMTP# correos electrónicos.">
					</cfif>
				<cfelse>
					<cfset LvarEmailMSG &= "Se enviaron #LvarEmailSMTP# correos electrónicos.">
				</cfif>
				<script language="javascript">
					alert("#LvarEmailMSG#");
					<cfif LvarEmailHTML EQ 0>
						window.close();
					</cfif>
				</script>
			</cfif>
			</body>
		</html>			
		</cfoutput>
		<cfsetting enablecfoutputonly="no">
	</cffunction>

	<cffunction name="fnSustituyeValores" output="no" returntype="string">
		<cfargument name="texto">
		<cfargument name="campos">
		
		<cfset LvarTexto = Arguments.texto>
		<!--- Sustituye cada posible campo del Query en la carta --->
		<cfloop list="#arguments.campos#" index="LvarCampo">
			<cfquery name="rsFMT" dbtype="query">
				select FMT02FMT,FMT02PRE,FMT02SUF from rsCampos where FMT11NOM = '#LvarCampo#'
			</cfquery>
			<cfset LvarFmt = rsFMT.FMT02FMT>
			<cfset LvarValor = rsDatos[LvarCampo]>

			<cfif isnumeric(LvarValor)>
				<cfif LvarFmt EQ "MONTOENLETRAS">
					<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
					<cfset LvarValor = LvarObj.fnMontoEnLetras(LvarValor, 0)>
				<cfelseif LvarFmt EQ "AMOUNTINWORDS">
					<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
					<cfset LvarValor = LvarObj.fnMontoEnLetras(LvarValor, 1)>
				<cfelseif find("##",LvarFmt) GT 0>
					<cfif find(",",LvarFmt) GT 0>
						<cfset LvarFmt1 = ",9">
					<cfelse>
						<cfset LvarFmt1 = "9">
					</cfif>
					<cfif find(".",LvarFmt) GT 0>
						<cfset LvarFmt1 = LvarFmt1 & mid(LvarFmt,find(".",LvarFmt),100)>
					</cfif>
					<cfset LvarValor = LSNUMBERFORMAT(LvarValor,LvarFmt1)>
				</cfif>
			<cfelseif isdate(LvarValor)>
				<cfif find("dd",LvarFmt)+find("hh",LvarFmt) GT 0>
					<cfset LvarValor = LSDATEFORMAT(LvarValor,LvarFmt)>
				<cfelseif LvarFmt EQ "FECHAENLETRAS">
					<cfobject component="sif.Componentes.fechaEnLetras" name="LvarObj">
					<cfset LvarValor = LvarObj.fnFechaEnLetras(LvarValor, 0)>
				<cfelseif LvarFmt EQ "DATEINWORDS">
					<cfobject component="sif.Componentes.fechaEnLetras" name="LvarObj">
					<cfset LvarValor = LvarObj.fnFechaEnLetras(LvarValor, 1)>
				</cfif>
			</cfif>
			<cfset LvarValor = "#rsFMT.FMT02PRE##LvarValor##rsFMT.FMT02SUF#">
			<cfset LvarTexto = ReplaceNoCase(LvarTexto, "###LvarCampo###", "#LvarValor#", "ALL")>
		</cfloop>
		<cfreturn LvarTexto>
	</cffunction>
</cfcomponent>

