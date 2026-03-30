<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select b.PEcodigo, b.PEdescripcion
	from Materia a, PeriodoEvaluacion b
	where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and a.Ncodigo = b.Ncodigo
	order by b.PEorden
</cfquery>
<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
	<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
<cfelseif not isdefined("Form.PEcodigo") and rsPeriodos.recordCount GT 0>
	<cfparam name="Form.PEcodigo" default="#rsPeriodos.PEcodigo#">
<cfelse>
	<cfparam name="Form.PEcodigo" default="0">
</cfif>

<cfquery datasource="#Session.DSN#" name="rsMateria">
	select c.Mnombre, a.Ndescripcion, b.Gdescripcion,
	       case c.Melectiva
		        when 'R' then 'Regular'
				when 'S' then 'Sustitutiva'
				when 'E' then 'Electiva'
				when 'C' then 'Complementaria'
				else ''
			end as Modalidad,
			d.MTdescripcion
	from Nivel a, Grado b, Materia c, MateriaTipo d
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and a.Ncodigo = c.Ncodigo 
	  and b.Ncodigo =* c.Ncodigo 
	  and b.Gcodigo =* c.Gcodigo 
	  and c.MTcodigo = d.MTcodigo
</cfquery>

<cfquery name="rsActividades" datasource="#Session.DSN#">
	select 0 as Tipo,
		   convert(varchar, MPcodigo) 
		   + '|' + convert(varchar, Mconsecutivo) 
		   + '|' + convert(varchar, PEcodigo) as Codigo, 
		   MPnombre as Nombre,
		   isnull(MPleccion,0) as Leccion, 
		   isnull(MPorden,0) as Secuencia 
	from MateriaPrograma
	where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	and MPorden != null
	union
	select 1 as Tipo, 
		   convert(varchar, EMcomponente) 
		   + '|' + convert(varchar, Mconsecutivo) 
		   + '|' + convert(varchar, PEcodigo) as Codigo, 
		   EMnombre as Nombre,
		   isnull(EMleccion,0) as Leccion, 
		   isnull(EMorden,0) as Secuencia 
	from EvaluacionMateria
	where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	and EMorden != null
	order by Leccion, Secuencia, Tipo, Nombre
</cfquery>

<cfquery name="rsConceptosEval" datasource="#Session.DSN#">
	select b.ECcodigo, rtrim(b.ECnombre) + ' (' + convert(varchar, a.ECMporcentaje, 1) + '%)' as ECnombre
	from EvaluacionConceptoMateria a, EvaluacionConcepto b
	where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	and a.ECcodigo = b.ECcodigo
	<!---
	and (100 - (select isnull(sum(c.EMporcentaje), 0) from EvaluacionMateria c
		 where a.Mconsecutivo = c.Mconsecutivo
		 and a.PEcodigo = c.PEcodigo
	     and a.ECcodigo = c.ECcodigo
		 and c.EMorden != null
		 <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and isdefined("Form.CodAct")>
		 	and c.EMcomponente != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
		 </cfif>
		 )) > 0
	--->
</cfquery>

<cfquery name="rsTablasEval" datasource="#Session.DSN#">
	select EVTcodigo, EVTnombre
	from EvaluacionValoresTabla
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	order by EVTnombre
</cfquery>

<!---
<cfquery name="rsPorcentajeRestante" datasource="#Session.DSN#">
	select a.ECcodigo, (100 - isnull(sum(c.EMporcentaje), 0)) as Restante
	from EvaluacionConceptoMateria a, EvaluacionMateria c
	where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	and a.Mconsecutivo *= c.Mconsecutivo
	and a.PEcodigo *= c.PEcodigo
	and a.ECcodigo *= c.ECcodigo
	and c.EMorden != null
	<cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and isdefined("Form.CodAct")>
	and c.EMcomponente != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
	</cfif>
	group by a.ECcodigo
</cfquery>
--->

