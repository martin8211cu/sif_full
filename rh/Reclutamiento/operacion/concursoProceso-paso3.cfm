<cfif isdefined("url.RHEAid") and (url.RHEAid gt 0) and not isdefined("form.RHEAid")>
	<cfset form.RHEAid= #url.RHEAid#>
</cfif>
<cfif isDefined("url.RHCconcurso") and (len(trim(#url.RHCconcurso#)) NEQ 0) and not isDefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cfif isDefined("url.paso") and (len(trim(#url.paso#)) NEQ 0) and not isDefined("form.paso")>
	<cfset form.paso = url.paso>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
		Select a.RHCconcurso, a.RHCcodigo, #LvaRHCdescripcion# as RHCdescripcion, 
			a.CFid, c.CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext, #LvarRHPdescpuesto# as RHPdescpuesto, a.RHCcantplazas, a.RHCfecha,
			a.RHCfapertura, a.RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, a.RHCestado, a.Usucodigo, 
			a.ts_rversion
        from RHConcursos a

			left outer join RHPuestos b
				on b.RHPcodigo = a.RHPcodigo
				and b.Ecodigo  = a.Ecodigo

			left outer join CFuncional c
				on c.CFid	   = a.CFid
				and c.Ecodigo  = a.Ecodigo
				
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	</cfquery>
</cfif>

<cfoutput>
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="16%" align="right" nowrap><strong>C&oacute;digo de Concurso:&nbsp;</strong></td>
			<td width="24%">
				#rsRHConcursos.RHCcodigo#
			</td>
			<td align="right" width="14%" nowrap><strong>&nbsp; &nbsp;Fecha Apertura:&nbsp;</strong></td>
			<td align="left" width="6%">
				<cfset fechaI = rsRHConcursos.RHCfapertura>
				#LSDateFormat(fechaI,'dd/mm/yyyy')#
			</td>
			<td width="23%" align="left" nowrap><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha Cierre:</strong>&nbsp;</td>
			<td width="17%" align="left" >
				<cfset fechaF = rsRHConcursos.RHCfcierre>
				#LSDateFormat(fechaF,'dd/mm/yyyy')#
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><strong>&nbsp; N&deg; Plazas:&nbsp;</strong></td>
			<td align="left" >
				#rsRHConcursos.RHCcantplazas#
			</td>
			<td align="right" nowrap><strong><cf_translate key="LB_Puesto" xmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></td>
			<td align="left" colspan="7">#rsRHConcursos.RHPcodigoext#- #rsRHConcursos.RHPdescpuesto#
			<a href="##" tabindex="-1" onClick='javascript: funcConsultaPuesto();'>
					<img src="/cfmx/rh/imagenes/findsmall.gif" alt="Información sobre el Puesto" name="imagen" width="18" 
					height="14" border="0" align="absmiddle"  title="Información sobre el Puesto"
					onClick='javascript: funcConsultaPuesto();'>
			</a></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
			<td align="left" >#rsRHConcursos.CFcodigoresp# - #rsRHConcursos.CFdescripcionresp#</td>
			<td align="right">&nbsp;&nbsp;<strong><cf_translate key="LB_Estado" xmlFile="/rh/generales.xml">Estado</cf_translate>:</strong>&nbsp;</td>
			<td align="left"> 
				<cfswitch expression="#rsRHConcursos.RHCestado#">
					<cfcase value="0"><strong>En&nbsp;<cf_translate key="LB_Proceso" xmlFile="/rh/generales.xml">Proceso</cf_translate></strong></cfcase>
					<cfcase value="10"><strong><cf_translate key="LB_Solicitado" xmlFile="/rh/generales.xml">Solicitado</cf_translate></strong></cfcase>
					<cfcase value="20"><strong><cf_translate key="LB_Desierto" xmlFile="/rh/generales.xml">Desierto</cf_translate></strong></cfcase>
					<cfcase value="30"><strong><cf_translate key="LB_Cerrado" xmlFile="/rh/generales.xml">Cerrado</cf_translate></strong></cfcase>
					<cfcase value="15"><strong><cf_translate key="LB_Verificado" xmlFile="/rh/generales.xml">Verificado</cf_translate></strong></cfcase>
					<cfcase value="40"><strong><cf_translate key="LB_Revisión" xmlFile="/rh/generales.xml">Revisión</cf_translate></strong></cfcase>
					<cfcase value="50"><strong><cf_translate key="LB_Aplicado" xmlFile="/rh/generales.xml">Aplicado</cf_translate></strong></cfcase>
					<cfcase value="60"><strong><cf_translate key="LB_Evaluando" xmlFile="/rh/generales.xml">Evaluando</cf_translate></strong></cfcase>
				</cfswitch>
			</td>
		</tr>
		<tr><td>&nbsp;</td><td colspan="7">&nbsp;</td></tr>
	</table>
</cfoutput>

<cfset Form.TotalA = 0>
<cfset Form.TotalC = 0>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	 <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
		select #LvarRHPdescpuesto# as RHPdescpuesto, b.RHPcodigo
		from RHPuestos a inner join RHConcursos b
		  on a.Ecodigo 	  = b.Ecodigo and
		     a.RHPcodigo  = b.RHPcodigo
		where b.Ecodigo	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	</cfquery>
<!-----******* Pruebas *******------>	
	<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
	<cfquery name="RSPRuebas" datasource="#Session.DSN#">
		select a.RHPcodigopr, 
		<!---b.RHPdescripcionpr  || '('  ||<cf_dbfunction name="to_char" args="a.Cantidad">|| ')' RHPdescripcionpr, --->
		{fn concat(#LvarRHPdescripcionpr#,{fn concat('(',{fn concat(<cf_dbfunction name="to_char" args="a.Cantidad">,')')})})},
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

<form  action="#CurrentPage#" method="post" name="form1">
	<cfif isdefined("Form.tab")>
		<input type="hidden" name="tab" value="#Form.tab#">
	</cfif>
	<input type="hidden" name="paso" value="<cfif isdefined("Gpaso")>#Gpaso#<cfelse>0</cfif>">
	<input type="hidden" name="borrararea" value="">
	<input type="hidden" name="modificaPesoC" value="">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
	<input type="hidden" name="RHCcantplazas" value="#rsRHConcursos.RHCcantplazas#">
	<input type="hidden" name="ORHPcodigo" value="#rsRHConcursos.RHPcodigo#">
	
	<table width="95%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td width="25%">
				<fieldset><legend><strong>&Aacute;reas de Evaluación</strong></legend>
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>			
						<td width="82%" align="center" nowrap><strong>&Aacute;rea de Evaluación:</strong>&nbsp;</td>
						<td nowrap>&nbsp;<cf_rhareasevalconcurso name ="AreaEval"></td>
					</tr>	
					<tr>
						<td align="right"><strong>Peso:</strong>&nbsp;&nbsp;</td>
						<td>
							<input type="text" name="RHEApeso" size="8" maxlength="7" align="right" 
								onChange="javascript: fm(this,2); validaPeso(this);" 
								onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
							<cfset estado = ",'<img src=''/cfmx/rh/imagenes/Borrar01_T.gif'' onclick=''EliminaArea('||convert(varchar,a.RHEAid)||');'' width=''16'' height=''16''>' as estadoimg">
							<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.RHEAid = b.RHEAid and a.RHCconcurso = #rsRHConcursos.RHCconcurso#" >
							<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
								<cfset filtro = filtro & " and a.RHCconcurso = #rsRHConcursos.fRHCconcurso#	">
							</cfif>
							<cfset filtro = filtro & "and a.Ecodigo = b.Ecodigo"> 
							<cfset filtro = filtro & " order by RHCconcurso">		
                            <cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">				
							<cfquery name="rsListaAreas" datasource="#session.DSN#">
								select b.RHEAcodigo, #LvarRHEAdescripcion# as RHEAdescripcion, a.RHAECpeso as peso
								from RHAreasEvalConcurso a inner join RHEAreasEvaluacion b
								  on a.Ecodigo  = b.Ecodigo and
								  	 a.RHEAid 	= b.RHEAid 
								where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
								order by RHCconcurso
							</cfquery>
							<cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaRH"
								returnvariable="pListaDed">
									<cfinvokeargument name="tabla" value="RHAreasEvalConcurso a, RHEAreasEvaluacion b"/>
									<cfinvokeargument name="columnas" value=" b.RHEAcodigo, #LvarRHEAdescripcion# as RHEAdescripcion, a.RHAECpeso as peso #estado#"/>
									<cfinvokeargument name="desplegar" value="RHEAcodigo, RHEAdescripcion, peso,estadoimg"/>
									<cfinvokeargument name="etiquetas" value="Area, Descripci&oacute;n, Peso, Estado"/>
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
						<td colspan="2" align="right"><strong>Peso Total : <input name="TotalA" type="text" value="#Form.TotalA#" align="right" size="6" disabled></strong> &nbsp;</td> 
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					<cf_botones exclude="Baja,Limpiar">
					</fieldset>
<!--***********--->					
					<fieldset><legend><strong>Pruebas a realizar</strong></legend>
					<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					  <cfset index = 0>
					  <cfset Total = 0>
					  <cfif RSPRuebas.recordcount gt 0>
							<cfloop query="RSPRuebas">
								<cfset index = index + 1>
								<tr>
									<td  align="right" width="25%"><strong><cfoutput>#RSPRuebas.RHPdescripcionpr# :</cfoutput></strong></td>
									<td width="25%">
									<input type="text" name="Peso_<cfoutput>#index#</cfoutput>" id="Peso_<cfoutput>#index#</cfoutput>"
										value="<cfoutput>#LSNumberFormat(RSPRuebas.Peso,',9')#</cfoutput>"
										onBlur="javascript: fm(this,-1); if (window.funcalculaTotal) return funcalculaTotal();"  
										onFocus="javascript:this.value=qf(this); this.select();"
										onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									>%</td>
									<td width="25%">&nbsp;</td>
								</tr>
								<cfset Total = Total + RSPRuebas.Peso>
								<input type="hidden" name="RHPcodigopr_<cfoutput>#index#</cfoutput>" value="<cfoutput>#RSPRuebas.RHPcodigopr#</cfoutput>">
							</cfloop>
							<tr>
								<td  align="right" width="25%">Total</td>
								<td width="25%">
								<input disabled type="text"
								name="Total" id="Total"
								value="<cfoutput>#LSNumberFormat(Total,',9')#</cfoutput>"
								onBlur="javascript: fm(this,0);"  
								onFocus="javascript:this.value=qf(this); this.select();" 
								>%</td>
								<td width="25%">&nbsp;</td>
							</tr>
							<tr>
							  <td align="center" colspan="3"><input type="submit" name="btnModificaPrueba" value="Modificar"></td>
							</tr>
					  <cfelse>
							 <tr>
								<td  colspan="3" align="center" ><strong>----- No hay pruebas para este concurso -----</strong></td>
							 </tr> 
					  </cfif>
					  <input type="hidden" name="index" value="<cfoutput>#index#</cfoutput>">
					</table>			
					</fieldset>	
			</td>
			<td width="75%"> 
				<fieldset><legend><strong>Competencias</strong></legend>
				<cfquery name="rsConocimientos" datasource="#session.DSN#">
					select distinct c.RHHdescripcion as descripcion, (case when len(c.RHHdescripcion) > 37 then substring(c.RHHdescripcion,1,37) || '...' else c.RHHdescripcion end) as corta, b.Idcompetencia, b.RHCPpeso, 
						   (case when tipocompetencia ='H' then 'Habilidades'  else 'Conocimientos' end) as tipocompetencia, 
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
					
					select distinct c.RHCdescripcion as descripcion, (case when len(c.RHCdescripcion) > 37 then substring(c.RHCdescripcion,1,37) || '...' else c.RHCdescripcion end) as corta, b.Idcompetencia, b.RHCPpeso, 
						   (case when tipocompetencia ='C' then 'Conocimientos' else 'Habilidades' end) as tipocompetencia,
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
									<td align="center"><strong>ID</strong></td>
									<td width="51%" align="center"><strong>Descripci&oacute;n</strong></td>
									<td width="12%" align="center"><strong>Peso</strong></td>
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
							<td colspan="4" align="right"><strong>Peso Total :</strong> <input name="TotalCon" value="#Form.TotalC#" type="text" disabled size="6" align="right"></td> 
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
					<cfelse>
						<tr><td align="center" colspan="4"><strong>--- No hay competencias para el puesto. ---</strong></td></tr>
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
				<cfif (isdefined("rsConsulta") and rsConsulta.RecordCount EQ 0 and
					  isdefined("rsConsultaP") and rsConsultaP.RecordCount EQ 0)>
					<input name="publicar" type="hidden" value="No">
				<cfelse>
					<input name="publicar" type="hidden" value="Si">
				</cfif>
				<cfif isdefined("rsConocimientos") and rsConocimientos.RecordCount GT 0>
					<cf_botones modo="CAMBIO" exclude="Baja,Nuevo,Limpiar">
				</cfif>
				</fieldset>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>		
		<tr><td align="center" colspan="2"><strong>Peso Total de Criterios de Evaluaci&oacute;n:</strong> <input name="TotalGral" type="text" value="#Form.TotalGral#" disabled align="right" size="6"></td></tr>
	</table>
	<br>
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<!--- PANTALLA DE ADMINISTRACION DE CONCURSOS --->
	<cfif isdefined("Form.tab")>
		<p align="center">
			<input type="submit" name="btnAceptar" value="Aceptar">
		</p>
	<!--- PANTALLA DE REGISTRO DE SOLICITUDES DE CONCURSOS --->
	<cfelse>
		<cf_botones modo="CAMBIO" values= "<< Anterior,Siguiente >>" names = "Anterior,Siguiente">
	</cfif>
	<input name="RHCconcurso" type="hidden" value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
	<input name="pasoante" type="hidden" value="3">
	<input name="TotalAreas"  type="hidden" value="#Form.TotalA#">
	<input name="TotalComp" type="hidden" value="#Form.TotalC#">
	<input name="TotalGeneral" type="hidden" value="#Form.TotalGral#">
	
</form>
</cfoutput>

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
		objForm.Total.description = 'El total de las pruebas de ser el 100%';
	
		_addValidator("isCantidad", Cantidad_valida);
		objForm.Total.validateCantidad();
		function Cantidad_valida(){
			var Cantidad = new Number(this.value)	
			if ( Cantidad != 100){
				this.error = "El total de las pruebas de ser el 100%";
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
			document.form1.borrararea.value=true;
			document.form1.modificaPesoC.value = false;
			document.form1.action='concursoProceso.cfm';
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
			alert('El monto digitado debe ser estar del rango 0 - 100.');			
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
			alert('El peso digitado debe estar entre 0 y 100.');			
			eval("document.form1.RHEApeso.value = '0.00'");
			eval("document.form1.RHEApeso.focus();");
			return false;
		}
	} 
	
	function funcAnterior(){
		if (confirm('Si hay datos modificados se pueden perder. ¿Desea continuar?')){
			document.form1.paso.value =  2;
			return true;
		}
		else {
			document.form1.borrararea.value = false;
			document.form1.modificaPesoC.value = false;
			return true;
		}
	}
	
	function funcSiguiente(){
		var publica = document.form1.publicar.value;
		if (publica == "No"){
			alert('No se puede publicar sin Áreas de Evaluación ni Pruebas de Competencia. Verifique que hayan compentencias para el puesto.');
			return false;
		}
	}
	function funcAlta(){
		var area = document.form1.AreaEval.value;
		if (area == ""){
			alert('No se ha seleccionado un área. Verifique.');
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
</SCRIPT>
 