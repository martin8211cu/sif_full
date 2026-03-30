	
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Titulo" default="Registro de Tablas Salariales" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_EvaluaciondelDesempeno" default="Evaluaci&oacute;n del Desempeño" returnvariable="LB_EvaluaciondelDesempeno" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_FechaRige" default="Fecha Rige" returnvariable="MSG_FechaRige" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_ListaVigencias" default="Lista de Vigencias" returnvariable="LB_ListaVigencias" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_FechaHasta" default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Estado" default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_SeleccionarVigencia" default="Debe seleccionar una vigencia." returnvariable="MSG_SeleccionarVigencia" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_CrearVigencia" default="La fecha ingresada ya esta asociada a una vigencia existente. Desea reemplazarla?" returnvariable="MSG_CrearVigencia" component="sif.Componentes.Translate" method="Translate"/>			

<cfinvoke key="LB_Aplicado" default="Aplicado" returnvariable="LB_Aplicado" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente"   xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_VigenciaSustituidaConsulta" default="Vigencia Sustituida sólo consulta" returnvariable="LB_VigenciaSustituidaConsulta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Indefinido" default="Indefinido" xmlFile="/rh/generales.xml" returnvariable="LB_Indefinido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CopiaVersion" default="Copia Versión" returnvariable="LB_CopiaVersion" component="sif.Componentes.Translate" method="Translate"/>


<!--- FIN VARIABLES DE TRADUCCION --->
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- VARIABLES URL --->
<cfif (isdefined('url.RHVTidL')or isdefined('form.RHVTidL')) and not isdefined("form.RHVTid")><cfset form.RHVTid = url.RHVTidL></cfif>
<cfif isdefined('form.RHVTidL') and (not isdefined("form.RHVTid") or LEN(TRIM(form.RHVTid)) EQ 0)><cfset form.RHVTid = form.RHVTidL></cfif>
<cfif isdefined('form.RHVTid') and (not isdefined("form.RHVTidL") or LEN(TRIM(form.RHVTidL)) EQ 0)><cfset form.RHVTidL = form.RHVTid></cfif>

<!--- FIN VARIABLES URL --->
<cfset filtro = ''>
<cfset navegacion = "RHTTid=" & Form.RHTTid>
<cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" type="numeric" default="1">
<cfset Modificable = false>

<!---<cfquery name="rsFechasVigenvia" datasource="#session.dsn#">
    select RHVTid, RHTTid, RHVTfecharige, RHVTestado
    from RHVigenciasTabla
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
        and RHVTestado = 'A'
</cfquery>

<cfdump var="#rsFechasVigenvia#">--->
<cf_dbfunction name="to_date"	  args="'01-01-6100'"   returnvariable="lvar_fechaIndefinidaDate">	
<cfif session.idioma eq 'en'>
	<cf_dbfunction name="date_format" args="RHVTfechahasta,mm/dd/yyyy" returnvariable="lvar_fechaHasta">	
	<cf_dbfunction name="date_format" args="#lvar_fechaIndefinidaDate#~mm/dd/yyyy" delimiters="~" returnvariable="lvar_fechaIndefinida">
<cfelse>	
	<cf_dbfunction name="to_sdatedmy" args="RHVTfechahasta" returnvariable="lvar_fechaHasta">
	<cf_dbfunction name="to_sdatedmy" args="#createdate(6100,01,01)#" returnvariable="lvar_fechaIndefinida">
</cfif>

<cf_dbfunction name="to_char" args="x.RHVTcodigo" returnvariable="lvar_RHVTcodigo">
<cf_dbfunction name="to_char"	args="RHVTnumcopia"  returnvariable="lvar_RHVTnumcopia">

<cf_dbfunction name="op_concat" returnvariable="_cat">

