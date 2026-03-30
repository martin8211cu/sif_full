
<!--- 
	Nombre: formComponentes.cfm
	Descripción: Formulario de Componentes Salariales
--->
<!--- Parámetros iniciales --->
<cfif isdefined("url.RHCAid") and not isdefined("form.RHCAid")><cfset form.RHCAid = url.RHCAid></cfif>
<cfif isdefined("url.CSid") and not isdefined("form.CSid")><cfset form.CSid = url.CSid></cfif>
<cfif isdefined("url.RHMCid") and not isdefined("form.RHMCid")><cfset form.RHMCid = url.RHMCid></cfif>
<cfif isdefined("url.PAGENUMABUELO") and not isdefined("form.PAGENUMABUELO")><cfset form.PAGENUMABUELO = url.PAGENUMABUELO></cfif>
<cfif isdefined("url.PAGENUMPADRE") and not isdefined("form.PAGENUMPADRE")><cfset form.PAGENUMPADRE = url.PAGENUMPADRE></cfif>
<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
<cfif isdefined("form.Metodos")>
		<cfset form.PAGENUMABUELO = form.PAGENUMPADRE>
		<cfset form.PAGENUMPADRE = form.PAGENUM>
		<cfset form.PAGENUM = 1>
</cfif>
<cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" type="numeric" default="1">
<cfparam name="form.PAGENUMABUELO" type="numeric" default="1">
<cfset MODO = "ALTA"><cfif isdefined("form.RHMCid")><cfset MODO = "CAMBIO"></cfif>
<!--- Consultas --->
<cfquery name="rsGComponentes" datasource="#Session.DSN#">
	select RHCAcodigo, RHCAdescripcion
	from RHComponentesAgrupados
	where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCAid#">
</cfquery>
<cfquery name="rsComponentes" datasource="#Session.DSN#">
	select CScodigo, CSdescripcion, CSusatabla
	from ComponentesSalariales
	where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
</cfquery>
<cfif (MODO NEQ "ALTA")>
	<!--- Form ---><cfset fecha = Createdate('6100','01','01')>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 
			a.RHMCid, a.Ecodigo, a.RHMCcodigo, a.RHMCdescripcion, a.CSid, a.RHCPlinea, a.RHPcodigo,
			a.RHMCfecharige, a.RHMCfechahasta, a.RHMCcomportamiento, a.RHMCtopeporc, a.RHMCestadometodo, a.RHMCindicador,
			a.RHMCvalor, a.BMUsucodigo, a.RHMCdiferenciasal, a.ts_rversion,
			s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
			t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
			u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,  a.RHMCpuestoref, a.RHMCplazaporc
		from RHMetodosCalculo a
			left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			left outer join RHCategoria t
				on t.RHCid = r.RHCid
			left outer join RHMaestroPuestoP u
				on u.RHMPPid = r.RHMPPid
		where a.RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMCid#">
	</cfquery>
	<cfset ts = "">
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
	<cfquery name="rsUAplicadoa" datasource="#Session.DSN#">
		select 1
		from RHMetodosCalculo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
		and RHMCestadometodo = 1
		and coalesce(RHMCfechahasta,<cfqueryparam cfsqltype='cf_sql_timestamp' value='#fecha#'>) = <cfqueryparam cfsqltype='cf_sql_timestamp' value='#CreateDate(6100, 01, 01)#'>
	</cfquery>

	<cfquery name="rsUAplicadob" datasource="#Session.DSN#">
		select 1
		from RHMetodosCalculo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
		and RHMCestadometodo = 1
		and coalesce(RHMCfechahasta,<cfqueryparam cfsqltype='cf_sql_timestamp' value='#fecha#'>) = <cfqueryparam cfsqltype='cf_sql_timestamp' value='#CreateDate(6100, 01, 01)#'>
	 	and RHMCfecharige <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1,rsForm.RHMCfecharige)#">
	</cfquery>

</cfif>
<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>

<!--- Tabla de Encabezado con info del Grupo de Componentes --->
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style=" border: 1px solid gray;">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:large; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsGComponentes.RHCAcodigo#&nbsp;#rsGComponentes.RHCAdescripcion#</strong>
		</td>
	</tr>
	<!--- Tabla de Encabezado con info del Componente --->
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:large; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsComponentes.CScodigo#&nbsp;#rsComponentes.CSdescripcion#</strong>
		</td>
	</tr>
</table>
</cfoutput>

