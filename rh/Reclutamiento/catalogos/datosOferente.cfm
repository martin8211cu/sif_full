<style type="text/css">
	.otroIdioma select { margin-right: 125px; }
</style>

<cfif isdefined("url.sel")>
	<cfset form.sel = url.sel>
</cfif>

<cfif isdefined("url.modo")>
	<cfset form.modo = url.modo>
</cfif>


<cfif isdefined("Form.Cambio") or isdefined('form.RHOid') and LEN(form.RHOid) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsAplicaRenta" datasource="#Session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 250
</cfquery>

<cfquery name="rsMonedaPRT" datasource="#Session.DSN#">
	select Miso4217,Miso4217 as Mnombre  from Moneda
</cfquery>
<cfquery name="rsMonedaLOC" datasource="#Session.DSN#">
	select Miso4217  from Monedas a
	inner join Empresa b
		on a. Mcodigo = b. Mcodigo
		and a.Ecodigo = b.Ecodigo
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfif rsAplicaRenta.recordCount GT 0>
	<cfset AplicaRenta = rsAplicaRenta.Pvalor>
<cfelse>
	<cfset AplicaRenta = "0">
</cfif>

<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
<cfquery name="rsIdiomas" datasource="#session.DSN#">
	select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
	from RHIdiomas
	order by RHDescripcion asc
</cfquery>

<cfif modo EQ "CAMBIO" and isdefined('form.RHOid') and LEN(form.RHOid) GT 0> 
	<cfquery datasource="#Session.DSN#" name="rsOferente">
		select a.RHOid, a.Ecodigo, a.NTIcodigo, a.RHOidentificacion, a.RHOnombre, a.RHOapellido1, a.RHOapellido2, a.RHOsexo, 
				a.RHOdireccion, a.RHOcivil, a.RHOtelefono1, a.RHOtelefono2, a.RHOemail, a.RHOfechanac, a.RHOobs1, a.RHOobs2, a.RHOobs3,
				a.RHOdato1, a.RHOdato2, a.RHOdato3, a.RHOdato4, a.RHOdato5, a.RHOinfo1, a.RHOinfo2, a.RHOinfo3,
				b.NTIdescripcion, a.ts_rversion, a.Ppais, a.id_direccion, a.RHORefValida, a.RHOfechaRecep,
				a.RHOfechaIngr, a.RHOPrenteInf, a.RHOPrenteSup, a.RHOPosViajar, a.RHOPosTralado, 
				a.RHOLengOral1, a.RHOLengOral2, a.RHOLengOral3, a.RHOLengOral4, a.RHOLengOral5, 
				a.RHOLengEscr1, a.RHOLengEscr2, a.RHOLengEscr3, a.RHOLengEscr4, a.RHOLengEscr5, 
				a.RHOLengLect1, a.RHOLengLect2, a.RHOLengLect3, a.RHOLengLect4, a.RHOLengLect5, 
				a.RHOIdioma1, a.RHOIdioma2, a.RHOIdioma3, a.RHOIdioma4, a.RHOOtroIdioma5, 
				a.RHOMonedaPrt, a.RHOEntrevistado, a.RHOfechaEntrevista, a.RHORealizadaPor 
		from DatosOferentes a 
		  inner join NTipoIdentificacion b
		    on  a.NTIcodigo = b.NTIcodigo
			and b.Ecodigo = #Session.Ecodigo#
		where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
		<cfif Session.cache_empresarial EQ 0>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfif>
		
		
	</cfquery>
	<!--- Buscar Usuario según Referencia 
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset datos_usuario = sec.getUsuarioByRef(Form.RHOid, Session.EcodigoSDC, 'DatosOferentes')>
	<cfset tieneUsuarioTemporal = (datos_usuario.recordCount GT 0 and datos_usuario.Estado EQ 1)>--->
</cfif>
<cf_translatedata name="get" tabla="RHEtiquetasOferente" col="RHEtiqueta" returnvariable="lvarRHEtiqueta">
<cfquery name="rsEtiquetasOferente" datasource="#Session.DSN#">
	select RHEcol,
		  #lvarRHEtiqueta# as  RHEtiqueta,
		   RHrequerido
	from RHEtiquetasOferente
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHdisplay = 1
	and RHEcol like 'RHO%'
</cfquery>

<cfquery name="rsEtiquetasDatos" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasOferente
	where RHEcol like 'RHOdato%'
</cfquery>

<cfquery name="rsEtiquetasObs" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasOferente
	where RHEcol like 'RHOobs%'
</cfquery>

<cfquery name="rsEtiquetasInfo" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasOferente
	where RHEcol like 'RHOinfo%'
</cfquery>

<cf_translatedata name="get" tabla="NTipoIdentificacion" col="NTIdescripcion" returnvariable="lvarNTIdescripcion">
<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, #lvarNTIdescripcion# as NTIdescripcion
	from NTipoIdentificacion
	where Ecodigo = #Session.Ecodigo#
	order by NTIdescripcion
