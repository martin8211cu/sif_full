<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_templatecss>
<style type="text/css">
	.LetraDetalle{
		font-size:10px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
</style>

<cfset max_lineas = 18 * 1.0>

<cfif isdefined ("url.ESnumero") and len(trim(url.ESnumero)) and not isdefined ("form.ESnumero")>
	<cfset form.ESnumero = url.ESnumero>
</cfif>
<cfif isdefined ("url.CMSid") and len(trim(url.CMSid)) and not isdefined ("form.CMSid")>
	<cfset form.CMSid = url.CMSid>
</cfif>

<cfquery name="rsSolicitud" datasource="#session.DSN#">
	select 	em.Edescripcion,
			b.DSconsecutivo,
			b.DSmontoest,
			b.DStotallinest,
			b.DScant,
			b.Ucodigo,
			b.DSdescalterna,
			b.DSdescripcion,
			b.DSespecificacuenta,
			b.DSformatocuenta,
			b.DSobservacion,
			c.Adescripcion,
			a.ESfecha,
			a.ESnumero,
			a.EStotalest,
			a.Usucodigo,
			em.ETelefono1,
			em.ETelefono2,
			em.EDireccion1,
			em.EDireccion2,
			em.EDireccion3,
			em.EIdentificacion as iden ,
			rtrim(ltrim(e.CMTScodigo)) #_Cat#'-'#_Cat# rtrim(ltrim(e.CMTSdescripcion)) as tipo,
			al.Almcodigo,
			case DStipo when 'A' then coalesce(c.Acodigo,'')
						when 'S' then coalesce(k.Ccodigo,'')
						when 'F' then coalesce(ac.ACcodigodesc,'')
			end as codigo,
			b.DSformatocuenta,
			rtrim(ltrim(d.CFcodigo)) #_Cat#'-'#_Cat# rtrim(ltrim(d.CFdescripcion)) as CFuncional,
			a.ESobservacion,
			a.SNcodigo,
			p.NumeroParte,
			a.ESestado,
			case when a.ESestado = 0 then  'Pendiente'
				when a.ESestado = 10 then 'En Trámite Aprobación'
				when a.ESestado = -10 then  'Rechazada por presupuesto'
				when a.ESestado = 20 then 'Aplicada'
				when a.ESestado = 25 then  'Compra Directa'
				when a.ESestado = 40 then'Parcialmente Surtida'
				when a.ESestado = 50 then  'Surtida'
				when a.ESestado = 60 then  'Cancelada'
			end as estado,
			cfcta.CFformato,
			imp.Iporcentaje,
			a.ProcessInstanceid
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud e
			on a.Ecodigo = e.Ecodigo
		   and a.CMTScodigo = e.CMTScodigo

		inner join Monedas m
			on m.Mcodigo = a.Mcodigo

		inner join Empresas em
			on a.Ecodigo = em.Ecodigo

		left outer join DSolicitudCompraCM b
			inner join CFuncional d
				on b.CFid = d.CFid

			inner join Impuestos imp
				on imp.Ecodigo = b.Ecodigo
			   and imp.Icodigo = b.Icodigo

			left outer join Articulos c
				on c.Aid=b.Aid

			left outer join Almacen al
				on  al.Aid = b.Alm_Aid

			left outer join Conceptos k
				on b.Cid=k.Cid

			left outer join AClasificacion ac
				on b.Ecodigo = ac.Ecodigo
			   and b.ACcodigo = ac.ACcodigo
 			   and b.ACid = ac.ACid

			left outer join CFinanciera cfcta
			on b.CFcuenta = cfcta.CFcuenta

		on a.ESidsolicitud = b.ESidsolicitud

		left outer join NumParteProveedor p
			on c.Aid = p.Aid
			and c.Ecodigo = p.Ecodigo
			and a.SNcodigo = p.SNcodigo
			and a.ESfecha between p.Vdesde and p.Vhasta

	where a.Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero#">
	  and a.CMSid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
	order by a.ESnumero, b.DSconsecutivo
</cfquery>

<cfquery name="rsPreTotales" datasource="#session.DSN#">
	  select coalesce((DScant*DSmontoest),0) as subtotal,
	  		coalesce(round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0) as MotoIEPS,
		  case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1) THEN
		    coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2),0)
		  else
		    coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2),0)
		  end as IVA
	   from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
			left join Impuestos d
				on a.Ecodigo=d.Ecodigo
				and b.codIEPS=d.Icodigo
			left join Conceptos e
				on e.Cid = b.Cid

			left join Articulos f
				on f.Aid= b.Aid
	   where a.Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero#">
		  and a.CMSid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
