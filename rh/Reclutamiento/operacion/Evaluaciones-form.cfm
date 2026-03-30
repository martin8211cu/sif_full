<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select  RHCconcurso,RHCPid, DEidentificacion as identificacion,
		 <cf_dbfunction name="concat" args=" b.DEnombre,' ', b.DEapellido1,'  ',b.DEapellido2">  as Nombre,
		 	RHCdescalifica, RHCrazondeacalifica
			from RHConcursantes a inner join DatosEmpleado b
			  on a.DEid  = b.DEid 
			where b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#" >
			  and RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >	
	</cfquery>
	<cfif (isdefined("rsForm") and rsForm.RecordCount EQ 0) or not isdefined("rsForm")>
		<cfquery name="rsForm" datasource="#session.DSN#">
			select  RHCconcurso,RHCPid, RHOidentificacion as identificacion,
			 <cf_dbfunction name="concat" args=" b.RHOnombre,' ', b.RHOapellido1,'  ',b.RHOapellido2">  as Nombre,
			 RHCdescalifica, RHCrazondeacalifica
				from RHConcursantes a inner join DatosOferentes b
				  on a.RHOid  = b.RHOid 
				where b.RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#" >
				  and RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >	
		</cfquery>
	</cfif>
</cfif>

<style type="text/css">
.flat, .flattd input {
	border:1px solid gray;
	height:19px;
}
</style>

<!---<cf_web_portlet_start border="true" titulo="Selecci&oacute;n de Concursantes" skin="#Session.Preferences.Skin#">--->
<table width="100%" height="80%" align="center" border="0" cellpadding="3" cellspacing="0" >
	<tr><td colspan="2"><cfinclude template="info-concurso.cfm"></td></tr>
