<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.ERid") and not isdefined("form.ERid")>
	<cfset form.ERid = Url.ERid>
</cfif>

<style type="text/css">
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
</style>

<!--- Consultas para llenar el Encabezado y Detalle del Reclamo --->
<cfquery name="dataCorreo" datasource="#session.DSN#">
	select a.ERid, a.SNcodigo, a.EDRnumero, a.EDRfecharec, a.ERobs,b.SNnumero, b.SNnombre
	from EReclamos a
		inner join SNegocios b
			on a.SNcodigo=b.SNcodigo
			and a.Ecodigo=b.Ecodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#" >
</cfquery>

<cfquery name="dataCorreoDetalle" datasource="#session.DSN#">
	select a.DRid, a.ERid, a.Ecodigo, a.DDRlinea, a.DRcantorig, a.DRcantrec, 
	#LvarOBJ_PrecioU.enSQL_AS("a.DRpreciooc")#, 
	#LvarOBJ_PrecioU.enSQL_AS("a.DRpreciorec")#, 
	a.DRfecharec, a.DRfechacomp, a.DRestado, a.DDRobsreclamo, c.DOdescripcion
	from DReclamos a
		inner join DDocumentosRecepcion b
			on a.DDRlinea=b.DDRlinea
			and a.Ecodigo=b.Ecodigo
		inner join DOrdenCM c
			on b.DOlinea=c.DOlinea
			and b.Ecodigo=c.Ecodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ERid = <cfqueryparam value="#form.ERid#" cfsqltype="cf_sql_numeric">
</cfquery>


<cfoutput>
	<table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
		<tr bgcolor="##003399">
			<td colspan="2" height="24"></td>
		</tr>
		<tr bgcolor="##999999">
			<td colspan="2"> <strong>Informaci&oacute;n sobre Reclamo en Sistema de Compras</strong> </td>
		</tr>
		<tr>
			<td width="70">&nbsp;</td>
			<td width="476">&nbsp;</td>
		</tr>
		<tr>
			<td><span class="style2"><strong>De</strong></span></td>
			<td><span class="style7">Sistema de Compras - Reclamos </span></td>
		</tr>
		<tr>
			<td><span class="style7"><strong>Para</strong></span></td>
			<td><span class="style7">#Pnombre#</span></td>
		</tr>
		<tr>
			<td><span class="style8"></span></td>
			<td><span class="style8"></span></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><span class="style7">Informaci&oacute;n sobre Reclamo de Sistema de Compras.</span></td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td>
				<table border="0" width="100%" cellpadding="2" cellspacing="0" style="border:1px solid ##999999;" > 
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>N&uacute;mero de Reclamo:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#dataCorreo.EDRnumero#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Fecha del Reclamo:&nbsp;</strong></span></td>
						<td align="left"><span class="style8">#LSDateFormat(dataCorreo.EDRfecharec,'dd/mm/yyyy')#</span></td>
					</tr>
					<tr>
						<td width="1%" nowrap><span class="style8"><strong>Observaciones:&nbsp;</strong></span></td>
						<td align="left">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td><span class="style8"><cfif len(trim(dataCorreo.ERobs)) ><p>#dataCorreo.ERobs#</p><cfelse>No se registraron observaciones</cfif></span></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;<hr size="1" color="##999999"></td>
					</tr>
					<tr>
						<td width="1%" nowrap valign="top"><span class="style8"><strong>Detalle del Reclamo&nbsp;</strong></span></td>
					</tr>
					<tr>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr bgcolor="##F5F5F5">
									<td><span class="style9"><strong>Item</strong></span></td>
									<td align='right' ><span class="style9"><strong>Cantidad Documento</strong></span></td>
									<td align='right'><span class="style9"><strong>Cantidad Recibida</strong></span></td>
									<td align='right'><span class="style9"><strong>Precio Unitario OC</strong></span></td>
									<td align='right'><span class="style9"><strong>Precio Unitario Doc</strong></span></td>
								</tr>
								
								<cfloop query="dataCorreoDetalle">
									<tr bgcolor="<cfif not dataCorreoDetalle.CurrentRow mod 2>##FAFAFA</cfif>" >
										<td title="#dataCorreoDetalle.DOdescripcion#"><span class="style9"><cfif len(dataCorreoDetalle.DOdescripcion) gt 35>#mid(dataCorreoDetalle.DOdescripcion,1,32)#...<cfelse>#dataCorreoDetalle.DOdescripcion#</cfif></span></td>
										<td align='right'><span class="style9">#LSCurrencyFormat(dataCorreoDetalle.DRcantorig,'none')#</span></td>
										<td align='right'><span class="style9">#LSCurrencyFormat(dataCorreoDetalle.DRcantrec,'none')#</span></td>
										<td align='right'><span class="style9">#LvarOBJ_PrecioU.enCF_RPT(dataCorreoDetalle.DRpreciooc)#</span></td>
										<td align='right'><span class="style9">#LvarOBJ_PrecioU.enCF_RPT(dataCorreoDetalle.DRpreciorec)#</span></td>
									</tr>
								</cfloop>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td><span class="style8"></span></td>
			<td><span class="style7">Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/cm/operacion/reclamos-lista.cfm'> Reclamos Pendientes</a> para revisarlo.</span></td>
		</tr>
	
		<tr>
			<td><span class="style8"></span></td>
			<td><span class="style8"></span></td>
		</tr>
	
		<cfset hostname = session.sitio.host>
		<cfset CEcodigo = session.CEcodigo>
	
		<!---<tr>
			<td>&nbsp;</td>
			<td align="center">
				<span class="style1">
					Nota: En #hostname# respetamos su privacidad. <br>
					Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click 
					<a href="http://#hostname#/cfmx/home/public/optout.cfm?b=#CEcodigo#&amp;c=#hostname#&amp;#Hash('please let me out of ' & hostname)#">aqu&iacute;</a>. 
				</span>
			</td>
		</tr>--->
	</table>
</cfoutput>
