<!--- Estado del combo --->
<cfquery name="rsEstado" datasource="#Session.DSN#">
	select b.FTidEstado,b.FTcodigo,b.FTdescripcion,b.FTPvalorAutomatico
		from EstadoFact b
	where FTPvalorAutomatico =  0 
		or b.FTidEstado = (select c.FTidEstado 
									 from EstadoFact  c 
									 	inner join  EDocumentosCxP a
											on c.FTidEstado = a.EVestado 
											where a.SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
											  and a.EDdocumento  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
											  and a.CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CPTcodigo)#">
											  and a.Ecodigo     = #session.Ecodigo#
								)
</cfquery>

<!---Listado del seguimiento--->
<cfquery datasource="#session.dsn#" name="listaDetAnt">
		select 
			c.IDdocumento ,
			c.CPTcodigo	,
			a.SNcodigo ,
			u.Usulogin,
			e.FTfolio as folio,
			e.FTPvalorAutomatico as Automatico,
			e.FTdescripcion as estado,
			c.CPTcodigo,
			e.FTdescripcion,
			a.BMfecha,
			a.EVid,
			a.EVfactura,
			a.EVestado,
			a.EVObservacion 
		from EventosFact a 
			inner join HEDocumentosCP c
				on  c.Ddocumento = a.EVfactura 
				and c.Ecodigo 	  = a.Ecodigo
				and c.SNcodigo   = a.SNcodigo
				and c.CPTcodigo  = a.CPTcodigo
			inner join EstadoFact e
				on e.FTidEstado  = a.EVestado
			inner join Usuario u
				on a.BMUsucodigo = u.Usucodigo
		where c.SNcodigo       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		  and c.Ddocumento     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
		  and c.CPTcodigo	     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigo#">
		  and c.Ecodigo        = #session.Ecodigo#

		union all 

		select 
			c.IDdocumento ,
			c.CPTcodigo	,
			a.SNcodigo ,
			u.Usulogin,
			e.FTfolio as folio,
			e.FTPvalorAutomatico as Automatico,
			e.FTdescripcion as estado,
			c.CPTcodigo,
			e.FTdescripcion,
			a.BMfecha,
			a.EVid,
			a.EVfactura,
			a.EVestado,
			a.EVObservacion
		from EventosFact a 
			inner join EDocumentosCxP c
				on c.EDdocumento = a.EVfactura 
				and c.Ecodigo 	  = a.Ecodigo
				and c.SNcodigo   = a.SNcodigo
				and c.CPTcodigo  = a.CPTcodigo
			inner join EstadoFact e
				on e.FTidEstado = a.EVestado
			inner join Usuario u
				on a.BMUsucodigo = u.Usucodigo
		where c.Ecodigo     = #session.Ecodigo#
	     and c.CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigo#">
	     and c.EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
	     and c.SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
	</cfquery>


<cfif modoDep NEQ 'ALTA'>
<!---PRINCIPAL--->
	<cfquery datasource="#session.dsn#" name="rsFormAntD">
			select a.BMfecha,
				d.FTPvalorAutomatico as Automatico,
				a.EVid,
				a.EVfactura,
				a.EVestado as EVestado,
				a.EVObservacion 
			from EventosFact a 
				inner join HEDocumentosCP c
					on c.Ddocumento = a.EVfactura 
				inner join EstadoFact d
					on d.FTidEstado = a.EVestado 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.EVid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVid#">	
			
			union all
			
			select a.BMfecha,
				d.FTPvalorAutomatico as Automatico,
				a.EVid,
				a.EVfactura,
				a.EVestado as EVestado,
				a.EVObservacion
			from EventosFact a 
				inner join EDocumentosCxP c
					on c.EDdocumento = a.EVfactura 
				inner join EstadoFact d
					on d.FTidEstado = a.EVestado 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.EVid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVid#">	
	</cfquery>
</cfif>
	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="50%">
			<table width="100%" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2"><hr></td>						
				</tr>
				<tr>
					<td align="left" valign="top" width="80%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
							query="#listaDetAnt#"
							desplegar="FTdescripcion,EVObservacion,BMfecha,Usulogin"
							etiquetas="Estado, Observación, Fecha,Usuario"
							formatos="S,S,D,S"
							align="left,left,left,left"
							ira="SeguimientoFact_form.cfm?#param#"
							showEmptyListMsg="yes"
							keys="EVid"
							maxRows="15"
							formName="formAntDLista"
							PageIndex="1"
							botones="Regresar"
							usaAJAX = "yes"
							conexion = "#session.dsn#"
							checkboxes="Y"
						 />
					</td>
					<td align="left" valign="top" width="20%"></td></tr>
			</table>
		</td>
		<td valign="top" width="50%">
			<cfoutput>
			<form action="SeguimientoFact_sql.cfm" method="post" name="formAntD" id="formAntD">
				<input type="hidden" name="modoDep" 	id="modoDep"  	value="#modoDep#" />
				<input type="hidden" name="EVid" 		id="EVid" 		value="<cfif isdefined('form.EVid')>#form.EVid#</cfif>"/>
				<input type="hidden" name="CPTcodigo" 	id="CPTcodigo" value="<cfif isdefined('form.CPTcodigo')>#form.CPTcodigo#</cfif>"/>
				<input type="hidden" name="factura" 	id="factura" 	value="<cfif isdefined('form.factura')>#form.factura#</cfif>"/>
				<input type="hidden" name="SNcodigo" 	id="SNcodigo" 	value="<cfif isdefined('form.SNcodigo')>#form.SNcodigo#</cfif>"/>
				
			<table width="100%" align="right" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" valign="top"><hr></td>						
				</tr>
				<tr>
					<td nowrap="nowrap" align="right"  valign="top"><strong>Estado:</strong> </td>
					<td>
						<cfif isdefined ('form.FTidEstado') and form.FTidEstado eq 4>
						&nbsp;#form.des_estado#
						<cfelse>
						<cfif modo NEQ 'ALTA' and rsDatoFactura.EVestado neq 4>
							<select name="Estado" id="Estado" tabindex="1">
								<cfloop query="rsEstado"> 
									<option value="#rsEstado.FTidEstado#"<cfif modo NEQ 'ALTA' and rsEstado.FTidEstado  EQ rsDatoFactura.EVestado> selected</cfif>>#rsEstado.FTdescripcion#</option>
								</cfloop>
							</select>
							<cfelse>
							&nbsp;#rsDatoFactura.estado#
							</cfif>
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td nowrap="nowrap" align="right" valign="top"><strong>Observaci&oacute;n: </strong> </td>
					<td>
						<textarea name="EVObservacion1" id="EVObservacion1" tabindex="1" rows="5" cols="40"><cfif modoDep NEQ 'ALTA'>#rsFormAntD.EVObservacion#</cfif></textarea>	
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>	   
				<tr>
					<td colspan="4" class="formButtons">
						<cf_botones sufijo='Det' modo='#modoDep#' exclude="Baja,Cambio" tabindex="2">		
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				</table>
			</form>
		</cfoutput>	
		</td>
	</tr>
</table>

	<cf_qforms objForm="objForm2" form="formAntD">
		<cf_qformsRequiredField name="EVObservacion1" 	description="Observación">
	</cf_qforms>	

<script language="JavaScript1.2" type="text/javascript">
	function funcRegresar(){
			document.formAntDLista.action = 'SeguimientoFact.cfm';
			document.formAntDLista.submit();
		}
		
		function funcAltaDet(){
			objForm2.EVObservacion1.description = "Observación";
			objForm2.EVObservacion1.required = true;
	 	} 		
</script>

