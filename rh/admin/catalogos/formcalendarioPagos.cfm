<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Seleccionar" Default="Seleccionar" XmlFile="/rh/generales.xml" returnvariable="LB_seleccionar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Generar" Default="Generar" returnvariable="BTN_Generar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_filtrar" Default="Filtrar" XmlFile="/rh/generales.xml" returnvariable="BTN_filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Desde" Default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Hasta" Default="Hasta" returnvariable="LB_Hasta"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Pago" Default="Pago" returnvariable="LB_Pago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Tipo" Default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ConceptosDePago" Default="Conceptos de Pago" returnvariable="LB_ConceptosDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" XmlFile="/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TiposDeDeduccionAExcluir" Default="Tipos de Deducci&oacute;n a Excluir" returnvariable="LB_TiposDeDeduccionAExcluir" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TiposDeDeduccionAIncluir" Default="Tipos de Deducci&oacute;n a Incluir" returnvariable="LB_TiposDeDeduccionAIncluir" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_FechaDeInicioDeAnticipos" Default="Fecha de Inicio de Anticipos" returnvariable="MSG_FechaDeInicioDeAnticipos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AgregarMasivo" Default="Agregar Masivo" returnvariable="LB_AgregarMasivo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EstaSeguroQueDeseaExcluirTodasLasDeducciones" Default="Esta seguro que desea excluir todas las deducciones?" returnvariable="MSG_ExcluirDeducciones" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="MSG_existDeduc" Default="Existen Tipos de Deducci&oacute;n a excluir asociadas!\n" returnvariable="MSG_existDeduc" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="MSG_existCreditosFiscales" Default="Existen Cr&eacute;ditos Fiscales a excluir asociados!\n" returnvariable="MSG_existCreditosFiscales" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="MSG_existConceptos" Default="Existen Conceptos de Pago a excluir asociados!\n" returnvariable="MSG_existConceptos" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="MSG_existCargas" Default="Existen Cargas a excluir asociadas!\n" returnvariable="MSG_existCargas" component="sif.Componentes.Translate" method="Translate"/>



<!--- FIN VARIABLES DE TRADUCCION --->

<!--- Creación de Filtro y Navegacion --->
<cfif isDefined("url.fCPdesde") and not isDefined("form.fCPdesde")>
	<cfset form.fCPdesde = url.fCPdesde>
</cfif>
<cfif isDefined("url.fCPhasta") and not isDefined("form.fCPhasta")>
	<cfset form.fCPhasta = url.fCPhasta>
</cfif>
<cfif isDefined("url.fCPfpago") and not isDefined("form.fCPfpago")>
	<cfset form.fCPfpago = url.fCPfpago>
</cfif>
<cfif isDefined("url.fCPcodigo") and not isDefined("form.fCPcodigo")>
	<cfset form.fCPcodigo = url.fCPcodigo>
</cfif>
<cfif isDefined("url.f_estado") and not isDefined("form.f_estado")>
	<cfset form.f_estado = url.f_estado >
</cfif>
<cfif isDefined("url.f_tipo") and not isDefined("form.f_tipo")>
	<cfset form.f_tipo = url.f_tipo >
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset campos_adicionales = "">
<cfif isdefined("form.fCPdesde") and Len(Trim(form.fCPdesde)) NEQ 0>
	<cfset filtro = filtro & " and CPdesde >= " & lsparsedatetime(form.fCPdesde) & "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCPdesde=" & form.fCPdesde>
	<cfset campos_adicionales = campos_adicionales & ",'#form.fCPdesde#' as fCPdesde">	
</cfif>
<cfif isdefined("form.fCPhasta") and Len(Trim(form.fCPhasta)) NEQ 0>
	<cfset filtro = filtro & " and CPhasta <= " & lsparsedatetime(form.fCPhasta) & "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCPhasta=" & form.fCPhasta>
	<cfset campos_adicionales = campos_adicionales & ",'#form.fCPhasta#' as fCPhasta">	
</cfif>
<cfif isdefined("form.fCPfpago") and Len(Trim(form.fCPfpago)) NEQ 0>
	<cfset filtro = filtro & " and CPfpago = " & lsparsedatetime(form.fCPfpago) & "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCPfpago=" & form.fCPfpago>
	<cfset campos_adicionales = campos_adicionales & ",'#form.fCPfpago#' as fCPfpago">	
