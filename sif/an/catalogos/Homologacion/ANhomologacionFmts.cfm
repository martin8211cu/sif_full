<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="M&aacute;scaras de Cuenta Financiera homologadas" 
returnvariable="LB_Mensaje" xmlfile="ANhomologacionFmts.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje1" 	default="Cuentas Financieras homologadas" 
returnvariable="LB_Mensaje1" xmlfile="ANhomologacionFmts.xml"/>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tituloAlterno" valign="top"> 
		<td><font size="2">#LB_Mensaje1#</font></td> 
	</tr>
	<tr><td>
			<cfinclude template="ANhomologacionFmts-form.cfm">
	</td></tr>
	<td><font size="2">#LB_Mensaje#</font></td>    
	<tr><td>
			<cfinclude template="ANhomologacionFmts-lista.cfm">
	</td></tr>
</table>

