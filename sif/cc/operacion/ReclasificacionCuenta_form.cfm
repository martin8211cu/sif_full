<!---
	Creado por Gustavo Fonseca H.
		Fecha: 13-12-2005.
		Motivo: Nuevo proceso de Reclasificación de Cuentas.
--->

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Ocodigo                      
</cfquery>

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select Ccuenta, 
	<cf_dbfunction name="concat" args="ltrim(rtrim(Cformato)),' ',Cdescripcion"> as Cdescripcion
	from CContables 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Cmovimiento = 'S' 
	  and Mcodigo = 2
	order by Ccuenta
</cfquery>
<cf_dbfunction name="sPart"		args="a.CCTdescripcion,1,10" returnvariable="LvarCCTdescripcion1" >
<cf_dbfunction name="sPart"		args="a.CCTdescripcion,1,20" returnvariable="LvarCCTdescripcion2" >
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 then <cf_dbfunction name="concat" args="#LvarCCTdescripcion1#+' (contado)'" delimiters="+"> else #LvarCCTdescripcion2# end as CCTdescripcion,
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
  	 from CCTransacciones a
	 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1
	   and NOT upper(a.CCTdescripcion) like '%TESORER_A%'
	   and CCTtranneteo = 0
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, CCTcodigo
</cfquery>

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery datasource="#session.dsn#" name="direcciones">
		select a.SNcodigo, a.SNnumero, a.SNid, a.Ecodigo, a.SNnombre, b.id_direccion,<cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2">as texto_direccion 
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
</cfif>

<form name="form1" method="post" action="ReclasificacionCuenta-Bitacora-sql.cfm" onsubmit="javascript: return validar();">


<table align="center" cellpadding="2" cellspacing="0" border="0" width="90%">
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="2" bgcolor="#f5f5f5" align="center" style="padding:3px;"><strong>Reclasificación de Cuentas</strong></td></tr>
	<tr><td>&nbsp;</td></tr>	

		<TR><TD>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" >
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td colspan="2"  valign="middle" class="tituloAlterno"><div align="left"><label><strong>Datos Generales</strong></label><d/iv></td>
				</tr>

				<tr>
					<td align="right"><strong>Socio&nbsp;de&nbsp;Negocios:</strong>&nbsp;</td>	
					<td align="left">
						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
							<cf_sifsociosnegocios2 idquery="#direcciones.SNcodigo#" tabindex="1">
						<cfelse>
							<cf_sifsociosnegocios2 tabindex="1">
						</cfif>
					</td>
				</tr>
			
				<tr>
					<td align="right"><strong>Cuenta&nbsp;Anterior&nbsp;:</strong>&nbsp;</td>
					<td align="left">
						<cfoutput>
									<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="1"
												cmayor="cmayor2" ccuenta="Ccuenta2" cdescripcion="Cfdescripcion2" cformato="Cformato2"> 
						</cfoutput>
					</td>
				</tr>
			
				<tr>
					<td><div align="right"><strong>Cuenta&nbsp;Nueva:&nbsp;</strong></div></td>
						<td>
							<cfoutput>
							<cfquery name="rsPintaCuentaParametro" datasource="#session.DSN#">
								select Pcodigo, Pvalor, Pdescripcion
								from  Parametros
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and Pcodigo =2
							</cfquery>
							<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="3"
									cmayor="cmayor" ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato"> 
							</cfoutput>
						</td>
				</tr>
			</table>
			<cf_web_portlet_end>
		</TD></TR>

	<tr><td>&nbsp;</td></tr>	


	<tr><td colspan="2">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" >
		<table width="100%">
		
			<!--- Opcion 1 de Filtrado --->
			<tr><td class="tituloListas" colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%" class="tituloAlterno" valign="middle"><input name="filtrar_por" tabindex="4" type="radio" value="T" checked="checked"  onclick="javascript:check()" /></td>
						<td valign="middle" class="tituloAlterno" align="left"><div align="left"><strong><label for="filtrar_por">Filtrar por Grupo de Criterios</label></strong></div></td>
					</tr>
				</table>
			</td></tr>
			<tr>
				<td align="right" ><strong>Dirección:</strong>&nbsp;</td>
				<td align="left">
					<select style="width:365px" name="id_direccionEnvio" id="id_direccionEnvio" tabindex="4" onchange="javascript:todos(this.value);">
						<option value="">- Todas -</option>
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cfoutput query="direcciones">
									<option value="#id_direccion#">
										#HTMLEditFormat(texto_direccion)#
									</option>
								</cfoutput>
							</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Oficina:</strong>&nbsp;</td>
				<td align="left">
					<select name="Ocodigo" tabindex="4"  onchange="javascript:todos(this.value);">
						<option value="">- Todas -</option>
						<cfoutput query="rsOficinas"> 
							<option value="#rsOficinas.Ocodigo#">
								#rsOficinas.Odescripcion#
							</option>
						</cfoutput> 
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Antigüedad&nbsp;en&nbsp;días:</strong>&nbsp;</td>
				<td align="left">
					<input type="text" value="" name="antiguedad" tabindex="4">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Tipo&nbsp;de&nbsp;Transacci&oacute;n:</strong>&nbsp;</td>
				<td align="left">
					<select name="CCTcodigo" tabindex="4"  onchange="javascript:todos(this.value);">
						<option value="">- Todas -</option>
						<cfoutput query="rsTransacciones"> 
							<option value="#rsTransacciones.CCTcodigo#">
									#rsTransacciones.CCTcodigo# - #rsTransacciones.CCTdescripcion#
							</option>
						</cfoutput> 
					</select>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>	
			</table>
	<cf_web_portlet_end>
	</td></tr>
	
	<tr><td>&nbsp;</td></tr>

	<tr><td colspan="2">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" >
		<table width="100%">
			<!--- Opcion 2 de Filtrado --->
			<tr><td class="tituloListas" colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle" class="tituloAlterno" width="1%"><input name="filtrar_por" type="radio" value="D" tabindex="4" onclick="javascript:check()" /></td>
						<td valign="middle" class="tituloAlterno"><div align="left"><label><strong>Filtrar por Documento</strong></label><d/iv></td>
					</tr>
				</table>
			</td></tr>
			<tr>
				<td align="right"><strong>Documento:</strong>&nbsp;</td>
				<td align="left">
					<cf_sifDocsPagoCxCTodos form="form1" tabindex="4">
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
	</td></tr>
	
	<tr>
		<td nowrap="nowrap" colspan="2" align="center">
			<input type="submit" class="btnSiguiente"  name="Siguiente" value="Siguiente" tabindex="4">
			<input type="hidden" name="existenDocumentos" value="0" tabindex="-1">
			<input type="hidden" name="mantener" value="0" tabindex="-1">
		</td>
	</tr>

