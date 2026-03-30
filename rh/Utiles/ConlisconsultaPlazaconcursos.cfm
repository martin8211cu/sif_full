<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,id) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.id#.value = id;
		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}

</script>
<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.RHCconcurso") and not isdefined("Form.RHCconcurso")>
	<cfparam name="Form.RHCconcurso" default="#Url.RHCconcurso#">
</cfif>

<cfif isdefined("Url.RHCcodigo") and not isdefined("Form.RHCcodigo")>
	<cfparam name="Form.RHCcodigo" default="#Url.RHCcodigo#">
</cfif>

<cfif isdefined("Url.RHPpuesto") and not isdefined("Form.RHPpuesto")>
	<cfparam name="Form.RHPpuesto" default="#Url.RHPpuesto#">
</cfif>

<cfif isdefined("Url.RHPdescpuesto") and not isdefined("Form.RHPdescpuesto")>
	<cfparam name="Form.RHPdescpuesto" default="#Url.RHPdescpuesto#">
</cfif>

<cfif isdefined("Url.CFid") and not isdefined("Form.CFid")>
	<cfparam name="Form.CFid" default="#Url.CFid#">
</cfif>

<cfif isdefined("Url.CFdescripcion") and not isdefined("Form.CFdescripcion")>
	<cfparam name="Form.CFdescripcion" default="#Url.CFdescripcion#">
</cfif>

<!--- <cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif> --->

<cfif isdefined("Url.RHCcantplazas") and not isdefined("Form.RHCcantplazas")>
	<cfparam name="Form.RHCcantplazas" default="#Url.RHCcantplazas#">
</cfif>

<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfquery name="rsAsignada" datasource="#session.DSN#">
	select distinct pl.*, lt.LTporcplaza
	from LineaTiempo lt, RHPlazas pl, RHPuestos pu
	where pl.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPpuesto#">
	  and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#"> 
	  and lt.RHPid = pl.RHPid
	  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and lt.Ecodigo = pu.Ecodigo
	  and lt.RHPcodigo = pu.RHPcodigo
	  and getdate() between lt.LTdesde and lt.LThasta
</cfquery>


<cfquery name="rsNOAsignada" datasource="#session.DSN#">
	select distinct pl.RHPid from RHPlazas pl
	where pl.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPpuesto#">
	  and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
	  and pl.RHPactiva = 1
	  and pl.RHPid not in (
		select distinct pl2.RHPid
		from LineaTiempo lt, RHPlazas pl2, RHPuestos pu
		where pl2.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPpuesto#">
		  and pl2.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
		  and lt.RHPid = pl2.RHPid
		  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
		  and lt.Ecodigo = pu.Ecodigo
		  and lt.RHPcodigo = pu.RHPcodigo
		  and getdate() between lt.LTdesde and lt.LThasta
	)
</cfquery>

<cfquery name="rsEstadoPuesto" datasource="#session.DSN#">
	select RHPactivo,RHPcodigo 
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and coalesce(RHPcodigoext,RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPpuesto#">
</cfquery>



<cfif rsEstadoPuesto.RHPactivo EQ 1>
	<cfset estadopuesto= 'Activo'>
<cfelseif rsEstadoPuesto.RHPactivo EQ 0>
	<cfset estadopuesto= 'Inactivo'>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>

<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid)) NEQ 0>
	<cfset filtro = filtro & " and CFid = #Form.CFid#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFid=" & Form.CFid>
</cfif>
 <cfif isdefined("Form.RHPpuesto") and Len(Trim(Form.RHPpuesto)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHPpuesto) like '%" & #UCase(rsEstadoPuesto.RHPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPpuesto=" & Form.RHPpuesto>
</cfif> 

<cfset filtro = filtro & " and RHPactiva = 1">

<html>
<head>
<title>Consulta de Plazas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset vparams = "&sel=1" >
<cfif isdefined("form.RHCconcurso")>
	<cfset vparams = vparams & "&RHCconcurso=" & form.RHCconcurso>
</cfif>
<cfif isdefined("form.RHCcodigo")>
	<cfset vparams = vparams & "&RHCcodigo=" & form.RHCcodigo>
</cfif>
<cfif isdefined("form.RHPpuesto")>
	<cfset vparams = vparams & "&RHPpuesto=" & form.RHPpuesto>
</cfif>
<cfif isdefined("form.RHPdescpuesto")>
	<cfset vparams = vparams & "&RHPdescpuesto=" & form.RHPdescpuesto>
</cfif>
<cfif isdefined("form.CFid")>
	<cfset vparams = vparams & "&CFid=" & form.CFid>
</cfif>
<cfif isdefined("form.CFdescripcion")>
	<cfset vparams = vparams & "&CFdescripcion=" & form.CFdescripcion>
</cfif>
<cfif isdefined("form.RHPcodigo")>
	<cfset vparams = vparams & "&RHPcodigo=" & form.RHPcodigo>
</cfif>
<cfif isdefined("form.RHCcantplazas")>
	<cfset vparams = vparams & "&RHCcantplazas=" & form.RHCcantplazas>
</cfif>
<cfif isdefined("url.form")>
	<cfset vparams = vparams & "&form=" & url.form>
</cfif>
<cfset vparams = vparams & "&name=" & url.name & "&desc=" & url.desc & "&id=" & url.id & "&conexion=" & url.conexion>