</cfquery>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsPais" datasource="asp">
select Ppais, Pnombre 
from Pais
</cfquery>
<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>

<table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
	<tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
    	<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
	  	<cfif modo EQ 'CAMBIO' and isdefined('form.RHOid') and LEN(form.RHOid) GT 0>
			<table width="100%" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="center">
				  <cfinclude template="/rh/Reclutamiento/catalogos/frame-foto.cfm">
				</td>
			  </tr>
			</table>
		</cfif>
      	</td>
		<td  valign="top" nowrap > 
			<form method="post" enctype="multipart/form-data" name="formDatosOferente" action="SQLdatosOferente.cfm">
				<input type="hidden" name="RHOid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOid#</cfoutput></cfif>">
				<cfif isdefined("Form.Regcon")>
				<input type="hidden" name="RHCconcurso" value="<cfoutput>#form.RHCconcurso#</cfoutput>">
				<input type="hidden" name="RegCon" value="<cfoutput>#form.regcon#</cfoutput>">
				</cfif>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsOferente.ts_rversion#" returnvariable="ts"></cfinvoke>
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
				</cfif>				
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				
					<tr> 
						<td colspan="3" bgcolor="#CCCCCC" align="center" style="padding-left: 5px;"><strong><cf_translate key="LB_DatosGenerales">Datos Generales</cf_translate></strong></td>
					</tr>
				
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_PrimerApellido">Primer Apellido</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_SegundoApellido">Segundo Apellido</cf_translate></td>
					</tr>
					<tr> 
						<td>
							<input name="RHOnombre" type="text" id="RHOnombre2" size="40" maxlength="100" 
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOnombre#</cfoutput></cfif>">
						</td>
						<td>
							<input name="RHOapellido1" type="text" id="RHOapellido12" size="40" maxlength="80" 
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOapellido1#</cfoutput></cfif>">
						</td>
						<td>
							<input name="RHOapellido2" type="text" id="RHOapellido22" size="40" maxlength="80" 
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOapellido2#</cfoutput></cfif>">
						</td>
					</tr>
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_TipoDeIdentificacion">Tipo de Identificaci&oacute;n</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
						<td class="fileLabel">
							<cfif Session.Params.ModoDespliegue EQ 1>
							  <cf_translate key="LB_RutaDeLaFoto">Ruta de la foto</cf_translate>
							<cfelse>
							  &nbsp;
							</cfif>
						</td>
					</tr>
					<tr> 
						<td>
							<select name="NTIcodigo" id="select">
							<cfoutput query="rsTipoIdent">
							  <option 
							  	value="#rsTipoIdent.NTIcodigo#" 
								<cfif modo NEQ 'ALTA' and rsOferente.NTIcodigo EQ rsTipoIdent.NTIcodigo> selected</cfif>>
								#rsTipoIdent.NTIdescripcion#</option>
							</cfoutput>
							</select>
						</td>
						<td>
							<input name="RHOidentificacion" type="text" id="RHOidentificacion"  
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOidentificacion#</cfoutput></cfif>">
						</td>
						<td>
							<cfif Session.Params.ModoDespliegue EQ 1>
								<input name="rutaFoto" type="file" id="rutaFoto2">
							<cfelse>&nbsp;</cfif>
						</td>
					</tr>
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_FechaDeNacimiento">Fecha de Nacimiento</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_Sexo">Sexo</cf_translate></td>
					</tr>
					<tr> 
						<td>
							<select name="RHOcivil" id="RHOcivil">
							<option value="0" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 0> selected</cfif>><cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate></option>
							<option value="1" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 1> selected</cfif>><cf_translate key="CMB_CasadoA">Casado(a)</cf_translate></option>
							<option value="2" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 2> selected</cfif>><cf_translate key="CMB_DivorciadoA">Divorciado(a)</cf_translate></option>
							<option value="3" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 3> selected</cfif>><cf_translate key="CMB_ViudoA">Viudo(a)</cf_translate></option>
							<option value="4" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 4> selected</cfif>><cf_translate key="CMB_UnionLibre">Union Libre</cf_translate></option>
							<option value="5" <cfif modo NEQ 'ALTA' and rsOferente.RHOcivil EQ 5> selected</cfif>><cf_translate key="CMB_SeparadoA">Separado(a)</cf_translate></option>
							</select>
						</td>
						<td> 
							<cfif modo NEQ 'ALTA'>
								<cfset fecha = LSDateFormat(rsOferente.RHOfechanac, "DD/MM/YYYY")>
							<cfelse>
								<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
							</cfif>
							<cf_sifcalendario form="formDatosOferente" value="#fecha#" name="RHOfechanac">				   
						</td>
						<td>
							<select name="RHOsexo" id="select2">
							<option value="M" <cfif modo NEQ 'ALTA' and rsOferente.RHOsexo EQ 'M'> selected</cfif>><cf_translate key="CMB_Masculino">Masculino</cf_translate></option>
							<option value="F" <cfif modo NEQ 'ALTA' and rsOferente.RHOsexo EQ 'F'> selected</cfif>><cf_translate key="CMB_Femenino">Femenino</cf_translate></option>
							</select>
						</td>
					</tr>
					<!--- <tr>
						<td class="fileLabel"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></td>
						<td class="fileLabel">&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="3" class="fileLabel" align="left">
							<!--- <textarea name="RHOdireccion" id="RHOdireccion" rows="2" style="width: 100%;"><cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOdireccion#</cfoutput></cfif></textarea> --->
							<cf_direccion action="input" >							
						</td>
					</tr> --->
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_TelefonoDeResidencia">Tel&eacute;fono de Residencia</cf_translate> </td>
						<td class="fileLabel"><cf_translate key="LB_TelefonoCelular">Tel&eacute;fono Celular</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_DireccionElectronica">Direcci&oacute;n electr&oacute;nica</cf_translate></td>
					</tr>
					<tr> 
						<td>
							<input name="RHOtelefono1" type="text" id="RHOtelefono13"  
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOtelefono1#</cfoutput></cfif>" 
							size="30" maxlength="30">
						</td>
						<td>
							<input name="RHOtelefono2" type="text" id="RHOtelefono2"  
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOtelefono2#</cfoutput></cfif>" 
							size="30" maxlength="30">
						</td>
						<td>
							<input name="RHOemail" type="text" id="RHOemail"  
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHOemail#</cfoutput></cfif>" 
							size="40" maxlength="120">
						</td>
					</tr>
					<tr>
						<td class="fileLabel"><cf_translate key="LB_PaisDeNacimiento">Pa&iacute;s de Nacimiento</cf_translate></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="fileLabel">
							<select name="Ppais">
								<option value="">(<cf_translate key="CMB_SeleccioneUnPais">Seleccione un Pa&iacute;s</cf_translate>)</option>
								<cfoutput query="rsPais">
								<option value="#Ppais#"<cfif modo NEQ 'ALTA' and rsPais.Ppais EQ rsOferente.Ppais> selected</cfif>>
									#Pnombre#</option>
								</cfoutput>
							</select>
						</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="3" bgcolor="#CCCCCC" align="center" style="padding-left: 5px;"><strong><cf_translate key="LB_>Direccion">Direcci&oacute;n</cf_translate></strong></td>
					</tr>
					<tr>
						<td colspan="3" class="fileLabel" align="left">
							<cfif modo neq 'ALTA' and IsDefined('rsOferente.id_direccion') And Len(rsOferente.id_direccion)>
									<cf_direccion action="input" title="" key="#rsOferente.id_direccion#" >
							<cfelse>
									<cf_direccion title="" action="input">	
							</cfif>
							
													
						</td>
					</tr>
					
					<tr> 
						<td colspan="3" bgcolor="#CCCCCC" align="center" style="padding-left: 5px;"><strong><cf_translate key="LB_Otros">Otros</cf_translate></strong></td>
					</tr>
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_FechaRecepcionCurriculum">Fecha Recepci&oacute;n Curr&iacute;culum</cf_translate> </td>
						<td class="fileLabel" colspan="2"><cf_translate key="LB_FechaIngresoCurriculum">Fecha Ingreso Curr&iacute;culum</cf_translate> </td>
					</tr>
					<tr>
						<td> 
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario form="formDatosOferente" value="#LSDateFormat(rsOferente.RHOfechaRecep, "DD/MM/YYYY")#" name="RHOfechaRecep">	
							<cfelse>
								<cf_sifcalendario form="formDatosOferente" value="" name="RHOfechaRecep">	
							</cfif>
						</td>
						<td  colspan="2"> 
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario form="formDatosOferente" value="#LSDateFormat(rsOferente.RHOfechaIngr, "DD/MM/YYYY")#" name="RHOfechaIngr">	
							<cfelse>
								<cf_sifcalendario form="formDatosOferente" value="" name="RHOfechaIngr">	
							</cfif>			   
						</td>
					</tr>
					<tr> 
						<td class="fileLabel"><cf_translate key="LB_AspiracionSalarial">Aspiraci&oacute;n salarial</cf_translate> </td>
						<td class="fileLabel" ><cf_translate key="LB_Inferior">Inferior</cf_translate> </td>
						<td class="fileLabel"><cf_translate key="LB_Superior">Superior</cf_translate> </td>

					</tr>
					<tr>
						<td class="fileLabel">
							<select name="RHOMonedaPrt">
								<cfloop query="rsMonedaPRT">
								<option value="<cfoutput>#rsMonedaPRT.Miso4217#</cfoutput>"
									<cfif      modo NEQ 'ALTA' and rsMonedaPRT.Miso4217 EQ rsOferente.RHOMonedaPrt> selected
									<cfelseif  modo EQ 'ALTA'  and rsMonedaPRT.Miso4217 EQ rsMonedaLOC.Miso4217 > selected									
									</cfif>>
									<cfoutput>#rsMonedaPRT.Mnombre#</cfoutput></option>
								</cfloop>
							</select>
						</td>
						<td>
							<input 
								name="RHOPrenteInf" 
								type="text" 
								id="RHOPrenteInf"  
								style="text-align: right;" 
								onBlur="javascript: fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								
								value="<cfif modo NEQ 'ALTA'><cfoutput>#LSNumberFormat(rsOferente.RHOPrenteInf,',.00')#</cfoutput><cfelse>0.00</cfif>">
						</td>
						<td>
							<input 
								name="RHOPrenteSup" 
								type="text" 
								id="RHOPrenteSup"  
								style="text-align: right;" 
								onBlur="javascript: fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								
								value="<cfif modo NEQ 'ALTA'><cfoutput>#LSNumberFormat(rsOferente.RHOPrenteSup,',.00')#</cfoutput><cfelse>0.00</cfif>">
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<fieldset><legend><cf_translate key="LB_Idiomas">Idiomas</cf_translate></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
										<td class="fileLabel"><cf_translate key="LB_Idioma">Idioma</cf_translate> </td>
										<td class="fileLabel" ><cf_translate key="LB_DominioConversacional">Dominio Conversacional</cf_translate> </td>
										<td class="fileLabel"><cf_translate key="LB_DominioEscrito">Dominio Escrito</cf_translate> </td>
										<td class="fileLabel"><cf_translate key="LB_DominioLectura">Dominio Lectura</cf_translate> </td>
									</tr>	
									<tr> 
										<td>
											<select class="sIdioma" name="RHOIdioma1" onchange="fnChangeIdioma(this)">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option> 
												<cfloop query="rsIdiomas">
													<option value="<cfoutput>#RHIid#</cfoutput>" <cfif modo NEQ 'ALTA' and isdefined('rsOferente') and rsOferente.RHOIdioma1 eq RHIid>selected</cfif> ><cfoutput>#RHDescripcion#</cfoutput></option>
												</cfloop>			
											</select>
										</td>
										<td> 
											<select name="RHOLengOral1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengOral1>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengOral1>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengOral1>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengOral1>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengOral1>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengOral1>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengOral1>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengOral1>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengOral1>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengOral1>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengOral1>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengEscr1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengEscr1>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengEscr1>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengEscr1>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengEscr1>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengEscr1>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengEscr1>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengEscr1>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengEscr1>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengEscr1>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengEscr1>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengEscr1>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengLect1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengLect1>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengLect1>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengLect1>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengLect1>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengLect1>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengLect1>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengLect1>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengLect1>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengLect1>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengLect1>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengLect1>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
									</tr>
									<tr> 
										<td>
											<select class="sIdioma" name="RHOIdioma2" onchange="fnChangeIdioma(this)">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<cfloop query="rsIdiomas">
													<option value="<cfoutput>#RHIid#</cfoutput>" <cfif modo NEQ 'ALTA' and rsOferente.RHOIdioma2 eq RHIid>selected</cfif> ><cfoutput>#RHDescripcion#</cfoutput></option>
												</cfloop>	
											</select>
										</td>
										<td> 
											<select name="RHOLengOral2">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengOral2>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengOral2>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengOral2>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengOral2>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengOral2>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengOral2>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengOral2>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengOral2>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengOral2>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengOral2>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengOral2>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengEscr2">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengEscr2>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengEscr2>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengEscr2>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengEscr2>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengEscr2>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengEscr2>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengEscr2>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengEscr2>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengEscr2>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengEscr2>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengEscr2>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengLect2">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengLect2>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengLect2>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengLect2>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengLect2>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengLect2>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengLect2>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengLect2>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengLect2>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengLect2>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengLect2>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengLect2>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
									</tr>
				
									<tr> 
										<td>
											<select class="sIdioma" name="RHOIdioma3" onchange="fnChangeIdioma(this)">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>										
												<cfloop query="rsIdiomas">
													<option value="<cfoutput>#RHIid#</cfoutput>" <cfif modo NEQ 'ALTA' and rsOferente.RHOIdioma3 eq RHIid>selected</cfif> ><cfoutput>#RHDescripcion#</cfoutput></option>
												</cfloop>		
											</select>
										</td>
										<td> 
											<select name="RHOLengOral3">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>	
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengOral3>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengOral3>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengOral3>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengOral3>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengOral3>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengOral3>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengOral3>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengOral3>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengOral3>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengOral3>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengOral3>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengEscr3">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengEscr3>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengEscr3>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengEscr3>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengEscr3>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengEscr3>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengEscr3>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengEscr3>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengEscr3>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengEscr3>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengEscr3>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengEscr3>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengLect3">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengLect3>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengLect3>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengLect3>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengLect3>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengLect3>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengLect3>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengLect3>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengLect3>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengLect3>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengLect3>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengLect3>selected</cfif>>Lengua materna</option>
											</select>						
										</td>										
									</tr>									
									<tr> 
										<td>
											<select class="sIdioma" name="RHOIdioma4" onchange="fnChangeIdioma(this)">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<cfloop query="rsIdiomas">
													<option value="<cfoutput>#RHIid#</cfoutput>" <cfif modo NEQ 'ALTA' and rsOferente.RHOIdioma4 eq RHIid>selected</cfif> ><cfoutput>#RHDescripcion#</cfoutput></option>
												</cfloop>		
											</select>
										</td>		 				
										<td> 
											<select name="RHOLengOral4">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>	
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengOral4>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengOral4>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengOral4>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengOral4>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengOral4>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengOral4>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengOral4>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengOral4>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengOral4>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengOral4>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengOral4>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengEscr4">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengEscr4>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengEscr4>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengEscr4>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengEscr4>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengEscr4>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengEscr4>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengEscr4>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengEscr4>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengEscr4>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengEscr4>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengEscr4>selected</cfif>>Lengua materna</option>
											</select>						
										</td>
										<td>
											<select name="RHOLengLect4">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   modo NEQ 'ALTA' and 10 EQ rsOferente.RHOLengLect4>selected</cfif>>10%</option>
												<option value="20"  <cfif   modo NEQ 'ALTA' and 20 EQ rsOferente.RHOLengLect4>selected</cfif>>20%</option>
												<option value="30"  <cfif   modo NEQ 'ALTA' and 30 EQ rsOferente.RHOLengLect4>selected</cfif>>30%</option>
												<option value="40"  <cfif   modo NEQ 'ALTA' and 40 EQ rsOferente.RHOLengLect4>selected</cfif>>40%</option>
												<option value="50"  <cfif   modo NEQ 'ALTA' and 50 EQ rsOferente.RHOLengLect4>selected</cfif>>50%</option>
												<option value="60"  <cfif   modo NEQ 'ALTA' and 60 EQ rsOferente.RHOLengLect4>selected</cfif>>60%</option>
												<option value="70"  <cfif   modo NEQ 'ALTA' and 70 EQ rsOferente.RHOLengLect4>selected</cfif>>70%</option>
												<option value="80"  <cfif   modo NEQ 'ALTA' and 80 EQ rsOferente.RHOLengLect4>selected</cfif>>80%</option>
												<option value="90"  <cfif   modo NEQ 'ALTA' and 90 EQ rsOferente.RHOLengLect4>selected</cfif>>90%</option>
												<option value="100" <cfif   modo NEQ 'ALTA' and 100 EQ rsOferente.RHOLengLect4>selected</cfif>>100%</option>
												<option value="105" <cfif   modo NEQ 'ALTA' and 105 EQ rsOferente.RHOLengLect4>selected</cfif>>Lengua materna</option>
											</select>						
										</td>										
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>			
					<tr>
						<td colspan="1">
							<input alt="0" style="font-size:10px" tabindex="1" name="RHIOtro" type="checkbox" id="RHIOtro" value="0" onclick="fnShowOtroIdioma()"><cf_translate key="LB_Otro" xmlFile="generales.xml">Otro</cf_translate>
							<cfset vRHOOtroIdioma5 = "" >
							<cfif isdefined("rsOferente.RHOOtroIdioma5") >
								<cfset vRHOOtroIdioma5 = rsOferente.RHOOtroIdioma5 >
							</cfif> 
							<input class="otroIdioma sIdioma" type="text" name="RHOOtroIdioma5" maxlength="80" size="15" value="<cfoutput>#vRHOOtroIdioma5#</cfoutput>"<cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>>
						</td>		
						<td colspan="2" class="otroIdioma"<cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>>
							<select name="RHOLengOral5" style="font-size:10px" tabindex="1">
								<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
								<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral5") and 10 EQ rsOferente.RHOLengOral5>selected</cfif>>10%</option>
								<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral5") and 20 EQ rsOferente.RHOLengOral5>selected</cfif>>20%</option>
								<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral5") and 30 EQ rsOferente.RHOLengOral5>selected</cfif>>30%</option>
								<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral5") and 40 EQ rsOferente.RHOLengOral5>selected</cfif>>40%</option>
								<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral5") and 50 EQ rsOferente.RHOLengOral5>selected</cfif>>50%</option>
								<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral5") and 60 EQ rsOferente.RHOLengOral5>selected</cfif>>60%</option>
								<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral5") and 70 EQ rsOferente.RHOLengOral5>selected</cfif>>70%</option>
								<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral5") and 80 EQ rsOferente.RHOLengOral5>selected</cfif>>80%</option>
								<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral5") and 90 EQ rsOferente.RHOLengOral5>selected</cfif>>90%</option>
								<option value="100" <cfif   isdefined("rsOferente.RHOLengOral5") and 100 EQ rsOferente.RHOLengOral5>selected</cfif>>100%</option>
								<option value="105" <cfif   isdefined("rsOferente.RHOLengOral5") and 105 EQ rsOferente.RHOLengOral5>selected</cfif>>Lengua materna</option>
							</select>

							<select name="RHOLengEscr5" style="font-size:10px" tabindex="1">
								<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
								<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 10 EQ rsOferente.RHOLengEscr5>selected</cfif>>10%</option>
								<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 20 EQ rsOferente.RHOLengEscr5>selected</cfif>>20%</option>
								<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 30 EQ rsOferente.RHOLengEscr5>selected</cfif>>30%</option>
								<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 40 EQ rsOferente.RHOLengEscr5>selected</cfif>>40%</option>
								<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 50 EQ rsOferente.RHOLengEscr5>selected</cfif>>50%</option>
								<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 60 EQ rsOferente.RHOLengEscr5>selected</cfif>>60%</option>
								<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 70 EQ rsOferente.RHOLengEscr5>selected</cfif>>70%</option>
								<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 80 EQ rsOferente.RHOLengEscr5>selected</cfif>>80%</option>
								<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 90 EQ rsOferente.RHOLengEscr5>selected</cfif>>90%</option>
								<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr5") and 100 EQ rsOferente.RHOLengEscr5>selected</cfif>>100%</option>
								<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr5") and 105 EQ rsOferente.RHOLengEscr5>selected</cfif>>Lengua materna</option>
							</select>

							<select name="RHOLengLect5" style="font-size:10px" tabindex="1">
								<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
								<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect5") and 10 EQ rsOferente.RHOLengLect5>selected</cfif>>10%</option>
								<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect5") and 20 EQ rsOferente.RHOLengLect5>selected</cfif>>20%</option>
								<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect5") and 30 EQ rsOferente.RHOLengLect5>selected</cfif>>30%</option>
								<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect5") and 40 EQ rsOferente.RHOLengLect5>selected</cfif>>40%</option>
								<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect5") and 50 EQ rsOferente.RHOLengLect5>selected</cfif>>50%</option>
								<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect5") and 60 EQ rsOferente.RHOLengLect5>selected</cfif>>60%</option>
								<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect5") and 70 EQ rsOferente.RHOLengLect5>selected</cfif>>70%</option>
								<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect5") and 80 EQ rsOferente.RHOLengLect5>selected</cfif>>80%</option>
								<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect5") and 90 EQ rsOferente.RHOLengLect5>selected</cfif>>90%</option>
								<option value="100" <cfif   isdefined("rsOferente.RHOLengLect5") and 100 EQ rsOferente.RHOLengLect5>selected</cfif>>100%</option>
								<option value="105" <cfif   isdefined("rsOferente.RHOLengLect5") and 105 EQ rsOferente.RHOLengLect5>selected</cfif>>Lengua materna</option>

							</select>
						</td>	
					</tr>
					<tr>
						<td colspan="1">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="5%"><input alt="0" name="RHOPosViajar" type="checkbox" id="RHOPosViajar" value="0" <cfif modo NEQ "ALTA" and rsOferente.RHOPosViajar EQ 1>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></td>
								</tr>
							</table>
						</td>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="5%"><input alt="0" name="RHOPosTralado" type="checkbox" id="RHOPosTralado" value="0" <cfif modo NEQ "ALTA" and rsOferente.RHOPosTralado EQ 1>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr>
						<td colspan="1">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="5%"><input alt="0" name="RHORefValida" type="checkbox" id="RHORefValida" value="0" <cfif modo NEQ "ALTA" and rsOferente.RHORefValida EQ 1>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate></td>
								</tr>
							</table>
						</td>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="5%"><input alt="0"  onclick="javascript:activacampos();" name="RHOEntrevistado" type="checkbox" id="RHOEntrevistado" value="0" <cfif modo NEQ "ALTA" and rsOferente.RHOEntrevistado EQ 1>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_Entrevistado">Entrevistado(a)</cf_translate></td>
								</tr>
							</table>
						</td>
					</tr>	
					<tr id='TR_E1' style="display:none">
						<td class="fileLabel"><cf_translate key="LB_Fecha_de_la_entrevista">Fecha de la entrevista</cf_translate> </td>
						<td class="fileLabel" colspan="2"><cf_translate key="LB_Realizada_por">Realizada por</cf_translate> </td>
					</tr>				
					<tr id='TR_E2' style="display:none">
						<td> 
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario form="formDatosOferente" value="#LSDateFormat(rsOferente.RHOfechaEntrevista, "DD/MM/YYYY")#" name="RHOfechaEntrevista">	
							<cfelse>
								<cf_sifcalendario form="formDatosOferente" value="" name="RHOfechaEntrevista">	
							</cfif>
						</td>
						<td  colspan="2"> 
							<input name="RHORealizadaPor" type="text" id="RHORealizadaPor"  
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsOferente.RHORealizadaPor#</cfoutput></cfif>" 
							size="60" maxlength="100">
		   
						</td>
					</tr>					
					<tr><td colspan="3">&nbsp;</td></tr>	
					<tr> 
						<td colspan="3" align="center" bgcolor="#CCCCCC" style="padding-left: 5px;"><strong><cf_translate key="LB_DatosVariables">Datos Variables</cf_translate></strong></td>
					</tr>

					<tr> 
						<td colspan="3" align="center"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<cfif isdefined('rsEtiquetasOferente') and rsEtiquetasOferente.recordCount GT 0>
									<cfif  isdefined('rsEtiquetasDatos')>
										<cfset contReg = 0>
										<cfloop query="rsEtiquetasDatos">
											<!--- Campos Variables de Datos del empleado --->
											<cfset contReg = contReg + 1>
											<tr> 
												<td width="21%" nowrap class="fileLabel">
													<cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>:
												</td>
												<td width="79%"> 
													<cfoutput> 
													<input name="RHOdato#contReg#" onFocus="this.select()" type="text" 
													id="RHOdato#contReg#" 
													value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsOferente.#rsEtiquetasDatos.RHEcol#")#</cfoutput></cfif>" 
													size="30" maxlength="30">
													</cfoutput> 
												</td>
											</tr>
										</cfloop>
									</cfif>
									<cfif  isdefined('rsEtiquetasInfo')>
										<cfset contReg = 0>
										<cfloop query="rsEtiquetasInfo">
											<!--- Campos variables de informacion del empleado --->
											<cfset contReg = contReg + 1>
											<tr> 
												<td width="21%" nowrap class="fileLabel">
													<cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>:
												</td>
												<td width="79%"> 
													<cfoutput> 
													<input name="RHOinfo#contReg#" onFocus="this.select()" type="text" 
													id="RHOinfo#contReg#" 
													value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsOferente.#rsEtiquetasInfo.RHEcol#")#</cfoutput></cfif>" 
													size="100" maxlength="100">
													</cfoutput>
												</td>
										</tr>
										</cfloop>
									</cfif>				
									<cfif  isdefined('rsEtiquetasObs')>			
										<cfset contReg = 0>
										<cfloop query="rsEtiquetasObs">
											<!--- Campos variables de observaciones --->
											<cfset contReg = contReg + 1>
											<tr> 
												<td width="21%" nowrap class="fileLabel">
													<cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>:
												</td>
												<td width="79%"> 
													<cfoutput> 
													<input name="RHOobs#contReg#" onFocus="this.select()" type="text" 
													id="RHOobs#contReg#" 
													value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsOferente.#rsEtiquetasObs.RHEcol#")#</cfoutput></cfif>" 
													size="100" maxlength="255">
													</cfoutput>
												</td>
											</tr>
										</cfloop>
									</cfif>				
								</cfif>
							</table>
						</td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr > 
					 
						<cfif not isdefined("form.regcon")>
							 <td colspan="4" nowrap>
							 	<cf_botones modo = #modo# regresar="../../Reclutamiento/catalogos/lista-oferentes.cfm">
							</td>
						<cfelse>
							 <td colspan="2" nowrap>
							 	<cfset regresa=''>
							 	<cfset regresa = '/cfmx/rh/Reclutamiento/operacion/RegistroConcursantes.cfm?paso=1&TipoConcursante=E&RHCconcurso=' & #form.RHCconcurso#>
								<cf_botones modo = #modo# regresar="#regresa#">
							</td>
						</cfif>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
		</td>
	</tr>	