</cfquery>

<cfquery name="rsTotales" dbtype="query">
	select sum(MotoIEPS) as TotalIEPS, sum(IVA) as impuesto, sum(subtotal) as subtotal
	from rsPreTotales
</cfquery>


<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>

<cfsavecontent variable="encabezado">
	<table width="98%" border="0" cellpadding="0"  cellspacing="0" align="center">
		<tr><td align="center">
			<strong><font size="3">#rsEmpresa.Edescripcion#</font></strong>
		</td></tr>
		<tr><td align="center" bgcolor="##CCCCCC"><font size="2">Gerencia de Compras</font></td></tr>
		<cfif  rsSolicitud.iden  eq '815646-8'>
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">#rsSolicitud.EDireccion1#</font></td>
			</tr>
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">#rsSolicitud.EDireccion2#</font></td>
			</tr>
		</cfif>

		<tr><td>&nbsp;</td></tr>

		<cfif rsSolicitud.RecordCount EQ 0>
			<tr><td align="center"><strong><font size="2">SOLICITUD DE COMPRA No: #form.ESnumero#</font></strong></td></tr>
			<tr><td align="center">&nbsp;</td></tr>
			<tr><td align="center">-------------------   No se encontraron registros   -------------------</td></tr>
		<cfelse>
		<tr><td align="center"><strong><font size="2">SOLICITUD DE COMPRA No: #rsSolicitud.ESnumero#</font></strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
					<tr>
						<td width="13%" nowrap class="LetraEncab">Tipo de solicitud:</td>
						<td width="49%" nowrap class="LetraDetalle">#rsSolicitud.tipo#</td>
						<cfif  rsSolicitud.iden  eq '815646-8'><!---815646-8 2PINOS    305-414-68335 D.V. 49  SOIN--->
						<td nowrap class="LetraEncab">NIT:</td>
						<td nowrap class="LetraEncab">#rsSolicitud.iden#</td>
						</cfif>
						<td width="10%" nowrap class="LetraEncab">Fecha:</td>
						<td width="28%" nowrap class="LetraDetalle">#LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Estado:</td>
						<td nowrap class="LetraDetalle">#rsSolicitud.ESestado#&nbsp;-&nbsp;#rsSolicitud.estado#</td>
						<td nowrap class="LetraEncab">No Solicitud:</td>
						<td nowrap class="LetraDetalle">#rsSolicitud.ESnumero#</td>
					</tr>
				</table>
			</td>
		</tr>
		</cfif>
	</table>
