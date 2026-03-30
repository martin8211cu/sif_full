<!--- Definición de Variables --->
<cfset modo = "CAMBIO">
<cfif isDefined("form.btnNuevo") and form.btnNuevo eq "Nuevo">
	<cfset modo = "ALTA">
</cfif>
<cfif isDefined("url.btnNuevo") and url.btnNuevo eq "Nuevo" and not isDefined("form.btnNuevo")>
	<cfset modo = "ALTA">
</cfif>
<cfif isDefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>

<!--- Definición de las Consultas --->
<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion
	from NTipoIdentificacion
	order by NTIdescripcion
</cfquery>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif modo eq "CAMBIO">
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select
			a.DEid as DEid,
			a.Ecodigo as Ecodigo,
			a.NTIcodigo as NTIcodigo,
			a.DEidentificacion as DEidentificacion,
			a.DEnombre as DEnombre,
			a.DEapellido1 as DEapellido1,
			a.DEapellido2 as DEapellido2,
			a.DEsexo as DEsexo,
			a.CBcc as CBcc ,
			a.DEdireccion as DEdireccion,
			a.DEcivil as DEcivil,
			a.DEtelefono1 as DEtelefono1,
			a.DEtelefono2 as DEtelefono2,
			a.DEemail as DEemail,
			a.DEfechanac as DEfechanac,
			a.DEobs1  as DEobs1,
			a.DEobs2  as DEobs2,
			a.DEobs3  as DEobs3,
			a.DEdato1 as DEdato1,
			a.DEdato2 as DEdato2,
			a.DEdato3 as DEdato3,
			a.DEdato4 as DEdato4,
			a.DEdato5 as DEdato5,
			a.DEinfo1 as DEinfo1,
			a.DEinfo2 as DEinfo2,
			a.DEinfo3 as DEinfo3,
			b.NTIdescripcion as NTIdescripcion,
			c.Mcodigo as Mcodigo,
			a.DEtarjeta as DEtarjeta,
			a.ts_rversion as ts_rversion,
			a.Bid as Bid,
			a.Ppais as Ppais,
			case a.DEdato1 when 'SI' then 1 when 'NO' then 0 end as DEdato1,
			a.isAbogado as isAbogado,
			a.isCobrador as isCobrador,
			a.PorcentajeCobranzaAntes as PorcentajeCobranzaAntes,
			a.PorcentajeCobranzaDespues as PorcentajeCobranzaDespues
		from DatosEmpleado a 
			inner join NTipoIdentificacion b on
		  		a.NTIcodigo = b.NTIcodigo
		  	inner join Monedas c on
		  		a.Mcodigo = c.Mcodigo and
				a.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.DEid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<cfquery name="rsMascara" datasource="#Session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = #Session.Ecodigo#  
      and Pcodigo = 4401
</cfquery>
<cfset TamañoMascara=len(rsMascara.Pvalor)>
<style type="text/css">
.msjError {
	color: #F00;
}
</style>


