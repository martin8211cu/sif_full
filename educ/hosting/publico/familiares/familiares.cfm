<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Mis Familiares
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
	<cfinclude template="../pNavegacion.cfm">
	<!--- <table width="89%" border="0" cellpadding="0" cellspacing="0" >
    	<tr>
    	  <td width="1%" nowrap><font size="2">&nbsp;<img src="/cfmx/sif/imagenes/Computer01_T2.gif" width="31" height="31"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Operaciones</b></font></td>
   	  </tr>
    	<tr>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap ><a href="registro.cfm?tipo=1"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="registro.cfm?tipo=1">Registro de Familiares que comparten mi domicilio</a></td>
   	    <tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td align="right" valign="middle" nowrap ><a href="registro.cfm?tipo=2"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
			<td valign="middle" nowrap><a href="registro.cfm?tipo=2">Registro de Familiares que no comparten mi domicilio</a></td>
   	    </tr>

		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</a></td>		
			<td valign="middle" nowrap>&nbsp;</a></td>		
       	</tr>

	</table> --->
	<cfinclude template="lista.cfm">
</cf_templatearea>
</cf_template>