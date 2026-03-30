<!--- Recibe form, conexion, atrRHPcodigo, atrRHPdescripcion, atrRHPid, RHPpuesto, Dcodigo, Ocodigo --->


<script language="JavaScript" type="text/javascript">
function Asignar(id, RHHdescripcion, RHCCnotaobt, codigo, tipo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#url.p3#.value = id;
		window.opener.document.#Url.form#.#Url.p1#.value = RHHdescripcion;
		window.opener.document.#Url.form#.#Url.p2#.value = RHCCnotaobt;
		window.opener.document.#Url.form#.#Url.p4#.value = codigo;
		window.opener.document.#Url.form#.#Url.p6#.value = tipo;
		</cfoutput>
		window.close();
	}
}

</script>

<cfif isdefined("Url.RHPCid") and not isdefined("Form.RHPCid")>
	<cfparam name="Form.RHPCid" default="#Url.RHPCid#">
</cfif>
<cfif isdefined("Url.RHCPid") and not isdefined("Form.RHCPid")>
	<cfparam name="Form.RHCPid" default="#Url.RHCPid#">
</cfif>
<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
	<cfparam name="Form.descripcion" default="#Url.descripcion#">
</cfif>
<cfif isdefined("Url.RHPid") and not isdefined("Form.RHPid")>
	<cfparam name="Form.RHPid" default="#Url.RHPid#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<cfset filtro1 = "">
<cfset filtro2 = "">
<cfset navegacion = "">


<cfif isdefined("Form.cod") and Len(Trim(Form.cod)) NEQ 0>
	<cfset filtro1 = filtro1 & " and upper(RHHcodigo) like '%" & #UCase(Form.cod)# & "%'">
	<cfset filtro2 = filtro2 & " and upper(RHCcodigo) like '%" & #UCase(Form.cod)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPCid=" & Form.RHPCid>
</cfif>
<cfif isdefined("Form.RHHdescripcion") and Len(Trim(Form.RHHdescripcion)) NEQ 0>
 	<cfset filtro1 = filtro1 & " and upper(RHHdescripcion) like '%" & #UCase(Form.descripcion)# & "%'">
 	<cfset filtro2 = filtro2 & " and upper(RHCdescripcion) like '%" & #UCase(Form.descripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcion=" & Form.descripcion>
</cfif>

<!--- <cfset filtro = filtro & " and rhp.RHPid = " & url.RHPid & " and RHCid not in (select RHCCid from  RHCompetenciasConcursante where RHPCid = " & Form.RHPCid & ")"> --->
<cfset filtro1 = filtro1 & " and rhp.RHPid = " & url.RHPid >
<cfset filtro2 = filtro2 & " and rhp.RHPid = " & url.RHPid >
<html>
<head>
<title>Lista de Plazas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroCompetencias" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="cod" type="text" id="cod" size="10" maxlength="10" value="<cfif isdefined("Form.cod")>#Form.cod#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="descripcion" type="text" id="descripcion" size="40" maxlength="80" value="<cfif isdefined("Form.descripcion")>#Form.descripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>

</cfoutput>

<br>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHPlazasConcurso rhpc
										 ,RHPlazas rhp
										 ,RHHabilidadesPuesto rhhp
										 ,RHHabilidades rhh 
										 ,RHCompetenciasConcursante cc
										 ,RHConcursantesPlaza rhcp
	"/>
	<cfinvokeargument name="columnas" value=" rhh.RHHid as id, rhh.RHHcodigo as cod, rhh.RHHdescripcion as descripcion
									,cc.RHCPid 
									,cc.RHCCid
									,cc.RHCCtipo
									,'Habilidades' as tipo
									,RHCCnotamin as nota
									,RHCCnotaobt as obt
									,'H' as tipoC
	"/>
	<cfinvokeargument name="desplegar" value="cod, descripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="rhpc.Ecodigo = #Session.Ecodigo# #filtro1# 
										  and rhcp.DEid = #form.DEid#
										  and rhpc.RHPid = rhp.RHPid
										  and rhhp.RHPcodigo = rhp.RHPpuesto
										  and rhh.RHHid =  rhhp.RHHid
										  and rhh.RHHid =  rhhp.RHHid 
										  and cc.RHCCid =* rhhp.RHHid 
										  and cc.RHCCid =* rhh.RHHid 
										  and cc.RHCPid =* rhcp.RHCPid 
										  and rhcp.RHPCid = rhpc.RHPCid 
										  and rhcp.Ecodigo = rhpc.Ecodigo
										  and rhhp.RHHid not in (select RHCCid from  RHCompetenciasConcursante 
										  						 where RHCPid = #Form.RHCPid#  and RHCCtipo = 'H')
										  union all
										  select rhc.RHCid as id, rhc.RHCcodigo as cod, rhc.RHCdescripcion as descripcion
											,cc.RHCPid 
											,cc.RHCCid
											,cc.RHCCtipo
											,'Conocimientos' as tipo
											,RHCCnotamin as nota
											,RHCCnotaobt as obt
											,'C' as tipoC
										  from RHPlazasConcurso rhpc
											 ,RHPlazas rhp
											 ,RHConocimientosPuesto rhcp
											 ,RHConocimientos rhc 
											 ,RHCompetenciasConcursante cc
											 ,RHConcursantesPlaza rhcpl 
											where rhcp.Ecodigo = #session.Ecodigo# 
										      #filtro2# 
											  and rhcpl.DEid = #form.DEid#
											  and rhpc.RHPid = rhp.RHPid
											  and rhcp.RHPcodigo = rhp.RHPpuesto
											  and rhc.RHCid = rhcp.RHCid
											  and cc.RHCCid =* rhcp.RHCid 
											  and cc.RHCCid =* rhc.RHCid 
											  and rhcpl.Ecodigo = rhpc.Ecodigo
											  and rhcpl.RHCPid *= cc.RHCPid
											  and rhcp.RHCid not in (select RHCCid from  RHCompetenciasConcursante
											  						 where RHCPid = #Form.RHCPid# and RHCCtipo = 'C')

																	 
											 order by 2, 3"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="Cortes" value="tipo"/>
	<cfinvokeargument name="irA" value="conlisCompetenciasConcursante.cfm"/>
	<cfinvokeargument name="formName" value="filtroCompetencias"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="id, descripcion, obt, cod, tipoC"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
			  
</body>
</html>