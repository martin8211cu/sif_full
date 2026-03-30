
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfsetting requesttimeout="36000"><head>
	<title>Importar Asentamientos</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<cfif not isdefined('form.Upload')>
<form action="Asentamientos.cfm" enctype="multipart/form-data" method="post">
	<input type="File" name="archivo" />
	<br />
	<input type="Submit" name="Upload" value="Upload" />
</form>
</cfif>
<cfif isdefined('form.Upload')>
	
	<cffile charset="us-ascii" action="upload"
		destination="#GetTempDirectory()#"
		filefield="archivo"
		nameconflict="MakeUnique">
	
	<cfset uploadedFilename = cffile.serverDirectory & "/" & cffile.serverFile>
	<cfset separador = ";">
	<cfset Ppais = "MX">
	
	<cfscript>
		ios  = CreateObject("java", "java.io.FileInputStream");
		frdr = CreateObject("java", "java.io.FileReader");
		lrdr = CreateObject("java", "java.io.LineNumberReader");
		
		// contar lineas
		frdr.init(uploadedFilename);
		lrdr.init(frdr);
		t1=now();
		while (true) {
			line = lrdr.readLine();
			if (Not IsDefined("line")) {
				break;
			}
		}
		total_lineas = lrdr.getLineNumber();
		total_registros_invalidos = 0;
		total_registros_rechazados = 0;
		total_registros_insertados = 0;
		proceso_ejecutado = false;
	
		frdr.close();
		lrdr.close();
		
		// calcular hash
		ios.init(uploadedFilename);
		MessageDigest = CreateObject("java", "java.security.MessageDigest");
		md = MessageDigest.getInstance("SHA");
		bytearraystr = CreateObject("java", "java.lang.String");
		str = "1234567890123456123456789012345612345678901234561234567890123456123456789012345612345678901234561234567890123456123456789012345612345678901234561234567890123456123456789012345612345678901234561234567890123456123456789012345612345678901234561234567890123456";
		bytearraystr.init(str & str & str & str);
		bytearray = bytearraystr.getBytes();
		while (true) {
			bytes = ios.read(bytearray);
			if (bytes EQ -1) break;
			md.update(bytearray, 0, bytes);
		}
		dbutils = CreateObject("component", "sif/Componentes/DButils");
		ios.close();
		str_hash = LCase( dbutils.toTimeStamp(md.digest()) );
		if (Left(str_hash,2) EQ "0x") {
			str_hash = Mid(str_hash, 3, Len(str_hash) - 2);
		}
		
		// abrir archivos para leer datos
		frdr.init(uploadedFilename);
		lrdr.init(frdr);
		t2=now();
		
		// Validador de fechas
		datevalid = CreateObject("java", "java.text.SimpleDateFormat");
		datevalid.init("yyyyMMdd");
	</cfscript>
	
	<cfflush interval="1">
	
	<cfsetting enablecfoutputonly="yes">
	<cftry>
		<cfloop condition="true">
			<cfset line=lrdr.readLine()>
			<cfset lineNumber = lrdr.getLineNumber()>
			<cfif Not IsDefined("line")>
				<cfbreak>
			</cfif>
			<cfset cols=ListaToArreglo(line, separador)>
			<!--- Raiz--->
			<cfquery datasource="asp" name="rsRaiz">
				select DGid
				from DistribucionGeografica a
					inner join 	NivelGeografico b
						on b.NGid = a.NGid
				where DGcodigo = '#cols[2]#'
				  and a.NGid = #cols[1]#
				  and DGidPadre is null
				  and Ppais = '#Ppais#'
			</cfquery>
			<!--- Padre --->
			<cfquery datasource="asp" name="rsPadre">
				select DGid
				from DistribucionGeografica a
					inner join 	NivelGeografico b
						on b.NGid = a.NGid
				where DGcodigo = '#cols[4]#'
				  and a.NGid = #cols[3]#
				  and DGidPadre = #rsRaiz.DGid#
				  and Ppais = '#Ppais#'
			</cfquery>
			<cfquery datasource="asp" name="rsExiste">
				select count(1) existe
				from DistribucionGeografica a
					inner join 	NivelGeografico b
						on b.NGid = a.NGid
				where DGcodigo = '#cols[6]#'
				  and a.NGid = #cols[5]#
				  and DGidPadre = #rsPadre.DGid#
				  and Ppais = '#Ppais#'
			</cfquery>
			<cfif rsExiste.existe gt 0>
				<cfoutput>
				<div style="background-color:##FFCC66">
				Ya ha sido agregado <strong>#cols[6]# - #cols[7]#</strong> con el padre <strong>#cols[4]#</strong><br>
				</div>
				</cfoutput>
			<cfelse>
				<cfquery datasource="asp">
					insert into DistribucionGeografica(NGid, DGidPadre, DGcodigo, DGDescripcion, BMfecha, BMUsucodigo, DGcodigoPostal)
					values(
						#cols[5]#,
						#rsPadre.DGid#,
						'#cols[6]#',
						'#cols[7]#',
						<cf_dbfunction name="now" datasource="asp">,
						-1,
						'#cols[8]#'
					)
				</cfquery>
				<cfoutput>
				<div style="background-color:##00CC00">
				Se agrega <strong>#cols[6]# - #cols[7]#</strong> con el padre <strong>#cols[4]#</strong><br>
				</div>
				</cfoutput>
			</cfif>
			<cfflush>
		</cfloop>

		<cfset hora_fin = Now()>
		<cfcatch type="any">
			<cfoutput>
			<div style="background-color:##FF0000">
			Error en  <strong>#cols[6]# - #cols[7]#</strong> con el padre <strong>#cols[4]#</strong><br>
			</div>
			</cfoutput>
		</cfcatch>
		
	</cftry>
	<cfflush>
	
	<cfsetting enablecfoutputonly="no">
	<cfscript>
		lrdr.close();
		frdr.close();
	</cfscript>
	<cffunction access="public" name="ListaToArreglo" returntype="array">
		<cfargument name="lista" type="string" required="true">
		<cfargument name="delim" type="string" required="true">
		
		<cfset caracter = "">
		<cfset elemento = "">
	
		<cfset arreglo = ArrayNew(1)>
		<cfloop index="i" from="1" to="#Len(Arguments.lista)#">
			<cfset caracter = Mid(Arguments.lista, i, 1)>
			
			<cfif caracter NEQ Arguments.delim>
				<cfset elemento = elemento & caracter>				
			<cfelse>		
				<cfset ArrayAppend(arreglo, elemento)>				
				<cfset elemento = "">
			</cfif>	
			
		</cfloop>
		<cfif Len(elemento) gt 0 or right(arguments.lista,1) eq arguments.delim>
			<cfset ArrayAppend(arreglo,elemento)>
		</cfif>
		<cfreturn #arreglo#>	
	</cffunction>
</cfif>
</body>
</html>




