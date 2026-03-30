<!--- Establecimiento del modo --->
<cfif isdefined("form.PAcodigo") and form.PAcodigo NEQ '' and isdefined('form.TCcodigo') and form.TCcodigo NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<!---      Consultas     --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,PAcodigo) as PAcodigo
			, convert(varchar,TCcodigo) as TCcodigo
			, PTmeses
		from PaqueteTarifas
		where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
			and TCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsTarifas" datasource="#session.DSN#">
	Select  (convert(varchar,t.TCcodigo) + '~' + convert(varchar,t.TCmeses)) as TCcodigo		
		, t.TCnombre
		, '*' as modulo
		, '*'  as nombre
	from TarifaCalculoIndicador t
	where t.modulo is null
	<cfif modoD NEQ 'CAMBIO'>	
		and TCcodigo not in (
				Select TCcodigo
				from PaqueteTarifas
				where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
			)
	</cfif>							
UNION
	Select (convert(varchar,t.TCcodigo) + '~' + convert(varchar,t.TCmeses)) as TCcodigo
		, t.TCnombre
		, rtrim(m.modulo) as modulo
		, m.nombre
	from PaqueteModulo p, TarifaCalculoIndicador t, Modulo m
	where p.PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
	  and p.modulo = t.modulo
	  and t.modulo = m.modulo
	<cfif modoD NEQ 'CAMBIO'>	
		and TCcodigo not in (
				Select TCcodigo
				from PaqueteTarifas
				where PAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
			)
	</cfif>							
	order by TCnombre
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="paqueteTarifas_SQL.cfm" method="post" name="formPaqueteTarifas" onSubmit="javascript: activacbTCcodigo();">
	<cfoutput>
		<input name="PAcodigo" type="hidden" value="#form.PAcodigo#">	
		
		<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td class="tituloMantenimiento" colspan="3" align="center">
					<cfif modoD eq "ALTA">
						Nueva Tarifa
						<cfelse>
						Modificar Tarifa
					</cfif>
				</td>
			</tr>
			<tr> 
			  
		      <td align="right" valign="top"><strong>Indicador</strong>:&nbsp;</td>
			  <td valign="baseline">
			  <cfif rsTarifas.recordCount EQ 0>
			  	<strong>N/A</strong>
				<input type="hidden" name="TCcodigo" onChange="javascript:return;">
				<input type="hidden" name="cbTCcodigo" onChange="javascript:return;">
			  <cfelse>
				<script language="JavaScript">
					var GvarModulosDeTarifas = new Array(2);
					GvarModulosDeTarifas[0] = new Array("*","*");
                  <cfloop query="rsTarifas">
					GvarModulosDeTarifas[#rsTarifas.currentRow#] = new Array("#rsTarifas.modulo#","#rsTarifas.nombre#");
                  </cfloop>
				</script>
				
				<input type="hidden" name="TCcodigo" value="">
				<select name="cbTCcodigo" id="cbTCcodigo" <cfif modoD NEQ 'ALTA'> disabled</cfif>
				onchange="javascript: idx=document.formPaqueteTarifas.cbTCcodigo.options.selectedIndex; document.formPaqueteTarifas.modulo.value = (GvarModulosDeTarifas[idx][1] == '*') ? '' : (GvarModulosDeTarifas[idx][0] + ' - ' + GvarModulosDeTarifas[idx][1]); cambiaIndicador(this);">	
                    <option value=""></option>
                  <cfloop query="rsTarifas">
					  <cfif modoD NEQ 'ALTA'>
						<cfset myArrayList = ListToArray(rsTarifas.TCcodigo,'~')>
						<!--- <cfdump var="#myArrayList#"> --->
						<cfset selec = false>
						<cfif myArrayList[1] EQ rsForm.TCcodigo>
							<cfset selec = true>
						</cfif>
					  </cfif>

                    <option value="#rsTarifas.TCcodigo#" <cfif modoD NEQ 'ALTA' and selec> selected</cfif>>#rsTarifas.TCnombre# (#rsTarifas.modulo#)</option>
                  </cfloop>
                </select>
			  </cfif>
			  </td>
			</tr>
			<tr> 
			  <td align="right" valign="top"><strong>M&oacute;dulo</strong>:&nbsp;</td>
		      <td valign="baseline"><input name="modulo" type="text" class="cajasinbordeb" size="40" readonly></td>
			  <script language="JavaScript">//document.formPaqueteTarifas.cbTCcodigo.onchange();</script>
			</tr>
			<tr> 
		      <td align="right" valign="top"><strong>Periodicidad</strong>:&nbsp;</td>
			  <td valign="baseline">
				<cfif isdefined('rsTarifas') and rsTarifas.recordCount GT 0>
					<select name="PTmeses">
						<option value="1"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "1"> selected</cfif>>Mes 
						vencido</option>
						<option value="12"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "12"> selected</cfif>>Año 
						vencido</option>
						<option value="0"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "0"> selected</cfif>>Pago 
						inicial</option>
						<option value="2"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "2"> selected</cfif>>Bimestre 
						vencido</option>
						<option value="3"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "3"> selected</cfif>>Trimestre 
						vencido</option>
						<option value="4"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "4"> selected</cfif>>Cuatrimestre 
						vencido</option>
						<option value="6"<cfif modoD NEQ "ALTA" AND rsForm.PTmeses EQ "6"> selected</cfif>>Semestre 
						vencido</option>
					</select>
				</cfif>
			  </td>
			</tr>						
			<tr> 
			  <td align="center">&nbsp;</td>
			  <td align="center">&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">
					<cfif not isdefined('modoD')>
            
						<cfset modoD = "ALTA">
					</cfif>
					
					<input type="hidden" name="botonSel" value="">
					<cfif modoD EQ "ALTA">
						<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>	
						<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionTar) habilitarValidacionTar();">					
						<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacionTar) deshabilitarValidacionTar(); return true; }else{ return false;}">
						<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionTar) deshabilitarValidacionTar(); ">
					</cfif>
							  
