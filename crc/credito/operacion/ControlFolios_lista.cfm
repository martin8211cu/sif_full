<cfhtmlhead text='<link href="/cfmx/jquery/estilos/jquery.modallink/jquery.modalLink-1.0.0.css" rel="stylesheet" type="text/css" />'>
<cfhtmlhead text='<script type="text/javascript" language="JavaScript" src="/cfmx/jquery/librerias/jquery.modallink/jquery.modalLink-1.0.0.js">//</script>'>


<cfset strFIltro = " and (1=1 or s.disT = 1 or s.TarjH = 1 or s.Mayor = 1)">
<cfif isdefined('form.Numero') and trim(form.Numero) neq ""><cfset strFIltro = "#strFIltro# and cf.Numero like '#trim(form.Numero)#'"></cfif>
<cfif isdefined('form.Lote') and trim(form.Lote) neq ""><cfset strFIltro = "#strFIltro# and Lote like '%#trim(form.Lote)#%'"></cfif>
<cfif isdefined('form.Tipo') and form.Tipo neq ""><cfset strFIltro = "#strFIltro# and substring(cf.Numero,5,1) = '#form.Tipo#'"></cfif>
<cfif isdefined('form.Estado') and form.Estado neq ""><cfset strFIltro = "#strFIltro# and Estado = '#form.Estado#'"></cfif>
<cfif isdefined('form.Cuentaid') and form.Cuentaid neq ""><cfset strFIltro = "#strFIltro# and c.id = '#form.Cuentaid#'"></cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
						<cfoutput>
							<cfform action="ControlFolios.cfm" method="post" id="formfiltro" name="formfiltro" style="margin:0;">
								<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
									<tr>
										<td width="20%" align="right">
											<b>Lote:&nbsp;</b>
											<input type="text" name="Lote" maxlength="10" size="20" value="<cfif isdefined('form.Lote')>#form.Lote#</cfif>">
										</td>
										</td>
										<td align="right" nowrap colspan="2">
											<b>Socio de Negocio:&nbsp;</b>
											<cfset ArrSN = ArrayNew(1)>
											<cfif isdefined('form.Cuentaid') and isdefined('form.SNid') and isdefined('form.SNnumero') and isdefined('form.SNnombre')>
												<cfset ArrayAppend(ArrSN,form.Cuentaid)>
												<cfset ArrayAppend(ArrSN,form.SNid)>
												<cfset ArrayAppend(ArrSN,form.SNnumero)>
												<cfset ArrayAppend(ArrSN,form.SNnombre)>
											</cfif>
											<cf_conlis
												Campos="Cuentaid,SNid,SNnumero,SNnombre"
												Desplegables="N,N,S,S"
												Modificables="N,N,S,N"
												Size="0,0,10,30"
												tabindex="2"
												ValuesArray="#ArrSN#"
												Tabla="Snegocios s inner join CRCCuentas c
														on c.SNegociosSNid = s.SNid
														and c.Tipo = 'D'"
												Columnas="id as Cuentaid,SNid,SNnumero,SNnombre"
												form="formfiltro"
												Filtro=" s.Ecodigo = #Session.Ecodigo# and (disT = 1) and s.eliminado is null
														order by SNnombre"
												Desplegar="SNnumero,SNnombre"
												Etiquetas="Codigo, Nombre"
												filtrar_por="SNnumero,SNnombre"
												Formatos="S,S"
												Align="left,left"
												Asignar="Cuentaid,SNid,SNnumero,SNnombre"
												Asignarformatos="S,S,S"/>
										</td>
										<td width="15%" nowrap align="center"><input type="submit" name="bFiltrar" value="#BTN_Filtrar#" class="btnFiltrar"></td>
									</tr>
									<tr>
										<td width="20%" align="right">
											<b>Folio:&nbsp;</b>
											<input type="text" name="Numero" maxlength="10" size="20" value="<cfif isdefined('form.Numero')>#form.Numero#</cfif>">
										</td>
										<td width="10%" align="right" nowrap>
											<b>Estado:&nbsp;</b>
											<cfquery name="rsEstatus" datasource="#session.dsn#">
												select id, Descripcion from CRCEstatusCuentas where Ecodigo=#Session.Ecodigo# order by Orden
											</cfquery>
											<select name="Estado">
												<option value="">Todos</option>
												<option value="G" <cfif isdefined('form.Estado') and form.Estado eq "G" > selected </cfif>>Generado</option>
												<option value="I" <cfif isdefined('form.Estado') and form.Estado eq "I" > selected </cfif>>Impreso</option>
												<option value="A" <cfif isdefined('form.Estado') and form.Estado eq "A" > selected </cfif>>Activo</option>
												<option value="C" <cfif isdefined('form.Estado') and form.Estado eq "C" > selected </cfif>>Consumido</option>
												<option value="X" <cfif isdefined('form.Estado') and form.Estado eq "X" > selected </cfif>>Cancelado</option>
											</select>
										</td>
										<td width="10%" align="right" nowrap>
											<b>Tipo:&nbsp;</b>
											<cfquery name="rsEstatus" datasource="#session.dsn#">
												select id, Descripcion from CRCEstatusCuentas where Ecodigo=#Session.Ecodigo# order by Orden
											</cfquery>
											<select name="Tipo">
												<option value="">Todos</option>
												<option value="0" <cfif isdefined('form.Tipo') and form.Tipo eq "0" > selected </cfif>>Vale</option>
												<option value="1" <cfif isdefined('form.Tipo') and form.Tipo eq "1" > selected </cfif>>Contravale</option>
											</select>
										</td>
										<td align="center">
											<a href="ControlFolios_crear.cfm" class="modal-link">
												<input type="button" name="bAgregar" value="Nuevo Lote" class="btnNuevo">
											</a>
											<a href="ControlFolios_cancelar.cfm" class="modal-link">
												<input type="button" name="bCancela" value="Cancelacion" class="btnEliminar">
											</a>
										</td>
									</tr>
								</table>
							</cfform>
						</cfoutput>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<cfif isdefined("form.bfiltrar")>
		<tr>
			<td valign="top">
				<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
					tabla="CRCControlFolio cf
							inner join CRCCuentas c
								on cf.CRCCuentasid = c.id
							inner join SNegocios s
								on c.SNegociosSNid = s.SNid "
					columnas="cf.id as Folioid, cf.Lote, cf.Numero, cf.FechaHasta,
								case cf.Estado
									when 'G' then 'Generado'
									when 'I' then 'Impreso'
									when 'A' then 'Activo'
									when 'C' then 'Consumido'
									when 'X' then 'Cancelado'
								end as Estado,
								case   
									when cf.Lote like 'IM%' then'Vale'
										else
											CASE substring(cf.Numero, 5, 1)
											WHEN '0' THEN 'Vale'
											ELSE 'Contravale'
											END
								end as Tipo, s.SNnombre, cf.FechaExpiracion"
					desplegar="Lote,Numero,Estado,Tipo,SNnombre, FechaExpiracion"
					etiquetas="Lote,Numero,Estado,Tipo,Asignado a, Fecha de Expiraci&oacute;n"
					formatos="S,S,S,S,S,D"
					filtro="cf.Ecodigo=#session.Ecodigo# #strFIltro# order by Numero"
					align="left,left,left,left,left,left"
					checkboxes="N"
					maxrowQuery="100"
					showlink="false"
					ira="ControlFolios.cfm"
					keys="Folioid">
				</cfinvoke>
			</td>
		</tr>
	</cfif>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>


<script>
$(document).ready(function(){
	$(".modal-link").on("modallink.close", function() {
		$("#formfiltro").submit();
	});
});
</script>

<script>
	$(function () {

	        $(".modal-link").modalLink({
		        title: '',
		        height: 250,
				width: 600
		    });

	});
</script>