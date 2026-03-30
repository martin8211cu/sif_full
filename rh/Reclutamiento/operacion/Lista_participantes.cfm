<title>
	Participantes en el concurso
</title>
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsLista" datasource="#session.DSN#">							
	select  RHCPid,
	 DEidentificacion,  
	 <cf_dbfunction name="concat" args=" b.DEnombre,' ', b.DEapellido1,' ',b.DEapellido2">  as NombreEmp
	from RHConcursantes a , DatosEmpleado b
	where  a.DEid  = b.DEid 
	and  RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RHCCONCURSO#" >
</cfquery>
<!---*******************************--->
<!---  área de pintado              --->
<!---*******************************--->
<table width="100%" cellpadding="2" cellspacing="0" border="1" align="center">
	<td colspan="1"  align="center"style="background-image:url(/cfmx/plantillas/login02/images/menuimg.gif)" valign="top"><strong><cf_translate key="LB_ListaDeConsursantes">Lista de Concursantes</cf_translate></strong></td>
	<tr>
	<cfinvoke
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"> 
		<cfinvokeargument name="query" value="#rsLista#"/> 
		<cfinvokeargument name="desplegar" value="DEidentificacion,NombreEmp"/> 
		<cfinvokeargument name="etiquetas" value="Identificación,Nombre"/> 
		<cfinvokeargument name="formatos" value=",S,S"/> 
		<cfinvokeargument name="align" value="left,left"/> 
		<cfinvokeargument name="ajustar" value="N"/> 
		<cfinvokeargument name="checkboxes" value="N"/> 
		<cfinvokeargument name="keys" value="RHCPid"/> 
		<cfinvokeargument name="showEmptyListMsg" value="true"/>						
		<cfinvokeargument name="maxrows" value="10"/>
		<cfinvokeargument name="showlink" value="false"/>
	</cfinvoke>
	</tr>
</table>



