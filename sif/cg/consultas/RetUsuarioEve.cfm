<cfquery name="rsRetusuario" datasource="asp">
	select Usulogin
	from Usuario
	where Usucodigo = #session.Usucodigo#
</cfquery>

<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
	<cfif isdefined("form.corte") and form.corte EQ 1>
        <tr>
            <td align="right"><strong>#LB_Pagina#:</strong>&nbsp;&nbsp;#Pagina#/#varPaginaMax#</td>
        </tr>
    </cfif>
    <tr>
		<td align="right"><strong>Hora:</strong>&nbsp;&nbsp;#timeformat(now(),"HH:mm:ss")# </td>
	</tr>
    <tr>
        <td align="right"><strong>Fecha:</strong> #dateformat(now(),"dd/mm/yyyy")# </td>
	</tr>
</table>
</cfoutput>