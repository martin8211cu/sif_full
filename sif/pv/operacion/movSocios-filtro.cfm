<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
<table width="100%" border="0" >
<cfif NOT isdefined("form.TraeAdelantos")>
	<tr>
		<td>
			<cfoutput>
				<form action="" method="post" name="form1" style="margin:0" onsubmit="javascript:return validar();">
					<table width="100%" border="0" cellspacing="3" cellpadding="3"  class="areaFiltro" style="margin:0">
						<tr>
							<td nowrap="nowrap" class="fileLabel">
								Cliente Origen:&nbsp;
							</td>
							<td nowrap="nowrap" width="100%">
								<cf_sifClienteDetCorp form='form1'>
							</td>
							<td></td>
						</tr>
						<tr>
							<td nowrap="nowrap" class="fileLabel">
								Documento:&nbsp;
							</td>
							<td nowrap="nowrap" width="100%">
								<input type="text" name="FAX14DOC" size="20" maxlength="12" value="" />
							</td>
							<td>
								<!--- Debe válidar CDCcodigo en el onSubmit --->
								<cf_botones values = "Traer Adelantos" names = "TraeAdelantos">
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>
		</td>
	</tr>
	<script language="javascript1.2" type="text/javascript">
		function validar(){
			var continuar = false;
			
			if( document.form1.CDCcodigo.value != '' ){
				continuar = true;
			}
			
			if( document.form1.FAX14DOC.value != '' ){
				continuar = true;
			}
			
			if ( !continuar ){
				alert('Se presentaron los siguientes errores\n - Debe seleccionar el Cliente o el Documento que desea procesar.');
				return false
			}
			return true;
		
		}
	</script>	


</cfif>

