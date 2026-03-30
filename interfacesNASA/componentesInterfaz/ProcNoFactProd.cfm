<!--- Cuenta los Errores Para indicarlo en el boton de Errores--->


<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and len(url.CodICTS) and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset ETQCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset ETQCodICTS = form.CodICTS>
<cfelse>
	<cfset ETQCodICTS = "">
</cfif>	

<cfif isdefined("ETQCodICTS") and len(ETQCodICTS)>
	<cfquery name="rsNombre" datasource="preicts">
		select min(acct_full_name) as acct_full_name
		from account
		where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#">
	</cfquery>
</cfif>

<cfif isdefined("rsNombre") AND rsNombre.recordcount GT 0>
	<cfset etiquetaT = " #rsNombre.acct_full_name#">
<cfelse>
	<cfset etiquetaT = "">
</cfif>

<cfquery name="Errores" datasource="sifinterfaces">
	select count(*) as TotalErrores
	from PrevIntComprasEnc enc 
    inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
	where mensajeError <>'ok'
     and enc.i_empresa_prop=#ETQCodICTS#
</cfquery>
<cfquery name="FacturasAplicables" datasource="sifinterfaces">
	select count(*) as Facturas
	from PrevIntComprasEnc enc 
    inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
	where mensajeError ='ok'
     and enc.i_empresa_prop=#ETQCodICTS#
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
	  <cf_web_portlet_start titulo="Procesa Documentos NoFact de Producto #etiquetaT#">
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
						<cflocation url="/cfmx/interfacesNASA/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=1&CodICTS=#form.CodICTS#">
					<cfelse>
						<cflocation url="/cfmx/interfacesNASA/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=2&CodICTS=#form.CodICTS#">			
					</cfif>
				</cfif>
				<cflocation url="/cfmx/interfacesNASA/Consultas/SQLNoFactProductosR2.cfm?Regresa=ProcNoFactProd.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
            	<cfquery datasource="sifinterfaces">
					delete from PrevIntComprasDet
                    where i_folio in(select i_folio from PrevIntComprasEnc where i_empresa_prop=#ETQCodICTS#) 
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete from PrevIntComprasEnc
                     where i_empresa_prop=#ETQCodICTS#
				</cfquery> 
                 
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/NoFactProductosParam.cfm">
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
                <cfif FacturasAplicables.facturas GT 0 >
                    <cfquery name="aplicaTransaccion" datasource="preicts">
                         update PmiSoin6Transaction set aplicado_ind = '1' 
                         where  booking_num=#ETQCodICTS#
                         and intfz_trans_id =#Intfz_trans_id.ultimo_numero#
                         and intfz_code ='#IntfzCode#'
                    </cfquery>
                    <cfinclude template="SQLAplicaNoFact.cfm">
                    <cflocation url="/cfmx/interfacesNASA/componentesInterfaz/NoFactProductosParam.cfm">
                <cfelse>
                	<cfthrow message="No hay documentos por aplicar..."    >
                </cfif>    
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores(#varErrores#)">
				<cfif isdefined("url.ModoV")>
					<cfif url.ModoV EQ 1>
						<cflocation url="/cfmx/interfacesNASA/Consultas/SQLNoFactProductosErroresR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=1&CodICTS=#form.CodICTS#">
					<cfelse>
						<cflocation url="/cfmx/interfacesNASA/Consultas/SQLNoFactProductosErroresR2.cfm?Regresa=ProcNoFactProd.cfm&ModoV=2&CodICTS=#form.CodICTS#">			
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnMostrar_Doctos._Costo_Parcial_rev_ICTS">
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/ProcNoFactProd.cfm?ModoV=2&botonsel=nada&CodICTS=#form.CodICTS#">
			<cfelseif form.botonsel EQ "btnOcultar_Doctos._Costo_Parcial_rev_ICTS">
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/ProcNoFactProd.cfm?ModoV=1&botonsel=nada&CodICTS=#form.CodICTS#">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnTerminado">
				<!--- terminado.cfm
				Muestra una leyenda que indica el estado del proceso (Terminado)--->
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/terminado.cfm?Regresa=ProcNoFactProd.cfm">
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
