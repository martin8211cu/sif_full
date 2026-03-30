<!---
Creado por: José Madrigal Arias
Fecha:04 de febrero del 2008
descripci&oacute;n: Filtros para creacion de Anticipos y liquidaciones asi como revicion de liquidaciones, nesesario QuerryLE.cfm(Liquidaciones) o QuerryAE.cfm(Anticpos de Empleados)
--->
<!--- verificacion--->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="Attributes.Tipo"				default="">
<cfparam name="Attributes.Estado"			default="0">
<cfparam name="Attributes.AprobacionL"		default="no"  type="boolean">
<cfparam name="Attributes.ListarCancelados" default="yes" type="boolean">
<cfparam name="Attributes.Botones" 			default=""    type="string">
<cfparam name="Attributes.PorEmpleado" 		default="no"  type="boolean">

<cfset LvarSAporComision = isdefined('caller.LvarSAporComision') and caller.LvarSAporComision>
	
<cfset LvarPrimera = false>
<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>
							
<cf_navegacion name="CFid_F" 				session default="">
<cf_navegacion name="UsucodigoSP_F"			session default="">
<cf_navegacion name="Usucodigo2_F"			session default="">
<cf_navegacion name="DEid_F" 	value="" session>
<cf_navegacion name="TESSPfechaPago_I" 		session value="">
<cf_navegacion name="TESSPfechaPago_F" 		session default="">
<cf_navegacion name="McodigoOri_F"			session default="">

	<cfif isdefined("form.cboCFid")>
		<cfset form.CFid_F = form.cboCFid>
	</cfif>
	<cfset form.cboCFid = form.CFid_F>
	
	<cfif Attributes.PorEmpleado>
		<cfset form.UsucodigoSP_F = session.usucodigo>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			  from UsuarioReferencia
			 where Usucodigo= #session.Usucodigo#
			   and Ecodigo	= #session.EcodigoSDC#
			   and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "50737"
							msg  = "El usuario '@errorDat_1@' no ha sido registrado como Empleado de la Empresa"
							errorDat_1="#session.Usulogin#"
			>
		</cfif>
		<cfset form.DEid = rsSQL.DEid>
	<cfelseif isdefined("form.Usucodigo")>	
		<cfset form.UsucodigoSP_F = form.Usucodigo>
	</cfif>
	<cfset form.Usucodigo = form.UsucodigoSP_F>
	
	<cfif isdefined("form.Usucodigo2")>	
		<cfset form.Usucodigo2_F = form.Usucodigo2>
	</cfif>
	<cfset form.Usucodigo2 = form.Usucodigo2_F>
	
	<cfif isdefined("form.DEid")>	
		<cfset form.DEid_F = form.DEid>
	</cfif>
	<cfset form.DEid = form.DEid_F>
	
	<cfif Attributes.Tipo EQ 6>
		<cfset label="Anticipo">
		<cfset labels="Anticipos">
	<cfelseif Attributes.Tipo EQ 7>
		<cfset label="Liquidación">
		<cfset labels="Liquidaciónes">
	<cfelseif Attributes.Tipo EQ 8>
		<cfset label="Transaccion">
		<cfset labels="Transaccion">
	<cfelseif Attributes.Tipo EQ 9 >
		<cfset label="Transacción">
		<cfset labels="Transacciones">
	<cfelseif Attributes.Tipo EQ 16 >
		<cfset label="Comisión">
		<cfset labels="Comisiones">
	<cfelseif Attributes.Tipo EQ 9 >
		<cfset label="Comisión">
		<cfset labels="Comisiones">
	</cfif>
<table width="100%" border="0" cellspacing="6">
		<tr>
			<td width="50%" valign="top">
			<form name="formFiltro" method="post" action="<cfoutput>#Attributes.IrA#</cfoutput>" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
<!--------------------FILTRO DE CENTRO FUNCIONAL--->
			<td nowrap align="right"><strong>Centro Funcional:</strong></td>
			<td nowrap>	
					<cf_cboCFid form="formFiltro" todos="yes">
					<cfset form.CFid_F = session.Tesoreria.CFid>
			</td>
<!---------------------FILTRO DE SOLICITANTE                                        --->				
			<td nowrap align="right"><strong>Solicitante:</strong></td>
			<td colspan="2">
					<cfif form.UsucodigoSP_F EQ "">
						<cf_sifusuario conlis="true" size="20" form="formFiltro" >			
					<cfelse>
                    	<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select u.Usucodigo, u.Usulogin
								, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
							  from Usuario u 
								inner join DatosPersonales dp
								   on dp.datos_personales = u.datos_personales
							 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
						</cfquery>
						<cf_sifusuario conlis="true" size="20" form="formFiltro" query="#rsSQL#" readonly="#Attributes.PorEmpleado#">
					</cfif>
			</td>
		</tr>										
		<tr>
