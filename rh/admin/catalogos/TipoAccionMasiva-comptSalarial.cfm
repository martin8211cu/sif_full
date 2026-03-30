<!--- Consultas del Componente Salarial --->
<cfquery name="rsComponenteSalarial" datasource="#Session.DSN#">
	select a.CSid, a.CScodigo, a.CSdescripcion
	from ComponentesSalariales a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.CSsalariobase = 0 
	and not exists (
		select 1
		from RHComponentesTAccionM b
		where b.RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
		and b.CSid = a.CSid
	)
	order by a.CScodigo
</cfquery>

<cfquery name="rsComponenteTipoAccionMasiva" datasource="#Session.DSN#">
	select a.RHTCAMid, a.CSid, a.RHTCAMagregam, a.RHTCAMelimina,{fn concat({fn concat(rtrim(b.CScodigo) , ' - ' )}, b.CSdescripcion)} as CSdescripcion
	from RHComponentesTAccionM a
		inner join ComponentesSalariales b
		on a.CSid = b.CSid
		and a.Ecodigo = b.Ecodigo
	where a.RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
</cfquery>
       
<script language="JavaScript1.2" type="text/javascript">
	function AgregarCTAM() {
		if (document.form1.CSid.value!="") {
			document.form1.CTAMAccion.value = "ALTA";
			return true;
		}
		alert('Se presentaron los siguientes errores:\n\nEl campo Componente Salarial es requerido.');
		return false;
	}
		
	function EliminarCTAM(id) {
		if (confirm('¿Desea eliminar el Componente Salarial?')) {
			document.form1.RHTCAMid.value = id;
			document.form1.CTAMAccion.value = "BAJA";
			return true;
		}
		return false;
	}
</script> 

<cfoutput>
	<input type="hidden" name="CTAMAccion" id="CTAMAccion" value="">
	<input type="hidden" name="RHTCAMid" id="RHTCAMid" value="">
	<fieldset>
	<legend><b>&nbsp;<cf_translate key="LB_ComponentesSalariales">Componentes Salariales</cf_translate>&nbsp;</b></legend>
		<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
			<tr>
				<td nowrap align="left" colspan="3">
					<table width="99%" align="center" border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td width="52%"><b><cf_translate key="LB_ComponenteSalarial">Componente Salarial</cf_translate></b></td>
							<td width="3%">&nbsp;</td>
							<td width="32%"><b><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></b></td>
							<td width="3%">&nbsp;</td>
							<td width="10%">&nbsp;</td>
						</tr>
						<tr>
							<td align="left"> 
								<select name="CSid">
									<cfloop query="rsComponenteSalarial">
										<option value="#rsComponenteSalarial.CSid#">#rsComponenteSalarial.CScodigo# - #rsComponenteSalarial.CSdescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>
								<select name="RHTCAMaccion">
									<option value="1"><cf_translate key="CMB_AgregarModificar">Agregar / Modificar</cf_translate></option>
									<option value="2"><cf_translate key="CMB_AgregarModificar">Eliminar</cf_translate></option>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>  
	
								<input type="submit" name="CTAAlta" id="CTAAlta" value="<cfoutput>#BTN_Agregar#</cfoutput>" onClick="javascript: return AgregarCTAM();">
							</td>
						</tr>
					</table>
				</td>					
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>	
			<tr>
				<td colspan="3">
					<table width="500" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td width="60%" class="tituloListas"><cf_translate key="LB_Componente">Componente</cf_translate></td>
							<td width="30%" class="tituloListas"><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></td>
							<td width="10%" align="center" class="tituloListas">&nbsp;</td>
						</tr>
					</table>
					<div id="divComponentes" style="overflow:auto; height: 100; margin:0" >
					<table width="500" cellpadding="2" cellspacing="0" border="0">
					<cfloop query="rsComponenteTipoAccionMasiva">
						<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
							<td width="60%" height="20">#rsComponenteTipoAccionMasiva.CSdescripcion#</td>
							<td width="30%"><cfif rsComponenteTipoAccionMasiva.RHTCAMagregam EQ 1><cf_translate key="LB_AgregarModificar">Agregar/Modificar</cf_translate><cfelse><cf_translate key="LB_Eliminar">Eliminar</cf_translate></cfif></td>
							<td width="10%" align="right">
								<input name="btnEliminar#CSid#" type="image" alt="Eliminar Componente Salarial" onClick="javascript: return EliminarCTAM('#RHTCAMid#');" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
							</td>
						</tr>
					</cfloop>
					</table>
					</div>
				</td>
			</tr>	
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>		
		</table>
	</fieldset>
</cfoutput>
