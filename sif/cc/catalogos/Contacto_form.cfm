<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and (not isdefined("form.SNcodigo") or len(trim(form.SNcodigo)) eq 0)>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.nuevo") and len(trim(url.nuevo))>
	<cfset form.Nuevo = url.Nuevo>
</cfif>

<cfif isdefined("url.CSEid") and len(trim(url.CSEid))>
	<cfset form.CSEid = url.CSEid>
</cfif>

<cfset modo = "ALTA">
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsSNid" datasource="#session.DSN#">
		select 
			SNid, 
			SNnombre
		from SNegocios
		where Ecodigo = #session.Ecodigo#
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
	<cfif  not isdefined("form.Nuevo")>
		<cf_dbfunction name="to_char" args="ds.SNDcodigo" returnvariable="LvarSNDcodigo">
		<cfquery name="rsContactoSocio" datasource="#session.DSN#">
			select 
				cs.CSEid, 
				cs.id_direccion,
				<cf_dbfunction name="concat" args="#LvarSNDcodigo#+' ' + ds.SNnombre" delimiters="+"> as Direccion,
				hd.CCTcodigo,
				hd.Ddocumento,
				cs.HDid, 
				us.Usulogin, 
				cs.CSEFecha, 
				CSEEstatus,
				cs.TCid, 
				cs.CSEnombreContacto,
				cs.CSEDetalleContacto,
				cs.Usucodigo
			from ContactoSocioE cs
				inner join Usuario us
					on us.Usucodigo = cs.Usucodigo
	
				left outer join HDocumentos hd
					on hd.HDid = cs.HDid
	
				left outer join SNDirecciones ds
					on ds.SNid = cs.SNid
					and ds.id_direccion = cs.id_direccion
			where cs.SNid = #rsSNid.SNid# 
			<cfif isdefined("form.CSEid") and len(trim(form.CSEid))>
				and cs.CSEid = #form.CSEid#
			</cfif>
			  and cs.CSEEstatus = 1 <!--- Abierto --->
		</cfquery>
		<cfif rsContactoSocio.recordcount eq 1>
			<cfset modo = "CAMBIO">
		</cfif>
	</cfif>
</cfif>
			
