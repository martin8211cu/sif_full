<!---Se realiza para obtener las impresiones de las Facturas de  PMI SES IRR APH  101012--->

<!------>
<!---<cfthrow message="#form.modo#">--->
<cfset varControlFlujo = true>
<cfset varControlFiltro = true>
<cfset varPosteo = true>

<cfif isdefined("form.OImpresionID") and len(trim(form.OImpresionID))>
	<cfif isdefined("form.modo") and form.modo EQ "GUARDA">
		<!--- Revisa los valores para los Form que puedan venir en blanco --->
        <cfif form.OIfecha EQ "">
        	<cfabort showerror="La Fecha no puede contener un valor nulo">
		</cfif>
        <cfif isdefined("form.TipoCambio") and form.TipoCambio EQ "">
        	<cfabort showerror="Especifique un valos para Tipo de Cambio">
		</cfif>

	<cfelseif isdefined("form.modo") and form.modo EQ "IMPRIME">
   
    <cfelseif isdefined("form.modo") and form.modo EQ "CANCELAOI">


		<cfset varControlFiltro = false>
        <cfset varControlFlujo = false>
    <cfelseif isdefined("form.modo") and form.modo EQ "REGISTRA">
		<cfif isdefined("form.ErrorDoc")>

		<cfelse>
			<cfif isdefined("form.DocCxC") and len(trim(form.DocCxC))>
            	<cftransaction>

         
				<cfif rsOIinsert.id_direccionFact EQ "">
                	<cfset varCuenta = rsOIinsert.Ccuenta>
                <cfelse>

                </cfif>

                </cftransaction>
                <cfset From.SNcodigo = "">
                <cfset Form.OIdocumento = "">
                <cfset form.PFDocumento = "">
                <cfset varControlFiltro = false>
				<cfset varControlFlujo = false>
         	</cfif>
	   	</cfif>
	<cfelseif isdefined("form.modo") and form.modo EQ "COPIA">
	</cfif>    
    
    <cfif varControlFlujo>
        <cfinclude template="formFacturaImpresa.cfm">
    <cfelse>
    	<cfinclude template="ListaFacturasImpresas.cfm">	
    </cfif>
<cfelse>
	<cfinclude template="ListaFacturasImpresas.cfm">
</cfif>


