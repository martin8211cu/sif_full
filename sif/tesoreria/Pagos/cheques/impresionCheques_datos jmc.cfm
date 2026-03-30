<cfif isdefined("url.download")>
	<cfinclude template="installSoinPrintDocs.cfm">
	<cfabort>
</cfif>
<cfparam name="form.FMT01COD" default="CHK001">
<cfquery name="rsFormatoDoc" datasource="#session.dsn#">
	SELECT
		rtrim(a.FMT01COD) 		as FMT01COD,  <!---Codigo Formato--->
		rtrim(FMT01DES) 		as FMT01DES,  <!--- Descripción --->
		FMT01TIP,  							  <!---Tipo de Formato--->
		'TESCFDNUMFORMULARIO'	as FMT01KEY,  <!--- Numero Doc para corte --->
		
		FMT01TOT,  		  <!--- Lineas Formato TOTAL --->
		FMT01LIN,  		  <!--- Lineas Encabezado --->
		FMT01DET,  		  <!--- Lineas Detalle --->
		FMT01PDT,  		  <!--- Lineas PostDetalle --->
		FMT01SPC,  		  <!---Espacio entre Lineas Detalle --->
		FMT01ENT,  		  <!---Mantener retorno de Linea --->
		FMT01REF,  		  <!---Referencia --->
		
		FMT01LAR,  		  <!--- Alto o Largo --->
		FMT01ANC,  		  <!--- Ancho --->
		
		FMT01ORI,  		  <!---Orientación: 1=Vertical, 0=Horizontal --->
		
		FMT01LFT, 		  <!---Margen Izquierdo --->
		FMT01TOP,  		  <!--- Margen Superior --->
		FMT01RGT,  		  <!---Margen Derecho --->
		FMT01BOT,         <!---Margen Inferior --->
		s.FMT01SQL as SQL <!--- SQL --->
	 FROM FMT001 a
		inner join FMT000 s
			 on s.FMT00COD=a.FMT01TIP 
	WHERE FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FMT01COD#">
	order by FMT01KEY
</cfquery>
<cfquery name="rsFormatoCol" datasource="#session.dsn#">
	SELECT
		FMT02POS,	<!--- Posicion:  1=Encabezado, 2=Detalle, 3=Total --->
		FMT02FIL AS FMT02_X,	<!--- Posición Horizontal	(equivale a CurrentX) --->
		FMT02COL AS FMT02_Y,	<!--- Posición Vertical	(equivale a CurrentY) --->

		FMT02TIP,	<!--- Tipo de Campo: 1=Etiqueta, 2=Dato --->
		case FMT02TIP
			when 1 then FMT02DES
			else FMT11NOM
		end AS FMT02SQL,	<!--- Campo cuando tipo Dato o Valor cuando Etiquetas --->

		FMT02AJU,	<!--- Ajusta Linea --->
		FMT02FMT,	<!--- Formato --->
		FMT02LON,	<!--- Longitud --->
		FMT02DEC,	<!--- Decimales --->
		FMT02JUS,	<!--- Alineacion:  1=Izquierda, 2=Centrado, 3=Derecha --->

		FMT02TPL,	<!--- Fuente:    Arial, Courier, sans-serif --->
		FMT02TAM,	<!--- Tamaño Letra:  6 - 16 --->
		FMT02CLR,	<!--- Color --->
		FMT02BOL,	<!--- Negrita --->
		FMT02UND,	<!--- Subrayado --->
		FMT02ITA,	<!--- Itálica --->
		FMT02PAG,	<!--- Salto de Página --->
		FMT02PRE, 	<!--- Prefijo --->
		FMT02SUF	<!--- Sufijo --->
	 FROM FMT001 a
		inner join FMT002 b 
			 on b.FMT01COD = a.FMT01COD
			and b.FMT02STS <> 1
	WHERE b.FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FMT01COD#">
	order by FMT02POS, FMT02_Y, FMT02_X
</cfquery>
<cfset LvarCampos	= StructNew()>
<cfloop query="rsFormatoCol">
	<cfif rsFormatoCol.FMT02TIP EQ 2>
		<cfset LvarCampos["#ucase(rsFormatoCol.FMT02SQL)#"] = rsFormatoCol.FMT02FMT>
	</cfif>
</cfloop>
<cfif NOT StructKeyExists(LvarCampos, "#ucase(rsFormatoDoc.FMT01KEY)#")>
	<cfset LvarCampos["#ucase(rsFormatoDoc.FMT01KEY)#"] = "">
</cfif>

<cfset LvarSQL = ReplaceNoCase(rsFormatoDoc.SQL, "##TESid##", "#session.Tesoreria.TESid#", "ALL")>
<cfset LvarSQL = ReplaceNoCase(LvarSQL, "##TESCFLid##", "#url.TESCFLid#", "ALL")>