<!--- Tabla que contiene la lista y el Formulario --->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top" width="45%" style="padding-right: 5px;">
		<!--- Lista --->
		<cfset navegacion = "">
		<cfset checked = "<img src='/cfmx/rh/imagenes/checked.gif' border='0'>">
		<cfset unchecked = "<img src='/cfmx/rh/imagenes/unchecked.gif' border='0'>">

		<cfset fecha = Createdate('6100','01','01')>

		<cfquery name="ListaComp" datasource="#session.DSN#">
			Select b.CSid, b.CAid as RHCAid, a.RHMCid 
				 , a.RHMCcodigo, a.RHMCdescripcion
				 , a.RHMCfecharige
				 , case a.RHMCfechahasta
				 	when <cfqueryparam cfsqltype='cf_sql_timestamp' value='#fecha#'> then 'Indefinido'
					else <cf_dbfunction name='to_char' args='a.RHMCfechahasta' > end as RHMCfechahasta
				 , case a.RHMCcomportamiento when 2 then 'Porcentaje' when 3 then 'Multiplicador' else 'Usar Monto' end as RHMCcomportamiento
				 , a.RHMCtopeporc
				 , case a.RHMCestadometodo when 1 then '#checked#' else '#unchecked#' end as RHMCestadometodo
				 , a.RHMCindicador, a.RHMCvalor 
				 , #form.PAGENUMPADRE#  as PAGENUMPADRE 
				 , #form.PAGENUMABUELO# as PAGENUMABUELO
			from RHMetodosCalculo a
				inner join ComponentesSalariales b
					on b.CSid = a.CSid 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
			order by 1,2,3,4,5 
		</cfquery>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Rige"
		Default="Rige"
		returnvariable="LB_Rige"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Hasta"
		Default="Hasta"
		returnvariable="LB_Hasta"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Comportamiento"
		Default="Comportamiento"
		returnvariable="LB_Comportamiento"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Aplicado"
		Default="Aplicado"
		returnvariable="LB_Aplicado"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ListaMetodos"
		Default="-- No se han agregado Métodos a este Componente. --"
		returnvariable="MSG_ListaMetodos"/>		
				
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaquery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#ListaComp#"/>
			<cfinvokeargument name="desplegar" value="RHMCfecharige, RHMCfechahasta, RHMCcomportamiento, RHMCestadometodo "/>
			<cfinvokeargument name="etiquetas" value="#LB_Rige#, #LB_Hasta#, #LB_Comportamiento#, #LB_Aplicado#"/>
			<cfinvokeargument name="formatos" value="D,S,V,S"/>
			<cfinvokeargument name="align" value="left,left,center,center"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="Metodos.cfm"/>
			<cfinvokeargument name="keys" value="RHMCid"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="#MSG_ListaMetodos#"/>
			
		</cfinvoke>
	</td>
	<td valign="top">&nbsp;&nbsp;&nbsp;</td>
    <td valign="top">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
			  <td>
				<!--- Mantenimiento --->
				<form action="SQLMetodos.cfm" name="form1" method="post" onSubmit="JAVASCRIPT:__finalizar();" style="margin: 0;">
					<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td class="fileLabel" align="right"><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate>:</td>
							<td>
								<cfif MODO NEQ "ALTA">
									<cf_sifcalendario name="RHMCfecharige" value="#LSDateFormat(rsForm.RHMCfecharige,'dd/mm/yyyy')#">
								<cfelse>
									<cf_sifcalendario name="RHMCfecharige" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
								</cfif>
							</td>
						</tr>
						<tr>
							<td class="fileLabel" align="right"><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:</td>
							<td>
								<select name="RHMCcomportamiento" <cfif rsComponentes.CSusatabla EQ 2> onchange="javascript: showOptions(this.value);"</cfif>>
									<cfif rsComponentes.CSusatabla EQ 1>
									<option value="1" <cfif (MODO NEQ "ALTA") and rsForm.RHMCcomportamiento eq 1>selected</cfif>><cf_translate key="CMB_UsarMonto">Usar Monto</cf_translate></option>
									</cfif>
									<cfif rsComponentes.CSusatabla EQ 2>
									<option value="2" <cfif (MODO NEQ "ALTA") and rsForm.RHMCcomportamiento eq 2>selected</cfif>><cf_translate key="CMB_Porcentaje">Porcentaje</cf_translate></option>
									</cfif>
									<option value="3" <cfif (MODO NEQ "ALTA") and rsForm.RHMCcomportamiento eq 3>selected</cfif>><cf_translate key="CMB_Multiplicador">Multiplicador</cf_translate></option>
								</select>
							</td>
						</tr>
						<cfif rsComponentes.CSusatabla EQ 2>
							<tr>
								<td class="fileLabel" align="right"><cf_translate key="LB_ValorOPorcentaje">Valor o Porcentaje</cf_translate>:</td>
								<td>
									<input type="text" name="RHMCvalor"
									size="15" 
									maxlength="18" 
									style="text-align: right"  
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,6);"  
									onKeyUp="if(snumber(this,event,6)){ if(Key(event)=='13') {this.blur();}}"
									value="<cfif MODO NEQ "ALTA"><cfoutput>#LSNumberFormat(rsForm.RHMCvalor,',9.000000')#</cfoutput><cfelse>0.000000</cfif>">
								</td>
							</tr>
						</cfif>
						<tr>
							<td class="fileLabel" align="right"><cf_translate key="LB_Tope">Tope</cf_translate>:</td>
							<td>
								<input type="text" name="RHMCtopeporc"
								size="15" 
								maxlength="18" 
								style="text-align: right"  
								onFocus="this.value=qf(this); this.select();" 
								onBlur="javascript: fm(this,2);"  
								onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								value="<cfif MODO NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsForm.RHMCtopeporc,'none')#</cfoutput><cfelse>0.00</cfif>">
							</td>
						</tr>
						<tr>
							<td class="fileLabel" align="right"><cf_translate key="LB_Tipo">Tipo</cf_translate>:</td>
							<td>
								<select name="RHMCindicador">
									<option value="A" <cfif MODO NEQ "ALTA" and rsForm.RHMCindicador EQ 'A'>selected</cfif>><cf_translate key="CMB_Anualidad">Anualidad</cf_translate></option>
									<option value="G" <cfif MODO NEQ "ALTA" and rsForm.RHMCindicador EQ 'G'>selected</cfif>><cf_translate key="CMB_General">General</cf_translate></option>
									<option value="S" <cfif MODO NEQ "ALTA" and rsForm.RHMCindicador EQ 'S'>selected</cfif>><cf_translate key="CMB_Sobresueldo">Sobresueldo</cf_translate></option>
								</select>
							</td>
						</tr>
						<!---para el control de porcentajes de plaza por componente salarial, por ahora lo escondemos hasta que lo vallamos a usar--->
						<tr style="display:none">
							<td class="fileLabel" align="right"><cf_translate key="LB_PorcPlazaPresupuestaria">% Plaza Presupuestaria</cf_translate>:</td>
							<td>
								<input type="text" name="RHMCplazaporc"
								size="15" 
								maxlength="18" 
								style="text-align: right"  
								onFocus="this.value=qf(this); this.select();" 
								onBlur="javascript: fm(this,2);"  
								onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								value="<cfif MODO NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsForm.RHMCplazaporc,'none')#</cfoutput><cfelse>0.00</cfif>">
							</td>
						</tr>
						<cfif rsComponentes.CSusatabla EQ 2>
						
