<cf_templateheader title="Consulta de Órdenes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Órdenes de Compra '>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">

<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>

<!--- Combo Compradores --->
<cfquery name="rsCompradores" datasource="#Session.DSN#">
	select CMCid,CMCcodigo,CMCnombre
	from CMCompradores
	where Ecodigo = #session.Ecodigo#	
</cfquery>

<!---- Combo Tipos de orden --->
<cfquery name="rsTipos" datasource="#Session.DSN#">	
	select CMTOcodigo,CMTOdescripcion 
	from CMTipoOrden
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Query Ordenes de compra --->
<cfquery name="rsOrdenes" datasource="#Session.DSN#">
	select distinct a.EOidorden,a.EOnumero, a.Observaciones, a.EOfecha, m.CMTOdescripcion
	from EOrdenCM a
		inner join CMTipoOrden m
			on a.CMTOcodigo = m.CMTOcodigo
			and a.Ecodigo = m.Ecodigo
		left outer join DOrdenCM b
			on a.EOidorden = b.EOidorden
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo= #session.Ecodigo#		 
		and a.EOestado = 10
		and (b.DOcantidad - b.DOcantsurtida) <>0		
		<cfif isdefined("form.EOnumero") and len(trim(form.EOnumero)) >
			and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero#">
		</cfif>
		<cfif isdefined("form.CMCid") and len(trim(form.CMCid)) >
			and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
		</cfif>		
		<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
			and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
		</cfif>
		<cfif isdefined("form.porcentaje") and len(trim(form.porcentaje)) >
			and 100-(DOcantsurtida/DOcantidad*100) = <cfqueryparam cfsqltype="cf_sql_float" value="#form.porcentaje#">
		</cfif>						
</cfquery>

<cfset iCount = 1>
<cfoutput>

<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
	<input type="hidden" name="opt" value="">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">	  
	  <tr>
		<td>
<!----*********************************************************************************************---->
			<table width="98%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr> 
					<td width="35%" nowrap>
						<label for="CMTOcodigo"><strong>&nbsp;Tipo Orden:&nbsp;</strong></label>
						<cfoutput>
							<select name="CMTOcodigo" id="CMTOcodigo">
							<option value="" selected>- Todos -</option> 
								<cfloop query="rsTipos">
										<option value="#rsTipos.CMTOcodigo#" <cfif isdefined('form.CMTOcodigo') and rsTipos.CMTOcodigo EQ form.CMTOcodigo>selected</cfif>>#HTMLEditFormat(rsTipos.CMTOdescripcion)#</option>
								</cfloop>
							</select>
						</cfoutput>
					</td>
					<td width="24%" nowrap>						
						<label for="EOnumero"><strong>&nbsp;Orden:&nbsp;</strong></label>
						<input type="text" name="EOnumero" size="20" maxlength="100" value="<cfif isdefined('form.EOnumero')><cfoutput>#form.EOnumero#</cfoutput></cfif>" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">&nbsp;						
					</td>
					<td nowrap>
						<label for="CMCid"><strong>&nbsp;Comprador:&nbsp;</strong></label>
						  <select name="CMCid" id="CMCid">
							<option value="" selected>- Todos -</option>
							<cfloop query="rsCompradores">
							  <option value="#rsCompradores.CMCid#" <cfif isdefined('form.CMCid') and rsCompradores.CMCid EQ form.CMCid>selected<cfelseif rsCompradores.CMCid EQ session.compras.comprador and not isdefined('form.CMCid')>selected</cfif>>#rsCompradores.CMCcodigo# - #rsCompradores.CMCnombre#</option>
							</cfloop>
						  </select>					 
					</td>
					<td nowrap>
						<label for="porcentaje"><strong>&nbsp;Porcentaje:&nbsp;</strong></label>
						<input type="text" name="porcentaje" size="10" maxlength="10" value="<cfif isdefined('form.porcentaje')><cfoutput>#form.porcentaje#</cfoutput></cfif>" 
						onBlur="javascript:fm(this,0); mayor()"  onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">% <!---onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">--->					
					</td>
					<td nowrap>&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar"></td>
				</tr>
				
				<tr><td colspan="5">&nbsp;<hr></td></tr>
				<tr>
					<td colspan="5">
						<div style="vertical-align: middle"><label for="DOjustificacionliq"><strong>&nbsp;&nbsp;&nbsp;Justificación:&nbsp;</strong></label></div>
						<!---<input type="text" name="DOjustificacionliq" size="100" maxlength="255">--->
						&nbsp;&nbsp;&nbsp;<textarea name="DOjustificacionliq" cols="120" rows="2"></textarea>
					</td>
				</tr>	
				<tr><td colspan="5">&nbsp;</td></tr>
			</table>
		</td>
	  </tr>
