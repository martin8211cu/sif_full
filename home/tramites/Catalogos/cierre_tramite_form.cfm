<!--- 
	Creado por: Gustavo Fonseca Hernández.
		Fecha: 25-8-2005.
		Motivo: Creación del Mantenimiento de la tabla: TPTramiteCierreDoc.
 --->


<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->


<cfinvoke component="home.tramites.componentes.cierre"
	method="datos_fijos" returnvariable="datos_fijos">
</cfinvoke>

<!--- ver si es un tipo de identificacion, y si es para personas o no --->

<cfquery name="tipo_ident_asociado" datasource="#session.tramites.dsn#">
	select ti.id_tipoident, ti.es_fisica
	from TPTramite tr
		join TPTipoIdent ti
			on ti.id_documento = tr.id_documento_generado
	where tr.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
</cfquery>


<cfparam name="form.id_tramite" type="numeric">

<cfquery name="rsCampos" datasource="#session.tramites.dsn#">
	select 
		e.id_campo_req,
		a.nombre_tipo, 
		b.nombre_documento, 
		b.ts_rversion,
		d.nombre_campo,
		d.id_campo,
		e.campo_fijo,
		e.modificable
	from DDTipo a
		inner join TPDocumento b
			on b.id_tipo = a.id_tipo 
		inner join TPTramite c
			on c.id_documento_generado = b.id_documento
		inner join DDTipoCampo d
			on d.id_tipo = a.id_tipo
		left outer join TPTramiteCierreDoc e
			on e.id_tramite = c.id_tramite
			and e.id_campo_doc= d.id_campo
	where c.id_tramite =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	order by d.orden_campo
</cfquery>


<cfif tipo_ident_asociado.RecordCount>
	<!--- solo para documentos que son un tipo de identificacion --->
	<cfquery name="rsCamposPersona" datasource="#session.tramites.dsn#">
		select 
			e.campo_persona,
			e.id_campo_req,
			e.campo_fijo,
			e.modificable
		from TPTramiteCierrePers e
		where e.id_tramite =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
	
	<!---
		JOIN A PATA; NI MODO
	--->
	
	<cfquery dbtype="query" name="rsDatosFijos">
		select 
			codigo,
			nombre,
			'' as id_campo_req,
			'' as campo_fijo,
			0  as modificable
		from datos_fijos
		<cfif tipo_ident_asociado.es_fisica NEQ 1>
		where codigo in ('IDN','NOM')
		</cfif>
	</cfquery>
	
	<cfloop query="rsDatosFijos">
		<cfquery dbtype="query" name="subquery">
			select id_campo_req, campo_fijo, modificable
			from rsCamposPersona
			where campo_persona = '#rsDatosFijos.codigo#'
		</cfquery>
		<cfset QuerySetCell(rsDatosFijos, 'id_campo_req', subquery.id_campo_req, rsDatosFijos.CurrentRow)>
		<cfset QuerySetCell(rsDatosFijos, 'campo_fijo',   subquery.campo_fijo,   rsDatosFijos.CurrentRow)>
		<cfset QuerySetCell(rsDatosFijos, 'modificable',  subquery.modificable,  rsDatosFijos.CurrentRow)>
	</cfloop>

</cfif>
<cfquery name="rsOrigen" datasource="#session.tramites.dsn#">
	select 
		--a.id_documento,
		c.nombre_tipo,
		a.nombre_requisito,
		d.nombre_campo,
		d.id_campo
	from TPRReqTramite x
		inner join TPRequisito a
			on a.id_requisito = x.id_requisito
			and a.es_impedimento = 0
		inner join TPDocumento b
			on b.id_documento =  a.id_documento
		inner join DDTipo c
			on c.id_tipo = b.id_tipo
		inner join DDTipoCampo d
			on d.id_tipo = c.id_tipo
	where x.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
		order by a.nombre_requisito, d.nombre_campo
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="metodos">
	select
		s.id_servicio, s.nombre_servicio,
		m.id_metodo, m.nombre_metodo,
		t.id_metodo_generado
	from TPTramite t
		join WSServicio s
			on s.id_documento = t.id_documento_generado
		join WSMetodo m
			on m.id_servicio = s.id_servicio
	where t.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	order by s.nombre_servicio, s.id_servicio, m.nombre_metodo
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color:  #E1E1E1;
		font-weight: bolder;
		color: #000000;
		padding-top: 15px;
		padding-bottom: 15px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>


