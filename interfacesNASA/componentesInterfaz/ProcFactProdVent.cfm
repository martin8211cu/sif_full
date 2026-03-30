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
	from PrevIntVentasEnc enc 
    inner join PrevIntVentasDet det on enc.voucher_num=det.voucherNum
	where mensajeError <>'ok'
    and voucher_book_comp_num = #ETQCodICTS#
    and invoiceType in  ('F','G','K','p','R','W','w','P')
</cfquery>
<cfquery name="FacturasAplicables" datasource="sifinterfaces">
	select count(*) as Facturas
	from PrevIntVentasEnc enc 
    inner join PrevIntVentasDet det  on enc.voucher_num=det.voucherNum
	where mensajeError ='ok'
    and voucher_book_comp_num = #ETQCodICTS#
    and invoiceType in  ('F','G','K','p','R','W','w','P')
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
<cfset IntfzCode = "CCPFA">
<cf_templateheader title="Procesa Facturas Venta de Producto">
  <cf_web_portlet_start titulo="Procesa Facturas Venta de Producto #etiquetaT#">

	<cfinclude template="/sif/portlets/pNavegacion.cfm">			
	<cfquery name="Intfz_trans_id" datasource="sifinterfaces">
           select ultimo_numero  from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
        </cfquery>		
	<cfif isdefined("Form.botonsel")>
		<cfif form.botonsel EQ "btnImprimir">
			<cflocation url="/cfmx/interfacesNASA/Consultas/SQLFacturasProdVentasR2.cfm?CodICTS=#form.CodICTS#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.botonsel")>
		<cfif form.botonsel EQ "btnRegresar">
        	<cfquery datasource="sifinterfaces">
				delete from PrevIntVentasDet where voucherNum in (select voucher_num from PrevIntVentasEnc 
                where  voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#"> 
                and invoiceType in  ('F','G','K','p','R','W','w','P'))                
			</cfquery>  
			<cfquery datasource="sifinterfaces">
					delete from PrevIntVentasEnc 
                    where  voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#">
                    and invoiceType in  ('F','G','K','p','R','W','w','P')
				</cfquery> 
                
			<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/FacturasProdVentasParam.cfm">
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
        
					<cfinclude template="SQLAplicaProdVentas.cfm">
            <cfelse>
                	<cfthrow message="No hay documentos por aplicar..."    >
            </cfif>        
		</cfif>
	</cfif>
	<cfif isdefined("Form.botonsel")>
		<cfif form.botonsel EQ "btnImprimir">
			<cflocation url="/cfmx/interfacesPMI/Consultas/SQLProductosR2_Pre.cfm">
		</cfif>
	</cfif>
	<cfif isdefined("Form.botonsel")>
		<cfif form.botonsel EQ "btnErrores(#varErrores#)">
				<cflocation url="/cfmx/interfacesNASA/Consultas/SQLFacturasProdVentasErroresR2.cfm?CodICTS=#form.CodICTS#">
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.botonsel")>
		<cfif form.botonsel EQ "btnTerminado">
			<!--- terminado.cfm
			Muestra una leyenda que indica el estado del proceso (Terminado)--->
			<cflocation url="/cfmx/interfacesNASA/componentesInterfaz/terminado.cfm?Regresa=ProcFactProdVent.cfm">
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.generar")>
		<cfinclude template="FacturasProdVentasA-sql.cfm">
	</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top" width="50%">
					<cfinclude template="FacturasProdVentasA-lista.cfm">
				</td>
			</tr>
		</table>
  <cf_web_portlet_end>
<cf_templatefooter>


