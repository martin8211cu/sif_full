<cfsetting enablecfoutputonly="yes">
<cfparam name="form.tipo"    type="string" default="">
<cfparam name="form.rango"   type="string" default="">
<cfparam name="form.sistema" type="string" default="">
<cfparam name="form.modulo"  type="string" default="">

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">

<cfif (tipo EQ "xml")>
	<cfheader name="Content-Disposition" value="attachment; filename=framework-app.xml">
<cfoutput><?xml version="1.0" encoding="ascii" ?>
<datos>
  <filtro>
    <cfif form.rango EQ 's'><sistema>#XmlFormat(form.sistema)#</sistema>
    <cfelseif form.rango EQ 'm'><modulo>#XmlFormat(form.modulo)#</modulo>
	<cfelse><exportar_todo /></cfif>
  </filtro>
</cfoutput>
<cfelseif (tipo EQ "sql")>
	<cfcontent type="text/html; charset=ISO-8859-1">
	<cfheader name="Content-Disposition" value="attachment; filename=framework-app.sql" >
	<cfoutput>/*# newline# Exportacion </cfoutput>
    <cfif form.rango EQ 's'><cfoutput>del sistema # form.sistema #</cfoutput></sistema>
    <cfelseif form.rango EQ 'm'><cfoutput>del modulo # form.modulo #</cfoutput></modulo>
	<cfelse><cfoutput>completa, todos los sistemas</cfoutput></cfif>
	<cfoutput># newline # */# newline #go# newline #</cfoutput>
</cfif>

<cfscript>
    dbutils = CreateObject("component", "sif/Componentes/DButils");

	function TypeIsBinary( typeName ) {
		return (0 NEQ ListFindNoCase("binary,varbinary,image,BLOB", typeName));
	}
	function TypeIsDate( typeName )  {
		return (0 NEQ ListFindNoCase("date,time,datetime,smalldatetime", typeName));
	}
	function TypeIsBoolean( typeName )  {
		return (0 NEQ ListFindNoCase("bit,boolean", typeName));
	}
	function TypeIsNumeric( typeName )  {
		return (0 NEQ ListFindNoCase("bigint,int,integer,smallint,tinyint,numeric,decimal,double,float,money,real", typeName));
	}
	function TypeIsString( typeName )  {
		return (0 NEQ ListFindNoCase("text,char,varchar,CLOB,longvarchar", typeName));
	}
	function getTypeNames( ret ) {
		var typeNames = ArrayNew (1);
		var md = ret.getMetaData();
		var count = md.getColumnCount();
		for (i = 1; i LE count; i = i + 1) {
			typeNames[i] = md.getColumnTypeName (JavaCast ("int", i) );
		}
		return typeNames;
	}
	function quoteXML( value, typeName ) {
		if (Len ( value ) EQ 0) {
			return "";
		} else if ( TypeIsBinary( typeName )) {
			return dbutils.toTimestamp( value );
		} else if ( TypeIsNumeric( typeName )) {
			return value;
		} else if ( TypeIsDate( typeName )) {
			return DateFormat(value, "yyyymmdd") & " " & TimeFormat(value, "HH:mm:ss.lll");
		} else if ( TypeIsBoolean( typeName )) {
			if (value) { 
				return "true";
			} else {
				return "false";
			}
		} else if ( TypeIsString( typeName )) {
			return XmlFormat( Trim (value) );
		} else {
			return " DESCONOCIDO : " & typeName;
		}
	}
	function quoteSQL( value, typeName ) {
		if (Len ( value ) EQ 0) {
			return "null";
		} else if ( TypeIsBinary( typeName )) {
			return dbutils.toTimestamp( value );
		} else if ( TypeIsNumeric( typeName )) {
			return value;
		} else if ( TypeIsDate( typeName )) {
			return "'" & DateFormat(value,"yyyymmdd") & " " & TimeFormat(value,"HH:mm:ss.lll") & "'";
		} else if ( TypeIsBoolean( typeName )) {
			if (value) {
				return "1";
			} else {
				return "0";
			}
		} else if ( TypeIsString( typeName )) {
			return "'" & Replace( Trim( value ), "'", "''", "all") & "'" ;
		} else {
			return " DESCONOCIDO : " & typeName;
		}
	}
	function gen(ret, table, pk)
	{
		if (form.tipo EQ "xml") {
			genXML(ret,table);
		} else {
			genSQL(ret,table,pk);
		}
	}
	
</cfscript>

<cffunction name="genSQL">
	<cfargument name="ret"   required="yes">
	<cfargument name="table" required="yes">
	<cfargument name="pk"    required="yes">
		<cfset names = ret.getMetaData().getColumnLabels()>
		<cfset typeNames = getTypeNames(ret)>
		<cfset timestamp = -1>
		<cfset lastcol = ArrayLen(names)>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfif "timestamp" EQ names[i]>
				<cfset timestamp = i>
				<cfif timestamp EQ lastcol>
					<cfset lastcol = lastcol - 1>
				</cfif>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfloop query="ret">
			<cfoutput>update #table## newline #</cfoutput>
			<cfset set_keyword = "set">
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp AND ListFind(pk, names[i]) EQ 0>
					<cfoutput>#set_keyword# #names[i]# = #quoteSQL( Evaluate (
						"ret." & names[i]), typeNames[i] )## newline #</cfoutput>
					<cfset set_keyword = ",  ">
				</cfif>
			</cfloop>
			<cfset where_keyword = "where">
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif ListFind(pk, names[i]) NEQ 0>
					<cfoutput>#where_keyword# #names[i]# = #quoteSQL( Evaluate (
						"ret." & names[i]), typeNames[i] )# # newline #</cfoutput>
					<cfset where_keyword = "  and">
				</cfif>
			</cfloop>
			<cfoutput>if @@rowcount = 0#newline#insert #table# (#newline#</cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp>
					<cfoutput>#names[i]#<cfif i NEQ lastcol>,<cfif i MOD 4 EQ 0>#newline# </cfif> </cfif></cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>)#newline#values (#newline#  </cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp>
					<cfoutput>#quoteSQL( Evaluate (
						"ret." & names[i]), typeNames[i] )#<cfif i NEQ lastcol>,<cfif i MOD 4 EQ 0>#newline# </cfif> </cfif></cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>)#newline#go#newline#</cfoutput>
		</cfloop>