<!--- 			  
				<cfset mensajeDelete = "¿Desea Eliminar la tarifa ?">
				<cfinclude template="../portlets/pBotones.cfm">
 --->			  </td>
			</tr>
		  </table>
	</cfoutput>		  
</form>	  

<cfif modoD NEQ 'ALTA'>
	<table width="95%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>	
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Rangos">		
				<table width="100%" border="0" cellspacing="0" cellpadding="0">	
				  <tr>
					<td valign="top"> 						
 						<cfinvoke component="aspAdmin.Componentes.pListasASP" 
								  method="pLista" 
								  returnvariable="pListaFormaPagoDatos">
							<cfinvokeargument name="tabla" value="PaqueteRangoDefault"/>
							<cfinvokeargument name="columnas" value="
									convert(varchar,PAcodigo) as PAcodigo
									, convert(varchar,TCcodigo) as TCcodigo
									,case convert(varchar,PRDhasta) 
										when '999999999999999' then '<script language=''JavaScript''>if (document.Ultimo) document.write(''> '' + document.Ultimo); else document.write(''Tarifa''); 0</script>'
										else convert(varchar,PRDhasta)+'<script language=''JavaScript''>document.Ultimo='+convert(varchar,PRDhasta)+'</script>'
									end as PRDhastaDespl
									, convert(varchar,PRDhasta) as PRDhasta
									, convert(varchar,PRDtarifaFija) as PRDtarifaFija
									, convert(varchar,PRDtarifaVariable) as PRDtarifaVariable"/>
							<cfinvokeargument name="desplegar" value="PRDhastaDespl, PRDtarifaFija,PRDtarifaVariable"/>
							<cfinvokeargument name="etiquetas" value="Hasta, Fija, Variable"/>
							<cfinvokeargument name="formatos"  value=""/>
							<cfinvokeargument name="filtro" value=" PAcodigo= #form.PAcodigo# and TCcodigo=#form.TCcodigo# order by PRDhasta"/>
							<cfinvokeargument name="align" value="right,right,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="keys" value="PAcodigo,TCcodigo,PRDhasta"/>
							<cfinvokeargument name="irA" value="paquete.cfm"/>
							<cfinvokeargument name="formName" value="form_listaPaqueteRangoDefault"/>
						</cfinvoke>
					</td>
					<td valign="top">&nbsp;</td>
					<td valign="top">
						<cfinclude template="paqueteRangoDefault_form.cfm">
					</td>
				  </tr>
				</table>
			
			</cf_web_portlet>		
		</td>	
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
	function cambiaIndicador(obj){
		if(obj.value != ''){
			var arr = obj.value.split('~');
			
			document.formPaqueteTarifas.TCcodigo.value = arr[0];
			<cfif modoD NEQ 'CAMBIO'>
				document.formPaqueteTarifas.PTmeses.value = arr[1];
			</cfif>
		}else{
			document.formPaqueteTarifas.TCcodigo.value = '';
			document.formPaqueteTarifas.PTmeses.value = '';			
		}	
	}
//---------------------------------------------------------------------------------------		
	function activacbTCcodigo(){
		document.formPaqueteTarifas.cbTCcodigo.disabled = false;
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacionTar() {
		objFormTar.cbTCcodigo.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionTar() {
		objFormTar.cbTCcodigo.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormTar = new qForm("formPaqueteTarifas");
//---------------------------------------------------------------------------------------
	objFormTar.cbTCcodigo.required = true;
	objFormTar.cbTCcodigo.description = "Indicador de tarifa";		
	
	document.formPaqueteTarifas.cbTCcodigo.onchange();	
</script>
