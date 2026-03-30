<cfif isdefined('url.dato') and url.dato NEQ '' and
	isdefined('url.oficina') and url.oficina NEQ '' and 
	isdefined('url.moneda') and url.moneda NEQ '' and 
	isdefined('url.tipo') and url.tipo NEQ ''>
	
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		Select Miso4217
		from Monedas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
	</cfquery>

	<cfif isdefined('rsMoneda') and rsMoneda.recordCount GT 0>
		<cfif url.Tipo EQ 'A'>	<!--- Articulo --->
			<cfif isdefined('url.bodega') and url.bodega NEQ ''>
				<cfquery name="rsFA_Trae_Precio" datasource="#session.DSN#">
					exec FA_Trae_Precio
					  @Tipo  = 'A'
					, @Concepto = null
					, @CodigoArt = '#url.dato#'
					, @CodigoBod = '#url.bodega#'
					, @Ocodigo = #url.oficina#
					, @Moneda = '#rsMoneda.Miso4217#'
					, @Ecodigo = #session.Ecodigo#
					, @SNcodigo = NULL
				</cfquery>
			<cfelse>
				<cfquery name="rsFA_Trae_Precio" datasource="#session.DSN#">
					exec FA_Trae_Precio
					  @Tipo  = 'A'
					, @Concepto = null
					, @CodigoArt = '#url.dato#'
					, @CodigoBod = null
					, @Ocodigo = #url.oficina#
					, @Moneda = '#rsMoneda.Miso4217#'
					, @Ecodigo = #session.Ecodigo#
					, @SNcodigo = NULL
				</cfquery>			
			</cfif>
		<cfelseif url.Tipo EQ 'C'>	<!--- Conceptos --->
			<cfquery name="rsFA_Trae_Precio" datasource="#session.DSN#">
				exec FA_Trae_Precio
				  @Tipo  = 'S'
				, @Concepto = #url.dato#
				, @CodigoArt = null
				, @CodigoBod = null
				, @Ocodigo = #url.oficina#
				, @Moneda = '#rsMoneda.Miso4217#'
				, @Ecodigo = #session.Ecodigo#
				, @SNcodigo = NULL
			</cfquery>	
		</cfif>
	</cfif>
</cfif>

<cfif isdefined('rsFA_Trae_Precio') and rsFA_Trae_Precio.recordCount GT 0>
	<cfif rsFA_Trae_Precio.CodImpuesto NEQ ''>
		<cfquery name="rsImpuestos" datasource="#Session.DSN#">
			select Icodigo,Idescripcion,Iporcentaje
			from Impuestos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsFA_Trae_Precio.CodImpuesto#">
		</cfquery>	
	</cfif>
	
	<script language="JavaScript">
		window.parent.document.<cfoutput>#url.form#.#url.preciou#</cfoutput>.value="<cfoutput>#rsFA_Trae_Precio.preciou#</cfoutput>";
		<cfif isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0>
			window.parent.document.<cfoutput>#url.form#.#url.codImpuesto#</cfoutput>.value="<cfoutput>#trim(rsImpuestos.Icodigo)#</cfoutput>";		
			window.parent.document.<cfoutput>#url.form#.#url.desImpuesto#</cfoutput>.value="<cfoutput>#trim(rsImpuestos.Idescripcion)#</cfoutput>";				
			window.parent.document.<cfoutput>#url.form#.#url.porcenImpuesto#</cfoutput>.value="<cfoutput>#rsImpuestos.Iporcentaje#</cfoutput>";							
		</cfif>		
		window.parent.document.<cfoutput>#url.form#.#url.almacen#</cfoutput>.value="<cfoutput>#trim(rsFA_Trae_Precio.bodega)#</cfoutput>";		
		if (window.parent.calcDescTotal) {window.parent.calcDescTotal();}		
	</script>
<cfelse>
	<script language="JavaScript">
		window.parent.document.<cfoutput>#url.form#.#url.preciou#</cfoutput>.value="0.00";
		window.parent.document.<cfoutput>#url.form#.#url.codImpuesto#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desImpuesto#</cfoutput>.value="";		
		window.parent.document.<cfoutput>#url.form#.#url.porcenImpuesto#</cfoutput>.value="0.00";									
		window.parent.document.<cfoutput>#url.form#.#url.monDesc#</cfoutput>.value="0.00";		
		window.parent.document.<cfoutput>#url.form#.#url.TotLin#</cfoutput>.value="0.00";	
	</script>
</cfif>
