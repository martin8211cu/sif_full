<cf_templateheader title="Seleccionar parche">
<cfinclude template="../mapa.cfm">

<h1>Seleccionar el parche que desea utilizar</h1>

<cfoutput>
<cfparam name="url.parche" default="">
<cfif Not Len(url.parche)>
<cf_web_portlet_start titulo="Seleccionar parche" width="700">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla='APParche'
			columnas='parche,pdir,pnum,psec,psub,creado,autor'
			conexion="asp"
			filtro=""
			desplegar="pdir,pnum,psec,psub,creado,autor"
			etiquetas="Dir,Num,Sec,Sub,Creado,Autor"
			formatos="S,S,S,S,DT,S"
			align="left,left,left,left,left,left"
			irA="selecc.cfm"
			keys="parche"
			form_method="get"
			formName="lista2"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
		/>
<p>Seleccione el parche que desea abrir haciendo clic sobre él</p>
<cf_web_portlet_end>
</cfif>
<cfif Len(url.parche)>
<cf_web_portlet_start titulo="Revisar el Parche" width="700">

<cfquery datasource="asp" name="data">
	select nombre,creado,modificado,autor,
		pdir,pnum,psec,psub,svnrev,
		entregado,cerrado,modulo,vistas
	from APParche
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.parche#">
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
   <tr><td  colspan="2">
   	<form action="selecc-control.cfm" method="post">
   <table cellpadding="0" cellspacing="0" width="100%">
   <tr><td>
		<input type="hidden" name="parche" value="# HTMLEditFormat(url.parche) #">
		<input type="hidden" name="nombre" value="# HTMLEditFormat(data.nombre) #">
		<input type="submit" name="ok" value="Utilizar este parche">
		<input type="button" name="cancel" value="Cancelar" onclick="javascript:back()">
	</td>
	<td align="right"><input type="submit" name="eliminar" class="btnEliminar" value="Eliminar este parche" onclick="return confirm('¿Está seguro de que desea eliminar este parche?')">
	</td>
	</tr></table>
	</form>
   </td></tr>
 </table>
<cf_web_portlet_end>
</cfif>
</cfoutput>
<cf_templatefooter>
