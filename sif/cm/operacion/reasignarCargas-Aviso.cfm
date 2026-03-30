<cfif isdefined("url.ESidsolicitud") and not isdefined("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = Url.ESidsolicitud>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
	<!--- Consultas para mostrar los datos de la Solicitud de Compra --->
	<cfquery name="rsSolicitud" datasource="#session.DSN#">
		select 	a.ESnumero, 
				a.ESfecha,
				a.ESobservacion,
				a.ESidsolicitud,
				a.EStotalest,
				rtrim(a.CMTScodigo)#_Cat#' - '#_Cat#b.CMTSdescripcion as CMTSdescripcion,
				a.CFid,
				rtrim(c.CFcodigo) as CFcodigo,
				c.CFdescripcion,
				d.Mnombre,
				d.Msimbolo,
				e.BMCfecha 
		from ESolicitudCompraCM a
				inner join CMTiposSolicitud b
					on a.Ecodigo = b.Ecodigo
					and a.CMTScodigo = b.CMTScodigo
				inner join CFuncional c	
					on a.Ecodigo = c.Ecodigo
					and a.CFid = c.CFid
				inner join Monedas d
					on a.Ecodigo = d.Ecodigo
					and a.Mcodigo = d.Mcodigo
				left outer join BMComprador e
					on a.Ecodigo = e.Ecodigo
					and a.ESidsolicitud = e.ESidsolicitud
		where a.ESidsolicitud in (#form.rb#)<!--- #ESidsolicitud#--->
	</cfquery>
	<cfset usuarioEnvia = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" >
	<cfset Titulo = "Informaci&oacute;n sobre la Reasignaci&oacute;n de Cargas de Trabajo del Sistema de Compras.">
	
	<cfoutput>
		<table border="0" width="99%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999;" align="center">
			<tr>
				<td nowrap colspan="2" align="center" bgcolor="##999999" style="color:##FFFFFF; font-size:18px; font-weight: bold;" >Solicitudes de Compra</td>
			</tr>
			<tr>
				<td nowrap colspan="2" bgcolor="##CCCCCC"><strong>Informaci&oacute;n sobre Reasignaci&oacute;n de Cargas de Trabajo</strong></td>
			</tr>
			<tr>
				<td nowrap colspan="2" >&nbsp;</td>
			</tr>
			<tr>
				<td width="7%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">De</td>
				<td width="93%" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#usuarioEnvia#</td>
			</tr>
			<tr>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Para</td>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#nameBuyerTo#</td>
			</tr>
			<tr>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Cc</td>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#nameBuyerCc#</td>
			</tr>
			<tr>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14;">Asunto</td>
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14;">#Titulo#</td>
			</tr>
			<tr>
				<td colspan="2">
					<table border="0" width="100%" cellpadding="2" cellspacing="0"> 
						<tr>
							<td colspan="2"><hr size="1" color="##999999"></td>
						</tr>
						<tr>
							<td nowrap style="font-size: 14; font-weight: bold; ">No. Solicitud(es):&nbsp;</td>
							<td align="left" style="font-size: 14; ">
								<cfloop query="rsSolicitud">
								#rsSolicitud.ESnumero#&nbsp;&nbsp;
								</cfloop>
							</td>
						</tr>
						<tr>
							<td nowrap style="font-size: 14; font-weight: bold; ">Fecha Solicitud:&nbsp;</td>
							<td style="font-size: 14; ">#LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td nowrap style="font-size: 14; font-weight: bold; ">Fecha Reasignaci&oacute;n:&nbsp;</td>
							<td align="left" style="font-size: 14; ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td nowrap valign="top" style="font-size: 14; font-weight: bold;">Asunto:&nbsp;</td>
							<td align="left" style="font-size: 14;">
								Sr(a) / Srta: #nameBuyerTo#, se le asign&oacute; la Solicitud(es) de Compra No.					
							<cfloop query="rsSolicitud">
								<strong>#rsSolicitud.ESnumero#</strong>, 
							</cfloop>
								que pertenec&iacute;a al comprador #nameBuyerCc#, cualquier duda favor de comunicarse con la persona mencionada.<br>
								La reasignaci&oacute;n de carga de trabajo fue efectuada por: #usuarioEnvia#.
							</td>
						</tr>						      
						<tr>
							<td colspan="2"><hr size="1" color="##999999"></td>
						</tr>
						<tr>
							<td valign="top" bgcolor="##CCCCCC" colspan="2" style="font-size: 14; font-weight: bold;">Datos de la Solicitud&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr bgcolor="##F5F5F5" style="font-size: 13 ">
										 <td nowrap><strong>Solicitud</strong></td>
										 <td align="center" nowrap><strong>Fecha</strong></td>
										<td nowrap><strong>Observaci&oacute;n</strong></td>
										<td nowrap><strong>Tipo Solicitud</strong></td>
										<td nowrap><strong>Centro Funcional</strong></td>
										<td nowrap><strong>Moneda</strong></td>
										<td nowrap align="right"><strong>Monto Estimado</strong></td>
									</tr>
									<cfloop query="rsSolicitud">
									<tr style="font-size: 13 ">									
										 <td>#rsSolicitud.ESnumero#</td>
										<td align="center">#LSDateFormat(rsSolicitud.ESfecha, 'dd/mm/yyyy')#</td>
										<td>#rsSolicitud.ESobservacion#</td>
										<td>#rsSolicitud.CMTSdescripcion#</td>
										<td>#rsSolicitud.CFcodigo#&nbsp;-&nbsp;#rsSolicitud.CFdescripcion#</td>
										<td>#rsSolicitud.Mnombre#</td>
										<td align="right">#rsSolicitud.Msimbolo#&nbsp;#LSCurrencyFormat(rsSolicitud.EStotalest,'none')#</td>
									</tr>
									</cfloop>
									<tr><td nowrap colspan="7">&nbsp;</td></tr>
								</table>
							</td>
						</tr>
					</table>
				</td>		
			</tr>
			<tr>
				<td colspan="2" nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; ">
					Ingrese a <a href='http://#session.sitio.host#/cfmx/sif/cm/consultas/MisSolicitudes-lista.cfm'> Lista de Solicitudes</a> para revisarlo.
				</td>
			</tr>
			<tr>
				<td nowrap colspan="2">&nbsp;</td>
			</tr>
			
			<cfset hostname = session.enombre>
			<cfset CEcodigo = session.CEcodigo>
			
		</table>
	</cfoutput>