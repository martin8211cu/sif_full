
<!--- Pinta el encabezado del conjunto de pantallas de importación de cotizaciones --->
<cfif isdefined("form.pantalla") and len(form.pantalla)>
	<cfif form.pantalla EQ "0">
		<cfset titulo = "Lista de Procesos de Compra Publicados">
		<cfset indicacion = "Seleccione el Proceso de Compra con que desea trabajar : ">
	<cfelseif form.pantalla EQ 1>
    	<cfif lvarSolicitante>
        	<cfset titulo = "Cotizaci&oacute;n escogida por el comprador">
			<cfset indicacion = "">
        <cfelse>
			<cfset titulo = "Lista de Cotizaciones importadas del Proceso de Compra">
            <cfset indicacion = "Seleccione la cotización que desea observar : ">
        </cfif>
	<cfelseif form.pantalla EQ 2>
		<cfquery name="rsCotizacion" datasource="#session.dsn#">
			select a.ECid, a.ECnumprov, a.ECdescprov, a.ECobsprov
			from ECotizacionesCM a
			where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		<cfset titulo = "Cotización #rsCotizacion.ECnumprov#: #rsCotizacion.ECdescprov#">
		<cfset indicacion = "#rsCotizacion.ECobsprov#">

	<cfelseif form.pantalla EQ 3>
		<cfquery name="rsCMPdescripcion" datasource="#session.dsn#">
			select 	CMPdescripcion, CMPnumero   
			from 	CMProcesoCompra
			where 	CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">		
		</cfquery>
		<cfset titulo = "Selección del Método de Evaluación">
		<cfset indicacion = "Seleccione el método de evaluación que desea utilizar">
	<cfelseif form.pantalla EQ 4>
		<cfquery name="rsCMPdescripcion" datasource="#session.dsn#">
			select 	CMPdescripcion, CMPnumero   
			from 	CMProcesoCompra
			where 	CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">		
		</cfquery>
		<cfset titulo = "Resultados del Proceso de Evaluación de Cotizaciones">
		<cfset indicacion = "Elección Sugerida">
	<cfelse>
		<cfquery name="rsCMPdescripcion" datasource="#session.dsn#">
			select 	CMPdescripcion , CMPnumero  
			from 	CMProcesoCompra
			where 	CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">		
		</cfquery>
		<cfset titulo = "Formulario de Orden de Compra">
		<cfset indicacion = "Llene el formulario de orden de compra con los datos requeridos">
	</cfif>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td style="padding-left: 10px;" valign="top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="border-bottom: 1px solid black " nowrap>
				<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cfif isdefined("form.pantalla") and isdefined("form.pantalla") and Len(Trim(form.pantalla)) and  form.pantalla EQ 0>
					<img border="0"  src="../../imagenes/number1_64.gif" align="absmiddle">
				<cfelseif isdefined("form.pantalla") and isdefined("form.pantalla") and Len(Trim(form.pantalla)) and  form.pantalla EQ 3>
					<img border="0"  src="../../imagenes/number2_64.gif" align="absmiddle">				
				<cfelseif isdefined("form.pantalla") and isdefined("form.pantalla") and Len(Trim(form.pantalla)) and  form.pantalla EQ 4>
					<img border="0"  src="../../imagenes/number3_64.gif" align="absmiddle">			
				<cfelseif isdefined("form.pantalla") and isdefined("form.pantalla") and Len(Trim(form.pantalla)) and  form.pantalla EQ 5>
					<img border="0"  src="../../imagenes/number4_64.gif" align="absmiddle">			
				</cfif>	 
				#titulo#
				</strong>
				</td>
			  </tr>			 
			  <tr>
			    <td class="tituloPersona" align="left" style="text-align:left" nowrap>#indicacion#</td>
			  </tr>
			  <cfif isdefined("form.pantalla") and isdefined("form.pantalla") and Len(Trim(form.pantalla)) and  form.pantalla EQ 3 or form.pantalla EQ 4 >
			  	<tr>
			  		<td class="ayuda" align="left" nowrap>Proceso de Compra: <font color="##003399"><strong>#rsCMPdescripcion.CMPnumero#&nbsp;-&nbsp;#rsCMPdescripcion.CMPdescripcion#</strong></font></td>
			 </cfif>
			</table>
		</td>
	  </tr>
	</table>
</cfoutput>

<br>