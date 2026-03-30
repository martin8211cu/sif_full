<cfset Form.TotalA = 0>
<cfset Form.TotalC = 0>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
		select a.RHPdescpuesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo
		from RHPuestos a inner join RHConcursos b
		  on a.Ecodigo 	  = b.Ecodigo and
		     a.RHPcodigo  = b.RHPcodigo
		where b.Ecodigo	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	</cfquery>
<!-----******* Pruebas *******------>	
	<cfquery name="RSPRuebas" datasource="#Session.DSN#">
		select a.RHPcodigopr, 
		{fn concat(b.RHPdescripcionpr,{fn concat('(',{fn concat(<cf_dbfunction name="to_char" args="a.Cantidad">,')')})})} as RHPdescripcionpr,
		a.Cantidad ,
		a.Peso,a.ts_rversion 
		from RHPruebasConcurso a ,  RHPruebas b
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
		and  a. Ecodigo = b. Ecodigo
		and  a.RHPcodigopr  = b.RHPcodigopr 
	</cfquery>
</cfif>

<!--- Estilos para el reporte --->
<style type="text/css">
	.encabReporte {
		background-color:  #E1E1E1;
		font-weight: bolder;
		color: #000000;
		padding-top: 15px;
		padding-bottom: 15px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>
<br>
<form action="ConcursosMng-sql.cfm" method="post" name="form1">
	<cfinclude template="ConcursosMng-hiddens.cfm">
	<input type="hidden" name="paso" value="<cfif isdefined("Gpaso")>#Gpaso#<cfelse>0</cfif>">
	<input type="hidden" name="borrararea" value="">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
	<input type="hidden" name="RHCcantplazas" value="#rsRHConcursos.RHCcantplazas#">
	<input type="hidden" name="ORHPcodigo" value="#rsRHConcursos.RHPcodigo#">
	
	<table width="95%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td width="25%">
				<fieldset><legend><strong><cf_translate key="LB_AreasDeEvaluacion">&Aacute;reas de Evaluación</cf_translate></strong></legend>
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>			
						<td width="82%" align="center" nowrap><strong><cf_translate key="LB_AreaDeEvaluacion">&Aacute;rea de Evaluación</cf_translate>:</strong>&nbsp;</td>
						<td nowrap>&nbsp;<cf_rhareasevalconcurso name ="AreaEval"></td>
					</tr>	
					<tr>
						<td align="right"><strong><cf_translate key="LB_Peso">Peso</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td>
							<input type="text" name="RHEApeso" size="8" maxlength="7" align="right" 
								onChange="javascript: fm(this,2); validaPeso(this);" 
								onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
							<!--- <cfset estado = ",'<img src=''/cfmx/rh/imagenes/Borrar01_T.gif'' onclick=''EliminaArea('||convert(varchar,a.RHEAid)||');'' width=''16'' height=''16''>' as estadoimg"> --->
							<!--- <cfset estado = ",{fn concat('<img src=''/cfmx/rh/imagenes/Borrar01_T.gif'' onclick=''EliminaArea(',{fn concat(convert(varchar,a.RHEAid),');'' width=''16'' height=''16''>')})} as estadoimg"> --->
							<cf_dbfunction name="to_char" returnvariable="RHEAid_char" args="a.RHEAid">
							<cf_dbfunction name="concat"  returnvariable="imagen" args="<img src=''/cfmx/rh/imagenes/Borrar01_T.gif'' onClick=''javascript:EliminaArea('+#RHEAid_char#+');'' width=''16'' height=''16''>" delimiters="+">

							<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.RHEAid = b.RHEAid and a.RHCconcurso = #rsRHConcursos.RHCconcurso#" >
							<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
								<cfset filtro = filtro & " and a.RHCconcurso = #rsRHConcursos.fRHCconcurso#	">
							</cfif>
							<cfset filtro = filtro & " and a.Ecodigo = b.Ecodigo"> 
							<cfset filtro = filtro & " order by RHCconcurso">						
							<cfquery name="rsListaAreas" datasource="#session.DSN#">
								select b.RHEAcodigo, b.RHEAdescripcion, a.RHAECpeso as peso
								from RHAreasEvalConcurso a inner join RHEAreasEvaluacion b
								  on a.Ecodigo  = b.Ecodigo and
								  	 a.RHEAid 	= b.RHEAid 
								where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
								order by RHCconcurso
							</cfquery>
							<!--- VARIABLES DE TRADUCCION --->
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Area"
								Default="Área"
								returnvariable="LB_Area"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Descripcion"
								Default="Descripci&oacute;n"
								XmlFile="/rh/generales.xml"
								returnvariable="LB_Descripcion"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Peso"
								Default="Peso"
								returnvariable="LB_Peso"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Estado"
								Default="Estado"
								returnvariable="LB_Estado"/>
							
							<cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaRH"
								returnvariable="pListaDed">
									<cfinvokeargument name="tabla" value="RHAreasEvalConcurso a, RHEAreasEvaluacion b"/>
									<cfinvokeargument name="columnas" value=" b.RHEAcodigo, b.RHEAdescripcion, a.RHAECpeso as peso, '#imagen#' as estadoimg "/>
									<cfinvokeargument name="desplegar" value="RHEAcodigo, RHEAdescripcion, peso, estadoimg "/>
									<cfinvokeargument name="etiquetas" value="#LB_Area#, #LB_Descripcion#, #LB_Peso#, #LB_Estado#"/>
									<cfinvokeargument name="formatos" value="S, S, M, S"/>
									<cfinvokeargument name="align" value="left, left, right, center"/>
									<cfinvokeargument name="ajustar" value="S"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="filtro" value="#filtro#"/>
									<cfinvokeargument name="showEmptyListMsg" value= "1"/>
									<cfinvokeargument name="incluyeform" value="false"/>
									<cfinvokeargument name="formname" value="form1"/>
									<cfinvokeargument name="showLink" value="false"/>
							</cfinvoke>		
							<cfloop query="rsListaAreas">
								<cfset Form.TotalA = Form.TotalA + rsListaAreas.peso>
							</cfloop>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="right"><strong><cf_translate key="LB_PesoTotal">Peso Total</cf_translate> : <input name="TotalA" type="text" value="#Form.TotalA#" align="right" size="6" disabled></strong> &nbsp;</td> 
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					<cf_botones exclude="Baja,Limpiar">
					</fieldset>
<!--***********--->					
					<fieldset><legend><strong><cf_translate key="LB_PruebasARealizar">Pruebas a realizar</cf_translate></strong></legend>
					<table width="95%" align="center" border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td colspan="3" align="right" style="font-size:12px; font-variant:small-caps; font-weight: bold;">
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_RegenerarPruebasParaElConcurso"
									Default="Regenerar Pruebas para el Concurso"
									returnvariable="LB_RegenerarPruebasParaElConcurso"/>
								<a href="javascript: RegenerarPruebas();"><cf_translate key="LB_Regenerar">regenerar</cf_translate><img src="/cfmx/rh/imagenes/refresh_o.gif" border="0" align="absmiddle" title="#LB_RegenerarPruebasParaElConcurso#"></a>
							</td>
						</tr>
					  <cfset index = 0>
					  <cfset Total = 0>
					  <cfif RSPRuebas.recordcount gt 0>
							<cfloop query="RSPRuebas">
								<cfset index = index + 1>
								<tr>
									<td  align="right" width="25%"><strong>#RSPRuebas.RHPdescripcionpr#:</strong></td>
									<td width="25%">
									<input type="text" name="Peso_#index#" id="Peso_#index#"
										value="#LSNumberFormat(RSPRuebas.Peso,',9')#"
										onBlur="javascript: fm(this,-1); if (window.funcalculaTotal) return funcalculaTotal();"  
										onFocus="javascript:this.value=qf(this); this.select();"
										onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
										style="text-align: right"
										size="6"  maxlength="10"
									>%</td>
									<td width="25%">&nbsp;</td>
								</tr>
								<cfset Total = Total + RSPRuebas.Peso>
								<input type="hidden" name="RHPcodigopr_#index#" value="#RSPRuebas.RHPcodigopr#">
							</cfloop>
							<tr>
								<td  align="right" width="25%"><cf_translate key="LB_Total">Total</cf_translate></td>
								<td width="25%">
								<input disabled type="text"
								name="Total" id="Total"
								value="#LSNumberFormat(Total,',9')#"
								onBlur="javascript: fm(this,0);"  
								onFocus="javascript:this.value=qf(this); this.select();" 
								>%</td>
								<td width="25%">&nbsp;</td>
							</tr>
							<tr>
							  	<td align="center" colspan="3">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Modificar"
										Default="Modificar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Modificar"/>
									<input type="submit" name="btnModificaPrueba" value="#BTN_Modificar#">
								</td>
							</tr>
					  <cfelse>
							 <tr>
								<td  colspan="3" align="center" ><strong>----- <cf_translate key="LB_NoHayPruebasParaEsteConcurso">No hay pruebas para este concurso</cf_translate> -----</strong></td>
							 </tr> 
					  </cfif>
					  <input type="hidden" name="index" value="#index#">
					</table>			
					</fieldset>	
			</td>
			<td width="75%"> 
				<fieldset><legend><strong><cf_translate key="LB_Compentencias">Competencias</cf_translate></strong></legend>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Habilidades"
					Default="Habilidades"
					returnvariable="LB_Habilidades"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Conocimientos"
					Default="Conocimientos"
					returnvariable="LB_Conocimientos"/>
				
					<!---<cf_dump var="#vCadena#">--->
					<!---{fn concat(substring(c.RHHdescripcion,1,37),'...')} --->
					<!---<cf_dbfunction name="concat" args="#vCadena#,'...'">  --->

				<cfquery name="rsConocimientos" datasource="#session.DSN#">
					select distinct c.RHHdescripcion as descripcion, 
							case when len(c.RHHdescripcion) > 37 then 
								{fn concat(<cf_dbfunction name="string_part" args="c.RHHdescripcion,1,37">,'...')}
								else c.RHHdescripcion end as corta, 
							b.Idcompetencia, b.RHCPpeso, 
						   case when tipocompetencia ='H' then '#LB_Habilidades#'  else '#LB_Conocimientos#' end as tipocompetencia, 
						   tipocompetencia as tipo
					from RHConcursos a inner join RHCompetenciasConcurso b
					  on a.Ecodigo 		 = b.Ecodigo and
						 a.RHCconcurso   = b.RHCconcurso inner join RHHabilidades c
					  on b.Idcompetencia = c.RHHid
					where a.Ecodigo 	 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHPcodigo 	  = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHConcursos.RHPcodigo#">
						and b.tipocompetencia = 'H'
						and b.RHCconcurso 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
						
					UNION
					
					select distinct c.RHCdescripcion as descripcion, 
							case when len(c.RHCdescripcion) > 37 then 
								{fn concat(<cf_dbfunction name="string_part" args="c.RHCdescripcion,1,37">,'...')} else c.RHCdescripcion end as corta, b.Idcompetencia, b.RHCPpeso, 
						   case when tipocompetencia ='C' then '#LB_Conocimientos#' else '#LB_Habilidades#' end as tipocompetencia,
						   tipocompetencia as tipo
					from RHConcursos a inner join RHCompetenciasConcurso b
					  on a.Ecodigo 		 = b.Ecodigo and
						 a.RHCconcurso 	 = b.RHCconcurso  inner join RHConocimientos c
					  on b.Idcompetencia = c.RHCid
					where a.Ecodigo 		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHPcodigo 	  = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHConcursos.RHPcodigo#">
						and b.tipocompetencia = 'C'
						and b.RHCconcurso 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
					order by tipo, Idcompetencia
				</cfquery>
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="4" align="right" style="font-size:12px; font-variant:small-caps; font-weight: bold;">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_RegenerarCompetenciasParaElConcurso"
								Default="Regenerar Competencias para el Concurso"
								returnvariable="MSG_RegenerarCompetenciasParaElConcurso"/>

							<a href="javascript: RegenerarCompetencias();"><cf_translate key="LB_Regenerar">regenerar</cf_translate><img src="/cfmx/rh/imagenes/refresh_o.gif" border="0" align="absmiddle" title="#MSG_RegenerarCompetenciasParaElConcurso#"></a>
						</td>
					</tr>
					<cfif isdefined("rsConocimientos") and rsConocimientos.RecordCount GT 0>
						<cfset competencia = "">
						<cfloop query="rsConocimientos">
							<cfif (currentRow Mod 2) eq 1>
								<cfset color = "Non">
							<cfelse>
								<cfset color = "Par">
							</cfif>
							<cfset Form.TotalC = Form.TotalC + rsConocimientos.RHCPpeso>
							<cfif competencia NEQ rsConocimientos.tipo>
								<cfset competencia = rsConocimientos.tipo>
								<tr><td colspan="4">&nbsp;</td></tr>
								<tr height="18" class="encabReporte" >
									<td colspan="4"><strong>&nbsp;&nbsp;&nbsp;#Ucase(rsConocimientos.tipocompetencia)#</strong></td>
								</tr>
								<tr height="18" bgcolor="F5F5F0">
									<td align="center"><strong><cf_translate key="LB_ID">ID</cf_translate></strong></td>
									<td width="51%" align="center"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
									<td width="12%" align="center"><strong><cf_translate key="LB_Peso">Peso</cf_translate></strong></td>
									<td width="2%">&nbsp;</td>
								</tr>
							</cfif>
							<tr>
								<td width="10%" align="center" class="lista#color#">#rsConocimientos.Idcompetencia#</td>
								<td width="70%"class="lista#color#">#rsConocimientos.corta#</td>
								<td width="10%"class="lista#color#">
									<input name="anterior_#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#" 
										type="hidden" value="#Trim(LSNumberFormat(rsConocimientos.RHCPpeso,"___.__"))#">
									<input align="right" name="peso_#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#" 
										type="text" size="6"  maxlength="10"
										onChange="javascript: fm(this,2); validaCant(this,'#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#');" 
										onBlur="if (window.CalculaTotal) return CalculaTotal('#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#');"
										onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
										value="#Trim(LSNumberFormat(rsConocimientos.RHCPpeso,"___.__"))#">
										
									<input name="tipocomp_#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#" 
										type="hidden" value="#rsConocimientos.tipo#">
									<input name="Idcomp_#rsConocimientos.Idcompetencia#_#rsConocimientos.tipo#" 
										type="hidden" value="#rsConocimientos.Idcompetencia#">
								</td>
								<td width="2%" class="lista#color#">&nbsp;</td>	
							</tr>
						</cfloop>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td colspan="4" align="right"><strong><cf_translate key="LB_PesoTotal">Peso Total</cf_translate> :</strong><input name="TotalCon" value="#Form.TotalC#" type="text" disabled size="6" align="right"></td> 
						</tr>
						<tr>
							<td colspan="4" align="center">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Modificar"
								Default="Modificar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Modificar"/>
							<input type="submit" name="btnModificaConceptos" value="#BTN_Modificar#">
							</td>
						</tr>
					<cfelse>
						<tr><td align="center" colspan="4"><strong>--- <cf_translate key="LB_NoHayCompetenciasParaElPuesto">No hay competencias para el puesto.</cf_translate> ---</strong></td></tr>
					</cfif>
				</table>
				<cfquery name="rsConsulta" datasource="#session.DSN#">
					select 1
					from RHAreasEvalConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
				</cfquery>
				<cfquery name="rsConsultaP" datasource="#session.DSN#">
					select 1
					from RHPruebasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
				</cfquery>
				<cfset Form.TotalGral = Form.TotalA + Form.TotalC>
				</fieldset>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>		
		<tr><td align="center" colspan="2"><strong><cf_translate key="LB_PesoTotalDeCriteriosDeEvaluacion">Peso Total de Criterios de Evaluaci&oacute;n</cf_translate>:</strong> <input name="TotalGral" type="text" value="#Form.TotalGral#" disabled align="right" size="6"></td></tr>
	</table>
	<br>
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input name="TotalAreas"  type="hidden" value="#Form.TotalA#">
	<input name="TotalComp" type="hidden" value="#Form.TotalC#">
	<input name="TotalGeneral" type="hidden" value="#Form.TotalGral#">
	<input type="hidden" name="RegCompetencias" value="0">
	<input type="hidden" name="RegPruebas" value="0">
</form>
</cfoutput>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElTotalDeLasPruebasDeSerEl100"
	Default="El total de las pruebas de ser el 100%"
	returnvariable="MSG_ElTotalDeLasPruebasDeSerEl100"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElMontoDigitadoDebeSerEstarDelRango0100"
	Default="El monto digitado debe ser estar del rango 0 - 100."
	returnvariable="MSG_ElMontoDigitadoDebeSerEstarDelRango0100"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElPesoDigitadoDebeEstarEntre0Y100"
	Default="El peso digitado debe estar entre 0 y 100."
	returnvariable="MSG_ElPesoDigitadoDebeEstarEntre0Y100"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSehaSeleccionadoUnAreaVerifique"
	Default="No se ha seleccionado un área. Verifique."
	returnvariable="MSG_NoSehaSeleccionadoUnAreaVerifique"/>
	
<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">
	//***************************
	var index =  new Number(document.form1.index.value)
	for(var i=1;i<=index;i++) {
		eval("objForm.Peso_"+i+".required = true")
		eval("objForm.Peso_"+i+".description='Porcentaje'")	
	}
	<cfif RSPRuebas.recordcount gt 0>
		objForm.Total.required = true;
		objForm.Total.description = '<cfoutput>#MSG_ElTotalDeLasPruebasDeSerEl100#</cfoutput>';
	
		_addValidator("isCantidad", Cantidad_valida);
		objForm.Total.validateCantidad();
		function Cantidad_valida(){
			var Cantidad = new Number(this.value)	
			if ( Cantidad != 100){
				this.error = "<cfoutput>#MSG_ElTotalDeLasPruebasDeSerEl100#</cfoutput>";
			}		
		}
	</cfif>	
	
	<cfif RSPRuebas.recordcount gt 0>
		function funcalculaTotal(){			
			var Total = 0;
			var index =  new Number(document.form1.index.value)
			for(var i=1;i<=index;i++) {
				Total = Total + new Number(eval("document.form1.Peso_"+i+".value"));
			}
			document.form1.Total.value = Total ;
		}
	</cfif>		
	//***************************
	function EliminaArea(id) {
		if (id !="") {
			//deshabilitar();
			document.form1.RHEAid.value=id;
			document.form1.borrararea.value = true;
			document.form1.submit();
		}
		return false;
	}
	
	function validaCant(numero,id){
		if (numero.name)
		 	num = numero.value
		else
			num = numero
		num = qf(num);
		if (num > 100) {
			alert('<cfoutput>#MSG_ElMontoDigitadoDebeSerEstarDelRango0100#</cfoutput>');			
			eval("document.form1.peso_" + id + ".value = '0.00'");
			eval("document.form1.peso_" + id + ".focus();");
			return false;
		}
	} 
	
	function validaPeso(peso){ 
		if (peso.name)
		 	p = peso.value;
			
		else 
			p = peso;
		p = qf(p);
			
		if (p > 100) {
			alert('<cfoutput>#MSG_ElPesoDigitadoDebeEstarEntre0Y100#</cfoutput>');			
			eval("document.form1.RHEApeso.value = '0.00'");
			eval("document.form1.RHEApeso.focus();");
			return false;
		}
	} 
	
	function funcAlta(){
		var area = document.form1.AreaEval.value;
		if (area == ""){
			alert('<cfoutput>#MSG_NoSehaSeleccionadoUnAreaVerifique#</cfoutput>');
			return false;
		}else{
			return true;
		}
	}
	
	function funcConsultaPuesto(valor){
	var params ="";
		params = "<cfoutput>?RHPcodigo=#rsRHConcursos.RHPcodigo#</cfoutput>";
		popUpWindowPuestos("/cfmx/rh/Reclutamiento/operacion/consultaPuesto.cfm"+params,75,50,850,630);
	}
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowPuestos(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	
	function CalculaTotal(index){
		var totalC ;
		var peso ;
		peso = eval("document.form1.peso_"+index+".value");
		totalC = new Number(document.form1.TotalCon.value);
		totalC += new Number (eval("document.form1.peso_"+index+".value"));
		totalC -= new Number (eval("document.form1.anterior_"+index+".value"));
		document.form1.TotalCon.value=totalC;
		eval("document.form1.anterior_"+index+".value=document.form1.peso_"+index+".value");
		document.form1.TotalGral.value = new Number(document.form1.TotalA.value)+new Number(document.form1.TotalCon.value);
	}
	
	function RegenerarCompetencias() {
		document.form1.RegCompetencias.value = '1';
		document.form1.submit();
	}

	function RegenerarPruebas() {
		document.form1.RegPruebas.value = '1';
		document.form1.submit();
	}
	
</SCRIPT>
 