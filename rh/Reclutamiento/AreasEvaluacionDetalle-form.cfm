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
<cfif isDefined("form.usucodigo") and not len(trim(form.usucodigo)) neq 0>
	<cfset form.usucodigo = form.usucodigo>
</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.RHEAid") and len(trim(#Form.RHEAid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHEAdescripcion#°1°55" delimiters="°" returnvariable="LvarRHEAdescripcion">
	<cfquery name="rsRHEAreasEvaluacion" datasource="#Session.DSN#" >
		Select distinct #LvarRHEAdescripcion# as RHEAdescripcion, Usucodigo 
        from RHEAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAid#" >		  
		order by #LvarRHEAdescripcion# asc
	</cfquery>
</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.RHDAlinea") and len(trim(#Form.RHDAlinea#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" returnvariable="LvarRHDAdescripcion">
	<cf_translatedata name="validar" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" filtro="RHDAlinea = #Form.RHDAlinea#"/>
	<cfquery name="rsRHDAreasEvaluacion" datasource="#Session.DSN#" >
		Select 	RHEAid, 
				substring(#LvarRHDAdescripcion#,1,55) as RHDAdescripcion ,
				RHDAnotamin,  
				RHDAobs, 
				RHDAfecha, 
				Usucodigo, 
				ts_rversion
				<cfif isDefined("request.usetranslatedata") and request.usetranslatedata>
					,RHDAobs_#session.idioma# as RHDAobs2
				</cfif>
        from RHDAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAid#">
		  and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#" >		  
		order by #LvarRHDAdescripcion# asc
	</cfquery>
</cfif>

<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script> 


<form action="AreasEvaluacionDetalle-SQL.cfm" method="post" name="formArea">  <cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
		  <td width="8%" align="right" nowrap>&nbsp;</td>
		  <td width="16%" align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
		  <td colspan="3"><input name="RHDAdescripcion" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsRHDAreasEvaluacion.RHDAdescripcion#</cfoutput></cfif>" size="60" maxlength="80" onFocus="this.select();"  alt="La Descripci&oacute;n del Area"></td>
	  </tr>
		<tr>
		  <td align="right" nowrap>&nbsp;</td>
		  <td align="right" nowrap><strong>#LB_NotaMinima#:&nbsp;</strong></td>
		  <td colspan="3" align="left"><span class="subTitulo">
		    <input name="RHDAnotamin" type="text"   onChange="javascript:fm(this,2);" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};" value="<cfif modo neq "ALTA"><cfoutput>#rsRHDAreasEvaluacion.RHDAnotamin#</cfoutput></cfif>" size="10" maxlength="5" onFocus="this.select();"  alt="Nota m&iacute;nima">
		  </span></td>
	  </tr>
		<tr>
		  <td height="113" align="right" nowrap>&nbsp;</td>
		  <td align="right" nowrap><strong>#LB_Observaciones#:&nbsp;</strong></td>
		  <cfset LvarObser=''>
		  <cfif isdefined("rsRHDAreasEvaluacion.RHDAobs") >
		  	<cfset LvarObser=rsRHDAreasEvaluacion.RHDAobs>
		  </cfif>
		  <cfif isDefined("request.usetranslatedata") and request.usetranslatedata and isdefined("rsRHDAreasEvaluacion.RHDAobs2") and len(trim(rsRHDAreasEvaluacion.RHDAobs2))>
		  		<cfset LvarObser = trim(rsRHDAreasEvaluacion.RHDAobs2)>
		  </cfif>
		  <td colspan="2" align="left"><textarea name="RHDAobs" rows="5" onFocus="this.select();"><cfif isdefined("rsRHDAreasEvaluacion") and modo NEQ 'Alta'><cfoutput>#trim(LvarObser)#</cfoutput></cfif></textarea></td>
		  <td width="18%" align="left"></td>
	  </tr>
		<tr>
		  <td align="right" nowrap>&nbsp;</td> 
			<td align="right" nowrap><strong>&nbsp; &nbsp;#LB_Fecha#:&nbsp;</strong></td>
			<td width="36%" align="left">
				<cfif modo neq "ALTA">
					<cfset fechaI = #LSDateFormat(rsRHDAreasEvaluacion.RHDAfecha,'dd/mm/yyyy')# >
				<cfelse>
					<cfset fechaI = '' >
				</cfif>
			
				<cfif isdefined("form.fFechaA")>
					<cfset fechaI = form.fFechaA>
				</cfif>
				<cf_sifcalendario form="formArea" name="fFechaA" value="#fechaI#">
			</td>
			<td width="22%" align="right" nowrap> <div align="right"></td>
			<td align="left"></td>
		</tr>
			<td colspan="5">&nbsp;</td>
		<tr> 
			<td colspan="5" align="center" nowrap><cf_botones formName="formArea" modo="#modo#" include="Regresar"></td>
		</tr>
  </table>
	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHDAreasEvaluacion.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="RHDAlinea" value="<cfif isdefined("form.RHDAlinea")><cfoutput>#form.RHDAlinea#</cfoutput></cfif>" size="32">
  <input type="hidden" name="RHEAid" value="<cfif isdefined("form.RHEAid")><cfoutput>#form.RHEAid#</cfoutput></cfif>" size="32">

  	<input type="hidden"   id="usucodigo" name="usucodigo" value="<cfif isdefined("form.usucodigo") and len(trim(form.usucodigo)) NEQ 0>#form.usucodigo#<cfelseif isdefined("rsRHEAreasEvaluacion")>#rsRHEAreasEvaluacion.Usucodigo#</cfif>">
  </cfoutput>
	
</form>


<cf_qforms form = "formArea">
<script language="JavaScript" type="text/JavaScript">

	function funcRegresar() {
		deshabilitar();
		document.formArea.RHEAid.value = '';
		document.formArea.action='AreasEvaluacion.cfm';
		document.formArea.submit();
	}
	
	function deshabilitar(){
		objForm.RHDAdescripcion.required= false;
		objForm.fFechaA.required= false;		

	}
	
	<cfif modo EQ "ALTA">
		<cfoutput>
		objForm.RHDAdescripcion.required= true;
		objForm.RHDAdescripcion.description="#LB_Descripcion#";		
		objForm.fFechaA.required= true;
		objForm.fFechaA.description="#LB_Fecha#";		
		</cfoutput>
	</cfif>
</script>