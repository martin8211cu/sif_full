<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<a href="javascript:window.open('/cfmx/home/public/logout.cfm','logggggout')">
logout....</a>
<iframe src="about:blank" width="200" height="10" name="logggggout"></iframe>

<cfoutput> #Now()#
<cfset comp = CreateObject("component", "saci.ws.intf.IPlanetService")>
<cfset testuser = 'mickysebas'>


<br />Query #testuser#..
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#" 
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">


<br />Ver si existe...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">

<cfif rs.RecordCount is 0>
	<br />Crear usuario...
	
	<cfset attributes = ArrayNew(1)>
	<!---
	<cfset ArrayAppend(attributes, 'objectclass=top$person$organizationalPerson$inetorgperson')>
	<cfset ArrayAppend(attributes, 'cn=CF Ldap Test User')>
	<cfset ArrayAppend(attributes, 'uid=#testuser#')>
	<cfset ArrayAppend(attributes, 'givenname=CF Ldap')>
	<cfset ArrayAppend(attributes, 'sn=Test User')>
	<cfset ArrayAppend(attributes, 'userpassword=secret')>
	--->
	
	
	<cfset ArrayAppend(attributes, 'cn=test_user')>
	<cfset ArrayAppend(attributes, 'datasource=iPlanet Messaging Server 5.0 Admin Console')>
	<cfset ArrayAppend(attributes, 'givenname=Test')>
	<cfset ArrayAppend(attributes, 'inetuserstatus=active')>
	<cfset ArrayAppend(attributes, 'iplanet-am-modifiable-by=cn=Top-level Admin Role,o=isp')>
	<cfset ArrayAppend(attributes, 'iplanet-am-user-login-status=Active')>
<cfset ArrayAppend(attributes, 'mail=test_user@nova.racsa.co.cr')>
	<cfset ArrayAppend(attributes, 'mailAlternateAddress=test_user@sol.racsa.co.cr')>
	<cfset ArrayAppend(attributes, 'mailDeliveryOption=mailbox')>
	<cfset ArrayAppend(attributes, 'mailHost=nova.racsa.co.cr')>
	<cfset ArrayAppend(attributes, 'mailMessageStore=mailbox')>
	<cfset ArrayAppend(attributes, 'mailQuota=100')>
	<cfset ArrayAppend(attributes, 'mailUserStatus=active')>
	<!---
<cfset ArrayAppend(attributes, 'nswmExtendeUserPrefs=meDraftFolder=Borrador')>
<cfset ArrayAppend(attributes, 'nswmExtendeUserPrefs=meSentFolder=Enviado')>
<cfset ArrayAppend(attributes, 'nswmExtendeUserPrefs=meTrashFolder=Papelera')>
<cfset ArrayAppend(attributes, 'nswmExtendeUserPrefs=meInitialized=true')>
--->
<cfset ArrayAppend(attributes, 'objectClass=top$person$organizationalPerson$inetorgperson$inetUser$inetSubscriber$ipUser$nsManagedPerson$inetmailuser$inetlocalmailrecipient$userpresenceprofile$iplanet-am-user-service$iplanet-am-managed-person$inetadmin$iplanetpreferences$sunUCPreferences')>
<!---
<cfset ArrayAppend(attributes, 'pabURI=ldap://ldap.racsa.co.cr:389/ou=test_user,ou=People,o=racsa.co.cr,o=isp')>
--->
<cfset ArrayAppend(attributes, 'preferredLanguage=es')>
<cfset ArrayAppend(attributes, 'sn=User')>
<cfset ArrayAppend(attributes, 'sunUCColorScheme=2')>
<cfset ArrayAppend(attributes, 'sunUCDateDelimiter=/')>
<cfset ArrayAppend(attributes, 'sunUCDateFormat=D/M/Y')>
<cfset ArrayAppend(attributes, 'sunUCDefaultApplication=mail')>
<cfset ArrayAppend(attributes, 'sunUCDefaultEmailHandler=uc')>
<cfset ArrayAppend(attributes, 'sunUCTimeFormat=12')>
<cfset ArrayAppend(attributes, 'sunUCTimeZone=America/Costa_Rica')>
<cfset ArrayAppend(attributes, 'uid=#testuser#')>
<cfset ArrayAppend(attributes, 'userPassword=test_pass')>

