<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="23%" valign="top" nowrap ><strong>Titulo</strong></td>
    <td width="29%" height="22" align="left" valign="top" nowrap >
      <input name="titulo" type="text" id="titulo" size="35" maxlength="50" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.titulo)#</cfoutput></cfif>">
    </td>
  </tr>
  <tr>
    <td width="23%" valign="top" ><strong>Autor </strong></td>
    <td align="left" valign="top"><input name="autor" type="text" id="autor4" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.autor)#</cfoutput></cfif>" size="35" maxlength="60">
    </td>
  <tr>
    <td valign="top"><strong>Fecha </strong></td>
    <td align="left" valign="top"> <a href="#">
      <input name="fecha" id="fecha3" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif modo NEQ "ALTA">#Trim(rsForm.fecha)#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
      <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formDocumentos.fecha');"> </a> </td>
  <tr>
    <td valign="top" nowrap ><strong>Tipo de Documento</strong></td>
    <td align="left" valign="top" nowrap><select name="cbTipoDoc" id="select3" onChange="javascript: cambioTipoDoc(this)">
        <cfoutput query="rsTipoDoc">
          <option value="#rsTipoDoc.id_tipo#" <cfif modo NEQ 'ALTA' and Trim(rsForm.id_tipo) EQ Trim(rsTipoDoc.id_tipo)> selected</cfif>>#rsTipoDoc.nombre_tipo#</option>
        </cfoutput>
      </select>
    </td>
  </tr>
  <cfset CodIdAtributo = 0>
  <cfoutput query="rsAtributos">
    <cfset CodIdAtributo = #rsAtributos.id_atributo#>
    <cfif modo NEQ "ALTA">
      <cfquery dbtype="query" name="rsAtribDocBusq">
      Select consecutivo,id_valor,valor from rsAtribDoc where id_atributo=
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodIdAtributo#">
      </cfquery>
    </cfif>
    <tr>
      <td  align="left" valign="top">
        <div style="display: ;" id="verTit_#rsAtributos.id_tipo#_#CodIdAtributo#"> <strong>#rsAtributos.nombre_atributo#</strong></div>
      </td>
      <td align="left" >
        <div style="display: ;" id="ver_#rsAtributos.id_tipo#_#CodIdAtributo#">
          <cfif rsAtributos.tipo_atributo EQ 'T'>
            <!--- Texto --->
            <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" id="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" type="text" size="30" maxlength="255" onFocus="this.select();" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
          </cfif>
        </div>
      </td>
      <cfelseif rsAtributos.tipo_atributo EQ 'N'>
      <!--- Numero --->
      <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" type="text" size="30" maxlength="255" style="text-align:right" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
      <cfelseif rsAtributos.tipo_atributo EQ 'F'>
      <!--- Fecha --->
      <input name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" size="12" maxlength="10" value="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>#rsAtribDocBusq.valor#</cfif>">
      <a href="##"> <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formDocumentos.ValorAtrib_#rsAtributos.id_tipo#_#CodIdAtributo#');"> </a>
      <cfelseif rsAtributos.tipo_atributo EQ 'V'>
      <!--- Valor (Combo de valores) --->
      <select name="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#" id="<cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0>Consec_#rsAtribDocBusq.consecutivo#_#form.id_documento#_<cfelse>ValorAtrib_</cfif>#rsAtributos.id_tipo#_#CodIdAtributo#">
        <cfloop query="rsValorAtributo">
          <cfif rsValorAtributo.id_atributo EQ CodIdAtributo>
            <option value="#rsValorAtributo.id_valor#" <cfif modo NEQ "ALTA" and rsAtribDocBusq.recordCount GT 0 and rsValorAtributo.id_valor EQ rsAtribDocBusq.id_valor> selected</cfif>>#rsValorAtributo.contenido#</option>
          </cfif>
        </cfloop>
      </select>
    </tr>
    <!---  </table> --->
  </cfoutput>
  <tr>
    <td valign="top" nowrap ><strong>Tipo de Contenido</strong></td>
    <td>
      <select name="cbTipoCont" id="cbTipoCont" onChange="javascript: cambioTipoCont(this)">
        <option value="L" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'L'> selected</cfif>>Link</option>
        <option value="D" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'D'> selected</cfif>>Documento</option>
        <option value="I" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'I'> selected</cfif>>Imagen</option>
        <option value="T" <cfif modo NEQ 'ALTA' and Trim(rsForm.tipo_contenido) EQ 'T'> selected</cfif>>Texto</option>
      </select>
    </td>
  <tr>
    <td valign="top" nowrap ><div style="display: ;" id="verTitResumen"><strong> Resumen </strong></div>
        <div style="display: ;" id="verTitImagen"><strong> Imagen - Documento </strong></div>
        <div style="display: ;" id="verTitArchivo"><strong> Liga de Referencia </strong></div>
    </td>
    <td align="left" valign="top" nowrap>
      <div style="display: ;" id="verResumen">
        <textarea name="resumen" cols="30" rows="3" onFocus="this.select()" id="resumen"><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.resumen)#</cfoutput><cfelse>Aqui va el texto del resumen</cfif></textarea>
      </div>
      <div style="display: ;" id="verImagen">
        <input name="fileImage" type="file" id="fileImage" size="35" maxlength="255">
      </div>
      <div style="display: ;" id="verArchivo">
        <input name="nom_archivo" type="text" id="nom_archivo" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsForm.nom_archivo)#</cfoutput></cfif>" size="35" maxlength="255">
      </div>
    </td>
  </tr>
  <cfset CodIdAtributo = 0>
  <cfoutput query="rsAtributos">
    <cfset CodIdAtributo = #rsAtributos.id_atributo#>
    <cfif modo NEQ "ALTA">
      <cfquery dbtype="query" name="rsAtribDocBusq">
      Select consecutivo,id_valor,valor from rsAtribDoc where id_atributo=
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodIdAtributo#">
      </cfquery>
    </cfif>
  </cfoutput>
  <!--- Tipos de Materia --->
</table>
</body>
</html>
