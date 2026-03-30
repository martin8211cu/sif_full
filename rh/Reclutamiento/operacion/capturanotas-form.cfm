<cfif isdefined("url.RHEAid") and (url.RHEAid gt 0) and not isdefined("form.RHEAid")>
	<cfset form.RHEAid= url.RHEAid >
</cfif>
<cfif isDefined("url.RHCconcurso") and (len(trim(#url.RHCconcurso#)) NEQ 0) and not isDefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso >
</cfif>
<cfif isDefined("url.RHCPid") and (len(trim(#url.RHCPid#)) NEQ 0) and not isDefined("form.RHCPid")>
	<cfset form.RHCPid = url.RHCPid >
</cfif>

<cfset modo = "ALTA">

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select RHCconcurso, RHCcodigo,#LvarRHCdescripcion# as  RHCdescripcion, 
			a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			b.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext, #LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
			RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
        from RHConcursos a
			left outer join RHPuestos b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo  = b.Ecodigo
			left outer join CFuncional c
				on a.CFid 	   = c.CFid
				and a.Ecodigo  = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
		order by RHCdescripcion asc
	</cfquery>

	<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
		select #LvarRHPdescpuesto# as RHPdescpuesto, b.RHPcodigo
		from RHPuestos a inner join RHConcursos b
		  on a.Ecodigo 	  = b.Ecodigo and
		     a.RHPcodigo  = b.RHPcodigo
		where b.Ecodigo	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	</cfquery>

	<cfquery name="rsDEid" datasource="#session.DSN#">
		select DEid, case RHCPtipo when 'I' then '<cf_translate key="LB_Interno" xmlFile="rh/generales.xml">Interno</cf_translate>' else '<cf_translate key="LB_Externo" xmlFile="rh/generales.xml">Externo</cf_translate>' end as tipo
		from RHConcursantes 
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCPid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>

	<cfif isdefined("rsDEid") and rsDEid.RecordCount GT 0 and LEN(rsDEid.DEid) GT 0>
		<cfset form.Concursante= rsDEid.DEid>
		<cfset tipo = rsDEid.tipo >
	</cfif>

	<cfquery name="rsRHOid" datasource="#session.DSN#">
		select RHOid, RHCPtipo as tipo 
		from RHConcursantes 
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCPid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>

	<cfif isdefined("rsRHOid") and rsRHOid.RecordCount GT 0 and LEN(rsRHOid.RHOid) GT 0>
		<cfset form.Concursante= rsRHOid.RHOid>
		<cfif not isdefined("tipo")>
			<cfset tipo = rsRHOid.tipo >
		</cfif>
	</cfif>
</cfif>

<cfif isdefined("rsDEid") and len(trim(rsDEid.DEid))>
	<cfquery name="nombre" datasource="#session.DSN#">
		select DEnombre as nombre, DEapellido1 as apellido1, DEapellido2 as apellido2
		from DatosEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
	</cfquery>
<cfelse>
	<cfquery name="nombre" datasource="#session.DSN#">
		select RHOnombre as nombre, RHOapellido1 as apellido1, RHOapellido2 as apellido2
		from DatosOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHOid.RHOid#">
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
	.flat, .flattd input {
		border:1px solid gray;
		height:19px;
	}
</style>

<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>
<form  action="capturanotas-SQL.cfm" method="post" name="form1" style="margin:0;">
	<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<BR>
      	<tr><td colspan="2"><cfinclude template="info-concurso.cfm"></td></tr>
	</table>

	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr><td >
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="&Aacute;reas de Evaluaci&oacute;n">
				<table width="100%" align="center" border="0" cellpadding="2" cellspacing="0">

					<tr><td colspan="4" bgcolor="##fafafa">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%" nowrap><font size="2"><strong>Concursante:</strong>&nbsp;</font></td>
								<td><font size="2">#nombre.nombre# #nombre.apellido1# #nombre.apellido2#</font></td>
							</tr>
							<tr>
								<td width="1%" nowrap><font size="2"><strong>Tipo:</strong>&nbsp;</font></td>
								<td><font size="2">#tipo#</font></td>
							</tr>
						</table>
					</td></tr>

					<tr valign="top">
						<td colspan="2" width="50%">
							<!--- <cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Evaluar Concursantes"> --->
								<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2" align="center" bgcolor="##CCCCCC" style="padding:1px;"><strong><font size="2">Evaluar Concursantes</font></strong></td></tr></table>
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
									<cfquery name="rsvalida1" datasource="#session.DSN#">
										select count(1) as valida1 
										from RHCalificaAreaConcursante
										where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
										  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
									</cfquery>
									<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
									<cfquery name="rsListaNotaGravada" datasource="#session.DSN#">
										select c.RHDAlinea, 
											   c.RHDAdescripcion, 
											   RHEAcodigo, 
											   b.RHEAid, 
											   #LvarRHEAdescripcion# as RHEAdescripcion
											   <cfif rsvalida1.valida1 GT 0>, RHCAONota, RHCAOid</cfif>
			
										from RHAreasEvalConcurso a 
										inner join RHEAreasEvaluacion b 
										  on a.RHEAid = b.RHEAid and 
											 a.Ecodigo = b.Ecodigo 
											 
										inner join RHDAreasEvaluacion c 
										  on c.RHEAid = b.RHEAid
										
										<cfif rsvalida1.valida1 GT 0>
											inner join RHCalificaAreaConcursante d 
											  on d.RHDAlinea = c.RHDAlinea and 
												 d.RHCconcurso = a.RHCconcurso
										</cfif>
										
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#">
										  <cfif rsvalida1.valida1 GT 0>
											  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
										  </cfif>
			
										order by b.RHEAcodigo, b.RHEAid
			
									</cfquery>
			
									<cfif isdefined("rsListaNotaGravada") and rsListaNotaGravada.RecordCount GT 0>
										<cfset AreaEncabezado = "">
										<cfloop query="rsListaNotaGravada">
											<cfif (currentRow Mod 2) eq 1>
												<cfset color = "Non">
											<cfelse>
												<cfset color = "Par">
											</cfif>
											<cfif AreaEncabezado NEQ rsListaNotaGravada.RHEAdescripcion>
												<cfset AreaEncabezado = rsListaNotaGravada.RHEAdescripcion>
												<tr class="listaCorte">
													<td colspan="4" style="padding-left:5px; "><strong>#rsListaNotaGravada.RHEAdescripcion#</strong></td>
												</tr>
												<tr class="tituloListas">
													<td width="5%" align="left"><strong>C&oacute;digo</strong></td>
													<td width="10%" align="left">&nbsp;&nbsp;<strong>Descripci&oacute;n</strong></td>
													<td width="5%" align="right" style="padding-right:6px; "><strong>Nota</strong></td>
												</tr>
											</cfif>
											<tr>
												<td width="5%" align="left" class="lista#color#">#rsListaNotaGravada.RHDAlinea#</td>
												<td width="10%"class="lista#color#">#rsListaNotaGravada.RHDAdescripcion#</td>
												<td width="5%"class="lista#color#" align="right" style="padding-right:6px; ">
													<input class="flat" style="text-align:right;" onFocus="this.select();"  name="peso_#rsListaNotaGravada.RHDAlinea#_#rsListaNotaGravada.RHEAid#" type="text" size="6"  maxlength="10"
															onChange="javascript: fm(this,2); validaPeso(this);"
															onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
															value="<cfif rsvalida1.valida1 GT 0>#Trim(LSNumberFormat(rsListaNotaGravada.RHCAONota,"___.__"))#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>" >
												</td>
												<input name="RHDAlinea_#rsListaNotaGravada.RHDAlinea#_#rsListaNotaGravada.RHEAid#" type="hidden" value="#trim(rsListaNotaGravada.RHDAlinea)#">
												<input type="hidden" name="RHCAOid_#trim(rsListaNotaGravada.RHDAlinea)#_#trim(rsListaNotaGravada.RHEAid)#" value="<cfif rsvalida1.valida1 GT 0>#rsListaNotaGravada.RHCAOid#</cfif>">
											</tr>
										</cfloop>
									</cfif>
									<tr><td colspan="9">&nbsp;</td></tr>
								</table>
							<!---<cf_web_portlet_end>	--->
						</td>
						
						<td width="50%" colspan="4">
							<!---<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Pruebas">--->
							<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2" align="center" bgcolor="##CCCCCC" style="padding:1px;"><strong><font size="2">Pruebas</font></strong></td></tr></table>
								<cfquery name="rsvalida2" datasource="#session.DSN#">
									select count (1) as valida2 
									from RHCalificaPrueConcursante 
									where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
								</cfquery>
                                <cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
								<cfquery name="rsListaNotaPGrabada" datasource="#session.DSN#">
									select distinct b.RHPcodigopr, #LvarRHPdescripcionpr# as RHPdescripcionpr
									<cfif rsvalida2.valida2 GT 0>
									, RHCPCNota, RHCPCid
									</cfif>
									from RHPruebas c inner join RHPruebasConcurso b 
									  on b.Ecodigo = c.Ecodigo and 
										 b.RHPcodigopr = c.RHPcodigopr
										 
									<cfif rsvalida2.valida2 GT 0>
									inner join RHCalificaPrueConcursante a 
									  on a.RHCconcurso = b.RHCconcurso and 
										 a.Ecodigo = b.Ecodigo and 
										 a.RHPcodigopr = b.RHPcodigopr
									</cfif>
									where b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									<cfif rsvalida2.valida2 GT 0>
									  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
									</cfif>
								</cfquery>
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
									<cfif isdefined("rsListaNotaPGrabada") and rsListaNotaPGrabada.RecordCount GT 0>
										<tr height="18%" bgcolor="F5F5F0">
											<td width="5%" align="left"><strong>C&oacute;digo</strong></td>
											<td width="10%" align="left"><strong>Descripci&oacute;n</strong></td>
											<td width="5%" align="right" style="padding-right:6px; "><strong>Nota</strong></td>
										</tr>
										<cfloop query="rsListaNotaPGrabada">
											<cfif (currentRow Mod 2) eq 1>
												<cfset color = "Non">
											<cfelse>
												<cfset color = "Par">
											</cfif>
											<!--- ********************************************* --->
											<tr>
												<td width="5%" align="left" class="lista#color#">#rsListaNotaPGrabada.RHPcodigopr#</td>
												<td width="10%"class="lista#color#">#rsListaNotaPGrabada.RHPdescripcionpr#</td>
												<td width="5%"class="lista#color#" align="right"  style="padding-right:6px; ">
													<input class="flat" style="text-align:right"  onFocus="this.select();" name="pesa_#lcase(trim(rsListaNotaPGrabada.RHPcodigopr))#"
													type="text" size="6"  maxlength="10"
													onChange="javascript: fm(this,2); validaPeso(this);"
													onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
													value="<cfif rsvalida2.valida2 GT 0>#rsListaNotaPGrabada.RHCPCNota#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>">
												<!--- rsListaNotaPGrabada --->
												</td>
												<input name="tipocompa_#rsListaNotaPGrabada.RHPcodigopr#" 
														type="hidden" value="#rsListaNotaPGrabada.RHPdescripcionpr#">
												<input name="Idcompa_#lcase(trim(rsListaNotaPGrabada.RHPcodigopr))#" 
														type="hidden" value="#rsListaNotaPGrabada.RHPcodigopr#">
												<input name="RHCPCid_#trim(rsListaNotaPGrabada.RHPcodigopr)#" 
														type="hidden" value="<cfif rsvalida2.valida2 GT 0>#rsListaNotaPGrabada.RHCPCid#</cfif>">
											</tr>
										</cfloop>
										<tr><td colspan="3">&nbsp;</td></tr>
									<cfelse>
										<tr><td align="center"><strong>--- No hay Pruebas. ---</strong></td></tr>
									</cfif>
								</table>
							<!---<cf_web_portlet_end>--->
						</td>
					</tr>
				</table>
			
				<br>
				<table width="90%" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center">
							<cfset ts = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
								<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
								</cfinvoke>
							</cfif>  
							<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
							<cfif rsvalida1.valida1 GT 0 or rsvalida2.valida2 GT 0>
								<cfset modo = "CAMBIO">
								<input type="submit" name="Cambio" value="Modificar">
								<input type="button" name="VerDetalle" value="Ver Detalle" onClick="javascript: funcAplicarEvaluacion();">
							<cfelse>
								<input type="submit" name="Alta" value="Agregar">
							</cfif> 
							<input type="submit" name="Regresar" value="Regresar" onClick="javascript:this.form.action='RegistroEval.cfm';">
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>		
				</table>
			<cf_web_portlet_end>
		</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>

	<input name="DEid" value="" type="hidden">
	<input name="RHCconcurso" type="hidden" value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
	<input type="hidden" name="RHCPid" value="#form.RHCPid#">

</form>
</cfoutput>


<cf_qforms form="form1">

<SCRIPT LANGUAGE="JavaScript">
	
	
	function validaPeso(peso){ 
		var nombre;
		if (peso.name){
		 	p = peso.value;
			nombre = peso.name;
		}
		else 
			p = peso;
		
		p = qf(p);
			
		if (p > 100) {
			alert('La Nota digitada debe estar entre 0 y 100.');			
			eval("document.form1."+ nombre + ".value = '0.00'");
			eval("document.form1."+ nombre + ".focus();");
			return false;
		}
	} 
	
	function funcAplicarEvaluacion(){ 
		<cfoutput>
		var PARAM  = "../Reportes/RH_infCalificaciones.cfm?RHCPid=#form.RHCPid#&RHCconcurso=#form.RHCconcurso#&eval=true"; 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400');
			return false;
		</cfoutput>
	}
</SCRIPT>
 <!---  <cfquery name="rsListaAreas" datasource="#session.DSN#">
							select c.RHDAlinea, c.RHDAdescripcion, b.RHEAcodigo, b.RHEAdescripcion, b.RHEAid
							from RHAreasEvalConcurso a
							
							inner join RHEAreasEvaluacion b
							on a.RHEAid = b.RHEAid
							and a.Ecodigo = b. Ecodigo
							
							inner join RHDAreasEvaluacion c
							on c.RHEAid = b.RHEAid
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.RHCconcurso= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.RHCconcurso#"> 
							order by b.RHEAcodigo, b.RHEAid
							</cfquery> --->