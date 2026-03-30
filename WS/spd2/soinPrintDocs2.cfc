<cfcomponent  namespace="http://spd2.WS" output="no" wsVersion="1">
	<cfset LvarPunto	= ".">			<!--- Punto --->
	<cfset LvarSep_Col	= chr(250)>		<!--- Separador de Columnas --->
	<cfset LvarSep_Fil	= chr(249)>		<!--- Separador de Filas --->

	<cffunction name="enviar_spd2" access="public" output="yes">
		<cfargument name="DESCRIPCION" 	type="string"	required="yes"	displayname="Descripcion que aparece en confirmacion de impresion">
		<cfargument name="ARCHIVO" 		type="string"	required="yes"	displayname="Nombre Archivo de download">
		<cfargument name="FMT01COD" 	type="string"	required="yes"	displayname="FMT01COD: Codigo de Formato de Impresion a imprimir">
		<cfargument name="FMT01KEY" 	type="string"	required="yes"	displayname="FMT01KEY: Campo de control de consecutivo">
		<cfargument name="Cantidad" 	type="numeric"	required="yes"	displayname="Cantidad de count(distinct <FMT01KEY>)">
		<cfargument name="Idioma" 		type="string"	required="yes"	displayname="Idioma=0:Español, 1:US English, 2:UK English">
		<cfargument name="Especial"		type="boolean"	required="yes"	displayname="Reimpresion Especial de Cheques">
		<cfargument name="Nacion"		type="boolean"	required="yes"	displayname="Cuando TESMPcodigo EQ CHK_NACION">
		<cfargument name="Datos_SQL" 	type="struct"	required="no"	displayname="Datos a sustiuir en el SQL del Tipo de Formato de Impresion" default="#structNew()#">
		
		<cfsetting enablecfoutputonly="yes">

		<!--- Crea el token de verificacion --->
		<cfparam name="Application.spd2" default="#structNew()#">
		<cfset LvarToken = "T" & numberformat(int(rand()*getTickcount()),"0")>
		<cfset Application.spd2[LvarToken] 				= structNew()>
		<cfset Application.spd2[LvarToken].ts 			= getTickcount()>
		<cfset Application.spd2[LvarToken].DESCRIPCION 	= arguments.DESCRIPCION>
		<cfset Application.spd2[LvarToken].ARCHIVO 		= arguments.ARCHIVO>
		<cfset Application.spd2[LvarToken].FMT01COD 	= arguments.FMT01COD>
		<cfset Application.spd2[LvarToken].FMT01KEY 	= arguments.FMT01KEY>
		<cfset Application.spd2[LvarToken].Cantidad 	= arguments.Cantidad>
		<cfset Application.spd2[LvarToken].Idioma 		= arguments.Idioma>
		<cfset Application.spd2[LvarToken].Especial 	= arguments.Especial>
		<cfset Application.spd2[LvarToken].Nacion		= arguments.Nacion>
		<cfset Application.spd2[LvarToken].dsn 			= session.dsn>

		<cfset Application.spd2[LvarToken].Datos_SQL = structNew()>
		<cfloop collection="#arguments.Datos_SQL#" item="LvarDato">
			<cfset Application.spd2[LvarToken].Datos_SQL[LvarDato] = arguments.Datos_SQL[LvarDato]>
		</cfloop>

		<cfoutput>
			<div align="center">
				<table border="0" width="100%">
					<tr>
						<td align="center">
							<img src="#CGI.CONTEXT_PATH#/WS/spd2/soinPrintDocs2.png">
						</td>
					</tr>
					<tr>
						<td align="center">
							...
						</td>
					</tr>
					<tr>
						<td align="center" style="font-family::Verdana, Geneva, sans-serif;">
							Se ha enviado la orden de impresion a soinPrintDocs2
						</td>
					</tr>
				</table>
			</div>
			<iframe id		= "ifrSoinPrintDocs2" 
					src		= "#CGI.CONTEXT_PATH#/WS/spd2/soinPrintDocs2.cfm?token=#LvarToken#"
					width	= "0"
					height	= "0"
			></iframe>
		</cfoutput>
	</cffunction>
	
	<cffunction name="leerDatos" access="remote" output="no" returntype="string">
		<cfargument name="Token"	type="string">

		<cftry>
			<cfif not isdefined("Application.spd2.#arguments.Token#")>
				<cfthrow message="No existe autorizacion para la Orden de Impresion">
			</cfif>

			<cfset Lvar_spd2 = Application.spd2[arguments.Token]>
			<cfset StructDelete(Application.spd2, arguments.Token)>

			<cfif abs(getTickcount() - Lvar_spd2.ts) GT 60000>
				<cfthrow message="La Autorizacion de la Orden de Impresion ha expirado">
			</cfif>
			
			<cfif Lvar_spd2.Nacion>
				<cfreturn fnLeerDatosNacion()>
			<cfelse>
				<cfreturn fnLeerDatos()>
			</cfif>
		<cfcatch type="any">
			<cfthrow message="##WSerror###cfcatch.message###WSerror##">
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="fnLeerDatos" access="private" output="no" returnType="string">
		<cfset LvarResultados = arrayNew(1)>

		<cfquery name="rsFormatoDoc" datasource="#Lvar_spd2.dsn#">
			SELECT
				rtrim(a.FMT01COD) 	as FMT01COD,		<!--- Codigo Formato--->
				rtrim(FMT01DES) 	as FMT01DES,		<!--- Descripción --->
				FMT01TIP,  						  		<!--- Tipo de Formato--->
				
				FMT01TOT,								<!--- Lineas Formato TOTAL --->
				FMT01LIN,								<!--- Lineas Encabezado --->
				FMT01DET,								<!--- Lineas Detalle --->
				FMT01PDT,								<!--- Lineas PostDetalle --->
				FMT01SPC,								<!--- Espacio entre Lineas Detalle --->
				FMT01ENT,								<!--- Mantener retorno de Linea --->
				FMT01REF,								<!--- Referencia --->
				
				FMT01LAR,								<!--- Alto o Largo --->
				FMT01ANC,								<!--- Ancho --->
				
				FMT01ORI,								<!---Orientación: 1=Vertical, 0=Horizontal --->
				
				FMT01LFT,								<!--- Margen Izquierdo --->
				FMT01TOP,								<!--- Margen Superior --->
				FMT01RGT,								<!--- Margen Derecho --->
				FMT01BOT,								<!--- Margen Inferior --->
				s.FMT01SQL as SQL						<!--- SQL --->
			 FROM FMT001 a
				inner join FMT000 s
					 on s.FMT00COD=a.FMT01TIP 
			WHERE FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_spd2.FMT01COD#">
		</cfquery>

		<cfquery name="rsFormatoCol" datasource="#Lvar_spd2.dsn#">
			SELECT
				FMT02POS,								<!--- Posicion:  1=Encabezado, 2=Detalle, 3=Total --->
				FMT02FIL AS FMT02_X,					<!--- Posición Horizontal	(equivale a CurrentX) --->
				FMT02COL AS FMT02_Y,					<!--- Posición Vertical	(equivale a CurrentY) --->
				FMT02TIP,								<!--- Tipo de Campo: 1=Etiqueta, 2=Dato --->
				case FMT02TIP
					when 1 then FMT02DES
					else FMT11NOM
				end AS FMT02SQL,						<!--- Campo cuando tipo Dato o Valor cuando Etiquetas --->
				FMT02AJU,								<!--- Ajusta Linea --->
				FMT02FMT,								<!--- Formato --->
				FMT02LON,								<!--- Longitud --->
				FMT02DEC,								<!--- Decimales --->
				FMT02JUS,								<!--- Alineacion:  1=Izquierda, 2=Centrado, 3=Derecha --->
				FMT02TPL,								<!--- Fuente:    Arial, Courier, sans-serif --->
				FMT02TAM,								<!--- Tamaño Letra:  6 - 16 --->
				FMT02CLR,								<!--- Color --->
				FMT02BOL,								<!--- Negrita --->
				FMT02UND,								<!--- Subrayado --->
				FMT02ITA,								<!--- Itálica --->
				FMT02PAG,								<!--- Salto de Página --->
				FMT02PRE,								<!--- Prefijo --->
				FMT02SUF								<!--- Sufijo --->
			 FROM FMT001 a
				inner join FMT002 b 
					 on b.FMT01COD = a.FMT01COD
					and b.FMT02STS <> 1
			WHERE b.FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_spd2.FMT01COD#">
			order by FMT02POS, FMT02_Y, FMT02_X
		</cfquery>

		<cfset LvarCampos	= StructNew()>
		<cfloop query="rsFormatoCol">
			<cfif rsFormatoCol.FMT02TIP EQ 2>
				<cfset LvarCampos["#ucase(rsFormatoCol.FMT02SQL)#"] = rsFormatoCol.FMT02FMT>
			</cfif>
		</cfloop>

		<cfif NOT StructKeyExists(LvarCampos, "#ucase(Lvar_spd2.FMT01KEY)#")>
			<cfset LvarCampos["#ucase(Lvar_spd2.FMT01KEY)#"] = "">
		</cfif>

		<!--- Sustituye los datos del SQL de sustitucion --->
		<cfset LvarSQL = rsFormatoDoc.SQL>
		<cfloop collection="#Lvar_spd2.Datos_SQL#" item="LvarDato">
			<cfset LvarSQL = ReplaceNoCase(LvarSQL, "##" & LvarDato & "##", Lvar_spd2.Datos_SQL[LvarDato], "ALL")>
		</cfloop>

		<cfquery name="rsDatos" datasource="#Lvar_spd2.dsn#">
			#preservesinglequotes(LvarSQL)#
		</cfquery>

		<!--- Verifica cantidad de control --->
		<cfquery name="rsDatosCtrl" dbtype="query">
			select count(distinct #Lvar_spd2.FMT01KEY#) as cantidad
					, min (#Lvar_spd2.FMT01KEY#) as PrimerKEY
			  from rsDatos
		</cfquery>

		<cfif rsDatosCtrl.cantidad NEQ Lvar_spd2.cantidad>
			<cf_errorCode	code = "50764"
							msg  = "La cantidad de cheques a imprimir (@errorDat_1@) no coincide con la cantidad de formularios en el Lote (@errorDat_2@). Se debe revisar con PSO el SQL en el Tipo de Formato de Impresión."
							errorDat_1="#rsDatosCtrl.cantidad#"
							errorDat_2="#Lvar_spd2.cantidad#"
			>
		</cfif>

		<cfset LvarColSQL = rsDatos.getColumnnames()>
		<cfset LvarColSQLlst = arrayToList(LvarColSQL)>
		<cfif listFindNoCase(LvarColSQLlst,"MontoEnLetrasMX")>
			<cfset LvarObjMonto = createObject("component","sif.Componentes.montoEnLetras")>
			<cfif NOT listFindNoCase(LvarColSQLlst,"EcodigoPago")>
				<cfthrow message="Para utilizar MontoEnLetrasMX debe incluir EcodigoPago en el Tipo de Formato de Impresión">
			</cfif>
			<cfif NOT listFindNoCase(LvarColSQLlst,"Miso4217Pago")>
				<cfthrow message="Para utilizar MontoEnLetrasMX debe incluir Miso4217Pago en el Tipo de Formato de Impresión">
			</cfif>
			<cfset LvarMonedaPago 	 = "">
			<cfset LvarMonedaPagoSuf = "">
			<cfif ListFind("1,2",Lvar_spd2.idioma)>
				<cfif rsDatos.Miso4217Pago EQ "USD">
					<cfset LvarMonedaPago = "dollars">
				</cfif>
			<cfelseif rsDatos.Miso4217Pago EQ "MXP">
				<cfset LvarMonedaPago 	 = "pesos">
				<cfset LvarMonedaPagoSuf = " M.N.">
			<cfelse>
				<cfquery name="rsMonedaPago" datasource="#Lvar_spd2.dsn#">
					  select Mnombre
						from Monedas m
					   where Ecodigo  = #rsDatos.EcodigoPago#
						 and Miso4217 = '#rsDatos.Miso4217Pago#'
				</cfquery>
				<cfset LvarMonedaPago = rsMonedaPago.Mnombre>
			</cfif>
		</cfif>

		<!--- 
			Verifica que todos los campos requeridos en el diseño del Formato de Impresión
			estén incluidos en el cfquery SQL
		--->
		<cfset LvarLinea = "">
		<cfset LvarColSQLN = 0>
		<cfloop item="LvarFMT" collection=#LvarCampos#>
			<cfif NOT ListFindNoCase(LvarColSQLlst, LvarFMT)>
				<cfset LvarLinea = LvarLinea & "'#ucase(LvarFMT)#', ">
			<cfelse>
				<cfset LvarColSQLN = LvarColSQLN + 1>
			</cfif>
		</cfloop>

		<cfif LvarLinea NEQ "">
			<cfset LvarLinea = mid(LvarLinea,1,len(LvarLinea) - 2)>
			<cfthrow message="ERROR: Los siguientes campos están definidos en el diseño del Formato de Impresión,\npero no se incluyeron en la Consulta SQL:\n\n#LvarLinea#">
		<cfelse>
			<!---
				Public Sub sbFormatoDoc(
					ByVal vFMT01COD As String, 
					ByVal vFMT01DES As String, 
					ByVal vFMT01TIP As String, 
					ByVal vFMT01KEY As String, 
					ByVal vFMT01TOT As Short, 
					ByVal vFMT01LIN As Short, 
					ByVal vFMT01DET As Short, 
					ByVal vFMT01PDT As Short, 
					ByVal vFMT01SPC As Double, 
					ByVal vFMT01ENT As Boolean, 

					ByVal vFMT01REF As String, 
					ByVal vFMT01LAR As Double, 
					ByVal vFMT01ANC As Double, 
					ByVal vFMT01ORI As Short, 
					ByVal vFMT01LFT As Double, 
					ByVal vFMT01TOP As Double, 
					ByVal vFMT01RGT As Double, 
					ByVal vFMT01BOT As Double, 

					ByVal vNumImagenes As Short, 
					ByVal vNumLineas As Short, 

					ByVal vNumColFmt As Short, 
					ByVal vNUMCOLSQL As Short, 

					ByVal vNumDocumento As String, 
					ByVal vTotDocumentos As Short, 
					ByVal vNUMFILSQL As Integer, 

					ByVal vHacerCortePag As Boolean, 

					ByVal vIdioma As Short,
					ByVal vDescripcion As String
				)
			--->

			<cfoutput query="rsFormatoDoc">
				<cfinvoke method="sbResultadoAppend"
					
					_metodo_01			= "FormatoDoc"
					
					_dato1  			= "#JSstringFormat(FMT01COD)#"
					_dato2  			= "#JSstringFormat(FMT01DES)#"
					_dato3  			= "#JSstringFormat(FMT01TIP)#"
					_dato4  			= "#JSstringFormat(Lvar_spd2.FMT01KEY)#"
					_dato5  			= "#FMT01TOT#"
					_dato6  			= "#FMT01LIN#"
					_dato7  			= "#FMT01DET#"
					_dato8  			= "#FMT01PDT#"
					_dato9  			= "#FMT01SPC#"
					_dato10 			= "#FMT01ENT#"

					_dato11				= "#JSstringFormat(FMT01REF)#"
					_dato12				= "#FMT01LAR#"
					_dato13				= "#FMT01ANC#"
					_dato14				= "#FMT01ORI#"
					_dato15				= "#FMT01LFT#"
					_dato16				= "#FMT01TOP#"
					_dato17				= "#FMT01RGT#"
					_dato18				= "#FMT01BOT#"

					_dato19				= "1"
					_dato20				= "1"

					_dato21				= "#rsFormatoCol.RecordCount#"
					_dato22				= "#LvarColSQLN#"

					_dato23				= "#rsDatosCtrl.PrimerKEY#"
					_dato24				= "#rsDatosCtrl.Cantidad#"
					_dato25				= "#rsDatos.RecordCount#"

					_dato26				= "#false#"
					
					_dato27				= "#Lvar_spd2.idioma#"
					_dato28				= "#JSstringFormat(Lvar_spd2.DESCRIPCION)#"

					_cantidad_02		= "28"
				>
			</cfoutput>

			<!---
				Public Sub sbFormatosCol(
					ByVal vFMT02POS As Short, 
					ByVal vFMT02_X As Double, 
					ByVal vFMT02_Y As Double, 
					ByVal vFMT02TIP As Short, 
					ByVal vFMT02SQL As String, 
					ByVal vFMT02AJU As Boolean, 
					ByVal vFMT02FMT As String, 
					ByVal vFMT02LON As Double, 
					ByVal vFMT02DEC As Short, 
					ByVal vFMT02JUS As Short, 
					ByVal vFMT02TPL As String, 
					ByVal vFMT02TAM As Short, 
					ByVal vFMT02CLR As String, 
					ByVal vFMT02BOL As Boolean, 
					ByVal vFMT02UND As Boolean, 
					ByVal vFMT02ITA As Boolean, 
					ByVal vFMT02PAG As Boolean, 
					ByVal vFMT02PRE As String, 
					ByVal vFMT02SUF As String
				)
			--->

			<cfoutput query="rsFormatoCol">
				<cfinvoke method="sbResultadoAppend"

					_metodo_01			= "FormatosCol"

					_dato1  			= "#FMT02POS#"
					_dato2  			= "#FMT02_X#"
					_dato3  			= "#FMT02_Y#"
					_dato4  			= "#FMT02TIP#" 
					_dato5  			= "#JSstringFormat(FMT02SQL)#"
					_dato6  			= "#FMT02AJU#"
					_dato7  			= "#JSstringFormat(FMT02FMT)#"
					_dato8  			= "#FMT02LON#"
					_dato9  			= "#FMT02DEC#"
					_dato10  			= "#FMT02JUS#"
					_dato11  			= "#JSstringFormat(FMT02TPL)#"
					_dato12  			= "#FMT02TAM#"
					_dato13  			= "#JSstringFormat(FMT02CLR)#"
					_dato14  			= "#FMT02BOL#"
					_dato15  			= "#FMT02UND#"
					_dato16  			= "#FMT02ITA#"
					_dato17  			= "#FMT02PAG#"
					_dato18  			= "#JSstringFormat(FMT02PRE)#"
					_dato19  			= "#JSstringFormat(FMT02SUF)#"

					_cantidad_02		= "19"
				>
			</cfoutput>

			<!---
				Public Sub sbDatosCol(ByVal ParamArray vColumn() As Object)
			--->
			<cfset LvarDatos = arrayNew(1)>
			<cfloop index="i" from="1" to="#arrayLen(LvarColSQL)#">
				<cfif StructKeyExists(LvarCampos, "#ucase(LvarColSQL[i])#")>
					<cfset arrayAppend(LvarDatos,LvarColSQL[i])>
				</cfif>
			</cfloop>
			<cfset sbResultadoAppendDatos("DatosCol", LvarDatos)>

			<!---
				Public Sub sbDatosLin(ByVal ParamArray vColumn() As Object)
			--->
			<cfloop query="rsDatos">
				<cfset LvarDatos = arrayNew(1)>
				<cfloop index="i" from="1" to="#arrayLen(LvarColSQL)#">
					<!---
						VALORES DE FMT02FMT:
							NumberFormat:	"#", "#0.00", "#0.000", "###", "###,###,###,###,##0.00", "###,###,###,###,##0.0000"
							DateFormat:		"dd/MM/yyyy", "dd/MMM/yyyy", "MMM/dd/yyyy", "MM/dd/yyyy"
							TimeFormat:		"hh:mm:ss", "hh:mm"
					--->				
					<cfif StructKeyExists(LvarCampos, "#ucase(LvarColSQL[i])#")>
						<cfif Lvar_spd2.especial AND (ucase(LvarColSQL[i]) EQ "TESOPFECHAPAGO" OR ucase(LvarColSQL[i]) EQ "FECHAENLETRAS")>
							<cfset LvarDato = dateFormat(now(),"YYYY-MM-DD 00:00:00")>
						<cfelse>
							<cfset LvarDato = trim(evaluate("rsDatos." & LvarColSQL[i]))>
						</cfif>
						<cfif ucase(LvarColSQL[i]) EQ "MONTOENLETRASMX">
							<cfset LvarDato = LvarObjMonto.fnMontoEnLetras(LvarDato,Lvar_spd2.idioma,"",LvarMonedaPago) & LvarMonedaPagoSuf>
						</cfif>
						<cfset arrayAppend(LvarDatos,JSstringFormat(LvarDato))>
					</cfif>
				</cfloop>
				<cfset sbResultadoAppendDatos("DatosLin", LvarDatos)>
			</cfloop>
		</cfif>

		<cfreturn arrayToList(LvarResultados, LvarSep_Fil)>
	</cffunction>

	<cffunction name="fnLeerDatosNacion" access="private" output="no" returnType="string">
		<cfset LvarResultados = arrayNew(1)>

		<cfquery name="rsLote" datasource="#Lvar_spd2.dsn#">
			SELECT
				cb.CBcodigo,
				mp.Miso4217, mp.Mnombre,
				cfcr.CFformato 		as ECuenta, 
				cfcr.CFdescripcion 	as ECuentaDes
			  FROM TEScontrolFormulariosL cfl 
				INNER JOIN CuentasBancos cb 
					INNER JOIN Monedas mp
						ON mp.Mcodigo = cb.Mcodigo
					INNER JOIN CFinanciera cfcr
						ON cfcr.CFcuenta = (select min(CFcuenta) from CFinanciera WHERE Ecodigo=cb.Ecodigo AND Ccuenta = cb.Ccuenta)
				 ON cb.CBid = cfl.CBid 
			 WHERE cfl.TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_spd2.Datos_SQL["TESid"]#">
			   AND cfl.TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_spd2.Datos_SQL["TESCFLid"]#">
			   AND cfl.TESCFLestado	= 1 	 	/* En Impresion */ 
		</cfquery>

		<cfquery name="rsDatos" datasource="#Lvar_spd2.dsn#">
			SELECT
				cfd.TESCFDnumFormulario as NumCheque,
				op.TESOPfechaPago,
				op.TESOPbeneficiario,
				op.TESOPtotalPago,
				op.TESOPobservaciones,
				
				TESDPdocumentoOri,
				TESDPmontoPago, 
				cfdb.CFformato 		as DCuenta, 
				cfdb.CFdescripcion 	as DCuentaDes
				
			  FROM TEScontrolFormulariosL cfl 
				INNER JOIN TEScontrolFormulariosD cfd 
					INNER JOIN TESordenPago op 
						LEFT JOIN TESendoso e 
							 ON e.TESid 	= op.TESid 
							AND e.TESEcodigo = op.TESEcodigo 
						INNER JOIN CuentasBancos cb 
							 ON cb.CBid = op.CBidPago 
						 ON op.TESOPid 	= cfd.TESOPid 
					INNER JOIN TESdetallePago dp 
						LEFT JOIN CFinanciera cfdb 
							ON cfdb.CFcuenta = dp.CFcuentaDB 
						 ON dp.TESOPid 	= cfd.TESOPid 
					 ON cfd.TESid 	 	= cfl.TESid 
					AND cfd.CBid 	 	= cfl.CBid 
					AND cfd.TESMPcodigo	= cfl.TESMPcodigo 
					AND cfd.TESCFLid	= cfl.TESCFLid 
			 WHERE cfl.TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_spd2.Datos_SQL["TESid"]#">
			   AND cfl.TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_spd2.Datos_SQL["TESCFLid"]#">
			   AND cfl.TESCFLestado	= 1 	 	/* En Impresion */ 
			   and cfd.TESCFDestado	= 0
			 ORDER BY cfd.TESCFDnumFormulario 
		</cfquery>

		<cfquery name="rsqCheques" dbtype="query">
			select count(distinct NumCheque) as cantidad
					, min (NumCheque) as PrimerCheque
			  from rsDatos
		</cfquery>

		<cfif rsqCheques.cantidad NEQ rsLoteT.cantidad>
			<cf_errorCode	code = "50764"
							msg  = "La cantidad de cheques a imprimir (@errorDat_1@) no coincide con la cantidad de formularios en el Lote (@errorDat_2@). Se debe revisar con PSO el SQL en el Tipo de Formato de Impresión."
							errorDat_1="#rsqCheques.cantidad#"
							errorDat_2="#rsLoteT.cantidad#"
			>
		</cfif>

		<!---
			Public Sub sbNacionIni(
				ByVal vNUMFILSQL As Integer, 
				ByVal vTotDocumentos As Integer, 
				ByVal vNumDocumento As String, 
				ByVal vCBcodigo As String, 
				ByVal vMonedaISO As String, 
				ByVal vMoneda As String, 
				ByVal vCuenta As String, 
				ByVal vCuentaDes As String, 
				ByVal vUsulogin As String,
				ByVal vDescripcion As String
			)
		--->				
		<cfloop query="rsLote">
			<cfset sbResultadoAppend(
				"NacionIni",

				rsDatos.RecordCount, 
				rsqCheques.PrimerCheque,
				sqCheques.Cantidad, 
				JSstringFormat(rsLote.CBcodigo), 
				JSstringFormat(rsLote.Miso4217), 
				JSstringFormat(rsLote.Mnombre), 
				JSstringFormat(trim(rsLote.ECuenta)), 
				JSstringFormat(trim(rsLote.ECuentaDes)),
				JSstringFormat(session.Usulogin),
				JSstringFormat(Lvar_spd2.DESCRIPCION)
			)>
		</cfloop>

		<!---
			Public Sub sbNacionDatos(
				ByVal pNumeroCheque As String, 
				ByVal pFecha As String,
				ByVal pBeneficiario As String, 
				ByVal pMonto As String, 
				ByVal pObservaciones As String, 
				ByVal pDocumentoDet As String, 
				ByVal pMontoDet As String,
				ByVal pDcuenta As String, 
				ByVal pDcuentaDes As String 
						)
		--->				
		<cfloop query="rsDatos">
			<cfset LvarObservaciones = trim(replace(replace(rsDatos.TESOPobservaciones,chr(10)," ","ALL"),chr(13)," ","ALL"))>
			<cfset sbResultadoAppend(
				"NacionDatos",

				JSstringFormat(rsDatos.NumCheque),
				JSstringFormat(dateFormat(rsDatos.TESOPfechaPago,"YYYY-MM-DD")),
				JSstringFormat(rsDatos.TESOPbeneficiario),
				JSstringFormat(rsDatos.TESOPtotalPago),
				JSstringFormat(LvarObservaciones),
				
				JSstringFormat(rsDatos.TESDPdocumentoOri),
				JSstringFormat(rsDatos.TESDPmontoPago),
				JSstringFormat(trim(rsDatos.DCuenta)),
				JSstringFormat(trim(rsDatos.DCuentaDes))
			)>
		</cfloop>

		<cfreturn arrayToList(LvarResultados, LvarSep_Fil)>
	</cffunction>

	<cffunction name="sbResultadoAppend"	access="private" output="no">
		<cfargument name="_metodo_01"		type="string">
		<cfargument name="_cantidad_02"		type="numeric">

		<cfset var LvarLinea = createObject("java","java.lang.StringBuilder").init(Arguments._metodo_01)>

		<cfloop index="i" from="1" to="#Arguments._cantidad_02#">
			<cfset LvarLinea.append(LvarSep_Col).append(fnSinSeparadores(Arguments["_dato" & i]))>
		</cfloop>
		<cfset arrayAppend(LvarResultados, LvarLinea.toString())>
	</cffunction>

	<cffunction name="sbResultadoAppendDatos" access="private" output="no">
		<cfargument name="_metodo_01"	type="string">
		<cfargument name="datos"	 	type="array">

		<cfset var LvarLinea = createObject("java","java.lang.StringBuilder").init(Arguments._metodo_01)>
		<cfloop index="i" from="1" to="#arrayLen(Arguments.datos)#">
			<cfset LvarLinea.append(LvarSep_Col).append(fnSinSeparadores(Arguments.Datos[i]))>
		</cfloop>
		<cfset arrayAppend(LvarResultados, LvarLinea.toString())>
	</cffunction>
	
	<cffunction name="fnSinSeparadores" access="private" output="no" returntype="string">
		<cfargument name="dato" type="string">
		<cfreturn replace(replace(Arguments.dato,LvarSep_Col,LvarPunto,"ALL"),LvarSep_Fil,LvarPunto,"ALL")>
	</cffunction>
</cfcomponent>
