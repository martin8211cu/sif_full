<!--- Expirar la sesión --->
<!---
Modificado por: Yu Hui Wen
Fecha: 10 de Marzo del 2003
Por favor NO CAMBIAR
--->
<cfapplication 
	name="SIF_ASP" 
	sessionmanagement="yes" 
	sessiontimeout="#CreateTimeSpan(0,0,0,0)#">
<cfloop collection=#Session# ITEM="key"> 
  <cfif Not ListFindNoCase('CFID,CFTOKEN,SESSIONID,URLTOKEN', Key)>  
    <cfset StructDelete(Session, Key)>
  </cfif> 
</cfloop>
<!--- 
<cfset StructDelete(Session,"Ecodigo")>
<cfset StructDelete(Session,"Usucodigo")>
<cfset StructDelete(Session,"Usuario")>
<cfset StructDelete(Session,"Ulocalizacion")>
<cfset StructDelete(Session,"DSN")>
--->
<cflogout>

<cfapplication 
	name="EDU" 
	sessionmanagement="yes" 
	sessiontimeout="#CreateTimeSpan(0,0,0,0)#">
<cfloop collection=#Session# ITEM="key"> 
  <cfif Not ListFindNoCase('CFID,CFTOKEN,SESSIONID,URLTOKEN', Key)>  
    <cfset StructDelete(Session, Key)>
  </cfif> 
</cfloop>
<cflogout>

<cflocation url="/jsp/login/logout.jsp">