<!-------------------FILTRO DE EMPLEADO--->
			<td nowrap align="right"><strong>Empleado:</strong></td>
			<td nowrap>	
			<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
				<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#">
			<cfelse>
				<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
				</cfif>
				
			</td>			
<!-------------------FILTRO DE FECHA--->				
			<td nowrap align="right"><strong>Fecha:</strong></td>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" border="0">
					  <tr>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	</td>
						<td nowrap align="right" valign="middle"><strong>&nbsp;Hasta:</strong></td>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						</td>
					  </tr>
					</table>
			</td>
		</tr>		
		<tr>
<!-----------------FILTRO DE NU. ANTICIPO o LIQUIDACIÓN--->
			<td nowrap align="right"><strong><cfoutput>Num.#label#:</cfoutput></strong></td>
			<td nowrap>
				<input type="text" name="numAnti" />
			</td>							
<!-----------------FILTRO DE MONEDA--->				
			<td nowrap align="right"><strong>Moneda</strong></td>
			<td colspan="2">
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						  from Monedas m 
						  where m.Ecodigo = #session.Ecodigo#
					</cfquery>	
					<select name="McodigoOri_F" tabindex="1" onchange="this.form.submit();">
						<option value="">(Todas las monedas)</option>
						<cfoutput query="rsMonedas">
						<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>	
			</td>
		</tr>
		<cfif LvarSAporComision>
		<tr>
<!-----------------FILTRO DE NUMERO COMISION--->
			<td nowrap align="right"><strong><cfoutput>Num.Comisión:</cfoutput></strong></td>
			<td nowrap>
				<input type="text" name="numComision" />
			</td>
		</tr>
		</cfif>
<!-----------------FILTRAR--->		
		<tr>
			<td ></td>
			<td ><div align="right">
			         <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" />				   
	             </div>
			</td>
		</tr>
		</table>
<!-----------------FILTRO ANTICIPOS CANCELADOS--->	
			<cfif #Attributes.ListarCancelados#>
				<input type="checkbox" name="chkCancelados"
				<cfif isdefined("form.chkCancelados")>checked</cfif>
				onclick="this.form.submit();"
				tabindex="1"
				> Listar <cfoutput><!---#labels#---></cfoutput> Cancelados
			</cfif>
				<cfset LvarPrimera = false>				
		</form>
		<cfif FALSE AND LvarPrimera>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" bgcolor="#CCCCCC">
					<strong>La lista no ha sido filtrada</strong><BR>
					Asegúrese de que haya seleccionado los filtros adecuados antes de presionar <strong>Filtrar</strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			<cfabort>
		<cfelse>
			<cfif isdefined("form.chkCancelados")>
				<cfset LvarMSGrechazo = "Motivo<br>Cancelación">
			<cfelseif Attributes.Tipo NEQ "">
				<cfset LvarMSGrechazo = "Motivo<br>Rechazo<BR>Anterior">
			<cfelse>
				<cfset LvarMSGrechazo = "Motivo<br>Rechazo">
			</cfif>
			<cfif Attributes.AprobacionL>
				<cfset LvarAprobarCHK="S">
				<cfset LvarAprobarBTN="Aprobar">
			<cfelse>
				<cfset LvarAprobarCHK="N">
				<cfset LvarAprobarBTN="">
			</cfif>

			<cfif #Attributes.Tipo# EQ 6><!---Anticipos--->
						<cfinclude template="QuerryAE.cfm">
			<cfelseif Attributes.Tipo EQ 7><!---Liquidaciones--->
						<cfinclude template="QuerryLE.cfm">
			<cfelseif #Attributes.Tipo# EQ 8><!---Todas--->
						<cfinclude template="QueryERDoc.cfm">
			<cfelseif Attributes.Tipo EQ 9> <!---Transacciones de Usuario--->
						<cfinclude template="QuerryTrans_Proceso.cfm">
			<cfelseif #Attributes.Tipo# EQ 16><!---Anticipos Comision--->
						<cfinclude template="QuerryAE.cfm">
			<cfelseif Attributes.Tipo EQ 17><!---Liquidaciones Comision--->
						<cfinclude template="QuerryLE.cfm">
			<cfelse>
				<cfoutput><div align="center">Aun no hay una lista implementada para el tipo #Attributes.Tipo#</div></cfoutput>
			</cfif>		
		</cfif>
	</td>
  </tr>
</table>

<iframe name="ifrDescripcion" id="ifrDescripcion" src="" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" >
</iframe>
<script language="javascript">
	function sbVer(TESSPid)
	{
		var LvarIframe = document.getElementById("ifrDescripcion");
		<cfoutput>
		LvarIframe.src = "#Attributes.IrA#?sbVer=1&SP=" + TESSPid;
		</cfoutput>
		document.lista.nosubmit = true;		
	}
<cfif Attributes.AprobacionL>
	function funcAprobar()
	{
		if (!confirm("¿Desea Aprobar las solicitudes seleccionadas?"))
		{
			document.lista.nosubmit = false;
			return false;
		}
	}
</cfif>
</script>




