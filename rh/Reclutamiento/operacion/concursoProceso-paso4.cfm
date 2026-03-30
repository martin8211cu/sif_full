<cfset modo = "ALTA">
<cfif isDefined("session.Ecodigo") and isDefined("Gconcurso") and len(trim(#Gconcurso#)) NEQ 0>
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select RHCconcurso, RHCcodigo, #LvaRHCdescripcion# as RHCdescripcion, 
			a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp,
			a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,#LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
			RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
        from RHConcursos a
			left outer join RHPuestos b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo  = b.Ecodigo
			left outer join CFuncional c
				on a.CFid 	  = c.CFid
				and a.Ecodigo = c.Ecodigo
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#" >
		order by RHCdescripcion asc
	</cfquery>
	
	<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
		select a.RHPdescpuesto, b.RHPcodigo
		from RHPuestos a inner join RHConcursos b
		  on a.Ecodigo   = b.Ecodigo and
		 	 a.RHPcodigo = b.RHPcodigo
		where b.Ecodigo	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#" >
	</cfquery>
	
	<cfif rsRHConcursos.recordcount>
		<cfset modo = "CAMBIO">
	</cfif> 
</cfif>
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
<cfquery name="rsAreasConsulta" datasource="#session.DSN#">
	Select b.RHEAcodigo as Codigo, #LvarRHEAdescripcion# as RHEAdescripcion as Descrip, a.RHAECpeso as peso
	From RHAreasEvalConcurso a inner join RHEAreasEvaluacion b
	  on a.RHEAid = b.RHEAid 
	Where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#" >
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #E1E1E1;
		font-weight: bold;
		color: #000000;
		padding-top: 10px;
		padding-bottom: 10px;
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
}
</style>
<cfoutput>
<form  action="#CurrentPage#" method="post" name="form1">
	<input type="hidden" name="paso" value="#Gpaso#">
	<input type="hidden" name="borrararea" value="">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			
			<td width="14%" align="right" nowrap><strong>C&oacute;digo de Concurso:&nbsp;</strong></td>
			<td width="20%">
				#rsRHConcursos.RHCcodigo#
			</td>
			<td align="right" width="12%" nowrap><strong>&nbsp; &nbsp;Fecha Apertura:&nbsp;</strong></td>
			<td align="left" width="5%">
				<cfif modo neq "ALTA">
					<cfset fechaI = #rsRHConcursos.RHCfapertura# >
				<cfelse>
					<cfset fechaI = '' >
				</cfif>
				#LSDateFormat(fechaI,'dd/mm/yyyy')#
			</td>
			<td width="13%" align="left" nowrap><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha Cierre:</strong>&nbsp;</td>
			<td width="6%" align="left" >
				<cfif modo neq "ALTA">
					<cfset fechaF = #rsRHConcursos.RHCfcierre# >
				<cfelse>
					<cfset fechaF = '' >
				</cfif>
				#LSDateFormat(fechaF,'dd/mm/yyyy')#
			</td>
		<cfif modo neq "ALTA">
			<td width="6%" align="right">&nbsp;&nbsp;<strong>Estado:</strong>&nbsp;</td>
			<td width="24%" align="left"> 
					
					<cfswitch expression="#rsRHConcursos.RHCestado#">
						<cfcase value="0">
							<strong>En&nbsp;Proceso</strong>
						</cfcase>
						<cfcase value="10">
							<strong>Solicitado</strong>
						</cfcase>
						<cfcase value="20">
							<strong>Desierto</strong>
						</cfcase>
						<cfcase value="30">
							<strong>Cerrado</strong>
						</cfcase>
						<cfcase value="15">
							<strong>Verificado</strong>
						</cfcase>
						<cfcase value="40">
							<strong>Revisi&oacute;n</strong>
						</cfcase>
						<cfcase value="50">
							<strong>Aplicado</strong>
						</cfcase>
					</cfswitch>
			</td>
			</cfif>
		</tr>
		<tr>
		  <td align="right" nowrap>&nbsp;</td>
		  <td align="left">&nbsp;</td>
		  <td align="right" nowrap>&nbsp;</td>
		  <td align="left" colspan="5">&nbsp;</td>
	  	</tr>
		<tr>
			<td align="right" nowrap><strong>&nbsp; N&deg; Plazas:&nbsp;</strong></td>
			<td align="left">#rsRHConcursos.RHCcantplazas#</td>
			<td align="right" nowrap><strong>C&oacute;digo del Puesto:&nbsp;</strong></td>
			<cfif isDefined("session.Ecodigo") and isDefined("Gconcurso") and len(trim(#Gconcurso#)) NEQ 0>
			<td align="left" colspan="5">#rsBuscaPuesto.RHPcodigoext#-&nbsp;#rsBuscaPuesto.RHPdescpuesto#</td>
			</cfif>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right"><strong>Centro Funcional:&nbsp;</strong></td>
			<td align="left" colspan="3">#rsRHConcursos.CFcodigoresp# - #rsRHConcursos.CFdescripcionresp#</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		</table>
	<table width="90%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr valign="top">
		<td colspan="4">
			<fieldset><legend><strong>&Aacute;reas de Evaluación</strong></legend>
			<table width="100%" height="44" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="7" align="center">
						<cfset estado = ",'<img src=''/cfmx/rh/imagenes/Borrar01_T.gif'' onclick=''EliminaArea('||convert(varchar,a.RHEAid)||');'' width=''16'' height=''16''>' as estadoimg">
						<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.RHEAid = b.RHEAid and a.RHCconcurso = #Gconcurso#" >
						<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
							<cfset filtro = filtro & " and a.RHCconcurso = #form.fRHCconcurso#	">
						</cfif>
						<cfset filtro = filtro & "and a.Ecodigo = b.Ecodigo"> 
						<cfset filtro = filtro & " order by RHCconcurso"> 
                        <cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaDed">
								<cfinvokeargument name="tabla" value="RHAreasEvalConcurso a, RHEAreasEvaluacion b"/>
								<cfinvokeargument name="columnas" value="b.RHEAcodigo, #LvarRHEAdescripcion# as RHEAdescripcion, RHAECpeso as peso"/>
								<cfinvokeargument name="desplegar" value="RHEAcodigo, RHEAdescripcion, peso"/>
								<cfinvokeargument name="etiquetas" value="Area, Descripci&oacute;n, Peso"/>
								<cfinvokeargument name="formatos" value="S, S, M"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left, left, right"/>
								<cfinvokeargument name="ajustar" value="S"/>
								<cfinvokeargument name="debug" value="N"/>
								<cfinvokeargument name="showEmptyListMsg" value= "1"/>
								<cfinvokeargument name="incluyeform" value="false"/>
								<cfinvokeargument name="formname" value="form1"/>
								<cfinvokeargument name="showLink" value="false"/>
						</cfinvoke>		
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>
			</fieldset>
		</td>
		<td colspan="7">
			<cfquery name="rsConocimientos" datasource="#session.DSN#">
				select distinct c.RHHdescripcion as descripcion, case when len(c.RHHdescripcion) > 45 then substring(c.RHHdescripcion,1,45) || '...' else c.RHHdescripcion end as corta, b.Idcompetencia, b.RHCPpeso, 
					   case when tipocompetencia ='H' then 'Habilidades'  else 'Conocimientos' end as tipocompetencia, 
					   tipocompetencia as tipo
				from RHConcursos a inner join RHCompetenciasConcurso b
				  on a.Ecodigo 		 = b.Ecodigo and
					 a.RHCconcurso   = b.RHCconcurso inner join RHHabilidades c
				  on b.Idcompetencia = c.RHHid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHConcursos.RHPcodigo#">
					and b.tipocompetencia= 'H'
					and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
					
				UNION
				
				select distinct c.RHCdescripcion as descripcion, case when len(c.RHCdescripcion) > 45 then substring(c.RHCdescripcion,1,45) || '...' else c.RHCdescripcion end as corta, b.Idcompetencia, b.RHCPpeso, 
					   case when tipocompetencia ='C' then 'Conocimientos' else 'Habilidades' end as tipocompetencia,
					   tipocompetencia as tipo
				from RHConcursos a inner join RHCompetenciasConcurso b
				  on a.Ecodigo 		 = b.Ecodigo and
					 a.RHCconcurso 	 = b.RHCconcurso  inner join RHConocimientos c
				  on b.Idcompetencia = c.RHCid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHConcursos.RHPcodigo#">
					and b.tipocompetencia= 'C'
					and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
				order by tipo, Idcompetencia
			</cfquery>		 
		<fieldset><legend><strong>Competencias</strong></legend>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			<cfset competencia = "">
			<cfif isdefined("rsConocimientos") and rsConocimientos.RecordCount GT 0>
				<cfloop query="rsConocimientos">
					<cfif (currentRow Mod 2) eq 1>
						<cfset color = "Non">
					<cfelse>
						<cfset color = "Par">
					</cfif>
					<cfif competencia NEQ rsConocimientos.tipo>
						<cfset competencia = rsConocimientos.tipo>
						<tr><td>&nbsp;</td></tr>
						<tr class="encabReporte" height="18">
							<td colspan="3"><strong>&nbsp;&nbsp;&nbsp;#Ucase(rsConocimientos.tipocompetencia)#</strong></td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr height="18" bgcolor="F5F5F0">
							<td align="center"><strong>ID</strong></td>
							<td width="51%" align="center"><strong>Descripci&oacute;n</strong></td>
							<td width="12%" align="center"><strong>Peso</strong></td>
							<td width="5%">&nbsp;</td>
						</tr>
					</cfif>
					<tr height="18">
						<td width="10%" align="center" class="lista#color#">#rsConocimientos.Idcompetencia#</td>
						<td class="lista#color#" nowrap>#rsConocimientos.corta#</td>
						<td class="lista#color#" align="right">#LSNumberFormat(rsConocimientos.RHCPpeso,"___.__")#</td>
						<td class="lista#color#" width="5%">&nbsp;</td>
					</tr>
				</cfloop>
				<tr><td>&nbsp;</td></tr>
			<cfelse>
				<tr><td align="center"><strong>--- No hay competencias para el puesto. ---</strong></td></tr>
			</cfif>
		</table>
		</fieldset>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>			
	</table>
	<cfquery name="rsConsultaP" datasource="#session.DSN#">
		select 1
		from RHPruebasConcurso
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
	</cfquery>
		<cfif (isdefined("rsConsultaP") and rsConsultaP.RecordCount EQ 0) or (isdefined("Form.TotalGeneral") and Form.TotalGeneral GT 100)>
			<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
				<tr>
					<td colspan="2">&nbsp;&nbsp;<strong>Observaciones:</strong></td>
				</tr>
				<tr>
					<cfif  rsConsultaP.RecordCount EQ 0>
						<td width="93%" align="center"><font color="red"><strong>No hay pruebas asociadas al puesto.</strong></font></td>
					</cfif>	
				</tr>	
				<tr>
					<cfif isdefined("form.TotalGeneral") and Form.TotalGeneral GT 100>
						<td width="93%" align="center">
							<font color="red">
								<strong>El Peso Total de Criterios de Evaluaci&oacute;n excede los 100 puntos.</strong>
							</font>
						</td>
					</cfif>
					<td width="5%">&nbsp;</td>					
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</cfif>
		<br>
	<cf_botones values= "<< Anterior,Publicar" names = "Anterior,Publicar">
	
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
		</cfinvoke>
	</cfif> 
	<input name="RHCconcurso" type="hidden" 
		value="<cfif isdefined("Gconcurso")and (Gconcurso GT 0)><cfoutput>#Gconcurso#</cfoutput></cfif>">
	<input name="RHPcodigo" type="hidden" 
		value="<cfif isdefined("rsRHConcursos.RHPcodigo")and (rsRHConcursos.RHPcodigo GT 0)><cfoutput>#rsRHConcursos.RHPcodigo#</cfoutput></cfif>">
	<input name="CFid" type="hidden" value="<cfif isdefined("form.CFid")and (form.CFid GT 0)><cfoutput>#form.CFid#</cfoutput></cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
</form>
</cfoutput>
<cf_qforms form="form1">

<SCRIPT LANGUAGE="JavaScript">
<!--
	function funcAnterior() {
		document.form1.borrararea.value=false;
		document.form1.paso.value='3';
	}
	
	function funcPublicar(){
		if (confirm('¿Desea publicar el concurso?')){
			return true;
		}else{
			return false;
		}
	}
//-->
</SCRIPT>
