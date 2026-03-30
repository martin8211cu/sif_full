<cfquery name="RSInstitucion" datasource="#session.DSN#">
	select RHIAid,RHIAcodigo,RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHIAid
</cfquery>


<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>	
	<cfset form.formulario = form1>
</cfif>
<cfif isdefined("url.index") and not isdefined("form.index")>
	<cfset form.index = url.index>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(Mcodigo,RHCcodigo,RHCnombre,RHCid,RHIAid,RHCfdesde,RHCfhasta) {
	if (window.opener != null) {	
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo<cfoutput>#form.index#</cfoutput>.value = Mcodigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHCcodigo<cfoutput>#form.index#</cfoutput>.value = RHCcodigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHCnombre<cfoutput>#form.index#</cfoutput>.value = RHCnombre;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHCid<cfoutput>#form.index#</cfoutput>.value = RHCid;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHIAid<cfoutput>#form.index#</cfoutput>.value = RHIAid;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHCfdesde<cfoutput>#form.index#</cfoutput>.value = RHCfdesde;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.RHCfhasta<cfoutput>#form.index#</cfoutput>.value = RHCfhasta;		
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<!--- Filtra por RHCcodigo(codigo del curso)---->
<cfif isdefined("Form.fMsiglas") and Len(Trim(Form.fMsiglas)) NEQ 0>	
	<cfset filtro = filtro & " and upper(a.RHCcodigo) like '%" & UCase(Form.fMsiglas) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMsiglas=" & Form.fMsiglas>
</cfif>
<cfif isdefined("Form.fMnombre") and Len(Trim(Form.fMnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHCnombre) like '%" & UCase(Form.fMnombre) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMnombre=" & Form.fMnombre>
</cfif>
<cfif isdefined("Form.RHIAid") and Len(Trim(Form.RHIAid)) NEQ 0 and Form.RHIAid NEQ 'Todas'>
 	<cfset filtro = filtro & " and d.RHIAid =" & #Form.RHIAid#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHIAid=" & Form.RHIAid>
</cfif>

<html>
<head>
<title><cf_translate key="LB_ListaDeCursos" xmlFile="/rh/generales.xml">Lista de Cursos</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroCursos" method="post">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<cfif Len(Trim(index))>
		<input type="hidden" name="index" value="#index#">
	</cfif>			  	
	<tr>
		<td width="5%" align="right"><strong>C&oacute;digo:</strong></td>
		<td width="7%"> 
			<input name="fMsiglas" type="text" id="desc" size="10" maxlength="15" value="<cfif isdefined("Form.fMsiglas")>#Form.fMsiglas#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="10%" align="right"><strong>Descripci&oacute;n</strong></td>
		<td width="27%"> 
			<input name="fMnombre" type="text" id="desc" size="30" maxlength="50" value="<cfif isdefined("Form.fMnombre")>#Form.fMnombre#</cfif>" onFocus="javascript:this.select();">
		</td>		
		<td width="8%" align="right"><strong>Instituci&oacute;n</strong></td>
		<td width="38%"> 
			<select name="RHIAid">
				<OPTION  VALUE="Todas">Todas</OPTION>
				<cfloop query="RSInstitucion"> 
                       <option <cfif isdefined("Form.RHIAid") and  Form.RHIAid EQ RSInstitucion.RHIAid>selected</cfif> value="#RSInstitucion.RHIAid#" >#RSInstitucion.RHIAcodigo#-#RSInstitucion.RHIAnombre#</option>
                </cfloop>
			</select>
		</td>		

		<td width="5%" align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>	
</table>
</form>
</cfoutput>

<cfset fecha = LSParseDateTime(LSDateFormat(now(),'dd/mm/yyyy')) >

<cfquery name="lista" datasource="#session.DSN#">
	select 	a.RHCnombre, 
			c.Msiglas,
			<cf_dbfunction name="date_format" args="a.RHCfdesde,DD/MM/YYYY"> as RHCfdesde,
			<cf_dbfunction name="date_format" args="a.RHCfhasta,DD/MM/YYYY"> as RHCfhasta,
			a.RHCid,
			a.RHIAid,
			a.Mcodigo,
			a.RHCcupo,
			d.RHIAnombre,
			a.RHCcodigo			

	from RHCursos a
	
		inner join RHOfertaAcademica b
			on a.RHIAid = b.RHIAid
			and a.Mcodigo = b.Mcodigo

		inner join RHMateria c
			on b.Mcodigo = c.Mcodigo
			and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">	

		inner join RHInstitucionesA d
			on b.RHIAid = d.RHIAid

	where a.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
		<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
			and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		</cfif>
	#preservesinglequotes(filtro)#
	
	order by d.RHIAnombre,a.RHCnombre, a.RHCcodigo
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#lista#"/>
	<cfinvokeargument name="desplegar" value="RHCcodigo,RHCnombre, RHCfdesde, RHCfhasta, RHCcupo"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción, Desde, Hasta, Cupo"/>
	<cfinvokeargument name="formatos" value="V,V,D,D,V"/>
	<cfinvokeargument name="align" value="left, left, left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisRHCursos.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar#index#"/>
	<cfinvokeargument name="fparams" value="Mcodigo,RHCcodigo,RHCnombre,RHCid,RHIAid,RHCfdesde,RHCfhasta"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="Cortes" value="RHIAnombre"/>

</cfinvoke>
</body>
</html>