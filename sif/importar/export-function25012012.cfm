<cfsetting 	enablecfoutputonly="yes"> 
<!---
	funciones para ser incluidas por el exportador
--->
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

<cffunction name="write_to_buffer">
	<cfargument name="contents"          type="string" required="yes">
	<cfargument name="flush"  	     type="boolean" default="no">
	<cfset buffer.append(javacast("string", Arguments.contents))>
	<cfif Arguments.flush Or (buffer.length() GE 16383)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>


<!---
	cf_sifimportar.exec=yes
	          se hace obsoleto y se modifica la funcion exportar()
			  para que no use una variable de retorno, sino que
			  haga directamente los cfoutput de cada registro.
			  se le quita el returntype="string" 
			  danim, 03-ene-2005
--->
<cffunction name="exportar" output="yes">
	<cfargument name="fmt" type="numeric" required="yes">
	<cfargument name="html" type="boolean" default="no">
	<cfargument name="encabezar" type="boolean" default="no">
	<cfargument name="parms" type="struct" required="yes">

	<cfparam name="session.Ecodigo" type="numeric" default="1">
	<cfquery datasource="sifcontrol" name="enc">
		select a.*, b.EIsqlexp
		from EImportador a
			left join EISQL b
				on a.EIid = b.EIid
		where a.EIid = <cfqueryparam value="#fmt#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif enc.RecordCount EQ 1>
		<cfset EIid = enc.EIid>
	<cfelse>
		<cfoutput>
		<h1>404 - Not Found</h1><hr>El formato #fmt# no existe.
		</cfoutput>
		<cfreturn>
	</cfif>
	
	<cfquery datasource="sifcontrol" name="det">
		select * from DImportador
		where EIid = <cfqueryparam value="#EIid#" cfsqltype="cf_sql_numeric">
		  and DInumero > 0
		order by DInumero
	</cfquery>
	
	<cfquery datasource="sifcontrol" name="los_params">
		select * from DImportador
		where EIid = <cfqueryparam value="#EIid#" cfsqltype="cf_sql_numeric">
		  and DInumero < 0
		order by DInumero desc
	</cfquery>
	
	<cfinvoke component="sustituir" method="sustituir" returnvariable="sql_string"
		sql_string = "#enc.EIsqlexp#" param_values="#Arguments.parms#" param_info="#los_params#">
	
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
	
	<!---
		El tipo debe ser varchar,numeric,int,float,money,datetime
		o algun otro válido para cfsqltype="cf_sql_..."
	--->
	<cfif len(trim(enc.EIcfexporta)) GT 0>
		<!--- Este archivo debe contener los resultados en un query que se llame err --->
		<cfinclude template="#enc.EIcfexporta#">
	<cfelse>
		<cfquery datasource="#session.dsn#" name="err">
			# PreserveSingleQuotes( sql_string ) # 
		</cfquery>
	</cfif>
	
	<cfif Not IsDefined("err.RecordCount")>
		<!----================= TRADUCCION ==================--->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_No_hay_resultados"
			Default="No hay resultados"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_No_hay_resultados"/>
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
			<title><cf_translate key="LB_Exportacion" XmlFile="/sif/generales.xml">Exportaci&oacute;n</cf_translate></title>
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
		<cfreturn temporaryFileName>
	</cfif>
</cffunction>