<form method="post" name="formCT" action="cierre_tramite_sql.cfm">
	<table align="center" cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr><td bgcolor="ECE9D8" style="padding:3px;" colspan="2"><font size="1">Cierre del Tr&aacute;mite</font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td  colspan="1"  ><strong>Entregar el siguiente documento al cerrar el tr&aacute;mite:</strong>&nbsp;</td>
			<td   align="left" ><cfoutput> #rsCampos.nombre_documento#</cfoutput>
			
			<cfif Len(Trim(rsCampos.nombre_documento)) EQ 0>
				No se ha especificado. <br>
			</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="1"  ><strong>Invocar este servicio despu&eacute;s de emitir el documento:</strong>&nbsp;</td>
			<td  align="left">
			<select name="id_metodo_generado" id="id_metodo_generado">
				<option value="">- Ninguno -</option>
				<cfoutput query="metodos" group="nombre_servicio">
				<optgroup label="#HTMLEditFormat(nombre_servicio)#">
				<cfoutput>
				<option value="#id_metodo#" <cfif id_metodo eq id_metodo_generado>selected</cfif>>#HTMLEditFormat(nombre_metodo)#</option>
				</cfoutput>
				</optgroup>
				</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfif Len(Trim(rsCampos.nombre_documento)) EQ 0>
				<br><br><center style="font-size:18px">
				<em><strong>Debe definir el documento por entregar antes
					de definir <br>
					la informaci&oacute;n de cierre del tr&aacute;mite.</strong></em>
				</center>
				<cfelse>
				<table style="width:100% " cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<!--- Pintar Encabezado --->
					<tr class="encabReporte">
						<td><strong>Datos Personales del documento por generar </strong></td>
						<td><strong>Origen de información </strong></td>
						<td align="center"><strong>Modificable</strong></td>
					</tr>
					<cfif tipo_ident_asociado.RecordCount>
					<!--- solo para documentos que son un tipo de identificacion --->
					
					<cfloop query="rsDatosFijos">
						<cfif (currentRow Mod 2) eq 1>
							<cfset color = "Non">
						<cfelse>
							<cfset color = "Par">
						</cfif>
						<tr>
							<td class="<cfoutput>lista#color#</cfoutput>">&nbsp;&nbsp;&nbsp;<cfoutput>#rsDatosFijos.nombre#</cfoutput></td>
							<td class="<cfoutput>lista#color#</cfoutput>">
							<select name="id_campo_req_<cfoutput>#rsDatosFijos.codigo#</cfoutput>"
								onchange="chgcampo(<cfoutput>'#rsDatosFijos.codigo#'</cfoutput>)">
								<option value="-1">Registro Manual</option>
								<cfset Lvarid_campo   = rsDatosFijos.id_campo_req>
								<cfset Lvarcampo_fijo = rsDatosFijos.campo_fijo>

								<optgroup label="Datos personales">
									<cfoutput query="datos_fijos">
										<option value="F,#HTMLEditFormat(codigo)#" <cfif Lvarcampo_fijo eq codigo>selected</cfif>>
											#HTMLEditFormat(nombre)#
										</option>
									</cfoutput>
								</optgroup>
								

								<cfoutput query="rsOrigen" group="nombre_requisito">
								
								<optgroup label="#rsOrigen.nombre_requisito#">
									<cfoutput>
										<option value="C,#rsOrigen.id_campo#" <cfif rsOrigen.id_campo eq Lvarid_campo>selected</cfif>>#rsOrigen.nombre_campo#</option>
									</cfoutput>
								</optgroup>
								</cfoutput>
							</select>
							</td>
							
							<td class="<cfoutput>lista#color#</cfoutput>" align="center">
							<cfoutput>
							<cfset disabled = (rsDatosFijos.id_campo_req EQ '' and Trim(rsDatosFijos.campo_fijo) EQ '')>
							<input type="checkbox"  name="modif_#rsDatosFijos.codigo#"
								<cfif disabled>disabled</cfif>
								<cfif disabled OR (rsDatosFijos.modificable EQ 1)>checked</cfif>
							></cfoutput></td>
						</tr>
					</cfloop>
					</cfif>
					<!--- Pintar Encabezado --->
					<tr class="encabReporte">
						<td><strong>Campo</strong></td>
						<td><strong>Origen de información </strong></td>
						<td align="center"><strong>Modificable</strong></td>
					</tr>
					<cfloop query="rsCampos">
						<cfif (currentRow Mod 2) eq 1>
							<cfset color = "Non">
						<cfelse>
							<cfset color = "Par">
						</cfif>
						<tr>
							<td class="<cfoutput>lista#color#</cfoutput>">&nbsp;&nbsp;&nbsp;<cfoutput>#rsCampos.nombre_campo#</cfoutput></td>
							<td class="<cfoutput>lista#color#</cfoutput>">
							<select name="id_campo_req_<cfoutput>#rsCampos.id_campo#</cfoutput>"
								onchange="chgcampo(<cfoutput>#rsCampos.id_campo#</cfoutput>)">
								<option value="-1">Registro Manual</option>
								<cfset Lvarid_campo = rsCampos.id_campo_req>
								<cfset Lvarcampo_fijo = rsCampos.campo_fijo>

								<optgroup label="Datos personales">
									<cfoutput query="datos_fijos">
										<option value="F,#HTMLEditFormat(codigo)#" <cfif Lvarcampo_fijo eq codigo>selected</cfif>>
											#HTMLEditFormat(nombre)#
										</option>
									</cfoutput>
								</optgroup>
								

								<cfoutput query="rsOrigen" group="nombre_requisito">
								
								<optgroup label="#rsOrigen.nombre_requisito#">
									<cfoutput>
										<option value="C,#rsOrigen.id_campo#" <cfif rsOrigen.id_campo eq Lvarid_campo>selected</cfif>>#rsOrigen.nombre_campo#</option>
									</cfoutput>
								</optgroup>
								</cfoutput>
							</select>
							</td>
							
							<td class="<cfoutput>lista#color#</cfoutput>" align="center">
							<cfoutput>
							<cfset disabled = (rsCampos.id_campo_req EQ '' and Trim(rsCampos.campo_fijo) EQ '')>
							<input type="checkbox"  name="modif_#rsCampos.id_campo#"
								<cfif disabled>disabled</cfif>
								<cfif disabled OR (rsCampos.modificable EQ 1)>checked</cfif>
							></cfoutput></td>
						</tr>
					</cfloop>
				</table></cfif>
			</td>
		</tr>
		<tr>
		  <td nowrap>&nbsp;</td>
		  <td></td>
	  </tr>
		<tr>
			<td colspan="2" nowrap><strong>Para informaci&oacute;n sobre permisos de cierre, consulte la pesta&ntilde;a de Seguridad</strong></td>
		</tr>
		<tr>
		  <td align="center" colspan="2">&nbsp;</td>
	  </tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="btnGuardar" value="Guardar Información" >
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='tramitesList.cfm';">
			</td>
		</tr>		
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCampos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<cfoutput>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_tramite" value="#form.id_tramite#">
</cfoutput>
</form>
<script type="text/javascript" language="javascript1.1">
function chgcampo(id_campo_req){
	var f = document.formCT;
	var v = f['id_campo_req_' + id_campo_req].value;
	var chk = f['modif_' + id_campo_req];
	chk.disabled = (v == -1);
	chk.checked |= (v == -1);
}
</script>

