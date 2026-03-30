<!---------
	Modificado por: Ana Villavicencio
	Fecha: 24 de noviembre del 2005
	Motivo: Cambiar el filtro por Estado de cuenta por la fecha de corte del estado de cuenta.
	
	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: Cambiar el filtro de solo por Estado de cuenta y agregar el banco y la cuenta.

	Modificado por: Ana Villavicencio
	Fecha de modificación: 24 de mayo del 2005
	Motivo:	Modificación en el depliegue de la información del conlis, se hace agrupa por cuenta bancaria
	
	Modificado por: Alejandro Bolaños APH
	Fecha de modificación: 19 de septiembre 2011
	Motivo:	Se agregan los filtros por periodo-mes
	
----------->

<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select distinct Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>
    
<cfset LvarIrAformConciliacion = "formConciliacion.cfm">
<cfset LvarCBesTCE = 0>
<cfset LvarTitulo = "Reporte de Conciliacion Bancaria">
<cfset LvarCuenta = "Cuenta:&nbsp;">
<cfif isdefined("LvarConciliacionTCE")>
	<cfset LvarIrAformConciliacion = "formConciliacionTCE.cfm">
	<cfset LvarCBesTCE = 1>
	<cfset LvarTitulo = "Reporte de Conciliacion Bancaria TCE">
	<cfset LvarCuenta = "Tarjeta de Cr&eacute;dito">
</cfif>

<cfif not isdefined("form.Bid") and  isdefined("url.Bid")>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif not isdefined("form.CBid") and  isdefined("url.CBid")>
	<cfset form.CBid = url.CBid>
</cfif>

<cfif not isdefined("form.ECid") and  isdefined("url.ECid")>
	<cfset form.CBid = url.ECid>
</cfif>

<cfquery name="rsBancos" datasource="#session.DSN#">
	<cfif isdefined("LvarConciliacionTCE")>
		select DISTINCT  b.Bid, b.Bdescripcion 
		from ECuentaBancaria a 
			inner join Bancos b
				on a.Bid = b.Bid 
			inner join CuentasBancos c
				on c.CBid = a.CBid
		where 	
				c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and c.CBesTCE = 1
			and a.CBid = c.CBid 
	<cfelse>
		select Bid, Bdescripcion  
		from Bancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfif>
</cfquery>

<cfquery name="rsCuentas" datasource="#session.DSN#">

	<cfif isdefined("LvarConciliacionTCE")>
		select c.CBid, CBdescripcion, b.Bid
		from ECuentaBancaria a 
			inner join Bancos b
				on a.Bid = b.Bid 
			inner join CuentasBancos c
				on c.CBid = a.CBid
		where 	
				c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and c.CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
			and a.CBid = c.CBid
			and a.EChistorico = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and a.ECStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	<cfelse>
		select CBid, Bid, CBdescripcion
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
	</cfif>
		

</cfquery>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
	
