  <cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento") and len(trim(url.IDdocumento))>
	<cfset form.IDdocumento = url.IDdocumento>
				<cfset modoDet = "CAMBIO">

</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset modo = 'Alta'>
<cfset modoDet = 'Alta'><!--- Solo se puede entrar en modo cambio --->
<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
	<cfset modoDet = 'Cambio'>
</cfif>

	<cfquery name="rsEstado" datasource="#Session.DSN#">
		select FTidEstado ,FTcodigo,FTdescripcion
		from EstadoFact
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FTPvalorAutomatico <> 1
	</cfquery>


<cfif modoDet neq 'Alta'>
    <cfquery name="rsDatoFactura" datasource="#session.DSN#">
		select a.BMfecha,
				a.EVid,
				a.EVfactura,
				a.EVestado,
				a.EVObservacion,
				a.EVProveedor from EventosFact a 
		inner join HEDocumentosCP c
		on c.IDdocumento = a.IDdocumento 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.CPTcodigo = 'FA'		
	</cfquery>
</cfif>

	
            
            <cf_navegacion name="IDdocumento" default="" 	navegacion="navegacion">
               <td width="1%">&nbsp;</td>
								<td width="40%" valign="top">
								<cfoutput>
									<fieldset>
									<legend><strong>Evento</strong>&nbsp;</legend>
										<form action="SeguimientoFact_sql.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
									
										
											<table width="60%" align="center" border="0" >
												<tr>
													<td align="right"><strong>Estado:</strong></td>
													<td>
														<select name="Estado" id="Estado" tabindex="1">
															<cfloop query="rsEstado"> 
																<option value="#rsEstado.FTidEstado#"<cfif modo NEQ 'ALTA' and rsEstado.FTidEstado  EQ rsEstado.FTidEstado> selected</cfif>>#rsEstado.FTdescripcion#</option>
															</cfloop>
														</select>
													</td>	
												</tr>		
												<tr>
													<td align="right"><strong>Observaci&oacute;n:</strong></td>
													<td colspan="2">
														<textarea name="EVObservacion" cols="50" rows="5" tabindex="1" value="<cfif modoDet NEQ "ALTA"> hola</cfif>"></textarea>
												</tr>		
												<tr><td colspan="3"></td></tr>
											</table>
												<cf_botones modo="#modoDet#" tabindex="1">

									</form>
									</fieldset>
								</cfoutput>
     

<script language="JavaScript1.2" type="text/javascript">
	function funcRegresar(){
			document.form1.action = 'SeguimientoFact.cfm';
			document.form1.submit();
		}
</script>


  
  

								