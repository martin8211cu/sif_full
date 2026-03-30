<cfquery name="rsRetusuario" datasource="asp">
	select Usulogin
	from Usuario
	where Usucodigo = #session.Usucodigo#
</cfquery>

<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td align="right"><strong class="Titulos2">#LB_Pagina#:&nbsp;&nbsp;#Pagina#/#varPaginaMax#</strong></td>
    </tr>
<!---    <tr>
		<td align="right"><strong>Hora:</strong>&nbsp;&nbsp;#timeformat(now(),"HH:mm:ss")# </td>
	</tr>
    <tr>
        <td align="right"><strong>Fecha:</strong> #dateformat(now(),"dd/mm/yyyy")# </td>
	</tr>
--->
</table>
</cfoutput>