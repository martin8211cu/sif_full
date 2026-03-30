    <style type="text/css">
<!--
.style1 {
	font-size: 20px;
	font-weight: bold;
}
-->
    </style>


<!---Regresar--->
<cfif isdefined ('form.Regresar')>
	<cflocation url="CambioResponsable.cfm">
</cfif>

<!---Modificar--->
<cfif isdefined ('form.modificar')>
    <!-------Inserto enla bitacora--------->
<cfquery name="inSQL" datasource="#session.dsn#">
			insert into CCHHistoricoResponsables(
				CCHid,
				Ecodigo,
				CCHHRresponsabeAnterior,
				CCHHRresponsableNuevo,			
				CCHHRfechaCambio,				
				BMUsucodigo   
			)
			values
			(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idRespAnterior#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(),'DD/MM/YYYY')#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
</cfquery>
<!--------------------->
	<cfquery name="rsMod" datasource="#session.dsn#">
		update CCHica set 
			CCHresponsable =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		where CCHid=#form.CCHid#		
	</cfquery>
	<cflocation url="CambioResponsable.cfm?CCHid=#form.CCHid#">
</cfif>

    <!---Bitacora--->    
<cfif isdefined ('form.Bitacora')>
<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="CambioResponsable.cfm?CCHid=#form.CCHid#"
	FileName="GestionEmpleados.xls"
	title="Histórico de Cambios de Responsable">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT"> 
	
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsBitacora" datasource="#session.dsn#">	
	     	 select 
				    a.CCHid,
					a.CCHHRid,
					a.CCHHRfechaCambio,
					h.CCHcodigo,
					h.CCHdescripcion,
					 u.datos_personales,
					b.DEnombre#LvarCNCT#' '#LvarCNCT#b.DEapellido1#LvarCNCT#' '#LvarCNCT#b.DEapellido2 as CCHresponsableNuevo, 
					c.DEnombre#LvarCNCT#' '#LvarCNCT#c.DEapellido1#LvarCNCT#' '#LvarCNCT#c.DEapellido2 as CCHresponsableAnterior,
					d.Pnombre#LvarCNCT#' '#LvarCNCT#d.Papellido1#LvarCNCT#' '#LvarCNCT#d.Papellido2 as AutorCambio
				from CCHHistoricoResponsables a 
	            inner join DatosEmpleado b 
		             on b.DEid = a.CCHHRresponsableNuevo 
	            inner join DatosEmpleado c
		             on c.DEid = a.CCHHRresponsabeAnterior		
				inner join CCHica h
				     on h.CCHid = a.CCHid
				inner join Usuario u
                     on u.Usucodigo =  a.BMUsucodigo
                inner join  DatosPersonales d
                     on u.datos_personales = d.datos_personales     	 	 
                where a.CCHid = #form.CCHid#
				and a.Ecodigo = #session.Ecodigo#
                order by CCHid			  
	</cfquery>	
	

	
	<table align="center" border="0" cellspacing="3">
	  <tr>
			<td colspan="4" align="center">
				<span class="style1">Soluciones Integrales</span>
			</td>
	  </tr>	  
	  <tr>
		   <td colspan="4" align="center"> 
				<strong>Histórico de Cambios de Responsable</strong> 
		   </td>	   
	  </tr>
	  <tr>
		  <td align="center" colspan="4">
		     <strong>Caja chica: <cfoutput>#rsBitacora.CCHcodigo#-#rsBitacora.CCHdescripcion#</cfoutput></strong>
		  </td>
	  </tr>
	  <tr>
	      <td>
		  </td>
	  </tr>
	  <tr bgcolor="#999999">
	    <td align="center">
            <strong>Responsable Anterior</strong>
	    </td>
	    <td align="center">
		    <strong>Responsable Actual</strong>
	    </td>
		 <td align="center">
		     <strong>Encargado del Cambio</strong>
		 </td>
	    <td align="center">
		     <strong>Fecha de Cambio</strong>
	    </td>		
	  </tr>
	  <cfif #rsBitacora.recordcount# gt 0>
	  <cfoutput>
	  <cfloop query="rsBitacora">
		<tr>
	    <td align="center">
		  #rsBitacora.CCHresponsableAnterior#
	    </td>
	    <td align="center">
		  #rsBitacora.CCHresponsableNuevo#
	    </td>
		 <td align="center">
		   #rsBitacora.AutorCambio#
		 </td>
	    <td align="center">
		  #LsDateFormat(rsBitacora.CCHHRfechaCambio,"dd-mm-YYYY")#
	    </td>		
	  </tr>
	  </cfloop>
	   <tr>
		   <td colspan="4" align="center"> 
				-------------   Fin del Reporte ----------------
		   </td>	   
	  </tr>	
	  </cfoutput>
	<cfelse>
	  <tr>
		   <td colspan="4" align="center"> 
				-------------   No hay registros ----------------
		   </td>	   
	  </tr>	   
	</cfif>
	   
	</table>
	
	
<!---	<cfdump var="#rsBitacora#">--->
	
</cfif>

