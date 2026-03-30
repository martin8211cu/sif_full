
<cfset ldapServer = '10.7.7.236'>
<cfset ldapBaseDN = 'dc=ldap,dc=soin,dc=com'>
<cfset ldapAdminUserDN = 'ldap.soin.com/Users/Alfonso Vargas'>
<cfset ldapAdminPassword = '123456'>
<cfset uid = 'admin@ldap.soin.com'>

<cfldap	server="#ldapServer#"
						action="query"
						name="finduserQuery1"
						start="#ldapBaseDN#" 
						filter="userPrincipalName=#trim(uid)#"
						attributes="dn"
						username="#ldapAdminUserDN#"		<!--- usuario administrador debe venir antecedido del dominio ej: dominio\usuario (por ser capturado en pantalla) --->
						password="#ldapAdminPassword#" >
<cfdump var="#finduserQuery1#">

<cfset uid = 'avargas@ldap.soin.com'>
<cfldap	server="#ldapServer#"
						action="query"
						name="finduserQuery2"
						start="#ldapBaseDN#" 
						filter="userPrincipalName=#trim(uid)#"
						attributes="dn"
						username="#ldapAdminUserDN#"		<!--- usuario administrador debe venir antecedido del dominio ej: dominio\usuario (por ser capturado en pantalla) --->
						password="#ldapAdminPassword#" >
<cfdump var="#finduserQuery2#">

<!--- <cfquery  datasource="ASP">

update UsuarioPassword
set PasswordSet  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(1999,01,01)#">
where Usulogin ='avargas'

</cfquery> --->


FIN