<cf_templateheader title="#LvarTitulo#">
	<cfinclude  template="../../portlets/pNavegacionMB.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>			
		<!---Utilizar en bancos con formConciliacion.cfm o en TCE con formConciliacionTCE.cfm--->
		<form name="form1" method="post" onsubmit="return sinbotones()"  action="<cfoutput>#LvarIrAformConciliacion#</cfoutput>">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="right" width="50%"><strong>Banco:&nbsp;</strong></td>
					<td>
						<select name="Bid" onChange="javascript:cambio_cuenta(this);">
							<option value="">-- seleccionar --</option>
							<cfoutput query="rsBancos">
								<option value="#rsBancos.Bid#" 
									<cfif isdefined('form.Bid') and rsBancos.Bid EQ form.Bid>selected</cfif>>#rsBancos.Bdescripcion#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right" width="50%"><strong><cfoutput>#LvarCuenta#</cfoutput></strong></td>
					<td>
						<select name="CBid" id="CBid">
							<option value="">-- seleccionar --</option>
                            <option value="-1"> - Todas - </option>
						</select>
					</td>
				</tr>
				<tr>
                	<td colspan="2" align="center">
                    	<table width="80%">
                        	<tr>
                                <td align="right" width="45%">
                                    <input type="radio" id="TipoRango1" name="TipoRango" checked="checked" onclick="javascript:CambioRango();"/>
                                     Por fecha
                                </td>
                                <td width="10%">&nbsp;</td>
                                <td align="left" width="45%">
                                    <input type="radio" id="TipoRango2" name="TipoRango" onclick="javascript:CambioRango();"/>
                                     Por Periodo - Mes
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Fecha" style="display:">
                    <td align="right" width="50%"><strong>Fecha del Estado de Cuenta:&nbsp;</strong></td>
                    <td>
                            <cf_sifcalendario name="EChasta">
                    </td>
                </tr>
                <input type="hidden" id="Rango" name="Rango" value="Fecha" />
                <tr id="PeriodoMes" style="display:none">
                    <td align="center" colspan="2">
                    	<table width="30%">
                        	<tr>
                                <td align="right"><strong>Periodo:</strong></td>
                                <td>
                                	<select name="Periodo" id="Periodo">
                                    <cfloop query = "rsPeriodos">
                                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                                    </cfloop>
                               		</select>
                                </td>
                                <td align="right"><strong>Mes:</strong></td>
                                <td>
                                	<select name="Mes" id="Mes">
                                    	<option value="1"><cfoutput>#CMB_Enero#</cfoutput></option>
                                        <option value="2"><cfoutput>#CMB_Febrero#</cfoutput></option>
                                        <option value="3"><cfoutput>#CMB_Marzo#</cfoutput></option>
                                        <option value="4"><cfoutput>#CMB_Abril#</cfoutput></option>
                                        <option value="5"><cfoutput>#CMB_Mayo#</cfoutput></option>
                                        <option value="6"><cfoutput>#CMB_Junio#</cfoutput></option>
                                        <option value="7"><cfoutput>#CMB_Julio#</cfoutput></option>
                                        <option value="8"><cfoutput>#CMB_Agosto#</cfoutput></option>
                                        <option value="9"><cfoutput>#CMB_Setiembre#</cfoutput></option>
                                        <option value="10"><cfoutput>#CMB_Octubre#</cfoutput></option>
                                        <option value="11"><cfoutput>#CMB_Noviembre#</cfoutput></option>
                                        <option value="12"><cfoutput>#CMB_Diciembre#</cfoutput></option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td></td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%"><input type="checkbox" name="montos_cero"></td>
								<td>Mostrar montos en cero</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnConsultar" value="Consultar">
						<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>            	
	 <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
		
	function limpiar(obj){
		var form = obj.form
		form.EChasta.value = "";
		form.Bid.value			 = '';
		form.CBid.value			 = '';
	}
	
	function cambio_cuenta(obj){
			var form = obj.form;
			var combo = form.CBid;
			
			combo.length = 2;
			combo.options[0].text = '-- seleccionar --';
			combo.options[0].value = '';
			combo.options[1].text = '-- Todas --';
			combo.options[1].value = '-1';
			var i = 2;
			<cfoutput query="rsCuentas">
				var tmp = #rsCuentas.Bid# ;
				if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
					combo.length++;
					combo.options[i].text = '#rsCuentas.CBdescripcion#';
					combo.options[i].value = '#rsCuentas.CBid#';
					<cfif (isdefined("form.CBid") and len(trim(form.CBid)) and form.CBid eq rsCuentas.CBid)>
						combo.options[i].selected=true;
					</cfif>
					i++;

				}
				
			</cfoutput>
		}
	
	function CambioRango(){
		if(document.getElementById('TipoRango1').checked){
			document.getElementById('PeriodoMes').style.display='none';
			document.getElementById('Fecha').style.display='';
			document.getElementById('Rango').value='Fecha';
			objForm.EChasta.required = true;
		}
		else {
			document.getElementById('Fecha').style.display='none';
			document.getElementById('PeriodoMes').style.display='';
			document.getElementById('Rango').value='PeriodoMes';
			objForm.EChasta.required = false;
		}
	}
	
	function _forminit(){
		var form = document.form1;
		cambio_cuenta(form.Bid);
	}
	_forminit();
	// ===========================================================================================

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/*-------------------------*/		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	
	objForm.Bid.required = true;
	objForm.Bid.description = "Banco";
	objForm.CBid.required = true;
	objForm.CBid.description = "Cuenta";
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha del Estado de Cuenta";
</script>