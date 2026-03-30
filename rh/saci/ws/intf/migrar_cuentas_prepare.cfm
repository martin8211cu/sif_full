<html><head><title>Preparar</title>
<link href="migrar_cuentas.css" rel="stylesheet" type="text/css" />
</head>
<body>
<cfif Not IsDefined('url.rows')>
	<cfoutput>
	<form action="#CGI.SCRIPT_NAME#" method="get"><table border="1" cellspacing="0" cellpadding="2">
  <tr>
    <td>Limitar cédulas</td>
    <td><input type="text" name="rows" value="50" /></td>
  </tr>
  <tr>
    <td> Iniciar en </td>
    <td><input type="text" name="startrow" value="1" /></td>
  </tr>
  <tr>
    <td>Solamente las cédulas </td>
    <td><input type="text" name="solocedulas" value="" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="submit" type="submit" onClick="this.disabled=true;this.value=&quot;Un momentico...&quot;" value="Preparar" /></td>
  </tr>
</table>
</form>
	#'<'#/body>#'<'#/html>
	</cfoutput>
	<cfabort>
</cfif>

<cfset Server.migracion = StructNew()>
<cfquery datasource="#session.dsn#">
	if object_id ('migra_cedula') is not null drop table migra_cedula
	if object_id ('migra_error') is not null drop table migra_error
</cfquery>
<cfquery datasource="#session.dsn#">
	create table migra_cedula (cedula varchar(30) not null, unique (cedula) )
	create table migra_error (errorid numeric(7) identity, cedula varchar(30), msg varchar(255), stack varchar(255), primary key (cedula, errorid))
</cfquery>
<cfset Server.migracion.rc = 'Consultando cédulas.  Por favor espere...'>
<cfparam name="url.solocedulas" default="">
<cfif Len(url.solocedulas)>
	<cfloop list="#url.solocedulas#" index="cedula">
		<cfquery datasource="#session.dsn#">
			insert into migra_cedula (cedula) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#cedula#">)
		</cfquery>
	</cfloop>
	<cfset Server.migracion.TotalRows = ListLen(url.solocedulas)>
<cfelse>
	<cfinvoke component="migrar_cuentas" method="query_cedulas" maxrows="#url.rows#" returnvariable="Server.migracion.TotalRows" />
</cfif>
<cfset Server.migracion.rc = 'Preparado. #Server.migracion.TotalRows# cédulas obtenidas'>
<cfset Server.migracion.startTime = 0>

ok @ <cfoutput>#Now()#</cfoutput><br />
<a href="migrar_cuentas_start.cfm">Comenzar</a>
</body></html>
