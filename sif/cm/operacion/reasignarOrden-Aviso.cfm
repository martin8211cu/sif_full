<cfif isdefined("url.EOidorden") and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = Url.EOidorden>
</cfif>
<cfif isdefined("Url.RB") and not isdefined("form.RB")>
	<cfset form.RB = Url.RB>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Consultas para mostrar los datos de la Orden de Compra --->
<cfquery name="rsOrden" datasource="#session.DSN#">
	select 	a.EOnumero,
			a.SNcodigo,
			a.EOfecha,
			a.Observaciones,
			a.EOtotal,	
			rtrim(b.SNidentificacion)#_Cat#' - '#_Cat#b.SNnombre as SNnombre,
			c.Mnombre,
			c.Msimbolo,
			rtrim(a.CMTOcodigo)#_Cat#' - '#_Cat#d.CMTOdescripcion as CMTOdescripcion,
			e.BMCfecha
	from EOrdenCM a
			inner join SNegocios b
				on a.Ecodigo = b.Ecodigo
				and a.SNcodigo = b.SNcodigo
			inner join Monedas c
				on a.Ecodigo = c.Ecodigo
				and a.Mcodigo = c.Mcodigo
			inner join CMTipoOrden d
				on a.Ecodigo = d.Ecodigo
				and a.CMTOcodigo = d.CMTOcodigo
			left outer join BMComprador e
						on a.Ecodigo = e.Ecodigo
						and a.EOidorden = e.EOidorden			
						and e.EOidorden in (#form.RB#)
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and a.EOidorden in (#form.RB#)
</cfquery>
<cfquery  dbtype="query" name="rsOrdenDetalle">
	select 	distinct EOnumero,
			SNcodigo,
			EOfecha,
			Observaciones,
			EOtotal,	
			SNnombre,
			Mnombre,
			Msimbolo,
			CMTOdescripcion
	from rsOrden
	order by EOnumero
</cfquery>

<cfset usuarioEnvia = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" >
<cfset Titulo = "Informaci&oacute;n sobre la Reasignaci&oacute;n de Ordenes de Compra.">

<cfoutput>
	<table border="0" width="99%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999;" align="center">
		<tr>
			<td nowrap colspan="2" align="center" bgcolor="##999999" style="color:##FFFFFF; font-size:18px; font-weight: bold;" >Ordenes de Compra</td>
		</tr>
		<tr>
			<td nowrap colspan="2" bgcolor="##CCCCCC"><strong>Informaci&oacute;n sobre Reasignaci&oacute;n de Ordenes de Compra.</strong></td>
		</tr>
		<tr>
			<td nowrap colspan="2" >&nbsp;</td>
		</tr>
		<tr>
			<td width="7%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">De</td>
			<td width="93%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#usuarioEnvia#</td>
		</tr>
		<tr>
			<td width="7%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Para</td>
			<td width="93%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#nameBuyerTo#</td>
		</tr>
		<tr>
			<td width="7%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Cc</td>
			<td width="93%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#nameBuyerCc#</td>
		</tr>
		<tr>
			<td width="7%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Asunto</td>
			<td width="93%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#Titulo#</td>
		</tr>
		<tr>
			<td colspan="2">
				<table border="0" width="100%" cellpadding="2" cellspacing="0"> 
					<tr>
						<td colspan="2"><hr size="1" color="##999999"></td>
					</tr>
					<tr>
						<td width="1%" nowrap style="font-size: 14; font-weight: bold; ">Fecha Reasignaci&oacute;n:&nbsp;</td>
						<td align="left" style="font-size: 14; ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td width="1%" nowrap valign="top" style="font-size: 14; font-weight: bold; ">Asunto:&nbsp;</td>
					  	<td align="left" style="font-size: 14; ">
							Sr(a) / Srta: #nameBuyerTo#, la(s) Orden(es) de Compra , 
							que pertenec&iacute;a(n) al comprador #nameBuyerCc# le ha(n) sido asignada(s), cualquier duda favor de comunicarse con la persona mencionada.<br>
							La reasignaci&oacute;n de Ordenes de Compra fue efectuada por: #usuarioEnvia#.
						</td>
					</tr>						      
					<tr>
						<td colspan="2"><hr size="1" color="##999999"></td>
					</tr>
					<tr>
						<td width="1%" nowrap valign="top" bgcolor="##CCCCCC" colspan="2" style="font-size: 14; font-weight: bold;">Datos de la Orden de Compra. &nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">
							<table width="100%" cellpadding="2" cellspacing="0">
								<tr bgcolor="##F5F5F5" style="font-size: 13 ">
								    <td nowrap><strong>Num.Orden</strong></td>
								    <td align="center" nowrap><strong>Fecha</strong></td>
									<td nowrap><strong>Observaci&oacute;n</strong></td>
									<td nowrap><strong>Tipo Orden</strong></td>
									<td nowrap><strong>Proveedor</strong></td>
									<td nowrap><strong>Moneda</strong></td>
									<td nowrap align="right"><strong>Monto Estimado</strong></td>
								</tr>
								<cfloop query="rsOrdenDetalle">
									<tr style="font-size: 13 ">
									  <td>#rsOrdenDetalle.EOnumero#</td>
									  <td align="center">#LSDateFormat(rsOrdenDetalle.EOfecha, 'dd/mm/yyyy')#</td>
									  <td>#rsOrdenDetalle.Observaciones#</td>
									  <td>#rsOrdenDetalle.CMTOdescripcion#</td>
									  <td>#rsOrdenDetalle.SNnombre#</td>
									  <td>#rsOrdenDetalle.Mnombre#</td>
									  <td align="right">#rsOrdenDetalle.Msimbolo#&nbsp;#LSCurrencyFormat(rsOrdenDetalle.EOtotal,'none')#</td>
									</tr>
									<tr><td nowrap colspan="7">&nbsp;</td></tr>
								</cfloop>
							</table>
						</td>
					</tr>
				</table>
			</td>		
		</tr>
		<tr>
			<td colspan="2" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; ">
				Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/cm/consultas/OrdenesCompra-lista.cfm'> Lista de Ordenes de Compra </a> para revisarlo.
			</td>
		</tr>
		<tr>
			<td nowrap colspan="2">&nbsp;</td>
		</tr>
		
		<cfset hostname = session.sitio.host>
		<cfset CEcodigo = session.CEcodigo>
	
		<!---<tr>
			<td colspan="2" align="center">
					<strong>Nota:</strong> En #hostname# respetamos su privacidad. 
					Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click 
					<a href="http://#hostname#/cfmx/home/public/optout.cfm?b=#CEcodigo#&amp;c=#hostname#&amp;#Hash('please let me out of ' & hostname)#">aqu&iacute;</a>. 
			</td>
		</tr>--->
	</table>
</cfoutput>