</table>
</form>

<iframe id="reclasificarCuenta" name="reclasificarCuenta" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" style="display:none;" ></iframe>

<cf_qforms>
<script language="javascript" type="text/javascript">
	function todos(valor){
		if ( valor == '' ){
			limpiarDocsPagoCxC();
		}
	}
	
	function funcSNnumero(){
		document.form1.cmayor2.value = '';
		document.form1.Cformato2.value = '';
		document.form1.Cfdescripcion2.value = '';
		document.form1.Ccuenta2.value = '';
		document.getElementById('reclasificarCuenta').src = 'Reclasificacion_sugerirCuenta.cfm?SNcodigo='+document.form1.SNcodigo.value;
	}

	function validar(){
		if ( parseFloat(document.form1.existenDocumentos.value) > 0 ){
			if ( confirm('Existen documentos sin aplicar para el socio seleccionado. Desea mantener esos documentos?') ){
				document.form1.mantener.value = 1;
			}
			else{
				document.form1.mantener.value = 0;
			}
			return true;		
		}
		else{
			return confirm('¿Está seguro (a) de ejecutar el proceso de Reclasificación?')	
		}	
	}
	
	function check(){
		if ( document.form1.filtrar_por[1].checked ){
			objForm.Documento.required = true;
			objForm.Documento.description = "Documento";
		}
		else{
			objForm.Documento.required = false;
		}
	}

<!-- 
		objForm.SNcodigo.required = true;
		objForm.SNcodigo.description = "Socio de Negocios";
		objForm.Ccuenta.required = true;
		objForm.Ccuenta.description = "Cuenta Nueva";
		objForm.Documento.required = false;
		
	-->
</script>