<cfquery name="rsDatos" datasource="#session.dsn#">
	#preservesinglequotes(LvarSQL)#
</cfquery>

<cfquery name="rsqCheques" dbtype="query">
	select count(distinct #rsFormatoDoc.FMT01KEY#) as cantidad
	 		, min (#rsFormatoDoc.FMT01KEY#) as PrimerCheque
	  from rsDatos
</cfquery>

<cfquery name="rsLote" datasource="#session.dsn#">
	select count(1) as cantidad
	  from TEScontrolFormulariosD cfd
	where cfd.TESid			= #session.Tesoreria.TESid#
	  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
	  and cfd.TESCFDestado	= 0
</cfquery>

<cfif rsqCheques.cantidad NEQ rsLote.cantidad>
	<cf_errorCode	code = "50764"
					msg  = "La cantidad de cheques a imprimir (@errorDat_1@) no coincide con la cantidad de formularios en el Lote (@errorDat_2@). Se debe revisar con PSO el SQL en el Tipo de Formato de Impresión."
					errorDat_1="#rsqCheques.cantidad#"
					errorDat_2="#rsLote.cantidad#"
	>
</cfif>

<cfset LvarColSQL = rsDatos.getColumnnames()>

<!--- 
	Verifica que todos los campos requeridos en el diseño del Formato de Impresión
	estén incluidos en el cfquery SQL
--->
<cfset LvarLinea = "">
<cfset LvarColSQLN = 0>
<cfset LvarColSQLlst = arrayToList(LvarColSQL)>
<cfloop item="LvarFMT" collection=#LvarCampos#>
	<cfif NOT ListFindNoCase(LvarColSQLlst, LvarFMT)>
		<cfset LvarLinea = LvarLinea & "'#ucase(LvarFMT)#', ">
	<cfelse>
		<cfset LvarColSQLN = LvarColSQLN + 1>
	</cfif>
</cfloop>
<cfif LvarLinea NEQ "">
	<cfset LvarLinea = mid(LvarLinea,1,len(LvarLinea) - 2)>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
		alert("ERROR: Los siguientes campos están definidos en el diseño del Formato de Impresión,\npero no se incluyeron en la Consulta SQL:\n\n#LvarLinea#");
		</cfoutput>
	</script>
<cfelse>
	<script language="JavaScript1.2" type="text/javascript">
		<cfquery name="rsIdioma" datasource="#session.dsn#">
			select CBidioma
			  from TEScontrolFormulariosL l
				inner join CuentasBancos c
					on c.CBid = l.CBid
			 where TESCFLid = #TESCFLid#
			 	and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
		</cfquery>
	<cfif rsIdioma.CBidioma NEQ -1>
		// Cambio de Idioma
		var LvarIdioma = null;
		try
		{
			<cfoutput>
			window.parent.document.all.Imprime1.setIdioma(#rsIdioma.CBidioma#);
			</cfoutput>
			LvarIdioma = true;
		}
		catch (e)
		{
			alert("El soinPrintDocs.ocx debe ser actualizado a la última versión porque se está utilizando Ingles");
			alert(e.description);
			LvarIdioma = false;
		}
		if (LvarIdioma)
		{
	</cfif>
		
			// FormatoDoc(	ByVal vFMT01COD As String, ByVal vFMT01DES As String, ByVal vFMT01TIP As String, ByVal vFMT01KEY As String,
			//				ByVal vFMT01TOT As Integer, ByVal vFMT01LIN As Integer, ByVal vFMT01DET As Integer, ByVal vFMT01PDT As Integer, 
			//				ByVal vFMT01SPC As Double, ByVal vFMT01ENT As Boolean, ByVal vFMT01REF As String, 
			//				ByVal vFMT01LAR As Double, ByVal vFMT01ANC As Double, ByVal vFMT01ORI As Integer, 
			//				ByVal vFMT01LFT As Double, ByVal vFMT01TOP As Double, ByVal vFMT01RGT As Double, ByVal vFMT01BOT As Double, 
			//				ByVal vNUMlineas As Integer, ByVal vNUMimagenes As Integer, ByVal vNUMCOLFMT As Integer, 
			//				ByVal vNUMCOLSQL As Integer, ByVal vNUMFILSQL As Integer, 
			//				ByVal vNumCheque As Integer, ByVal vTOTCHEQUES As Integer,
			//				ByVal vHacerCortePag)

		<cfoutput query="rsFormatoDoc">
			window.parent.document.all.Imprime1.FormatoDoc(
							"#FMT01COD#", "#FMT01DES#", "#FMT01TIP#", "#FMT01KEY#", 
							#FMT01TOT#, #FMT01LIN#, #FMT01DET#, #FMT01PDT#, 
							#FMT01SPC#, #FMT01ENT#, "#FMT01REF#", 
							#FMT01LAR#, #FMT01ANC#, #FMT01ORI#, 
							#FMT01LFT#, #FMT01TOP#, #FMT01RGT#, #FMT01BOT#, 
							1,1, #rsFormatoCol.RecordCount#, 
							#LvarColSQLN#, #rsDatos.RecordCount#, 
							#rsqCheques.PrimerCheque#, #rsqCheques.Cantidad#,
							false
						);
		</cfoutput>
			// FormatosCol(	ByVal vFMT02POS As Integer, ByVal vFMT02_X As Double, ByVal vFMT02_Y As Double, 
			//				ByVal vFMT02TIP As Integer, ByVal vFMT02SQL As String, 
			//				ByVal vFMT02AJU As Boolean, ByVal vFMT02FMT As String, ByVal vFMT02LON As Double, ByVal vFMT02DEC As Integer, ByVal vFMT02JUS As Integer, 
			//				ByVal vFMT02TPL As String, ByVal vFMT02TAM As Integer, ByVal vFMT02CLR As String, ByVal vFMT02BOL As Boolean, 
			//				ByVal vFMT02UND As Boolean, ByVal vFMT02ITA As Boolean, ByVal vFMT02PAG As Boolean)
		<cfoutput query="rsFormatoCol">
			<cfif ucase(FMT02SQL) EQ "MONTOENLETRAS">
				<cfset LvarSUFIJO = "***">
				<cfset LvarPREFIJO = "***">
			<cfelseif ucase(FMT02SQL) EQ "TESOPBENEFICIARIO">
				<cfset LvarSUFIJO = "***">
				<cfset LvarPREFIJO = "***">
			<cfelseif ucase(FMT02SQL) EQ "TESOPTOTALPAGO">
				<cfset LvarSUFIJO = "***">
				<cfset LvarPREFIJO = "***">
			<cfelse>
				<cfset LvarSUFIJO = "">
				<cfset LvarPREFIJO = "">
			</cfif>
			window.parent.document.all.Imprime1.FormatosCol(
							#FMT02POS#, #FMT02_X#, #FMT02_Y#, 
							#FMT02TIP#, "#FMT02SQL#", 
							#FMT02AJU#, "#FMT02FMT#", #FMT02LON#, #FMT02DEC#, #FMT02JUS#, 
							"#FMT02TPL#", #FMT02TAM#, "#FMT02CLR#", #FMT02BOL#, 
							#FMT02UND#, #FMT02ITA#, #FMT02PAG#,
							"#FMT02PRE#", "#FMT02SUF#"
						);
		</cfoutput>
			//DatosCol(ParamArray vColumn() As Variant);

		<cfsetting  enablecfoutputonly="yes">
			<cfset LvarLinea = "">
			<cfloop index="i" from="1" to="#arrayLen(LvarColSQL)#">
				<cfif StructKeyExists(LvarCampos, "#ucase(LvarColSQL[i])#")>
					<cfset LvarLinea = LvarLinea & '"#LvarColSQL[i]#", '>
				</cfif>
			</cfloop>
		
			<cfoutput>
			window.parent.document.all.Imprime1.DatosCol(#LvarLinea#"");

			//DatosLin(ParamArray vColumn() As Variant);
			</cfoutput>

			<cfloop query="rsDatos">
				<cfset LvarLinea = "">
				<cfloop index="i" from="1" to="#arrayLen(LvarColSQL)#">
					<!---
						VALORES DE FMT02FMT:
							NumberFormat:	"#", "#0.00", "#0.000", "###", "###,###,###,###,##0.00", "###,###,###,###,##0.0000"
							DateFormat:		"dd/MM/yyyy", "dd/MMM/yyyy", "MMM/dd/yyyy", "MM/dd/yyyy"
							TimeFormat:		"hh:mm:ss", "hh:mm"
					--->				
					<cfif StructKeyExists(LvarCampos, "#ucase(LvarColSQL[i])#")>
						<cfif isdefined("url.especial") AND (ucase(LvarColSQL[i]) EQ "TESOPFECHAPAGO" OR ucase(LvarColSQL[i]) EQ "FECHAENLETRAS")>
							<cfset LvarDato = dateFormat(now(),"YYYY-MM-DD 00:00:00")>
						<cfelse>
							<cfset LvarDato = trim(evaluate("rsDatos." & LvarColSQL[i]))>
						</cfif>
						<cfset LvarLinea = LvarLinea & '"#JSstringFormat(LvarDato)#", '>
					</cfif>
				</cfloop>
				<cfoutput>
				window.parent.document.all.Imprime1.DatosLin(#LvarLinea#"");
				</cfoutput>
			</cfloop>
			<cfoutput>
			window.parent.document.all.Imprime1.DatosFin();
	<cfif rsIdioma.CBidioma NEQ -1>
		}
	</cfif>
			</cfoutput>
		<cfsetting  enablecfoutputonly="no">
	</script>
</cfif>