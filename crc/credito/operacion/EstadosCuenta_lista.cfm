<cfset filterUsr = "">
<cfif parentEntrancePoint eq 'Cuentas.cfm'>
	<cfquery name="q_usuario" datasource="#session.DSN#">
		select llave from UsuarioReferencia where Usucodigo = #session.usucodigo#
	</cfquery>
	<cfset filterUsr = "(c.DatosEmpleadoDEid = #q_usuario.llave# or c.DatosEmpleadoDEid2 = #q_usuario.llave#) and">
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
						<cfoutput>
							<cfform action="#parentEntrancePoint#" method="post" name="formfiltro" style="margin:0;">
								<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
									<tr>
										<td width="20%"><b>Numero</b></td>
										<td width="30%"><b>Socio de Negocio</b></td>
										<td width="30%"><b>Estado</b></td>
										<td width="15%" nowrap>&nbsp;</td>
									</tr>
									<tr>
										<td>
											<input type="text" name="numero" maxlength="10" size="20" value="<cfif isdefined('form.numero')>#form.numero#</cfif>">
										</td>
										<td>
											<cfset ArrSN = ArrayNew(1)>
											<cfif isdefined('form.SNid') and isdefined('form.SNnumero') and isdefined('form.SNnombre')>
												<cfset ArrayAppend(ArrSN,form.SNid)>
												<cfset ArrayAppend(ArrSN,form.SNnumero)>
												<cfset ArrayAppend(ArrSN,form.SNnombre)>
											</cfif>
											<cf_conlis
												Campos="SNid,SNnumero,SNnombre"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,10,30"
												tabindex="2"
												ValuesArray="#ArrSN#"
												Tabla="Snegocios"
												Columnas="SNid,SNnumero,SNnombre"
												form="formfiltro"
												Filtro="Ecodigo = #Session.Ecodigo# and (disT = 1 or TarjH = 1 or Mayor = 1) and eliminado is null
														order by SNnombre"
												Desplegar="SNnumero,SNnombre"
												Etiquetas="Codigo, Nombre"
												filtrar_por="SNnumero,SNnombre"
												Formatos="S,S"
												Align="left,left"
												Asignar="SNid,SNnumero,SNnombre"
												Asignarformatos="S,S,S"/>
										</td>
										<td>
											<cfquery name="rsEstatus" datasource="#session.dsn#">
												select id, Descripcion from CRCEstatusCuentas where Ecodigo=#Session.Ecodigo# order by Orden
											</cfquery>
											<select name="Estado">
												<option value="">Todos</option>
												<cfloop query="rsEstatus">
													<option value="#rsEstatus.id#" <cfif isdefined('form.Estado') and form.Estado eq rsEstatus.id > selected </cfif>>#rsEstatus.Descripcion#</option>
												</cfloop>
											</select>
										</td>
										<td>
											<input type="submit" name="bFiltrar" value="#BTN_Filtrar#" class="btnFiltrar">
										</td>
									</tr>
									<tr>
										<td><b>Tipo</b></td>
										<td >
											<span class="trToogle">
											<b>Catgoria</b>
											</span>
										</td>
									</tr>
									<tr>
										<td >
											<label><input type="checkbox" class="chkToogle" id="AplicaVales" name="AplicaVales" <cfif isdefined('form.AplicaVales')> checked </cfif>><cf_translate key="LB_Vales" XmlFile="/crc/generales.xml">Vales</cf_translate></label>
											<label><input type="checkbox" id="AplicaTC" name="AplicaTC" <cfif isdefined('form.AplicaTC')> checked </cfif>><cf_translate key="LB_TC" XmlFile="/crc/generales.xml">Tarjeta de Credito</cf_translate></label>
											<label><input type="checkbox" id="AplicaTM" name="AplicaTM" <cfif isdefined('form.AplicaTM')> checked </cfif>><cf_translate key="LB_TM" XmlFile="/crc/generales.xml">Tarjeta Mayorista</cf_translate></label>
										</td>
										<td>
											<cfquery name="rsCategoria" datasource="#session.dsn#">
												select id, Titulo from CRCCategoriaDist where Ecodigo = #Session.Ecodigo# order by Orden
											</cfquery>
											<span class="trToogle">
											<select name="Categoria">
												<option value="">Todos</option>
												<cfloop query="rsCategoria">
													<option value="#rsCategoria.id#" <cfif isdefined('form.Categoria') and form.Categoria eq rsCategoria.id > selected </cfif>>#rsCategoria.Titulo#</option>
												</cfloop>
											</select>
											</span>
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
	<tr>
		<td valign="top">
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="CRCCuentas c
						inner join SNegocios s
							on s.SNid = c.SNegociosSNid
						left join CRCCategoriaDist cd
							on c.CRCCategoriaDistid = cd.id
						left join CRCEstatusCuentas ec
							on c.CRCEstatusCuentasid = ec.id"
				columnas="c.id, c.Numero,c.SNegociosSNid,c.Tipo,
							case c.Tipo
								when 'D' then 'Vales'
								when 'TC' then 'Tarjeta de Credito'
								when 'TM' then 'Tarjeta Mayorista'
								else ''
							end as TipoDescripcion,c.CRCCategoriaDistid,c.CRCEstatusCuentasid,s.SNnombre,cd.Titulo,ec.Descripcion as Estado"
				desplegar="Numero,SNnombre,TipoDescripcion,Estado,Titulo"
				etiquetas="Numero de Cuenta,Socio de Negocio,Tipo,Estado,Categoria"
				formatos="S,S,S,S,S"
				filtro="#filterUsr#  c.Ecodigo=#session.Ecodigo# #strFIltro# and s.eliminado is null order by Numero"
				align="left,left,left,left,left"
				checkboxes="N"
				ira="#parentEntrancePoint#"
				keys="id">
			</cfinvoke>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>

<script>
$(document).ready(function(){
	<cfif not isdefined('form.AplicaVales')>
		 $(".trToogle").toggle();
	</cfif>
    $(".chkToogle").change(function(){
        $(".trToogle").toggle();
    });
});
</script>