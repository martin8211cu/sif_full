<!---------
	Modificado por: Ana Villavicencio
	Fecha: 1 de diciembre del 2005
	Motivo: Se agregó un nuevo tipo de conciliacion automática en el paso 2. Transaccion - Documento - Monto.
			
	Modificado por: Ana Villavicencio
	Fecha: 23 de noviembre del 2005
	Motivo: Agregar los datos del estado de cuenta en proceso
	
	Modificado por: Ana Villavicencio
	Fecha: 14 de noviembre del 2005
	Motivo: Se cambio el proceso de conciliacion en lo que respecta a estados de cuenta los cuales 
			no concluye el proceso, esto es mantener los datos de esta conciliacion mientras q no se indique
			lo contrario (reiniciar el proceso).
	
	Modificado por: Ana Villavicencio
	Fecha: 25 de octubre del 2005
	Motivo: cambio de llamado de componente para la conciliacion bancaria, se llama la funcion para el inicion de la conciliacion.
			Se hace la conciliacion bancaria por defecto (Transaccion - Documento - Monto) utilizando la nueva funcion de 
			conciliacion automática y enviando tipo = 0.
			El tipo = 1 es Transaccion - Fecha - Monto y tipo = 2 es Transaccion - Monto
			
	Creado por: Ana Villavicencio
	Fecha de creación: 17 de mayo del 2005
	Motivo:	Nuevo paso en le proceso de conciliación bancaria.  
			Conciliación Automática procesa los documentos que se puedan conciliar automaticamente por Transaccion-Fecha-Monto o
			Transaccion-Monto. 
			El proceso es seleccionado por el usuario. Una vez terminado este paso puede continuar con la conciliación manual.
	
	Modificado por: Ana Villavicencio
	Fecha: 07 de octubre del 2005
	Motivo: modificar el diseño de la forma, se cambio el tamaño de las etiquetas y el estilo de los radio 
			para q fuera del color del fondo y además q si marca el texto tambien selecciona esa opcion.

	Creado por: Desconocido
	Fecha: Desconocido
	Motivo: Desconocido
----------->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAFrameConfig="frame-config.cfm">
<cfset LvarIrAFrameProgre="frame-Progreso.cfm">
<cfset LvarIrAConciliacion="Conciliacion.cfm">
<cfset LvarIrAlistECP="listaEstadosCuentaEnProceso.cfm">
<cfset LvarIrAframeProgreso="frame-Progreso.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfset LvarBTEtce=0><!---Filtro para transaccion de los querys TCE o CDBancos--->
 <cfif isdefined("LvarTCEConciliacionAuto")>
	<cfset LvarIrAFrameConfig="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAFrameProgre="../../tce/operaciones/TCEframe-Progreso.cfm"> 
	<cfset LvarIrAConciliacion="TCEConciliacion.cfm">
	<cfset LvarIrAlistECP="../../tce/operaciones/listaEstadosCuentaProcesoTCE.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
	<cfset LvarIrAframeProgreso="../../tce/operaciones/TCEframe-Progreso.cfm">
	<cfset LvarBTEtce=1>
</cfif>

<cf_dbfunction name="now" returnvariable="now">