</cfif>
<cfif isdefined("form.fCPcodigo") and Len(Trim(form.fCPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and CPcodigo like '%" & Trim(form.fCPcodigo) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCPcodigo=" & form.fCPcodigo>
	<cfset campos_adicionales = campos_adicionales & ",'#form.fCPcodigo#' as fCPcodigo">	
</cfif>
<cfif isdefined("form.f_estado") and Len(Trim(form.f_estado)) NEQ 0>
	<cfset filtro2 = '( select 1 from HRCalculoNomina where RCNid = CalendarioPagos.CPid )'  >
	<cfif form.f_estado eq 1 >
		<cfset filtro = filtro & ' and not exists #filtro2#' >
	<cfelseif form.f_estado eq 2 >
		<cfset filtro = filtro & ' and exists #filtro2#' > 	
	</cfif>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_estado=" & form.f_estado>
	<cfset campos_adicionales = campos_adicionales & ",'#form.f_estado#' as f_estado">	
</cfif>
<cfif isdefined("form.f_tipo") and Len(Trim(form.f_tipo)) NEQ 0>
	<cfset filtro = filtro & " and CPtipo = #form.f_tipo#" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_tipo=" & form.f_tipo>
	<cfset campos_adicionales = campos_adicionales & ",'#form.f_tipo#' as f_tipo">		
</cfif>

<!--- Definición del Modo --->
<cfif isdefined("form.CPid") and len(trim(form.CPid)) gt 0 and isdefined("form.Tcodigo") and len(trim(form.Tcodigo)) gt 0>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("Form.Cambio")>
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

<!--- Consultas --->
<cfquery name="rsTipoNomina" datasource="#Session.DSN#">
	select 
		Tcodigo,
		Tdescripcion,
		Ttipopago as CodTipoPago,
		case
			when Ttipopago=0 then 'Semanal'
			when Ttipopago=1 then 'Bisemanal'
			when Ttipopago=2 then 'Quincenal'
			when Ttipopago=3 then 'Mensual'
		end Ttipopago
	from TiposNomina
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and rtrim (Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsCalenPago" datasource="#Session.DSN#">
		select 	CPid,
				CPdesde,
				CPhasta,
				CPfpago,
				rtrim(CPcodigo) as CPcodigo,
				CPperiodo,
				CPdescripcion,
				CPtipo,
				CPmes,
				CPnorenta,
				CPnocargasley,
				CPnocargas,
				CPnodeducciones,
				CPfcalculo,
                CPTipoCalRenta,
                IRcodigo,
				CPesUltimaSemana
		from CalendarioPagos
		where CPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	</cfquery>
    
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select a.CPid, b.CIid, c.CIcodigo, c.CIdescripcion
		from CalendarioPagos a
        	inner join CCalendario b
            	on b.CPid  = a.CPid
            inner join CIncidentes c
            	on c.CIid = b.CIid
		where a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.CPid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(form.Tcodigo)#">
	</cfquery>

	<!--- Tipos de Deducción --->
	<cfquery name="rsTiposDeduccion" datasource="#Session.DSN#">
		select a.CPid, b.TDid, c.TDdescripcion 
		from CalendarioPagos a
        	inner join TDCalendario b
            	on b.CPid = a.CPid
            inner join TDeduccion c
            	on c.TDid = b.TDid
		where a.Ecodigo        = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.CPid           = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(form.Tcodigo)#">
	</cfquery>											
</cfif>

<cfquery name="rsNumCalenPago" datasource="#Session.DSN#">
	Select CPhasta as PChasta
	from CalendarioPagos
	where CPhasta = (
		select Max(CPhasta) 
		from CalendarioPagos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
		and CPtipo = 0
	)
	and CPtipo = 0
	and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
</cfquery>

<cfif not isdefined('rsNumCalenPago') OR rsNumCalenPago.RecordCount EQ 0>
<!---	<cfset modo = 'ALTA'>---> <!--- 2011-06-15 LZ.
								Si Solo hay CalendariosEspeciales el modo Alta no permite modificar el Calendario (caso CEFA) y analizandolo la consulta esta hecha para que se proponga el CPhasta Masivo
							Así que se elimina y se indica la condicion de CPhasta=ninguno. --->
	<cfset PChasta= "">							
<cfelse>
	<cfset PChasta = DateAdd('d',1,rsNumCalenPago.PChasta)>
</cfif>

<cfquery name="rsCPcodigos" datasource="#Session.DSN#">
	select rtrim(CPcodigo) as CPcodigo from CalendarioPagos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and rtrim(Tcodigo)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
</cfquery>

<!---SE VERIFICA SI USA ESTRUCTURA SALARIAL--->
<cfquery name="rsEstructura" datasource="#session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 	  and CSsalariobase = 1
</cfquery>

<cfset usaEstructuraSalarial = false>
<cfif rsEstructura.recordCount and rsEstructura.CSusatabla EQ 1>
	<cfset usaEstructuraSalarial = true>
</cfif>

<cfset CalculaPTU = false>
<cfquery name="rsPTU" datasource="#session.DSN#">
	select Pvalor
    from RHParametros
    where Ecodigo = #session.Ecodigo#
    and Pcodigo = 2025
</cfquery>


<cfif rsPTU.recordCount gt 0 and rsPTU.Pvalor eq 1>
	<cfset CalculaPTU = true>
</cfif>

<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript1.2" type="text/javascript">
	//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cf_templatecss>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="2">
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabContent">
				<tr> 
					<td colspan="6" align="center" class="subTitulo"><cf_translate   key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>			
				<tr> 
					<td width="7%" nowrap class="fileLabel">#LB_CODIGO#</td>
					<td width="22%">#rsTipoNomina.Tcodigo#</td>
					<td width="8%" nowrap class="fileLabel">#LB_DESCRIPCION#</td>
					<td width="29%">#rsTipoNomina.Tdescripcion#</td>
					<td width="13%" nowrap class="fileLabel"><cf_translate   key="LB_TipoDePago">Tipo de Pago</cf_translate></td>
					<td width="21%">#rsTipoNomina.Ttipopago#</td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>
			</table>	
		</cfoutput>
		</td>
	</tr>
	
	<tr>
		<td colspan="2"> 
			<form name="formGenerar" id="formGenerar" method="post" action="SQLcalendarioPagos.cfm" onSubmit="return confirmacion(this);">
				<input type="hidden" name="Tcodigo" 		id="Tcodigo" 		value="<cfif isdefined('form.Tcodigo')><cfoutput>#form.Tcodigo#</cfoutput></cfif>">		
				<input type="hidden" name="CodTipoPago" 	id="CodTipoPago" 	value="<cfif isdefined('rsTipoNomina')><cfoutput>#rsTipoNomina.CodTipoPago#</cfoutput></cfif>">
				<input type="hidden" name="ultFechaHasta" 	id="ultFechaHasta" 	value="<cfif isdefined('rsNumCalenPago') and rsNumCalenPago.recordCount GT 0><cfoutput>#PChasta#</cfoutput></cfif>"><!--- SE ELIMINA EL   rsNumCalenPago --->
				<input type="hidden" name="LvarAnticipo" 	id="LvarAnticipo"	value="0" tabindex="-1">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabContent">
					<tr><td colspan="4" class="subTitulo"><cf_translate   key="LB_GeneracionAutomatica">Generaci&oacute;n autom&aacute;tica</cf_translate></td></tr>
					<tr>
						<td colspan="4">
							<table width="80%" cellpadding="0" cellspacing="0" border="0" align="center">
								<tr>
									<td width="20%" class="fileLabel"><cf_translate   key="LB_FechaDeInicio">Fecha de inicio</cf_translate></td>
									<td width="20%" class="fileLabel"><cf_translate   key="LB_CantidadDePeriodos">Cantidad de per&iacute;odos</cf_translate></td>
									<td width="15%" class="fileLabel">
										<input name="GenAnticipos" type="checkbox" tabindex="1" onclick="javascript: habilitaFecha(this);">
										<cf_translate key="LB_Anticipos">Anticipos</cf_translate>
									</td>
									<td width="30%" class="fileLabel">
										<div id='LabelfechaA' style="display:none"><cf_translate   key="LB_FechaInicioAnticipos">Fecha de Inicio para Anticipos</cf_translate></div>
									</td>
									<td width="15%">&nbsp;</td>
								</tr>
								<tr>
									<td> 
										<cfoutput>
										<cfif isdefined('rsNumCalenPago') and rsNumCalenPago.recordCount GT 0>
											<cfset fechaCPinicioGen=LSDateFormat(PChasta)> <!--- SE ELIMINA EL  rsNumCalenPago --->
											#fechaCPinicioGen#
											<input type="hidden" name="CPdesdeIni" id="CPdesdeIni" value="#fechaCPinicioGen#">
										<cfelse>
											<cfset fechaCPinicioGen = LSDateFormat(Now(), "DD/MM/YYYY")>					
											<cf_sifcalendario form="formGenerar" value="#fechaCPinicioGen#" name="CPdesdeIni">							
										</cfif>
										</cfoutput>					
									</td>
									<td>
										<input type="text" name="cantPer" value="" size="5" maxlength="3" onFocus="javascript:this.select()" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};" alt="Cantidad de periodos a generar autom&aacute;ticamente">
									</td>
									<td>&nbsp;</td>
									<td>
										<div id='fechaA' style="display:none"><cf_sifcalendario form="formGenerar" name="CPAdesdeIni"></div>
									</td>
									<td width="16%" rowspan="3" valign="bottom">
										<input name="Generar" class="btnAplicar" type="submit" id="Generar" value="<cfoutput>#BTN_Generar#</cfoutput>" onClick="javascript: document.formCalendarioPago.botonSel.value = this.name;">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
				</table>
			</form>	
		</td>
	</tr>	
</table>

<table width="99%" align="center" cellpadding="2" cellspacing="0"> <!--- Principal--->
	<tr> <!--- TR: principal --->
		<td valign="top"> <!--- Lista/filtro --->
			<table width="100%" cellpadding="0" cellspacing="0"> <!--- Tabla: filtro/lista--->
				<tr><!--- filtro --->
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro"> <!--- Tabla: filtro --->
							<form style="margin:0; " name="formfiltro" action="calendarioPagos.cfm" method="post">
								<input type="hidden" name="Tcodigo" id="Tcodigo" value="<cfif isdefined('form.Tcodigo')><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
								<tr>
									<td align="left" class="FileLabel"><cfoutput>#LB_CODIGO#</cfoutput></td>
									<td align="left" class="FileLabel"><cf_translate   key="LB_Desde">Desde</cf_translate></td>
									<td align="left" class="FileLabel"><cf_translate   key="LB_Hasta">Hasta</cf_translate></td>
									<td align="left" class="FileLabel"><cf_translate   key="LB_Pago">Pago</cf_translate></td>
									<td align="left" class="FileLabel">&nbsp;</td>
								</tr>
								<tr>
									<td>
										<cfif isDefined("form.fCPcodigo") and len(trim(form.fCPcodigo)) gt 0 >
											<cfoutput>
												<input type="text" name="fCPcodigo" size="15" maxlenght="11" value="#form.fCPcodigo#">
											</cfoutput>
										<cfelse>
											<input type="text" name="fCPcodigo" size="15" maxlenght="11">
										</cfif>									</td>
<!--- formato --->					<td>
										<cfif isDefined("form.fCPdesde") and len(trim(form.fCPdesde)) gt 0>
											<cfoutput>
												<cf_sifcalendario form="formfiltro" value="#form.fCPdesde#" name="fCPdesde">
											</cfoutput>
										<cfelse>
											<cf_sifcalendario form="formfiltro" name="fCPdesde">
										</cfif>
											
									</td>
									<td>
										<cfif isDefined("form.fCPhasta") and len(trim(form.fCPhasta)) gt 0>
											<cfoutput>
												<cf_sifcalendario form="formfiltro" value="#form.fCPhasta#" name="fCPhasta">
											</cfoutput>
										<cfelse>
											<cf_sifcalendario form="formfiltro" name="fCPhasta">
										</cfif>									</td>
									
									<td>
										<cfif isDefined("form.fCPfpago") and len(trim(form.fCPfpago)) gt 0>
											<cfoutput>
												<cf_sifcalendario form="formfiltro" value="#form.fCPfpago#" name="fCPfpago">
											</cfoutput>
										<cfelse>
											<cf_sifcalendario form="formfiltro" name="fCPfpago">
										</cfif>									</td>
								</tr>
								<tr>
									<td align="left" class="FileLabel"><cf_translate   key="LB_Estado">Estado</cf_translate></td>
									<td align="left" class="FileLabel"><cf_translate   key="LB_Hasta">Tipo</cf_translate></td>
									<td align="left" class="FileLabel">&nbsp;</td>
									<td align="left" class="FileLabel">&nbsp;</td>
								</tr>
								<tr>
									<td>
										<select name="f_estado">
											<option value="0" <cfif isdefined("form.f_estado") and form.f_estado EQ 0 >selected</cfif> >-<cf_translate key="LB_Todos">Todos</cf_translate>-</option>
											<option value="1" <cfif isdefined("form.f_estado") and form.f_estado EQ 1 >selected</cfif>><cf_translate key="LB_Pendientes">Pendientes</cf_translate></option>
											<option value="2" <cfif isdefined("form.f_estado") and form.f_estado EQ 2 >selected</cfif>><cf_translate key="LB_Pagados">Pagados</cf_translate></option>
										</select>
									</td>
									<td>
										<select name="f_tipo">
											<option value="">-<cf_translate key="LB_Todos">Todos</cf_translate>-</option>
											<option value="0" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 0 >selected</cfif> ><cf_translate   key="CMB_Normal">Normal</cf_translate></option>
											<option value="1" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 1 >selected</cfif> ><cf_translate   key="CMB_Especial">Especial</cf_translate></option>
											<option value="2" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 2 >selected</cfif> ><cf_translate   key="CMB_Anticipo">Anticipo</cf_translate></option>
											<cfif usaEstructuraSalarial>
											<option value="3" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 3 >selected</cfif> ><cf_translate   key="CMB_Retroactivo">Retroactivo</cf_translate></option>
											</cfif>
                                            <cfif CalculaPTU>
											<option value="4" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 4 >selected</cfif> >PTU</option>
											</cfif>
                                            <option value="5" <cfif isdefined("form.f_tipo") and form.f_tipo EQ 5 >selected</cfif> >FOA</option>
										</select>
									</td>
								  	<td colspan="2" align="center">
										<input type="submit" name="filtrar" class="btnFiltrar" id="filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" />
									</td>
								</tr>
							</form>
						</table> 
						<!--- Tabla: filtro --->
					</td>
				</tr><!--- filtro --->
				
				<tr> <!--- lista --->
					<td> <!--- TD: Lista--->
						<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Form.Tcodigo>
						</cfif>
						
						<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaCalenPagos">
							<cfinvokeargument name="tabla" 		value="CalendarioPagos"/>
							<cfinvokeargument name="columnas" 	value="CPcodigo,CPid,Tcodigo,CPdesde,CPhasta,CPfpago, case when CPtipo = 0 then 'N' when CPtipo = 1 then 'E' when CPtipo = 2 then 'A' when CPtipo = 3 then 'R' when CPtipo = 4 then 'PTU' when CPtipo = 5 then 'FOA' end as tipo #preservesinglequotes(campos_adicionales)#"/> <!---SML. Modificacion para Fondo de Ahorro--->
							<cfinvokeargument name="filtro" 	value="Ecodigo=#session.Ecodigo# and Tcodigo='#trim(form.Tcodigo)#' #filtro# order by CPfpago "/>
							<cfinvokeargument name="desplegar" 	value="CPcodigo,CPdesde,CPhasta,CPfpago, tipo"/>
							<cfinvokeargument name="etiquetas" 	value="#LB_Codigo#,#LB_Desde#,#LB_Hasta#,#LB_Pago#,#LB_Tipo#"/>
							<cfinvokeargument name="formatos" 	value="S,D,D,D,S"/>
							<cfinvokeargument name="align" 		value="left,left,left,left,left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="irA" 		value="calendarioPagos.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="keys" 		value="CPid"/>
							<cfinvokeargument name="PageIndex" 	value="2"/>
							<cfinvokeargument name="debug" 		value="N"/>
						</cfinvoke>	

					</td> <!--- TD: Lista--->
				</tr> <!--- lista --->
			</table> <!--- Tabla: filtro/lista--->
		</td> <!--- Lista/filtro --->
		
		<cfoutput>

		<form name="formCalendarioPago" id="formCalendarioPago" method="post" action="SQLcalendarioPagos.cfm" onSubmit="document.formCalendarioPago.CPtipo.disabled = false;">
			<input type="hidden" name="Tcodigo" id="Tcodigo" value="<cfif isdefined('form.Tcodigo')><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
			<input type="hidden" name="CPid" id="CPid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCalenPago.CPid#</cfoutput></cfif>">

			<cfif isdefined("form.fCPdesde") and Len(Trim(form.fCPdesde)) NEQ 0>
				<input type="hidden" name="fCPdesde" value="#form.fCPdesde#" />
			</cfif>
			<cfif isdefined("form.fCPhasta") and Len(Trim(form.fCPhasta)) NEQ 0>
				<input type="hidden" name="fCPhasta" value="#form.fCPhasta#" />
			</cfif>
			<cfif isdefined("form.fCPfpago") and Len(Trim(form.fCPfpago)) NEQ 0>
				<input type="hidden" name="fCPfpago" value="#form.fCPfpago#" />
			</cfif>
			<cfif isdefined("form.fCPcodigo") and Len(Trim(form.fCPcodigo)) NEQ 0>
				<input type="hidden" name="fCPcodigo" value="#form.fCPcodigo#" />
			</cfif>
			<cfif isdefined("form.f_estado") and Len(Trim(form.f_estado)) NEQ 0>
				<input type="hidden" name="f_estado" value="#form.f_estado#" />
			</cfif>
			<cfif isdefined("form.f_tipo") and Len(Trim(form.f_tipo)) NEQ 0>
				<input type="hidden" name="f_tipo" value="#form.f_tipo#" />
			</cfif>

			<cfif isdefined("Form.PageNum2")>
				<input type="hidden" name="PageNum2" id="PageNum2" value="<cfoutput>#Form.PageNum2#</cfoutput>">
			</cfif>

		<td valign="top"> <!--- Mantenimientos --->
			<table width="100%" cellpadding="0" cellspacing="0"> <!--- TABLE: Mantenimientos --->
				<tr> <!--- TR: mant. principal --->
					<td> <!--- TD: mant. principal --->
						<table width="100%" cellpadding="0" cellspacing="0"> <!--- TABLE: mant. principal --->
							<tr>
								<td colspan="3" align="center" class="subTitulo">
									<cfif modo NEQ "ALTA"><cf_translate   key="LB_ModificacionDeCalendarioDePago">Modificaci&oacute;n de Calendario de Pago</cf_translate>
									<cfelse><cf_translate   key="LB_NuevoCalendarioDePago">Nuevo Calendario de Pago</cf_translate></cfif></td></tr>
							<tr> 
								<td width="28%" class="fileLabel" id="Lfdesde"><cf_translate   key="LB_FechaDesde">Fecha desde</cf_translate></td>
								<td width="30%" class="fileLabel"><cf_translate   key="LB_FechaHasta">Fecha hasta</cf_translate></td>
								<td width="42%" class="fileLabel"><cf_translate   key="LB_FechaDePago">Fecha de pago</cf_translate></td>
							</tr>
							<tr>								
								<td id="fdesde">
									<cfif modo NEQ 'ALTA'>
										<cfset fechaCPdesde = LSDateFormat(rsCalenPago.CPdesde,"DD/MM/YYYY")>
									<cfelse>
										<cfset fechaCPdesde = LSDateFormat(Now(), "DD/MM/YYYY")>
									</cfif>
									<cf_sifcalendario form="formCalendarioPago" value="#fechaCPdesde#" name="CPdesde">	 
								</td>								
								<td>
									<cfif modo NEQ 'ALTA'>
										<cfset fechaCPhasta = LSDateFormat(rsCalenPago.CPhasta,"DD/MM/YYYY")>
									<cfelse>
										<cfset fechaCPhasta = LSDateFormat(Now(), "DD/MM/YYYY")>
									</cfif> 
									<cf_sifcalendario  form="formCalendarioPago" value="#fechaCPhasta#" name="CPhasta">							  
								</td>
								<td>
									<cfif modo NEQ 'ALTA'>
										<cfset fechaCPfpago = LSDateFormat(rsCalenPago.CPfpago,"DD/MM/YYYY")>
									<cfelse>
										<cfset fechaCPfpago = LSDateFormat(Now(), "DD/MM/YYYY")>
									</cfif>
									<cf_sifcalendario form="formCalendarioPago" value="#fechaCPfpago#" name="CPfpago" onBlur="funcCargaPeriodoMes()">

								</td>
							</tr>
							
							<tr> 
								<td class="fileLabel">#LB_CODIGO#</td>
								<td class="fileLabel"><cf_translate   key="LB_Periodo">Per&iacute;odo</cf_translate></td>
								<td class="fileLabel"><cf_translate   key="LB_Mes">Mes</cf_translate></td>
							</tr>
							
							<tr> 
								<td  valign="top">
									<cfif modo NEQ 'ALTA'>
										<cf_sifmaskstring form="formCalendarioPago" name="CPcodigo" formato="****-**-***" 
														  size="15" maxlenght="11" mostrarmascara="false" value="#rsCalenPago.CPcodigo#">
									<cfelse>
										<cf_sifmaskstring form="formCalendarioPago" name="CPcodigo" formato="****-**-***" 
														  size="15" maxlenght="11" mostrarmascara="false">
									</cfif>
								</td>
								<td valign="top">
									<input type="text" name="CPperiodo" value="<cfif modo NEQ 'ALTA'>#rsCalenPago.CPperiodo#<cfelse>#year(now())#</cfif>" size="13" maxlength="5" onFocus="javascript:this.select()" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};" alt="Periodo del calendario de pago">
								</td>
								<td valign="top">
									<input type="text" name="CPmes" value="<cfif modo NEQ 'ALTA'>#rsCalenPago.CPmes#<cfelse>#month(now())#</cfif>" size="13" maxlength="3" onFocus="javascript:this.select()" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};" alt="Mes del calendario de pago">
								</td>
							</tr>
							<tr> 
								<td class="fileLabel" colspan="2">#LB_DESCRIPCION#</td>
								<td class="fileLabel"><cf_translate   key="LB_Tipo">Tipo</cf_translate></td>
							</tr>

							<tr> 
								<td colspan="2">
									<input type="text" name="CPdescripcion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCalenPago.CPdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select()" alt="Descripción del calendario de pago">
								</td>
								<td><select name="CPtipo" onchange="javascript: activa_desactiva(); <cfif modo NEQ 'ALTA'>mostrarCargas();</cfif> " <cfif modo EQ 'CAMBIO' and LEN(TRIM(rsCalenPago.CPfcalculo))>disabled</cfif>>
								  <cfif modo NEQ 'ALTA'>
								    <option value="0" <cfif rsCalenPago.CPtipo EQ 0>selected</cfif>>
								      <cf_translate   key="CMB_Normal">Normal</cf_translate>
							        </option>
								    <option value="1" <cfif rsCalenPago.CPtipo EQ 1>selected</cfif>>
								      <cf_translate   key="CMB_Especial">Especial</cf_translate>
							        </option>
								    <option value="2" <cfif rsCalenPago.CPtipo EQ 2>selected</cfif>>
								      <cf_translate   key="CMB_Anticipo">Anticipo</cf_translate>
							        </option>
								    <cfif usaEstructuraSalarial>
								      <option value="3" <cfif rsCalenPago.CPtipo EQ 3>selected</cfif>>
								        <cf_translate   key="CMB_Anticipo">Retroactivo</cf_translate>
							          </option>
							        </cfif>
								    <cfif CalculaPTU>
								      <option value="4" <cfif rsCalenPago.CPtipo EQ 4>selected</cfif>>PTU</option>
							        </cfif>
								    <option value="5" <cfif rsCalenPago.CPtipo EQ 5>selected</cfif>>
								      <cf_translate key="CMB_FondoAhorro">Fondo Ahorro</cf_translate>
							        </option>
								    <cfelse>
								    <option value="0" selected>
								      <cf_translate   key="CMB_Normal">Normal</cf_translate>
							        </option>
								    <option value="1">
								      <cf_translate key="CMB_Especial">Especial</cf_translate>
							        </option>
								    <option value="2">
								      <cf_translate key="CMB_Anticipo">Anticipo</cf_translate>
							        </option>
								    <cfif usaEstructuraSalarial>
								      <option value="3">
								        <cf_translate key="CMB_Retroactivo">Retroactivo</cf_translate>
							          </option>
							        </cfif>
								    <cfif CalculaPTU>
								      <option value="4">PTU</option>
							        </cfif>
								    <option value="5">
								      <cf_translate key="CMB_FondoAhorro">Fondo Ahorro</cf_translate>
							        </option>
							      </cfif>
							    </select></td>
							</tr>
                            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2035" default="" returnvariable="vTablaNomina"/>
							<cfif #vTablaNomina# >
                            <tr>
                                <td align="right" nowrap class="fileLabel" id="LbTablaImpuesto"><cf_translate key="LB_TablaDeImpuestoDeRenta">Tabla de Impuesto de Renta</cf_translate>:&nbsp;</td>
                                <td colspan="3" id="ConLisTablaImpuesto">
                                    <!--- trae la descripcion del impuesto de renta --->
                                    <cfset values = ''>
                                    <cfif isdefined('rsCalenPago') and rsCalenPago.RecordCount GT 0 >
                                        <cfif len(trim(rsCalenPago.IRcodigo)) GT 0 >
                                            <cfquery name="rsTraeIRenta" datasource="#session.DSN#">
                                                select IRcodigo, rtrim(ltrim(IRdescripcion)) as IRdescripcion
                                                from ImpuestoRenta 
                                                where 
                                                IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsCalenPago.IRcodigo)#">
                                            </cfquery>
                                            <cfset values = '#rsTraeIRenta.IRcodigo#,#rsTraeIRenta.IRdescripcion#'>
                                        </cfif>
                                    </cfif>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        key="LB_ListadeTablasdeRenta"
                                        default="Lista de Tablas de Renta"
                                        returnvariable="LB_ListadeTablasdeRenta"/>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        key="LB_Codigo"
                                        default="C&oacute;digo"
                                        returnvariable="LB_Codigo"/>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        key="LB_Descripcion"
                                        default="Descripci&oacute;n"
                                        returnvariable="LB_Descripcion"/>
                            
                                    <cf_conlis title="#LB_ListadeTablasdeRenta#"
                                        campos = "IRcodigo,IRdescripcion" 
                                        desplegables = "S,S" 
                                        size = "10,50"
                                        values="#values#"
                                        tabla="ImpuestoRenta"
                                        columnas="IRcodigo,IRdescripcion"
                                        filtro=""
                                        desplegar="IRcodigo,IRdescripcion"
                                        etiquetas="#LB_Codigo#,#LB_Descripcion#"
                                        formatos="S,S"
                                        align="left,left"
                                        conexion="#session.DSN#"
                                        form = "formCalendarioPago"                                        
                                        tabindex="1">			
                                </td>
                            </tr>
                            </cfif>
							<tr>
								<td colspan="3">
									<!--- Contiene la parte nueva de deducciones --->								
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="1%" ><input type="checkbox" name="CPnorenta" id="CPnorenta" value="checkbox" onclick="changeNoRenta()"
													   <cfif modo NEQ 'ALTA' and rsCalenPago.CPnorenta EQ 1>checked</cfif> /></td>
											<td class="fileLabel" nowrap><cf_translate   key="CHK_NoCalculaRenta">No calcula Renta</cf_translate></td>
                                            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
													ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vUsaSBC"/>
											<cfif #vUsaSBC# EQ 1>
												<td colspan="3" id="TDCPTipoCalRenta">
													Tipo Calculo Renta
													<select name="CPTipoCalRenta" id="CPTipoCalRenta">
													  <option value="1" id="CPTipoCalRenta1" <cfif modo NEQ 'ALTA' and rsCalenPago.CPTipoCalRenta EQ 1>selected="selected"</cfif>>Renta por Mes</option>
													  <option value="2" id="CPTipoCalRenta2" <cfif modo NEQ 'ALTA' and rsCalenPago.CPTipoCalRenta EQ 2>selected="selected"</cfif>>Renta Nomina Aguinaldo</option>
													  <option value="3" id="CPTipoCalRenta3" <cfif modo NEQ 'ALTA' and rsCalenPago.CPTipoCalRenta EQ 3>selected="selected"</cfif>>Ajuste Anual de Renta</option>
                                                      <option value="4" id="CPTipoCalRenta4" <cfif modo NEQ 'ALTA' and rsCalenPago.CPTipoCalRenta EQ 4>selected="selected"</cfif>>Renta en Nomina</option>
													</select>
												</td>
											</cfif>
										</tr>
										
										<tr>
											<td width="1%">
												<input type="checkbox" name="CPnocargasley" value="checkbox" <cfif modo neq 'ALTA'>onclick="javascript:mostrarCargas();"</cfif> <cfif modo NEQ 'ALTA' and rsCalenPago.CPnocargasley EQ 1>checked</cfif>>
											</td>
											<td class="fileLabel" nowrap><cf_translate   key="CHK_NoCalculaCargasDeLey">No calcula Cargas de Ley</cf_translate></td>
										</tr>
								
										<tr>
											<td width="1%">
												<input type="checkbox" name="CPnocargas" value="checkbox"  <cfif modo neq 'ALTA'>onclick="javascript:mostrarCargas();"</cfif> <cfif modo NEQ 'ALTA' and rsCalenPago.CPnocargas EQ 1>checked</cfif>>
											</td>
											<td class="fileLabel" colspan="2" nowrap><cf_translate   key="CHK_NoCalculaCargas">No calcula Cargas</cf_translate></td>
										</tr>
										<tr>
											<td width="1%">
												<input type="checkbox" name="CPnodeducciones" value="checkbox"  <cfif modo NEQ 'ALTA' and rsCalenPago.CPnodeducciones EQ 1>checked</cfif> onclick="javascript:mostrarDeducciones();">
											</td>
											<td class="fileLabel" colspan="2" nowrap><cf_translate   key="CHK_NoAplicaDeducciones">No aplica Deducciones</cf_translate></td>
										</tr>
										<cfif modo NEQ 'ALTA' and rsCalenPago.CPMes eq '12'>
											<tr>
												<td width="1%">
													<input type="checkbox" name="CPultimaSemana" value="1" <cfif modo NEQ 'ALTA' and rsCalenPago.CPesUltimaSemana EQ 1>checked</cfif>>
												</td>
												<td class="fileLabel" colspan="2" nowrap>Ultima Semana</td>
											</tr>
										</cfif>

										<tr><td>&nbsp;</td></tr>
									</table>
								</td>
							</tr>		

							<script language="JavaScript" type="text/javascript">
								// Funciones para Manejo de Botones
								botonActual = "";
							
								function setBtn(obj) {
									botonActual = obj.name;
								}
								function btnSelected(name, f) {
									if (f != null) {
										return (f["botonSel"].value == name)
									} else {
										return (botonActual == name)
									}
								}
							</script>
							<cfif not isdefined('modo')>
								<cfset modo = "ALTA">
							</cfif>
							<cfif not isdefined("tabindex")>
								<cfset tabindex="-1">
							</cfif>
							<input type="hidden" name="botonSel" value="">

							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Limpiar"
								Default="Limpiar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Limpiar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Modificar"
								Default="Modificar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Modificar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Eliminar"
								Default="Eliminar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Eliminar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_DeseaEliminarElRegegistro"
								Default="\nDesea eliminar el registro?"
								XmlFile="/rh/generales.xml"
								returnvariable="MSG_DeseaEliminarElRegistro"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Nuevo"
								Default="Nuevo"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Nuevo"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Replicar"
								Default="Replicar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Replicar"/>

							<tr>

								<td colspan="3" class="fileLabel" align="center">
									<cfif modo neq 'ALTA'>
										<input type="submit" class="btnGuardar" name="Cambio" value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); "
										
										 tabindex="-1">	
										 
										 
										 
