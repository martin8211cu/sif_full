<!-- Hecho por: Rodolfo Jimenez Jara, Soluciones Integrales S.A., 28/07/2003 -->
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

<cfif isdefined("Url.Splaza") and not isdefined("form.Splaza")>
	<cfset form.Splaza = Url.Splaza>
</cfif>
<cfif isdefined("Url.cbTipoMatFiltro") and not isdefined("form.cbTipoMatFiltro")>
	<cfset form.cbTipoMatFiltro = Url.cbTipoMatFiltro>
</cfif>
<cfif isdefined("Url.cbTipoContFiltro") and not isdefined("form.cbTipoContFiltro")>
	<cfset form.cbTipoContFiltro = Url.cbTipoContFiltro>
</cfif>
<cfif isdefined("Url.tituloFiltro") and not isdefined("form.tituloFiltro")>
	<cfset form.tituloFiltro = Url.tituloFiltro>
</cfif>

<cfif isdefined("Url.cbTipoDocFiltro") and not isdefined("form.cbTipoDocFiltro")>
	<cfset form.cbTipoDocFiltro = Url.cbTipoDocFiltro>
</cfif>


<!--- Consultas --->

<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select  convert(varchar, id_documento) as id_documento, 
		        convert(varchar, id_tipo) as id_tipo, 
				titulo, resumen, convert(varchar,fecha,103) as fecha,  contenido, tipo_contenido, nom_archivo
		from MADocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
	</cfquery>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsTipoDoc">
	Select  convert(varchar, id_tipo) as id_tipo, nombre_tipo
	from BibliotecaCentroE bce, MATipoDocumento matd
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and bce.id_biblioteca= matd.id_biblioteca	
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsProf">
	select distinct convert(varchar,s.Splaza) as Splaza, (Papellido1 + ' ' + Papellido2 + ','+ Pnombre) as nombre 
	from PersonaEducativo a, Curso c, Staff s, PeriodoVigente pv, Materia m, MateriaTipo mt
	where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and s.retirado = 0 
		and s.autorizado = 1
		and a.persona=s.persona 
		and a.CEcodigo=s.CEcodigo
		and c.CEcodigo=s.CEcodigo
		and c.Splaza=s.Splaza
		and c.PEcodigo=pv.PEcodigo
		and c.SPEcodigo=pv.SPEcodigo
		and c.Mconsecutivo=m.Mconsecutivo
		and m.MTcodigo=mt.MTcodigo
	order by nombre
</cfquery>
<cfif not isdefined("form.Splaza") >
	<cfset form.Splaza = rsProf.Splaza>
</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsMateriaTipo">
	Select distinct convert(varchar,m.MTcodigo) as MTcodigo, substring(MTdescripcion,1,50) as MTdescripcion
	from Curso c, Staff s, PeriodoVigente pv, Materia m, MateriaTipo mt
	where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	
		<cfif isdefined("form.Splaza") and len(trim(form.Splaza)) neq 0>
			and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">	
		</cfif>
		and s.retirado = 0 
		and s.autorizado = 1
		and c.CEcodigo=s.CEcodigo
		and c.Splaza=s.Splaza
		and c.PEcodigo=pv.PEcodigo
		and c.SPEcodigo=pv.SPEcodigo
		and c.Mconsecutivo=m.Mconsecutivo
		and m.MTcodigo=mt.MTcodigo
	order by MTdescripcion
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsAtributos">
	Select convert(varchar, id_atributo) as id_atributo,
	       convert(varchar, MAA.id_tipo) as id_tipo,
		   nombre_atributo,tipo_atributo
	from MAAtributo MAA, MATipoDocumento MATD , BibliotecaCentroE BCE 
	where BCE.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and BCE.CEcodigo= MAA.CEcodigo
		and MAA.id_tipo = MATD.id_tipo
		and BCE.id_biblioteca = MATD.id_biblioteca 
	order by orden_atributo
	
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsValorAtributo">
	Select convert(varchar, mva.id_atributo) as id_atributo,
	       convert(varchar, id_valor) as id_valor, contenido
	from MAValorAtributo mva, MAAtributo maa
	where mva.id_atributo=maa.id_atributo
	order by orden_valor
