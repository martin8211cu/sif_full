<!---------
	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: se cambio el filtro, se puso el banco, cuenta bancaria y estado de cuenta.
			Se cambio el despliegue de los datos, se eliminaron las dos columnas.
			Se agrego un parametro por url, para indicar si son documentos conciliados o no conciliados.
			
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Nuevo reporte de Partidas sin conciliar
----------->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
		
		Modificado por: Alejandro Bolaños APH
		Fecha de modificación: 19 de septiembre 2011
		Motivo:	Se agregan los filtros por periodo-mes y el poder elegir todas las cuentas de un banco

--->

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

<cfset LvarIrARPPartiSinConci="RPPartidasSinConciliar.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfset LvarTitulo = "Reporte de Partidas sin Conciliar">
<cfset LvarCuenta = "Cuenta:&nbsp;">
<cfif isdefined("LvarTCEPartiSinConci") or isdefined("LvarTCEPartiSinConciConsulta")>
 	<cfset LvarIrARPPartiSinConci="TCERPPartidasSinConciliar.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
	<cfset LvarTitulo = "Reporte de Partidas sin Conciliar TCE">
	<cfset LvarCuenta = "Tarjeta de Cr&eacute;dito:">
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
	<cfif isdefined("LvarTCEPartiSinConci") or isdefined("LvarTCEPartiSinConciConsulta")>
		select DISTINCT  b.Bid, b.Bdescripcion 
		from ECuentaBancaria a 
			inner join Bancos b
				on a.Bid = b.Bid 
			inner join CuentasBancos c
				on c.CBid = a.CBid
		where 	
				c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and c.CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
			and a.CBid = c.CBid 
	<cfelse>
		select Bid, Bdescripcion  
		from Bancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfif>
</cfquery>

<cfquery name="rsCuentas" datasource="#session.DSN#">
	<cfif isdefined("LvarTCEPartiSinConci") or isdefined("LvarTCEPartiSinConciConsulta")>
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
			and a.EChistorico = <cfqueryparam cfsqltype="cf_sql_char" value="N">
			and a.ECStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	<cfelse>
	select CBid, Bid, CBdescripcion
	from CuentasBancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
	</cfif>
		
</cfquery>

<cf_templateheader title="#LvarTitulo#">

<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<!---Redireccion RPPartidasSinConciliar.cfm o TCERPPartidasSinConciliar.cfm--->
<form name="form1" method="post"  onsubmit="return sinbotones()" action="<cfoutput>#LvarIrARPPartiSinConci#</cfoutput>">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
					titulo="#LvarTitulo#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>	
				<td valign="top">
					<table border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="right" width="50%"><strong>Banco:&nbsp;</strong></td>
							<td>
								<select name="Bid" onChange="javascript:cambio_cuenta(this);">
									<option value="">-- seleccionar --</option>
									<cfoutput query="rsBancos">
										<option value="#rsBancos.Bid#">#rsBancos.Bdescripcion#</option>
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
                                <table width="90%">
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
								<!--- <cfset valuesArray = ArrayNew(1)>
								<cfif isdefined('form.ECid')>
									<cfset ArrayAppend(valuesArray, Form.ECid)>
									<cfset ArrayAppend(valuesArray, Form.ECdescripcion)>
								</cfif>
									<cf_conlis 
										title="Lista de Estados de Cuenta"
										campos = "ECid, ECdescripcion" 
										desplegables = "N,S" 
										modificables = "N,N"
										size = "0,60"
										valuesarray="#valuesArray#" 
										tabla="ECuentaBancaria ec
												inner join CuentasBancos cb
												   on ec.CBid=cb.CBid
												   and cb.CBesTCE = #LvarCBesTCE#
												inner join Bancos b
												   on cb.Bid = b.Bid
												  and cb.Ecodigo = b.Ecodigo"
										columnas="ec.Bid,ec.CBid,ec.ECid,ec.ECdescripcion,b.Bdescripcion, 
	   											  cb.CBdescripcion,ECdesde,EChasta,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
										filtro="cb.Ecodigo = #Session.Ecodigo# and ec.Bid=$Bid,numeric$ and ec.CBid = $CBid,numeric$ and ECaplicado='N'"
										desplegar="ECdescripcion,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
										filtrar_por="ECdescripcion,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
										etiquetas="Descripcion, Débitos, Créditos, Saldo Inicial,Saldo Final"
										formatos="S,M,M,M,M"
										align="left,right,right,right,right "
										asignar="ECid,ECdescripcion"
										asignarformatos="I,S"> --->
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
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center" width="50%" colspan="2">
								<input name="visualiza" type="submit" value="Consultar" onClick="javascript: document.form1.cons.value = 'N';">
								<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
								<input name="cons" type="hidden" value="">
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
				</td>
			</tr>		
		</table>
	<cf_web_portlet_end>
</form>

<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'flashpaper'>
</cfif>
<cf_templatefooter>


<script language="JavaScript1.2">

	function limpiar(obj){
		var form = obj.form
		form.EChasta.value          = "";
		form.Bid.value			 = '';
		form.CBid.value			 = '';
	}

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");


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