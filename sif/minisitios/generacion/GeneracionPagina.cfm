<cfquery datasource="sdc" name="datos">
	select a.MSPplantilla, a.MSCcategoria, a.MSPtitulo, b.MSPtexto, b.MSPareas, b.MSPlargos 
	from MSPagina a, MSPlantilla b
	where a.Scodigo = #Scodigo#
	  and a.MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
	  and b.MSPplantilla = a.MSPplantilla
</cfquery>
<cfif datos.RecordCount EQ 0>
	<cfoutput>La p&aacute;gina (Scodigo = #Scodigo#, MSPcodigo = #MSPcodigo#) no existe.</cfoutput>
	<cf_errorCode	code = "50414"
					msg  = "La página (Scodigo = @errorDat_1@, MSPcodigo = @errorDat_2@) no existe"
					errorDat_1="#Scodigo#"
					errorDat_2="#MSPcodigo#"
	>
<cfelse>
	<cfset arrayLargos = ListToArray(datos.MSPlargos, ",") >
	<cfset MSPtexto = datos.MSPtexto>
	<cfloop condition="ArrayLen(arrayLargos) LT datos.MSPareas">
		<cfset arrayLargos[ArrayLen(arrayLargos) + 1] = 1024>
	</cfloop>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
	
	<html>
	<head>
	<title><cfoutput>#datos.MSPtitulo#</cfoutput></title>
	
	<link type='text/css' rel='stylesheet' href='shared/minisitio.css' >
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	<meta http-equiv="Pragma" content="no-cache">
	</head>
	<body>
	
	<cfquery datasource="sdc" name="rs">
		select a.MSPAarea, b.MSCcontenido, b.MSCcategoria, b.MSCtitulo, b.MSCtexto as myMSCtexto
		from MSPaginaArea a, MSContenido b
		where a.Scodigo = #Scodigo#
		  and a.MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
		  and b.Scodigo =* a.Scodigo
		  and b.MSCcontenido =* a.MSCcontenido
		  and b.MSCexpira > getdate()
	</cfquery>
	<cfset imgposition = "left">
		<cfoutput query="rs">
			<cfif Len(MSCcontenido) GT 0>
				<cfquery datasource="sdc" name="MSIcodigoRS">
					select min(MSIcodigo) as MSIcodigo from MSImagen
					where Scodigo = #Scodigo#
					  and MSCcontenido = #MSCcontenido#
				</cfquery>
				<cfset MSIcodigo = MSIcodigoRS.MSIcodigo>
			<cfelse>
				<cfset MSIcodigo = "">
			</cfif>
			<cfscript>
			MSCtexto = myMSCtexto;
			maxChars = arrayLargos[MSPAarea] * 2;
			muyLargo = Len (MSCtexto) GT maxChars;
			href = "";
			if (muyLargo) href =  "c" & MSCcontenido & ".html";
			src = "AREA-" & MSPAarea & "-";
			dst = "";
			if (Len (rs.MSCtitulo) LE 1) {
				spos = Find(" ", MSCtexto);
				if (spos EQ 0) spos = 20;
				MSCtitulo = Left( MSCtexto, spos );
			}
			if (muyLargo) {
				dst = dst & "<a href='" & href & "' class='titulo-contenido'><b>" & MSCtitulo & "</b></a><br />";
			} else {
				dst = dst & "<span class='titulo-contenido'>" & MSCtitulo & "</span><br />";
			}
			// Tratamiento de las Imagenes
			incidencia = Find ("<@//", MSCtexto); // revisa por si el usuario puso imganenes manualmente >
			if (incidencia EQ 0) {      // El usuario no puso imagenes
				if (Len(MSIcodigo) NEQ 0) {
					dst = dst & "<img class='imagen-contenido' ";
					if (datos.MSPareas NEQ 1) {
						dst = dst & " height='100px' ";
					}
					dst = dst & " src='/jsp/DownloadServlet/MiniSitios/MSIimagen?MSIcodigo=" & MSIcodigo 
						& "' align='" & imgposition & "' >";
					if (imgposition EQ "left") {
						imgposition = "right";
					} else {
						imgposition = "left";
					}
				}
			} else {
				// El usuario puso imagenes en el contenido
				resultado = "";
				imagen = "";
				found = Find ("<@//", MSCtexto); // >
				found2 = 0; 
				//WriteOutput("1. found:" & found & "<br>");
				while (found NEQ 0) {
					if (found2 + 1 LT found) {
						resultado = resultado & Mid (MSCtexto, found2+1, found-found2+1);
					}
					found2 = Find ("//@>", MSCtexto, found);
					//WriteOutput("2. found2:" & found2 & ", resultado: {" & resultado & "}<br>");
					if (found2 EQ 0) break;
					imagen = Mid(MSCtexto, found+4, found2 - found - 4);
					//WriteOutput("imagen:"&imagen&"<br>");
					
					imagenparams = ListToArray(imagen, "//");
					//WriteOutput("imagenparams:"&ArrayToList(imagenparams)&"<br>");
					
					imgtag = "<img class='imagen-contenido' src='/jsp/DownloadServlet/MiniSitios/MSIimagen?MSIcodigo=" ;
					imgtag = imgtag & imagenparams[1] & "' " & "height='" & imagenparams[3] & "px' ";
					
					if (imagenparams[2] EQ "L") {
						imgtag = imgtag & "align='left'>";
					} else {
						imgtag = imgtag & "align='right'>";
					}
					
					resultado = resultado & imgtag;
					found2 = found2 + 3;
					found = Find ("<@//", MSCtexto, found2 + 1); // >
					//WriteOutput("3. found:" & found & ", found2:" & found2 & ", resultado: {" & resultado & "}<br>");
				}
				if (found2+1 LT Len(MSCtexto)) {
					resultado = resultado & Mid(MSCtexto, found2+1, Len(MSCtexto));
				}
				MSCtexto = resultado;
			}
			
			if (datos.MSPplantilla NEQ "1x1" ){
				if (Len(MSCtexto) GT 1) {
					dst = dst & "<span class='texto-contenido'>" & Left(MSCtexto, maxChars) & "</span>";
				}
				if (muyLargo) {
					dst = dst & " <a class='titulo-contenido' href='" & href & "'>...</a></span>";
				}
			} else {  // Una sola area despliega el texto completo
				dst = dst & "<span class='texto-contenido'>" & MSCtexto & "</span>";
			}
			MSPtexto = Replace(MSPtexto, src, dst, "all");
			</cfscript>
		</cfoutput>
		<cfoutput>#MSPtexto#</cfoutput>
	
	  <table width='100%'>
		<tr>
			<td colspan='3'><hr width='70%'></td>
		</tr>        
		<tr>
			<td colspan='3' align='center' valign='middle'>
			  <span style='font: smaller'>Este sitio fue generado con herramientas del Portal www.migestion.net</span>
			</td>
		</tr>
		<tr>
			<td colspan='3' align='center' valign='middle'>
			  <span style='font: smaller'>Todos los derechos reservados &copy; 2002</span>
			</td>
		</tr>
	</table>
	
	</body>
	</html>
</cfif>


