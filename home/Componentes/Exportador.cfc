<!---►►►►Formateo de datos◄◄◄◄◄--->
<cfscript>
	function soloFormato(value, tipo) {
		if ( IsBinary( value )) {
			return dbutils.toTimestamp( value );
		} else if (Len(value) EQ 0) {
			return "";
		} else if ( tipo EQ "datetime" ) {
			if ( IsDate( value ) ) {
				return LSDateFormat(value, "YYYYMMDD");
			} else {
				return "";
			}
		} else {
			return value;
		}
	}
	function formatearDato(value, tipo, longitud) {
		var s = "";
		if (enc.EIdelimitador NEQ "L") {
			return soloFormato(value, tipo);
		} else if (longitud EQ 0) {
			return "";
		}
		s = soloFormato(value, tipo);
		if (Len (s) GT longitud) {
			return Left( s , longitud );
		} else if (Len(s) LT longitud) {
			return Left( s , longitud );
		} else {
			return s;
		}
	}
</cfscript>
<!---►►►►►Metodo para exportar Archivos, con una definicion de exportador-INVOCACION REMOTA◄◄◄◄◄--->
<cffunction name="exportarRemote" output="yes" access="remote" hint="Metodo para exportar Archivos, con una definicion de exportador-INVOCACION REMOTA">
	<cfargument name="fmt" 		 type="numeric" required="yes">
	<cfargument name="html" 	 type="boolean" default="no">
	<cfargument name="encabezar" type="boolean" default="no">
    <cfargument name="Descargar" type="boolean" default="no">
    <CFSET exportar(Arguments.fmt,Arguments,Arguments.html,Arguments.encabezar,Arguments.Descargar)>