<cf_templateheader title="Cat&aacute;logo del Responsable">
		<cf_web_portlet_start titulo="Datos del Empleado">
			<cfoutput>
			<form name="form1" id="form1" method="post" action="empleadosCF-sql.cfm" onsubmit="return fnValidaMaskID()">
				<br>
				<fieldset>
					<legend><strong>Empleado&nbsp;</strong></legend>			
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<!--- Línea No. 1 --->
						<tr>
							<td class="fileLabel">Tipo de Identificaci&oacute;n</td>
							<td class="fileLabel">Identificaci&oacute;n</td>
							<td class="fileLabel">Sexo</td>
						</tr>
						<!--- Línea No. 2 --->
						<tr>
							<td>
								<select name="NTIcodigo" id="select" tabindex="1">
									<cfloop query="rsTipoIdent">
										<option value="#rsTipoIdent.NTIcodigo#" <cfif modo NEQ 'ALTA' and rsEmpleado.NTIcodigo EQ rsTipoIdent.NTIcodigo> selected</cfif>>#rsTipoIdent.NTIdescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td>
                            
								<input name="DEidentificacion" type="text" id="DEidentificacion" tabindex="1"  value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEidentificacion#</cfif>" onFocus="this.select()"  onchange="validarMascara()">
								<span id="msjError" class="msjError"></span>
							  <input name="DEidentificacionL" type="hidden" id="DEidentificacionL" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEidentificacion#</cfoutput></cfif>">
                              
                              	
                                
                                
                                <cfparam name="Request.jsMask" default="false">
                                
                                <cfif Request.jsMask EQ false>
                                    <cfset Request.jsMask = true>
                                    <script src="/cfmx/sif/js/MaskApi/masks.js"></script>
                                	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
                                </cfif>                                
							</td>
							<td>
								<select name="DEsexo" id="select2" tabindex="1">
									<option value="M" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'M'> selected</cfif>>Masculino</option>
									<option value="F" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'F'> selected</cfif>>Femenino</option>
								</select>
							</td>
						</tr>
                        <!--- Línea de mascara --->
                        <tr> 
							<td class="fileLabel"></td>
							<td style="font-size:10px; color:##999">#rsMascara.Pvalor#</td>
							<td class="fileLabel"></td>
						</tr>
						<!--- Línea No. 3 --->
						<tr> 
							<td class="fileLabel">Nombre</td>
							<td class="fileLabel">Primer Apellido</td>
							<td class="fileLabel">Segundo Apellido</td>
						</tr>
						<!--- Línea No 4 --->
						<tr> 
							<td><input name="DEnombre" type="text" id="DEnombre" tabindex="1" size="40" maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEnombre#</cfif>" onFocus="this.select()"></td>
							<td><input name="DEapellido1" type="text" id="DEapellido1" tabindex="1" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEapellido1#</cfif>" onFocus="this.select()"></td>
							<td><input name="DEapellido2" type="text" id="DEapellido2" tabindex="1" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEapellido2#</cfif>" onFocus="this.select()"></td>
						</tr>
						<!--- Línea No 5 --->
						<tr> 
							<td class="fileLabel">Estado Civil</td>
							<td class="fileLabel">Moneda</td>
							<td class="fileLabel">Fecha de Nacimiento</td>
						</tr>
						<!--- Línea No 6 --->
						<tr> 
							<td>
								<select name="DEcivil" id="DEcivil" tabindex="1">
									<option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 0> selected</cfif>>Soltero(a)</option>
									<option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 1> selected</cfif>>Casado(a)</option>
									<option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 2> selected</cfif>>Divorciado(a)</option>
									<option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 3> selected</cfif>>Viudo(a)</option>
									<option value="4" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 4> selected</cfif>>Union Libre</option>
									<option value="5" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 5> selected</cfif>>Separado(a)</option>
								</select>
							</td>
							<td>
								<select name="Mcodigo" id="Mcodigo" tabindex="1">
									<cfloop query="rsMoneda"> 
										<option value="#rsMoneda.Mcodigo#"<cfif modo NEQ 'ALTA' and rsEmpleado.Mcodigo EQ rsMoneda.Mcodigo> selected</cfif>>#rsMoneda.Mnombre#</option>
									</cfloop>
							  	</select>							
							</td>
							<td> 
								<cfif modo NEQ 'ALTA'>
									<cfset fecha = LSDateFormat(rsEmpleado.DEfechanac, "DD/MM/YYYY")>
								<cfelse>
									<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
								</cfif>
								<cf_sifcalendario form="form1" value="#fecha#" name="DEfechanac" tabindex="1">
							</td>
						</tr>
						<!--- Línea No 7 --->
						<tr>
							<td class="fileLabel">Direcci&oacute;n</td>
							<td class="fileLabel">&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<!--- Línea No 8 --->
						<tr>
							<td colspan="3" class="fileLabel">
								<textarea name="DEdireccion" id="DEdireccion" tabindex="1" rows="2" style="width: 100%;" onFocus="this.select()"><cfif modo NEQ 'ALTA'>#rsEmpleado.DEdireccion#</cfif></textarea>
							</td>
						</tr>
						<!--- Línea No 9 --->
						<tr> 
							<td class="fileLabel">Tel&eacute;fono de Residencia</td>
							<td class="fileLabel">Tel&eacute;fono Celular</td>
							<td class="fileLabel">Direcci&oacute;n electr&oacute;nica</td>
						</tr>
						<tr> 
							<td><input name="DEtelefono1" type="text" id="DEtelefono13" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEtelefono1#</cfif>" size="30" maxlength="30" onFocus="this.select()"></td>
							<td><input name="DEtelefono2" type="text" id="DEtelefono2" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEtelefono2#</cfif>" size="30" maxlength="30" onFocus="this.select()"></td>
							<td><input name="DEemail" type="text" id="DEemail" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsEmpleado.DEemail#</cfif>" size="40" maxlength="120" onFocus="this.select()"></td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>						
						<tr>
							<td class="fileLabel">Tipo de Empleado</td>
							<td class="fileLabel">
								<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
								<cfset val = objParams.getParametroInfo('30200503')>
								<cfif val.valor eq ''><cfthrow message=" El parametro [30200503 - Dias para comision de gestor o abogado] no esta definido"></cfif>
								Porcentaje de Cobranza a [#val.valor#] dias
							</td>
							<td><input type="checkbox" name="chkFirma" <cfif isdefined("rsEmpleado.DEdato1") and #rsEmpleado.DEdato1# EQ 'SI'>checked="true"</cfif>/>Autorizado para Firmar</td>
						</tr>							
						<tr>
							<td>
								<select name="Cob_Abg"  tabindex="1">
									<option value="" selected>Ninguno</option>
									<option value="abogado" <cfif modo NEQ 'ALTA'><cfif rsEmpleado.isAbogado eq 1>selected</cfif></cfif>>Abogado</option>
									<option value="cobrador" <cfif modo NEQ 'ALTA'><cfif rsEmpleado.isCobrador eq 1>selected</cfif></cfif>>Gestor</option>
								</select>
							</td>
							<td>
								antes: <input name="PorcientoCobranza1" type="number" id="PorcientoCobranza1" tabindex="1" <cfif modo NEQ 'ALTA'>value=#rsEmpleado.PorcentajeCobranzaAntes#</cfif> step="any" style="width:55px;">&emsp;%
								&emsp;despu&eacutes: <input name="PorcientoCobranza2" type="number" id="PorcientoCobranza2" tabindex="1" <cfif modo NEQ 'ALTA'>value=#rsEmpleado.PorcentajeCobranzaDespues#</cfif> step="any" style="width:55px;">&emsp;%
							</td>
							<td></td>
						</tr>					
					</table>
				</fieldset>

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							<cfset ts  = "">
							<cfset ts2 = "">
							<cfif modo NEQ 'ALTA'>
								<input type="hidden" name="DEid" id="DEid" value="#form.DEid#" tabindex="-1">
								<!--- <input type="hidden" name="CFid" id="CFid" value="#form.CFid#" tabindex="-1"> --->

								<!--- ts_rVersion --->
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsEmpleado.ts_rversion#" returnvariable="ts"></cfinvoke>
								<input type="hidden" name="ts_rversion" value="#ts#">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsEmpleado.ts_rversion#" returnvariable="ts2"></cfinvoke>
								<input type="hidden" name="ts_rversion2" value="#ts2#">
							</cfif>
							<cf_botones modo="#modo#" include="Lista" tabindex="1">
							<input type="hidden" name="modo" id="modo" value="#modo#">							
						</td>
					</tr>
				</table>
			</form>
            <form name="form2">
				<cfif modo NEQ 'ALTA'>
					<fieldset>
						<legend><strong>Vigencia&nbsp;</strong></legend>
						<!--- Valida si el usuario tiene alguna línea de tiempo vigente --->
						<cfquery name="rsValidaLineaVigente" datasource="#session.dsn#">
							select 1
							from EmpleadoCFuncional
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							   and #now()# between ECFdesde and ECFhasta   
						</cfquery>
									
						<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<cfif isdefined("rsValidaLineaVigente") and rsValidaLineaVigente.recordcount EQ 0>
													<input type="button" name="btnAgregarCF" class="btnGuardar" value="Agregar CF" onClick="javascript: AgregarCF();">
												<cfelse>
													<input type="button" name="btnCambiarCF" class="btnGuardar"     value="Cambiar CF" onClick="javascript: CambiarCF();">
													<input type="button" name="btnCerrarCF" class="btnNormal"  value="Retirar CF" onClick="javascript: RetirarCF();">
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>
								<cf_dbfunction name="date_format" args="a.ECFdesde,DD/MM/YYYY"  returnvariable="ECFdesde">
								<cf_dbfunction name="date_format" args="a.ECFhasta,DD/MM/YYYY"  returnvariable="ECFhasta">
								<cf_dbfunction name="to_char" args="a.ECFlinea"  returnvariable="ECFlinea">
								<cf_dbfunction name="to_char" args="a.CFid"  	 returnvariable="CFid">
								<cf_dbfunction name="concat" args="'<a href=''javascript:ModificarCF(' + #ECFlinea# + ',' + #CFid# + ');''><img src=''/cfmx/sif/imagenes/iedit.gif'' border=''0''></a>'" delimiters="+"  returnvariable="Modificar">
									<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet"
										tabla="EmpleadoCFuncional a, CFuncional b "
										columnas="	a.ECFlinea,
													a.DEid,
													a.CFid,
													#ECFdesde# as ECFdesde,
													#ECFhasta# as ECFhasta,
													case when a.ECFencargado = 1 
															then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' 
															else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' 
													end as ECFencargado,
													#Modificar#  as Modificar,
													b.CFcodigo,
													b.CFdescripcion"
										desplegar="CFcodigo,CFdescripcion,ECFdesde,ECFhasta,ECFencargado,Modificar"
										etiquetas="Codigo, Centro Funcional,Fecha Inicio,Fecha Final,Encargado, "
										formatos="S,S,S,S,S,S"
										filtro=" 	a.Ecodigo = #session.ecodigo# 
													and a.CFid = b.CFid 
													and a.DEid = #form.DEid# 
												order by ECFdesde "
										align="left,left,left,left,center,center"
										ajustar="N"
										checkboxes="N"
										keys="DEid,CFid"
										MaxRows="20"
										MaxRowsQuery="500"
										showLink="false"
										showEmptyListMsg="true"
										incluyeForm="false"
										formName="lista"
									/>
	
								</td>
							</tr>
						</table>
					</fieldset>
				</cfif>
                <input name="MaskIDCorrecto" id="MaskIDCorrecto" type="hidden" value="1" />
			</form>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
<cf_qforms>
            <cf_qformsRequiredField name="DEnombre" description="Nombre">
			<cf_qformsRequiredField name="DEidentificacion" description="Identificación">
			<cf_qformsRequiredField name="DEfechanac" description="Fecha de Nacimiento">
</cf_qforms>
<cfoutput>
<script language="javascript1.2" type="text/javascript">

<cfoutput>
										<cfset varMask_= #Replace(rsMascara.Pvalor,'X','x','ALL')#>
										<cfset varMask_= #Replace(varMask_,'?','##','ALL')#>

										var Mask_1 = new Mask("#varMask_#", "string");
										Mask_1.attach(document.form1.DEidentificacion, Mask_1.mask, "string");
									
										function validarMascara(){
											if(document.form1.DEidentificacion.value.length!=0 && #TamañoMascara#!=document.form1.DEidentificacion.value.length)
											{	alert('La identificación del Empleado es incorrecta');
												document.form1.DEidentificacion.focus();
												document.getElementById('msjError').innerHTML = "Incorrecto";
												return false;
											}
											else
											{
												document.getElementById('msjError').innerHTML = "";
												return true;
											}
										}
									
									
									</cfoutput>	


	function funcLista()
	{
		deshabilitarValidacion();
		return true;
	}
	document.form1.NTIcodigo.focus();
		
	<cfif modo NEQ 'ALTA'>
		function AgregarCF() 
		{
			var PARAM  = "empleadosCF-agregarCF.cfm?DEid="+<cfoutput>#form.DEid#</cfoutput>;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=500,height=200');
		}
	
		function CambiarCF()
		{
			var PARAM  = "empleadosCF-cambiarCF.cfm?DEid="+<cfoutput>#form.DEid#</cfoutput>;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=500,height=300');
		}
		
		function RetirarCF()
		{
			var PARAM  = "empleadosCF-retirarCF.cfm?DEid="+<cfoutput>#form.DEid#</cfoutput>;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=500,height=200');
		}
		
		function ModificarCF(vECFlinea,vCFid)
		{
			var PARAM  = "empleadosCF-modificarCF.cfm?DEid="+<cfoutput>#form.DEid#</cfoutput>+"&ECFlinea="+vECFlinea+"&CFid="+vCFid;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=500,height=200');
		}
	</cfif>
	function fnValidaMaskID()
	{	
		return validarMascara();
	}
	
	function funcCambio(){
		var tipoEmpleado = document.getElementsByName('Cob_Abg')[0].value;
		var porcentaje1 = document.getElementsByName('PorcientoCobranza1')[0].value
		var porcentaje2 = document.getElementsByName('PorcientoCobranza2')[0].value
		if(tipoEmpleado != "" && ((porcentaje1=="" || porcentaje1==0) || (porcentaje2=="" || porcentaje2==0))){
			alert('Se requiere un porcentaje de cobranza');
			return false;
		}
		return true;
	}
	
	function funcAlta(){
		var tipoEmpleado = document.getElementsByName('Cob_Abg')[0].value;
		var porcentaje1 = document.getElementsByName('PorcientoCobranza1')[0].value
		var porcentaje2 = document.getElementsByName('PorcientoCobranza2')[0].value
		if(tipoEmpleado != "" && ((porcentaje1=="" || porcentaje1==0) || (porcentaje2=="" || porcentaje2==0))){
			alert('Se requiere un porcentaje de cobranza');
			return false;
		}
		return true;
	}
	
</script>
</cfoutput>