<!--************************************************************************************************---->							  
	  <cfif isdefined("form.CMCcodigo") or isdefined("form.CMTOcodigo") or isdefined("form.EOnumero") or isdefined("form.porcentaje")>	  
	  <tr>
		<td>
		  <table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
		 <cfif rsOrdenes.Recordcount EQ 0>
			 <tr align="center">	  	
				<td class="tituloListas" colspan="4">			
					<label for="todos"><strong>-------------------------------- &nbsp;No hay líneas por liquidar &nbsp;--------------------------------</strong></label>
				</td>
			  </tr>
		 <cfelse>
		  <tr>	  	
			<td class="tituloListas" colspan="4">			
				<input type="checkbox" name="chkAllItems" value="1" onClick="javascript: funcChkAll(this);" style="border:none; vertical-align:middle">
				<label for="todos"><strong>&nbsp;Todo&nbsp;</strong></label>
			</td>
	  	  </tr>
		  <cfset corte1=''>
          <cfinclude template="../../Utiles/sifConcat.cfm">
		  <cfloop query="rsOrdenes">
			  <cfif corte1 NEQ rsOrdenes.EOidorden>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
					<td>
						<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="2%" nowrap class="tituloListas" style="border-bottom: 1px solid black;">&nbsp;
								<input type="checkbox" name="EOidorden" value="#rsOrdenes.EOidorden#" onClick="javascript: funcChkSolicitud(this); UpdChkAll(this);" style="border:none; vertical-align:middle">
							</td>
							<td width="10%"  nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">No.Orden: &nbsp;#rsOrdenes.EOnumero#</td>
							<td width="40%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">Tipo de Orden: &nbsp;#rsOrdenes.CMTOdescripcion# </td>
							<td width="40%"  nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">Observación: &nbsp;#rsOrdenes.Observaciones#</td>
							<td width="10%" nowrap  align="center" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">Fecha:&nbsp;#LSDateFormat(rsOrdenes.EOfecha,'dd/mm/yyy')#</td>
				     	</tr>
						</table>
					</td>
				  </tr>
			  </cfif><!--- Fin del if del corte por orden --->		
				<!--- Query que trae los datos de la orden --->
				<cfquery name="rsDetOrdenes" datasource="#Session.DSN#">
					select	a.EOidorden, a.EOnumero, a.Observaciones, a.EOfecha,
							b.DOconsecutivo, b.DOcantidad, b.DOcantsurtida, b.DOlinea,
							coalesce(b.DOcantidad - DOcantsurtida,0) as saldo,
							m.CMTOdescripcion,		
							 case CMtipo	when 'A' then Adescripcion
											when 'S' then Cdescripcion
											when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as item
																					
					from EOrdenCM a
						inner join CMTipoOrden m
							on a.CMTOcodigo = m.CMTOcodigo
							and a.Ecodigo = m.Ecodigo
						
						left outer join DOrdenCM b
							on a.EOidorden = b.EOidorden
							and a.Ecodigo = b.Ecodigo
							
							<!---Articulos--->
							left outer join Articulos f
								on b.Aid=f.Aid
								and b.Ecodigo=f.Ecodigo		
						  
							<!---Conceptos--->
							left outer join Conceptos h
								on b.Cid=h.Cid
								and b.Ecodigo=h.Ecodigo		
					 
							<!---Activos--->
							left outer join ACategoria j
								on b.ACcodigo=j.ACcodigo
								and b.Ecodigo=j.Ecodigo
					 
							left outer join AClasificacion k
								on b.ACcodigo=k.ACcodigo
								and b.ACid=k.ACid
								and b.Ecodigo=k.Ecodigo
					 
					where	a.Ecodigo= #session.Ecodigo#	
							and coalesce(b.DOcantidad - DOcantsurtida,0) <> 0
							and a.EOidorden = #rsOrdenes.EOidorden#
				</cfquery>

				<tr><td>
				<table  width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">					  
				  <tr>
					<td width="2%" nowrap class="tituloListas" style="padding-right: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td width="51%" nowrap class="tituloListas" style="padding-right: 5px;">Item</td>
					<td width="17%" align="right" nowrap class="tituloListas" style="padding-right: 5px;">Cantidad</td>
					<td width="18%" align="right" nowrap class="tituloListas" style="padding-right: 5px;">Cant. Surt.</td>
					<td width="12%" align="right" nowrap class="tituloListas" style="padding-right: 5px;">Saldo</td>
				  </tr>
				  <cfloop query="rsDetOrdenes">
						  <tr>
							<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;								
								<input type="hidden" name="saldo_#rsDetOrdenes.DOlinea#" value="#rsDetOrdenes.saldo#" onClick="javascript: UpdChkSolicitud(this);" >
								<input type="checkbox" name="DOlinea_#rsDetOrdenes.EOidorden#" value="#rsDetOrdenes.DOlinea#" onClick="javascript: UpdChkSolicitud(this);" style="border:none; vertical-align:middle">
							</td>
							<td>#rsDetOrdenes.item#</td>
							<td align="right">#rsDetOrdenes.DOcantidad#</td>
							<td align="right">#rsDetOrdenes.DOcantsurtida#</td>
							<td align="right">#Abs(rsDetOrdenes.saldo)#</td>
						  </tr>
				  </cfloop><!--- Fin del loop del segundo corte por linea detalle de la orden --->
				</table>
				</td></tr>	  
			<cfset corte1 = rsOrdenes.EOidorden>
		  </cfloop>
		  </cfif><!--- Fin de si hay ordenes --->
		 </table>	  </tr>	
	  <tr><td>&nbsp;</td></tr>
	  <tr><td>&nbsp;</td></tr>	  
	  <tr>
	  	<td colspan="4" align="center"><input type="submit" value="Liquidar" onClick="javascript: return listo();"></td>
	  </tr>
	  <tr><td colspan="4">&nbsp;</td></tr>
	  </cfif>	
	</table>	