</table>
 <!--- VARIABLES DE TRADUCCION ---> 
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_la_entrevista"
	Default="Fecha de la entrevista"
	returnvariable="LB_Fecha_de_la_entrevista"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RealizadoPor"
	Default="Realizado por"
	returnvariable="LB_RealizadoPor"/>
 
 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeIdentificacion"
	Default="Tipo de Identificación"
	returnvariable="LB_TipoDeIdentificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EstadoCivil"
	Default="Estado Civil"
	returnvariable="LB_EstadoCivil"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeNacimieto"
	Default="Fecha de Nacimieto"
	returnvariable="LB_FechaDeNacimieto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sexo"
	Default="Sexo"
	returnvariable="LB_Sexo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_SelectPorcentajeDominioIdioma"
	default="Debe indicar el porcentaje de dominio oral, escrito y lectura sobre los idiomas seleccionados"
	xmlFile="/rh/generales.xml"
	returnvariable="MSG_SelectPorcentajeDominioIdioma"/>	
	
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">



fm(document.formDatosOferente.RHOPrenteInf,2);
fm(document.formDatosOferente.RHOPrenteSup,2);


//------------------------------------------------------------------------------------------
	arrNombreObjs = new Array();
	arrNombreEtiquetas = new Array();	
	
	//Objetos de los datos variables del empleado
	var cont = 0;
	<cfloop query="rsEtiquetasDatos">	
		cont++;	
		<cfif rsEtiquetasDatos.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'RHOdato' + cont;
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>';
		</cfif>
	</cfloop>
	var cont = 0;
	<cfloop query="rsEtiquetasObs">	
		cont++;
		<cfif rsEtiquetasObs.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'RHOobs' + cont;						
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>';		
		</cfif>
	</cfloop>
	var cont = 0;
	<cfloop query="rsEtiquetasInfo">	
		cont++;
		<cfif rsEtiquetasInfo.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'RHOinfo' + cont;				
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>';		
		</cfif>
	</cfloop>	
	
