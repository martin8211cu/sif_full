<cf_templateheader template="#session.sitio.template#" title="Reclasificaci&oacute;n de Cuentas">

<cfquery name="socio" datasource="#session.DSN#">
	select SNnumero, SNnombre
	from SNegocios
	where Ecodigo =  #Session.Ecodigo# 
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 then 	<cf_dbfunction name="sPart"	args="a.CCTdescripcion,1,10"> #_Cat# ' (contado)' else <cf_dbfunction name="sPart"	args="a.CCTdescripcion,1,20"> end as CCTdescripcion,
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
	 from CCTransacciones a
	 where a.Ecodigo =  #Session.Ecodigo# 
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1
	   and NOT upper(a.CCTdescripcion) like '%TESORER_A%'
	   and CCTtranneteo = 0
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, CCTcodigo
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select a.IDbitacora, 
		   a.CCTcodigo,
		   b.CCTdescripcion, 
		   a.Ddocumento, 
		   a.SNcodigo, 
		   a.Cuenta_Anterior as Ccuentaant, 
		   ( select cc1.Cformato
			 from CContables cc1
			 where cc1.Ecodigo=a.Ecodigo
			   and cc1.Ccuenta=a.Cuenta_Anterior ) as cuentaantformato,
		   a.Cuenta_Nueva as Ccuentanueva,
		   ( select cc2.Cformato
			 from CContables cc2
			 where cc2.Ecodigo=a.Ecodigo
			   and cc2.Ccuenta=a.Cuenta_Nueva ) as cuentanuevaformato
	from RCBitacora a
	
	inner join Documentos c
	on c.Ecodigo = a.Ecodigo	
	and c.CCTcodigo = a.CCTcodigo
	and c.Ddocumento = a.Ddocumento

	inner join CCTransacciones b
	on b.Ecodigo=a.Ecodigo
	and b.CCTcodigo=a.CCTcodigo
	
	where a.RCBestado = 0
	  and a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	  and a.Ecodigo =  #Session.Ecodigo# 
	  
	  <cfif isdefined("url.fCCTcodigo") and len(trim(url.fCCTcodigo))>
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.fCCTcodigo)#" >
	  </cfif>
	  <cfif isdefined("url.fDdocumento") and len(trim(url.fDdocumento))>
		and upper(a.Ddocumento) like '%#ucase(url.fDdocumento)#%'
	  </cfif>
	order by a.CCTcodigo, a.Ddocumento
</cfquery>

<table width="100%" align="center" cellpadding="3" cellspacing="0" >
	<cfoutput>
	<tr><td align="center" class="menutitulo"><strong>Proceso de Reclasificaci&oacute;n de Cuentas</strong></td></tr>
	<tr><td align="center" class="menutitulo"><strong>Socio de Negocios:&nbsp;</strong>#socio.SNnumero#-#socio.SNnombre#</td></tr>
	</cfoutput>
</table>

<br>