<cfif modo EQ "ALTA">
	<cfquery name="rsPendientes" datasource="#Session.DSN#">
		select '1' 
			   + '|' + convert(varchar, a.EMcomponente) 
			   + '|' + convert(varchar, a.ECcodigo)
			   + '|' + rtrim(convert(varchar, b.EVTcodigo))
			   + '|' + convert(varchar, isnull(b.EVTnombre, 'Ninguna'))
			   + '|' + convert(varchar, isnull(a.EMporcentaje, 0), 1) 
			   + '|' + isnull(a.EMnombre, '')
			   as Codigo, 
			   a.EMnombre as Nombre
		from EvaluacionMateria a, EvaluacionValoresTabla b
		where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and a.EMorden = null
		and a.EVTcodigo *= b.EVTcodigo
		order by a.EMnombre
	</cfquery>

	<cfquery name="rsLecciones" datasource="#Session.DSN#">
		select isnull(MPleccion, 0) as Leccion, ceiling(isnull(MPleccion, 0) + isnull(MPduracion, 0)) as ProxLeccion 
		from MateriaPrograma
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and MPorden != null
		having MPleccion = max(MPleccion)
		union
		select isnull(EMleccion, 0) as Leccion, isnull(EMleccion, 0) as ProxLeccion 
		from EvaluacionMateria
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and EMorden != null
		having EMleccion = max(EMleccion)
	</cfquery>
	<cfif rsLecciones.recordCount GT 0>
		<cfquery name="rsLeccionSugerida" dbtype="query">
			select max(Leccion) as Leccion, max(ProxLeccion) as ProxLeccion
			from rsLecciones
		</cfquery>
		<cfset LeccionTema = #rsLeccionSugerida.ProxLeccion#>
		<cfset LeccionEval = #rsLeccionSugerida.Leccion#>
	<cfelse>
		<cfset LeccionTema = 1>
		<cfset LeccionEval = 1>
	</cfif>

<cfelseif isdefined("Form.Tipo")>
	<cfif Form.Tipo EQ 0>
		<cfquery name="rsActividad" datasource="#Session.DSN#">
			select '0'
			       + '|' + convert(varchar, MPcodigo)
			       + '|' + convert(varchar, Mconsecutivo)
				   + '|' + convert(varchar, PEcodigo) as Codigo,
				   MPnombre as Nombre,
				   MPdescripcion,
				   MPleccion as Leccion,
				   MPduracion,
				   MPorden as Secuencia
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
		</cfquery>
	<cfelseif Form.Tipo EQ 1>
		<cfquery name="rsActividad" datasource="#Session.DSN#">
			select '1'
			       + '|' + convert(varchar, EMcomponente)
			       + '|' + convert(varchar, Mconsecutivo)
				   + '|' + convert(varchar, PEcodigo) as Codigo,
				   EMnombre as Nombre,
				   convert(varchar, ECcodigo) as ECcodigo,
				   convert(varchar, EVTcodigo) as EVTcodigo, 
				   EMleccion as Leccion,
				   EMporcentaje,
				   EMorden as Secuencia
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
		</cfquery>
	</cfif>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rsActividades" default="1">
<cfset MaxRows_rsActividades=20>
<cfset StartRow_rsActividades=Min((PageNum_rsActividades-1)*MaxRows_rsActividades+1,Max(rsActividades.RecordCount,1))>
<cfset EndRow_rsActividades=Min(StartRow_rsActividades+MaxRows_rsActividades-1,rsActividades.RecordCount)>
<cfset TotalPages_rsActividades=Ceiling(rsActividades.RecordCount/MaxRows_rsActividades)>
<cfset QueryString_rsActividades=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsActividades,"PageNum_rsActividades=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsActividades=ListDeleteAt(QueryString_rsActividades,tempPos,"&")>
</cfif>

<cfif isdefined("Form.Mconsecutivo") and isdefined("Form.PEcodigo")>
	<cfset QueryString_rsActividades = "&Mconsecutivo=#Form.Mconsecutivo#&PEcodigo=#Form.PEcodigo#">
</cfif>
<cfif isdefined("Form.Tipo")>
	<cfset QueryString_rsActividades = QueryString_rsActividades & "&Tipo=#Form.Tipo#">
</cfif>
<cfif isdefined("Form.CodAct")>
	<cfset QueryString_rsActividades = QueryString_rsActividades & "&CodAct=#Form.CodAct#">
</cfif>

