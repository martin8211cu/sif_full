<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templateheader title="Anulación de Transacciones">
		<cf_web_portlet_start titulo="Anulación de Transacciones">
			<cfinclude template="../../portlets/pNavegacion.cfm">			
	
		<!--- Si viene por url la variable VPintado=1 es porque el pintado es de las transacciones que no se pudieron copiar o anular --->
			<cfif isdefined("url.VPintado") and (url.VPintado EQ 1)>
				<cfset url.Lista = Mid(url.Lista,2,len(url.Lista))> <!--- Quita la primera coma de la variable(,300000000025,300000000024)---->
				<!--- Table con el titulo --->
				<cfoutput>
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					  <tr><td colspan="3">&nbsp;</td></tr>
					  <tr><td colspan="3" align="center" class="Subtitulo"><strong><font size="3">#session.enombre#</font></strong></td></tr>
					  <tr><td  nowrap colspan="3">&nbsp;</td></tr>				  
					  <tr><td colspan="3" class="listaCorte"><strong><font size="2">Transacciones Sin Procesar</font></strong></td></tr>
					  <tr><td colspan="3" nowrap>&nbsp;</td></tr>
				</table>
				<!--- Table con los encabezados --->
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr class="titulolistas">
						<td width="15%" nowrap><strong>N° Documento</strong></td>
						<td width="10%" nowrap><strong>Fecha </strong></td>
						<td width="30%" nowrap><strong>Socio de Negocio </strong></td>
						<td width="10%" nowrap><strong>Moneda </strong></td>
						<td width="20%" nowrap align="right"><strong>Total&nbsp;</strong></td>
						<td width="15%" nowrap><strong>Póliza </strong></td>
					</tr>
					<!----  Loop de la variable que trae los ID de las transacciones que no se pudieron anular/copiar 
							En el index se almacena el ID cada vez que los separa (No hace falta indicar que el separador es la , ese es el default)----->
					<cfloop list="#url.Lista#" index="EDIid">
						<!--- Para cada ID que viene en la variable selecciona los datos  ---->	
						<cfquery name="rsSinAnular" datasource="#session.DSN#">						
							select 	a.Ddocumento, a.EDIfecha,a.EPDid,e.DDIconsecutivo,
									b.SNnumero#_Cat#' '#_Cat#b.SNnombre as Socio,
									c.Mnombre,
									(select sum (j.DDItotallinea) 
										from DDocumentosI j
											inner join EDocumentosI k
												on j.EDIid = k.EDIid
												and j.Ecodigo = k.Ecodigo
										where k.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 	and k.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIid#">) as total,
									
									d.EPDnumero#_Cat#' '#_Cat#d.EPDdescripcion as poliza				
							
							from 	EDocumentosI a
									inner join SNegocios b
										on a.SNcodigo = b.SNcodigo
										and a.Ecodigo = b.Ecodigo
									inner join Monedas c
										on a.Mcodigo = c.Mcodigo
										and a.Ecodigo = c.Ecodigo
								
								left outer join DDocumentosI e		
									left outer join EPolizaDesalmacenaje d
										on e.EPDid = d.EPDid
										and e.Ecodigo = d.Ecodigo
							
								on a.EDIid = e.EDIid
								and a.Ecodigo = e.Ecodigo
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							and a.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIid#">
						</cfquery>	
						<tr>
							<td width="15%">#rsSinAnular.Ddocumento#</td>
							<td width="10%">#LSDateFormat(rsSinAnular.EDIfecha,'dd/mm/yyyy')#</td>
							<td width="30%">#rsSinAnular.Socio#</td>
							<td width="10%">#rsSinAnular.Mnombre#</td>
							<td align="right" width="20%">#LSCurrencyFormat(rsSinAnular.total,'none')#&nbsp;</td>
							<td width="15%">#rsSinAnular.poliza#</td>							
						</tr>
					</cfloop>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr><td colspan="6" align="center"><input type="button" name="btnRegresar" value="Regresar" onClick="javascript: FunRegresar();"></td></tr>
					<tr><td colspan="6">&nbsp;</td></tr>
				</table>	
				</cfoutput>																						
		<!--- Si se dio click sobre la lista --->
			<cfelse>
				<!---- Seleeción de los datos del encabezado de la transacción ---->
				<cfquery name="rsETransacciones" datasource="#session.DSN#">
					select 	a.Ddocumento, 
							a.EDIfecha,
							a.EDItc,
							a.EDobservaciones,
							a.EDIimportacion,		
							case a.EDItipo	 when 'N' then 'Nota de Credito'
											 when 'F' then 'Factura'
									end as TipoTran,
							b.EOnumero,
							c.CPdescripcion,
							d.Mnombre,
							e.SNnumero#_Cat#' '#_Cat#e.SNnombre as Socio
									
					from EDocumentosI a
					
						left outer join EOrdenCM b
							on a.EOidorden = b.EOidorden
							and a.Ecodigo = b.Ecodigo
					
						inner join TTransaccionI c
							on a.CPcodigo = c.CPcodigo
							and a.Ecodigo = c.Ecodigo
						
						inner join Monedas d
							on a.Mcodigo = d.Mcodigo
							and a.Ecodigo = d.Ecodigo
						
						inner join SNegocios e
							on a.SNcodigo = e.SNcodigo
							and a.Ecodigo = e.Ecodigo
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#"> 
				</cfquery>
				<cfoutput>
				<!--- Table con el titulo --->
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					  <tr><td colspan="3">&nbsp;</td></tr>
					  <tr><td colspan="3" align="center" class="tituloAlterno"><strong><font size="3">#session.enombre#</font></strong></td></tr>
					  <tr><td  nowrap colspan="3" >&nbsp;</td></tr>		  
					  <tr><td colspan="3" align="center"><strong><font size="2">Detalles de la Transacción</font></strong></td></tr>
					 <!---  <tr><td colspan="3" nowrap>&nbsp;</td></tr> --->
				</table>
				<!--- Table con los datos del encabezado --->
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td nowrap><strong>&nbsp;N° Documento:</strong>&nbsp;#rsETransacciones.Ddocumento#&nbsp;</td>
						<td nowrap><strong>&nbsp;Orden Compra:</strong>&nbsp;#rsETransacciones.EOnumero#&nbsp;</td>
					</tr>
					<tr>
						<td nowrap><strong>&nbsp;Tipo: </strong>&nbsp;#rsETransacciones.TipoTran#&nbsp;</td>
						<td nowrap><strong>&nbsp;Tipo Transaccion: </strong>&nbsp;#rsETransacciones.CPdescripcion#&nbsp;</td>
					</tr>		
					<tr>
						<td nowrap><strong>&nbsp;Moneda: </strong>&nbsp;#rsETransacciones.Mnombre#&nbsp;</td>
						<td nowrap><strong>&nbsp;Fecha: </strong>&nbsp;#LSDateFormat(rsETransacciones.EDIfecha,'dd/mm/yyyy')#&nbsp;</td>					</tr>	
					<tr>
						<td nowrap><strong>&nbsp;Tipo Cambio: </strong>&nbsp;#rsETransacciones.EDItc#&nbsp;</td>
						<td nowrap><strong>&nbsp;Observaciones: </strong>&nbsp;#rsETransacciones.EDobservaciones#&nbsp;</td>
					</tr>	
					<tr>
						<td nowrap><strong>&nbsp;Socio de Negocio: </strong>&nbsp;#rsETransacciones.Socio#&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</table>
				<!----  Selección de los datos del detalle de la transacción ----->
				<cfquery name="rsDTransacciones" datasource="#session.DSN#">
					select 	a.DDIconsecutivo,
							a.CFcuenta,
							a.DDIcantidad,
							#LvarOBJ_PrecioU.enSQL_AS("a.DDIpreciou")#,
							a.DDItotallinea,
							a.ETidtracking,
							a.EPDid,
							a.Icodigo,
							a.DOlinea,
							a.Cid,
							case a.DDItipo
								when 'A' then 'Articulo' 
								when 'S' then 'Servicio'
								when 'F' then 'Activo'
							  end  as DDItipo,
							case 
								when a.Aid is not null then case when  <cf_dbfunction name="length" args="art.Adescripcion"> > 25 then 	<cf_dbfunction name="sPart"	args="art.Adescripcion,1,25"> #_Cat# '...' else art.Adescripcion end
								when a.Cid is not null then case when  <cf_dbfunction name="length" args="con.Cdescripcion"> > 25 then    <cf_dbfunction name="sPart"	args="con.Cdescripcion,1,25"> #_Cat# '...' else con.Cdescripcion end
								when a.Icodigo is not null then a.Icodigo
								else case when <cf_dbfunction name="length" args="b.DOdescripcion"> > 25 then <cf_dbfunction name="sPart"	args="b.DOdescripcion,1,25"> #_Cat# '...' else b.DOdescripcion end
							  end as itemDescripcion,
							case a.DDIafecta	when 1 then 'Fletes'
												when 2 then 'Seguros'
												when 3 then 'Costos'
												when 4 then 'Gastos'
												when 5 then 'Impuestos'
									end as Afecta		
					from DDocumentosI  a

							left outer join Conceptos con
									on con.Cid = a.Cid
									and con.Ecodigo = a.Ecodigo
					
							left outer join DOrdenCM b
				
								left outer join Articulos art
										on art.Aid = b.Aid
										and art.Ecodigo = b.Ecodigo
										
							on a.DOlinea = b.DOlinea 
							and a.Ecodigo = b.Ecodigo
					
					where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#"> 
				</cfquery>
				<!--- Table con el detalle ---->			
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>&nbsp;</tr>
				  <cfif rsDTransacciones.RecordCount EQ 0>
					<tr>
					  <td align="center"> ------------------------ No se encontraron detalles ------------------------</td>
					</tr>
					<cfelse>
					<tr class="titulolistas">
					  <td nowrap width="5%" ><strong>Consecutivo</strong></td>
					  <td nowrap width="5%" ><strong>Orden </strong></td>
					  <td nowrap width="40%" ><strong>Descripción</strong></td>
					  <td nowrap width="10%" ><strong>Tipo</strong></td>
					  <td nowrap width="10%" ><strong>Afecta a</strong></td>
					  <td nowrap width="5%" ><strong>Cantidad</strong></td>
					  <td nowrap width="10%" align="right"><strong>Precio Unitario</strong></td>
					  <td nowrap width="10%" align="right"><strong>Total</strong></td>
					</tr>
					<cfloop query="rsDTransacciones">
					  <tr>
						<td nowrap width="5%">#rsDTransacciones.DDIconsecutivo#</td>
						<td nowrap width="5%"><cfif rsDTransacciones.DOlinea EQ ''>--<cfelse>#rsDTransacciones.DOlinea#</cfif></td>
						<td nowrap width="40%"><cfif rsDTransacciones.itemDescripcion EQ ''>----<cfelse>#rsDTransacciones.itemDescripcion#</cfif></td>
						<td nowrap width="10%">#rsDTransacciones.DDItipo#</td>
						<td nowrap width="10%">#rsDTransacciones.Afecta#</td>
						<td nowrap width="5%" align="center">#rsDTransacciones.DDIcantidad#</td>
						<td nowrap width="10%" align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDTransacciones.DDIpreciou)#</td>
						<td nowrap width="10%" align="right">#LSCurrencyFormat(rsDTransacciones.DDItotallinea,'none')#</td>
					  </tr>
					</cfloop>
				  </cfif>
				  <tr><td colspan="8">&nbsp;</td></tr>
				  <tr><td colspan="8">&nbsp;</td></tr>
				  <tr><td colspan="8" align="center"><input type="button" name="btnRegresar" value="Regresar" onClick="javascript: FunRegresar();"></td></tr>
				  <tr><td colspan="8">&nbsp;</td></tr>
				</table>
				</cfoutput>
			</cfif>
			<script language="javascript" type="text/javascript">
				function FunRegresar(){
					location.href ='anulaEDocumentosI.cfm'  		//Se regresa al archivo de la lista
				} 
			</script>
		<cf_web_portlet_end>
<cf_templatefooter>