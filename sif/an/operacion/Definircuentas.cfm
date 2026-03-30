<html>
<head>
<title>Anexos Financieros: Cuentas Contables por Rango</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfquery name="rsFmt" datasource="#Session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 10
</cfquery>
<cfif isdefined("url.AnexoId") and url.AnexoId NEQ "">
	<cfparam name="Form.AnexoId" default="#url.AnexoId#">
</cfif>
<cfif isdefined("url.AnexoCelId") and url.AnexoCelId NEQ "">
	<cfparam name="Form.AnexoCelId" default="#url.AnexoCelId#">
</cfif>
<cfquery name="rsAnexo" datasource="#Session.DSN#">
	select 	AnexoDes,
		 	<cf_dbfunction name="to_date" args="AnexoFec"> as AnexoFec, 
			AnexoUsu 
	from Anexo
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
</cfquery>

<cfquery name="rsRangos" datasource="#Session.DSN#">
	select AnexoRan 
	from AnexoCel 
	where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
</cfquery>
<cfoutput>
  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="ayuda">
    <tr> 
      <td colspan="5" bgcolor="##3399CC"> <div align="center"><strong><font color="##FFFFFF" size="2">Anexos 
          Financieros </font></strong></div></td>
    </tr>
    <tr> 
      <td width="6%"><strong>Anexo:</strong></td>
      <td width="30%">#rsAnexo.AnexoDes#</td>
      <td><strong>Fecha:</strong></td>
      <td>#rsAnexo.AnexoFec#</td>
      <td width="34%">&nbsp;</td>
    </tr>
    <tr> 
      <td><strong>Rango:</strong></td>
      <td>#rsRangos.AnexoRan#</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  </cfoutput>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="tituloAlterno"> 
    <td width="43%"><div align="left"><font size="2">Cuentas Contables Rango:<strong>&nbsp;<cfoutput>#rsRangos.AnexoRan#</cfoutput></strong> </font></div></td>
    <td width="57%"><div align="left"><font size="2">Formato Completo de Cuentas 
        Contables: <strong><cfoutput>#Trim(rsFmt.Pvalor)#</cfoutput></strong></font></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td valign="top"> 
	<cf_dbfunction name="to_char" args="b.AnexoId" 		returnvariable="AnexoId" >
	<cf_dbfunction name="to_char" args="a.AnexoCelDid" 	returnvariable="AnexoCelDid" >
	<cf_dbfunction name="to_char" args="a.AnexoCelId" 	returnvariable="AnexoCelId" >
	<cf_dbfunction name="length" args="a.AnexoCelFmt" 	returnvariable="AnexoCelFmt" >	
	<cf_dbfunction name="sPart"	  args="a.AnexoCelFmt;1;#AnexoCelFmt#-1" delimiters=";" returnvariable="AnexoCelFmt">	
	<cfinvoke 
 		component="sif.Componentes.pListas"
 		method="pListaRH"
 		returnvariable="pListaRet">
        <cfinvokeargument name="tabla" 		value="AnexoCelD a, AnexoCel b"/>
        <cfinvokeargument name="columnas" 	value="#AnexoId# as AnexoId, #AnexoCelDid# as AnexoCelDid, #AnexoCelId# as AnexoCelId, case when a.AnexoCelMov ='N' then a.AnexoCelFmt else #AnexoCelFmt# end as AnexoCelFmt, a.AnexoCelFmt as Cformato, a.AnexoCelMov"/>
        <cfinvokeargument name="desplegar" 	value="AnexoCelFmt, AnexoCelMov"/>
        <cfinvokeargument name="etiquetas" 	value="Formato, Movimientos"/>
        <cfinvokeargument name="formatos" 	value=""/>
        <cfinvokeargument name="filtro" 	value="a.AnexoCelId = #Form.AnexoCelid# and a.AnexoCelId = b.AnexoCelId"/>
        <cfinvokeargument name="align"		value="left, left"/>
        <cfinvokeargument name="ajustar" 	value="S,N"/>
        <cfinvokeargument name="checkboxes" value="N"/>
        <cfinvokeargument name="irA" 		value="Definircuentas.cfm"/>
        <cfinvokeargument name="maxrows" 	value="0"/>
      </cfinvoke> </td>
    <td><cfinclude template="formAnexoCelD.cfm"><br>
<table width="100%" border="0" cellspacing="2" cellpadding="2" class="ayuda">
        <tr> 
          <td><strong>Instrucciones:</strong></td>
        </tr>
        <tr> 
          <td height="87">
<ol>
              <li>Indique el formato de cuenta contable que desea asignar al rango.</li>
              <li>Los caracteres v&aacute;lidos son: <font color="#666699"><strong>[0-9][x][X][?][_]</strong></font></li>
              <li>Si desea agregar una cuenta particular puede seleccionarla de 
                la lista presionando el indicador <img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas" name="instimagen" width="18" height="14" border="0" align="absmiddle"></li>
              <li>Para regresar a la definici&oacute;n de Rangos oprima <font color="#003399"><strong>Regresar</strong></font>.</li>
            </ol></td>
        </tr>
      </table>
</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</body>
</html>