<cfquery name="rsDatosEC" datasource="#session.DSN#">
	select ec.ECid,
		ec.ECdescripcion,
		b.Bdescripcion, 
		cb.CBdescripcion, 
		ec.Bid,
		ec.CBid,
		coalesce(ec.ECdesde, #now# ) as ECdesde,
		coalesce(ec.EChasta, #now# ) as EChasta
	from ECuentaBancaria ec
	inner join CuentasBancos cb
	   on cb.CBid = ec.CBid
	  and cb.Bid = ec.Bid
	  and cb.Ecodigo =  #Session.Ecodigo#
	inner join Bancos b
	   on b.Bid = cb.Bid
	  and b.Ecodigo = cb.Ecodigo
	where ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
    	and cb.CBesTCE = #LvarCBesTCE#
</cfquery>
<!-- Combo Tipos de Transaccion -->
<!---
	Filtro #LvarBTEtce# para transacciones Bancos  o Tarjetas Credito
 --->
<cfquery name="rsTipos" datasource="#Session.DSN#">
 	select Bid, BTEcodigo, BTEdescripcion 
	from TransaccionesBanco
	where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEC.Bid#">
		and BTEtce = #LvarBTEtce# 
 		order by BTEdescripcion
</cfquery>

<cfquery name="rsConsultaLibros" datasource="#session.DSN#">
	select 1
	from CDLibros
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
</cfquery>

<cfquery name="rsConsultaBancos" datasource="#session.DSN#">
	select 1
	from CDBancos
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
</cfquery>


<cfif isdefined('InicioConc') and rsConsultaBancos.RecordCount EQ 0 and rsConsultaLibros.RecordCount EQ 0>
	<cfinvoke 
		 component="sif.Componentes.MB_ConciliacionBancaria"
		 method="IniciaConciliacionBancaria"
		 returnvariable="LvarResult">
	  <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
	  <cfinvokeargument name="ECid" value="#ECid#"/>
	  <cfinvokeargument name="preconciliar" value="true"/>
	  <cfinvokeargument name="debug" value="false"/>
	  <cfinvokeargument name="usuario" value="#Session.Usuario#"/>
	  <cfinvokeargument name="conexion" value="#Session.DSN#"/>
	  <!---Filtro para TCE o Conciliacion Bancaria en Bancos---> 
	  <cfif isdefined("LvarTCEConciliacionAuto")>
	 	 <cfinvokeargument name="CBesTCE" value="1"/>
	  <cfelse>
	  	 <cfinvokeargument name="CBesTCE" value="0"/>
 	  </cfif>
	 </cfinvoke>
	
	<cfloop query="rsTipos">
		<cfinvoke 
			 component="sif.Componentes.MB_ConciliacionBancaria"
			 method="ConciliacionBancaria"
			 returnvariable="LvarResult">
		  <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
		  <cfinvokeargument name="ECid" value="#ECid#"/>
		  <cfinvokeargument name="Bid" value="#rsTipos.Bid#"/>
		  <cfinvokeargument name="BTEcodigo" value="#rsTipos.BTEcodigo#"/>
		  <cfinvokeargument name="preconciliar" value="true"/>
		  <cfinvokeargument name="Tipo" value="0"/>	
		  <cfinvokeargument name="debug" value="false"/>
		  <cfinvokeargument name="usuario" value="#Session.Usuario#"/>
		  <cfinvokeargument name="conexion" value="#Session.DSN#"/>
		 <!---Filtro para TCE o Conciliacion Bancaria en Bancos---> 
		  <cfif isdefined("LvarTCEConciliacionAuto")>
			 <cfinvokeargument name="CBesTCE" value="1"/>
		  <cfelse>
			 <cfinvokeargument name="CBesTCE" value="0"/>
		  </cfif>
	 </cfinvoke>
	</cfloop>
<cfelse>
	<!--- JARR se Ejecuta la Funcion para cargar movimientos de MLibros que falten en CDLibros --->
	<cfinvoke 
		 component="sif.Componentes.MB_ConciliacionBancaria"
		 method="CargaMovAlMesAxuliar"
		 returnvariable="LvarResult">
	  <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
	  <cfinvokeargument name="ECid" value="#ECid#"/>
	  <cfinvokeargument name="Bid" value="#rsDatosEC.Bid#"/>
	  <cfinvokeargument name="CBid" value="#rsDatosEC.CBid#"/>
	  <cfinvokeargument name="usuario" value="#Session.Usuario#"/>
	  <cfinvokeargument name="conexion" value="#Session.DSN#"/>
	 </cfinvoke>
</cfif>

<cfset filtroDefault = false>
<cfif not isdefined('form.TFM') and not isdefined('form.TM') and not isdefined('form.TDM')>
	<cfset filtroDefault = true>
</cfif>

		<!---Redireccion de frame-config.cfm o TCEframe-config.cfm--->
		<cfinclude template="#LvarIrAFrameConfig#">
 		
		<style type="text/css">
			input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
		</style>
<cfif isdefined('Form.TDM')>
	<cfset tipoC = 0>
<cfelseif isdefined('Form.TFM')>
	<cfset tipoC = 1>
<cfelseif isdefined('Form.TM')>
	<cfset tipoC = 2>
<cfelse>
	<cfset tipoC = 4>
</cfif>

<!--- <cf_dump var="#tipoC#"> --->	

<cfif isdefined('tipoC') and tipoC LT 4>
	<cfset campos = ListToArray(Transaccion,"|")>
	<cfinvoke 
		 component="sif.Componentes.MB_ConciliacionBancaria"
		 method="ConciliacionBancaria"
		 returnvariable="LvarResult">
	  <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
	  <cfinvokeargument name="ECid" value="#ECid#"/>
	  <cfinvokeargument name="Bid" value="#campos[1]#"/>
	  <cfinvokeargument name="BTEcodigo" value="#campos[2]#"/>
	  <cfinvokeargument name="preconciliar" value="true"/>
	  <cfinvokeargument name="Tipo" value="#tipoC#"/>	  
	  <cfinvokeargument name="debug" value="false"/>
	  <cfinvokeargument name="usuario" value="#Session.Usuario#"/>
	  <cfinvokeargument name="conexion" value="#Session.DSN#"/>
	 <!---Filtro para TCE o Conciliacion Bancaria en Bancos---> 
	  <cfif isdefined("LvarTCEConciliacionAuto")>
	 	 <cfinvokeargument name="CBesTCE" value="1"/>
	  <cfelse>
	  	 <cfinvokeargument name="CBesTCE" value="0"/>
 	  </cfif>
	 </cfinvoke>		
</cfif>
<cf_templateheader title="Conciliaci&oacute;n Autom&aacute;tica">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=''>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="85%" valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<form name="frmGO" action="" method="post" style="margin: 0; ">
							<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
							<input type="hidden" name="TipoCAutomatica" 
								value="<cfif isdefined('Form.TFM')>#Form.TFM#<cfelseif isdefined('Form.TM')>#Form.TM#</cfif>">
						</form>
						<form action="" method="post" name="form1">
						  <input type="hidden" name="ECid" value="<cfif isDefined("Form.ECid") and Form.ECid NEQ ""><cfoutput>#Form.ECid#</cfoutput></cfif>">
						
						<table width="100%" border="0" cellpadding="1" cellspacing="0">
							<tr>
								<td>
									<table width="100%" border="0">
										<tr><td colspan="2">&nbsp;</td></tr>
										<tr>
											<td align="right" nowrap><span style="font-size:10px"><strong>Cuenta:</strong></span></td>
											<td nowrap>
												<span style="font-size:10px">
													<cfif isDefined("Form.ECid")>
														<cfoutput>#rsDatosEC.Bdescripcion# - #rsDatosEC.CBdescripcion#</cfoutput>
													<cfelse>
														<cfoutput>#rsDatosEC.getField(1,3)# - #v.getField(1,4)#</cfoutput>
													</cfif>
												</span>
											</td>
										</tr>
										<tr> 
											<td align="right" nowrap>&nbsp;</td>
											<td nowrap>
												<span style="font-size:10px"><cfoutput>#rsDatosEC.ECdescripcion#</cfoutput></span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="84%">
									<table width="41%"  border="0" align="center">
										<tr>
											<td align="left"><span style="font-size:11px"><strong>Transacci&oacute;n</strong></span></td>
										</tr>
										<tr>
											<td>
												<select name="Transaccion">
													<cfoutput query="rsTipos">
														<option value="#rsTipos.Bid#|#rsTipos.BTEcodigo#"><span style="font-size:11px">#rsTipos.BTEdescripcion#</span></option>
													</cfoutput>
											  	</select>				
											</td>
										</tr>
										<tr>
											<td align="left">
												<input name="TDM" type="radio" value="0" <cfif isdefined('form.TDM')>checked</cfif>
												id="TDM"
												onClick="javascript: document.form1.TFM.checked=false; document.form1.TM.checked=false;"
												style=" border:0; background:background-color">
												<label for="TDM"><span style="font-size:10px">Transacci&oacute;n - Documento - Monto</span></label>
											</td>
										</tr>
										<tr>
											<td align="left">
												<input name="TFM" type="radio" value="1" <cfif isdefined('form.TFM')>checked</cfif>
												id="TFM"
												onClick="javascript: document.form1.TDM.checked=false;document.form1.TM.checked=false;"
												style=" border:0; background:background-color">
												<label for="TFM"><span style="font-size:10px">Transacci&oacute;n - Fecha - Monto</span></label>
											</td>
										</tr>
										
										<tr>
											<td align="left">
												<input name="TM" type="radio" value="2"  <cfif isdefined('form.TM')>checked</cfif>
												 id="TM"
												onClick="javascript: document.form1.TDM.checked=false;document.form1.TFM.checked=false;"
												style=" border:0; background:background-color">
											 <label for="TM"><span style="font-size:10px">Transacci&oacute;n - Monto</span></label>
											</td>
										</tr>
								  	</table>
								</td>
							</tr>
							<tr>
								<td bgcolor="#A0BAD3" align="right">
									<input type="button" name="Anterior" value="<< Anterior" 
										onClick="javascript: funcRegresar();">
									<input type="submit" name="Conciliar" value="Conciliar" 
										onClick="">
									<input type="button" name="Siguiente" value="Siguiente >>" 
										onClick="javascript: funcSiguiente();">
										
								</td>
							</tr>
						</table>
						<br>
						</form>	
						<script language="JavaScript" type="text/javascript">
							function funcRegresar() {
								<!--- Redireccion listaEstadosCuentaEnProceso.cfm o listaEstadosCuentaEnProcesoTCE.cfm (TCE)--->
								document.frmGO.action='<cfoutput>#LvarIrAlistECP#</cfoutput>';
								document.frmGO.submit();
							}
						
							function funcSiguiente() {
								<!---Redireccion Conciliacion.cfm o TCEConciliacion.cfm--->
								document.frmGO.action='<cfoutput>#LvarIrAConciliacion#</cfoutput>';
								document.frmGO.submit();
							}
						</script>		
				</td>
			    <td width="15%" valign="top">
 					<cfinclude template="#LvarIrAFrameProgre#">
					<br>
					<div class="ayuda">
						<strong>Pasos para Realizar la Operación:</strong><br><br>
						1) Selecciones el tipo de Conciliación a realizar y presione el bot&oacute;n de <font color="#003399"><strong>Conciliar</strong></font>.<br><br>
						2) Si no desea realizar una conciliaci&oacute;n autom&aacute;tica presione el bot&oacute;n de <font color="#003399"><strong>Siguiente>></strong></font>.<br><br>
						3) Si desea volver a la pantalla anterior presione el bot&oacute;n de <font color="#003399"><strong><< Anterior</strong></font>.
					</div>
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
	<cf_templatefooter>