<cfoutput>
<form name="filtroEmpleado" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" >
	<tr>
		<td align="right"><cf_rhimprime datos="/rh/Utiles/ConlisconsultaPlazaconcursos.cfm" paramsuri="#vparams#"></td>
	</tr>
	<!--- <cf_rhimprime datos="/rh/expediente/consultas/TipoAccionEmpleado-detalle.cfm" paramsuri="#vparams#"> --->
	<tr>
		<td align="left"><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>: #form.CFdescripcion# </strong></td>
	</tr>
	<tr>		
		<td align="left"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>: #form.RHPpuesto# - #form.RHPdescpuesto#</strong></td>
	</tr>
	<tr>		
		<td align="left"><strong><cf_translate key="LB_EstadoDelPuesto">Estado del puesto</cf_translate>: #estadopuesto#</strong></td>
	</tr>
</table>
</form>
</cfoutput>
<table width="98%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="3">
		 <!--- <cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaConcursos#"/>
				<cfinvokeargument name="desplegar" value="concurso,  RHPcodigo, RHPdescpuesto"/>
				<cfinvokeargument name="etiquetas" value="N&ordm;. Solicitud - Concurso, C&oacute;digo de Puesto, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S, S, S"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="keys" value="RHCconcurso"/> 
				<cfinvokeargument name="showEmptyListMsg" value= "1"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="botones" value="Nuevo, Eliminar"/>
				<cfinvokeargument name="irA" value= "#ir#"/>
		</cfinvoke> --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="C&oacute;digo"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DescripcionDeLaPlaza"
				Default="Descripci&oacute;n de la Plaza"
				returnvariable="LB_DescripcionDeLaPlaza"/>	
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NoSeEncontraronPlazasEnElCentrofuncional"
				Default="No se encontraron Plazas en el Centro funcional"
				returnvariable="MSG_NoSeEncontraronPlazasEnElCentrofuncional"/>	
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ParaElPuesto"
				Default="para el puesto"
				returnvariable="MSG_ParaElPuesto"/>	
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="RHPlazas"/>
				<cfinvokeargument name="columnas" value="RHPid, CFid, RHPcodigo, RHPpuesto, RHPdescripcion	"/>
				<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_DescripcionDeLaPlaza#"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro# order by 2"/> <!--- analizar--->
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<!--- <cfinvokeargument name="irA" value="ConlisconsultaPlazaconcursos.cfm"/> --->
				<cfinvokeargument name="formName" value="form1"/> <!--- analizar--->
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="showLink" value="false"/>
				<!--- <cfinvokeargument name="funcion" value="Asignar"/> 
				<cfinvokeargument name="fparams" value="RHPcodigo, RHPdescripcion, RHPid"/>  --->
				<!--- <cfinvokeargument name="navegacion" value="#navegacion#"/> --->
				<cfinvokeargument name="Conexion" value="#url.conexion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="1">
				<cfinvokeargument name="EmptyListMsg" value="--- #MSG_NoSeEncontraronPlazasEnElCentrofuncional#: #Form.CFdescripcion#, #MSG_ParaElPuesto#: #Form.RHPpuesto# ---"/>
			</cfinvoke>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		
		<td width="55%" align="right">
		<fieldset><legend><cf_translate key="LB_ResumenPlaza">Resumen Plaza</cf_translate>:</legend>
		<cfoutput>
		<table width="100%" align="right" cellspacing="0" cellpadding="2" border="0">
			<!--- <tr>
				<td><strong>Plazas&nbsp;vigentes:</strong>&nbsp;???</td>	
			</tr> --->
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><strong><cf_translate key="LB_Concurso">Concurso</cf_translate>:</strong>&nbsp;#form.RHCcodigo#</td>
			</tr>
			<tr>
				<td><strong><cf_translate key="LB_CantidadDePlazasSolicitadasEnElConcurso">Cantidad de plazas solicitadas en el concurso</cf_translate>:</strong>&nbsp;#form.RHCcantplazas#</td>
			</tr>
			<tr>
				<td><strong><cf_translate key="LB_CantidadDePlazasDisponibles">Cantidad de plazas disponibles</cf_translate>:</strong>&nbsp; #rsNOAsignada.recordcount#</td>
			</tr>
			<tr>
				<td><strong><cf_translate key="LB_CantidadDePlazasUtilizadas">Cantidad de plazas utilizadas</cf_translate>:</strong>&nbsp;#rsAsignada.recordcount#</td>
			</tr>
				<cfset vplazas = #rsAsignada.recordcount# + #rsNOAsignada.recordcount#>
				<cfif vplazas EQ 0>
					<cfset porc = 0>
				<cfelse>
					<cfset porc = (#rsAsignada.recordcount# / #vplazas#) * 100>
				</cfif>
				
			<tr>
				<td><strong><cf_translate key="LB_PorcentajeDeUtilizacion">Porcentaje&nbsp;de&nbsp;utilizaci&oacute;n</cf_translate>:</strong>&nbsp;#DecimalFormat(porc)#&nbsp;%</td>	
			</tr>
		</table>
		</cfoutput>
		</fieldset>
		</td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<cfif isdefined('url.imprimir')>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr > 
			<td colspan="12" align="center">
				<strong>
				------------------------------
				<cf_translate key="LB_FinDeLaConsulta">Fin de la Consulta</cf_translate>
				--------------------------------------
				</strong>	&nbsp;
			</td>
		</tr>
	</cfif>	

</table>


</body>
</html>