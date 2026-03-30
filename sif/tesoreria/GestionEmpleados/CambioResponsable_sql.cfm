<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_TituloHeadHistoricoCambiosResponsable" default = "Hist&oacute;rico de Cambios de Responsable" returnvariable="LB_TituloHeadHistoricoCambiosResponsable" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_GestionEmpleado" default = "GestionEmpleado" returnvariable="LB_GestionEmpleado" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_SolucionesIntegrales" default = "Soluciones Integrales" returnvariable="LB_SolucionesIntegrales" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_CajaChica" default = "Caja Chica" returnvariable="LB_CajaChica" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_ResponsableActual" default = "Responsable Actual" returnvariable="LB_ResponsableActual" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_ResponsableAnterior" default = "Responsable Anterior" returnvariable="LB_ResponsableAnterior" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_EncargadoCambio" default = "Encargado del Cambio" returnvariable="LB_EncargadoCambio" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_FechaCambio" default = "Fecha de Cambio" returnvariable="LB_FechaCambio" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "MSG_FinReporte" default = "Fin del Reporte" returnvariable="MSG_FinReporte" xmlfile = "CambioResponsable_sql.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "MSG_NoHayRegistros" default = "No hay Registros" returnvariable="MSG_NoHayRegistros" xmlfile = "CambioResponsable_sql.xml">


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
	FileName="#LB_GestionEmpleado#.xls"
	title="#LB_TituloHeadHistoricoCambiosResponsable#">

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
				<span class="style1"><cfoutput>#LB_SolucionesIntegrales#</cfoutput></span>
			</td>
	  </tr>	  
	  <tr>
		   <td colspan="4" align="center"> 
				<strong><cfoutput>#LB_TituloHeadHistoricoCambiosResponsable#</cfoutput></strong> 
		   </td>	   
	  </tr>
	  <tr>
		  <td align="center" colspan="4">
		     <strong><cfoutput>#LB_CajaChica#</cfoutput>: <cfoutput>#rsBitacora.CCHcodigo#-#rsBitacora.CCHdescripcion#</cfoutput></strong>
		  </td>
	  </tr>
	  <tr>
	      <td>
		  </td>
	  </tr>
	  <tr bgcolor="#999999">
	    <td align="center">
            <strong><cfoutput>#LB_ResponsableAnterior#</cfoutput></strong>
	    </td>
	    <td align="center">
		    <strong><cfoutput>#LB_ResponsableActual#</cfoutput></strong>
	    </td>
		 <td align="center">
		     <strong><cfoutput>#LB_EncargadoCambio#</cfoutput></strong>
		 </td>
	    <td align="center">
		     <strong><cfoutput>#LB_FechaCambio#</cfoutput></strong>
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
				-------------   <cfoutput>#MSG_FinReporte#</cfoutput> ----------------
		   </td>	   
	  </tr>	
	  </cfoutput>
	<cfelse>
	  <tr>
		   <td colspan="4" align="center"> 
				-------------   <cfoutput>#MSG_NoHayRegistros#</cfoutput> ----------------
		   </td>	   
	  </tr>	   
	</cfif>
	   
	</table>
	
	
<!---	<cfdump var="#rsBitacora#">--->
	
</cfif>

