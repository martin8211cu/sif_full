<cfquery name="rsRetusuario" datasource="asp">
	select Usulogin
	from Usuario
	where Usucodigo = #session.Usucodigo#
</cfquery>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Usuario" default="Usuario" 
returnvariable="LB_Usuario" xmlfile="RetUsuario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="RetUsuario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hora" default="Hora" 
returnvariable="LB_Hora" xmlfile="RetUsuario.xml"/>
<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="50%" align="left"><strong>#LB_Fecha#:</strong> #dateformat(now(),"dd/mm/yyyy")# </td>
		<td width="50%" align="right"><strong>#LB_Usuario#:</strong> #rsRetusuario.Usulogin# </td>
	</tr>
	<tr>
		<td colspan="2" align="left"><strong>#LB_Hora#:</strong>&nbsp;&nbsp;#timeformat(now(),"HH:mm:ss")# </td>
	</tr>
</table>
</cfoutput>