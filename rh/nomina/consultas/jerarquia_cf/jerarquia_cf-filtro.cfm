<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Consulta de Jerarqu&iacute;a de Centros Funcionales"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>
			
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
		<div align="center">
			<cfoutput>
			<form name="form1" method="get" action="jerarquia_cf.cfm" style="margin:0;">
				<table border="0" width="550" cellspacing="0" cellpadding="3">
					
					<tr>
						<td nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong></td>
						<td><cf_rhcfuncional id="CFidresp"></td>
					</tr>
					
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_desc_cf" name="mostrar_desc_cf" value="true" /></td>
						<td><label for="mostrar_desc_cf"><cf_translate key="LB_Mostrar_descripcion_del_Centro_Funcional">Mostrar descripci&oacute;n del Centro Funcional</cf_translate></label></td>
					</tr>
	
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_responsable" name="mostrar_responsable" value="true" /></td>
						<td><label for="mostrar_responsable"><cf_translate key="LB_Mostrar_nombre_del_responsable_del_Centro_Funcional">Mostrar nombre del responsable del Centro Funcional</cf_translate></label></td>
					</tr>
	
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_foto_resp" name="mostrar_foto_resp" value="true" /></td>
						<td><label for="mostrar_foto_resp"><cf_translate key="LB_Mostrar_foto_del_responsable_del_Centro_Funcional">Mostrar foto del responsable del Centro Funcional</cf_translate></label></td>
					</tr>
	
					<!--- este no se esta usando --->
					<!---
					<tr>
						<td width="1%" valign="middle" align="center"><input type="checkbox" id="mostrar_dependientes" name="mostrar_dependientes" value="" /></td>
						<td><label for="mostrar_dependientes"></label></td>
					</tr>
					--->
	
					<!--- este es a partir de estar y aen el reporte--->
					<!---
					<tr>
						<td width="1%" valign="middle" align="center"><input type="checkbox" id="mostrar_subordinados" name="mostrar_subordinados" value="" /></td>
						<td><label for="mostrar_subordinados"></label></td>
					</tr>
					--->
	
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_oficina" name="mostrar_oficina" value="true" /></td>
						<td><label for="mostrar_oficina"><cf_translate key="LB_Mostrar_Oficina">Mostrar Oficina</cf_translate></label></td>
					</tr>
	
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_departamento" name="mostrar_departamento" value="true" /></td>
						<td><label for="mostrar_departamento"><cf_translate key="LB_Mostrar_Departamento">Mostrar Departamento</cf_translate></label></td>
					</tr>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Filtrar"
						Default="Filtrar"	
						xmlfile="/rh/generales.xml"
						returnvariable="vFiltrar"/>
					<tr><td colspan="2" align="center"><input type="submit" class="btnFiltrar" id="Filtrar" name="Filtrar" value="#vFiltrar#" /></td></tr>

				</table>
			</form>
			</cfoutput>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>