

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
<cfset IntfzCode = "CPPFA">
<cf_templateheader title="Procesa Facturas Compra de Producto">
	  <cf_web_portlet_start titulo="Procesa Facturas Compra de Producto #etiquetaT#">

		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfquery name="Intfz_trans_id" datasource="sifinterfaces">
           select ultimo_numero  from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
        </cfquery>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesNASA/Consultas/SQLFacturasProductosR2.cfm?CodICTS=#form.CodICTS#">
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
               
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/FacturasProductosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
                <cfif FacturasAplicables.facturas GT 0 >
                    <cfquery name="aplicaTransaccion" datasource="preicts">
                         update PmiSoin6Transaction set aplicado_ind = '1' 
                         where  booking_num=#ETQCodICTS#
                         and intfz_trans_id =#Intfz_trans_id.ultimo_numero#
                         and intfz_code ='#IntfzCode#'
                    </cfquery>   
                    <!---<cflocation url="SQLAplicaProductos.cfm?Intfz_trans_id=#Intfz_trans_id.ultimo_numero#">--->  
                    <cfinclude template="SQLAplicaProductos.cfm">
                    
                    
                <cfelse>
                	<cfthrow message="No hay documentos por aplicar..."    >
                </cfif>
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores(#varErrores#)">
				<cflocation url="/cfmx/interfacesNASA/Consultas/SQLFacturasProductosErroresR2.cfm?&CodICTS=#form.CodICTS#&Intfz_trans_id=#Intfz_trans_id.ultimo_numero#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnTerminado">
				<!--- terminado.cfm
				Muestra una leyenda que indica el estado del proceso (Terminado)--->
				<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/terminado.cfm?Regresa=ProcFactProd.cfm">
			</cfif>
		</cfif>
		
		<cfif isdefined("Form.generar")>
			<cfinclude template="FacturasProductosA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="FacturasProductosA-lista.cfm"> 

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