<!----------------------- pregunta si existen deducciones asociadas a este calendario--->
										
										<cfquery name="ExistenDeducciones" datasource="#session.DSN#">
											select (1) from RHExcluirDeduccion where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										
												<cfif ExistenDeducciones.RecordCount GT 0>
													 <cfset MSG_DeseaEliminarElRegistro=#MSG_existDeduc#&#MSG_DeseaEliminarElRegistro#>
												 </cfif>
												 
															
<!----------------------- pregunta si existen conceptos de pago asociados a este calendario--->
										
										<cfquery name="ExistenConcepto" datasource="#session.DSN#">
											select (1) from CCalendario where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										
												<cfif ExistenConcepto.RecordCount GT 0>
													 <cfset MSG_DeseaEliminarElRegistro=#MSG_existConceptos#&#MSG_DeseaEliminarElRegistro#>
												 </cfif>																					 
				 
										 	
<!----------------------- pregunta si existen Creditos fiscales asociados a este calendario--->									
							<cfquery name="ExistenCreditosFiscales" datasource="#session.DSN#">					
								select (1) from RHExcluirCFiscal where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
								</cfquery>							
																
									
										 <cfif ExistenCreditosFiscales.RecordCount GT 0>
											 <cfset MSG_DeseaEliminarElRegistro=#MSG_existCreditosFiscales#&#MSG_DeseaEliminarElRegistro#>
										 </cfif>
			 
			 

								 
