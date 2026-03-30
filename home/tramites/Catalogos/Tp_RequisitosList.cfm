<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Requisitos
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Requisitos">

		<cfif isdefined("url.id_requisito") and not isdefined("form.id_requisito")>
			<cfset form.id_requisito = url.id_requisito >
		</cfif>

		<cfquery name="rstipos" datasource="#session.tramites.dsn#">
			SELECT id_tiporeq ,codigo_tiporeq ,nombre_tiporeq
			FROM TPTipoReq 
			where id_tiporeq in (select id_tiporeq from TPRequisito)
			order by nombre_tiporeq
		</cfquery>

		<cfquery name="rsinst" datasource="#session.tramites.dsn#">
			SELECT id_inst, nombre_inst
			FROM TPInstitucion 
			where id_inst in (select id_inst from TPRequisito)
			order by nombre_inst
		</cfquery>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<tr><td>
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr>
					  <td>C&oacute;digo</td>
					  <td>Descripci&oacute;n</td>
					  <td>Instituci&oacute;n</td>
					  <td>Tipo</td>
					  <td>Comportamiento</td>
				  <td rowspan="2" valign="bottom">
			    	  <input type="submit" name="btnFiltrar" value="Filtrar">
					  <input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiar();">
					  <input type="button" name="btnNuevo" value="Nuevo Requisito" onClick="javascript: nuevo();">
					  <input type="button" name="btnImprimir" value="Imprimir" onClick="javascript: imprimir();">
					  
					  					</td>
				  </tr>
					<tr> 
						<td><input type="text" name="fcodigo_requisito"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_requisito")>#fcodigo_requisito#</cfif>"></td>
						<td><input type="text" name="fnombre_requisito"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_requisito")>#fnombre_requisito#</cfif>"></td>
						<td><select name="fid_inst">
								<option value="-1">- Todas- </option>
								<cfloop query="rsinst">
									<option value="#rsinst.id_inst#" <cfif isdefined('form.fid_inst') and form.fid_inst eq rsinst.id_inst>selected</cfif>>#rsinst.nombre_inst#</option>
								</cfloop>
							</select>
							</td>
						<td><select name="fid_tiporeq">
								<option value="-1">- Todos -</option>
								<cfloop query="rstipos">
									<option value="#rstipos.id_tiporeq#" <cfif isdefined('form.fid_tiporeq') and form.fid_tiporeq eq rstipos.id_tiporeq>selected</cfif>>#rstipos.nombre_tiporeq#</option>
								</cfloop>
							</select>
							</td>
						<td><cfparam name="form.fid_comportamiento" default="">
						<select name="fid_comportamiento">
								<option value="-1">- Todos -</option>
								<option value="D" <cfif form.fid_comportamiento eq 'D'>selected</cfif>>Documental</option>
								<option value="C" <cfif form.fid_comportamiento eq 'C'>selected</cfif>>Cita</option>
								<option value="P" <cfif form.fid_comportamiento eq 'P'>selected</cfif>>Pago</option>
								<option value="A" <cfif form.fid_comportamiento eq 'A'>selected</cfif>>Aprobaci&oacute;n</option>
							</select>
							</td>
					</tr>
				</table>
				</cfoutput>
			</form>
			</td></tr>
			<tr><td>
				<cfset comdicion =" where ">	
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					select id_requisito, a.id_tiporeq,nombre_tiporeq,codigo_requisito,nombre_requisito ,'1' as tab ,
						case comportamiento
							when 'D' then 'Documental'
							when 'C' then 'Cita'
							when 'P' then 'Pago'
							when 'A' then 'Aprobaci&oacute;n'
							else 'Otro'
						end as comport_desc,
						i.nombre_inst
					from TPRequisito  a 
						join TPTipoReq b 
							on a.id_tiporeq = b.id_tiporeq
						left join TPInstitucion i
							on i.id_inst = a.id_inst
					<cfif isdefined("form.fcodigo_requisito") and len(trim(form.fcodigo_requisito))>
						  #comdicion# upper (codigo_requisito) like upper('%#trim(form.fcodigo_requisito)#%')
						  <cfset comdicion =" and ">	
					</cfif>
					<cfif isdefined("form.fnombre_requisito") and len(trim(form.fnombre_requisito))>
						#comdicion# upper(nombre_requisito) like upper('%#trim(form.fnombre_requisito)#%')
						<cfset comdicion =" and ">
					</cfif>
					<cfif isdefined("form.fid_inst") and len(trim(form.fid_inst)) and form.fid_inst neq '-1'>
						#comdicion#  a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fid_inst#">
						<cfset comdicion =" and ">
					</cfif>
					<cfif isdefined("form.fid_tiporeq") and len(trim(form.fid_tiporeq)) and form.fid_tiporeq neq '-1'>
						#comdicion#  a.id_tiporeq = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fid_tiporeq#">
						<cfset comdicion =" and ">
					</cfif>
					<cfif isdefined("form.fid_comportamiento") and len(trim(form.fid_comportamiento)) and form.fid_comportamiento neq '-1'>
						#comdicion#  a.comportamiento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fid_comportamiento#">
						<cfset comdicion =" and ">
					</cfif>
					order by nombre_inst,codigo_requisito,nombre_tiporeq
				</cfquery>
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="codigo_requisito,nombre_requisito,nombre_tiporeq,comport_desc"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n,Tipo,Comportamiento"/>
					<cfinvokeargument name="formatos" value="S,S,S,S"/>
					<cfinvokeargument name="align" value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="Tp_Requisitos.cfm"/>
					<cfinvokeargument name="cortes" value="nombre_inst"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="id_requisito,tab" />
				</cfinvoke>
			</td></tr>
		</table>
	<cf_web_portlet_end>
</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fcodigo_requisito.value = '';
	document.filtro.fnombre_requisito.value = '';
	document.filtro.fid_inst.value = '-1';
	document.filtro.fid_tiporeq.value = '-1';
	document.filtro.fid_comportamiento.value = '-1';
	
}

function nuevo(){
	document.filtro.action = "Tp_Requisitos.cfm";
	document.filtro.submit()
}

function imprimir(){
	location.href='../Consultas/requisitos.cfm';
}
</script>
