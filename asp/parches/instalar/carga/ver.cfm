<cf_templateheader title="Información del parche">
<cfinclude template="../mapa.cfm">

<h1>Seleccionar el parche que desea utilizar</h1>

<cfoutput>

<cf_web_portlet_start titulo="Información del parche" width="700">

<cfquery datasource="asp" name="data">
	select nombre,creado,modificado,autor,
		pdir,pnum,psec,psub,svnrev,
		entregado,cerrado,modulo,vistas
	from APParche
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.parche#">
</cfquery>

<p>
	Revise la información del parche que acaba de seleccionar, y 
	confirme si este es el parche que desea utilizar.
</p>

 <table border="0" cellspacing="0" cellpadding="2" width="600" align="center">
   <tr>
     <td>Nombre</td>
     <td>#HTMLEditFormat(data.nombre)#</td>
   </tr>
   <tr>
     <td>UUID parche</td>
     <td># HTMLEditFormat(session.instala.parche)#</td>
   </tr>
   <tr>
     <td>UUID instalaci&oacute;n</td>
     <td># HTMLEditFormat(session.instala.instalacion)#</td>
   </tr>
   <tr>
     <td>Secuencia y Número</td>
     <td>#HTMLEditFormat(data.pdir)# #HTMLEditFormat(data.pnum)# 
	 	#HTMLEditFormat(data.psec)# #HTMLEditFormat(data.psub)#</td>
   </tr>
   <tr>
     <td>Módulo que afecta</td>
     <td>#HTMLEditFormat(data.modulo)#</td>
   </tr>
   <tr>
     <td>Fecha de creación</td>
     <td><cfif Len(data.creado)>#LSDateFormat(data.creado)# #LSTimeFormat(data.creado)# </cfif>&nbsp;</td>
   </tr>
   <tr>
     <td>Fecha de entrega</td>
     <td><cfif Len(data.entregado)>#LSDateFormat(data.entregado)# #LSTimeFormat(data.entregado)# </cfif>&nbsp;</td>
   </tr>
   <tr>
     <td>Fecha de cierre</td>
     <td><cfif Len(data.cerrado)>#LSDateFormat(data.cerrado)# #LSTimeFormat(data.cerrado)# </cfif>&nbsp;</td>
   </tr>
   <tr>
     <td>Revisión SVN</td>
     <td>#HTMLEditFormat(data.svnrev)#</td>
   </tr>
   <tr>
     <td>Autor</td>
     <td>#HTMLEditFormat(data.autor)#</td>
   </tr>
   <tr>
     <td>Regenerar vistas</td>
     <td>#YesNoFormat(data.vistas)#</td>
   </tr>
   <tr><td colspan="2">&nbsp;</td></tr>
   <tr>
     <td colspan="2">&nbsp;</td>
   </tr>
   <tr>
     <td colspan="2" align="right">
	 	<form action="ver-control.cfm" style="margin:0" method="post">
	 <input type="submit" value="Continuar" class="btnSiguiente" /></form></td>
   </tr>
 </table>
<cf_web_portlet_end>

</cfoutput>
<cf_templatefooter>
