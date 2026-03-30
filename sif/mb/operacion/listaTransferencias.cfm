<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Bancos" default="Banco" returnvariable="LB_Bancos" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodo" default="Seleccionar Todo" returnvariable="LB_SeleccionarTodo" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransferenciasCuentas" default="Transferencias entre Cuentas" returnvariable="LB_TransferenciasCuentas" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="filtroListaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" xmlfile="listaTransferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="listaTransferencias.xml"/>

<cf_templateheader title="#LB_Bancos#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TransferenciasCuentas#'>
		<script language="JavaScript1.2" type="text/javascript">
			// ==================================================================================================
			// 								Usadas para validar checks
			// ==================================================================================================
			function existe(form, name){
			// RESULTADO
			// Valida la existencia de un objecto en el form
			
				if (form[name] != undefined) {
					return true
				}
				else{
					return false
				}
			}
		
			function check_all(obj){
				var form = eval('lista');
				if (existe(form, "chk")){
					if (obj.checked){
						if (form.chk.length){
							for (var i=0; i<form.chk.length; i++){
								form.chk[i].checked = "checked";
							}
						}
						else{
							form.chk.checked = "checked";
						}
					}	
				}
			}
			
			function funcImprimir(){
				document.lista.action = '../consultas/TransferenciaRep_sql.cfm?ori=1';
				return true;
			}
			
			function funcAplicar(){
				document.lista.action = 'Transferencias.cfm';
				return true;
			}
			
			function funcNuevo(){
				document.lista.modo.value = "ALTA";
				document.lista.action = 'Transferencias.cfm';
				document.lista.chk.value = '';
				return true;
			}

			function Procesar(val,posA, fname){
					//EVITA EL ONSUBMIT SI SE ENCUENTRA ESTE ATRIBUTO PRENDIDO EN EL FORM
					if (document.forms[fname].nosubmit) {document.forms[fname].nosubmit=false;return false;}
					
					//NUMERO DE COLUMNAS PASAN A UN ARREGLO
					var columnas = new String(document.forms[fname].columnas.value);
					var arrColumnas = columnas.split(',');
			
					//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
					for(var i=0; i < arrColumnas.length; i++){
							var colAsig =arrColumnas[i];
							eval('document.forms[fname].'+arrColumnas[i].toUpperCase()+'.value=document.forms[fname].'+arrColumnas[i].toUpperCase()+'_'+val+'.value');
					}
					document.forms[fname].action = 'Transferencias.cfm';
					document.forms[fname].modo.value="CAMBIO";
					document.forms[fname].submit();
			}
		</script>

		<input type="hidden" name="modo" value="CAMBIO" />
		<input type="hidden" name="dmodo" value="ALTA" />
		
		<div align="center">
			<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
				<tr><td><cfinclude template="../../portlets/pNavegacionMB.cfm"></td></tr>
				<tr><td  align="center" height="10"> <cfinclude template="filtroListaTransferencias.cfm"></td></tr>
				<tr><td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"><b><cfoutput>#LB_SeleccionarTodo#</cfoutput></b></td></tr>
				<tr> 
					<td> 
						<cfquery name="rsListaTransferencias" datasource="#Session.DSN#">
							select ETid, ETperiodo, (case ETmes when 1 then 'Enero' when 2 then 'Febrero'
																when 3 then 'Marzo' when 4 then 'Abril'
																when 5 then 'Mayo' when 6 then 'Junio'
																when 7 then 'Julio' when 8 then 'Agosto'
																when 9 then 'Setiembre' when 10 then 'Octubre'
																when 11 then 'Noviembre' when 12 then 'Diciembre' end) as ETmes,
										  ETfecha, ETdescripcion, Edocbase
							from ETraspasos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							<cfif isdefined("form.fEdocbase") and len(trim(form.fEdocbase))>
								and upper(rtrim(Edocbase)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.fEdocbase)#%">
							</cfif> 
							<cfif isdefined("form.fETdescripcion") and len(trim(form.fETdescripcion))>
								and upper(rtrim(ETdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.fETdescripcion)#%">
							</cfif> 
							<cfif isdefined("form.fETperiodo") and form.fETperiodo neq "all" >
								and ETperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fETperiodo#">
							</cfif>
							<cfif isdefined("form.fETmes") and form.fETmes neq "all" >
								and ETmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fETmes#">
							</cfif> 
							<cfif isdefined("form.fETfecha") and len(trim(form.fETfecha))>
								and ETfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fETfecha)#">
							</cfif> 
							<cfif isdefined("form.fUsuario") and form.fUsuario neq "all" >
								and ETusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fUsuario#">
							</cfif> 
							order by ETperiodo, ETmes, ETfecha
						</cfquery>
					
					
						<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
						  <cfinvokeargument name="query"  	  value="#rsListaTransferencias#"/>
						  <cfinvokeargument name="desplegar"  value="Edocbase, ETdescripcion, ETfecha, ETperiodo, ETmes"/>
						  <cfinvokeargument name="etiquetas"  value="#LB_Documento#, #LB_Descripcion#, #LB_Fecha#, #LB_Periodo#, #LB_Mes#"/>
						  <cfinvokeargument name="formatos"   value="S,S,D,S,s"/>
						  <cfinvokeargument name="align"      value="left, left, left, left, left"/>
						  <cfinvokeargument name="ajustar"    value="N"/>
						  <cfinvokeargument name="checkboxes" value="S"/>
						  <cfinvokeargument name="Nuevo"      value="Transferencias.cfm"/>
						  <cfinvokeargument name="irA"        value="Transferencias.cfm"/>
						  <cfinvokeargument name="botones"    value="Aplicar,Nuevo,Imprimir"/>
						  <cfinvokeargument name="showEmptyListMsg" value="true"/>
						  <cfinvokeargument name="keys"       value="ETid"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter> 