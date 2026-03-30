<cfquery datasource="#Session.DSN#" name="rsSede">
	select convert(varchar,b.Scodigo) as Scodigo, rtrim(b.Snombre) as Snombre,
		Scodificacion, Sprefijo 	
		from Sede b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfif isdefined("Url.fGAnombre") and not isdefined("Form.fGAnombre")>
	<cfparam name="Form.fGAnombre" default="#Url.fGAnombre#">
</cfif>
<form name="GradoAcad_filtro" method="post" action="gradoAcademico.cfm">
	<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
	  <tr>
		<td align="left" nowrap>&nbsp;</td>
		<td align="left" nowrap><strong>Nombre del Grado Acad&eacute;mico</strong></td>
		<td width="14%" align="center"  nowrap>&nbsp;</td>
	  </tr>
	  <tr align="left">
		<td width="3%" nowrap>&nbsp;</td>
		<td width="64%" nowrap><input name="fGAnombre" type="text" id="fGAnombre2" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fGAnombre") AND Form.fGAnombre NEQ ""><cfoutput>#Form.fGAnombre#</cfoutput></cfif>">
		</td>
		<td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
	  </tr>
	</table>
</form>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fGAnombre") AND Form.fGAnombre NEQ "">
	<cfset filtro = "and upper(rtrim(GAnombre)) like upper('%" & #Trim(Form.fGAnombre)# & "%')">
	<cfset navegacion = "fGAnombre=" & Form.fGAnombre>
</cfif>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="GradoAcademico"/>
	<cfinvokeargument name="columnas" value="
							convert(varchar,Ecodigo) as Ecodigo,
							convert(varchar,GAcodigo) as GAcodigo,
							GAnombre,
							GAorden
				, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
				, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg
							"/>
	<cfinvokeargument name="desplegar" value="GAnombre, upImg, downImg"/>
	<cfinvokeargument name="etiquetas" value="Nombre, , "/>
	<cfinvokeargument name="formatos" value="V,IMG,IMG"/>
	<cfinvokeargument name="filtro" value=" Ecodigo = #session.Ecodigo# 
											#filtro#
											order by GAorden"/>
	<cfinvokeargument name="align" value="left,left,left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="keys" value="GAcodigo"/>
	<cfinvokeargument name="funcion" value=" ,fnSubir,fnBajar" />
	<cfinvokeargument name="fparams" value="GAcodigo,GAorden"/>
	<cfinvokeargument name="funcionByCols" value="true"/>
	<cfinvokeargument name="irA" value="gradoAcademico.cfm"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="navegacion" value="#navegacion#" />
</cfinvoke>
<form name="frmMove" action="gradoAcademico_SQL.cfm" method="post">
	<input type="hidden" name="modoMove">
	<input type="hidden" name="GAcodigo">
	<input type="hidden" name="GAorden">
</form>
<script language="JavaScript">
function fnSubir(GAcodigo,GAorden)
{
	fnMove(GAcodigo,GAorden,"up");
}
function fnBajar(GAcodigo,GAorden)
{
	fnMove(GAcodigo,GAorden,"dw");
}
function fnMove(GAcodigo,GAorden,mv)
{
	document.frmMove.modoMove.value=mv;
	document.frmMove.GAcodigo.value=GAcodigo;
	document.frmMove.GAorden.value=GAorden;
	document.frmMove.submit();
}
</script>