//------------------------------------------------------------------------------------------
	/*function funcRegresar(){
		var valor = document.formDatosOferente.RHCconcurso.value;
		alert(valor);
		deshabilitarValidacion();
		location.href ='/cfmx/rh/Reclutamiento/operacion/RegistroConcursantes.cfm?paso=1&RHCconcurso=' + valor;	
	}*/

//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		objForm.NTIcodigo.required = false;
		objForm.RHOidentificacion.required = false;
		objForm.RHOnombre.required = false;
		objForm.RHOcivil.required = false;
		objForm.RHOfechanac.required = false;
		objForm.RHOsexo.required = false;
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = false;");
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.NTIcodigo.required = true;
		objForm.RHOidentificacion.required = true;
		objForm.RHOnombre.required = true;
		objForm.RHOcivil.required = true;
		objForm.RHOfechanac.required = true;
		objForm.RHOsexo.required = true;	
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = true;");		
	}
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formDatosOferente");
	<cfoutput>
	objForm.RHOfechaEntrevista.required = false;
	objForm.RHOfechaEntrevista.description = "#LB_Fecha_de_la_entrevista#";	
	objForm.RHORealizadaPor.required = false;
	objForm.RHORealizadaPor.description = "#LB_RealizadoPor#";	


	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description = "#LB_TipoDeIdentificacion#";	
	objForm.RHOidentificacion.required = true;
	objForm.RHOidentificacion.description = "#LB_Identificacion#";
	objForm.RHOnombre.required = true;
	objForm.RHOnombre.description = "#LB_Nombre#";	
	objForm.RHOcivil.required = true;
	objForm.RHOcivil.description = "#LB_EstadoCivil#";			
	objForm.RHOfechanac.required = true;
	objForm.RHOfechanac.description = "#LB_FechaDeNacimieto#";				
	objForm.RHOsexo.required = true;
	objForm.RHOsexo.description = "#LB_Sexo#";
	</cfoutput>
	//Validacion de los datos variables por empresa
	for(var i=0;i<arrNombreObjs.length;i++){
		eval("objForm." + arrNombreObjs[i] + ".required = true;");
		eval("objForm." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");		
	}	
	
	function activacampos(){
		var TR_E1 = document.getElementById("TR_E1");
		var TR_E2 = document.getElementById("TR_E2");
		TR_E1.style.display = ((TR_E1.style.display == "none") ? "" : "none");
		TR_E2.style.display = ((TR_E2.style.display == "none") ? "" : "none");
		objForm.RHOfechaEntrevista.required = ((objForm.RHOfechaEntrevista.required == false) ? true : false);
		objForm.RHORealizadaPor.required    = ((objForm.RHORealizadaPor.required == false) ? true : false);		
		
	}
	
	if (document.formDatosOferente.RHOEntrevistado.checked ){
		var TR_E1 = document.getElementById("TR_E1");
		var TR_E2 = document.getElementById("TR_E2");
		TR_E1.style.display = "";
		TR_E2.style.display = "";
		objForm.RHOfechaEntrevista.required = true;
		objForm.RHORealizadaPor.required    = true;
	}
	else{
		var TR_E1 = document.getElementById("TR_E1");
		var TR_E2 = document.getElementById("TR_E2");
		TR_E1.style.display = "none";
		TR_E2.style.display = "none";
		objForm.RHOfechaEntrevista.required = false;
		objForm.RHORealizadaPor.required    = false;
	 
	}

	$( document ).ready(function() {
		<cfif len(vRHOOtroIdioma5) gt 0 >
			$('#RHIOtro').attr('checked',true);
		</cfif>	

		$('input.btnGuardar').click(function(e){
		    if(!fnValidaIdiomas())
		    	e.preventDefault();
		});
	});

	<cfoutput>
		function fnValidaIdiomas(){
			var result = false;
			var elements = $('.sIdioma');

			for(i=0; i<elements.length; i++){
				result = fnValidarElement(elements[i].name,i+1,'#MSG_SelectPorcentajeDominioIdioma#');
				if(!result)
					break;
			}
			return result;
		}
	</cfoutput>

	function fnValidarElement(e,val,showMsg){  
		var selector = '';
		if(val != 5)
			selector = 'select'; 
		else
			selector = 'input'; 
			
		if($(selector+'[name='+e+']').val().trim() != ''){ 
			if($('select[name=RHOLengOral'+val+']').val() == '' || $('select[name=RHOLengEscr'+val+']').val() == '' || $('select[name=RHOLengLect'+val+']').val() == ''){
				alert(showMsg);
				return false;
			}	
		}		
		else
			$(selector+'[name='+e+']').parent().siblings().children().val('');

		return true;
	}

	function fnChangeIdioma(e){
		if($('select[name='+e.name+']').val() == '')
			$('select[name='+e.name+']').parent().siblings().children().val('');
	}

	function fnShowOtroIdioma(){
		if($('#RHIOtro').is(':checked')) 
			$('.otroIdioma').delay(200).fadeIn(400);	
		else
			$('.otroIdioma').delay(200).fadeOut(400);
	}
							
</script>