<cfoutput>
	<form name="form1" action="Contacto_sql.cfm" method="post">
		<input name="CSEid" type="hidden" id="CSEid" tabindex="-1" value="<cfif isdefined("rsContactoSocio") and len(trim(rsContactoSocio.CSEid))>#rsContactoSocio.CSEid#</cfif>">
		<input name="SNcodigo" type="hidden" tabindex="-1" value="#form.SNcodigo#">	
		<input name="SNid" type="hidden" tabindex="-1" value="<cfif isdefined("rsSNid") and len(trim(rsSNid.SNid))>#rsSNid.SNid#</cfif>">	
		<table width="100%" border="0" cellspacing="2" cellpadding="0">
			<tr>
				<td colspan="4" align="center"><strong>Socio:&nbsp;#rsSNid.SNnombre#</strong></td>
			</tr>
			<tr>
				<td nowrap align="right"><strong>Fecha:&nbsp;</strong></td>
				<td nowrap align="left">
					<cfif modo EQ 'CAMBIO'>
						<cfset fecha = LSDateFormat(rsContactoSocio.CSEFecha,'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
					</cfif>
					#fecha#
				</td>
				<cfquery name="rsTipoContacto" datasource="#session.DSN#">
					select 
						TCid,
						TCcodigo, 
						TCdescripcion 
					from TipoContacto 
					where Ecodigo = #session.Ecodigo#
					order by TCdescripcion
				</cfquery>
				<td align="right" nowrap="nowrap"><strong>Tipo Contacto:</strong>&nbsp;</td>
				<td align="left">
					<select name="TCid" id="TCid" tabindex="1">
						<cfloop query="rsTipoContacto">
							<option value="#rsTipoContacto.TCid#" <cfif isdefined("rsContactoSocio") and rsTipoContacto.TCid eq rsContactoSocio.TCid>selected</cfif>>#rsTipoContacto.TCdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap" style="width:50%"><strong>Nombre Contacto:</strong>&nbsp;</td>
				<td>
					<input name="CSEnombreContacto" type="text" id="CSEnombreContacto" tabindex="1" value="<cfif isdefined("rsContactoSocio.CSEnombreContacto") and len(trim(rsContactoSocio.CSEnombreContacto))>#rsContactoSocio.CSEnombreContacto#</cfif>" size="77" maxlength="256">
				</td>
				<td align="left" colspan="2">
					<input name="CSEEstatus" type="radio" id="CSEEstatus1" tabindex="1" title="Estado" value="1" <cfif isdefined("rsContactoSocio") and rsContactoSocio.CSEEstatus eq 1>checked="checked"</cfif>>&nbsp;<label for="CSEEstatus1">Abierto</label>
					<input name="CSEEstatus" type="radio" id="CSEEstatus0" tabindex="1" title="Estado" value="0" <cfif isdefined("rsContactoSocio") and rsContactoSocio.CSEEstatus eq 0>checked="checked"</cfif>>&nbsp;<label for="CSEEstatus0">Cerrado</label>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Responsable:</strong>&nbsp;</td>
				<td colspan="3">
					<cf_dbfunction name="concat" args="dp.Pnombre, ' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvarnombre">
					<cfset LvarValues = "">
					<cfif modo eq 'ALTA'>
						<cfquery name="rsValues" datasource="#session.DSN#">
							select
								u.Usucodigo,
								u.Usulogin,
								dp.Pid as Identificacion, 
								#PreserveSingleQuotes(Lvarnombre)# as nombre
							from Usuario u 
								inner join DatosPersonales dp 
									on dp.datos_personales = u.datos_personales
							where Usucodigo = #session.Usucodigo#
							  and u.Utemporal = 0
							  and u.Uestado=1
							  and u.CEcodigo=#session.CEcodigo#
							order by dp.Pid
						</cfquery>
						<cfset LvarValues = '#rsValues.Usucodigo#'&','&'#rsValues.Identificacion#'&','&'#rsValues.Usulogin#'&','&'#rsValues.nombre#'>
					<cfelse>
						<cfquery name="rsValues" datasource="#session.DSN#">
							select
								u.Usucodigo,
								u.Usulogin,
								dp.Pid as Identificacion, 
								#PreserveSingleQuotes(Lvarnombre)# as nombre
							from Usuario u 
								inner join DatosPersonales dp 
									on dp.datos_personales = u.datos_personales
							where Usucodigo = #rsContactoSocio.Usucodigo#
							  and u.Utemporal = 0
							  and u.Uestado=1
							  and u.CEcodigo=#session.CEcodigo#
							order by dp.Pid
						</cfquery>
						<cfset LvarValues = '#rsValues.Usucodigo#'&','&'#rsValues.Identificacion#'&','&'#rsValues.Usulogin#'&','&'#rsValues.nombre#'>
					</cfif>
					
					<cf_conlis
						campos="Usucodigo,Identificacion,Usulogin,nombre"
						desplegables="N,S,S,S"
						Values="#LvarValues#"
						modificables="N,S,N,N"
						size="0,14,14,40"
						title="Lista de Usuarios"
						tabla="Usuario u
							inner join DatosPersonales dp
							on dp.datos_personales=u.datos_personales"
						columnas="u.Usucodigo,u.Usulogin,dp.Pid as Identificacion, 
							#Lvarnombre# as nombre"
						filtro="u.Utemporal = 0
							and u.Uestado=1
							and u.CEcodigo=#session.CEcodigo#
							order by dp.Pid "
						desplegar="Identificacion,Usulogin,nombre"
						filtrar_por="dp.Pid|Usulogin|{fn concat({fn concat({fn concat({fn concat(dp.Papellido1 , ' ' )}, dp.Papellido2 )},  ' ' )}, dp.Pnombre )}"
						filtrar_por_delimiters="|"
						etiquetas="Identificaci&oacute;n,Login,Usuario"
						formatos="S,S,S"
						align="left,left,left"
						asignar="Usucodigo,Identificacion,Usulogin,nombre"
						asignarformatos="S, S, S, S"
						showEmptyListMsg="true"
						EmptyListMsg="-- No se encontraron usuarios--"
						tabindex="1">
				</td>
			</tr>
			<tr>
				<td  align="right"><strong>Direcci&oacute;n:</strong>&nbsp;</td>
				<td>
					<cfquery datasource="#session.dsn#" name="direcciones">
						select 
							b.id_direccion, 
							SNDcodigo as texto_direccion
						from SNegocios a
							inner join SNDirecciones b
								on a.SNid = b.SNid
						where a.Ecodigo = #Session.Ecodigo#
						  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
					</cfquery>
					<select style="width:170px" name="id_direccion" id="id_direccion" tabindex="1" >
						<cfloop query="direcciones">
							<option value="#id_direccion#" <cfif isdefined('form.id_direccion') and id_direccion EQ form.id_direccion>selected</cfif>>
								#HTMLEditFormat(texto_direccion)#
							</option>
						</cfloop>
					</select>
				</td>
				<td align="right" nowrap="nowrap"><strong>Referencia:</strong>&nbsp;</td>
				<td>
					<cfset LvarValues = "">
					<cfif modo eq 'CAMBIO' and isdefined("rsContactoSocio") and len(trim(rsContactoSocio.HDid))>
						<cfquery name="rsReferencia" datasource="#session.DSN#">
							select 
								HDid, 
								Mnombre, 
								CCTcodigo, 
								Ddocumento
							from HDocumentos a 
								inner join Monedas b
									on b.Mcodigo = a.Mcodigo
							where HDid = #rsContactoSocio.HDid#
						</cfquery>
						<cfset LvarValues = '#rsReferencia.HDid#'&','&'#rsReferencia.Mnombre#'&','&'#rsReferencia.CCTcodigo#'&','&'#rsReferencia.Ddocumento#'>
					</cfif>
					
					<cf_conlis
						campos="HDid, Mnombre, CCTcodigo, Ddocumento"
						desplegables="N,N,S,S"
						modificables="N,N,N,S"
						values="#LvarValues#"
						size="0,0,2,20"
						title="Lista de Documentos Aplicados (#rsSNid.SNnombre#)"
						tabla="HDocumentos a 
								inner join Monedas b
									on b.Mcodigo = a.Mcodigo"
						columnas="a.HDid, a.CCTcodigo, a.Ddocumento, b.Mnombre, a.id_direccionFact"
						filtro="a.SNcodigo = #form.SNcodigo#
							and a.Ecodigo = #session.Ecodigo#
							and a.id_direccionFact = $id_direccion,numeric$
							order by  a.CCTcodigo, a.Ddocumento"
						desplegar="CCTcodigo, Ddocumento, Mnombre"
						filtrar_por="CCTcodigo|Ddocumento|Mnombre"
						filtrar_por_delimiters="|"
						etiquetas="Transacción,Documento,Moneda"
						formatos="S,S,S"
						align="left,left,left"
						asignar="HDid,CCTcodigo,Ddocumento"
						asignarformatos="S, S, S"
						showEmptyListMsg="true"
						EmptyListMsg="-- No se encontraron Documentos --"
						MaxRowsQuery="300"
						MaxRows="20"
						tabindex="1">
				</td>
			</tr>
			<!--- <tr>
				<td nowrap align="right"><strong>Fecha&nbsp;Soluci&oacute;n:&nbsp;</strong></td>
				<td nowrap align="left">
					<cfif modo EQ 'CAMBIO'>
						<cfset fecha = LSDateFormat(rsContactoSocio.CSEFechaSolucion,'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha = "">
					</cfif>
					<cf_sifcalendario name="CSEFechaSolucion" tabindex='1' form="form1" value="#fecha#">
				</td>
			</tr> --->
			<tr>
				<cfset LvarTextoEscribible = "">
				<cfif isdefined("rsContactoSocio") and len(trim(rsContactoSocio.CSEDetalleContacto))>
					<cfset LvarTextoEscribible = rsContactoSocio.CSEDetalleContacto>
				</cfif>
				<td valign="top" align="right"><strong>Detalle:</strong>&nbsp;</td>
				<td colspan="3" style="width:10%">
					<textarea style="width:750px; height:150px" label="CSEDetalleContacto" title="Detalle del contacto" tabindex="1" name="CSEDetalleContacto" id="CSEDetalleContacto">#LvarTextoEscribible#</textarea>
				</td>
			</tr>
		</table>
		<cf_botones modo="#modo#" tabindex="1" exclude="Baja" include="Cerrar">
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcCerrar(){
	window.close();
		deshabilitarValidacion_form1();
	}
</script>

<cf_qforms>
	<cf_qformsRequiredField name="Identificacion" description="Identificación">
	<cf_qformsRequiredField name="CSEEstatus" description="Estado">
	<cf_qformsRequiredField name="CSEDetalleContacto" description="Detalle Contacto">
	<cf_qformsRequiredField name="TCid" description="Tipo Contacto">
	<cf_qformsRequiredField name="CSEnombreContacto" description="Nombre Contacto">
</cf_qforms> 