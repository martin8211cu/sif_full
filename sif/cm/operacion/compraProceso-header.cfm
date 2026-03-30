<!--- Pantalla --->
<cfif isdefined("Session.Compras.ProcesoCompra") and isdefined("Session.Compras.ProcesoCompra.Pantalla") and Len(Trim(Session.Compras.ProcesoCompra.Pantalla)) NEQ 0>
	<cfif Session.Compras.ProcesoCompra.Pantalla EQ "1">
		<cfset titulo = "Solicitudes de Compra">
		<cfset indicacion = "Seleccione los itemes de compra que desea incluir en el proceso de compra">
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "2">
		<cfif isdefined("Form.btnNotas")>
			<cfset titulo = "Cat&aacute;logo de Notas">
		<cfelse>
			<cfset titulo = "Proceso de Compra">
		</cfif>
		<cfset indicacion = "Llene el formulario del proceso de compra con los datos requeridos">
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "3">
		<cfset titulo = "Invitaci&oacute;n a Proveedores">
		<cfset indicacion = "Seleccione los proveedores que desea invitar a participar en esta compra">
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "4">
		<!--- Lee parametro de Publicacion --->
		<cfquery name="rsPublica" datasource="#session.DSN#">
			select Pvalor 
			from Parametros 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and Pcodigo=570
		</cfquery>
		<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
			<cfset titulo = "Publicaci&oacute;n de Compra">
			<cfset indicacion = "Verifique que los datos de la compra estén correctos antes de proceder a publicarla">
		<cfelse>
			<cfset titulo = "Resumen de Proceso de Compra">
			<cfset indicacion = "Verifique que los datos de la compra estén correctos antes de proceder a guardarlos">
		</cfif>	
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "5">
		<cfset titulo = "Cotizaci&oacute;n Manual">
		<cfset indicacion = "Registre una nueva cotización para este Proceso de Compra">
	<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "6">
		<cfset titulo = "Importaci&oacute;n de Cotizaciones">
		<cfset indicacion = "Seleccione una línea para ver la cotización asociada">
	<cfelse>
		<cfset titulo = "Lista de Procesos de Compra pendientes de publicar">
		<cfset indicacion = "Seleccione un Proceso de Compra">
	</cfif>
</cfif>

<cfif modo EQ "CAMBIO">

	<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid)) GT 0>

        <cfquery name="rsDatosProceso" datasource="#Session.DSN#">
            select CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas
            from CMProcesoCompra
            where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
   
    
        <cfquery name="rsEstadoAct" datasource="#Session.DSN#">
            select CMNtipo
            from CMNotas
            where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
            and CMNestado = 1		
        </cfquery>
    
    </cfif>
    
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td width="1%" align="right">
			<!--- El logo no sale cuando se entra al catálogo de notas --->
		  <cfif not isdefined("Form.btnNotas")>
			<cfif isdefined("Session.Compras.ProcesoCompra") and isdefined("Session.Compras.ProcesoCompra.Pantalla") and Len(Trim(Session.Compras.ProcesoCompra.Pantalla)) and Session.Compras.ProcesoCompra.Pantalla EQ "0">
				&nbsp;
			<cfelseif isdefined("Session.Compras.ProcesoCompra") and isdefined("Session.Compras.ProcesoCompra.Pantalla") and Len(Trim(Session.Compras.ProcesoCompra.Pantalla))>
				<img border="0" src="/cfmx/sif/imagenes/number#Session.Compras.ProcesoCompra.Pantalla#_64.gif" align="absmiddle">
			<cfelse>
				&nbsp;
			</cfif>
		  <cfelse>
		  	&nbsp;
		  </cfif>
		</td>
		<td style="padding-left: 10px;" valign="top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
			  </tr>
			<!--- La indicacion no sale cuando se entra al catálogo de notas --->
			  <cfif not isdefined("Form.btnNotas")>
			  <tr>
			    <td class="tituloPersona" align="left" style="text-align:left" nowrap>#indicacion#</td>
			  </tr>
			  </cfif>
			<cfif modo EQ "CAMBIO" and isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla NEQ 0>
			  <tr>
			    <td class="ayuda" align="left" nowrap>Modificando: <font color="##003399"><strong><cfif rsDatosProceso.CMPnumero NEQ ''>#rsDatosProceso.CMPnumero#&nbsp;-<cfelse>&nbsp;</cfif>&nbsp;#rsDatosProceso.CMPdescripcion#</strong></font><cfif isdefined('rsEstadoAct.CMNtipo')><strong>- (#rsEstadoAct.CMNtipo#)</strong></cfif></td>
			  </tr>
			</cfif>
			</table>
		</td>
	  </tr>
	</table>
</cfoutput>
