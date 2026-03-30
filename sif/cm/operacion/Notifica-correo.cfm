<cffunction name="mailBody" returntype="string">
	<cfargument name="EDRid" type="numeric" required="yes">			<!--- id del Documento --->
	<cfargument name="Pnombre" type="string" required="yes">		<!--- Nombre del Resposable --->
	<cfargument name="tipo" type="string" required="yes"> 			<!--- 0 - CF, 1 - Almacen--->
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>Notificación</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
		<!--
		.style1 {
			font-size: 10px;
			font-family: "Times New Roman", Times, serif;
		}
		.style2 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 14;
		}
		.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
		.style8 {font-size: 14}
		
		.style9 {font-size: 13}
		-->
		</style>
		</head>
		<body>
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsProveedorRecepcion" datasource="#session.DSN#">
			select sn.SNidentificacion #_Cat# ' - ' #_Cat# sn.SNnombre as SNnombre
			from EDocumentosRecepcion edr
				inner join SNegocios sn
					on sn.SNcodigo = edr.SNcodigo
					and sn.Ecodigo = edr.Ecodigo
			where edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDRid#">
				and edr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		 
		<cfif arguments.tipo eq "0">
			<cfquery name="dataCorreoDetalle" datasource="#session.DSN#">
				select  a.DDRlinea,
						b.Acodigo as CodArt,
						b.Adescripcion as DescArt,
						a.Ucodigo, a.DDRcantorigen,
						e.EDRnumero,
						e.EDRfecharec,
						e.CFid,
						o.EOnumero, o.DOconsecutivo,
						cmc.CMCnombre
						
				from DDocumentosRecepcion a
				
					inner join DOrdenCM o
						on a.DOlinea = o.DOlinea
						and a.Ecodigo = o.Ecodigo
						
						inner join EOrdenCM eo
							on eo.EOidorden = o.EOidorden
							and eo.Ecodigo = o.Ecodigo
							
							inner join CMCompradores cmc
								on cmc.CMCid = eo.CMCid
								and cmc.Ecodigo = eo.Ecodigo

					inner join EDocumentosRecepcion e
						on a.EDRid = e.EDRid
						and a.Ecodigo = e.Ecodigo
						
					inner join Articulos b
						on a.Aid = b.Aid
						and a.Ecodigo = b.Ecodigo
						and b.Areqcert = 1
						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.EDRid = <cfqueryparam value="#arguments.EDRid#" cfsqltype="cf_sql_numeric">
					and a.Aid is not null
					and a.DDRtipoitem = 'A'
				order by CodArt
			</cfquery>
		<cfelse>	
 			<cfquery name="dataCorreoDetalle" datasource="#session.DSN#">
				select  a.DDRlinea,
						b.Acodigo as CodArt,
						b.Adescripcion as DescArt,
						a.Ucodigo, a.DDRcantorigen,
						e.EDRnumero,
						e.EDRfecharec,
						e.Aid as almacen,
						o.EOnumero, o.DOconsecutivo,
						cmc.CMCnombre
						
				from DDocumentosRecepcion a
				
					inner join DOrdenCM o
						on a.DOlinea = o.DOlinea
						and a.Ecodigo = o.Ecodigo
						
						inner join EOrdenCM eo
							on eo.EOidorden = o.EOidorden
							and eo.Ecodigo = o.Ecodigo
							
							inner join CMCompradores cmc
								on cmc.CMCid = eo.CMCid
								and cmc.Ecodigo = eo.Ecodigo
								
					inner join EDocumentosRecepcion e
						on a.EDRid = e.EDRid 
						and a.Ecodigo = e.Ecodigo
						
					inner join Articulos b
						on a.Aid = b.Aid
						and a.Ecodigo = b.Ecodigo
						and b.Areqcert = 1
						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.EDRid = <cfqueryparam value="#arguments.EDRid#" cfsqltype="cf_sql_numeric">
					and a.Aid is not null
					and a.DDRtipoitem = 'A'
				order by CodArt
 			</cfquery>
		</cfif>
		
  	    <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			
			<tr bgcolor="##003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="##999999">
			  <td colspan="2"> <strong>Informaci&oacute;n sobre notificaci&oacute;n en Sistema de Compras</strong> </td>
			</tr>
			<tr>
			  <td width="70">&nbsp;</td>
			  <td width="476">&nbsp;</td>
			</tr>
			<tr>
			  <td><span class="style2"><strong>De</strong></span></td>
			  <td><span class="style7">Sistema de Compras</span></td>
			</tr>
			<tr>
			  <td><span class="style7"><strong>Para</strong></span></td>
			  <td> <span class="style7"><cfoutput>#arguments.Pnombre#</cfoutput></span></td>
			</tr>
		
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><span class="style7">Informaci&oacute;n sobre notificaci&oacute;n de Sistema de Compras.</span></td>
			</tr>
		
			<tr>
			  <td>&nbsp;</td>
			  <td>
				<table border="0" width="100%" cellpadding="2" cellspacing="0" style="border:1px solid ##999999;" > 
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>N&uacute;mero de Recepci&oacute;n:&nbsp;</strong></span></td>
						<td align="left"><span class="style8"><cfoutput>#dataCorreoDetalle.EDRnumero#</cfoutput></span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha de Recepci&oacute;n:&nbsp;</strong></span></td>
						<td align="left"><span class="style8"><cfoutput>#LSDateFormat(dataCorreoDetalle.EDRfecharec,'dd/mm/yyyy')#</cfoutput></span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Proveedor:&nbsp;</strong></span></td>
						<td align="left"><span class="style8"><cfoutput>#rsProveedorRecepcion.SNnombre#</cfoutput></span></td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
					 <tr>
						<td colspan="2" nowrap>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td><span class="style8">
									Sr(a)/Srta. <cfoutput>#arguments.Pnombre#</cfoutput> la siguiente lista de artículos requieren <br>
									ser verificados para su ingreso en <cfoutput>#rsEmpresa.Edescripcion#</cfoutput></span>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
					<tr>
						<td width="1%" nowrap valign="top"><span class="style8"><strong>Detalle de la Orden de Compra&nbsp;</strong></span></td>
					</tr>
		
					<tr>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr bgcolor="##F5F5F5">
								    <td  nowrap align='left'><span class="style9"><strong>O. C.&nbsp;</strong></span></td>
									<td align='right'><span class="style9"><strong>Línea&nbsp;</strong></span></td>
									<td align='left'><span class="style9"><strong>Comprador&nbsp;</strong></span></td>
									<td align='left'><span class="style9"><strong>Articulo&nbsp;</strong></span></td>
									<td align='left'><span class="style9"><strong>Descripci&oacute;n&nbsp;</strong></span></td>
									<td align='right'><span class="style9"><strong>Cantidad&nbsp;</strong></span></td>
									<td nowrap align='left'><span class="style9"><strong>Unidad de medida&nbsp;</strong></span></td>
								</tr>
								<cfloop query="dataCorreoDetalle">
									<cfoutput>
									<tr bgcolor="<cfif not dataCorreoDetalle.CurrentRow mod 2>##FAFAFA</cfif>" >
										<td align='left'><span class="style9">#dataCorreoDetalle.EOnumero#&nbsp;</span></td>
										<td align='right'><span class="style9">#dataCorreoDetalle.DOconsecutivo#&nbsp;</span></td>
										<td align='left'><span class="style9">#dataCorreoDetalle.CMCnombre#&nbsp;</span></td>
										<td align='left'><span class="style9">#dataCorreoDetalle.CodArt#&nbsp;</span></td>
										<td align='left'><span class="style9">#dataCorreoDetalle.DescArt#&nbsp;</span></td>
										<td align='right'><span class="style9">#LSCurrencyFormat(dataCorreoDetalle.DDRcantorigen,'none')#&nbsp;</span></td>
										<td align='right'><span class="style9">#dataCorreoDetalle.Ucodigo#&nbsp;</span></td>
									</tr>
									</cfoutput>
								</cfloop>
							</table>
						</td>
					</tr>
				</table>
			  </td>
			</tr>
			<tr>
			  <td><span class="style8"></span></td>
			  <td><span class="style8"></span></td>
			</tr>
			<cfset hostname = session.sitio.host>
			<cfset Usucodigo = session.Usucodigo>
			<cfset CEcodigo = session.CEcodigo>
			<!---<cfoutput>
				<tr>
				  <td>&nbsp;</td>
				  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
				  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span>
				  </td>
				</tr>
			</cfoutput>	--->
		  </table>
 		</body>
		</html>
 	</cfsavecontent>
	<cfreturn _mail_body> 
</cffunction>