<table width="100%" align="center" cellpadding="2" cellspacing="0" >
<form name="form1" method="get" action="" style="margin:0;">

	<cfif data.recordcount gt 25>
		<tr>
			<td colspan="5" align="center">
				<input type="button" class="btnAnterior" name="btnAnterior" value="Anterior" onclick="javascript:location.href='ReclasificacionCuenta.cfm';" />
				
				<cfif data.recordcount gt 0>
					<input type="submit" class="btnEliminar" name="btnEliminar" value="Eliminar" onclick="javascript: return funcEliminar(); " />
					<input type="submit" class="btnSiguiente" name="btnSiguiente" value="Siguiente" onclick="javascript: return funcSiguiente(); " />
				</cfif>
			</td>
		</tr>
	</cfif>

	<tr>
		<td colspan="5">
			<cfoutput>
			<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="10%"><strong>Transacci&oacute;n:</strong></td>
					<td width="20%">
						<select name="fCCTcodigo" tabindex="1" >
							<option value="">- Todas -</option>
							<cfloop query="rsTransacciones"> 
								<option value="#rsTransacciones.CCTcodigo#" <cfif isdefined("url.fCCTcodigo") and len(trim(url.fCCTcodigo)) and trim(url.fCCTcodigo) eq trim(rsTransacciones.CCTcodigo) >selected="selected"</cfif> >#trim(rsTransacciones.CCTcodigo)# - #rsTransacciones.CCTdescripcion#</option>
							</cfloop> 
						</select>
					</td>
					<td width="10%"><strong>Documento:</strong></td>
					<td width="20%"><input type="text" size="25" maxlength="20" name="fDdocumento" tabindex="1" value="<cfif isdefined('url.fDdocumento') and len(trim(url.fDdocumento))>#url.fDdocumento#</cfif>" /></td>
					<td width="40%" align="center" rowspan="2" valign="middle">
						<input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: document.form1.action=''" />
						<input type="button" class="btnlimpiar" name="btnLimpiar" value="Limpiar" onclick="javascript: document.form1.fCCTcodigo.value=''; document.form1.fDdocumento.value='';" />
					</td>
				</tr>	
			</table>
			</cfoutput>
		</td>
	</tr>

	<tr>
		<td class="tituloListas">&nbsp;</td>
		<td class="tituloListas"><strong>Transacci&oacute;n</strong></td>
		<td class="tituloListas"><strong>Documento</strong></td>
		<td class="tituloListas"><strong>Cuenta Anterior</strong></td>
		<td class="tituloListas"><strong>Cuenta Nueva</strong></td>
	</tr>
	
	<cfif data.recordcount gt 0>
		<cfoutput query="data">
			<tr <cfif data.currentrow mod 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
				<td width="1%"><input type="checkbox" name="chk" value="#data.IDbitacora#" /></td>
				<td>#trim(data.CCTcodigo)#-#data.CCTdescripcion#</td>
				<td>#data.Ddocumento#</td>
				<td>#data.CuentaAntFormato#</td>
				<td>#data.CuentaNuevaFormato#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr >
			<td colspan="5" align="center">No hay registros para reclasificar</td>
		</tr>
		<tr >
			<td colspan="5" align="center">&nbsp;</td>
		</tr>
	</cfif>

	<tr>
		<td colspan="5" align="center">
			<input type="button" class="btnAnterior" name="btnAnterior" value="Anterior" onclick="javascript:location.href='ReclasificacionCuenta.cfm';" />
			<cfif data.recordcount gt 0>
				<input type="submit" class="btnEliminar" name="btnEliminar" value="Eliminar" onclick="javascript: return funcEliminar(); " />
				<input type="submit" class="btnSiguiente" name="btnSiguiente" value="Siguiente" onclick="javascript: return funcSiguiente(); " />
			</cfif>	
		</td>
	</tr>

	<cfoutput>
	<input type="hidden" name="SNcodigo" value="#url.SNcodigo#" />
	<input type="hidden" name="Ccuenta" value="#url.Ccuenta#" />

	<cfif isdefined("url.Ccuenta2") and len(trim(url.Ccuenta2))>
		<input type="hidden" name="Ccuenta2" value="#url.Ccuenta2#" />
	</cfif>	

	<cfif isdefined("url.Ddocumento") and len(trim(url.Ddocumento))>
		<input type="hidden" name="Ddocumento" value="#url.Ddocumento#" />
	</cfif>

	<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
		<input type="hidden" name="id_direccion" value="#url.id_direccion#" />		
	</cfif>
	
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<input type="hidden" name="Ocodigo" value="#url.Ocodigo#" />
	</cfif>
	
	<cfif isdefined("url.antiguedad") and len(trim(url.antiguedad))>
		<input type="hidden" name="antiguedad" value="#url.antiguedad#" />
	</cfif>
	
	<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
		<input type="hidden" name="CCTcodigo" value="#url.CCTcodigo#" />
	</cfif>
	<cfif isdefined("url.filtrar_por") and len(trim(url.filtrar_por))>
		<input type="hidden" name="filtrar_por" value="#url.filtrar_por#" />
	</cfif>
	</cfoutput>
</form>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcEliminar(){
		if ( confirm('Desea eliminar los documentos seleccionados?') ){
			document.form1.action = 'reclasificacionCuentas-documentos-sql.cfm';

			var continuar = false;
			if (document.form1.chk) {
				if (document.form1.chk.value) {
					continuar = document.form1.chk.checked;
				}
				else {
					for (var k = 0; k < document.form1.chk.length; k++) {
						if (document.form1.chk[k].checked) {
							continuar = true;
							break;
						}
					}
				}
				if (!continuar) { 
					alert('Se presentaron los siguientes errores:\n - Debe seleccionar al menos un documento para trasladar.'); 
					return false;
				}
				
			}
			return true;
		}
		return false;
	}

	function funcSiguiente(){
		document.form1.action = 'reclasificacionCuentas-confirmar.cfm';
		return true;
	}	
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcAgregar(){
		popUpWindow("/cfmx/sif/cc/operacion/reclasificacionCuentas-agregar.cfm",100,50,1100,750);
		return false;
	}
</script>

<cf_templatefooter template="#session.sitio.template#">