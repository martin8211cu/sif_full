<cfldap	server="192.168.210.14"
						action="query"
						name="finduserQuery"
						start="dc=sutel,dc=go,dc=cr" 
						filter="userPrincipalName=alexander.herrera@sutel.go.cr"
						attributes="dn"
						username="SUTEL\Administrador"
						password="Sutel2013AD" >
<cfdump var="#finduserQuery#">

<cfldap	server="192.168.210.14"
						action="query"
						name="finduserQuery"
						start="dc=sutel,dc=go,dc=cr" 
						filter="userPrincipalName=soin@sutel.go.cr"
						attributes="dn"
						username="SUTEL\Administrador"
						password="Sutel2013AD">
<cfdump var="#finduserQuery#">

