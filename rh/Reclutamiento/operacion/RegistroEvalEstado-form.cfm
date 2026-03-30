<!--- <cfdump var="#form#"> <cfdump var="#url#"> --->
<cfif isdefined("url.RHCconcurso") and not isdefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>

	<cfinclude template="/rh/portlets/pNavegacionIV.cfm">
 

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
		Select distinct RHCcodigo, substring(RHCdescripcion,1,55) as RHCdescripcion, RHCestado as estado
        from RHConcursos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >		  
		order by RHCdescripcion asc
	</cfquery>

	<cfquery  name="rsDescalificados" datasource="#Session.DSN#">
		select count(1) as Concursantes_Descalificados
		from RHConcursantes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and RHCdescalifica > 0
	</cfquery> 

	<cfquery  name="rsConcursantes" datasource="#Session.DSN#">
		select count(1) as Concursan
		from RHConcursantes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	</cfquery>
</cfif>
<cfoutput>
<form action="RegistroEvalEstado-SQL.cfm" method="post" name="form1">
<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">

	<table width="75%" align="center"  border="0" cellspacing="2" cellpadding="0">

		<tr>
			<td colspan="4" align="center" bgcolor="##cccccc" style="padding: 3PX; "><strong><FONT size="2">Concurso: #trim(rsRHConcursos.RHCcodigo)# - #rsRHConcursos.RHCdescripcion#</FONT></strong></td>
		</tr>

		<tr>
			<td align="right" align="right">Estado actual:&nbsp;</td>
			<td>
				<cfif rsRHConcursos.estado eq 0>
					En proceso
				<cfelseif rsRHConcursos.estado eq 10 >
					Solicitado
				<cfelseif rsRHConcursos.estado eq 15 >
					Verificado
				<cfelseif rsRHConcursos.estado eq 20 >
					Desierto
				<cfelseif rsRHConcursos.estado eq 30 >
					Cerrado
				<cfelseif rsRHConcursos.estado eq 40 >
					Revisi&oacute;n
				<cfelseif rsRHConcursos.estado eq 50 >
					Aplicado/Publicado
				<cfelseif rsRHConcursos.estado eq 60 >
					Evaluado
				<cfelseif rsRHConcursos.estado eq 70 >
					Terminado
				</cfif>
			</td>
		</tr>	

		<tr>
			<td align="right" align="right">Nuevo estado:&nbsp;</td>
			<td colspan="3" > 
				<select name="RHCestado" id="RHCestado">
					<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
						<!---
						<cfif rsDescalificados.Concursantes_Descalificados EQ rsConcursantes.Concursan>						
						  <option value="30">Cerrado</option>
						</cfif>
						<cfif rsConcursantes.Concursan EQ 0>
						  <option value="20">Desierto</option>
						</cfif>
						<cfif rsConcursantes.Concursan GT rsDescalificados.Concursantes_Descalificados and rsConcursantes.Concursan GT 0>
						  <option value="70">Terminado</option>
						</cfif>
						--->
					  <option value="30">Cerrado</option>
					  <option value="20">Desierto</option>
					  <option value="70">Terminado</option>
					</cfif>
				</select>
			</td>
		</tr>

		<tr>
			<td align="right" valign="top">Justificaci&oacute;n:&nbsp;</td>
			<td >
				<textarea name="RHCjustificacion" id="RHCjustificacion" rows="3" style="width:90% " ></textarea>
			</td>
		</tr>
		<tr>
			<!---<td colspan="4"><input name="Reporte" type="button" value="Reporte" onClick="javascript: funcReporte();"><cf_botones values= "Aplicar,Regresar" names = "Aplicar,Regresar"></td>--->
			<td colspan="4"><cf_botones values= "Aplicar,Regresar" names = "Aplicar,Regresar"></td>
		</tr>

	</table>


</form>
</cfoutput>
<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	function funcAplicar(){
		habilitarValidacion();
		if (confirm('¿Desea cambiar el estado del concurso?')){
			return true;
		}else{
			return false;
		}
	}
	function funcRegresar() {
		deshabilitarValidacion();
		document.form1.action='/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm';
		document.form1.RHCconcurso.value = '';
		document.form1.submit();
	}
	
	function funcReporte() {
	var params ="";
	deshabilitarValidacion();
		params = "<cfoutput>?RHCconcurso=#url.RHCconcurso#</cfoutput>";
		popUpWindowPuestos("/cfmx/rh/Reclutamiento/operacion/RegistroEvalInforme.cfm"+params,75,50,850,630);
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

	
	
	
	
	function habilitarValidacion(){
		objForm.RHCjustificacion.required = true;
		objForm.RHCjustificacion.description = 'Justificación';
	}

	function deshabilitarValidacion(){
		objForm.RHCjustificacion.required = false;
	}
	//objForm.RHCjustificacion.required = true;
	//objForm.RHCjustificacion.description = "Justificación";
	
	//-->
</script>