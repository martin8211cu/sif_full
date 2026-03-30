<cf_rhimprime datos="/sif/cp/consultas/DocsFavorComprobante.cfm" paramsuri="&id=#url.id#"> 

<cfquery name="rsDisponible" datasource="#Session.DSN#">
	select a.ID, c.EDsaldo, sum(b.DAmonto) as MontoDet, round(c.EDsaldo - sum(b.DAmonto),2) as disponible
	from EAplicacionCP a
		inner join DAplicacionCP b
			on a.ID = b.ID
		inner join EDocumentosCP c
			on a.Ecodigo    = c.Ecodigo
	       and a.CPTcodigo 	= c.CPTcodigo
	where a.Ecodigo =  #Session.Ecodigo# 
	and a.ID 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	and rtrim(a.Ddocumento) = rtrim(c.Ddocumento)
	group by a.ID, c.Ecodigo, c.CPTcodigo, c.Ddocumento, c.EDsaldo			
</cfquery>

<cfquery name="data" datasource="#Session.DSN#">
	select a.Ddocumento,
		   sn.SNnumero, 
		   sn.SNnombre, 
		   a.CPTcodigo, 
		   t.CPTdescripcion, 
		   a.EAfecha, 
		   a.Mcodigo, 
		   m.Mnombre, 
		   a.EAtipocambio
	from EAplicacionCP a
	
	inner join SNegocios sn
	on sn.SNcodigo=a.SNcodigo
	and sn.Ecodigo=a.Ecodigo
	
	inner join CPTransacciones t
	on t.CPTcodigo=a.CPTcodigo
	and t.Ecodigo=a.Ecodigo
	
	inner join Monedas m
	on m.Mcodigo=a.Mcodigo
	
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>

<cfquery name="detalle" datasource="#Session.DSN#">
	select  a.DAlinea,
			a.DAtransref,
			a.DAdocref,
			c.Mnombre,
			b.Mcodigo, 
			a.DAtipocambio,
			a.DAtotal,
			a.DAmonto as DAmonto,
			a.DAidref
	from DAplicacionCP a, EDocumentosCP b, Monedas c
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and a.Ecodigo =  #Session.Ecodigo# 
	  and a.DAidref = b.IDdocumento
	  and b.Mcodigo = c.Mcodigo
</cfquery>

<cfquery name="rsTotalLineas" dbtype="query">
	select sum(DAmonto) as DAmonto
	from detalle
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_ConsDocsaFavor = t.Translate('Tit_ConsDocsaFavor','Consulta de Documentos a Favor')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Disponible = t.Translate('LB_Disponible','Disponible')>
<cfset Tit_DetLinDocto = t.Translate('Tit_DetLinDocto','Detalles de L&iacute;nea(s) del Documento')>
<cfset LB_Linea = t.Translate('LB_Linea','L&iacute;nea')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_MontoMonedaPag = t.Translate('LB_MontoMonedaPag','Monto en Moneda de Pago')>
<cfset Msg_DocNoTieneLinDet = t.Translate('Msg_DocNoTieneLinDet','El documento no tiene l&iacute;neas de detalle')>
<cfset Msg_FinCons = t.Translate('Msg_FinCons','Fin de la consulta')>

<cf_templatecss>
<table width="98%" align="center" cellpadding="2" cellspacing="0" >
	<tr>
		<td valign="top" width="50%">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">		
				<tr><td colspan="4" align="center" style="font:bold; padding:4px;" class="tituloListas"><font size="2">#session.Enombre#</font></td></tr>
				<tr><td colspan="4" align="center" style="font:bold; padding:4px;" class="tituloListas">#Tit_ConsDocsaFavor#</td></tr>
				<tr><td colspan="4" class="tituloListas" align="center"><strong>&nbsp;Documento: #data.Ddocumento#</strong></td></tr>
				<tr>
					<td colspan="2" align="center">
						<table width="60%" border="0" cellspacing="0" cellpadding="2" align="center"> 
							<tr><td colspan="4">&nbsp;</td></tr>
							<tr>
								<td align="right"><strong>#LB_SocioNegocio#:&nbsp;</strong></td>
								<td >#data.SNnumero#- #data.SNnombre#</td>
								<td align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
								<td>#LSDateformat(data.EAfecha,"dd/mm/yyyy")#</td>
							</tr>

							<tr>
								<td align="right"><strong>#LB_Transaccion#:&nbsp;</strong></td>
								<td>#data.CPTcodigo# - #data.CPTdescripcion#</td>
								<td align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>
								<td>#data.Mnombre# </td>
							</tr>

							<tr>
								<td align="right"><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
								<td>#data.EAtipocambio#</td>
								<td align="right"><strong>#LB_Saldo#:&nbsp;</strong></td>
								<td>#LSNumberFormat(rsDisponible.EDsaldo, ',9.00')#</td>
							</tr>
							
							<tr>
								<td align="right"></td>
								<td></td>
								<td align="right"><strong>#LB_Disponible#:&nbsp;</strong></td>
								<td>#LSNumberFormat(rsDisponible.disponible,",9.00")#</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cfoutput>

			<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" >
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td valign="top">
						<table width="100%" border="0" cellspacing="0" cellpadding="2" > 
                        	<cfoutput> 
							<tr><td colspan="5" class="tituloListas" style="border-bottom: 1px solid gray;" ><strong>#Tit_DetLinDocto#</strong></td></tr>
							<tr>
								<td><strong>&nbsp;#LB_Linea#</strong></td>
								<td><strong>&nbsp;#LB_Transaccion#</strong></td>
								<td><strong>&nbsp;#LB_Documento#</strong></td>
								<td><strong>&nbsp;#LB_Moneda#</strong></td>
								<td align="right"><strong>#LB_MontoMonedaPag#</strong></td>
							</tr>
							</cfoutput>
							<cfoutput query="detalle">
								<tr class ="<cfif detalle.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
									<td align="center">#detalle.currentrow#</td>
									<td align="left">#Mid(detalle.DAtransref,1,30)#</td>
									<td align="left">#detalle.DAdocref#</td>
									<td align="left">#detalle.Mnombre#</td>
									<td align="right">#LSNumberFormat(detalle.DAmonto,',9.00')#</td>
								</tr>
							</cfoutput>
							<cfoutput>
							<cfif detalle.recordcount eq 0>
								<tr><td colspan="5" align="center">---  #Msg_DocNoTieneLinDet# ---</td></tr>
							<cfelse>
								<tr><td>&nbsp;</td></tr>							
								<tr><td colspan="5" nowrap align="center">**** #Msg_FinCons# ****</td></tr>
							</cfif>
							</cfoutput>
						</table>
					</td>
					<td>&nbsp;</td>
				</tr>	
			</table>
		</td>
	</tr>
</table>