<!---<cf_web_portlet_end>--->

	<tr><td colspan="2">
		<br>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
			<!---<tr><td colspan="2" align="center" bgcolor="#CCCCCC" style="padding:3px;"><strong><font size="2">Concursantes</font></strong></td></tr>--->
			<tr>
				<td width="48%" valign="top">
					<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Concursantes">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td>
								<cfquery name="rsLista" datasource="#session.DSN#">							
									select  RHCconcurso,
											RHCPid, 
											DEidentificacion as identificacion,
											 <cf_dbfunction name="concat" args=" b.DEnombre,' ', b.DEapellido1,'  ',b.DEapellido2">  as Nombre,
											a.RHCdescalifica,
											coalesce(a.RHCPpromedio,0) as RHCPpromedio,
											case a.RHCPtipo when 'I' then 'Interno' else 'Externo' end as tipo,
											(case RHCdescalifica when 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
												else'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' end) as descalificado 
									from RHConcursantes a 
									inner join  DatosEmpleado b 
									  on a.Ecodigo  = b.Ecodigo and 
										 a.DEid  	= b.DEid
									where a. Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
									  and RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >
									
									union
									
									select  RHCconcurso,
											RHCPid, 
											RHOidentificacion as identificacion,
											<cf_dbfunction name="concat" args=" b.RHOnombre,' ', b.RHOapellido1,'  ',b.RHOapellido2">  as Nombre,
											a.RHCdescalifica,
											coalesce(a.RHCPpromedio,0) as RHCPpromedio,
											case a.RHCPtipo when 'I' then 'Interno' else 'Externo' end as tipo,
											(case RHCdescalifica when 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
												else'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' end) as descalificado 
									from RHConcursantes a 
									inner join  DatosOferentes b 
									  on a.Ecodigo = b.Ecodigo and 
										 a.RHOid   = b.RHOid
									where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
									  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >							  
									  order by 3, 4
								</cfquery>
								
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr style="padding:3px; ">
										<td class="tituloListas" style="padding-left:25px; ">Identificación</td>
										<td class="tituloListas">Nombre</td>
										<td class="tituloListas" align="center">Tipo</td>
										<td class="tituloListas" align="right">Calificaci&oacute;n</td>
										<td class="tituloListas" align="center">Descalificado</td>
										<td class="tituloListas" colspan="2">&nbsp;</td>
									</tr>
									<cfoutput query="rsLista">
										<tr style="padding:3px;" class="<cfif rsLista.currentrow mod 2>listaNon<cfelse>listaPar</cfif>" >
											<td style="padding-left:25px; ">#rsLista.identificacion#</td>
											<td>#rsLista.Nombre#</td>
											<td align="center">#rsLista.tipo#</td>
											<td align="right">#LSNumberFormat(rsLista.RHCPpromedio,',9.00')#</td>
											<td align="center">#rsLista.descalificado#</td>
											<td align="right"><input class="flat" type="button" name="Descalificar" value="Descalificar" onClick="javascript:descalificar(#rsLista.RHCconcurso#, #rsLista.RHCPid#, #rsLista.RHCdescalifica#);"></td>
											<td width="1%"><input class="flat" type="button" name="Evaluar" value="Evaluar" onClick="javascript:evaluar(#rsLista.RHCconcurso#, #rsLista.RHCPid#, #rsLista.RHCdescalifica#);"></td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
					</table>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
	
		<cfquery name="rsTotal" datasource="#session.DSN#">
			select a.*
			from RHConcursantes a
			
			inner join DatosEmpleado b
			on a.Ecodigo=b.Ecodigo
			and a.DEid=b.DEid
			
			where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			  and a.RHCdescalifica = 0

			union 

			select a.*
			from RHConcursantes a
			
			inner join DatosOferentes b
			on a.Ecodigo=b.Ecodigo
			and a.RHOid=b.RHOid
			
			where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			  and a.RHCdescalifica = 0
		</cfquery>

		<cfquery name="rsEvaluados" datasource="#session.DSN#">
			select a.*
			from RHConcursantes a
			
			inner join DatosEmpleado b
			on a.Ecodigo=b.Ecodigo
			and a.DEid=b.DEid
			
			where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			  and a.RHCdescalifica = 0
  			  and a.RHCevaluado = 1

			union 

			select a.*
			from RHConcursantes a
			
			inner join DatosOferentes b
			on a.Ecodigo=b.Ecodigo
			and a.RHOid=b.RHOid
			
			where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			  and a.RHCdescalifica = 0
  			  and a.RHCevaluado = 1
		</cfquery>

		<form action="listaRegistroEval.cfm" method="post" name="form1">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="center">
						<input name="RHCconcurso" type="hidden" value="<cfoutput>#form.RHCconcurso#</cfoutput>">
						<input name="RHCPid" type="hidden" value="">
						<cfif rsEvaluados.recordcount gte rsTotal.recordcount >
							<input type="submit" name="btnAplicar" value="Aplicar" onClick="javascript:return false;">
						</cfif>
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript:regresar();">
					</td>
				</tr>
			</table>
		</form>
	</td></tr>
</table>	

<script language="JavaScript" type="text/JavaScript">
	<!--
	function regresar() {
		document.form1.RHCconcurso.value= '';
		document.form1.action='/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm';
		document.form1.submit();
	}
	
	function Siguiente(){
		valor = document.form1.RHCconcurso.value;
		document.form1.action='/cfmx/rh/Reclutamiento/operacion/ConcursantesSeleccionados.cfm?RHCconcurso=' + valor;
		document.form1.submit();	
	}
	
	function descalificar(concurso, concursante, descalificado){
		if (descalificado == 1){
			alert('El concursante ya esta descalificado para este concurso,\n unicamente puede modificar el motivo de la descalificación.' );
		}

		document.form1.RHCPid.value = concursante;
		document.form1.action='/cfmx/rh/Reclutamiento/operacion/descalificar.cfm';
		document.form1.submit();	
	}

	function evaluar(concurso, concursante, descalificado){
		if (descalificado == 1){
			alert('El concursante esta descalificado, no puede ser evaluado.' );
			return;
		}

		document.form1.RHCPid.value = concursante;
		document.form1.action='/cfmx/rh/Reclutamiento/operacion/capturanotas.cfm';
		document.form1.submit();	
	}

	//-->
</script>
