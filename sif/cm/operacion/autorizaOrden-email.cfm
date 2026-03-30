			<cfquery name="dataOrden" datasource="#session.DSN#">
				select a.EOnumero, a.Observaciones, coalesce(a.EOtotal,0) as EOtotal, a.Mcodigo, a.EOfecha, b.Mnombre, c.CMCnombre
				from EOrdenCM a
				
				inner join Monedas b
				on a.Mcodigo=b.Mcodigo
				and a.Ecodigo=b.Ecodigo
				
				inner join CMCompradores c
				on a.CMCid=c.CMCid
				and a.Ecodigo=c.Ecodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				 and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			</cfquery>

			<cfoutput>
			<cfsavecontent variable="_body">
				<HTML>
					<head>
						<style type="text/css">
							.tituloIndicacion {
								font-size: 10pt;
								font-variant: small-caps;
								background-color: ##CCCCCC;
							}
							.tituloListas {
								font-weight: bolder;
								vertical-align: middle;
								padding: 2px;
								background-color: ##F5F5F5;
							}
							.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
							.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
							body,td {
								font-size: 12px;
								background-color: ##f8f8f8;
								font-family: Verdana, Arial, Helvetica, sans-serif;
							}
						</style>
					</head>
                    <cfquery name="rsPvalor" datasource="#session.DSN#">
                        select Pvalor
                        from Parametros
                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and Pcodigo = 15500
                    </cfquery>
					<body>
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr><td colspan="2" class="tituloAlterno"><strong>Sistema de Compras. <cfif isdefined("autorizada") and autorizada >La siguiente orden de compra ha sido autorizada.<cfelse>La siguiente Orden de Compra requiere de su aprobaci&oacute;n.</cfif></strong></td></tr>
							<tr>
								<td style="padding-left:10px;" width="1%"><strong>Orden:&nbsp;</strong></td>
								<td>#dataOrden.EOnumero#</td>
							</tr>
							<tr>
								<td style="padding-left:10px;" width="1%"><strong>Observaciones:&nbsp;</strong></td>
								<td>#dataOrden.Observaciones#</td>
							</tr>
							<tr>
								<td style="padding-left:10px;" width="1%" nowrap><strong>Fecha de la Orden:&nbsp;</strong></td>
								<td>#LSDateFormat(dataOrden.EOfecha,'dd/mm/yyyy')#</td>
							</tr>
							<tr>
								<td style="padding-left:10px;" width="1%"><strong>Comprador:&nbsp;</strong></td>
								<td>#dataOrden.CMCnombre#</td>
							</tr>
							<tr>
								<td style="padding-left:10px;" width="1%"><strong>Moneda:&nbsp;</strong></td>
								<td>#dataOrden.Mnombre#</td>
							</tr>
							<tr>
								<td style="padding-left:10px;" width="1%"><strong>Monto:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataOrden.EOtotal, ',9.00')#</td>
							</tr>
                            <tr>
                              <td colspan="2">
                              <!---se hace la pregunta para saber cual link usar--->
                              <cfif not isdefined("autorizada") and not autorizada >
									<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                                        Para visualizar las Orden de Compra haga click <a href="http://#hostname#/cfmx/proyecto7/ordenCompras.cfm">aquí</a>.
                                   </cfif>
                               </cfif>
                              </td>
                           </tr>
							<tr><td colspan="2"><hr size="1" color="##CCCCCC"></td></tr>
						</table>
					</body>
				</HTML>			
			</cfsavecontent>
			</cfoutput>