<cfquery  name="rsMonedas" datasource="#session.DSN#">
    select a.Mcodigo, b.Mnombre
    from RHMonedas a
    inner join Monedas b
        on a.Mcodigo = b.Mcodigo
    where a.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif isdefined('form.RHVTid')>
	<cfset form.modoV = 'CAMBIO'> 
	<cf_translatedata name="validar" tabla="RHVigenciasTabla" col="RHVTdescripcion" filtro="RHVTid = #Form.RHVTid#"/>
	<cf_translatedata name="get" tabla="RHVigenciasTabla" col="RHVTdescripcion" returnvariable="LvarRHVTdescripcion">	
	<cf_dbfunction name="op_concat" returnvariable="concat"	>
	<cfquery name="rsRHVigenciasTabla" datasource="#session.dsn#">
		select RHVTid, RHTTid, RHVTfecharige, RHVTestado, 
			   case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#'  when 'C' then '#LB_VigenciaSustituidaConsulta#' else RHVTestado end as RHVTestadodesc, 
			   case #preservesinglequotes(lvar_fechaHasta)# when #preservesinglequotes(lvar_fechaIndefinida)# then '#LB_Indefinido#' else #preservesinglequotes(lvar_fechaHasta)# end as RHVTfechahasta, 
			   case RHVTfechahasta when #preservesinglequotes(lvar_fechaIndefinidaDate)# then #preservesinglequotes(lvar_fechaIndefinidaDate)# else RHVTfechahasta end as RHVTfechahastaDate, 
			   case when RHVTtablabase is null then '' else (select #lvar_RHVTcodigo# #concat#' '#concat# #LvarRHVTdescripcion# from RHVigenciasTabla x where x.RHVTid = RHVigenciasTabla.RHVTtablabase) end as RHVTtablabaseDesc, 
			   RHVTdocumento, #LvarRHVTdescripcion# as RHVTdescripcion, ts_rversion, RHVTestado,RHVTtablabase,coalesce(Mcodigo,0) Mcodigo ,RHVTtipocambio
		from RHVigenciasTabla
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
		  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
		  order by RHVTfecharige,RHVTfechahasta
	</cfquery>
	<cfif modoV EQ 'CAMBIO'>
		<cfset Lvar_botones = 'Modificar,Eliminar,Nuevo'>
	</cfif>
	<cfif rsRHVigenciasTabla.RHVTestado EQ 'P'>
		<cfset Modificable = true>
	<cfelse>
		<cfset Modificable = false>
		<cfset Lvar_botones = 'Nuevo'>
	</cfif>
<cfelse>
	<cfset form.modoV = 'ALTA'>
	<cfset Lvar_botones = 'Agregar,Limpiar'>
</cfif>
<!--- CONSULTAS --->

<!--- FIN CONSULTA --->
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
	<form action="Vigencias-sql.cfm" method="post" name="formV">
		<input name="SEL" type="hidden" value="2" />
		<input name="modo" type="hidden" value="" />
		<input name="modov" type="hidden" value="<cfif isdefined('form.modov') and LEN(TRIM(form.modov))><cfoutput>#form.modov#</cfoutput></cfif>" />
		<input name="RHTTid" type="hidden" value="<cfif isdefined('form.RHTTid')><cfoutput>#form.RHTTid#</cfoutput></cfif>" />
		<input name="RHVTidL" type="hidden" value="<cfif isdefined('form.RHVTid')><cfoutput>#form.RHVTid#</cfoutput></cfif>" />
		<table width="95%" cellpadding="2" cellspacing="0">
			<tr>
				<td>
					<table width="95%" cellpadding="2" cellspacing="0" align="center" border="0">
						<tr>
							<td nowrap><strong>&nbsp;</strong></td>
							<td><strong><cf_translate key="LB_Rige">Rige</cf_translate></strong></td>
							<td><strong><cf_translate key="LB_Hasta">Hasta</cf_translate></strong></td>
							<td><strong><cf_translate key="LB_TablaBase">Tabla Base</cf_translate></strong></td>
                            <td nowrap><strong><cf_translate key="LB_Moneda">Moneda </cf_translate></strong></td>
						</tr>
						<tr>
							<td nowrap><strong>&nbsp;</strong></td>
							<td>
								<cfoutput>
                                     
									<cfif (MODOV neq "ALTA")>
										<cfif Modificable>
											<cf_sifcalendario name="RHVTfecharige" value="#rsRHVigenciasTabla.RHVTfecharige#" tabindex="1" form="formV">
										<cfelse>
											<cf_sifcalendario name="RHVTfecharige" value="#rsRHVigenciasTabla.RHVTfecharige#" readonly="true" tabindex="1" form="formV">
										</cfif>
									<cfelse>
										<cf_sifcalendario name="RHVTfecharige" tabindex="1" form="formV"> 
									</cfif>
								</cfoutput>
							</td>
							<cfoutput><td><cfif (MODOV neq "ALTA")><cf_sifcalendario name="RHVTfechahasta" value="#rsRHVigenciasTabla.RHVTfechahastaDate#" readonly="true" tabindex="1" form="formV"><cfelse>#LB_Indefinido#</cfif></td></cfoutput>
							<td>
								<cfif (MODOV neq "ALTA")>
									<cfif Modificable>
										<cfset ArrayTB=ArrayNew(1)>
										<cfif LEN(TRIM(rsRHVigenciasTabla.RHVTtablabase))>
											<cfquery name="rsTB" datasource="#session.DSN#">
												select *
												from RHVigenciasTabla
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHVigenciasTabla.RHVTtablabase#">
												  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
											</cfquery>
											<cfset ArrayAppend(ArrayTB,rsTB.RHVTid)>
											<cfset ArrayAppend(ArrayTB,rsTB.RHVTcodigo)>
											<cfset ArrayAppend(ArrayTB,rsTB.RHVTdescripcion)>
										</cfif>
										<cf_translatedata name="get" tabla="RHVigenciasTabla" col="RHVTdescripcion" returnvariable="LvarRHVTdescripcion">
										<cf_conlis 
											campos="RHVTidref,RHVTcodigoref,RHVTdescripcionref"
											size="0,10,20"
											desplegables="N,S,S"
											modificables="N,N,N"
											title="#LB_ListaVigencias#"
											tabla="RHVigenciasTabla"
											columnas="RHTTid,RHVTcodigo as RHVTcodigoref,#LvarRHVTdescripcion# as RHVTdescripcionref,RHVTid as RHVTidref,RHVTfecharige,case #lvar_fechaHasta# when #lvar_fechaIndefinida# then '#LB_Indefinido#' else #lvar_fechaHasta# end as RHVTfechahasta,case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#' else RHVTestado end as RHVTestado"
											filtro="Ecodigo = #session.Ecodigo# and RHTTid = #Form.RHTTid# and RHVTestado = 'A' #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTestado"
											filtrar_por="RHVTcodigoref,RHVTdescripcionref,RHVTfecharige,RHVTfechahasta,RHVTestado"
											desplegar="RHVTcodigoref,RHVTdescripcionref,RHVTfecharige,RHVTfechahasta,RHVTestado"
											etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_FechaRige#,#LB_FechaHasta#,#LB_Estado#"
											formatos="I,S,D,S,S"
											align="left,left"
											asignar="RHVTidref,RHVTcodigoref,RHVTdescripcionref"
											asignarFormatos="S,S,S"
											form="formV"
											showEmptyListMsg="true"
											ValuesArray="#ArrayTB#" />
									<cfelse>
										<cfoutput><cfif len(trim(rsRHVigenciasTabla.RHVTtablabaseDesc))>#rsRHVigenciasTabla.RHVTtablabaseDesc#<cfelse>#LB_Indefinido#</cfif></cfoutput>
									</cfif>
								<cfelse>
									<cf_translatedata name="get" tabla="RHVigenciasTabla" col="RHVTdescripcion" returnvariable="LvarRHVTdescripcion">
									<cf_conlis 
										campos="RHVTidref,RHVTcodigoref,RHVTdescripcionref"
										size="0,10,20"
										desplegables="N,S,S"
										modificables="N,N,N"
										title="#LB_ListaVigencias#"
										tabla="RHVigenciasTabla"
										columnas="RHTTid,RHVTcodigo as RHVTcodigoref,#LvarRHVTdescripcion# as RHVTdescripcionref,RHVTid as RHVTidref,RHVTfecharige,case #lvar_fechaHasta# when #lvar_fechaIndefinida# then '#LB_Indefinido#' else #lvar_fechaHasta# end as RHVTfechahasta,case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#' else RHVTestado end as RHVTestado"
										filtro="Ecodigo = #session.Ecodigo# and RHTTid = #Form.RHTTid# and RHVTestado = 'A' #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTestado"
										filtrar_por="RHVTcodigo,RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTestado"
										desplegar="RHVTcodigoref,RHVTdescripcionref,RHVTfecharige,RHVTfechahasta,RHVTestado"
										etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_FechaRige#,#LB_FechaHasta#,#LB_Estado#"
										formatos="I,S,D,S,S"
										align="left,left"
										asignar="RHTTid,RHVTidref,RHVTcodigoref,RHVTdescripcionref"
										asignarFormatos="S,S,S"
										form="formV"
										showEmptyListMsg="true"/>
								</cfif>
							</td>
                             <td >
								<cfoutput> 
								<cfinvoke key="LB_SeleccioneTipoMoneda" default="Seleccione Tipo Moneda"  returnvariable="LB_SeleccioneTipoMoneda" component="sif.Componentes.Translate" method="Translate"/>

                                <select name="Mcodigo" id="Mcodigo" tabindex="1"> 
                                    <option  title="" value="">-- #LB_SeleccioneTipoMoneda# --</option>
                                    <cfloop query="rsMonedas">
                                        <option  title="#rsMonedas.Mcodigo#" value="#rsMonedas.Mcodigo#" <cfif modoV neq "ALTA" and isdefined('rsRHVigenciasTabla') and rsRHVigenciasTabla.Mcodigo eq rsMonedas.Mcodigo>selected</cfif> >#rsMonedas.Mnombre#</option>
                                    </cfloop>
                                </select>
                                </cfoutput>
                            </td>
						</tr>
					  <tr>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap ><strong><cf_translate key="LB_Documento_Autoriza">Documento que autoriza </cf_translate> </strong></td>
						<td nowrap><strong><cf_translate key="LB_Descripcion">Descripción </cf_translate></strong></td>
                        <td nowrap><strong>&nbsp;</strong></td>
                        <td nowrap><strong><cf_translate key="LB_Tipo_Cambio">Tipo Cambio </cf_translate></strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>
							<input type="text"
								name="RHVTdocumento" id="RHVTdocumento"
								onFocus="javascript:this.select();"
								maxlength="80"
								<cfif not Modificable and MODOV neq "ALTA">style= "border=0;"</cfif>
								<cfif not Modificable and MODOV neq "ALTA">readonly=""</cfif>
								size="40"
								tabindex="1"
								value="<cfif (MODOV neq "ALTA")><cfoutput>#HTMLEditFormat(rsRHVigenciasTabla.RHVTdocumento)#</cfoutput></cfif>">
						</td>
						<td colspan="2">
							<input type="text"
								name="RHVTdescripcion" id="RHVTdescripcion"
								onFocus="javascript:this.select();"
								<cfif not Modificable and MODOV neq "ALTA">style= "border=0;"</cfif>
								<cfif not Modificable and MODOV neq "ALTA">readonly=""</cfif>
								maxlength="60"
								size="40"
								tabindex="1"
								value="<cfif (MODOV neq "ALTA")><cfoutput>#HTMLEditFormat(rsRHVigenciasTabla.RHVTdescripcion)#</cfoutput></cfif>">
						</td>
                        <td>
	                        <cfif modoV neq "ALTA" and isdefined('rsRHVigenciasTabla') >
	                            <cf_inputNumber name="RHVTtipocambio"  value="#rsRHVigenciasTabla.RHVTtipocambio#" enteros="15" decimales="2" negativos="false" comas="no">
                            <cfelse>
                            	<cf_inputNumber name="RHVTtipocambio"  value="1.00" enteros="15" decimales="2" negativos="false" comas="no">
                            </cfif>
                        </td>
					  </tr>
					  <tr><td colspan="5"><cf_botones names="#Lvar_botones#" values="#Lvar_botones#"></td></tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td valign="top">
					 <cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRHRet">
						<cfinvokeargument name="tabla" value="RHVigenciasTabla"/>
						<cfinvokeargument name="columnas" value="RHVTid as RHVTid, RHVTcodigo as RHVTcodigoL, 
								RHVTfecharige as RHVTfecharigeL,
								case #lvar_fechaHasta# when #lvar_fechaIndefinida# then '#LB_Indefinido#' else #lvar_fechaHasta# end as RHVTfechahastaL,
								case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#'  when 'C' then '#LB_CopiaVersion# ' #_cat# #preservesinglequotes(lvar_RHVTnumcopia)# else RHVTestado end as RHVTestadoL, 
								 #form.PAGENUMPADRE# as PAGENUMPADRE, #form.sel# as selL"/>
						<cfinvokeargument name="desplegar" value="RHVTfecharigeL,RHVTfechahastaL,RHVTestadoL"/>
						<cfinvokeargument name="etiquetas" value="#LB_FechaRige#,#LB_FechaHasta#,#LB_Estado#"/>
						<cfinvokeargument name="formatos" value="D,S,S"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# and RHTTid = #Form.RHTTid# #filtro# order by RHVTfecharige, RHVTfechahasta, RHVTnumcopia  desc,RHVTestado"/>
						<cfinvokeargument name="align" value="center,center,center"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="tipoTablasSal.cfm"/>
						<cfinvokeargument name="maxRows" value="20"/>
						<cfinvokeargument name="keys" value="RHVTid"/>
						<cfinvokeargument name="formName" value="formV"/>
						<cfinvokeargument name="incluyeform" value="no"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>  
					
				</td>	
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<cfif (isdefined('form.RHVTIDL') and form.RHVTIDL GT 0 ) or (isdefined('form.RHVTID') and form.RHVTID GT 0 )>
					<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente"  formName="formV">
					<cfelse>
					<cf_botones values="Anterior" names="Anterior"  formName="formV">
					</cfif>
				</td>
			</tr>
		</table>	
	</form>
 <cf_qforms objForm="objForm" form='formV'>
	<cf_qformsrequiredfield args="RHVTfecharige,#MSG_FechaRige#">
</cf_qforms>	 
<script>
	function funcSiguiente(){
		deshabilitarValidacion();
		document.formV.SEL.value = "3";
		document.formV.action = "tipoTablasSal.cfm";
		return true;
	}
	function funcAnterior(){
		deshabilitarValidacion();
		document.formV.SEL.value = "1";
		document.formV.action = "tipoTablasSal.cfm";
		return true;
	}
	
	function habilitarValidacion(){
		objForm.RHVTfecharige.required = true;
	}
		
	function deshabilitarValidacion(){
			objForm.RHVTfecharige.required = false;
	}	

	function funcNuevo(){
		objForm.RHVTfecharige.required = false;
	}

</script>