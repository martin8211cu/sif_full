<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js"></script>

<!--- Ciclos Lectivos --->
<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
	select convert(varchar,a.CILcodigo) as CILcodigo, CILnombre, CILtipoCicloDuracion
	from CicloLectivo a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- Chequear que haya tipos de ciclos lectivos creados --->
<cfif rsCicloLectivo.recordCount GT 0>
	
	<cfparam name="form.CARcodigo" default="0">
	<cfparam name="form.PEScodigo" default="0">
	<cfparam name="form.GAcodigo" default="0">
	<cfparam name="form.Scodigo" default="0">
	<cfparam name="form.Ccodigo" default="">

	<!--- Tipos de Ciclo Lectivo --->
	<cfif not isdefined("Form.CILcodigo")>
		<cfset Form.CILcodigo = rsCicloLectivo.CILcodigo>
		<cfset Form.CILtipoCicloDuracion = rsCicloLectivo.CILtipoCicloDuracion>
	<cfelse>
		<cfquery name="rsCicloLectivoSel" datasource="#Session.DSN#">
			select convert(varchar,a.CILcodigo) as CILcodigo, CILnombre, CILtipoCicloDuracion
			from CicloLectivo a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
		</cfquery>
		<cfset Form.CILtipoCicloDuracion = rsCicloLectivoSel.CILtipoCicloDuracion>
	</cfif>
	
	<!--- Períodos de Matrícula --->
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	<cfif form.CILtipoCicloDuracion EQ "E">
		select 	convert(varchar, pl.PLcodigo) as PLcodigo, 
				convert(varchar, pe.PEcodigo) as PEcodigo, 
				pl.PLnombre + ' - ' + pe.PEnombre as Periodo
		from CicloLectivo cil, PeriodoLectivo pl, PeriodoEvaluacion pe
		where cil.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and cil.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		  and pl.CILcodigo = cil.CILcodigo
		  and pe.PLcodigo = pl.PLcodigo
		  and convert(datetime, convert(varchar, getDate(), 103), 103) <= pe.PEfinal
	<cfelse>
		select convert(varchar,PLcodigo) as PLcodigo, 
			   PLnombre as Periodo
		from CicloLectivo cil, PeriodoLectivo pl
		where cil.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and cil.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		  and pl.CILcodigo = cil.CILcodigo
		  and convert(datetime, convert(varchar, getDate(), 103), 103) <= pl.PLfinal
	</cfif>
	</cfquery>
	<cfif not isdefined("form.PLcodigo")>
		<cfset form.PLcodigo = rsPeriodo.PLcodigo>
		<cfif form.CILtipoCicloDuracion EQ "E">
			<cfset form.PEcodigo = rsPeriodo.PEcodigo>
		</cfif>
	</cfif>
	
	<!--- Escuelas --->
	<cfinclude template="/educ/queries/qryEscuela.cfm">
	<cfif not isdefined("form.EScodigo")>
		<cfset form.EScodigo = rsEscuela.EScodigo>
	</cfif>
		
	<!--- Carreras --->
	<cfquery name="rsCarrera" datasource="#Session.DSN#">
		select convert(varchar, a.CARcodigo) as CARcodigo, 
			   a.CARnombre
		from Carrera a
		<cfif form.EScodigo GT 0>
		where a.EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EScodigo#">
		</cfif>
		order by CARcodificacion
	</cfquery>

	<!--- Grados Academicos --->
	<cfquery name="rsGrados" datasource="#Session.DSN#">
		select convert(varchar, a.GAcodigo) as GAcodigo, 
			   a.GAnombre
		from GradoAcademico a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by GAorden
	</cfquery>

	<!--- Planes Académicos --->
	<cfquery name="rsPlanes" datasource="#Session.DSN#">
		set nocount on
		declare @hoy datetime
		select @hoy = convert(varchar,getdate(),112)
		select convert(varchar, a.PEScodigo) as PEScodigo, 
			   b.GAnombre + ' en ' + a.PESnombre as PESnombre
		from PlanEstudios a, GradoAcademico b, Carrera c
		where a.GAcodigo = b.GAcodigo
		  and a.CARcodigo = c.CARcodigo
		  and c.EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EScodigo#">
		  <cfif form.CARcodigo GT 0>
		  and a.CARcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CARcodigo#">
		  </cfif>
		  <cfif form.GAcodigo GT 0>
		  and a.GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
		  </cfif>
		  and a.PESestado > -1
		  and @hoy BETWEEN PESdesde and isnull(PESmaxima,isnull(PEShasta,@hoy))
		order by CARcodificacion, GAorden, PEScodificacion
		set nocount off
	</cfquery>
	<cfif form.PEScodigo GT 0>
		<cfset LvarPlan = false>
		<cfloop query="rsPlanes">
			<cfif form.PEScodigo eq rsPlanes.PEScodigo>
				<cfset LvarPlan = true>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif not LvarPlan>
			<cfset form.PEScodigo = 0>
		</cfif>
	</cfif>

	<!--- Sedes --->
	<cfquery name="rsSedes" datasource="#Session.DSN#">
		select convert(varchar, a.Scodigo) as Scodigo, 
				rtrim(a.Scodificacion) || ':&nbsp;&nbsp;' || a.Snombre as Nombre
		from Sede a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Sorden
	</cfquery>
	<cfoutput>
	<script language="javascript" type="text/javascript">
	function cambioPeriodo(obj) {
		obj.form.action = "#GetFileFromPath(GetTemplatePath())#";
		obj.form.submit();
	}
	
	function funcChkAll(c) {
		if (c.form.chk) {
			if (c.form.chk.value) {
				if (!c.form.chk.disabled) c.form.chk.checked = c.checked;
			} else {
				for (var counter = 0; counter < c.form.chk.length; counter++) {
					if (!c.form.chk[counter].disabled) c.form.chk[counter].checked = c.checked;
				}
			}
		}
	}

	function UpdChkAll(c) {
		var allChecked = true;
		if (!c.checked) {
			allChecked = false;
		} else {
			if (c.form.chk.value) {
				if (!c.form.chk.disabled) allChecked = true;
			} else {
				for (var counter = 0; counter < c.form.chk.length; counter++) {
					if (!c.form.chk[counter].disabled && !c.form.chk[counter].checked) {allChecked=false; break;}
				}
			}
		}
		c.form.chkAllItems.checked = allChecked;
	}
	function sbPasarCodigos()
	{
		document.frmMaterias.CILcodigo.value = document.formCursoGeneracion.CILcodigo.value;
		document.frmMaterias.PLcodigo.value = document.formCursoGeneracion.PLcodigo.value;
		<cfif form.CILtipoCicloDuracion EQ "E">
			document.frmMaterias.PEcodigo.value = document.formCursoGeneracion.PEcodigo.value;
		</cfif>
		document.frmMaterias.EScodigo.value = document.formCursoGeneracion.EScodigo.value;
		document.frmMaterias.CARcodigo.value = document.formCursoGeneracion.CARcodigo.value;
		document.frmMaterias.GAcodigo.value = document.formCursoGeneracion.GAcodigo.value;
		document.frmMaterias.PEScodigo.value = document.formCursoGeneracion.PEScodigo.value;
		document.frmMaterias.Scodigo.value = document.formCursoGeneracion.Scodigo.value;
		document.frmMaterias.txtMnombreFiltro.value = document.formCursoGeneracion.txtMnombreFiltro.value;
	}

	function sbListaCursos(Mcodigo)
	{
		document.formCursoGeneracion.Mcodigo.value = Mcodigo;
		document.formCursoGeneracion.Ccodigo.value = "";
		document.formCursoGeneracion.action = "";
		document.formCursoGeneracion.submit();
	}

	function sbCambiaCurso(Mcodigo,Ccodigo)
	{
		document.formCursoGeneracion.Mcodigo.value = Mcodigo;
		document.formCursoGeneracion.Ccodigo.value = Ccodigo;
		document.formCursoGeneracion.action = "";
		document.formCursoGeneracion.submit();
	}

	function fnGenerar() 
	{
		if (document.formCursoGeneracion.Scodigo.value <= 0)
		{
			alert ("ERROR: Indique la Sede donde se desea generar.");
			return false;
		}

		var LvarChk = false;
		var LvarErr = false;
		if (document.frmMaterias.chk.value) 
		{
			if (document.frmMaterias.chk.checked)
			{	
				var LvarVal = eval("document.frmMaterias.Cupo_" + document.frmMaterias.chk.value + ".value");
				
				if ((ESNUMERO(LvarVal)) && (LvarVal > 0))
					LvarChk = true;
				else
					LvarErr = true;

				LvarVal = eval("document.frmMaterias.Cant_" + document.frmMaterias.chk.value + ".value");
				if ((ESNUMERO(LvarVal)) && (LvarVal > 0))
					LvarChk = true;
				else
					LvarErr = true;
			}
		}
		else 
			for (var counter = 0; counter < document.frmMaterias.chk.length; counter++) 
				if (document.frmMaterias.chk[counter].checked)
				{
					var LvarVal = eval("document.frmMaterias.Cupo_" + document.frmMaterias.chk[counter].value + ".value");
					
					if ((ESNUMERO(LvarVal)) && (LvarVal > 0))
						LvarChk = true;
					else
						LvarErr = true;

					LvarVal = eval("document.frmMaterias.Cant_" + document.frmMaterias.chk[counter].value + ".value");
					if ((ESNUMERO(LvarVal)) && (LvarVal > 0))
						LvarChk = true;
					else
						LvarErr = true;
				}
			
		if (!LvarChk)
		{
			alert ("ERROR: Indique las materias que desea generar.");
			return false;
		}
		else if (LvarErr)
		{
			alert ("ERROR: Tanto el cupo como la cantidad de cursos deben ser mayor que cero.");
			return false;
		}

		sbPasarCodigos();
		return true;
	}

	function fnEnterToDefault (objEvent,objButton)
	{
		var LvarKey = (objEvent.keyCode) ? objEvent.keyCode : objEvent.which;
		if (LvarKey == 13) {
			if (objButton) objButton.click();
			return false;
		} else 
			return true;
	}
 	</script>
  <cfif isdefined("form.Ccodigo") and form.Ccodigo EQ "">
	<form name="formCursoGeneracion" method="post" action="<cfif session.MoG EQ "G">CursoGeneracion.cfm<cfelse>CursoMantenimiento.cfm</cfif>" style="margin: 0; " onKeyPress="javascript:return fnEnterToDefault(event,this.btnMaterias);">
	  <input type="hidden" name="Mcodigo">
	  <input type="hidden" name="Ccodigo">
      <table width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr> 
          <td width="20%" align="right" class="fileLabel" nowrap>Tipo Ciclo Lectivo:</td>
          <td width="30%" nowrap> 
		  	<select name="CILcodigo" onChange="javascript: cambioPeriodo(this);">
              <cfloop query="rsCicloLectivo">
                <option value="#rsCicloLectivo.CILcodigo#" <cfif isdefined("Form.CILcodigo") and Form.CILcodigo EQ rsCicloLectivo.CILcodigo>selected</cfif>>#rsCicloLectivo.CILnombre#</option>
              </cfloop>
            </select> </td>
        </tr>
        <tr> 
          <cfif form.CILtipoCicloDuracion EQ "E">
            <td width="20%" align="right" class="fileLabel">Per&iacute;odo Evaluaci&oacute;n:</td>
            <td width="30%" nowrap> 
				<input type="hidden" name="PLcodigo" value="<cfif isdefined("rsPeriodo.PLcodigo")>#rsPeriodo.PLcodigo#</cfif>">
				<select name="PEcodigo"
			  		<cfif isdefined("Form.btnMaterias")>onChange="javascript:this.form.submit();"</cfif>>
                <cfloop query="rsPeriodo">
                  <option value="#rsPeriodo.PEcodigo#" <cfif isdefined("Form.PEcodigo") and Form.PEcodigo EQ rsPeriodo.PEcodigo>selected</cfif>>#rsPeriodo.Periodo#</option>
                </cfloop>
              </select> </td>
            <cfelse>
            <td width="20%" align="right" class="fileLabel" nowrap> Ciclo Lectivo: 
            </td>
            <td width="30%" nowrap> 
			  <select name="PLcodigo"
			  		<cfif isdefined("Form.btnMaterias")>onChange="javascript:this.form.submit();"</cfif>>
                <cfloop query="rsPeriodo">
                  <option value="#rsPeriodo.PLcodigo#" <cfif isdefined("Form.PLcodigo") and Form.PLcodigo EQ rsPeriodo.PLcodigo>selected</cfif>>#rsPeriodo.Periodo#</option>
                </cfloop>
              </select> </td>
          </cfif>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">#session.parametros.Escuela#: </td>
          <td> <select name="EScodigo" onChange="javascript:this.form.submit();">
              <cfloop query="rsEscuela">
                <option value="#EScodigo#" <cfif isDefined("Form.EScodigo") and Trim(Form.EScodigo) EQ rsEscuela.EScodigo>selected</cfif>>#rsEscuela.ESnombre#</option>
              </cfloop>
            </select> </td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Carrera: </td>
          <td> <select name="CARcodigo" onChange="javascript:this.form.submit();">
              <option value="0" <cfif isDefined("Form.CARcodigo") and Trim(Form.CARcodigo) EQ '0'>selected</cfif>> 
              -- Cualquiera -- </option>
              <cfloop query="rsCarrera">
                <option value="#rsCarrera.CARcodigo#" <cfif isDefined("Form.CARcodigo") and Trim(Form.CARcodigo) EQ rsCarrera.CARcodigo>selected</cfif>>#rsCarrera.CARnombre#</option>
              </cfloop>
            </select></td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Grado Acad&eacute;mico: </td>
          <td> <select name="GAcodigo" onChange="javascript:this.form.submit();">
              <option value="0" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '0'>selected</cfif>> 
              -- Cualquiera -- </option>
              <option value="-1" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '-1'>selected</cfif>> 
              -- Ninguno -- </option>
              <cfloop query="rsGrados">
                <option value="#rsGrados.GAcodigo#" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ rsGrados.GAcodigo>selected</cfif>>#rsGrados.GAnombre#</option>
              </cfloop>
            </select></td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Plan de Estudios: </td>
          <td> <select name="PEScodigo"
			  		<cfif isdefined("Form.btnMaterias")>onChange="javascript:this.form.submit();"</cfif>>
              <option value="0" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '0'>selected</cfif>>-- 
              Cualquiera --</option>
              <cfif isdefined("rsPlanes")>
                <cfloop query="rsPlanes">
                  <option value="#rsPlanes.PEScodigo#" <cfif isDefined("Form.PEScodigo") and Trim(Form.PEScodigo) EQ rsPlanes.PEScodigo>selected</cfif>>#rsPlanes.PESnombre#</option>
                </cfloop>
              </cfif>
            </select> </td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Materia que contenga: </td>
          <td colspan="2"> <input name="txtMnombreFiltro" type="text" size="60" <cfif isdefined("form.txtMnombreFiltro")>value="#form.txtMnombreFiltro#"</cfif>> 
          </td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Sede:</td>
          <td> <select name="Scodigo"
		  		<cfif isdefined("Form.btnMaterias")>onChange="javascript:this.form.btnMaterias.click();"</cfif>>
              <option value="0">-- Cualquiera --</option>
              <cfloop query="rsSedes">
                <option value="#rsSedes.Scodigo#" <cfif isDefined("Form.Scodigo") and Trim(Form.Scodigo) EQ rsSedes.Scodigo>selected</cfif>>#rsSedes.Nombre#</option>
              </cfloop>
            </select> </td>
        </tr>
        <tr align="center"> 
          <td colspan="4" class="fileLabel"> 
		  	<input name="btnMaterias" type="submit" id="btnMaterias2" value="Listar Materias"> 
          </td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">&nbsp;</td>
          <td>&nbsp;</td>
          <td align="right" class="fileLabel">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
    </form>
  </cfif>
	</cfoutput>

	<cfif isdefined("Form.Ccodigo") and form.Ccodigo NEQ "">
		<cfinclude template="Curso_tabs.cfm">
	<cfelseif isdefined("Form.Mcodigo") and form.Mcodigo NEQ "">
		<cfset session.TABS.TabsCurso = 1>
		<cfinclude template="CursoGeneracion_formCursos.cfm">
	<cfelseif isdefined("Form.btnMaterias")>
		<cfinclude template="CursoGeneracion_formMaterias.cfm">
	</cfif>
	

<cfelse>
	No hay tipos de cursos lectivos creados
</cfif>