<!--- se filtro para obtener datos --->
<cfif isdefined("form.TraeAdelantos")>
	<cfset vCodCliente = 0 >
	<cfset vCliente = '' >
	<cfset vDocumento = 'Todos' >
	<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) >
		<cfset vCodCliente = form.CDCcodigo >
		<cfquery name="cliente" datasource="#session.DSN#">
			select CDCidentificacion, CDCnombre
			from ClientesDetallistasCorp
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
		</cfquery>
		<cfset vCliente = trim(cliente.CDCidentificacion) & ' - ' &cliente.CDCnombre >
	</cfif>

	<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC)) >
		<cfset vDocumento = form.FAX14DOC >
		<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) eq 0>
			<cfquery name="cliente" datasource="#session.DSN#">
				select distinct c.CDCcodigo, c.CDCnombre, c.CDCidentificacion	
				from FAX014 a 
					inner join ClientesDetallistasCorp c
					 on c.CDCcodigo = a.CDCcodigo			
					and c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					
					inner join FAX001 d
					 on d.FAX01NTR = a.FAX01NTR
					and d.Ecodigo = a.Ecodigo
					and d.FAX01STA in ('T','C')				
					
					left outer join FATiposAdelanto b
					on b.IdTipoAd = a.IdTipoAd
					
				where a.FAX14MON > a.FAX14MAP
				  and a.FAX14STS = '1'
				  and a.FAX14TDC in ('AD','NC')
				  and a.FAX14CLA in ('1','2')		  
				  and a.FAX14DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX14DOC#">
			</cfquery>
			
			<cfif cliente.recordcount gt 0>
				<cfset vCliente = trim(cliente.CDCidentificacion) & ' - ' &cliente.CDCnombre >
				<cfset vCodCliente = cliente.CDCcodigo >
			</cfif>
		</cfif>
	</cfif>

	<cfoutput>
	<tr>
		<td>
			<table width="100%" align="center" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr><td colspan="2"><strong>Selecci&oacute;n de NC/Adelantos por Trasladar</strong></td></tr>
				<tr><td nowrap="nowrap" width="1%"><strong>Cliente Origen:&nbsp;</strong></td><td>#vCliente#</td></tr>
				<tr><td><strong>Documento:&nbsp;</strong></td><td>#vDocumento#</td></tr>
			</table>
		</td>
	</tr>
	</cfoutput>	
	
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLista" datasource="#session.DSN#" >
        select  a.FAX14CON,
                a.FAX14DOC,
				case when a.IdTipoAd is null then a.FAX14TDC
					 else ltrim(rtrim(b.CodInterno)) #_Cat# '  ' #_Cat# ltrim(rtrim(b.Descripcion))
				end as Tipo,
				a.FAX14FEC as Fecha, 
				(	select ltrim(rtrim(x.FAM01CODD))#_Cat#' / '#_Cat#rtrim(ltrim(y.Oficodigo)) 
					from FAM001 x, Oficinas y 
					where x.Ecodigo =  a.Ecodigo 
					  and x.FAM01COD = a.FAM01COD
					  and x.Ecodigo = y.Ecodigo 
					  and x.Ocodigo = y.Ocodigo ) as CajaOficina,
				(	select Miso4217 
					from Monedas 
					where Mcodigo = a.Mcodigo) as Moneda, 
				coalesce(a.FAX14MON, 0) as MontoAdelanto, 
				coalesce(a.FAX14MAP,0) as MontoAplicado,
				coalesce(a.FAX14MON - a.FAX14MAP, 0) as MontoDisponible,
				c.CDCcodigo as CodClienteOrigen,
				c.CDCnombre as NombreClienteOrigen,
				c.CDCidentificacion as IdClienteOrigen	

			from FAX014 a 

				inner join ClientesDetallistasCorp c
				on c.CDCcodigo = a.CDCcodigo			

				inner join FAX001 d
				 on d.FAX01NTR = a.FAX01NTR
				and d.Ecodigo  = a.Ecodigo
				and d.FAX01STA in ('T','C')
            
				left outer join FATiposAdelanto b
				on b.IdTipoAd = a.IdTipoAd
			
			where a.FAX14MON > a.FAX14MAP
			  and a.FAX14STS = '1'
			  and a.FAX14TDC in ('AD','NC')
			  and a.FAX14CLA in ('1','2')		  

        	<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
				and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
			<cfelseif isdefined("vCodCliente")	and vCodCliente neq 0 >
				and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCodCliente#">
			</cfif>
			
			<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC))>
				and a.FAX14DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX14DOC#">
			</cfif>	
		
		order by Moneda, FAX14DOC, Tipo	
	</cfquery>		

	<cfif rsLista.recordcount gt 0 >
		<form action="movSocios-confirmar.cfm" name="form1" method="post" onsubmit="javascript: return validar();" style="margin:0;" >
		<tr>
			<td>
				<cfoutput>
				<table>
					<tr>
						<td nowrap="nowrap" width="1%"><strong>Socio Destino:</strong></td>
						<td >
							<cfset idquery = -1 >
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cfset idquery = form.SNcodigo >
							</cfif>	
							<cf_sifsociosnegocios2 idquery="#idquery#" tabindex="1" >
						</td>
					</tr>

					<cfquery name="rsTransacciones" datasource="#session.DSN#"	>
						select CCTcodigo, CCTdescripcion 
						from CCTransacciones
						where CCTpago = 1
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by CCTcodigo
					</cfquery>
					<tr>
						<td nowrap="nowrap" width="1%"><strong>Tipo de Transacci&oacute;n:</strong></td>
						<td >
							<select name="CCTcodigo" >
								<option value=""></option>
								<cfloop query="rsTransacciones">
									<option value="#rsTransacciones.CCTcodigo#" <cfif isdefined("form.CCTcodigo") and form.CCTcodigo eq rsTransacciones.CCTcodigo>selected</cfif>  >#trim(rsTransacciones.CCTcodigo)# - #rsTransacciones.CCTdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>



					<tr>											
						<td nowrap="nowrap"><strong>Motivo:</strong></td>
						<td><input type="text" name="FABMotivo" size="75" maxlength="80"  tabindex="1" value="<cfif isdefined('form.FABmotivo')>#form.FABmotivo#</cfif>"/></td>
					</tr>
	
				</table>
				</cfoutput>
			</td>
		</tr>

		<tr><td>
			<table width="100%" cellpadding="1" cellspacing="0" >
				<tr><td colspan="9"><strong>Seleccione los documentos que desea trasladar:</strong></td></tr>
				<tr>
					<td class="tituloListas">&nbsp;</td>
					<td class="tituloListas">Documento</td>
					<td class="tituloListas">Tipo</td>
					<td class="tituloListas">Fecha</td>
					<td class="tituloListas">Caja/Oficina</td>
					<td class="tituloListas" align="right">Monto Adelanto</td>
					<td class="tituloListas" align="right">Monto Aplicado</td>
					<td class="tituloListas" align="right">Monto Disponible</td>
				</tr>
	
				<cfoutput>
				<input type="hidden" name="CDCcodigo" value="<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>#form.CDCcodigo#<cfelse>#vCodCliente#</cfif>" />
				<input type="hidden" name="FAX14DOC" value="#form.FAX14DOC#" />
				</cfoutput>
				<cfoutput query="rsLista" group="Moneda">
					<tr>
						<td class="listaCorte" align="left" colspan="9" style="padding-left:20px;">Moneda: #rsLista.Moneda#</td>
					</tr>
					<cfoutput>
						<tr class="<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaNonSel';" onmouseout="this.className='<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';">
							<td style="padding-left:20px;" ><input type="checkbox" tabindex="1" name="chk" <cfif isdefined("form.chk") and listFind(form.chk, rsLista.FAX14CON) gt 0 >checked="checked"</cfif> value="#rsLista.FAX14CON#" /></td>
							<td >#rsLista.FAX14DOC#</td>
							<td >#rsLista.Tipo#</td>
							<td >#LSDateFormat(rsLista.Fecha, 'dd/mm/yyyy')#</td>
							<td >#rsLista.CajaOficina#</td>
							<td align="right" >#LSNumberFormat(rsLista.MontoAdelanto, ',9.00')#</td>
							<td align="right" >#LSNumberFormat(rsLista.MontoAplicado, ',9.00')#</td>
							<td align="right" >#LSNumberFormat(rsLista.MontoDisponible, ',9.00')#</td>
						</tr>
					
					</cfoutput>
				</cfoutput>
					<tr>
						<td colspan="9" align="center">
							<input type="submit"  tabindex="1" class="btnNormal" name="btnTrasladar" value="Trasladar" />
							<input type="button" tabindex="1"  name="btnRegresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='movSocios-filtro.cfm'" />
						</td>
							
					</tr>
			</table>
		</td></tr>
		</form>	
		
		<tr><td>&nbsp;</td></tr>
	
		<script language="javascript1.2" type="text/javascript">
			function validar(){
				var mensaje = '';
				if ( document.form1.SNcodigo.value == '' ){
					mensaje = ' - El Socio destino es requerido.';
				}
				if ( document.form1.CCTcodigo.value == '' ){
					mensaje += '\n - El Tipo de Transacción es requerido.';
				}
				if ( document.form1.FABMotivo.value == '' ){
					mensaje += '\n - El Motivo de traslado es requerido.';
				}
				
				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje);
					return false
				}
	
	
				var continuar = false;
				if (document.form1.chk) {
					if (document.form1.chk.value) {
						continuar = document.form1.chk.checked;
					}
					else {
						for (var k = 0; k < document.form1.chk.length; k++) {
							if (document.form1.chk[k].checked) {
								continuar = true;
								break;
							}
						}
					}
					if (!continuar) { alert('Se presentaron los siguientes errores:\n - Debe seleccionar al menos un documento para trasladar.'); }
				}
				return continuar;
			}
		</script>	
	<cfelse>
		<tr><td>
			<table width="80%" align="center" cellpadding="3" cellspacing="0" >
				<tr><td align="center">No se encontraron registros para los criterios de b&uacute;squeda seleccionados</td></tr>
				<tr>
					<td align="center">
						<input type="button" tabindex="1"  name="btnRegresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='movSocios-filtro.cfm'" />
					</td>
				</tr>
			</table>
 		</td></tr>
	</cfif>
</cfif>
</table>
<cf_web_portlet_end>
<cf_templatefooter>