!!! <cfset ArrayAppend(attributes, 'sunUCTheme=uwc')>
<!---
<cfset ArrayAppend(attributes, 'dn= uid=mickysebas, ou=People, o=racsa.co.cr,o=isp')>

<cfset ArrayAppend(attributes, 'mailhost= supernova.racsa.co.cr')>
<cfset ArrayAppend(attributes, 'maildeliveryoption= mailbox')>
<cfset ArrayAppend(attributes, 'mailuserstatus= active')>
<cfset ArrayAppend(attributes, 'mailquota= 104857600')>
<cfset ArrayAppend(attributes, 'mail= mickysebas@racsa.co.cr')>
<cfset ArrayAppend(attributes, 'preferredlanguage= es')>
<cfset ArrayAppend(attributes, 'inetuserstatus= active')>
<cfset ArrayAppend(attributes, 'cn= MICHAEL DAVID CLEMENS')>
<cfset ArrayAppend(attributes, 'uid= mickysebas')>
<cfset ArrayAppend(attributes, 'datasource= iPlanet Messaging Server 5.0 Admin Console')>
<cfset ArrayAppend(attributes, 'givenname= EMPTY')>
<cfset ArrayAppend(attributes, 'sn= EMPTY')>
<cfset ArrayAppend(attributes, 'userpassword= ppwswm9k')>

<cfset ArrayAppend(attributes, 'mailalternateaddress= mickysebas@sol.racsa.co.cr')>
<cfset ArrayAppend(attributes, 'mailMessageStore= tercery')>
<cfset ArrayAppend(attributes, 'iplanet-am-user-login-status= Active')>
<cfset ArrayAppend(attributes, 'iplanet-am-modifiable-by= cn=Top-level Admin Role,o=isp')>
<cfset ArrayAppend(attributes, 'sunUCDefaultApplication=mail')>
<cfset ArrayAppend(attributes, 'sunUCTheme=uwc')>
<cfset ArrayAppend(attributes, 'sunUCColorScheme=2')>
<cfset ArrayAppend(attributes, 'sunUCDefaultEmailHandler=uc')>
<cfset ArrayAppend(attributes, 'sunUCDateFormat=D/M/Y')>
<cfset ArrayAppend(attributes, 'sunUCDateDelimiter=/')>
<cfset ArrayAppend(attributes, 'sunUCTimeFormat=12')>
<cfset ArrayAppend(attributes, 'sunUCTimeZone=America/Costa_Rica')>
<cfset ArrayAppend(attributes, 'objectclass=top$person$organizationalPerson$inetorgperson$inetUser$inetSubscriber$ipUser$nsManagedPerson$inetmailuser$inetlocalmailrecipient$userpresenceprofile$inetadmin$iplanetpreferences$sunUCPreferences$iplanet-am-user-service$iplanet-am-managed-person')>
--->
<table><tr><td valign="top">
<cfdump var="#attributes#" label="attributes"></td><td valign="top">
<cfif IsDefined('server.atts')>
<cfdump var="#server.atts#" label="server.atts"></cfif></td></tr></table>
		
	<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
		action="add"
		dn="uid=#testuser#,#comp.ldapSuffix#" attributes="#ArrayToList(attributes, ';')#" separator="$" delimiter=";">


</cfif>

<br />Query usuario nuevo ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">

<br />Modificar No. Fax ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="modify"
	dn="uid=#testuser#,#comp.ldapSuffix#" attributes="facsimileTelephoneNumber=#Int(Rand()*8008000+1001000)#">

<br />Query de nuevo ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">

<br />Query usuario renombrado ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#2"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">
<cfif rs.RecordCount is 0>
	<br />Renombrar usuario ...
	<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
		action="modifydn" 
		dn="uid=#testuser#,#comp.ldapSuffix#"
		attributes="uid=#testuser#2">
</cfif>

<br />Query de nuevo ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#2"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">

<br />Eliminar usuario ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="delete"
	dn="uid=#testuser#2,#comp.ldapSuffix#">

<br />Query de nuevo ...
<cfldap server="#comp.ldaphost#" port="#comp.ldapport#" username="#comp.ldapuser#" password="#comp.ldappass#"
	action="query" filter="uid=#testuser#2"
	attributes="*" name="rs" start="#comp.ldapSuffix#">
<cfdump var="# rs #">
</cfoutput>
</body>
</html>