</form>
</cfoutput>
	<script type="text/javascript" language="JavaScript">				
		//Funcion para mostrar pantalla de confirmacion de liquidación 
		function listo(){
			if (document.form1.DOjustificacionliq.value == ''){
				alert("El campo justificación es requerido");
				return false;				
			}
			if(confirm ('Desea liquidar las líneas seleccionadas?')){
				liquidar();
				return true;
			}
				return false;
		}
						
		// Funcion para validar que el porcentaje digitado no sea mayor a100
		function mayor(){
			if ( new Number(qf(document.form1.porcentaje.value)) > 100 ){
						alert("El porcentaje no puede ser mayor a 100");
						document.form1.porcentaje.value = '';
					}
		}
		
		// Funcion que envia al SQL para realizar los updates
		function liquidar(){
			document.form1.action = 'SQLLiqSaldos-ListaOrdenes.cfm';
			//document.form1.submit();		
		}
		
		// Funciones del chequeo 
		function funcChkAll(c) {
			if (document.form1.EOidorden) {
				if (document.form1.EOidorden.value) {
					if (!document.form1.EOidorden.disabled) { 
						document.form1.EOidorden.checked = c.checked;
						funcChkSolicitud(document.form1.EOidorden);
					}
				} else {
					for (var counter = 0; counter < document.form1.EOidorden.length; counter++) {
						if (!document.form1.EOidorden[counter].disabled) {
							document.form1.EOidorden[counter].checked = c.checked;
							funcChkSolicitud(document.form1.EOidorden[counter]);
						}
					}
				}
			}
		}

		function UpdChkAll(c) {
			var allChecked = true;
			if (!c.checked) {
				allChecked = false;
			} else {
				if (document.form1.EOidorden.value) {
					if (!document.form1.EOidorden.disabled) allChecked = true;
				} else {
					for (var counter = 0; counter < document.form1.EOidorden.length; counter++) {
						if (!document.form1.EOidorden[counter].disabled && !document.form1.EOidorden[counter].checked) {allChecked=false; break;}
					}
				}
			}
			document.form1.chkAllItems.checked = allChecked;
		}
		
		function funcChkSolicitud(c) {
			if (document.form1['DOlinea_'+c.value]) {
				if (document.form1['DOlinea_'+c.value].value) {
					if (!document.form1['DOlinea_'+c.value].disabled) document.form1['DOlinea_'+c.value].checked = c.checked;
				} else {
					for (var counter = 0; counter < document.form1['DOlinea_'+c.value].length; counter++) {
						if (!document.form1['DOlinea_'+c.value][counter].disabled) document.form1['DOlinea_'+c.value][counter].checked = c.checked;
					}
				}
			}
		}

		function UpdChkSolicitud(c) {
			var idOrden = "" + c.name.split('_')[1];
			var allChecked = true;
			if (!c.checked) {
				allChecked = false;
			} else {
				if (document.form1['DOlinea_'+idOrden].value) {
					if (!document.form1['DOlinea_'+idOrden].disabled) allChecked = true;
				} else {
					for (var counter = 0; counter < document.form1['DOlinea_'+idOrden].length; counter++) {
						if (!document.form1['DOlinea_'+idOrden][counter].disabled && !document.form1['DOlinea_'+idOrden][counter].checked) {
							allChecked=false; break;
						}
					}
				}
			}
			if (document.form1.EOidorden.value) {
				document.form1.EOidorden.checked = allChecked;
				UpdChkAll(document.form1.EOidorden);
			} else {
				for (var counter = 0; counter < document.form1.EOidorden.length; counter++) {
					if (!document.form1.EOidorden[counter].disabled && document.form1.EOidorden[counter].value == idOrden) {
						document.form1.EOidorden[counter].checked = allChecked; 
						UpdChkAll(document.form1.EOidorden[counter]);
						break;
					}
				}
			}
		}
		
		function checkContinuar() {
			var continuar = false;
			if (document.form1.EOidorden) {
				if (document.form1.EOidorden.value) {
					if (document.form1['DOlinea_'+document.form1.EOidorden.value].value) {
						if (!document.form1['DOlinea_'+document.form1.EOidorden.value].disabled) continuar = document.form1['DOlinea_'+document.form1.EOidorden.value].checked;
					} else {
						for (var counter = 0; counter < document.form1['DOlinea_'+document.form1.EOidorden.value].length; counter++) {
							if (!document.form1['DOlinea_'+document.form1.EOidorden.value][counter].disabled && document.form1['DOlinea_'+document.form1.EOidorden.value][counter].checked) { continuar = true; break; }
						}
					}
				} else {
					for (var k = 0; k < document.form1.EOidorden.length; k++) {
						if (document.form1['DOlinea_'+document.form1.EOidorden[k].value].value) {
							if (!document.form1['DOlinea_'+document.form1.EOidorden[k].value].disabled && document.form1['DOlinea_'+document.form1.EOidorden[k].value].checked) continuar = true;
						} else {
							for (var counter = 0; counter < document.form1['DOlinea_'+document.form1.EOidorden[k].value].length; counter++) {
								if (!document.form1['DOlinea_'+document.form1.EOidorden[k].value][counter].disabled && document.form1['DOlinea_'+document.form1.EOidorden[k].value][counter].checked) { continuar = true; break; }
							}
						}
					}
				}
				if (!continuar) alert('Debe seleccionar al menos un item de compra');
			} else {
				alert('No existen itemes de compra para iniciar un nuevo proceso de compra')
			}
			return continuar;
		}
		
	</script>
		<cf_web_portlet_end>
	<cf_templatefooter>