<!----------------------- pregunta si existen Cargas asociadas a este calendario--->
										
										<cfquery name="ExistenCargas" datasource="#session.DSN#">
											select (1) from RHCargasExcluir where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										
												<cfif ExistenCargas.RecordCount GT 0>
													 <cfset MSG_DeseaEliminarElRegistro=#MSG_existCargas#&#MSG_DeseaEliminarElRegistro#>
												 </cfif>
														
																	 
						 
			 
				 
										 
										 																	 
										 
										<input type="submit" class="btnEliminar" name="Baja"   value="#BTN_Eliminar#"  onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('#MSG_DeseaEliminarElRegistro#');" tabindex="-1">
										<input type="submit" class="btnNuevo" name="Nuevo"   value="#BTN_Nuevo#"    onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); " tabindex="-1">
										<input type="submit" class="btnNormal" id="Replicar" name="Replicar"   value="#BTN_Replicar#"    onClick="javascript: this.form.botonSel.value = this.name; funcReplicar();" tabindex="-1">
									<cfelse>
										<input tabindex="-1" class="btnGuardar" type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
										<input tabindex="-1" class="btnLimpiar" type="reset" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
									</cfif>										
								</td>
							</tr>										
						</table> <!--- TABLE: mant. principal --->
					</td> <!--- TD: mant. principal --->
				</tr> <!--- TR: mant. principal --->
				
				<tr><td>&nbsp;</td></tr> <!--- espacio entre botones/mantenimientos agregados --->
								
				<cfif modo NEQ 'ALTA'> <!--- IF: mantenimientos agregados --->
					<tr> <!--- TR: mantenimientos agregados --->
						<td> <!--- TD: mantenimientos agregados --->
							<table width="100%" cellpadding="0" cellspacing="0"> <!--- TABLE: mantenimientos agregados --->
								<cfif isdefined('rsCalenPago') and rsCalenPago.recordcount and not rsCalenPago.CPnodeducciones><!--- SI NO APLICA DEDUCCIONES NO LO MUESTRA --->
								<tr id="tr_deducciones"> <!--- TR: deducciones a excluir --->
								
								
								
									<td> <!--- TD: deducciones a excluir ----------------------------------------->
										
										
													<!--- Tipos de Deducción --->
																			<cfquery name="rsTiposDeduccionEX" datasource="#Session.DSN#">
																				select a.CPid, b.TDid, c.TDdescripcion 
																				from CalendarioPagos a, RHExcluirDeduccion b, TDeduccion c
																				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
																				  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
																				  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Tcodigo)#">
																				  and a.CPid = b.CPid
																				  and b.TDid = c.TDid																							
																			</cfquery>	
																			
																			
											<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TiposDeDeduccionAExcluir#'>	
											<table width="100%" cellpadding="2" cellspacing="0"> <!--- TABLE: deducciones a excluir --->
											<!--- Tipos de Deducciones para excluir --->
											<input type="hidden" name="btnBorrarDeduccionEx" value="">
												
																
											<tr align="center">		
												<td>
													<input type="text" name="exTDdescripcion" value="" id="exTDdescripcion" readonly size="30" maxlength="60" tabindex="-1">
													<input type="hidden" name="exTDid" value="">
													
													<a href="javascript: doConlisTipoDeduccionEx();" tabindex="-1" >
														<img src="/cfmx/rh/imagenes/Description.gif" width="18" height="14" border="0" alt="Lista de Tipos de Deducciones">
													</a>
													
												</td>	
												
											</tr>
					
											
											<tr align="center">			
												<td align="center" valign="top">
													<input type="submit" class="btnGuardar" name="btnAgregarTipoDeduccionEx" value="Agregar" onClick="javascript: return validaTipoDeduccionEx();">
												</td>					
											</tr>
											
											<tr>
												<td>
													<!--- Lista --->
													<table border="0" width="100%">
														<cfif rsTiposDeduccionEx.RecordCount gt 0 >
															<cfloop query="rsTiposDeduccionEx">
															<tr <cfif rsTiposDeduccionEx.CurrentRow MOD 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
																<td><a href="" onClick="javascript: return false;" 
																	   title="#rsTiposDeduccionEx.TDdescripcion#">
																			<cfif Len(Trim(rsTiposDeduccionEx.TDdescripcion)) LT 30>
																		   		#rsTiposDeduccionEx.TDdescripcion#
																				<cfelse>
																				#Mid(rsTiposDeduccionEx.TDdescripcion,1,18)#...
																		   </cfif>
																</a></td>
																<td>
																	<input name="btnBorrarTipoDeduccionEx" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarTipoDeduccionEx(#TDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
																</td>
															</tr>
															</cfloop>
														<cfelse>
															<tr>
																<td nowrap align="center" valign="top"><b><cf_translate   key="LB_NoSeEncontraronDatos">- No se encontraron datos -</cf_translate></b></td>
															</tr>
														</cfif>
														<input type="hidden" name="exTDid_" value="">
													</table>
												</td>
										
												
											</tr>
											</table><!--- TABLE: deducciones a excluir --->
											<cf_web_portlet_end>	
																
																					
										
										
									</td> <!--- TD: deducciones a excluir ----------------------------------------->
								</tr> <!--- TR: deducciones a excluir --->
								<tr><td>&nbsp;</td></tr>
                                
                                <!---SML. Inicio de Deducciones a incluir--->
                                <tr id="tr_deducciones"> <!--- TR: deducciones a incluir --->
								
								
								
									<td> <!--- TD: deducciones a excluir ----------------------------------------->
										
										
													<!--- Tipos de Deducción --->
																			<cfquery name="rsTiposDeduccionIN" datasource="#Session.DSN#">
																				select a.CPid, b.TDid, c.TDdescripcion 
																				from CalendarioPagos a, RHIncluirDeduccion b, TDeduccion c
																				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
																				  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
																				  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Tcodigo)#">
																				  and a.CPid = b.CPid
																				  and b.TDid = c.TDid																							
																			</cfquery>	
																			
																			
											<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TiposDeDeduccionAIncluir#'>	
											<table width="100%" cellpadding="2" cellspacing="0"> <!--- TABLE: deducciones a excluir --->
											<!--- Tipos de Deducciones para excluir --->
											<input type="hidden" name="btnBorrarDeduccionIn" value="">
												
																
											<tr align="center">		
												<td>
													<input type="text" name="inTDdescripcion" value="" id="inTDdescripcion" readonly size="30" maxlength="60" tabindex="-1">
													<input type="hidden" name="inTDid" value="">
													
													<a href="javascript: doConlisTipoDeduccionIn();" tabindex="-1" >
														<img src="/cfmx/rh/imagenes/Description.gif" width="18" height="14" border="0" alt="Lista de Tipos de Deducciones">
													</a>
													
												</td>	
												
											</tr>
					
											
											<tr align="center">			
												<td align="center" valign="top">
													<input type="submit" class="btnGuardar" name="btnAgregarTipoDeduccionIn" value="Agregar" onClick="javascript: return validaTipoDeduccionIn();">
												</td>					
											</tr>
											
											<tr>
												<td>
													<!--- Lista --->
													<table border="0" width="100%">
														<cfif rsTiposDeduccionIN.RecordCount gt 0 >
															<cfloop query="rsTiposDeduccionIN">
															<tr <cfif rsTiposDeduccionIN.CurrentRow MOD 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
																<td><a href="" onClick="javascript: return false;" 
																	   title="#rsTiposDeduccionIN.TDdescripcion#">
																			<cfif Len(Trim(rsTiposDeduccionIN.TDdescripcion)) LT 30>
																		   		#rsTiposDeduccionIN.TDdescripcion#
																				<cfelse>
																				#Mid(rsTiposDeduccionIN.TDdescripcion,1,18)#...
																		   </cfif>
																</a></td>
																<td>
																	<input name="btnBorrarTipoDeduccionIn" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarTipoDeduccionIn(#TDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
																</td>
															</tr>
															</cfloop>
														<cfelse>
															<tr>
																<td nowrap align="center" valign="top"><b><cf_translate   key="LB_NoSeEncontraronDatos">- No se encontraron datos -</cf_translate></b></td>
															</tr>
														</cfif>
														<input type="hidden" name="inTDid_" value="">
													</table>
												</td>
										
												
											</tr>
											</table><!--- TABLE: deducciones a excluir --->
											<cf_web_portlet_end>	
																
																					
										
										
									</td> <!--- TD: deducciones a excluir ----------------------------------------->
								</tr> <!--- TR: deducciones a excluir --->
								</cfif>
								<tr><td>&nbsp;</td></tr>
                                
                               <!--- SML. Final--->
								
								<tr id="detalles_cp" style="display:none" > <!--- TR: conceptos de pago --->
									<td> <!--- TD: conceptos de pago --->
																				
										<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
														titulo='#LB_ConceptosDePago#'>	
											<table width="100%" cellpadding="2" cellspacing="0">  <!--- TABLE: conceptos de pago --->
												<tr>
													<td align="center">
														<cf_rhCIncidentes form="formCalendarioPago" IncluirTipo="2,3">
													</td>
												</tr>
												<tr>
													<td align="center">
														<input type="submit" class="btnGuardar" name="btnAgregarConcepto" value="#BTN_Agregar#" onClick="javascript: return validaConcepto();">
													</td>
												</tr>
												<tr>
													<td>
														<!--- Lista --->
														<table border="0" width="100%">
															<cfloop query="rsConceptos">
																<tr <cfif CurrentRow MOD 2> 
																		class="listaPar"<cfelse>class="listaNon"</cfif>>
																	<td>#CIcodigo#</td>
																	<td>
																		<a href="" onClick="javascript: return false;" 
																		   title="#CIdescripcion#">
																		   <cfif Len(Trim(CIdescripcion)) LT 20>
																		   		#CIdescripcion#<cfelse>#Mid(CIdescripcion,1,18)#...
																		   </cfif>
																		 </a>
																	</td>
																	<td>
																		<input name="btnBorrarConcepto" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarConcepto(#CIid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
																	</td>
																</tr>
															</cfloop>
															<input type="hidden" name="CIid_" value="">
														</table>
													</td>
												</tr>
											</table> <!--- TABLE: conceptos de pago --->
										<cf_web_portlet_end>						
									</td>  <!--- TD: conceptos de pago --->
								</tr>  <!--- TR: conceptos de pago --->
								<tr><td>&nbsp;</td></tr>

								<!--- Creditos Fiscales --->
								<cfquery name="rs_creditos" datasource="#session.DSN#">
									select a.CDid, a.CDcodigo, a.CDdescripcion
									
									from ConceptoDeduc a, DConceptoDeduc b
									
									where b.EIRid in (	select EIRid
														from EImpuestoRenta
														where IRcodigo = ( select Pvalor
																		   from RHParametros
																		   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		   and Pcodigo = 30 )
														and <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(rsCalenPago.CPperiodo, rsCalenPago.CPmes, 1)#"> between EIRdesde and EIRhasta
									  				 )
									
									
									and a.CDid not in (	select CDid													
														from RHExcluirCFiscal
														where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#"> )
									
									and b.CDid = a.CDid
									
									order by a.CDcodigo
								</cfquery>	
						
						
						
								<cfif rsCalenPago.CPtipo NEQ 4 and rsCalenPago.CPtipo NEQ 5> <!---SML. Modificacion para que no aparezcan los creditos fiscales a excluir--->
                                    <tr > <!--- TR: creditos fiscales a excluir --->
                                        <td> <!--- TD: creditos fiscales --->
                                            <cfinvoke Key="LB_Creditos_Fiscales_a_excluir" Default="Cr&eacute;ditos Fiscales a excluir" returnvariable="LB_Creditos_Fiscales_a_excluir" component="sif.Componentes.Translate" method="Translate"/>
                                            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Creditos_Fiscales_a_excluir#'>	
                                                <table width="100%" cellpadding="2" cellspacing="0">  <!--- TABLE: creditos fiscales --->
                                                    <tr>
                                                        <td align="center">
                                                            <select name="CDid">
                                                                <option value="">#LB_seleccionar#</option>
                                                                <cfloop query="rs_creditos">
                                                                    <option value="#rs_creditos.CDid#">#trim(rs_creditos.CDcodigo)# - #rs_creditos.CDdescripcion#</option>
                                                                </cfloop>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center">
                                                            <input type="submit" class="btnGuardar" name="btnAgregarCredito" value="#BTN_Agregar#" onClick="javascript: return validaCredito();">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <!--- Lista --->
                                                            <table border="0" width="100%">
                                                                
                                                                <cfquery name="rsCreditos" datasource="#session.DSN#">
                                                                    select a.CDid, b.CDcodigo, b.CDdescripcion
                                                                    from RHExcluirCFiscal a, ConceptoDeduc b
                                                                    where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
                                                                    and b.CDid = a.CDid
                                                                    order by b.CDcodigo
                                                                </cfquery>
                                                                
                                                                <cfloop query="rsCreditos">
                                                                    <tr <cfif CurrentRow MOD 2> 
                                                                            class="listaPar"<cfelse>class="listaNon"</cfif>>
                                                                        <td>#CDcodigo#</td>
                                                                        <td>
                                                                            <a href="" onClick="javascript: return false;" 
                                                                               title="#CDdescripcion#">
                                                                               <cfif Len(Trim(CDdescripcion)) LT 20>
                                                                                    #CDdescripcion#<cfelse>#Mid(CDdescripcion,1,18)#...
                                                                               </cfif>
                                                                             </a>
                                                                        </td>
                                                                        <td>
                                                                            <input name="btnBorrarCredito" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarCredito(#CDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
                                                                        </td>
                                                                    </tr>
                                                                </cfloop>
                                                                <input type="hidden" name="CDid_" value="">
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table> <!--- TABLE: conceptos de pago --->
                                            <cf_web_portlet_end>						
                                        </td>  <!--- TD: conceptos de pago --->
                                    </tr>  <!--- TR: conceptos de pago --->
                                </cfif>


								<!--- ********************************************************* --->
								<!--- ********************************************************* --->
								<tr><td>&nbsp;</td></tr>
								<tr id="tr_cargas" <cfif (isdefined("rsCalenPago") and rsCalenPago.CPtipo eq 0) or rsCalenPago.CPnocargas eq 1 or rsCalenPago.CPnocargasley eq 1>style="display: none;"</cfif> > <!--- TR: cargas a excluir --->
									<td> <!--- TD: cargas --->
										<cfinvoke Key="LB_Cargas_a_excluir" Default="Cargas a excluir" returnvariable="LB_cargas" component="sif.Componentes.Translate" method="Translate"/>
										<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_cargas#'>	
											<table width="100%" cellpadding="2" cellspacing="0">  <!--- TABLE: cargas --->
												<tr>
													<td align="center">
														<cf_conlis title="#LB_cargas#"
															campos = "DClinea,DCcodigo,DCdescripcion" 
															desplegables = "N,S,S" 
															modificables = "N,S,N" 
															size = "0,10,30"
															asignar="DClinea,DCcodigo,DCdescripcion"
															asignarformatos="I,S,S"
															tabla="DCargas a"
															columnas="a.DClinea,a.DCcodigo,a.DCdescripcion"
															form="formCalendarioPago"
															filtro="a.Ecodigo =#session.Ecodigo#"
															desplegar="DCcodigo,DCdescripcion"
															etiquetas=" #LB_CODIGO#,#LB_DESCRIPCION#"
															formatos="S,S"
															align="left,left"
															showEmptyListMsg="true"
															debug="false"
															width="800"
															height="500"
															left="70"
															top="20"
															filtrar_por="DCcodigo,DCdescripcion">
													</td>
												</tr>
												<tr>
													<td align="center">
														<input type="submit" class="btnGuardar" name="btnAgregarCarga" value="#BTN_Agregar#" onClick="javascript: return validaCarga();">
													</td>
												</tr>
												<tr>
													<td>
														<!--- Lista --->
														<table border="0" width="100%">
															
															<cfquery name="rsCargas" datasource="#session.DSN#">
																select a.DClinea, b.DCcodigo, DCdescripcion
																from RHCargasExcluir a, DCargas b
																where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
																and b.DClinea=a.DClinea
															</cfquery>
															
															<cfloop query="rsCargas">
																<tr <cfif CurrentRow MOD 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
																	<td>
																		<a href="" onClick="javascript: return false;" 
																		   title="#trim(DCcodigo)# - #DCdescripcion#">
																		   <cfif Len(Trim(DCdescripcion)) LT 50>
																		   		#trim(DCcodigo)# - #DCdescripcion#<cfelse>#Mid(DCdescripcion,1,48)#...
																		   </cfif>
																		 </a>
																	</td>
																	<td>
																		<input name="btnBorrarCarga" type="image" alt="Eliminar carga" onClick="javascript: return BorrarCarga(#DClinea#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
																	</td>
																</tr>
															</cfloop>
															<input type="hidden" name="DClinea_" value="">
														</table>
													</td>
												</tr>
											</table> <!--- TABLE: cargas --->
										<cf_web_portlet_end>						
									</td>  <!--- TD: cargas --->
								</tr>  <!--- TR: cargas a excluir --->

								<!--- ********************************************************* --->
							</table> <!--- TABLE: mantenimientos agregados --->
						</td> <!--- TD: mantenimientos agregados --->
					</tr> <!--- TR: mantenimientos agregados ---> 
				</cfif> <!--- IF: mantenimientos agregados --->

			</table><!--- TABLE: Mantenimientos --->
		</td> <!--- Mantenimientos --->
		</form>
		</cfoutput>
	</tr> <!--- TR: principal --->
</table> <!--- Principal--->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_LaCantidadDePerIodosAGenerarTieneQueSerMenorQue" Default="La cantidad de períodos a generar tiene que ser menor que 999." returnvariable="MSG_LaCantidadDePerIodosAGenerarTieneQueSerMenorQue" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_LaCantidadDePeriodosAGenerarTieneQueSerMayorQue" Default="La cantidad de períodos a generar tiene que ser mayor que cero." returnvariable="MSG_LaCantidadDePeriodosAGenerarTieneQueSerMayorQue" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_DeseaGenerarEstos" Default="Desea generar estos" returnvariable="MSG_DeseaGenerarEstos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_CalendarioDePago" Default="calendarios de pago?" returnvariable="MSG_CalendarioDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_LaFechaDeInicioEsRequerida" Default="La fecha de inicio es requerida." returnvariable="MSG_LaFechaDeInicioEsRequerida" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCodigoDigitadoYaExisteDebeDigitarUnoQueNoExista" Default="El código digitado ya existe. Debe digitar uno que no exista." returnvariable="MSG_ElCodigoDigitadoYaExisteDebeDigitarUnoQueNoExista" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_ElCampo" Default="El campo " returnvariable="MSG_ElCampo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeContenerUnaFechaValida" Default=" debe contener una fecha válida." returnvariable="MSG_DebeContenerUnaFechaValida" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElValorPara" Default="El valor para" returnvariable="MSG_ElValorPara" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_DebeContenerSolamenteCaracteresAlfanumericos" Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?)." returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericos" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_Codigo" Default="Código" returnvariable="MSG_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Periodo" Default="Periodo" returnvariable="MSG_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Periodo" Default="Periodo" returnvariable="MSG_Periodo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ELValorDelCampo" Default="EL valor del campo" returnvariable="MSG_ELValorDelCampo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSerUnNumeroEntero." Default="debe ser un Número entero." returnvariable="MSG_DebeSerUnNumeroEntero" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_SeRecomiendaElAnnoDelPago" Default="(se recomienda el año del pago)" returnvariable="MSG_SeRecomiendaElAnnoDelPago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_SeRecomiendaElMesDelPago" Default="(se recomienda el mes del pago)" returnvariable="MSG_SeRecomiendaElMesDelPago" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_FechaDesde" Default="Fecha desde" returnvariable="MSG_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_FechaHasta" Default="Fecha hasta" returnvariable="MSG_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_FechaDePago" Default="Fechade pago" returnvariable="MSG_FechaDePago" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_Tipo" Default="Tipo" returnvariable="MSG_Tipo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_CantidadDePeriodosAGenerar" Default="cantidad de periodos a generar" returnvariable="MSG_CantidadDePeriodosAGenerar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_DebeSeleccionarUnTipoDeDeduccion" Default="Debe seleccionar un tipo de deducción" returnvariable="MSG_DebeSeleccionarUnTipoDeDeduccion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_DebeSeleccionarUnTipoDeDeduccionParaEexcluir" Default="Debe seleccionar un tipo de deducción para excluir" returnvariable="MSG_DebeSeleccionarUnTipoDeDeduccionParaEexcluir" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_DebeSeleccionarUnTipoDeDeduccionParaIncluir" Default="Debe seleccionar un tipo de deducción para incluir" returnvariable="MSG_DebeSeleccionarUnTipoDeDeduccionParaIncluir" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_DebeSeleccionarUnConceptoDePago" Default="Debe seleccionar un concepto de pago" returnvariable="MSG_DebeSeleccionarUnConceptoDePago" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_DebeBorrarEsteTipoDeDeduccionDelCalendario" Default="Debe borrar este tipo de deducción del calendario" returnvariable="MSG_DebeBorrarEsteTipoDeDeduccionDelCalendario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaBorrarEsteTipoDeDeduccionDelCalendario" Default="Desea borrar este tipo de deducción del calendario" returnvariable="MSG_DeseaBorrarEsteTipoDeDeduccionDelCalendario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaBorrarEsteConceptoDelCalendario" Default="Desea borrar este concepto de pago del calendario" returnvariable="MSG_DeseaBorrarEsteConceptoDelCalendario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaEliminarCreditoFiscal" Default="Desea eliminar el Crédito Fiscal seleccionado" returnvariable="MSG_DeseaEliminarCreditoFiscal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaEliminarLaCarga" Default="Desea eliminar la carga" returnvariable="MSG_DeseaEliminarCarga" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarCreditoFiscal" Default="Debe seleccionar un Crédito Fiscal" returnvariable="MSG_DebeSeleccionarCreditoFiscal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarCarga" Default="Debe seleccionar una Carga" returnvariable="MSG_SeleccionarCarga" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

<script language="JavaScript" type="text/javascript">
	function deshabilitarValidacion(){
		/*objForm.CPdesde.required = false;*/
		objForm.CPhasta.required = false;
		objForm.CPfpago.required = false;
		//Generacion Automatica
		objFormGenerar.cantPer.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		/*objForm.CPdesde.required = true;*/
		objForm.CPhasta.required = true;
		objForm.CPfpago.required = true;
		//Generacion automatica
		objFormGenerar.cantPer.required = true;
	}
//------------------------------------------------------------------------------------------	
	
	
	function __isCantPeriodos() {
		if (btnSelected("Generar",document.formCalendarioPago)) {
			if(this.value > 0){
				if(this.value > 999){
					this.error = "<cfoutput>#MSG_LaCantidadDePerIodosAGenerarTieneQueSerMenorQue#</cfoutput>";
					this.obj.focus();			
				}
			}else{
				if (this.value <= 0){
					this.error = "<cfoutput>#MSG_LaCantidadDePeriodosAGenerarTieneQueSerMayorQue#</cfoutput>";
					this.obj.focus();
				}
			}
		}
	}
//------------------------------------------------------------------------------------------		

	function confirmacion(form){
		if (!confirm("<cfoutput>#MSG_DeseaGenerarEstos#</cfoutput> " + form.cantPer.value + " <cfoutput>#MSG_CalendarioDePago#</cfoutput>"))
			return false;	
			
		return true;	
	}
//------------------------------------------------------------------------------------------	
	
	function __isValFechIni() {
		if (btnSelected("Generar",document.formCalendarioPago)) {
			if(this.obj.form.CPdesdeIni.value == "" && this.obj.form.ultFechaHasta.value == ""){
				this.error = "<cfoutput>#MSG_LaFechaDeInicioEsRequerida#</cfoutput>";
				this.obj.form.CPdesdeIni.focus();
			}
		}
	}	
//------------------------------------------------------------------------------------------	
	function __isValidaFechaIni() {
		if (btnSelected("Generar",document.formCalendarioPago)) {
			if(this.obj.form.CodTipoPago.value == "2"){	//Quincenal
				var ArrayFechaInicio = this.obj.form.CPdesdeIni.value.split('/');
				
				if((ArrayFechaInicio[0] != '01')&&(ArrayFechaInicio[0] != '15')){
					ArrayFechaInicio[0] = '01';
				}
				
				this.obj.form.CPdesdeIni.value = ArrayFechaInicio[0] + "/" + ArrayFechaInicio[1] + "/" + ArrayFechaInicio[2];
			}else{
				if(this.obj.form.CodTipoPago.value == "3"){	//Mensual
					var ArrayFechaInicio = this.obj.form.CPdesdeIni.value.split('/');
					if(ArrayFechaInicio[0] != "01"){
						ArrayFechaInicio[0] = "01";
					}
					
					this.obj.form.CPdesdeIni.value = ArrayFechaInicio[0] + "/" + ArrayFechaInicio[1] + "/" + ArrayFechaInicio[2];									
				}
			}
		}
	}	
//------------------------------------------------------------------------------------------
	
	function __isCodigoValido() {
		var existe = new Boolean;
		existe = false;
		<cfoutput query="rsCPcodigos">
			if ('#CPcodigo#'==this.value<cfif modo NEQ 'ALTA'>&&'#rsCalenPago.CPcodigo#'!=this.value</cfif>)
				existe = true;
		</cfoutput>
		if (existe)
			this.error = "<cfoutput>#MSG_ElCodigoDigitadoYaExisteDebeDigitarUnoQueNoExista#</cfoutput>"
	}
//------------------------------------------------------------------------------------------	
	
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "<cfoutput>#MSG_ElCampo#</cfoutput>" + this.description + " <cfoutput>#MSG_DebeContenerUnaFechaValida#</cfoutput>";
	}
//------------------------------------------------------------------------------------------	
	
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="<cfoutput>#MSG_ElValorPara#</cfoutput>"+this.description+"<cfoutput>#MSG_DebeContenerSolamenteCaracteresAlfanumericos#</cfoutput>";
		}
	}
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValFechIni", __isValFechIni);	
	_addValidator("isCantPeriodos", __isCantPeriodos);
	_addValidator("isValidaFechaIni", __isValidaFechaIni);
	_addValidator("isCodigo", __isCodigoValido);
	_addValidator("isFecha", _Field_isFecha);
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	
	//Instancias de qForms
	objForm = new qForm("formCalendarioPago");
	objFormGenerar = new qForm("formGenerar");
	objFormFiltro = new qForm("formfiltro");
	
	//Mantenimiento Calendario
	objForm.CPcodigo.required = true;
	objForm.CPcodigo.description = "<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.CPcodigo.validateCodigo();
	//objForm.CPcodigo.validateFormat("xxxx-xx-xxx");
	
	objForm.CPperiodo.required = true;
	objForm.CPperiodo.description = "<cfoutput>#MSG_Periodo#</cfoutput>";
	objForm.CPperiodo.validateNumeric("<cfoutput>#MSG_ELValorDelCampo#</cfoutput> " + objForm.CPperiodo.description + " <cfoutput>#MSG_DebeSerUnNumeroEntero#</cfoutput> <cfoutput>#MSG_SeRecomiendaElAnnoDelPago#</cfoutput>");
	
	objForm.CPmes.required = true;
	objForm.CPmes.description = "Mes";
	objForm.CPmes.validateNumeric("<cfoutput>#MSG_ELValorDelCampo#</cfoutput>" + objForm.CPmes.description + " <cfoutput>#MSG_DebeSerUnNumeroEntero#</cfoutput> <cfoutput>#MSG_SeRecomiendaElMesDelPago#</cfoutput>");

	objForm.CPhasta.required = true;
	objForm.CPhasta.description = "<cfoutput>#MSG_FechaHasta#</cfoutput>";
	objForm.CPhasta.validateFecha();
	
	objForm.CPfpago.required = true;
	objForm.CPfpago.description = "<cfoutput>#MSG_FechaDePago#</cfoutput>";
	objForm.CPfpago.validateFecha();
	
	objForm.CPdescripcion.description = "<cfoutput>#LB_DESCRIPCION#</cfoutput>";
	
	objForm.CPtipo.required = true;
	objForm.CPtipo.description = "<cfoutput>#MSG_Tipo#</cfoutput>";
	
	objForm.CPhasta.obj.focus();
	
	//Generacion automatica
	objFormGenerar.cantPer.required = true;
	objFormGenerar.cantPer.description = "<cfoutput>#MSG_CantidadDePeriodosAGenerar#</cfoutput>";
	objFormGenerar.Generar.validateValidaFechaIni();
	objFormGenerar.Generar.validateValFechIni();
	objFormGenerar.cantPer.validateCantPeriodos();
	objFormGenerar.CPAdesdeIni.required = false;
	objFormGenerar.CPAdesdeIni.description = "<cfoutput>#MSG_FechaDeInicioDeAnticipos#</cfoutput>";

	//Form Filtro
	objFormFiltro.fCPcodigo.validateAlfaNumerico();
	objFormFiltro.fCPdesde.validateFecha();
	objFormFiltro.fCPhasta.validateFecha();
	objFormFiltro.fCPfpago.validateFecha();
	
//------------------------------------------------------------------------------------------							
</script>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisTipoDeduccion() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=formCalendarioPago&id=TDid&desc=TDdescripcion",250,200,400,350);
	}
	
	function doConlisTipoDeduccionEx() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=formCalendarioPago&id=exTDid&desc=exTDdescripcion",250,200,400,450);
	}
	
	function doConlisTipoDeduccionIn() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=formCalendarioPago&id=inTDid&desc=inTDdescripcion",250,200,400,450);
	}

	activa_desactiva();

	function activa_desactiva() 
	{ 
		var f = document.formCalendarioPago;				
				
		<cfif modo NEQ 'ALTA'>
			var tablaDetalles_cp = document.getElementById('detalles_cp');
			//var tablaDetalles_td = document.getElementById('detalles_td');
		</cfif>
		
		// Tipo: Especial = 1, Normal = 0, Anticipo = 2, 4 = PTU, 5 = Fondo Ahorro
		if (f.CPtipo.value == '1')  
		{		
	
			// los habilita
			f.CPnorenta.disabled = false;
			f.CPnocargasley.disabled = false;
			f.CPnocargas.disabled = false;
			f.CPnodeducciones.disabled = false;
			f.CPnodeducciones.disabled = false;
			
			try{
			document.getElementById("Replicar").style.visibility = 'visible';
			}catch(err){};

			// los chequea/deschequea como estaban originalmente
			f.CPnorenta.checked = f.CPnorenta.defaultChecked;
			f.CPnocargasley.checked = f.CPnocargasley.defaultChecked;
			f.CPnocargas.checked = f.CPnocargas.defaultChecked;			
			
			//No Solicitar fecha desde
			document.getElementById("fdesde").style.display = 'none';
			document.getElementById("Lfdesde").style.display = 'none';	
			document.getElementById("LbTablaImpuesto").style.display = '';
			document.getElementById("ConLisTablaImpuesto").style.display = '';
					
			
				// muestra los mantenimientos de Tipos de Deducción y Conceptos de Pago
				<cfif modo NEQ 'ALTA'>
					tablaDetalles_cp.style.display = '';
					//tablaDetalles_td.style.display = '';
				</cfif>	
		}
		else 
		{
			if (f.CPtipo.value == '0'){// PARA NOMINA NORMAL
				// los deschequea
				f.CPnorenta.checked = false;
				f.CPnocargasley.checked = false;
				f.CPnocargas.checked = false;
				f.CPnodeducciones.checked = false;
				try{
				document.getElementById("Replicar").style.visibility = 'hidden';
				}catch(err){};
				// los deshabilita
				f.CPnorenta.disabled = true;
				f.CPnocargasley.disabled = true;
				f.CPnocargas.disabled = true;
				f.CPnodeducciones.disabled = true;

				//Solicitar fecha desde
				document.getElementById("fdesde").style.display = '';
				document.getElementById("Lfdesde").style.display = '';			
				document.getElementById("LbTablaImpuesto").style.display = 'none';
				document.getElementById("ConLisTablaImpuesto").style.display = 'none';
			}else if (f.CPtipo.value == '2'){ //PARA NOMINA ANTICIPO
				// los habilita
				f.CPnorenta.disabled = false;
				f.CPnocargasley.disabled = false;
				f.CPnocargas.disabled = false;
				f.CPnodeducciones.disabled = false;
				try{
				document.getElementById("Replicar").style.visibility = 'hidden';
				}catch(err){};
				// los chequea/deschequea como estaban originalmente
				<cfif not isdefined('rsCalenPago')>
				f.CPnorenta.checked = true;
				f.CPnocargasley.checked = true;


				f.CPnocargas.checked = true;
				f.CPnodeducciones.checked = true;	
				</cfif>

				//Solicitar fecha desde
				document.getElementById("fdesde").style.display = '';
				document.getElementById("Lfdesde").style.display = '';	
				document.getElementById("LbTablaImpuesto").style.display = 'none';
				document.getElementById("ConLisTablaImpuesto").style.display = 'none';
			}else if (f.CPtipo.value == '4'){ //PARA PTU 
				// los habilita
				f.CPnorenta.disabled = true;
				f.CPnocargasley.disabled = true;
				f.CPnocargas.disabled = true;
				f.CPnodeducciones.disabled = true;
				try{
				document.getElementById("Replicar").style.visibility = 'hidden';
				}catch(err){};
				// los chequea/deschequea como estaban originalmente
				f.CPnorenta.checked = false;
				f.CPnocargasley.checked = true;
				f.CPnocargas.checked = true;
				f.CPnodeducciones.checked = true;	
				
				//No Solicitar fecha desde
				document.getElementById("fdesde").style.display = 'none';
				document.getElementById("Lfdesde").style.display = 'none';
				document.getElementById("LbTablaImpuesto").style.display = 'none';
				document.getElementById("ConLisTablaImpuesto").style.display = 'none';
			}
			else if (f.CPtipo.value == '5'){ //PARA FONDO DE AHORRO SML
				// los habilita
				f.CPnorenta.disabled = true;
				f.CPnocargasley.disabled = true;
				f.CPnocargas.disabled = true;
				f.CPnodeducciones.disabled = true;
				try{
				document.getElementById("Replicar").style.visibility = 'hidden';
				}catch(err){};
				// los chequea/deschequea como estaban originalmente
				f.CPnorenta.checked = true;
				f.CPnocargasley.checked = true;
				f.CPnocargas.checked = true;
				f.CPnodeducciones.checked = false;	
				
				//No Solicitar fecha desde
				document.getElementById("fdesde").style.display = 'none';
				document.getElementById("Lfdesde").style.display = 'none';
				document.getElementById("LbTablaImpuesto").style.display = 'none';
				document.getElementById("ConLisTablaImpuesto").style.display = 'none';
			}		
		}
		/*??????Manejo del Tipo de Calculo de Renta??????*/	
			if (f.CPtipo.value == '0') //Normal 
			{	
				<!---CarolRS--->
				<cfif #vUsaSBC# EQ 1>
					if (!document.getElementById("CPnorenta").checked)
						document.getElementById("TDCPTipoCalRenta").style.display = '';	
					 else 
						document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
					document.getElementById("CPTipoCalRenta2").disabled="disabled";	
				
					if(document.formCalendarioPago.CPTipoCalRenta.selectedIndex == 1)
						document.formCalendarioPago.CPTipoCalRenta.selectedIndex = 0
				</cfif>
			}
			else if (f.CPtipo.value == '1') //Especial
			{	
				<!---CarolRS--->
				<cfif #vUsaSBC# EQ 1>
					if (!document.getElementById("CPnorenta").checked)
						document.getElementById("TDCPTipoCalRenta").style.display = '';
					else 
						document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
					document.getElementById("CPTipoCalRenta2").disabled="";	
				</cfif>
			}
			else if (f.CPtipo.value == '2')  //Anticipo
			{
				<!---CarolRS--->
				<cfif #vUsaSBC# EQ 1>
				document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
				</cfif>
			}
			else if (f.CPtipo.value == '3')  //Retroactivos
			{	
				<!---CarolRS--->
				<cfif #vUsaSBC# EQ 1>
				document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
				</cfif>
			}
			else if (f.CPtipo.value == '4')  //PTU
			{
				<!---CarolRS--->
				<cfif #vUsaSBC# EQ 1>
				document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
				</cfif>
			}
			else if (f.CPtipo.value == '5')  //Fondo Ahorro SML
			{
				<cfif #vUsaSBC# EQ 1>
				document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
				</cfif>
			}
		
	}

	function validaTipoDeduccion() {
		if (trim(document.formCalendarioPago.TDdescripcion.value) == "") 
		{
			alert('<cfoutput>#MSG_DebeSeleccionarUnTipoDeDeduccion#</cfoutput>');
			return false;
		}
		return true;
	}

	function validaTipoDeduccionEx() {
		if (trim(document.formCalendarioPago.exTDdescripcion.value) == "") 
		{
			alert('<cfoutput>#MSG_DebeSeleccionarUnTipoDeDeduccionParaEexcluir#</cfoutput>');
			return false;
		}
		return true;
	}
	
	function validaTipoDeduccionIn() {
		if (trim(document.formCalendarioPago.inTDdescripcion.value) == "") 
		{
			alert('<cfoutput>#MSG_DebeSeleccionarUnTipoDeDeduccionParaIncluir#</cfoutput>');
			return false;
		}
		return true;
	}
	
	
	function funcMasivo(){
		if(confirm('<cfoutput>#MSG_ExcluirDeducciones#</cfoutput>')){
			return true;
		}
		else{return false;}		
	}

	function validaConcepto() {
		if (trim(document.formCalendarioPago.CIcodigo.value) == "") 
		{
			alert('<cfoutput>#MSG_DebeSeleccionarUnConceptoDePago#</cfoutput>');
			return false;
		}
		return true;
	}

	function validaCredito() {
		if (trim(document.formCalendarioPago.CDid.value) == "") 
		{
			alert('<cfoutput>#MSG_DebeSeleccionarCreditoFiscal#</cfoutput>');
			return false;
		}
		return true;
	}

	function BorrarTipoDeduccion(id) 
	{
		if (confirm("<cfoutput>#MSG_DebeBorrarEsteTipoDeDeduccionDelCalendario#</cfoutput>")) {	
			var f = document.formCalendarioPago;
			f.TDid_.value = id;
			f.submit();
			return true;
		}
		return false;
	}		

	function BorrarTipoDeduccionEx(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaBorrarEsteTipoDeDeduccionDelCalendario#</cfoutput>")) {	
			var f = document.formCalendarioPago;
			f.btnBorrarDeduccionEx.value = 'BORRAR';
			f.exTDid_.value = id;
			f.submit();
			return true;
		}
		return false;
	}	
	
	function BorrarTipoDeduccionIn(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaBorrarEsteTipoDeDeduccionDelCalendario#</cfoutput>")) {	
			var f = document.formCalendarioPago;
			f.btnBorrarDeduccionIn.value = 'BORRAR';
			f.inTDid_.value = id;
			f.submit();
			return true;
		}
		return false;
	}		

	function limpiar(){
	document.formCalendarioPago.reset();
	}


	function BorrarConcepto(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaBorrarEsteConceptoDelCalendario#</cfoutput>")) {
			var f = document.formCalendarioPago;
			f.CIid_.value = id;
			f.btnBorrarConcepto.click()
			f.submit();
			return true;
		}
		return false;
	}

	function BorrarCredito(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaEliminarCreditoFiscal#</cfoutput>?")) {
			var f = document.formCalendarioPago;
			f.CDid_.value = id;
			f.btnBorrarCredito.click()
			f.submit();
			return true;
		}
		return false;
	}

	function BorrarCarga(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaEliminarCarga#</cfoutput>?")) {
			var f = document.formCalendarioPago;
			f.DClinea_.value = id;
			f.btnBorrarCarga.click()
			f.submit();
			return true;
		}
		return false;
	}
	
	function habilitaFecha(obj){
		var fecha = document.getElementById('fechaA');
		var Lfecha = document.getElementById('LabelfechaA');
		var form = document.formGenerar;
	
		if (obj.checked){
			fecha.style.display = '';
			Lfecha.style.display = '';
			objFormGenerar.CPAdesdeIni.required = true;
		}else{
			fecha.style.display = 'none';
			Lfecha.style.display = 'none';
			objFormGenerar.CPAdesdeIni.required = false;
		}
	}
	
	function funcReplicar(){
		document.formCalendarioPago.action = 'calendarioReplicar.cfm';
	}
	
	function funcCargaPeriodoMes(){//========== Pre-carga el periodo (año) y mes tomandolo de la fecha de pago ==========
		var vs_fecha='';
		vs_fecha = document.formCalendarioPago.CPfpago.value.split("/");
		if (vs_fecha != ''){
			document.formCalendarioPago.CPperiodo.value = vs_fecha[2];
			document.formCalendarioPago.CPmes.value = vs_fecha[1];
		}
		else{
			document.formCalendarioPago.CPperiodo.value = '';
			document.formCalendarioPago.CPmes.value = '';
		}
	}	
	function validaCarga() {
		if (trim(document.formCalendarioPago.DClinea.value) == "") 
		{
			alert('<cfoutput>#MSG_SeleccionarCarga#</cfoutput>');
			return false;
		}
		return true;
	}
	
	function mostrarCargas(){
		<cfif modo neq 'ALTA'>
			var tr_cargas = document.getElementById("tr_cargas");
			if ( document.formCalendarioPago.CPtipo.value == 0 || document.formCalendarioPago.CPtipo.value == 4  || (document.formCalendarioPago.CPnocargasley.checked || document.formCalendarioPago.CPnocargas.checked)  ){
				tr_cargas.style.display = 'none';
			}
			else{
				if ( (document.formCalendarioPago.CPtipo.value != 0 || document.formCalendarioPago.CPtipo.value != 4) && (!document.formCalendarioPago.CPnocargasley.checked && !document.formCalendarioPago.CPnocargas.checked) ){
					tr_cargas.style.display = '';
				}
			}
		</cfif>	
	}
	
	function mostrarDeducciones(){
		<cfif modo neq 'ALTA'>
			var tr_deduc = document.getElementById("tr_deducciones");
			if ( document.formCalendarioPago.CPtipo.value == 0 || document.formCalendarioPago.CPtipo.value == 4  || (document.formCalendarioPago.CPnodeducciones.checked)  ){
				tr_deduc.style.display = 'none';
			}
			else{
				if ( (document.formCalendarioPago.CPtipo.value != 0 || document.formCalendarioPago.CPtipo.value != 4) && (!document.formCalendarioPago.CPnodeducciones.checked) ){
					tr_deduc.style.display = '';
				}
			}
		</cfif>	
	}
	
	function changeNoRenta()
	{
		<!---CarolRS--->
		<cfif #vUsaSBC# EQ 1>
			if (!document.getElementById("CPnorenta").checked)
				document.getElementById("TDCPTipoCalRenta").style.display = '';	
			else 
				document.getElementById("TDCPTipoCalRenta").style.display = 'none';	
		</cfif>
	}
	
</script>