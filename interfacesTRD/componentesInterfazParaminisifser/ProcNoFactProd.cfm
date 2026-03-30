<!--- Cuenta los Errores Para indicarlo en el boton de Errores--->
<cfquery name="Errores" datasource="sifinterfaces">
	select count(MensajeError) as TotalErrores
		from nofactProdPMI a1
		where MensajeError is not null
		and sessionid=#session.monitoreo.sessionid#
</cfquery>
<cfif Errores.TotalErrores NEQ "">
	<cfset varErrores = Errores.TotalErrores>
<cfelse>
	<cfset varErrores = 0>
</cfif>

<!--- Variable de Boton presionado --->
<cfif IsDefined('url.botonsel') and Len(url.botonsel) NEQ 0>
	<cfset Form.botonsel = url.botonsel>
</cfif>

<cf_templateheader title="Procesa Documentos NoFact de Producto">
	  <cf_web_portlet_start titulo="Procesa Documentos NoFact de Producto">
		<cfif isdefined("url.ModoV")>
			<cfif url.ModoV EQ 2>
				<cfset Mvista = 2>
			</cfif>
		</cfif>
			
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cfif isdefined("url.ModoV")>
					<cfif url.ModoV EQ 1>
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=1">
					<cfelse>
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=2">			
					</cfif>
				</cfif>
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from nofactProdPMI where sessionid = #session.monitoreo.sessionid#
					<!---delete from PMICOMP_ID10 where sessionid = #session.monitoreo.sessionid#--->
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/NoFactProductosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfif isdefined("url.ModoV")>
					<cfif url.ModoV EQ 2>
						<cfset ModoA = 2>
					<cfelse>
						<cfset ModoA = 1>
					</cfif>
				</cfif>
				<cfinclude template="SQLAplicaNoFact.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/NoFactProductosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores(#varErrores#)">
				<cfif isdefined("url.ModoV")>
					<cfif url.ModoV EQ 1>
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLNoFactProductosErroresR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=1">
					<cfelse>
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLNoFactProductosErroresR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=2">			
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnMostrar_Doctos._Costo_Parcial_rev_ICTS">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/ProcNoFactProd.cfm?ModoV=2&botonsel=nada">
			<cfelseif form.botonsel EQ "btnOcultar_Doctos._Costo_Parcial_rev_ICTS">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/ProcNoFactProd.cfm?ModoV=1&botonsel=nada">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnTerminado">
				<!--- terminado.cfm
				Muestra una leyenda que indica el estado del proceso (Terminado)--->
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/terminado.cfm?Regresa=ProcNoFactProd.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.generar")>
			<cfinclude template="NoFactProductosA-sql.cfm">
			<cfset Mvista = 1>
			<!--- Mvista = 1 No Incluye Documentos con costos Erroneos --->
 			<!--- Mvista = 2 Incluye Documentos con costos Erroneos --->
		</cfif>
		
		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">
		<cfinclude template="NoFactProductosA-lista.cfm">

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
