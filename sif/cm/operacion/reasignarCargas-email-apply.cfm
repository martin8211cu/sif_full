<!---  Se obtienen los datos que ocupa el correo para ser enviado. --->
<cfset email_subject = "Reasignación de Carga de Trabajo">
<cfset email_from = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#"> <!---  '<msalash@dospinos.com>'  "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" --->

<cfset email_to = '"' & form.nameBuyerTo & '" <' & form.email & '>'>
<cfset email_cc = '"' & form.nameBuyerCc & '" <' & form.Ccemail & '>'>

<cfsavecontent variable="email_body">
		<html>
			<head></head>
			<body>
				<cfinclude template="reasignarCargas-Aviso.cfm">
			</body>
		</html>
</cfsavecontent>

<cfinclude template="reasignarCargas-sql.cfm">

<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) NEQ 0>
    <cfmail from="#email_from#" to="#email_to#" cc="#form.Ccemail#" subject="#email_subject#" >
		<cfmailpart type="html" wraptext="72">
        	<cfoutput>#email_body#</cfoutput>
		</cfmailpart>
    </cfmail>
<cfelse>
    <cfmail from="#email_from#" to="#email_to#" subject="#email_subject#" >
	<cfmailpart type="html" wraptext="72">
        <cfoutput>#email_body#</cfoutput>
	</cfmailpart>
    </cfmail>
</cfif>

<cflocation url="reasignarCargas.cfm">