<!--- 
	Creado por Gustavo Fonseca H.
	Fecha: 16-4-2005.
	Motivo: Requerimiento de importación de notas.
 --->
 
<!--- <cfdump var="#form#">
 <cfdump var="#url#"> --->
<cfif isdefined("url.RHCPid") and len(trim(url.RHCPid)) and not isdefined("form.RHCPid")>
	<cfset form.RHCPid = url.RHCPid>
</cfif>

<!--- Oferente interno --->
<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
	<cfset form.DEid= url.DEid>
</cfif>

<!--- Oferente externo --->
<cfif isdefined("url.RHOid") and len(trim(url.RHOid)) and not isdefined("form.RHOid")>
	<cfset form.RHOid= url.RHOid>
</cfif>

<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso)) and not isdefined("form.RHCconcurso")>
	<cfset form.RHCconcurso= url.RHCconcurso>
</cfif>

<!--- Query del Concursante --->
	<cfquery name="rsConcursante" datasource="#Session.DSN#">
		select a.RHCPid, b.DEidentificacion as identificacion, 
				{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as Nombre,
			   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
		from RHConcursantes a, DatosEmpleado b
		where a.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		and b.DEid = a.DEid
		and b.Ecodigo = a.Ecodigo
		union
		select a.RHCPid, b.RHOidentificacion as identificacion, 
				{fn concat(b.RHOapellido1,{fn concat(' ',{fn concat(b.RHOapellido2,{fn concat(', ',b.RHOnombre)})})})} as Nombre,
			   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
		from RHConcursantes a, DatosOferentes b
		where a.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		and b.RHOid = a.RHOid
		and b.Ecodigo = a.Ecodigo
	</cfquery>
<!--- Areas --->
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
<cfquery name="rsListaNotaGrabada" datasource="#Session.DSN#">
	select  a.RHCAONota, 
			a.RHDAlinea, 
			#LvarRHEAdescripcion# as RHEAdescripcion, 
			c.RHDAdescripcion, 
			b.RHCconcurso, 
			b.RHCPid, 
			b.DEid, 
			c.RHEAid, 
			d.RHCcodigo, 
			d.RHCfcierre, 
			a.RHCAOid 
	from RHCalificaAreaConcursante a
			inner join RHConcursantes b
				on b.RHCPid = a.RHCPid
				and b.RHCconcurso = a.RHCconcurso
			inner join RHDAreasEvaluacion c
				on c.RHDAlinea = a.RHDAlinea
			inner join RHConcursos d
				on d.RHCconcurso = b.RHCconcurso
			inner join RHEAreasEvaluacion e
				on e.RHEAid = c.RHEAid 
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
				and b.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			</cfif>
			
			and d.RHCconcurso <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		order by d.RHCfcierre desc
</cfquery>

<!--- Pruebas --->
<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
<cfquery name="rsListaNotaPGrabada" datasource="#session.DSN#">
	select d.RHCfcierre, d.RHCcodigo, d.RHCconcurso, c.RHPcodigopr, #LvarRHPdescripcionpr# as RHPdescripcionpr, a.RHCPCNota, a.RHCPCid, d.RHCfcierre 
	from RHCalificaPrueConcursante a
		inner join RHConcursantes b
			on b.RHCPid = a.RHCPid
		inner join RHPruebasConcurso c
			on c.RHCconcurso = a.RHCconcurso
			and c.Ecodigo = a.Ecodigo
			and c.RHPcodigopr = a.RHPcodigopr
		inner join RHConcursos d
			on d.RHCconcurso = b.RHCconcurso
		inner join RHPruebas e
			on e.Ecodigo = c.Ecodigo
			and e.RHPcodigopr = c.RHPcodigopr
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
				and b.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			</cfif>
		and d.RHCconcurso <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	order by d.RHCfcierre desc

</cfquery>

<cfoutput>
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroQueDeseaAceptar"
	Default="¿Esta seguro que desea aceptar?"
	returnvariable="MSG_EstaSeguroQueDeseaAceptar"/>


<script language="javascript" type="text/javascript">
	function confirmar(){
	  
	  if(confirm('<cfoutput>#MSG_EstaSeguroQueDeseaAceptar#</cfoutput>'))
	   {
	   document.form1.submit();
	   	return true;
		}
	  else{
	  document.form1.action = '';
	  document.form1.submit();
	  return true;
	  }
	}


</script>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="1%">&nbsp;</td>
	    <td>&nbsp;</td>
	    <td width="1%">&nbsp;</td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>
			<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td width="1%">&nbsp;<strong><cf_translate key="LB_CRITERIOS">CRITERIOS</cf_translate></strong></td>
					<td align="right" width="25">&nbsp;</td>
				  </tr>
				</table>
			</fieldset>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td>&nbsp;</td>
		<td valign="top">
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<table width="99%" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid ##CCCCCC">
				  <tr style="height: 15;">
					<td class="tituloListas" nowrap>
						<font color="##000099" style="font-size:11px;"><strong>
						&nbsp;&nbsp;<cf_translate key="LB_Concursante">Concursante</cf_translate>: #rsConcursante.identificacion#&nbsp;&nbsp;#rsConcursante.nombre#
				    </strong></font>					</td>
					<td class="tituloListas" align="right" nowrap>&nbsp;</td>
				  </tr>
				  <tr style="height: 15;">
				  	<td class="tituloListas" nowrap>
						<font color="##000099" style="font-size:11px;"><strong>
						&nbsp;&nbsp;&nbsp;&nbsp;<cf_translate key="LB_ConcursosEnLosQueHaParticipado">Concursos en los que ha participado</cf_translate>:
						</strong></font>	
					</td>
				  </tr>
				</table>
				<form name="form1" method="post" action="ImportarNota_SQL.cfm">
				  <div id="divNuevo" style="overflow:auto; height: #380#; margin:0;" >
					
					<input type="hidden" name="op" value="3">
					<table border="0" cellspacing="0" cellpadding="0" align="left">
					<tr>
						<td colspan="4">
							<!--- <fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;"> --->
								<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
									<tr bgcolor="##DFDFDF">
								  		<td colspan="4" style="padding-left:0px; border-bottom:1px solid ##FFFFFF;">
											<strong><cf_translate key="LB_AREASDEEVALUACION">&Aacute;REAS&nbsp;DE&nbsp;EVALUACI&Oacute;N</cf_translate></strong>
										</td>
									</tr>
								</table>
							<!--- </fieldset> --->
						</td>
					</tr>
					  <cfif isdefined("rsListaNotaGrabada") and rsListaNotaGrabada.RecordCount GT 0>
						<cfset AreaEncabezado = "">
						<cfloop query="rsListaNotaGrabada">
						  <cfif (currentRow Mod 2) eq 1>
							<cfset color = "Non">
							<cfelse>
							<cfset color = "Par">
						  </cfif>
						  <cfif AreaEncabezado NEQ rsListaNotaGrabada.RHEAdescripcion>
							<cfset AreaEncabezado = rsListaNotaGrabada.RHEAdescripcion>
							
						  	<!--- <tr>
						  		<td colspan="4" height="1%" >
									&nbsp;
								</td>
						  	</tr> --->
							<tr  bgcolor="##DFDFDF">
							  <td colspan="1" style="padding-left:20px;" height="150%"><strong><cf_translate key="LB_Concurso">Concurso</cf_translate>:&nbsp;#trim(rsListaNotaGrabada.RHCcodigo)#</strong></td>
							  <td colspan="3" style="padding-left:5px;"><strong>#rsListaNotaGrabada.RHEAdescripcion#&nbsp;&nbsp;Fecha:&nbsp;#lsdateformat(rsListaNotaGrabada.RHCfcierre,'dd/mm/yyyy')#</strong></td>
							</tr>
							<!--- <tr>
							  <td colspan="1" style="padding-left:5px;">&nbsp;</td>							  
							  <td colspan="2" style="padding-left:5px;"><strong></strong></td>
							</tr> --->
							
							<tr class="tituloListas">
							  <td align="left" style="padding-left:30px;"><strong><cf_translate key="LB_EcportarNotas">Exportar&nbsp;Notas</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
							  <td align="right" style="padding-right:5px;"><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
							</tr>
						  </cfif>
						  <tr>
							<td class="lista#color#" style="padding-left:55px;">&nbsp;&nbsp;<input type="checkbox" name="chk" value="#rsListaNotaGrabada.RHDAlinea#|#rsListaNotaGrabada.RHCAONota#|#rsListaNotaGrabada.RHEAid#"></td>
							<td class="lista#color#" style="padding-right:5px;" nowrap>#trim(rsListaNotaGrabada.RHDAlinea)#</td>
							<td class="lista#color#" style="padding-right:5px;">#trim(rsListaNotaGrabada.RHDAdescripcion)#</td>
							<td class="lista#color#" align="right" style="padding-right:5px;">
							  
							  <cfif Len(Trim(rsListaNotaGrabada.RHCAONota))>#Trim(LSNumberFormat(rsListaNotaGrabada.RHCAONota,"___.__"))#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>
							  <input name="RHDAlinea_#rsListaNotaGrabada.RHDAlinea#_#rsListaNotaGrabada.RHEAid#" type="hidden" value="#trim(rsListaNotaGrabada.RHDAlinea)#">
							  <input type="hidden" name="RHCAOid_#trim(rsListaNotaGrabada.RHDAlinea)#_#trim(rsListaNotaGrabada.RHEAid)#" value="#rsListaNotaGrabada.RHCAOid#">
							</td>
						  </tr>
						</cfloop>
					  </cfif>
					  	<tr class="listaCorte">
						  <td colspan="4" style="padding-left:0px;">&nbsp;</td>
						</tr> 
					  	<tr bgcolor="##DFDFDF">
						  <td colspan="4" style="padding-left:0px;">
							<!--- <fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;"> --->
							  <table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
								<tr>
									<td colspan="4" style=" border-bottom:1px solid ##FFFFFF;"><strong><cf_translate key="LB_PRUEBAS">PRUEBAS</cf_translate></strong></td>
								</tr>
							  </table>
							 <!--- </fieldset> --->
						  
						  </td>
						</tr>
						<cfif isdefined("rsListaNotaPGrabada") and rsListaNotaPGrabada.RecordCount GT 0>
						<cfset AreaEncabezadoD = "">
						<cfloop query="rsListaNotaPGrabada">
						  <cfif (currentRow Mod 2) eq 1>
							<cfset color = "Non">
							<cfelse>
							<cfset color = "Par">
						  </cfif>
						  <cfif AreaEncabezadoD NEQ rsListaNotaPGrabada.RHCcodigo>
							<cfset AreaEncabezadoD = rsListaNotaPGrabada.RHCcodigo>
						<tr bgcolor="##DFDFDF">
							  <td colspan="1" style="padding-left:20px;"><strong><cf_translate key="LB_Concurso">Concurso</cf_translate>:&nbsp;#trim(rsListaNotaPGrabada.RHCcodigo)#</strong></td>
							  <td colspan="3" style="padding-left:5px;"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;#lsdateformat(rsListaNotaPGrabada.RHCfcierre,'dd/mm/yyyy')#</strong></td>
							</tr>
							<tr class="tituloListas">
							  <td align="left" style="padding-left:30px;"><strong><cf_translate key="LB_ExportarNotas">Exportar&nbsp;Notas</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
							  <td align="left" style="padding-right:5px;"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
							  <td align="right" style="padding-right:5px;"><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
							</tr>
						</cfif>
								<tr>
								<cfquery name="rsConsulta" datasource="#session.DSN#">
									select RHPcodigopr
									from RHCalificaPrueConcursante
									where Ecodigo =1
										and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#rsListaNotaPGrabada.RHPcodigopr#">
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
								</cfquery>
								  <td class="lista#color#" style="padding-left:55px;">&nbsp;<input type="checkbox" name="chk_Pruebas" value="#trim(rsListaNotaPGrabada.RHPcodigopr)#|#rsListaNotaPGrabada.RHCPCNota#|#rsListaNotaPGrabada.RHCconcurso#" <cfif rsConsulta.recordcount EQ 0>disabled</cfif> ></td>
									<td class="lista#color#" style="padding-right:5px;">#trim(rsListaNotaPGrabada.RHPcodigopr)#</td>
									<td class="lista#color#" style="padding-right:5px;">#trim(rsListaNotaPGrabada.RHPdescripcionpr)#</td>
									<td class="lista#color#" align="right" style="padding-right:5px;">
										
										<cfif Len(Trim(rsListaNotaPGrabada.RHCPCNota))>#rsListaNotaPGrabada.RHCPCNota#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>
										<input name="tipocompa_#rsListaNotaPGrabada.RHPcodigopr#" 
												type="hidden" value="#rsListaNotaPGrabada.RHPdescripcionpr#">
										<input name="Idcompa_#trim(rsListaNotaPGrabada.RHPcodigopr)#" 
												type="hidden" value="#rsListaNotaPGrabada.RHPcodigopr#">
										<input name="RHCPCid_#trim(rsListaNotaPGrabada.RHPcodigopr)#" 
												type="hidden" value="<cfif Len(Trim(rsListaNotaPGrabada.RHCPCid))>#rsListaNotaPGrabada.RHCPCid#</cfif>">
									</td>
								</tr>
						  </cfloop>
							<tr><td colspan="4">&nbsp;</td></tr>
						<cfelse>
							<tr><td colspan="4" align="center"><strong>--- <cf_translate key="LB_NoHayPruebas">No hay Pruebas</cf_translate>. ---</strong></td></tr>
						</cfif>
					</table>
				  </div>
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <tr style="height: 25;">
						<td colspan="4" align="center" valign="middle" nowrap>

							<cfif isdefined("form.DEid") and len(trim(form.DEid))>
								<input type="hidden" name="DEid" value="#form.DEid#">
							<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
								<input type="hidden" name="RHOid" value="#form.RHOid#">
							</cfif>
							<input type="hidden" name="RHCconcurso" value="#form.RHCconcurso#">
							<input type="hidden" name="RHCPid" value="#form.RHCPid#">
							<input type="submit" name="btnAceptar" value="Aceptar" onClick="confirmar()">
						</td>
					  </tr>
					</table>
				</form>
			</fieldset>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>