<!---  Modificación , Check para utilizar como base el salario del puesto actual o del puesto homólogo --->												
						<tr id="trBox0" <cfif modo EQ "CAMBIO" and rsForm.RHMCcomportamiento NEQ 2> style="display: none;"</cfif>>
							<td colspan="2" nowrap>
								<input type="checkbox" name="chkOtrPuest" id="chkOtrPuest" value="1" <cfif (MODO NEQ "ALTA") and (rsForm.RHMCpuestoref EQ 1 )>checked</cfif>>
								<label for="checkbox"><b>
								<cf_translate key="CHK_UtilizaElSalarioEquivalenteDeLaCategoriaPuestoDelEmpleado">Utiliza el salario equivalente de la categor&iacute;a-puesto del empleado.</cf_translate>
								</b></label>
							</td>
						</tr>
<!---  Fin de Modificación , Check para utilizar como base el salario del puesto actual o del puesto homólogo --->												
						
						<tr id="trBox1" <cfif modo EQ "CAMBIO" and rsForm.RHMCcomportamiento NEQ 2> style="display: none;"</cfif>>
							<td colspan="2" nowrap>
								<input type="checkbox" name="chkOtraCat" id="chkOtraCat" value="1" onClick="javascript:funcShowOtraCat(this);" <cfif (MODO NEQ "ALTA") and len(trim(rsForm.RHCPlinea))>checked</cfif>>
								<label for="checkbox"><b>
								<cf_translate key="CHK_SeBasaEnOtraCategoriaPuestoParaRealizarElCalculo">Se basa en otra categor&iacute;a - puesto para realizar el c&aacute;lculo.</cf_translate>
								</b></label>
							</td>
						</tr>
						<tr id="trBox2" <cfif modo EQ "CAMBIO" and rsForm.RHMCcomportamiento NEQ 2> style="display: none;"</cfif>>
							<td colspan="2">
								<div align="center" id="div_diftable" style="display:<cfif (MODO NEQ "ALTA") and len(trim(rsForm.RHCPlinea))><cfelse>none</cfif>">
									<fieldset><legend>
									<cf_translate key="LB_CategoriaPuesto">Categor&iacute;a / Puesto</cf_translate>
									</legend>
										<cfif (MODO NEQ "ALTA") and len(trim(rsForm.RHCPlinea))>
										  <cf_rhcategoriapuesto form="form1" query="#rsForm#" incluyeTabla="true">
										<cfelse>
										  <cf_rhcategoriapuesto form="form1" incluyeTabla="true">
										</cfif>
										<input type="checkbox" name="RHMCdiferenciasal" id="RHMCdiferenciasal" value="1"<cfif MODO NEQ "ALTA" and len(trim(rsForm.RHCPlinea)) and rsForm.RHMCdiferenciasal EQ 1> checked</cfif>>
										<b>
										<cf_translate key="CHK_RealizarElCalculoSobreLaDiferenciaDeSalarios">Realizar el c&aacute;lculo sobre la diferencia de salarios</cf_translate>
										</b>
									</fieldset>
								</div>
							</td>
						</tr>
						</cfif>
						<tr>
						  <td colspan="2" align="center">
							<cfif (MODO NEQ "ALTA") and rsForm.RHMCestadometodo EQ 1>
								<p class="style1">
								<cf_translate key="MSG_EsteRegistroNoPuedeSerModificadoNiEliminadoPorqueYaFueAplicado">Este registro no puede ser modificado ni eliminado porque ya fue aplicado.</cf_translate>
								</p>
								<cf_botones modo="#MODO#" include="Duplicar, Regresar" exclude="Baja,Cambio">
							<cfelseif (MODO NEQ "ALTA") and (rsUAplicadoa.RecordCount neq rsUAplicadob.RecordCount)>
								<p class="style1">
								<cf_translate key="MSG_EsteRegistroNoPuedeSerAplicadoPorqueLaFechaRigeDebeSerMayorPorAlMenosUnDiaQueLaUltimaFechaRigeAplicada">Este registro no puede ser aplicado porque la fecha rige debe ser mayor por al menos un día que la última fecha rige aplicada.</cf_translate>
								</p>
								<cf_botones modo="#MODO#" include="Regresar">
							<cfelseif (MODO NEQ "ALTA") >
								<cf_botones modo="#MODO#" include="Aplicar,Regresar">
							<cfelse>
								<cf_botones modo="#MODO#" include="Regresar">
							</cfif>
						  </td>
						</tr>
					</table>
					<input name="RHCAid" type="hidden" value="<cfoutput>#Form.RHCAid#</cfoutput>">
					<input name="CSid" type="hidden" value="<cfoutput>#Form.CSid#</cfoutput>">
					<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
					<input name="PAGENUMABUELO" type="hidden" value="<cfoutput>#Form.PAGENUMABUELO#</cfoutput>">
					<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
					<cfif (MODO neq "ALTA")>
						<input type="hidden" name="RHMCid" value="<cfoutput>#rsForm.RHMCid#</cfoutput>">
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					</cfif>
				</form>
			  </td>
			</tr>
			<cfif MODO EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2>
				<tr id="trBox3" <cfif modo EQ "CAMBIO" and rsForm.RHMCcomportamiento NEQ 2> style="display: none;"</cfif>>
				  <td>
					<fieldset>
						<legend><b><cf_translate key="LB_Subtitulo7">Componentes de C&aacute;lculo</cf_translate></b></legend>
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<cfif rsForm.RHMCestadometodo EQ 0>
						  <tr>
							<td>
								<form name="form2" method="post" action="SQLMetodos.cfm">
									<input name="RHCAid" type="hidden" value="<cfoutput>#Form.RHCAid#</cfoutput>">
									<input name="CSid" type="hidden" value="<cfoutput>#Form.CSid#</cfoutput>">
									<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
									<input name="PAGENUMABUELO" type="hidden" value="<cfoutput>#Form.PAGENUMABUELO#</cfoutput>">
									<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
									<input type="hidden" name="RHMCid" value="<cfoutput>#rsForm.RHMCid#</cfoutput>">
									<table cellpadding="0" cellspacing="0" border="0" width="100%">
									  <tr>
										<td class="fileLabel" align="right" width="10%">
											<cf_translate key="LB_Subtitulo8">Componente</cf_translate>:
										</td>
										<td>
											<cfquery name="rsComponentesCalculo" datasource="#Session.DSN#">
												select c.CSid, c.CSdescripcion
												from RHMetodosCalculo a
													inner join ComponentesSalariales b
														on b.CSid = a.CSid
													inner join ComponentesSalariales c
														on c.CSorden < b.CSorden
														and c.Ecodigo = b.Ecodigo
														and not exists (
															select 1
															from RHComponentesCalculo d
															where d.CSid = c.CSid
															and d.RHMCid = a.RHMCid
														)
												where a.RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
												order by c.CScodigo
											</cfquery>
										
											<select name="CSid_Comp">
											  <cfoutput query="rsComponentesCalculo">
												<option value="#rsComponentesCalculo.CSid#">#rsComponentesCalculo.CSdescripcion#</option>
											  </cfoutput>
											</select>
										</td>
									  </tr>
									  <tr>
										<td colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Agregar"
												Default="Agregar"
												returnvariable="BTN_Agregar"/>	
											<cf_botones names="AgregarCompCalc" values="#BTN_Agregar#">
										</td>
									  </tr>
									</table>
								</form>
							</td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  </cfif>
						  <tr>
							<td>
							
						
							<cf_dbfunction name="to_char" args="a.CSid" returnvariable="vCSid" >
							
							
							<cfset EL1	= '<a href="javascript: eliminarcompcalc('>
							<cfset EL2 = ');"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>


						<!---	<cfset parte1 =  "<input type=''image'' onClick=''javascript: return eliminarcompcalc(''" >							
							<cfset parte2 =  "'') src=''/cfmx/rh/imagenes/Borrar01_S.gif'' tabindex=''-1''>" >
							<cf_dbfunction name="concat" args="#parte1#,VCSid,#parte2#" returnvariable="vsql2">--->
							
							
								<cfquery name="ListaCompCalculo" datasource="#Session.DSN#">
									select a.CSid as CompCalculo, {fn concat(b.CScodigo , {fn concat( ' - ' , b.CSdescripcion)})} as CompCalculoDesc,
										   <cfif rsForm.RHMCestadometodo EQ 1>
										   '' as borrar
										   <cfelse>
										   case when b.CSsalariobase = 0 then '#preservesinglequotes(EL1)#'+#vCSid#+'#preservesinglequotes(EL2)#' else '' end as borrar
										   </cfif>
									from RHComponentesCalculo a
										inner join ComponentesSalariales b
											on b.CSid = a.CSid
									where a.RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
									order by b.CScodigo
								</cfquery>
							
								<form name="listaCompCalculo" action="SQLMetodos.cfm" method="post">
									<input name="RHCAid" type="hidden" value="<cfoutput>#Form.RHCAid#</cfoutput>">
									<input name="CSid" type="hidden" value="<cfoutput>#Form.CSid#</cfoutput>">
									<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
									<input name="PAGENUMABUELO" type="hidden" value="<cfoutput>#Form.PAGENUMABUELO#</cfoutput>">
									<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
									<input type="hidden" name="RHMCid" value="<cfoutput>#rsForm.RHMCid#</cfoutput>">
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Componente"
									Default="Componente"
									returnvariable="LB_Componente"/>	
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="MSG_LISTAVACIA"
									Default="--- No se han agregado componentes para el cálculo ---"
									returnvariable="MSG_LISTAVACIA"/>
								
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaquery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#ListaCompCalculo#"/>
										<cfinvokeargument name="desplegar" value="CompCalculoDesc, borrar"/>
										<cfinvokeargument name="etiquetas" value="#LB_Componente#, &nbsp;"/>
										<cfinvokeargument name="formatos" value="S,S"/>
										<cfinvokeargument name="align" value="left,right"/>
										<cfinvokeargument name="formName" value="listaCompCalculo"/>
										<cfinvokeargument name="incluyeForm" value="false"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="SQLMetodos.cfm"/>
										<cfinvokeargument name="keys" value="CompCalculo"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="showLink" value="false"/>
										<cfinvokeargument name="maxRows" value="0"/>
										<cfinvokeargument name="PageIndex" value="4"/>
										<cfinvokeargument name="EmptyListMsg" value="#MSG_LISTAVACIA#"/>
									</cfinvoke>
								</form>
							</td>
						  </tr>
						</table>
					</fieldset>
				  </td>
				</tr>
			</cfif>
			<cfif rsComponentes.CSusatabla EQ 2>
			<tr>
			  <td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3" class="Ayuda">
					<tr>
					  <td>
					  <cf_translate key="AYUDA_Comportamiento">
					  <strong>Comportamiento: </strong> Este campo permitir&aacute; al usuario determinar como desea que se calcule el componente en la captura dentro de la acci&oacute;n de personal cuando &eacute;ste es un <strong>m&eacute;todo de c&aacute;lculo</strong>. Los comportamientos permitidos son <strong>Multiplicador</strong> el cual permite la captura de las unidades a multiplicar por el valor registrado en el m&eacute;todo de c&aacute;lculo y <strong>Porcentaje</strong> el cual es el resultado de multiplicar la suma de los montos de los componentes de c&aacute;lculo por el porcentaje registrado en el m&eacute;todo de c&aacute;lculo.
					  </cf_translate></td>
					  </tr>
					<tr>
					  <td>
					   <cf_translate key="AYUDA_ValorOPorcentaje">
					  <strong>Valor o Porcentaje: </strong> Utilizado dependiendo del comportamiento escogido.</cf_translate></td>
					  </tr>
					<tr>
					  <td>
					  <cf_translate key="AYUDA_Tope">
					  <strong>Tope: </strong>Porcentaje m&aacute;ximo que pagar&aacute; con referencia en el salario base de la persona. Si en el tope se indica un valor de 0 se asume un valor de 100 en el tope.</cf_translate></td>
					</tr>
					<tr>
					  <td>
					  <cf_translate key="AYUDA_Tipo">
					  <strong>Tipo: </strong>Identificar&aacute; si el componente es una anualidad, sobresueldo, o de otra clase.</cf_translate></td>
					</tr>
					<tr>
					  <td>
					  <cf_translate key="AYUDA_SeBasaEnOtraCategoria">
					  <strong>Se basa en otra categor&iacute;a / puesto para realizar el c&aacute;lculo: </strong>Permitir&aacute; que el componente se pague con el salario base de un puesto espec&iacute;fico, sin importar el de la persona.</cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_UtilizaElSalarioEquivalente"><strong><b>Utiliza el salario equivalente de la categor&iacute;a-puesto del empleado</b>:</strong>Permitir&aacute; que el componente se pague con la diferencia entre el salario de un puesto espec&iacute;fico, y el del puesto equivalente al de la persona.</cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_CategoriaPuesto"><strong>Categor&iacute;a / Puesto: </strong>identificar&aacute; el <strong>puesto</strong> y la <strong>categor&iacute;a </strong>asignada a este, con la que se desea pagar.</cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_ComponentesDeCaculo"><strong>Componentes de C&aacute;lculo: </strong> la sumatoria de los componentes se utiliza para obtener el monto base sobre el cual se aplica el m&eacute;todo de c&aacute;lculo. &Uacute;nicamente se pueden agregar componentes cuyo orden de c&aacute;lculo sea menor al orden del componente actual. <strong>Los componentes de C&aacute;lculo se toman en cuenta &uacute;nicamente si el m&eacute;todo no se basa en otra categor&iacute;a/puesto.</strong></cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_BotonDuplicar"><strong style="color:#000099">Bot&oacute;n Duplicar: </strong>Permite crear un nuevo m&eacute;todo de c&aacute;lculo copiando las mismas condiciones configuradas en el m&eacute;todo de c&aacute;lculo actual.</cf_translate></td>
					</tr>
				</table>
			  </td>
			</tr>
			<cfelse>
			<tr>
			  <td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3" class="Ayuda">
					<tr>
					  <td><cf_translate key="AYUDA_Comportamiento"><strong>Comportamiento: </strong> Este campo permitir&aacute; al usuario determinar como desea que se calcule el componente en la captura dentro de la acci&oacute;n de personal cuando &eacute;ste <strong>usa tabla</strong>. Los comportamientos permitidos son <strong>Usar Monto</strong> el cual simplemente obtiene el monto registrado en la tabla salarial sin permitir modificaci&oacute;n alguna y <strong>Multiplicador</strong> permite la captura de las unidades a multiplicar por el monto registrado en la tabla salarial.</cf_translate></td>
					  </tr>
					<tr>
					  <td><cf_translate key="AYUDA_Tope"><strong>Tope: </strong>Porcentaje m&aacute;ximo que pagar&aacute; con referencia en el salario base de la persona. Si en el tope se indica un valor de 0 se asume un valor de 100 en el tope.</cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_Tipo"><strong>Tipo: </strong>Identificar&aacute; si el componente es una anualidad, sobresueldo, o de otra clase.</cf_translate></td>
					</tr>
					<tr>
					  <td><cf_translate key="AYUDA_BotonDuplicar"><strong style="color:#000099">Bot&oacute;n Duplicar: </strong>Permite crear un nuevo m&eacute;todo de c&aacute;lculo copiando las mismas condiciones configuradas en el m&eacute;todo de c&aacute;lculo actual.</cf_translate></td>
					</tr>
				</table>
			  </td>
			</tr>
			</cfif>
		</table>
	</td>
  </tr>
