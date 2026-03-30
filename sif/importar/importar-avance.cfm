
<cfsetting requesttimeout="36000">
<cfset LvarInicio = now()>
<cfset session.Importador.Tipo = "C">
<cfset session.Importador.SubTipo = "1">
<cfset session.Importador.Avance = 0>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<!---
	Realiza la importación, y muestra su avance
	Parámetros:
		form.fmt	( requerido ) Número de formato, EImportador.EIid
		form.archivo( requerido ) Archivo por importar (input type="file")
--->
<head>
<title><cf_translate key="ImportacionEnProceso">Importaci&oacute;n en progreso</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body style="margin:0">

<cffile charset="us-ascii" action="upload"
	destination="#GetTempDirectory()#"
	filefield="archivo"
	nameconflict="MakeUnique">
<cfset uploadedFilename=#cffile.serverDirectory# & "/" & #cffile.serverFile#>

<cfparam name="form.fmt" type="numeric" default="0">
<cfif not isnumeric(form.fmt)>
	<cfthrow message="El valor de EIid: #form.fmt# no es numérico, proceso cancelado!">
</cfif>
<cfquery datasource="sifcontrol" name="formatos">
	select * from EImportador
	where ( Ecodigo is null
	   or Ecodigo = #Session.Ecodigo# )
	  and EIid = #form.fmt#
</cfquery>
<cfif formatos.RecordCount EQ 1>
	<cfset EIid = formatos.EIid>
<cfelse>
	<h1>404 - Not Found</h1><hr><cf_translate key="ElFormato">El formato</cf_translate> <cfoutput>#form.fmt#</cfoutput> <cf_translate key="NoExiste">no existe</cf_translate>.
	<cfabort>
</cfif>

<cfparam name="session.Ecodigo" type="numeric" default="1">

<cfquery datasource="sifcontrol" name="enc">
	select a.* , b.EIsql
	from EImportador a
		left join EISQL b
			on a.EIid = b.EIid
	where a.EIid = #EIid#
</cfquery>

<cfif enc.RecordCount NEQ 1>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoExisteElFormatoDeImportacionNo"
		Default="No existe el formato de importación No"
		returnvariable="MSG_NoExisteElFormatoDeImportacionNo"/>
	<cf_errorCode	code = "50381"
					msg  = "@errorDat_1@. @errorDat_2@"
					errorDat_1="#MSG_NoExisteElFormatoDeImportacionNo#"
					errorDat_2="#EIid#"
	>
</cfif>

<cfif enc.EIdelimitador EQ "C">
	<cfset separador = ",">
<cfelseif enc.EIdelimitador EQ "T">
	<cfset separador = chr(9)>
<cfelseif enc.EIdelimitador EQ "P">
	<cfset separador = "|">
<cfelseif enc.EIdelimitador EQ "X">
	<cfset separador = ";">
<cfelseif enc.EIdelimitador EQ "L">
	<cfset separador = chr(255)>
<cfelse>
	<cfset separador = chr(9)>
</cfif>

<cfquery datasource="sifcontrol" name="TipoReg">
	select DISTINCT(DItiporeg) as DItiporeg from DImportador
	where EIid = #EIid#
	order by DItiporeg
</cfquery>

<!---
<cfdump var="#enc#">
<cfdump var="#det#">
--->
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

	frdr.close();lrdr.close();

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
<!---
<cfoutput>con #total_lineas# lineas<br></cfoutput>
<cfoutput>Tiempo examinado archivos: #DateDiff("s" , t1, t2) # segundos <br></cfoutput>
--->
<script type="text/javascript">
total  = <cfoutput>#total_lineas#</cfoutput>;
function el9(elid){
	return document.all?document.all[elid]:document.getElementById(elid);
}
function jp8(n) {
	var percent = 0;

	percent = Math.floor(n * 100 / total);
	el9('pct2').style.width = " " + percent + "%";
	el9('percent').innerHTML = percent + " % (" + n + " / " + total + ")";
}
function jp9(p) {
	var percent = Math.floor(p);
	var n = Math.floor(p * total / 100);
	el9('pct2').style.width = " " + percent + "%";
	el9('percent').innerHTML = percent + " % (" + n + " / " + total + ")";
}
</script>
<cfset table_name = "tm" & (DateDiff("s", CreateDateTime(1970,1,1,0,0,0), Now()) mod 111111)>
<!---
<cfif enc.EIusatemp EQ 1>
	<cfset table_name = "##" & table_name>
</cfif>
--->
<!---
<cfoutput>table_name: # table_name #<br></cfoutput>
--->

<!--- Validar si el archivo ya había sido importado --->

<cfif enc.EIverificaant NEQ 0>
	<cfquery datasource="sifcontrol" name="duplicado">
		select *
		from IBitacora
		where EIid = #EIid#
		  and IBcompletada = 1
		<cfif enc.EIverificaant EQ 1 OR enc.EIverificaant EQ 3>
		  and IBnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.clientFile#">
		</cfif>
		<cfif enc.EIverificaant EQ 2 OR enc.EIverificaant EQ 3>
		  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#str_hash#">
		</cfif>
	</cfquery>
	<cfif duplicado.RecordCount NEQ 0>
		<cfdump var="#duplicado#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EsteArchivoYaHabiaSidoImportado2"
			Default="Este archivo ya hab&iacute;a sido importado"
			returnvariable="MSG_EsteArchivoYaHabiaSidoImportado2"/>
		<cfthrow message="#MSG_EsteArchivoYaHabiaSidoImportado2#">
	</cfif>
</cfif>

<!---<cftransaction action="begin">--->

<!---
<cfquery datasource="#session.dsn#">
	if object_id('#table_name#') is not null drop table #table_name#
</cfquery>
--->




<cftransaction>
	<!--- identity --->
	<cfquery datasource="sifcontrol" name="insert_bitacora">
		insert into IBitacora (
			EIid, Ecodigo,
			IBmod_login, IBmod_usucodigo, IBmod_ulocalizacion,
			IBregistros, IBinvalidos, IBrechazados,
			IBnombre, IBhash, IBfechaini)
		values (
			#EIid#,
			#session.Ecodigo#,

			'#session.usuario#',
			#session.usucodigo#,
			'#session.ulocalizacion#',

			-1, -1, -1,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(cffile.clientFile,1,60)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_hash#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		<cf_dbidentity1 datasource="sifcontrol">
	</cfquery>
	<cf_dbidentity2 datasource="sifcontrol" name="insert_bitacora">
</cftransaction>

<table border="0">
	<tr>
		<td>
			<cf_translate key="LB_Importando">Importando</cf_translate> <cfoutput>#cffile.clientFile#
			(# NumberFormat(cffile.fileSize)# bytes)
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<span id="oper"><cf_translate key="LB_Cargando">Cargando</cf_translate>:</span>
		</td>
	</tr>
	<tr>
		<td>
			<span id="paso"><cf_translate key="LB_Inicializando">Inicializando</cf_translate></span>... <span id="percent">0</span>
		</td>
	</tr>
	<tr>
		<td>
			<span id=pct1 style="border:1px solid black;width:250px;">
				<span id=pct2 style="background-color:#66ccff;width:0%;"></span>
			</span>
		</td>
	</tr>
	<tr>
		<td align="center">
			<form name="formcancelar" id="formcancelar" style="margin:0" action="/cfmx/sif/importar/importar-cancela.cfm" target="cancelando" onSubmit="cancelar.disabled=true" method="post">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_CancelarProceso"
					Default="Cancelar Proceso"
					XmlFile="/sif/generales.xml"
					returnvariable="BTN_CancelarProceso"/>
				<input type="submit" value="<cfoutput>#BTN_CancelarProceso#</cfoutput>" name="cancelar">
				<input type="hidden" name="hash" value="<cfoutput>#str_hash#</cfoutput>">
				<input type="hidden" name="IBid" value="<cfoutput>#insert_bitacora.identity#</cfoutput>">
				<iframe src="" name="cancelando" width="1" height="1" frameborder="0"></iframe>
			</form>
		</td>
	</tr>
</table>
<iframe name="ifrImportarAvance"
	width ="0"
	height="0"
	frameborder="0"
	src="/cfmx/sif/importar/importar-refresh.cfm">
</iframe>
<!--- necesario para realizar el cfflush --->
<!--
<cfoutput>#repeatString("*",7000)#</cfoutput>
-->
<cfflush interval="1">

<!--- Intenta hacer la función de ListToArray de ColdFusion
	Cuando la lista vienen elmentos vacíos esta función los toma en cuenta
 --->
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

<cfsetting enablecfoutputonly="yes">
	<!---
		la creacion de la tabla va afuera del cftry para que si falla el error sea fatal
	--->
<!--- Crea todas las tablas necesarias definidas por el campo DItiporeg  INICIA --->
<!--- *************** Crea una estructura para los nombres Físicos de las tablas Temporales ************--->
<cfset strTable_nameC = structNew()>
<!--- **************************************************************************************************--->
<cfloop query="TipoReg">
 	<cfset table_nameC = #table_name#>
 	<cfif Trim(TipoReg.DItiporeg) neq "-">
    	<cfset table_nameC = #table_name# & TipoReg.DItiporeg>
    </cfif>

    <cfquery datasource="sifcontrol" name="det">
        select * from DImportador
        where EIid = #EIid#
        <cfif Trim(TipoReg.DItiporeg) eq "-">
            and (DItiporeg = '#TipoReg.DItiporeg#' and DInumero > 0)
        <cfelse>
            and (DItiporeg = '#TipoReg.DItiporeg#' and DInumero > 1) <!---Por que el primer registro del detalle es el tipo de registro--->
        </cfif>
        order by DInumero
    </cfquery>

<!---<cfdump var="#det#">  --->

	<cf_dbtemp name="#table_nameC#" returnvariable="table_nameC" datasource="#session.dsn#" temp="# enc.EIusatemp EQ 1 #">

		<cf_dbtempcol name="id" type="numeric" identity="yes">
		<cfoutput query="det">
			<cfset tipo = det.DItipo>
			<cfif (det.DIlongitud GT 0) AND
				(det.DItipo EQ "varchar" OR
				 det.DItipo EQ "numeric")>
				 <cfset tipo = tipo & '(' & det.DIlongitud & ')'>
			</cfif>
			<cf_dbtempcol name="#det.DInombre#" type="#tipo#">
		</cfoutput>
		<cf_dbtempkey cols="id">
	</cf_dbtemp>
	<!--- *************** Guarda en la estructura el nombre Fisico ************--->
	<cfset strTable_nameC[#trim(TipoReg.DItiporeg)#] = table_nameC>
	<!--- *********************************************************************--->
 </cfloop>
<!--- Crea todas las tablas necesarias definidas por el campo DItiporeg  TERMINA --->

<cftry>
        <cfset hora_inicio = Now()>
        <cfset los_insert="">
        <cfset continuar_proceso = True>
        <cfset lineNumber = 0>
        <cfset session.Importador.SubTipo = "2">
        <cfset DItipoIni  = ""> <!---Para que no busque siempre--->
        <cfloop condition="true">
            <cfset session.Importador.Avance = (lineNumber / total_lineas)>
            <cfset line=lrdr.readLine()>
            <cfset lineNumber = lrdr.getLineNumber()>
            <cfif Not IsDefined("line")><cfbreak></cfif>
            <cfif trim(line) NEQ "">
				<cfset cols=ListaToArreglo(line, separador)>
                <!---<cfset cols=ListToArray(line, separador)>--->
                <!--- validaciones sobre el registro --->
                <cfset registro_ok = True>
                <cfset tipo_error = 0>
                <cfset columna_error = 0>

                <!--- Para el archivo multitablas, la primera columna trae el nombre del tipo de archivo  --->
                <cfif TipoReg.RecordCount gt 1> <!---Tiene mas de un tipo de registro, "-" Default--->
                    <cfset DItiporeg  = trim(cols[ 1 ])>
                <cfelse>
                    <cfset DItiporeg  = "-">
                </cfif>

                <cfif DItipoIni neq DItiporeg>  <!---Cuando es diferente traigo la definición el detalle--->
                    <cfset DItipoIni  = DItiporeg>
                    <cfquery datasource="sifcontrol" name="det">
                        select * from DImportador
                        where EIid = #EIid#
                        <cfif DItiporeg eq "-">
                            and DItiporeg ='#DItiporeg#' and DInumero > 0
                        <cfelse>
                            and DItiporeg ='#DItiporeg#' and DInumero > 1
                        </cfif>
                        order by DInumero
                    </cfquery>
                    <cfquery datasource="sifcontrol" name="los_params">
                        select * from DImportador
                        where EIid = #EIid#
                        and DItiporeg = '#DItiporeg#'
                          and DInumero < 0
                        order by DInumero desc
                    </cfquery>
                </cfif>

                <cfset Columnas = ArrayLen(cols)>
                <cfif DItiporeg neq "-">
                    <cfset Columnas = ArrayLen(cols)-1> <!---Por que la primera columna es el tipo de registro--->
                </cfif>
                <cfif Columnas NEQ det.RecordCount>
                    <!--- Cantidad invalida de columnas --->
                    <cfset registro_ok = False>
                    <cfif Columnas LT det.RecordCount>
                        <cfset tipo_error = 5>
                    <cfelse>
                        <cfset tipo_error = 1>
                    </cfif>
                    <cfset columna_error = 0>
                </cfif>
                <!--- Quitarle los espacios a cada dato --->
                <cfloop from="1" to="#ArrayLen(cols)#" index="cols_index">
                    <cfset cols[cols_index] = Trim(cols[cols_index])>
                </cfloop>
                <cfif registro_ok>
                    <!--- validar el registro --->
                    <cfloop query="det">
                        <cfset CurrentRow = det.CurrentRow>
                        <cfif det.DItiporeg neq "-">
                            <cfset CurrentRow = det.CurrentRow+1> <!---Por que cols[1] trae el Tipo de registro--->
                        </cfif>
                        <!--- ('varchar','numeric','float','money') --->
                        <cfif Len(cols[CurrentRow]) Is 0>
                            <!--- aceptar los nulos que vengan --->
                        <cfelseif det.Ditipo EQ "datetime">
                            <cfif REFind("^\d{8}$", cols [CurrentRow]) EQ 0>
                                <cfset registro_ok = false>
                                <cfset tipo_error = 2>
                                <cfset columna_error = CurrentRow>
                                <cfbreak>
                            <cfelse>
                                <cftry>
                                    <cfif datevalid.format(datevalid.parse(cols[CurrentRow])) NEQ cols[CurrentRow]>
                                        <cfset registro_ok = false>
                                        <cfset tipo_error = 2>
                                        <cfset columna_error = CurrentRow>
                                    </cfif>
                                <cfcatch type="any">
                                    <cfset registro_ok = false>
                                    <cfset tipo_error = 2>
                                    <cfset columna_error = CurrentRow>
                                </cfcatch>
                                </cftry>
                            </cfif>
                        <cfelseif det.DItipo EQ "int">
                            <cfif not IsNumeric(cols[CurrentRow]) OR Ceiling(cols[CurrentRow]) NEQ cols[CurrentRow]>
                                <cfset registro_ok = false>
                                <cfset tipo_error = 3>
                                <cfset columna_error = CurrentRow>
                                <cfbreak>
                            </cfif>
                        <cfelseif det.DItipo EQ "numeric" OR det.DItipo EQ "float" OR det.DItipo EQ "money">
                            <cfif not IsNumeric(cols[CurrentRow])>
                                <cfset registro_ok = false>
                                <cfset tipo_error = 4>
                                <cfset columna_error = CurrentRow>
                                <cfbreak>
                            </cfif>
                        </cfif>
                    </cfloop>
                </cfif>
                <cfif registro_ok>
                    <cfset total_registros_insertados = total_registros_insertados + 1>
                    <!--- insertar el registro en la tabla temporal --->
                    <cfsavecontent variable="un_insert">
                        <!--- *************** Obtiene de la estructura el nombre Fisico ************--->
                        <cfset table_nameC = strTable_nameC[trim(DItiporeg)]>
                        <!--- *********************************************************************--->
                        <cfoutput>
                        insert into #table_nameC# (#ValueList(det.DInombre)#) values (</cfoutput>
                        <cfoutput query="det">
                            <cfset MiFila = det.CurrentRow>
                            <cfif trim(DItiporeg) neq "-">
                                <cfset MiFila = det.CurrentRow + 1> <!---Por que cols[1] trae el Tipo de registro--->
                            </cfif>
                            <cfif #MiFila# gt 1 and trim(DItiporeg) eq "-">,</cfif>
                            <cfif #MiFila# gt 2 and trim(DItiporeg) neq "-">,</cfif>
                            <cfif Len(cols[MiFila]) Is 0>
                                null
                            <cfelseif det.Ditipo EQ "varchar">
                                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Left(cols [ MiFila ], det.DIlongitud)#" len="#det.DIlongitud#">
                            <cfelseif det.Ditipo EQ "datetime">
                                #CreateDate( mid(cols [ MiFila ], 1, 4),
                                             mid(cols [ MiFila ], 5, 2),
                                             mid(cols [ MiFila ], 7, 2))#
                            <cfelse>
                                 # cols [ MiFila ] #
                            </cfif>
                        </cfoutput><cfoutput>)</cfoutput>
                    </cfsavecontent>
                    <cfset los_insert = los_insert & " " & un_insert >
                    <cfif Len (los_insert) GT enc.EItambuffer >
                        <cfquery datasource="#session.dsn#">
                            #PreserveSingleQuotes (los_insert)#
                        </cfquery>
                        <cfset los_insert="">
                    </cfif>
                <cfelse>
                    <cfset total_registros_invalidos = total_registros_invalidos + 1>
                    <!--- Insertar el registro de error --->
                  <cftry>
					<cfquery datasource="sifcontrol">
                        insert into IErrores (IBid, IEid, IBdatos, IBlinea, IBerror, IBcolumna)
                        values (#insert_bitacora.identity#,
                                #total_registros_invalidos#,
                               <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#line#" len="255">,
                                #lineNumber#,
                                #tipo_error#,
                                #columna_error#
                            )
                    </cfquery>
						<cfcatch>
						   <cfthrow message="El Formato del Archivo es Invalido">
						</cfcatch>
				  </cftry>
                </cfif>
                <!--- actualizar el contador en el cliente html (cada 179 lineas) --->
                <cfif (lineNumber mod 179 EQ 0) or (lineNumber EQ total_lineas)>
                    <cfoutput>
                        <!-- Flush:
                            #repeatString("*",1024)#
                        -->
                        <script type="text/javascript">
                            jp8(#lineNumber#);
                        </script>
                    </cfoutput>
                    <!--- veamos si hay que cancelar el proceso --->
                    <cfquery datasource="sifcontrol" name="cancelar">
                        select IBcancelada from IBitacora
                        where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_bitacora.identity#">
                    </cfquery>
                    <cfif cancelar.IBcancelada EQ 1>
                        <cfoutput><table border="0"><tr><td>
                            <cf_translate key="LB_OperacionCanceladaPorElUsuario">Operaci&oacute;n cancelada por el usuario</cf_translate>.</td></tr></table></cfoutput>
                        <cfset continuar_proceso = false>
                        <cfbreak>
                    </cfif>
                    <cfflush>
                </cfif>
            </cfif>
        </cfloop>

        <cfif Len(los_insert) GT 2>
            <cfquery datasource="#session.dsn#">#PreserveSingleQuotes (los_insert)#</cfquery>
        </cfif>
        <cfoutput>
            <!-- Flush:
                #repeatString("*",7000)#
            -->
            <script type="text/javascript">
                jp9(100);
            </script>
        </cfoutput>
        <cfflush>

        <cfset session.Importador.SubTipo = "3">

        <cfset los_insert="">

        <cfset hora_fin = Now()>
        <cfoutput>
        <script>formcancelar.cancelar.disabled=true;</script></cfoutput>

        <cfif continuar_proceso AND ( total_registros_invalidos GT 0 ) AND ( enc.EIparcial NEQ 1 ) >
            <cfset continuar_proceso = False>
        </cfif>



        <cfif continuar_proceso>
            <cfset session.Importador.Tipo = "P">
            <cfset session.Importador.SubTipo = "1">

            <cfset proceso_ejecutado = True>
            <cfif Len(Trim(enc.EIcfimporta))>
                <cfset es_parcial = total_registros_invalidos GT 0 AND enc.EIparcial EQ 1>

<!---<cfdump var  = "#table_name#">
<cf_dump var  = "#table_nameC#">
--->
				<cfif enc.EIusatemp EQ 1>
                    <cfloop query="TipoReg">
                        <cfset table_name = strTable_nameC[trim(DItiporeg)]>
                    </cfloop>
                </cfif>
<!---<cf_dump var  = "#table_name#">
--->
                <cfinclude template="#enc.EIcfimporta#">
            <cfelseif Len(Trim(enc.EIsql))>
                <!--- indicador de si es parcial --->
                <cfset param_values = StructNew()>
                <cfset param_values.es_parcial = IIf(total_registros_invalidos GT 0 AND enc.EIparcial EQ 1, 1, 0) >
                <cfset QueryAddRow(los_params, 1)>
                <cfset QuerySetCell(los_params, 'DInombre', 'es_parcial')>
                <cfset QuerySetCell(los_params, 'DItipo', 'int')>
<!---                Substitución de las tablas en el query INICIA  --->
                <cfloop query="TipoReg">
                    <cfinvoke component="sustituir" method="sustituir" returnvariable="sql_string"
                        sql_string = "#enc.EIsql#" param_values="#param_values#" param_info="#los_params#">
                    <cfset table_name = strTable_nameC[trim(DItiporeg)]>
    				<cfset sql_string = Replace (sql_string, "##table_name##", table_name, "all")>
				</cfloop>
<!---                Substitución de las tablas en el query TERMINA  --->

                <cfquery datasource="#session.dsn#" name="err">
                    # PreserveSingleQuotes( sql_string ) #
                    /* */
                </cfquery>
            <cfelse>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="MSG_NoSeHaEspecificadoNiSQLNiColdfusionParaEjecutarEnLaImportacion"
                    Default="No se ha especificado ni SQL ni coldfusion para ejecutar en la importación"
                    returnvariable="MSG_NoSeHaEspecificadoNiSQLNiColdfusionParaEjecutarEnLaImportacion"/>
                <cfthrow message="MSG_NoSeHaEspecificadoNiSQLNiColdfusionParaEjecutarEnLaImportacion">
            </cfif>
            <cfif IsDefined("err.RecordCount") AND err.RecordCount GE 1>
                <cfset total_registros_rechazados = err.RecordCount>
                <cfset err_dump="">
                <cfsavecontent variable="err_dump">
                    <!--- una mini exportación a HTML --->
                    <cfset metaData = err.getMetaData()>
                    <cfset columnCount = metaData.getColumnCount()>
                    <cfset columns = metaData.getColumnLabels()>
                    <cfoutput><table border="0" cellspacing="2" cellpadding="2">
                    <tr></cfoutput><cfloop from="1" to="#columnCount#" index="i">
                        <cfoutput><td valign="top" bgcolor="##EEEEEE"><b>#columns[i]#</b></td></cfoutput>
                    </cfloop><cfoutput></tr></cfoutput>
                    <cfoutput query="err">
                    <tr><cfloop from="1" to="#columnCount#" index="i">
                        <td valign="top" bgcolor="##CCCCCC">
                        <cfset typeName = metaData.getColumnTypeName(JavaCast("int",i))>
                        <cfset value = Evaluate("err." & columns[i])><cfif
                            Len(value) EQ 0>&nbsp;<cfelseif
                            FindNoCase("date",typeName)>#LSDateFormat(ParseDateTime(value),"YYYYMMDD")#<cfelseif
                            IsBinary(value)>#dbutils.toTimestamp(value)#<cfelse
                            >#value#</cfif></td></cfloop>
                    </tr></cfoutput>
                    <cfoutput></table></cfoutput>
                </cfsavecontent>
                <cffile action="write" nameconflict="overwrite"  output="#err_dump#"
                    file="#GetTempDirectory()#/imp-err-#insert_bitacora.identity#.html">
                <cfif abs(datediff("n",LvarInicio,now())) GT 50>
                    <cffile action="write" nameconflict="overwrite"  output="#err_dump#"
                            file="#expandPath("/sif/importar")#/imp-err-#insert_bitacora.identity#.html"
                    >
                    <cfset session.Importador.location_replace = "#GetTempDirectory()#/imp-err-#insert_bitacora.identity#.html">
                    <cfset session.Importador.SubTipo = "-3">
                </cfif>

            </cfif>
        </cfif>
        <cfset session.Importador.SubTipo = "4">
    <cfcatch type="any">
        <cfset ErrorMsg = cfcatch.Detail>
        <cfoutput>
            <font color="##FF0000">
            <cf_translate key="LB_ErrorEnLaImportacion">Error en importaci&oacute;n</cf_translate>:</font>
            #cfcatch.Detail# #cfcatch.Message#
        </cfoutput>

        <cfinclude template="/home/public/error/log_cfcatch.cfm">
        <cfparam name="url.ErrorId" default="-1">
        <cfset session.Importador.ErrorId = url.ErrorId>
        <cfset session.Importador.SubTipo = "-1">
    </cfcatch>
</cftry>

	<cfoutput>
        <!-- Flush:
            #repeatString("*",7000)#
        -->
    </cfoutput>
    <cfflush>

    <cfsetting enablecfoutputonly="no">
    <cfscript>
        lrdr.close();
        frdr.close();
    </cfscript>

<!---    <cfquery datasource="#session.dsn#" name="tmp">
    select count(1) as cnt
    from #table_name#
    </cfquery>
<cfquery datasource="#session.dsn#">drop table #table_name#</cfquery>
<script type="text/javascript">alert("table_name: #table_name#");</script>--->

<cfquery datasource="sifcontrol">
	update IBitacora
	set IBregistros = <cfqueryparam cfsqltype="cf_sql_integer" value="#total_lineas#">,
		IBinvalidos = <cfqueryparam cfsqltype="cf_sql_integer" value="#total_registros_invalidos#">,
		IBrechazados = <cfqueryparam cfsqltype="cf_sql_integer" value="#total_registros_rechazados#">,
		<cfif IsDefined("lineNumber")>
		IBinsertados = <cfqueryparam cfsqltype="cf_sql_integer" value="#total_registros_insertados#">,
		</cfif>

		<cfif continuar_proceso>IBcompletada = 1,</cfif>
		<cfif proceso_ejecutado>IBejecutado = 1,</cfif>
		IBfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_bitacora.identity#">
</cfquery>

<!---<cftransaction action="commit">--->

<!--- Mostrar el status --->
<cfoutput>
	<cfif NOT IsDefined("ErrorMsg")>
		<cfparam name="session.Importador.location_replace" default="">
		<cfif session.Importador.location_replace EQ "">
			<cfset session.Importador.location_replace = "importar-status.cfm?id=#insert_bitacora.identity#&hash=#str_hash#">
			<cfset session.Importador.SubTipo = "5">
		</cfif>
		<script type="text/javascript">
			location.replace ( "importar-status.cfm?id=#insert_bitacora.identity#&hash=#str_hash#" );
		</script>
	</cfif>
	<table border="0"><tr><td>
	<cf_translate key="ProcesoCompletadoHagaClickParaContinuar">Proceso completado.  Haga
	<a href="/cfmx/sif/importar/importar-status.cfm?id=#insert_bitacora.identity#&hash=#str_hash#">
	click</a> para continuar</cf_translate>.
	</td></tr></table>
</cfoutput>
</body>
</html>


