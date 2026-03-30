
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> <cfoutput>#pNavegacion#</cfoutput>
		
		<form action="movClientes-confirmar.cfm" name="form1" method="post" style="margin:0;" >
		<table width="100%">
			<cfset vCodCliente = 0 >
			<cfset vCliente = '' >
			<cfset vIdCliente = '' >
			<cfset vDocumento = 'Todos' >
			<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) >
				<cfset vCodCliente = form.CDCcodigo >
				<cfquery name="cliente" datasource="#session.DSN#">
					select CDCidentificacion, CDCnombre
					from ClientesDetallistasCorp
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				</cfquery>
				<cfset vCliente = cliente.CDCnombre >
				<cfset vIdCliente = trim(cliente.CDCidentificacion) >
			</cfif>
		
			<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC)) >
				<cfset vDocumento = form.FAX14DOC >
				
				<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) eq 0>
					<cfquery name="cliente" datasource="#session.DSN#">
						select a.CDCcodigo, a.CDCidentificacion, a.CDCnombre
						from ClientesDetallistasCorp a
						
						inner join FAX014 b
						on b.CDCcodigo=a.CDCcodigo
						and b.FAX14DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX14DOC#">
						
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>
					<cfset vCliente = cliente.CDCnombre >
					<cfset vIdCliente = trim(cliente.CDCidentificacion) >
					<cfset vCodCliente = cliente.CDCcodigo >
				</cfif>
			</cfif>
			
			<cfquery name="clientedest" datasource="#session.DSN#">
				select CDCidentificacion, CDCnombre
				from ClientesDetallistasCorp
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigoDest#">
			</cfquery>
					
			<tr>
				<td>
					<cfoutput>
					<table width="100%" align="center" cellpadding="3" cellspacing="0" class="areaFiltro">
						<tr>
							<td colspan="2" align="center"><strong>Confirmaci&oacute;n de NC/Adelantos por Trasladar</strong></td>
						</tr>
						<tr>
							<td width="50%"><strong>Cliente Origen:&nbsp;</strong>#vCliente#</td>
							<td width="50%" ><strong>Cliente Destino:&nbsp;</strong>#clientedest.CDCnombre#<input type="hidden" name="CDCcodigoDest" value="#form.CDCcodigoDest#" /></td>
						</tr>
						<tr>
							<td><strong>Identificaci&oacute;n:&nbsp;</strong>#vIdCliente#</td>
							<td ><strong>Identificaci&oacute;n:&nbsp;</strong>#clientedest.CDCidentificacion#</td>
						</tr>
						<tr>											
							<td nowrap="nowrap" colspan="2"><strong>Motivo:&nbsp;</strong>#form.FABmotivo#<input type="hidden" name="FABmotivo" value="#form.FABmotivo#" /></td>
						</tr>
					</table>
					</cfoutput>
				</td>
			</tr>
            
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
					on a.CDCcodigo = c.CDCcodigo			
					
					inner join FAX001 d
					on a.FAX01NTR = d.FAX01NTR
					and a.Ecodigo = d.Ecodigo
				    and d.FAX01STA in ('T','C')					
					
					left outer join FATiposAdelanto b
					on a.IdTipoAd = b.IdTipoAd
					
					where a.FAX14MON > a.FAX14MAP
					  and a.FAX14STS = '1'
					  and a.FAX14TDC in ('AD','NC')
					  and a.FAX14CLA in ('1','2')	
		
					<cfif isdefined("form.chk") and len(trim(form.chk))>
					  and a.FAX14CON in (#form.chk#)
					</cfif>
		
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
			<tr><td>
				<table width="100%" cellpadding="1" cellspacing="0" >
					<tr><td colspan="9"><strong>Listado de documentos que desea trasladar:</strong></td></tr>
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
					<input type="hidden" name="TraeAdelantos" value="TraeAdelantos" />
					</cfoutput>
					<cfoutput query="rsLista" group="Moneda">
						<tr>
							<td class="listaCorte" align="left" colspan="9" style="padding-left:20px;">Moneda: #rsLista.Moneda#</td>
						</tr>
						<cfoutput>
							<tr class="<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaNonSel';" onmouseout="this.className='<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';">
								<td style="padding-left:20px;" ><input type="hidden" name="chk" value="#rsLista.FAX14CON#" /></td>
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
				</table>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><cf_botones values="Regresar, Aplicar"></td></tr>
		</table>
		</form>

		<script language="javascript1.2" type="text/javascript">
			function funcRegresar(){
				document.form1.action = 'opmovad.cfm';
			}
			function funcAplicar(){
				document.form1.action = 'movClientes-sql.cfm';
				return confirm('Desea trasladar los documentos seleccionados?');
			}
		</script>


		<cf_web_portlet_end>
<cf_templatefooter>