</cfquery>
	
<cfif modo EQ "CAMBIO" and isdefined('form.id_documento')>	
	<cfquery datasource="#Session.Edu.DSN#" name="rsAtribDoc">
		Select 	convert(varchar, consecutivo) as consecutivo,
				convert(varchar, id_documento) as id_documento,
				convert(varchar, md.id_atributo) as id_atributo,
				convert(varchar, md.id_valor) as id_valor,
				valor
		from MAAtributoDocumento md, MAAtributo ma
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
			and md.id_atributo=ma.id_atributo
	</cfquery>	
	<cfquery datasource="#Session.Edu.DSN#" name="rsDocumMatTipo">
		Select convert(varchar, MTcodigo) as MTcodigo, convert(varchar, id_documento) as id_documento
		from DocumentoMateriaTipo
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
	</cfquery>	
</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function crearNuevoTipo(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='../../ced/recurso/listaBiblioteca.cfm?RegresarURL=../../docencia/MaterialApoyo/Documentos.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
</script>
<form action="../MaterialApoyo/SQLDocumentos.cfm" method="post" enctype="multipart/form-data" id="formDocumentos" name="formDocumentos">
	<input name="id_documento" id="id_documento" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.id_documento#</cfoutput></cfif>" type="hidden">
	<input name="MODO" 	id="MODO" value="<cfoutput>#modo#</cfoutput>" type="hidden">

<!--- Objetos ara el filtro de la lista inferios --->	
<!---	<input name="tituloFiltro" id="tituloFiltro" value="<cfif isdefined('form.tituloFiltro')><cfoutput>#form.tituloFiltro#</cfoutput></cfif>" type="hidden">
	 <input name="cbTipoDocFiltro" id="cbTipoDocFiltro" value="<cfif isdefined('form.cbTipoDocFiltro')><cfoutput>#form.cbTipoDocFiltro#</cfoutput></cfif>" type="hidden">	
	<input name="cbTipoContFiltro" id="cbTipoContFiltro" value="<cfif isdefined('form.cbTipoContFiltro')><cfoutput>#form.cbTipoContFiltro#</cfoutput></cfif>" type="hidden">
	 --->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="5%">&nbsp;</td>
      <td width="50%" rowspan="8" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td nowrap>&nbsp;</td>
            <td align="left" valign="top" nowrap >&nbsp;</td>
          </tr>
          <tr> 
            <td nowrap><strong>Profesor</strong></td>
            <td align="left" valign="top" nowrap ><select name="Splaza"  id="Splaza"  onChange="javascript:  document.formDocumentos.submit();">
                <cfoutput query="rsProf"> 
                  <option value="#rsProf.Splaza#" <cfif isdefined("form.Splaza") and form.Splaza EQ #rsProf.Splaza#>selected</cfif>>#rsProf.nombre#</option>
                </cfoutput> </select></td>
          </tr>
          <tr> 
            <td width="35%" nowrap><strong>Tipo de Documento</strong></td>
            <td width="65%" align="left" valign="top" nowrap > <select name="cbTipoDoc" id="cbTipoDoc" onChange="javascript: cambioTipoDoc(this); crearNuevoTipo(this);">
                <cfoutput query="rsTipoDoc"> 
                  <option value="#rsTipoDoc.id_tipo#" <cfif modo NEQ 'ALTA' and Trim(rsForm.id_tipo) EQ Trim(rsTipoDoc.id_tipo)> selected</cfif>>#rsTipoDoc.nombre_tipo#</option>
                </cfoutput> 
                <option value="">-------------------</option>
                <option value="0">Crear Nuevo ...</option>
              </select></td>
          </tr>
          <tr> 
            <td valign="top" nowrap ><strong>Tipo de Contenido</strong></td>
            <td align="left" valign="top" nowrap ><select name="cbTipoCont" id="cbTipoCont" onChange="javascript: cambioTipoCont(this); validar(this);">
                <option value="L" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'L'> selected</cfif>>Link</option>
                <option value="D" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'D'> selected</cfif>>Documento</option>
                <option value="I" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'I'> selected</cfif>>Imagen</option>
                <option value="T" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'T'> selected</cfif>>Texto</option>
              </select></td>
          </tr>
          <tr> 
            <td valign="top" nowrap ><strong>Titulo</strong></td>
            <td align="left" valign="top" nowrap > <input name="titulo" type="text" id="titulo" size="35" maxlength="50" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.titulo)#</cfoutput></cfif>"> 
            </td>
          </tr>
          <tr> 
            <td valign="top" nowrap > <div style="display: ;" id="verTitResumen"><strong> 
                Texto </strong></div>
              <div style="display: ;" id="verTitImagen"><strong> Imagen - Documento 
                </strong></div>
              <div style="display: ;" id="verTitArchivo"><strong> Liga de Referencia 
                </strong></div></td>
            <td align="left" valign="top"> <div style="display: ;" id="verResumen"> 
                <textarea name="resumen" cols="30" rows="3" onFocus="this.select()" id="resumen"><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.resumen)#</cfoutput></cfif></textarea>
              </div>
              <div style="display: ;" id="verImagen"> 
                <input name="fileImage" type="file" id="fileImage" size="35" maxlength="255">
              </div>
              <div style="display: ;" id="verArchivo"> 
                <input name="nom_archivo" type="text" id="nom_archivo" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.nom_archivo)#</cfoutput><cfelse>http://</cfif>" size="35" maxlength="255">
              </div></td>
          </tr>
          <cfset CodIdAtributo = 0>
          <cfoutput query="rsAtributos"> 
            <cfset CodIdAtributo = #rsAtributos.id_atributo#>
            <cfif modo NEQ "ALTA">
              <cfquery dbtype="query" name="rsAtribDocBusq">
              Select consecutivo, id_valor, valor from rsAtribDoc where id_atributo 
              = 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodIdAtributo#">
              </cfquery>
            </cfif>
            <tr> 
              <td colspan="2" nowrap> <div style="display: ;" id="ver_#rsAtributos.id_tipo#_#CodIdAtributo#"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="35%" align="left" nowrap><strong>#rsAtributos.nombre_atributo#</strong></td>
                      <td width="65%"> <cfif rsAtributos.tipo_atributo EQ 'T'>
                          <!--- Texto --->
                          <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" id="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" type="text" size="30" maxlength="255" onFocus="this.select();" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
                          <cfelseif rsAtributos.tipo_atributo EQ 'N'>
                          <!--- Numero --->
                          <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" type="text" size="30" maxlength="255" style="text-align:right" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
                          <cfelseif rsAtributos.tipo_atributo EQ 'F'>
                          <!--- Fecha --->
                          <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" size="12" maxlength="10" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
                          <a href="##"> 
                          <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formDocumentos.<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#');"> 
                          </a> 
                          <cfelseif rsAtributos.tipo_atributo EQ 'V'>
                          <!--- Valor (Combo de valores) --->
                          <select name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" id="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#">
                            <cfloop query="rsValorAtributo">
                              <cfif rsValorAtributo.id_atributo EQ CodIdAtributo>
                                <option value="#rsValorAtributo.id_valor#" <cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0 and rsValorAtributo.id_valor EQ rsAtribDocBusq.id_valor> selected</cfif>>#rsValorAtributo.contenido#</option>
                              </cfif>
                            </cfloop>
                          </select>
                        </cfif> </td>
                    </tr>
                  </table>
                </div></tr>
          </cfoutput> 
          <tr> 
            <td colspan="5">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center" colspan="5"><cfinclude template="../../portlets/pBotones.cfm"></td>
          </tr>
        </table></td>
      <td rowspan="8" width="45%" valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr valign="top">
            <td height="19" colspan="3" align="center" nowrap >&nbsp;</td>
          </tr>
          <tr valign="top"> 
            <td height="21" colspan="3" align="center" nowrap ><strong>Tipos de 
              Materia en donde se Aplica el Documento</strong></td>
          </tr>
          <cfoutput query="rsMateriaTipo"> 
            <cfif modo EQ "CAMBIO">
              <cfquery dbtype="query" name="rsDocumMatTipoCount">
              Select MTcodigo from rsDocumMatTipo where id_documento = 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_documento#">
              and MTcodigo = 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMateriaTipo.MTcodigo#">
              </cfquery>
            </cfif>
            <tr> 
              <td width="33%" height="19" align="right"> <input type="checkbox" name="MateriaTipo" value="#rsMateriaTipo.MTcodigo#" <cfif modo EQ "CAMBIO" and rsDocumMatTipoCount.recordCount GT 0> checked</cfif>></td>
              <td width="4%" align="right">&nbsp;</td>
              <td width="63%">#rsMateriaTipo.MTdescripcion#</td>
            </tr>
          </cfoutput> </table></td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%">&nbsp;</td>
    </tr>
  </table>

  </form>