</cfsavecontent>

	<cfif rsSolicitud.RecordCount NEQ 0>
		<cfset contador = 0 >
		<!---
		<cfset vnTotalEstimado = 0>
		--->
		<table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">
			<!--- Primer Loop para pintar las líneas de solicitud --->
			 <cfloop query="rsSolicitud">
				<cfif (isdefined("Url.imprimir") and contador eq max_lineas) or rsSolicitud.Currentrow eq 1>
					<tr><td colspan="11">
						#encabezado#
					</td></tr>
					<tr class="titulolistas">
						<td class="LetraEncab" width="1%">L&iacute;n.</td>
						<td class="LetraEncab">Bodega</td>
						<td class="LetraEncab">N° Artículo</td>
						<td class="LetraEncab">##Parte</td>
						<td class="LetraEncab">Descripción</td>
						<td class="LetraEncab">N° Cta.</td>
						<td class="LetraEncab">Ctro.Funcional</td>
						<td class="LetraEncab">UM</td>
						<td class="LetraEncab">Cantidad</td>
						<td align="right" class="LetraEncab">Costo Unit.</td>
						<td align="right" class="LetraEncab">Valor Total</td>

					</tr>
					<cfset contador = 0 >
				</cfif>
				  <tr>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle" width="1%">#rsSolicitud.DSconsecutivo#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.Almcodigo#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.codigo#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.NumeroParte#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.DSdescripcion#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">
						<cfif rsSolicitud.DSespecificacuenta EQ 1>
							#rsSolicitud.DSformatocuenta#
						<cfelseif rsSolicitud.DSespecificacuenta EQ 0>
							#rsSolicitud.CFformato#
						</cfif>
						&nbsp;
					</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.Cfuncional#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.Ucodigo#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" class="LetraDetalle">#rsSolicitud.DScant#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" align="right" class="LetraDetalle">#LvarOBJ_PrecioU.enCF_RPT(rsSolicitud.DSmontoest)#&nbsp;</td>
					<td style="border-bottom: 1px solid gray;" align="right" class="LetraDetalle">#LSNumberFormat(rsSolicitud.DStotallinest,',9.00')#&nbsp;</td>
				</tr>

				<cfif isdefined("Url.imprimir") and rsSolicitud.Currentrow mod max_lineas EQ 0>
					  <tr>
						<td colspan="11" align="right" class="LetraDetalle">Pág. #Int(rsSolicitud.Currentrow / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#</td>
					  </tr>
					  <tr class="pageEnd">
						<td colspan="11" class="LetraDetalle">&nbsp;</td>
					  </tr>
				</cfif>

				<cfset contador = contador + 1 >
				<!---
				<cfset vnTotalEstimado = vnTotalEstimado + rsSolicitud.DStotallinest>
				--->
			 </cfloop>

			<tr>
			 	<td colspan="11" class="LetraDetalle">&nbsp;</td>
			</tr>

			 <cfset contador = rsSolicitud.recordCount>

			 <!--- Segundo Loop para pintar las descripciones y observaciones de las líneas de solicitud --->
			 <cfloop query="rsSolicitud">
				<cfif (isdefined("Url.imprimir") and contador eq max_lineas)>
					<tr><td colspan="11">
						#encabezado#
					</td></tr>
					<tr class="titulolistas" >
						<td class="LetraEncab" width="1%">L&iacute;n.</td>
						<td colspan="10" class="LetraEncab">Descripci&oacute;n Alterna</td>
					</tr>
					<cfset contador = 0 >
				</cfif>

				<tr>
				  <td width="1%" class="LetraDetalle">#rsSolicitud.DSconsecutivo#</td>
				  <td colspan="10" class="LetraDetalle"><cfif len(trim(rsSolicitud.DSdescalterna))>#rsSolicitud.DSdescalterna#<cfelse>---</cfif> </td>
				</tr>
				<tr>
				  	<td colspan="11" style="border-bottom: 1px solid gray;"><table><tr>
						<td  class="LetraEncab">
							Observaciones:&nbsp;
						</td>
						<td class="LetraDetalle">
							<cfif len(trim(rsSolicitud.DSobservacion))>#rsSolicitud.DSobservacion#<cfelse>---</cfif>
						</td>
					</tr></table></td>
				</tr>

				<cfif isdefined("Url.imprimir") and (rsSolicitud.recordCount + rsSolicitud.Currentrow) NEQ (rsSolicitud.recordCount * 2) and (rsSolicitud.recordCount + rsSolicitud.Currentrow) mod max_lineas EQ 0>
					  <tr>
						<td colspan="11" align="right" class="LetraDetalle">Pág. #Int((rsSolicitud.recordCount + rsSolicitud.Currentrow) / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#</td>
					  </tr>
					  <tr class="pageEnd">
						<td colspan="11">&nbsp;</td>
					  </tr>
				</cfif>

				<cfset contador = contador + 1 >
			 </cfloop>

			 <cfif rsSolicitud.recordCount>
			 <tr>
				<td colspan="11" align="right">
					<table>
					  <tr>
						<td align="right" class="LetraEncab">Subtotal Estimado:</td>
						<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.subtotal,',9.00')#</td>
					  </tr>
					  <tr>
						<td align="right" class="LetraEncab">IEPS Estimado:</td>
						<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.TotalIEPS,',9.00')#</td>
					  </tr>
					  <tr>
						<td align="right" class="LetraEncab">Impuesto Estimado:</td>
						<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.impuesto,',9.00')#</td>
					  </tr>
					  <tr>
						<td align="right" class="LetraEncab">Total Estimado:</td>
						<td align="right" class="LetraEncab">#LSNumberFormat(rsSolicitud.EStotalest,',9.00')#</td>
					  </tr>
				  </table>
				</td>
			 </tr>
			 </cfif>

			<tr><td colspan="11">&nbsp;</td></tr>

			<tr>
				<td colspan="11"><table><tr>
				<td class="LetraEncab">Observaciones:</td>
				<td colspan="10" class="LetraDetalle">#rsSolicitud.ESobservacion#</td>
				</tr></table></td>
			</tr>
			<tr><td colspan="11">&nbsp;</td></tr>
			<tr>
				<td colspan="11"><table><tr>
					<!--- Obtiene el login y el nombre del Usucodigo de la tabla ESolicitudCompraCM ----->
					<cfquery name="rsLogin" datasource="#session.DSN#">
						select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
						from Usuario a
							left outer join DatosPersonales b
								on a.datos_personales = b.datos_personales
						where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.Usucodigo#">
					</cfquery>
					<td nowrap valign="top" class="LetraEncab">
						Usuario que aplicó:
					</td>
					<td colspan="10" valign="top" class="LetraDetalle">
						<cfif rsLogin.RecordCount NEQ 0>&nbsp;#rsLogin.nombre#&nbsp;</cfif>
					</td>
				</tr></table></td>
			</tr>
			<tr>
				<td colspan="11"><table><tr>
					<td nowrap valign="top" class="LetraEncab">
						<!--- Obtiene el Nombre del usuario que aprobó --->
						Usuario que aprob&oacute;:
					</td>
					<td colspan="10" valign="top" class="LetraDetalle">
						<cfif Len(Trim(rsSolicitud.ProcessInstanceid))>
							<cfquery name="rsParticipante" datasource="#Session.DSN#">
								select b.Description
								from WfxActivity a, WfxActivityParticipant b
								where a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.ProcessInstanceid#">
								and a.ActivityInstanceId = b.ActivityInstanceId
								and b.HasTransition = 1
							</cfquery>
							<cfif rsParticipante.recordCount>
								<cfloop query = "rsParticipante">
									&nbsp;#rsParticipante.Description#&nbsp;<br>
								</cfloop>
							<cfelse>
								<cfif rsLogin.RecordCount NEQ 0>
									&nbsp;#rsLogin.nombre#&nbsp;
								</cfif>
							</cfif>
						<cfelse>
							<cfif rsLogin.RecordCount NEQ 0>
								&nbsp;#rsLogin.nombre#&nbsp;
							</cfif>
						</cfif>
					</td>
				</tr></table></td>
			</tr>

			<cfif isdefined("Url.imprimir") and rsSolicitud.recordCount>
			<tr>
				<td height="44" colspan="11" align="right" class="LetraDetalle">
					Pág. #Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#
				</td>
			</tr>
			</cfif>

			</table>
  </cfif>
</cfoutput>