<br />
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfif archivo EQ "Activos.cfm">
	<cfinclude template="Activos_frameEncabezado.cfm">
</cfif>
	<cfquery name="Activo" datasource="#session.DSN#">
		select cat.ACatId categoria, cla.AClaId clasificacion
 		  from Activos a
	        inner join ACategoria cat
		       on cat.Ecodigo = a.Ecodigo
		      and cat.ACcodigo = a.ACcodigo
	        inner join AClasificacion cla
		      on cla.Ecodigo = a.Ecodigo
		     and cla.ACcodigo = a.ACcodigo
		     and cla.ACid = a.ACid
 		where Aid = #URL.Aid#
	</cfquery>
	<cfset Tipificacion = StructNew()>
	<cfset temp = StructInsert(Tipificacion, "AF", "")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#Activo.categoria#")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#Activo.clasificacion#")> 

<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
	<tr>
	  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Otros Datos </td>
	</tr>
	</tbody>
</table>
			
<form name="otrosDatos" action="Activos_frameOtrosDatos-sql.cfm" method="post">
	<input type="hidden" name="Aid" 	   value="<cfoutput>#url.Aid#</cfoutput>"/>
	<input type="hidden" name="tab" 	   value="<cfoutput>#url.tab#</cfoutput>"/>
	<input type="hidden" name="AF" 		   value="<cfoutput>#Tipificacion['AF']#</cfoutput>"/>
	<input type="hidden" name="AF_CATEGOR" value="<cfoutput>#Tipificacion['AF_CATEGOR']#</cfoutput>"/>
	<input type="hidden" name="AF_CLASIFI" value="<cfoutput>#Tipificacion['AF_CLASIFI']#</cfoutput>"/>
	<p>
		<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
			<cfinvokeargument name="DVTcodigoValor" value="AF">
			<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
			<cfinvokeargument name="DVVidTablaVal"  value="#URL.Aid#">
			<cfinvokeargument name="form" 			value="otrosDatos">
			<cfinvokeargument name="NumeroColumas"  value="2">
		</cfinvoke>
	</p>
		<cfif Cantidad EQ 0>
			<div align="center">No Existen Datos Variables Asignados al Activo</div>
		<cfelse>
			<div align="center"><input type="submit" name="ALTA" value="Guardar Valores" class="btnGuardar" /></div>
		</cfif>
</form>

<cfinvoke component="sif.Componentes.DatosVariables" method="QformDatoVariable">
	<cfinvokeargument name="DVTcodigoValor" value="AF">
	<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
	<cfinvokeargument name="DVVidTablaVal"  value="#URL.Aid#">
	<cfinvokeargument name="form" 			value="otrosDatos">
</cfinvoke>