</cffunction>
<!---►►►►►Metodo para exportar Archivos, con una definicion de exportador◄◄◄◄◄--->
<cffunction name="exportar" output="yes" access="public" hint="Metodo para exportar Archivos, con una definicion de exportador">
	<cfargument name="fmt" 		 type="numeric" required="yes">
    <cfargument name="parms" 	 type="struct"  required="yes">
	<cfargument name="html" 	 type="boolean" default="no">
	<cfargument name="encabezar" type="boolean" default="no">
    <cfargument name="Descargar" type="boolean" default="no">

	<cfparam name="session.Ecodigo" type="numeric" default="1">
	<cfquery datasource="sifcontrol" name="enc">
		select a.*, b.EIsqlexp
		from EImportador a
			left join EISQL b
				on a.EIid = b.EIid
		where a.EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fmt#">
	</cfquery>
	
	<cfif enc.RecordCount EQ 1>
		<cfset EIid = enc.EIid>
	<cfelse>
		<cfoutput><h1>404 - Not Found</h1><hr>El formato #Arguments.fmt# no existe.</cfoutput>
		<cfreturn>
	</cfif>
	
	<cfquery datasource="sifcontrol" name="det">
		select * from DImportador
		where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EIid#">
		  and DInumero > 0
		order by DInumero
	</cfquery>
	
	<cfquery datasource="sifcontrol" name="los_params">
		select * from DImportador
		where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EIid#">
		  and DInumero < 0
		order by DInumero desc
	</cfquery>
	<cfset sql_string = sustituir(enc.EIsqlexp,Arguments.parms,los_params)>
	
	<cfif enc.EIdelimitador EQ "C">
		<cfset separador = ",">
	<cfelseif enc.EIdelimitador EQ "T">
		<cfset separador = chr(9)>
	<cfelseif enc.EIdelimitador EQ "L">
		<cfset separador = "">
	<cfelse>
		<cfset separador = chr(9)>
	</cfif>
	<cfset enter = chr(13) & chr(10)>
	
	<cfscript>
		dbutils = CreateObject("component", "sif/Componentes/DButils");
	</cfscript>
	
	<!---►►►►►El tipo debe ser varchar,numeric,int,float,money,datetime o algun otro válido para cfsqltype="cf_sql_..."◄◄◄◄◄--->
	<cfif len(trim(enc.EIcfexporta)) GT 0>
		<!---►►►►►Este archivo debe contener los resultados en un query que se llame err◄◄◄◄◄--->
		<cfinclude template="#enc.EIcfexporta#">
	<cfelse>
		<cfquery datasource="#session.dsn#" name="err">
			# PreserveSingleQuotes( sql_string ) # 
		</cfquery>
	</cfif>

	<cfif Not IsDefined("err.RecordCount")>
		<!----================= TRADUCCION ==================--->
		<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_No_hay_resultados"
			Key="MSG_No_hay_resultados" Default="No hay resultados"	XmlFile="/sif/generales.xml"/>
		<cfthrow message="#MSG_No_hay_resultados#">
		<cfreturn>
	</cfif>
	<cfset metaData = err.getMetaData()>
	<cfset columnCount = metaData.getColumnCount()>
	<cfif html>
			<cfflush interval="1024">
			<cfset temporaryFileName = "">
			<!--- una mini exportación a HTML --->
			<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			<html><head>
			<title><cf_translate key="LB_Exportacion" XmlFile="/sif/generales.xml">Exportación</cf_translate></title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<cf_templatecss>
			</head>
			<body style="margin:0">
			<style>
			td { background-color:##ccc; vertical-align:top }
			td.h { background-color:##eee }
			</style>
			<table border="0" cellspacing="2" cellpadding="2">
			</cfoutput>
			<cfif encabezar>
				<cfoutput><tr></cfoutput>
				<cfloop query="det">	
					<cfoutput><td><b>#det.DInombre#</b></td></cfoutput>
				</cfloop>
				<cfoutput></tr></cfoutput>
			</cfif>
			<cfloop from="1" to="#err.RecordCount#" index="row">
				<cfoutput><tr></cfoutput>
				<cfoutput query="det">
					<cfset value7=err.getField(javacast("int", row), javacast("int",det.CurrentRow))>
					<cfif Not IsDefined("value7")><cfset value7="8"></cfif>
					<td>#formatearDato(value7,det.DItipo, det.DIlongitud)#</td>
				</cfoutput>
				<cfoutput></tr>#enter#</cfoutput>
			</cfloop>
			<cfoutput></table></body></html></cfoutput>
			<cfreturn temporaryfilename>
	<cfelse>
		<cfset newline = Chr(13) & Chr(10)>
		<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 32768 ))>
		<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'QueryToFileXL')>
		<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
		<cfif encabezar>
			<cfloop query="det">
				<cfif det.CurrentRow gt 1>
					<cfset write_to_buffer(separador)>
				</cfif>
				<cfset write_to_buffer(det.DInombre)>
			</cfloop>
			<cfset write_to_buffer(newline)>
		</cfif>
		<cfloop from="1" to="#err.RecordCount#" index="row">
			<cfloop query="det">
				<cfset value7=err.getField(javacast("int", row), javacast("int",det.CurrentRow))>
				<cfif Not IsDefined("value7")><cfset value7=""></cfif>
				<cfif det.CurrentRow gt 1>
					<cfset write_to_buffer(separador)>
				</cfif>
				<cfset LvarColumna = formatearDato(value7, det.DItipo, det.DIlongitud)>
				<cfset write_to_buffer(LvarColumna)>
			</cfloop>
			<cfset write_to_buffer(newline)>
		</cfloop>
		<cfset write_to_buffer('', true)>
        <!---►►►►►Si se envia Descargar, se descarga el Archivo de una vez, si no se retorna el Archivo◄◄◄◄--->
        <cfif Arguments.Descargar>
            <cfheader name="Content-Disposition" value="attachment; filename=exportar.txt">
            <cfcontent type="text/plain" reset="yes" file="#temporaryFileName#" deletefile="yes">
        <cfelse>
        	<cfreturn temporaryFileName>
        </cfif>
	</cfif>
</cffunction>