</cffunction>

<cffunction name="genXML">
	<cfargument name="ret" required="yes">
	<cfargument name="table" required="yes">
		<cfset names = ret.getMetaData().getColumnLabels()>
		<cfset typeNames = getTypeNames(ret)>
		<cfset timestamp = -1>
		<cfset lastcol = ArrayLen(names)>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfif "timestamp" EQ names[i]>
				<cfset timestamp = i>
				<cfif timestamp EQ lastcol>
					<cfset lastcol = lastcol - 1>
				</cfif>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfoutput><#table#_list>#newline#</cfoutput>
		<cfloop query="ret">
			<cfoutput>#indent#<row>#newline#</cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp>
					<cfoutput>#indent##indent#<#names[i]#>#quoteXML( Evaluate (
						"ret." & names[i]), typeNames[i] )#</#names[i]#>#newline#</cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>#indent#</row>#newline#</cfoutput>
		</cfloop>
		<cfoutput></#table#_list>#newline#</cfoutput>
</cffunction>

<cfquery datasource="sdc" name="ret">
		select * from Sistema s
		<cfif form.rango EQ 's' >
		where sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#">
		<cfelseif form.rango EQ 'm' >
		where exists (select * from Modulo m
			where m.sistema = s.sistema
			  and m.modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#"> )
		</cfif>
	</cfquery>
<cfset gen(ret, "Sistema", "sistema") >

<cfquery datasource="sdc" name="ret">
		select * from Modulo
		<cfif form.rango EQ 's' >
		where sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#">
		<cfelseif form.rango EQ 'm' >
		where modulo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#">
		</cfif>
	</cfquery>
<cfset gen(ret, "Modulo", "modulo") >

<cfquery datasource="sdc" name="ret">
		select * from Rol r
		<cfif form.rango EQ 's' >
		where sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#">
		<cfelseif form.rango EQ 'm' >
		where exists (select * from Modulo m
			where m.sistema = r.sistema
			  and m.modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#"> )
		</cfif>
	</cfquery>
<cfset gen(ret, "Rol", "rol") >

<cfquery datasource="sdc" name="ret">
		select 
			<cfif form.tipo EQ "sql">
			<!--- son todas las columnas excepto home_uri y home_tipo --->
			servicio, modulo, nombre, descripcion,
			menu, home, snapshot_uri,
			agregacion, orden, activo,
			BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
			<cfelse> *
			</cfif>
		from Servicios s
		<cfif form.rango EQ 's' >
		where exists (select * from Modulo m
			where s.modulo = m.modulo
			  and m.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#"> )
		<cfelseif form.rango EQ 'm' >
		where modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#">
		</cfif>
	</cfquery>
<cfset gen(ret, "Servicios", "servicio") >

<cfquery datasource="sdc" name="ret">
		select * from ServiciosRol sr
		<cfif form.rango EQ 's' >
		where exists (select * from Servicios s, Modulo m
			where sr.servicio = s.servicio
			  and s.modulo = m.modulo
			  and m.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#"> )
		<cfelseif form.rango EQ 'm' >
		where exists (select * from Servicios s
			where sr.servicio = s.servicio
			  and s.modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#"> )
		<cfelse>
		where exists (select * from Servicios s
			where sr.servicio = s.servicio)
		</cfif>
	</cfquery>
<cfset gen(ret, "ServiciosRol", "servicio,rol") >

<cfquery datasource="sdc" name="ret">
		select * from Procesos p
		<cfif form.rango EQ 's' >
		where exists (select * from Servicios s, Modulo m
			where p.servicio = s.servicio
			  and s.modulo = m.modulo
			  and m.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#"> )
		<cfelseif form.rango EQ 'm' >
		where exists (select * from Servicios s
			where p.servicio = s.servicio
			  and s.modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#"> )
		</cfif>
	</cfquery>
<cfset gen(ret, "Procesos", "tipo_uri,uri,servicio") >
<cfif (tipo EQ "xml") >
<cfoutput></datos></cfoutput>
<cfelseif form.tipo EQ "sql">
	<cfquery datasource="sdc" name="ret">
		<!--- siguen los update de home --->
		select servicio, home_uri, home_tipo
		from Servicios s
		where home_uri is not null
		  and home_tipo is not null
		  and home_uri != ''
		<cfif form.rango EQ 's' >
		  and exists (select * from Modulo m
			where s.modulo = m.modulo
			  and m.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#"> )
		<cfelseif form.rango EQ 'm' >
		  and modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#">
		</cfif>
	</cfquery>
<cfoutput query="ret"><!--- no indentar --->
update Servicios
set home_tipo = #quoteSQL( ret.home_tipo, 'char' )#, home_uri = #quoteSQL( ret.home_uri, 'char' )#
where servicio = #quoteSQL( ret.servicio, 'char' )#
go
</cfoutput>
</cfif>