<script language="JavaScript" src="../../recurso/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">

 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function Editar(data) {
		if (data!="") {
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	
	function crearNuevoPeriodo(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='PeriodoEvaluacion.cfm?RegresarURL=MateriaDetalle.cfm'+'<cfoutput>#URLEncodedFormat("?")#Mconsecutivo#URLEncodedFormat("=")##Form.Mconsecutivo#</cfoutput>';
		}
		else if (c.value == "") {
			c.selectedIndex = 0;
		}
		else if (c.value != "") {
			document.form3.PEcodigo.value = c.value; 
			document.form3.submit();
		}
	}
	
	function crearNuevaTabla(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='tablaEvaluac.cfm?RegresarURL=MateriaDetalle.cfm'+'<cfoutput>#URLEncodedFormat("?")#Mconsecutivo#URLEncodedFormat("=")##Form.Mconsecutivo#</cfoutput>';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	<!---
	var restante = new Object();
	<cfloop query="rsPorcentajeRestante"><cfoutput>
		restante['#ECcodigo#'] = new Number('#Restante#');
	</cfoutput></cfloop>
	--->
	
</script>

	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2">
				<table class="areaDatos" width="100%">
				  <thead>
					<tr> 
					  <td colspan="5">Datos de Materia</td>
					</tr>
				  </thead>
				  <tbody>
					<tr> 
					  <td width="35%" rowspan="2" align="center" valign="middle" style="font-size: 13pt; font-weight: bold;" nowrap><cfoutput>#rsMateria.Mnombre#</cfoutput></td>
					  <td nowrap><strong>Nivel:</strong> <cfoutput>#rsMateria.Ndescripcion#</cfoutput> </td>
					  <td nowrap><strong>Tipo de Materia:</strong> <cfoutput>#rsMateria.MTdescripcion#</cfoutput></td>
					</tr>
					<tr> 
					  <td nowrap> <strong>Grado:</strong> <cfoutput>#rsMateria.Gdescripcion#</cfoutput> </td>
					  <td nowrap><strong>Modalidad:</strong> <cfoutput>#rsMateria.Modalidad#</cfoutput></td>
					</tr>
				  </tbody>
				</table>
			</td>
		</tr>
		<tr valign="middle">
			<td colspan="2" align="center" nowrap class="areaFiltro">
				Periodo de Evaluaci&oacute;n 
				  <select name="PEcodigo" tabindex="1" onChange="javascript: crearNuevoPeriodo(this);">
					<cfoutput query="rsPeriodos"> 
					  <option value="#PEcodigo#" <cfif rsPeriodos.PEcodigo EQ Form.PEcodigo>selected</cfif>>#PEdescripcion#</option>
					</cfoutput> 
					<option value="">-------------------</option>
					<option value="0">Crear Nuevo ...</option>
				  </select>
			</td>
		</tr>
		<tr>
			<td width="40%" valign="top">
		<form method="post" name="form1" id="form1" action="MateriaDetalle.cfm">
		  <input name="datos" type="hidden" value="">
        <table border="0" width="100%" cellpadding="2" cellspacing="0">
			<!--- Encabezado --->
			<tr> 
			  <td align="center" nowrap class="tituloListas" style="padding-left: 5px">Tipo</td>
			  <td nowrap class="tituloListas" style="padding-left: 5px">Actividad</td>
			  <td align="center" nowrap class="tituloListas" style="padding-left: 5px">Lecci&oacute;n</td>
			  <td align="center" nowrap class="tituloListas" style="padding-left: 5px">Secuencia</td>
			</tr>
			<cfoutput query="rsActividades" startrow="#StartRow_rsActividades#" maxrows="#MaxRows_rsActividades#"> 
			  <tr <cfif rsActividades.CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> onMouseOver="javascript: style.backgroundColor='##E4E8F3';" onMouseOut="javascript: style.backgroundColor='<cfif rsActividades.currentRow mod 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
				<td align="center" nowrap><a href="javascript:Editar('#Tipo#|#Codigo#');" tabindex="-1"><img border="0" alt="<cfif Tipo EQ 0>Tema<cfelseif Tipo EQ 1>Evaluación</cfif>" src="<cfif Tipo EQ 0>../../Imagenes/Documentos.gif<cfelseif Tipo EQ 1>../../Imagenes/Documentos2.gif</cfif>"></a></td>
				<td nowrap><a href="javascript:Editar('#Tipo#|#Codigo#');" tabindex="-1">#Nombre#</a></td>
				<td align="center" nowrap><a href="javascript:Editar('#Tipo#|#Codigo#');" tabindex="-1">#Leccion#</a></td>
				<td align="center" nowrap><a href="javascript:Editar('#Tipo#|#Codigo#');" tabindex="-1">#Secuencia#</a></td>
			  </tr>
			</cfoutput> 
			<tr> 
			  <td colspan="4" align="center">&nbsp; 
				<table border="0" width="50%" align="center">
				  <cfoutput> 
					<tr> 
					  <td width="23%" align="center"> 
						<cfif PageNum_rsActividades GT 1>
						  <a href="#CurrentPage#?PageNum_rsActividades=1#QueryString_rsActividades#"><img src="../../recurso/Imagenes/First.gif" border=0></a> 
						</cfif>
					  </td>
					  <td width="31%" align="center"> 
						<cfif PageNum_rsActividades GT 1>
						  <a href="#CurrentPage#?PageNum_rsActividades=#Max(DecrementValue(PageNum_rsActividades),1)##QueryString_rsActividades#"><img src="../../recurso/Imagenes/Previous.gif" border=0></a> 
						</cfif>
					  </td>
					  <td width="23%" align="center"> 
						<cfif PageNum_rsActividades LT TotalPages_rsActividades>
						  <a href="#CurrentPage#?PageNum_rsActividades=#Min(IncrementValue(PageNum_rsActividades),TotalPages_rsActividades)##QueryString_rsActividades#"><img src="../../recurso/Imagenes/Next.gif" border=0></a> 
						</cfif>
					  </td>
					  <td width="23%" align="center"> 
						<cfif PageNum_rsActividades LT TotalPages_rsActividades>
						  <a href="#CurrentPage#?PageNum_rsActividades=#TotalPages_rsActividades##QueryString_rsActividades#"><img src="../../recurso/Imagenes/Last.gif" border=0></a> 
						</cfif>
					  </td>
					</tr>
				  </cfoutput> 
				</table>
			  </td>
			</tr>
		  </table>
		</form>
	</td>
	<td width="60%" valign="top">
	  <form name="form2" method="post" action="SQLMateriaDetalle.cfm">
	  	<cfif modo EQ "ALTA">
			<input name="LeccionTema" type="hidden" id="LeccionTema" value="<cfoutput>#LeccionTema#</cfoutput>">
			<input name="LeccionEval" type="hidden" id="LeccionEval" value="<cfoutput>#LeccionEval#</cfoutput>">
		</cfif>
        <input name="Mconsecutivo" type="hidden" id="Mconsecutivo" value="<cfoutput>#Form.Mconsecutivo#</cfoutput>">
        <input name="PEcodigo" type="hidden" id="PEcodigo" value="<cfoutput>#Form.PEcodigo#</cfoutput>">
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr> 
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td width="40%" valign="middle" nowrap>Lecci&oacute;n</td>
            <td width="60%" nowrap> 
              <input name="Leccion" type="text" id="Leccion" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActividad.Leccion#</cfoutput></cfif>">
            </td>
          </tr>
            <tr> 
              <td valign="middle" nowrap>Actividad</td>
              <td nowrap> 
                <cfif modo NEQ "ALTA">
					<input name="Actividad" type="hidden" value="<cfoutput>#rsActividad.Codigo#</cfoutput>">
					<cfif isdefined("Form.Tipo") and Form.Tipo EQ 0>
						<cfoutput>Tema</cfoutput>
					<cfelseif isdefined("Form.Tipo") and Form.Tipo EQ 1>
						<cfoutput>Evaluaci&oacute;n</cfoutput>
					</cfif>
                  <cfelse>
                  <select name="Actividad" tabindex="2" onChange="javascript: refreshForm(this);">
                    <cfoutput query="rsPendientes"> 
                      <option value="#Codigo#">#Nombre#</option>
                    </cfoutput> 
                    <option value="">-------------------</option>
                    <option value="0">Nuevo Tema ...</option>
                    <option value="1">Nueva Evaluaci&oacute;n ...</option>
                  </select>
                </cfif>
              </td>
            </tr>
          <tr> 
            <td valign="middle" nowrap>Nombre</td>
            <td nowrap> 
              <input name="Nombre" type="text" id="Nombre" size="40" maxlength="80" tabindex="2" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActividad.Nombre#</cfoutput></cfif>">
            </td>
          </tr>
          <tr id="trContenido" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
            <td valign="top" nowrap>Contenido</td>
            <td nowrap> 
              <textarea name="MPdescripcion" cols="30" rows="4" id="MPdescripcion" tabindex="2"><cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPdescripcion#</cfoutput></cfif></textarea>
            </td>
          </tr>
          <tr id="trDuracion" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
            <td valign="middle" nowrap>Duraci&oacute;n (en lecciones)</td>
            <td nowrap> 
              <input name="MPduracion" type="text" id="MPduracion" size="10" maxlength="6" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,2);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPduracion#</cfoutput><cfelse><cfoutput>1.00</cfoutput></cfif>">
            </td>
          </tr>
          <tr id="trConcepto" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
            <td valign="middle" nowrap>Concepto de Evaluaci&oacute;n</td>
            <td nowrap> 
              <select name="ECcodigo" id="ECcodigo" tabindex="2">
                <option value="">(Seleccione un Concepto)</option>
                <cfoutput query="rsConceptosEval"> 
                  <option value="#ECcodigo#" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.ECcodigo EQ rsConceptosEval.ECcodigo>selected</cfif>>#ECnombre#</option>
                </cfoutput> 
              </select>
            </td>
          </tr>
          <tr id="trTabla" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
            <td valign="middle" nowrap>Tipo de Evaluaci&oacute;n</td>
            <td nowrap> 
			  <!---
              <select name="EVTcodigo" id="EVTcodigo" tabindex="2" onChange="javascript: crearNuevaTabla(this);">
                <option value="">(Ninguna)</option>
                <cfoutput query="rsTablasEval"> 
                  <option value="#EVTcodigo#" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ rsTablasEval.EVTcodigo>selected</cfif>>#EVTnombre#</option>
                </cfoutput> 
                <option value="">-------------------</option>
                <option value="0">Crear Nuevo ...</option>
              </select>
			  --->
				<select name="EVTcodigo" id="EVTcodigo" onChange="javascript: crearNuevaTabla(this);">
				  <option value="-1" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0>selected</cfif>>-- Digitar Nota --</option>
				  <cfoutput query="rsTablasEval"> 
					<option value="#EVTcodigo#" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ rsTablasEval.EVTcodigo>selected</cfif>>Usar Tabla: #EVTnombre#</option>
				  </cfoutput> 
				  <option value="">-------------------</option>
				  <option value="0">Crear Nueva Tabla ...</option>
				</select>
			  
              <!---
              <input name="EVTcodigo_Label" type="text" class="cajasinbordeb" value="" size="40" readonly>
			  --->
            </td>
          </tr>
		  <!---
          <tr id="trPorcentaje" <cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
            <td valign="middle" nowrap>Porcentaje</td>
            <td nowrap> 
              <input name="EMporcentaje" type="text" id="EMporcentaje" tabindex="2" style="text-align: right;" onFocus="javascript: this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" size="10" maxlength="6"  alt="Porcentaje de la Evaluación" value="<cfif modo NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>#rsActividad.EMporcentaje#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>">
            </td>
          </tr>
		  --->
          <tr> 
            <td valign="middle" nowrap>Secuencia</td>
            <td nowrap> 
              <input name="Secuencia" type="text" id="Secuencia" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActividad.Secuencia#</cfoutput></cfif>">
            </td>
          </tr>
          <tr> 
            <td colspan="2" nowrap>&nbsp;</td>
          </tr>
          <tr align="center"> 
            <td colspan="2" nowrap> 
              <cfinclude template="../../recurso/portlets/pBotones.cfm">
            </td>
          </tr>
          <tr> 
            <td colspan="2" nowrap>&nbsp;</td>
          </tr>
        </table>
      </form>
      </td>
		</tr>
	</table>
	<form name="form3" action="MateriaDetalle.cfm" method="post">
		<input type="hidden" name="Mconsecutivo" value="<cfoutput>#Form.Mconsecutivo#</cfoutput>">
		<input type="hidden" name="PEcodigo" value="">
	</form>
	<script language="JavaScript" type="text/javascript">

		<!---
		function __isPorcentajes() {
			if ((btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) && (this.obj.form.ECcodigo.value != "")) {
				if (new Number(this.value) > new Number(restante[this.obj.form.ECcodigo.value])) {
					this.error = "El porcentaje asignado supera el porcentaje disponible para el concepto de evaluación. El porcentaje disponible es de " + restante[this.obj.form.ECcodigo.value] + " %";
				}
			}
		}
		--->
		
		function __isPeriodo() {
			if (this.obj.form.PEcodigo.value == "0") {
				this.error = "error";
			}
			if ((btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) && (this.obj.form.PEcodigo.value == "0" || this.obj.form.PEcodigo.value == "")) {
				this.error = "El Período de Evaluación es requerido";
			}
		}

		qFormAPI.errorColor = "#FFFFCC";
		<!--- _addValidator("isPorcentajes", __isPorcentajes); --->
		_addValidator("isPeriodo", __isPeriodo);
		objForm = new qForm("form2");

		<cfif modo EQ "ALTA">
	
		function habilitarCampos(control) {
			var tipo = control.value;
			var f = control.form;
			var a = document.getElementById("trContenido");
			var b = document.getElementById("trDuracion");
			var c = document.getElementById("trConcepto");
			var d = document.getElementById("trTabla");
			//var e = document.getElementById("trPorcentaje");
			if (tipo.indexOf("|") != -1) {
				var x = tipo.split("|");
				tipo = x[0];
				// Cargar Concepto de Evaluación
				for (var i=0; i<f.ECcodigo.length; i++) {
					if (f.ECcodigo.options[i].value == x[2]) {
						f.ECcodigo.selectedIndex = i;
						break;
					}
				}
				f.ECcodigo.disabled = true;
				// Cargar Tabla de Evaluacion
				for (var i=0; i<f.EVTcodigo.length; i++) {
					if (f.EVTcodigo.options[i].value == x[3]) {
						f.EVTcodigo.selectedIndex = i;
						break;
					}
				}
				f.EVTcodigo.disabled = true;
				// Cargar Porcentaje
				//f.EMporcentaje.value = x[5];
				// Cargar Nombre
				f.Nombre.value = x[6];
			} else {
				f.MPdescripcion.value = "";
				f.MPduracion.value = "1.00";
				f.ECcodigo.selectedIndex = 0;
				f.ECcodigo.disabled = false;
				f.EVTcodigo.selectedIndex = 0;
				f.EVTcodigo.disabled = false;
				//f.EMporcentaje.value = "0.00";
				f.Nombre.value = "";
			}
			if (tipo == "0") {
				a.style.display = "";
				b.style.display = "";
				c.style.display = "none";
				d.style.display = "none";
				//e.style.display = "none";
				f.Leccion.value = f.LeccionTema.value;
				objForm.MPduracion.required = true;
				//objForm.EMporcentaje.required = false;
				objForm.ECcodigo.required = false;
			} else if (tipo == "1") {
				a.style.display = "none";
				b.style.display = "none";
				c.style.display = "";
				d.style.display = "";
				//e.style.display = "";
				f.Leccion.value = f.LeccionEval.value;
				objForm.MPduracion.required = false;
				//objForm.EMporcentaje.required = true;
				objForm.ECcodigo.required = true;
			} else {
				a.style.display = "none";
				b.style.display = "none";
				c.style.display = "none";
				d.style.display = "none";
				//e.style.display = "none";
				objForm.MPduracion.required = false;
				//objForm.EMporcentaje.required = false;
				objForm.ECcodigo.required = false;
			}
		}
	
		function refreshForm(c) {
			if (c.value != "") {
				habilitarCampos(c);
			}
			else {
				c.selectedIndex = 0;
				habilitarCampos(c);
			}
		}
	
		</cfif>

		<cfif modo EQ "ALTA">
			refreshForm(document.form2.Actividad);
		</cfif>
		
		function deshabilitarValidacion() {
			objForm.Leccion.required = false;
			objForm.Nombre.required = false;
			objForm.MPduracion.required = false;
			//objForm.EMporcentaje.required = false;
			objForm.ECcodigo.required = false;
		}

		<cfif modo EQ "ALTA">
			objForm.Leccion.obj.focus();
			objForm.Leccion.validatePeriodo();
			objForm.Leccion.required = true;
			objForm.Leccion.description = "Lección";
			objForm.Nombre.required = true;
			objForm.Nombre.description = "Nombre";
			objForm.Actividad.required = true;
			objForm.Actividad.description = "Actividad";
			objForm.MPduracion.required = true;
			objForm.MPduracion.description = "Duración";
			/*
			objForm.EMporcentaje.required = true;
			objForm.EMporcentaje.description = "Porcentaje";
			objForm.EMporcentaje.validatePorcentajes();
			*/
			objForm.ECcodigo.required = true;
			objForm.ECcodigo.description = "Concepto de Evaluación";
		<cfelseif modo EQ "CAMBIO">
			objForm.Leccion.obj.focus();
			objForm.Leccion.validatePeriodo();
			objForm.Leccion.required = true;
			objForm.Leccion.description = "Lección";
			objForm.Nombre.required = true;
			objForm.Nombre.description = "Nombre";
			<cfif Form.Tipo EQ 0>
			objForm.MPduracion.required = true;
			objForm.MPduracion.description = "Duración";
			<cfelseif Form.Tipo EQ 1>
			/*
			objForm.EMporcentaje.required = true;
			objForm.EMporcentaje.description = "Porcentaje";
			objForm.EMporcentaje.validatePorcentajes();
			*/
			objForm.ECcodigo.required = true;
			objForm.ECcodigo.description = "Concepto de Evaluación";
			</cfif>
		</cfif>

	</script>