<!---►►►►►Funcion para la sustitucion de variables una a una◄◄◄◄--->
<cffunction name="sustituir" access="public" output="false" returntype="string">
	<cfargument name="sql_string" type="string" required="yes">
	<cfargument name="param_values" type="struct" required="yes">
	<cfargument name="param_info" type="query" required="yes">

	<cfset ret_value = Arguments.sql_string>
	<cfloop query="param_info">
		<cfif Not StructKeyExists(Arguments.param_values, param_info.DInombre)>
			<cf_errorCode	code = "51413"
							msg  = "Parámetro sin definir: @errorDat_1@"
							errorDat_1="#param_info.DInombre#"
			>
		<cfelse>
			<cfset the_value = Arguments.param_values[param_info.DInombre] >
			<cfif (param_info.DItipo EQ "numeric" or 
				   param_info.DItipo EQ "int" or  
				   param_info.DItipo EQ "float" or  
				   param_info.DItipo EQ "money") and 
				   not IsNumeric(the_value)>
				<cf_errorCode	code = "51414"
								msg  = "El parámetro '@errorDat_1@' debe ser numérico, y su valor es '@errorDat_2@'"
								errorDat_1="#param_info.DInombre#"
								errorDat_2="#the_value#"
				>
			<cfelseif param_info.DItipo EQ "datetime" and Not IsDate(the_value)>
				<cf_errorCode	code = "51415"
								msg  = "El parámetro '@errorDat_1@' debe ser fecha, y su valor es '@errorDat_2@'"
								errorDat_1="#param_info.DInombre#"
								errorDat_2="#the_value#"
				>
			</cfif>
		</cfif>
		<cfset ret_value = sustituir_uno(ret_value, param_info.DInombre, the_value, param_info.DItipo)>
	</cfloop>
	
	<cfset ret_value = sustituir_uno(ret_value, "Ecodigo", session.Ecodigo, "int")>
	<cfset ret_value = sustituir_uno(ret_value, "Usulogin", session.usuario, "varchar")>
	<cfset ret_value = sustituir_uno(ret_value, "Usucodigo", session.Usucodigo, "numeric")>
	<cfset ret_value = sustituir_uno(ret_value, "Ulocalizacion", "00", "varchar")>
	
	<cfreturn ret_value>
</cffunction>
<!---►►►►►Funcion que llena el Buffer◄◄◄◄--->
<cffunction name="write_to_buffer">
	<cfargument name="contents"  type="string"  required="yes">
	<cfargument name="flush"  	 type="boolean" default="no">
	<cfset buffer.append(javacast("string", Arguments.contents))>
	<cfif Arguments.flush Or (buffer.length() GE 16383)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>
<!---►►►►►Funcion para la sustitucion de variables una a una◄◄◄◄--->
<cffunction name="sustituir_uno" access="private" output="false" returntype="string">
	<cfargument name="sqlstring" 		type="string" required="yes">
	<cfargument name="variable_name" 	type="string" required="yes">
	<cfargument name="value" 			type="string" required="yes">
	<cfargument name="datatype" 		type="string" required="yes">
	
	<cfif ListFind('numeric,int,float,money,datetime',Arguments.datatype )>
		<cfset formatted_value = Arguments.value >
	<cfelseif ListFind('varchar', Arguments.datatype )>
		<cfset formatted_value = "'" & Replace(Arguments.value, "'", "''", "all") & "'">
	<cfelse>
		<cf_errorCode	code = "51412"
						msg  = "datatype inválido para sustitución: @errorDat_1@ @errorDat_2@"
						errorDat_1="#Arguments.variable_name#"
						errorDat_2="#Arguments.datatype#">
	</cfif>
	
	<cfset ret_value = Replace(ret_value, "##" & Arguments.variable_name & "##", formatted_value, 'all')>
	<cfset ret_value = Replace(ret_value, "@" & Arguments.variable_name, formatted_value, 'all')>
	<cfreturn ret_value>
</cffunction>