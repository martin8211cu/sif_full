<cfoutput>
<cfif isdefined("form.linea") and len(trim(form.linea)) and form.modo eq "CAMBIO">
	 <cfif form.cantidad lt 0>
		<cfthrow message="La cantidad no puede ser menor a 0">
	 </cfif>
	 <cfset Total = form.cantidad * form.precioU>
	 <cfquery name="rsUpdate" datasource="#session.dsn#">
		update DOrdenCM set DOcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#form.cantidad#">,
		DOtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#Total#">  
		where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.linea#">
	 </cfquery>
	 <cfset calculaMonto(form.orden)>
		<script language="javascript">
			  window.opener.location.reload(true);
			  window.close();
		</script>
<cfelseif isdefined("url.linea") and len(trim(url.linea)) and url.modo eq "BAJA">  
     <cfquery name="rsEliminarLinea" datasource="#session.dsn#">
	 delete DOrdenCM where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.linea#">
	 </cfquery>
	 <cfset calculaMonto(url.orden)>
	  <script language="javascript">
	    window.location.href = "ordenCompra.cfm?eoidorden="+#url.orden#;
	  </script>	 
</cfif>
<cffunction name="calculaMonto" access="public" output="no">
	<cfargument name="EOidorden" required="yes" type="numeric">
	<cfargument name="Ecodigo" required="no" type="numeric" default="#session.Ecodigo#">

	<cfinvoke 	component	= "sif.Componentes.CM_AplicaOC"
				method		= "calculaTotalesEOrdenCM"

				ecodigo="#Arguments.Ecodigo#"
				eoidorden="#Arguments.EOidorden#"
	/>
</cffunction>
</cfoutput>