</table>
<br>

<cf_qforms form="form1" objForm="objForm">
<cfif modo EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2 and rsForm.RHMCestadometodo EQ 0>
	<cf_qforms form="form2" objForm="objForm2">
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	
	<!--- Funcion que alerta sobre la modificación del check de otra categoría / puesto antes de agregar un componente --->
	<cfif MODO NEQ "ALTA" and (len(trim(rsForm.RHCPlinea)) or rsForm.RHMCcomportamiento NEQ 2)>
	 	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DebeModificarElMetodoDeCalculoAntesDeAgregarComponentesDeCalculo"
		Default="Debe modificar el método de cálculo antes de agregar componentes de cálculo"
		returnvariable="MSG_DebeModificarElMetodoDeCalculoAntesDeAgregarComponentesDeCalculo"/>	
		
		
		function funcAgregarCompCalc() {
			alert('<cfoutput>#MSG_DebeModificarElMetodoDeCalculoAntesDeAgregarComponentesDeCalculo#</cfoutput>');
			return false;
		}
	</cfif>

	<cfif rsComponentes.CSusatabla EQ 2>
		function funcShowOtraCat(o) {
			var div = document.getElementById("div_diftable");
			var comp = document.getElementById("trBox3");
			if (o.checked) {
				if (div) div.style.display = "";
				if (comp) comp.style.display = "none";
			}
			else{
				if (div) div.style.display = "none";
				if (comp) comp.style.display = "";
				resetDifTable();
			}
			habilitarValidacion();
		}

		function showOptions(val) {
			funcShowOtraCat(document.form1.chkOtraCat);
			var a = document.getElementById("trBox1");
			var b = document.getElementById("trBox2");
			<cfif modo EQ "CAMBIO">
			var c = document.getElementById("trBox3");
			</cfif>
			if (val == '2') {
				if (a) a.style.display = "";
				if (b) b.style.display = "";
				<cfif modo EQ "CAMBIO">
				if (c && !document.form1.chkOtraCat.checked) c.style.display = "";
				</cfif>
			} else if (val == '3') {
				if (a) a.style.display = "none";
				if (b) b.style.display = "none";
				<cfif modo EQ "CAMBIO">
				if (c) c.style.display = "none";
				</cfif>
			}
		}
	</cfif>

	<cfif modo EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2 and rsForm.RHMCestadometodo EQ 0>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EstaSeguroDeQueDeseaEliminarElComponente"
		Default="¿Está seguro de que desea eliminar el componente?"
		returnvariable="MSG_EstaSeguroDeQueDeseaEliminarElComponente"/>		
		
		function eliminarcompcalc(csid) {
			if (confirm("<cfoutput>#MSG_EstaSeguroDeQueDeseaEliminarElComponente#</cfoutput>")) {
				document.listaCompCalculo.COMPCALCULO.value = csid;
				document.listaCompCalculo.submit();
			} else {
				return;
			}
		}
	</cfif>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaRige"
	Default="Fecha Rige"
	returnvariable="MSG_FechaRige"/>	

    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Comportamiento"
	Default="Comportamiento"
	returnvariable="MSG_Comportamiento"/>	

    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tope"
	Default="Tope"
	returnvariable="MSG_Tope"/>
	
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo"
	Default="Tipo"
	returnvariable="MSG_Tipo"/>
	
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ValorOPorcentaje"
	Default="Valor o Porcentaje"
	returnvariable="MSG_ValorOPorcentaje"/>	

    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Categoria"
	Default="Categoría"
	returnvariable="MSG_Categoria"/>	
	
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"
	returnvariable="MSG_Puesto"/>	
	
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ComponenteSalarial"
	Default="Componente Salarial"
	returnvariable="MSG_ComponenteSalarial"/>	
		
	<cfoutput>
	objForm.RHMCfecharige.description = "#JSStringFormat('#MSG_FechaRige#')#";
	objForm.RHMCcomportamiento.description = "#JSStringFormat('#MSG_Comportamiento#')#";
	objForm.RHMCtopeporc.description = "#JSStringFormat('#MSG_Tope#')#";
	objForm.RHMCindicador.description = "#JSStringFormat('#MSG_Tipo#')#";
	<cfif rsComponentes.CSusatabla EQ 2>
	objForm.RHMCvalor.description = "#JSStringFormat('#MSG_ValorOPorcentaje#')#";
	objForm.RHCdescripcion.description = "#JSStringFormat('#MSG_Categoria#')#";
	objForm.RHMPPdescripcion.description = "#JSStringFormat('#MSG_Puesto#')#";
	</cfif>
	
	<cfif modo EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2 and rsForm.RHMCestadometodo EQ 0>
		objForm2.CSid_Comp.description = "#MSG_ComponenteSalarial#";
	</cfif>
	</cfoutput>
	/*Funciones JavaScript*/
	
	function deshabilitarValidacion(){
		objForm.RHMCfecharige.required = false;
		objForm.RHMCcomportamiento.required = false;
		objForm.RHMCtopeporc.required = false;
		objForm.RHMCindicador.required = false;
		<cfif rsComponentes.CSusatabla EQ 2>
		objForm.RHMCvalor.required = false;
		objForm.RHMPPdescripcion.required = false;
		objForm.RHCdescripcion.required = false;
		</cfif>
		<cfif modo EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2 and rsForm.RHMCestadometodo EQ 0>
			objForm2.CSid_Comp.required = false;
		</cfif>
	}
	
	function habilitarValidacion(){
		objForm.RHMCfecharige.required = true;
		objForm.RHMCcomportamiento.required = true;
		objForm.RHMCtopeporc.required = true;
		objForm.RHMCindicador.required = true;
		<cfif rsComponentes.CSusatabla EQ 2>
		objForm.RHMCvalor.required = true;
		if (objForm.chkOtraCat.getValue()=='1') {
			objForm.RHMPPdescripcion.required = true;
			objForm.RHCdescripcion.required = true;
		}else
		{
			objForm.RHMPPdescripcion.required = false;
			objForm.RHCdescripcion.required = false;
		}
		</cfif>
		<cfif modo EQ "CAMBIO" and rsComponentes.CSusatabla EQ 2 and rsForm.RHMCestadometodo EQ 0>
			objForm2.CSid_Comp.required = true;
		</cfif>
	}
	
	function __finalizar(){
		<cfif rsComponentes.CSusatabla EQ 2>
		objForm.RHMCvalor.obj.value = qf(objForm.RHMCvalor.obj.value);
		objForm.RHMCvalor.obj.disabled = false;
		</cfif>
		objForm.RHMCtopeporc.obj.value = qf(objForm.RHMCtopeporc.obj.value);
		objForm.RHMCtopeporc.obj.disabled = false;
	}

	function resetDifTable(){
	}
	
	function funcRegresar(){
		deshabilitarValidacion();
		objForm.obj.action = "Componentes.cfm";
		objForm.PAGENUM.obj.value = objForm.PAGENUMPADRE.getValue();
		objForm.PAGENUMPADRE.obj.value = objForm.PAGENUMABUELO.getValue();
		return true;
	}
	
	/*Campos Requeridos*/
	habilitarValidacion();
	
	/*Focus*/
	objForm.RHMCfecharige.obj.focus();

	<cfif rsComponentes.CSusatabla EQ 2>
		showOptions(document.form1.RHMCcomportamiento.value);
	</cfif>
	
	//-->	
</script>
