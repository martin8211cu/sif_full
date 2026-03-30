<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Trasladar"
	Default="Trasladar"
	returnvariable="LB_Trasladar"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Regresar"
	Default="Regresar"
	returnvariable="LB_Regresar"/> 	
	
<cfquery name="rstraslado" datasource="#session.DSN#">	
	select c.CIcodigo,c.CIdescripcion,importe from  
		RHLiqIngresos a
		inner join RHTransferIncidencia b
			on a.CIid = b.CIidEmpOrigen
			and  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		inner join CIncidentes c
			on a.CIid = c.CIid	 
	where a.DLlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
</cfquery>

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	a.CIidEmpOrigen
			,ltrim(rtrim(b.CIcodigo)) as cod_origen
			,b.CIdescripcion as origen_des
			,ltrim(rtrim(c.CIcodigo)) as cod_destino
			,c.CIdescripcion as destino_des
			,ltrim(rtrim(d.CIcodigo)) as cod_equivalencia
			,d.CIdescripcion  as equivalencia_des
	from RHTransferIncidencia a
		inner join CIncidentes b
			on a.CIidEmpOrigen = b.CIid
		inner join CIncidentes c
			on a.CIidEmpDestino = c.CIid
		inner join CIncidentes d
			on a.CIidEquivalencia = d.CIid	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
	<form style="margin:0" name="form1" method="post" action="liquidacionTrasnsfer-sql.cfm">
		<input name="DLlinea" type="hidden" value="<cfif isdefined("form.DLlinea")and (form.DLlinea GT 0)><cfoutput>#form.DLlinea#</cfoutput></cfif>">

		
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<fieldset><legend><cf_translate  key="LB_Equivalencia_de_Conceptos_Entre_Empresas">Equivalencia de Conceptos Entre Empresas</cf_translate></legend>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr class="areaFiltro">
								<td align="left" colspan="2"><b><cf_translate  key="LB_Concepto_Origen">Concepto Origen</cf_translate></b></td>
								<td align="left" colspan="2"><b><cf_translate  key="LB_Concepto_Equivalencia">Concepto Equivalencia</cf_translate></b></td>
								<td align="left" colspan="2"><b><cf_translate  key="LB_Concepto_Destino">Concepto Destino</cf_translate></b></td>
							</tr>
							<cfif rsLista.recordCount GT 0>
								<cfloop query="rsLista">
									<tr">
										<td align="left" colspan="1">#rsLista.cod_origen#</td>
										<td align="left" colspan="1">#rsLista.origen_des#</td>
										<td align="left" colspan="1">#rsLista.cod_equivalencia#</td>
										<td align="left" colspan="1">#rsLista.equivalencia_des#</td>
										<td align="left" colspan="1">#rsLista.cod_destino#</td>
										<td align="left" colspan="1">#rsLista.destino_des#</td>
										
										
									</tr>
								
								</cfloop>
							</cfif>	

						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<fieldset><legend><cf_translate  key="LB_Conceptos_a_ Trasladar">Conceptos a Trasladar</cf_translate></legend>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr class="areaFiltro">
								<td><b><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></b></td>
								<td><b><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></b></td>
								<td align="right"><b><cf_translate  key="LB_Monto">Monto</cf_translate></b></td>
							</tr>
							<cfif rstraslado.recordCount GT 0>
								<cfset total_traslado = 0>
								<cfloop query="rstraslado">
									<tr>
										<td>#rstraslado.CIcodigo#</td>
										<td>#rstraslado.CIdescripcion#</td>
										<td align="right">#LSNumberFormat(rstraslado.importe,',.00')#</td>
									</tr>	
									<cfset total_traslado = total_traslado + rstraslado.importe>						
								</cfloop>
								<tr>
									<td colspan="3"><hr/></td>
								</tr>
								
								<tr>
									<td><b><cf_translate  key="LB_Total">Total</cf_translate></b></td>
									<td>&nbsp;</td>
									<td align="right">#LSNumberFormat(total_traslado,',.00')#</td>
								</tr>
							</cfif>
							
						</table>					
					</fieldset>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<td width="10%"><b>
						  <cf_translate  key="LB_Tipo_Cambio">Tipo Cambio</cf_translate></b></td>
						<td><cf_monto name="tipo_cambio" decimales="2" size="15" value="1.00"></td>
						
					</table>
				</td>
			</tr>
			<tr>
				<td align="center">
					<input 
							type="submit" 
							name="btnAplicar" 
							class="btnAplicar" 
							value="#LB_Trasladar#" 
							tabindex="0">
					<input 
							type="button" 
							name="btnRegresar" 
							class="btnAnterior" 
							value="#LB_Regresar#" 
							onclick="javascript:func_Regresar()"
							tabindex="0">		
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	function func_Regresar(){
		location.href = 'liquidacionTrasnsfer.cfm';

	}
</script>