<form action="../MaterialApoyo/documentos.cfm" method="post" name="FiltroDocumentos">	
  <table class="areaFiltro" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="21%" height="21" nowrap >Titulo</td>
      <td width="22%" nowrap >Tipo de Materia</td>
      <td width="23%" nowrap >Tipo de Documento</td>
      <td width="21%" nowrap >Tipo de Contenido</td>
      <td width="13%" nowrap>&nbsp;
	  		<input name="Splaza" id="Splaza" value="<cfoutput>#form.Splaza#</cfoutput>" type="hidden"> 
	  </td>
    </tr>
    <tr> 
      <td nowrap><input name="tituloFiltro" type="text" id="tituloFiltro" size="25" maxlength="50" value="<cfif isdefined("Form.tituloFiltro")><cfoutput>#Form.tituloFiltro#</cfoutput></cfif>"></td>
      <td nowrap><select name="cbTipoMatFiltro" id="cbTipoMatFiltro">
          <option value="-1" <cfif isdefined('form.cbTipoDocFiltro') and form.cbTipoMatFiltro EQ '-1'> selected</cfif>>-- 
          Todos --</option>
          <cfoutput query="rsMateriaTipo"> 
            <option value="#rsMateriaTipo.MTcodigo#" <cfif isdefined('form.cbTipoMatFiltro') and form.cbTipoMatFiltro EQ rsMateriaTipo.MTcodigo> selected</cfif>>#rsMateriaTipo.MTdescripcion#</option>
          </cfoutput> </select> </td>
      <td nowrap> 
		<select name="cbTipoDocFiltro" id="cbTipoDocFiltro">
          <option value="-1" <cfif isdefined('form.cbTipoDocFiltro') and form.cbTipoDocFiltro EQ '-1'> selected</cfif>>-- Todos --</option>		
          <cfoutput query="rsTipoDoc"> 
            <option value="#rsTipoDoc.id_tipo#" <cfif isdefined('form.cbTipoDocFiltro') and form.cbTipoDocFiltro EQ rsTipoDoc.id_tipo> selected</cfif>>#rsTipoDoc.nombre_tipo#</option>
          </cfoutput>
		</select>	  
	  </td>
      <td nowrap> 
		<select name="cbTipoContFiltro" id="cbTipoContFiltro">
          <option value="-1" <cfif isdefined('form.cbTipoContFiltro') and form.cbTipoContFiltro EQ '-1'> selected</cfif>>-- Todos --</option>				
          <option value="T" <cfif isdefined('form.cbTipoContFiltro') and  form.cbTipoContFiltro EQ 'T'> selected</cfif>>Texto</option>
          <option value="L" <cfif isdefined('form.cbTipoContFiltro') and  form.cbTipoContFiltro EQ 'L'> selected</cfif>>Link</option>
          <option value="D" <cfif isdefined('form.cbTipoContFiltro') and  form.cbTipoContFiltro EQ 'D'> selected</cfif>>Documento</option>
          <option value="I" <cfif isdefined('form.cbTipoContFiltro') and  form.cbTipoContFiltro EQ 'I'> selected</cfif>>Imagen</option>
        </select>
      </td>
      <td align="center" nowrap> <input type="submit" name="Filtrar" tabindex="5" value="Buscar"> 
      </td>
    </tr>
  </table>
  </form>
  <table width="100%">
	<tr> 
		<td align="right"><b>Haga click en uno de los íconos para probar</b></td>
	</tr> 
    <tr>
		<td>
		 <cfset filtro = "">
					 <cfset navegacion = "">
					 <cfset parExtra = "">					 
					 <cfset f1 = "">
					 <cfset f2 = "">
					 <cfset f3 = "-1">
					 <cfset f4 = "-1">
				 	 <cfset f5 = "-1">
					 
					 <cfif isdefined("Form.tituloFiltro") and Form.tituloFiltro NEQ "">
						<cfset filtro = filtro & " and Upper(titulo) like Upper('%" & #Form.tituloFiltro# & "%')">
						<cfset f1 = Form.tituloFiltro>
						<cfset navegacion = "tituloFiltro=" & Form.tituloFiltro>
					 </cfif>
					 <cfif isdefined("Form.autorFiltro") and Form.autorFiltro NEQ ''>
						<cfset filtro = filtro & " and Upper(autor) like Upper('%" & #Form.autorFiltro# & "%')">
						<cfset f2 = Form.autorFiltro>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "autorFiltro=" & Form.autorFiltro>
					 </cfif>
					 <cfif isdefined("Form.cbTipoMatFiltro") and Len(Trim(Form.cbTipoMatFiltro)) NEQ 0 and Form.cbTipoMatFiltro NEQ '-1' and Form.cbTipoMatFiltro NEQ ''>
						<cfset filtro = filtro & " and MT.MTcodigo=" & #Form.cbTipoMatFiltro#>
						<cfset f5 = Form.cbTipoMatFiltro>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cbTipoMatFiltro=" & Form.cbTipoMatFiltro>
					 </cfif>
 					 <cfif isdefined("Form.cbTipoDocFiltro") and Len(Trim(Form.cbTipoDocFiltro)) NEQ 0 and Form.cbTipoDocFiltro NEQ '-1' and Form.cbTipoDocFiltro NEQ ''>
						<cfset filtro = filtro & " and MAD.id_tipo=" & #Form.cbTipoDocFiltro#>
						<cfset f3 = Form.cbTipoDocFiltro>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cbTipoDocFiltro=" & Form.cbTipoDocFiltro>
					 </cfif>
					 <cfif isdefined("Form.cbTipoContFiltro") and Form.cbTipoContFiltro NEQ '-1' and Form.cbTipoContFiltro NEQ ''>
						<cfset filtro = filtro & " and tipo_contenido = '" & #Form.cbTipoContFiltro# & "'">
						<cfset f4 = Form.cbTipoContFiltro>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cbTipoContFiltro=" & Form.cbTipoContFiltro>
					 </cfif>
					 	<cfset filtro = filtro & " and MAD.Splaza = " & #form.Splaza# >
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Splaza=" & form.Splaza>
 					<cfif f1 NEQ ''>
						<cfset parExtra = parExtra & "'" & f1 & "' as tituloFiltro,"> 
					<cfelseif f2 NEQ ''>
						<cfset parExtra = parExtra & "'" & f2 & "' as autorFiltro,">
					<cfelseif f3 NEQ '-1'>
						<cfset parExtra = parExtra & f3 & " as cbTipoDocFiltro,">
					<cfelseif f4 NEQ '-1'>
						<cfset parExtra = parExtra & "'" & f4 & "' as cbTipoContFiltro,">
					<cfelseif f5 NEQ '-1'>
						<cfset parExtra = parExtra & "'" & f5 & "' as cbTipoMatFiltro,">						
					</cfif>
 	
						<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaMaterialApoyo">
							<cfinvokeargument name="tabla" value="MADocumento MAD, MATipoDocumento MADT, BibliotecaCentroE BCE, DocumentoMateriaTipo  DMT, MateriaTipo MT"/>
							<cfinvokeargument name="columnas" value="#parExtra# convert(varchar,MAD.id_documento) as id_documento, 
																convert(varchar,MAD.Splaza) as Splaza,
																convert(varchar,MAD.id_tipo) as id_tipo, 
																titulo, 
																MAD.tipo_contenido,
																MADT.nombre_tipo,
																substring(MT.MTdescripcion,1,50) as MTdescripcion,
																case MAD.tipo_contenido when 'I' then '<a href=''/cfmx/edu/Utiles/downloadMA.cfm?cod='+convert(varchar,MAD.id_documento)+ '''>'+'<img border=''0'' alt=''Ver Imagen'' src=''/cfmx/edu/Imagenes/eye.jpg''>' +'</a>'
																		  when 'D' then '<a href=''/cfmx/edu/Utiles/downloadMA.cfm?cod='+convert(varchar,MAD.id_documento)+ '''>'+'<img border=''0'' alt=''Descargar Documento'' src=''/cfmx/edu/Imagenes/documento.gif''>' +'</a>' 
																		  when 'L' then '<a href='''+ MAD.nom_archivo + '''>'+'<img border=''0'' alt=''Visitar Link'' src=''/cfmx/edu/Imagenes/web.gif''>' +'</a>' 
																		  when 'T' then '<img border=''0'' alt=''Ver Texto'' src=''/cfmx/edu/Imagenes/texto.gif''>' else '' end as img_contenido,
																case MAD.tipo_contenido when 'I' then 'Imagen' when 'D' then 'Documento' when 'L' then 'Link' when 'T' then 'Texto' else 'No definido' end as tipo 						
																"/> 
							<cfinvokeargument name="desplegar" value="titulo, MTdescripcion, tipo, img_contenido"/>
							<cfinvokeargument name="etiquetas" value="Titulo, Tipo de Materia, Tipo de Contenido, "/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="maxrows" value="20"/>
							<cfinvokeargument name="filtro" value="1=1 #filtro# and BCE.CEcodigo = #Session.Edu.CEcodigo# 
																				and MAD.id_tipo = MADT.id_tipo 
																				and MADT.id_biblioteca = BCE.id_biblioteca 
																				and MAD.id_documento = DMT.id_documento 
																				and MAD.id_documento = DMT.id_documento
																				and MT.MTcodigo = DMT.MTcodigo
																				order by MAD.id_tipo, DMT.MTcodigo, titulo
																				 "/>
							<cfinvokeargument name="align" value="left,left,rigth,rigth"/>
							<cfinvokeargument name="ajustar" value="N,N,N,N"/>
							<cfinvokeargument name="irA" value="documentos.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="cortes" value="nombre_tipo"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxrows" value="17"/>						
						</cfinvoke>
		</td>
	</tr>
  </table>					
			

<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>			
<script language="JavaScript" type="text/javascript">

	function validar(ctl) {
				
			if (ctl.value == 'L') {
				objForm.nom_archivo.required = true;
				objForm.nom_archivo.description = "Liga de referencia";
				objForm.resumen.required = false;
				objForm.fileImage.required = false;
			} 
			else if (ctl.value == 'T') {
				objForm.resumen.required = true;
				objForm.resumen.description = "Texto";
				objForm.nom_archivo.required = false;
				objForm.fileImage.required = false;	
			} 
			else if (ctl.value == 'I') {
				
				if (btnSelected("Nuevo") || btnSelected("Eliminar") || btnSelected("Modificar")) {
					objForm.fileImage.required = false;			
				} else {
					<cfif modo EQ "ALTA">
					objForm.fileImage.required = true;
					<cfelse>
					objForm.fileImage.required = false;
					</cfif>
					objForm.fileImage.description = "Imagen - Documento";
				}
				objForm.nom_archivo.required = false;
				objForm.resumen.required = false;
	
			} 
			else if (ctl.value == 'D') {
				<cfif modo EQ "ALTA">
				objForm.fileImage.required = true;
				<cfelse>
				objForm.fileImage.required = false;
				</cfif>
				objForm.fileImage.description = "Imagen - Documento";
				objForm.nom_archivo.required = false;
				objForm.resumen.required = false;
			}
			objForm.MateriaTipo.required = true;
			objForm.MateriaTipo.description = "Tipo de materia";
	
	}

	function deshabilitarValidacion() {
		objForm.titulo.required = false;
		objForm.cbTipoDoc.required = false;
		objForm.MateriaTipo.required = false;
		objForm.fileImage.required = false;
		objForm.nom_archivo.required = false;
		objForm.resumen.required = false;
		<cfoutput query="rsAtributos">
			<cfset CodIdAtributo = #rsAtributos.id_atributo#>
			<cfif modo NEQ "ALTA">
				<cfquery dbtype="query" name="rsAtribDocBusq">
					Select consecutivo,
						   id_valor, 
						   valor 
					from rsAtribDoc 
					where id_atributo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodIdAtributo#">
				</cfquery>
			</cfif>
			objForm.<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#.required = false;
		</cfoutput> 
	}

	function habilitarValidacion() {
		objForm.titulo.required = true;
		objForm.cbTipoDoc.required = true;
		objForm.MateriaTipo.required = false;
		validar(document.formDocumentos.cbTipoCont);
		cambioTipoDoc(document.formDocumentos.cbTipoDoc);
	}

	arrAtrib = new Array();
	arrTipoDoc = new Array();	
	
	<cfloop query="rsTipoDoc">
		arrTipoDoc[arrTipoDoc.length] = '<cfoutput>#rsTipoDoc.id_tipo#</cfoutput>'		
	</cfloop>	
	<cfloop query="rsAtributos">
		arrAtrib[arrAtrib.length] =  '<cfoutput>#rsAtributos.id_tipo#</cfoutput>' + ',' + '<cfoutput>#rsAtributos.id_atributo#</cfoutput>'
	</cfloop>	
	
	<cfif modo NEQ "ALTA">
		arrAtribDoc = new Array();
		<cfloop query="rsAtribDoc">
			arrAtribDoc[arrAtribDoc.length] =  '<cfoutput>#rsAtribDoc.consecutivo#</cfoutput>';
		</cfloop>	
	</cfif>

	function valValor(obj, cod){
		if(obj.value != '' && eval('obj.form.ValorAtrib_' + cod + '.value') == ''){	
			alert('Para digitar este valor debe existir el tipo de atributo para el documento');
			obj.value = '';
		}		
	}	

	function cambioTipoDoc(obj){
		if(obj.value != ""){
			//Apagado de todas las lineas de los atributos
			for (var idx=0; idx < arrTipoDoc.length; idx++) {
				for (var idxAtri=0; idxAtri < arrAtrib.length; idxAtri++) {
					var arrAtributos = arrAtrib[idxAtri].split(',');
					if(arrTipoDoc[idx] == arrAtributos[0]){
						var connDiv	= document.getElementById('ver_' + arrTipoDoc[idx] + "_" + arrAtributos[1]);
						connDiv.style.display = "none";
						var attribEl = eval("objForm.ValorAtrib_" + arrTipoDoc[idx] + "_" + arrAtributos[1]);
						if (attribEl) attribEl.required = false;
						<cfif modo NEQ "ALTA">
						for (var _idxAt=0; _idxAt < arrAtribDoc.length; _idxAt++) {
							var attribEl2 = eval("objForm.Consec_" + arrAtribDoc[_idxAt] + "_<cfoutput>#rsForm.id_documento#</cfoutput>_" + arrTipoDoc[idx] + "_" + arrAtributos[1]);
							if (attribEl2) attribEl2.required = false;
						}
						</cfif>
					}
				}	
			}
	
			//Prendido de todas las lineas de los atrobutos pero solo de las del tipo seleccionado
			for (var idxAtri=0; idxAtri < arrAtrib.length; idxAtri++) {
				var arrAtributos = arrAtrib[idxAtri].split(',');
				if(obj.value == arrAtributos[0]){
					var connDiv	= document.getElementById('ver_' + obj.value + "_" + arrAtributos[1]);						
					connDiv.style.display = "";		
					var attribEl = eval("objForm.ValorAtrib_" + obj.value + "_" + arrAtributos[1]);
					if (attribEl) attribEl.required = true;
					<cfif modo NEQ "ALTA">
					for (var _idxAt=0; _idxAt < arrAtribDoc.length; _idxAt++) {
						var attribEl2 = eval("objForm.Consec_" + arrAtribDoc[_idxAt] + "_<cfoutput>#rsForm.id_documento#</cfoutput>_" + obj.value + "_" + arrAtributos[1]);
						if (attribEl2) attribEl2.required = true;
					}
					</cfif>
				}
			}		
		}
	}

	function cambioTipoCont(obj){
		var connVerResumen	= document.getElementById("verResumen");
		var connVerImagen	= document.getElementById("verImagen");
		var connVerArchivo	= document.getElementById("verArchivo");
		
		var connVerTitResumen	= document.getElementById("verTitResumen");
		var connVerTitImagen	= document.getElementById("verTitImagen");
		var connVerTitArchivo	= document.getElementById("verTitArchivo");		
		
		switch(obj.value){
			case 'T':{
				connVerResumen.style.display = "";
				connVerTitResumen.style.display = "";
				connVerImagen.style.display = "none";
				connVerTitImagen.style.display = "none";
				connVerArchivo.style.display = "none";
				connVerTitArchivo.style.display = "none";
			}
			break;
			case 'L':{				
				connVerResumen.style.display = "none";									
				connVerImagen.style.display = "none";				
				connVerArchivo.style.display = "";				
				connVerTitResumen.style.display = "none";									
				connVerTitImagen.style.display = "none";				
				connVerTitArchivo.style.display = "";				
			}
			break;
			case 'D':{
				connVerResumen.style.display = "none";													
				connVerImagen.style.display = "";				
				connVerArchivo.style.display = "none";
				connVerTitResumen.style.display = "none";													
				connVerTitImagen.style.display = "";				
				connVerTitArchivo.style.display = "none";												
			}
			break;			
			case 'I':{		
				connVerResumen.style.display = "none";
				connVerImagen.style.display = "";
				connVerArchivo.style.display = "none";
				connVerTitResumen.style.display = "none";													
				connVerTitImagen.style.display = "";				
				connVerTitArchivo.style.display = "none";												
			}
			break;			
		}
	}		  	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formDocumentos");
	
	objForm.titulo.required = true;
	objForm.titulo.description = "Titulo";	
	objForm.cbTipoDoc.required = true;
	objForm.cbTipoDoc.description = "Tipo de Documento";

	<cfoutput query="rsAtributos">
		<cfset CodIdAtributo = #rsAtributos.id_atributo#>
		<cfif modo NEQ "ALTA">
			<cfquery dbtype="query" name="rsAtribDocBusq">
				Select consecutivo,
				       id_valor, 
					   valor 
				from rsAtribDoc 
				where id_atributo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodIdAtributo#">
			</cfquery>
		</cfif>
		objForm.<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#.required = true;
		objForm.<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#.description = "#rsAtributos.nombre_atributo#";
	</cfoutput> 
	
//------------------------------------------------------------------------------------------											
	cambioTipoCont(document.formDocumentos.cbTipoCont);
	cambioTipoDoc(document.formDocumentos.cbTipoDoc);
	validar(document.formDocumentos.cbTipoCont);
   	
</script>
