<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_GenerarEvaluadoresEItemsParaEsteEmpleado"
		default="Generar evaluadores e items para este empleado!"
		returnvariable="MSG_GenerarEvaluadoresEItemsParaEsteEmpleado"/>
		
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>

<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.fRHPcodigo") and not isdefined("Form.fRHPcodigo")>
	<cfparam name="Form.fRHPcodigo" default="#Url.fRHPcodigo#">
</cfif>
<cfif isdefined("Url.chkVaciios") and not isdefined("Form.chkVaciios")>
	<cfparam name="Form.chkVaciios" default="#Url.chkVaciios#">
</cfif>
<cfif isdefined("Url.Estado") and not isdefined("Form.Estado")>
	<cfparam name="Form.Estado" default="#Url.Estado#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif not isdefined('url.SEL')>
	<cfset navegacion = navegacion & "&SEL=3">
</cfif>
<cfset navegacion = navegacion & "&RHEEid=" & Form.RHEEid>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEidentificacion) like '%" & UCase(Form.FDEidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ', ' #_Cat# b.DEnombre) like '%" & UCase(Form.FDEnombre) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHPcodigo) like '%" & UCase(Form.fRHPcodigo) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & Form.fRHPcodigo>
</cfif>
<cfif isdefined("Form.chkVaciios") and Len(Trim(Form.chkVaciios)) NEQ 0>
 	<cfset filtro = filtro & " and (select count(1) from RHNotasEvalDes where RHNotasEvalDes.RHEEid = a.RHEEid and RHNotasEvalDes.DEid = b.DEid) = 0">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "chkVaciios=" & Form.chkVaciios>
</cfif>
<cfoutput>
<form name="form1" method="post" action="registro_evaluacion.cfm">
<input type="hidden" name="SEL" value="#FORM.SEL#">
<input type="hidden" name="RHEEid" value="#FORM.RHEEid#">

<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td width="" align="right"><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</td>
    <td width="">
		</cfoutput><!--- Se cierra por el TAG, y se vuelve a abrir mas abajo --->
		<cfif isdefined("Form.fRHPcodigo") and len(trim(Form.fRHPcodigo)) gt 0>
			<cfquery name="rsPuesto" datasource="#session.dsn#">
				select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo as fRHPcodigo, RHPdescpuesto
				from RHPuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fRHPcodigo#">
			</cfquery>
			<cf_rhpuesto query="#rsPuesto#" name="fRHPcodigo" size="20" tabindex="1">
		<cfelse>
		<cf_rhpuesto name="fRHPcodigo" size="20" tabindex="1">
		</cfif>
		<cfoutput>
	</td>
	<td align="right"><cf_translate key="LB_Avance">Avance</cf_translate>:</td>
	<td>
		<select name="Estado" id="Estado">
            <option value="">- <cf_translate key="LB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate> -</option>
            <option value="1" <cfif isdefined("form.Estado") and len(trim(form.Estado)) and form.Estado EQ 1>selected</cfif>><cf_translate key="LB_Listo">Listo</cf_translate></option>
			<option value="0" <cfif isdefined("form.Estado") and len(trim(form.Estado)) and form.Estado EQ 0>selected</cfif>><cf_translate key="LB_Pendiente">Pendiente</cf_translate></option> 
			<option value="2" <cfif isdefined("form.Estado") and len(trim(form.Estado)) and form.Estado EQ 2>selected</cfif>><cf_translate key="LB_Parcial">Parcial</cf_translate></option>        
        </select>
	</td>
  </tr>
  <tr>
    <td width="" align="right"><cf_translate key="LB_Identificacion" XmlFile="/rh/generales.xml">Identificaci&oacute;n</cf_translate>:</td>
    <td width="">
        <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>" tabindex="1">
	</td>
    <td width="" align="right"><cf_translate key="LB_Nombre" XmlFile="/rh/generales.xml">Nombre</cf_translate>:</td>
    <td width=""> 
		<input name="FDEnombre" type="text" id="FDEnombre" size="30" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>" tabindex="1">
	</td>
  </tr>
  <tr><td align="right" valign="top" ><input type="checkbox" name="chkVaciios" <cfif isdefined("Form.chkVaciios")>checked</cfif> tabindex="1"></td>
	  <td colspan="6" ><cf_translate key="CHK_MostrarSoloEmpleadosCuyoPuestoNoTieneItemsParaEvaluar">Mostrar solo empleados cuyo puesto no tiene items para evaluar</cf_translate>.</td>  
  </tr>

<tr>
    <td colspan="7" width="" align="center" style="vertical-align:middle ">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="BTN_Filtrar"
			default="Filtrar"
			xmlfile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>
	
      <input name="btnBuscar" class="btnFiltrar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
    </td>

</tr>
<tr>
	<td colspan="6" align="left" valign="top" ><input type="checkbox" onchange="funcMarcar(this.checked)" name="chkTodos" <cfif isdefined("Form.chkTodos")>checked</cfif> tabindex="1">
	Seleccionar todos.</td>  
</tr>
</table>
</form>
</cfoutput>
<cfif FORM.SEL eq 3>
	<cfsavecontent variable="EVAL_RIGHT">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
			<tr>
				<td><img src="/cfmx/rh/imagenes/Excl32.gif"> </td>
				<td>
					<cf_translate key="MSG_IndicaQueParaEsteEmpleqadoNoSeHaPodidoGenerarNingunItem">Indica que 
					para este empleado no se ha podido generar ningún item</cf_translate>, </td>
					</tr><tr>
				<td colspan="2">
					<cf_translate key="MSG_EstoPorqueParaElPuestoEnQueSeEncuentraNoExistenItemsNiPorHbilidadNiPorConocimiento">esto porque para el puesto en 
					que se encuentra, no existen items, ni por habilidad, ni por 
					conocimiento. Si hace click sobre el ícono, el sistema 
					intentará generar nuevamente los items para este empleado,
					o bien, puede marcar varios, y precionar el botón Generar,
					que se encuentra en la sección de botones(abajo).
					</cf_translate>
					</td>
			</td>
		  </tr>
		</table>
	</cfsavecontent>
	
		
	<cfset desplegar = ", cantEmpl">
	<cfset etiquetas = ", ">
	<cfset formatos = ", S">
	<cfset align = ", left">
<cfelse>
	<cfset cantEmpl = "">
	<cfset desplegar = "">
	<cfset etiquetas = "">
	<cfset formatos = "">
	<cfset align = "">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_RegistrarObservacionesParaEsteEmpleado"
	default="Registrar observaciones para este empleado!"
	returnvariable="MSG_RegistrarObservacionesParaEsteEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_EmpleadoConObservacionesRegistradas"
	default="Empleado con observaciones registradas!"
	returnvariable="MSG_EmpleadoConObservacionesRegistradas"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Listo"
	default="Listo"
	returnvariable="MSG_Listo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Parcial"
	default="Parcial"
	returnvariable="MSG_Parcial"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Pendiente"
	default="Pendiente"
	returnvariable="MSG_Pendiente"/>	
	
	
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_GenerarEvaluadoresEItemsParaEsteEmpleado"
		Default="Generar evaluadores e items para este empleado!"
		returnvariable="MSG_GenerarEvaluadoresEItemsParaEsteEmpleado"/>		

	
	
<cf_dbfunction name='to_char' args='RHLEobservacion' returnvariable="obs">	
<cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="vRHEEid">	
<cf_dbfunction name="to_char" args="b.DEid" returnvariable="vDEid">	


<cfset iconoObs2 = ", imagen = ''">
<cfset lvar = 1>
<cfquery name="rsPCid" datasource="#session.DSN#">
	select PCid 
	from RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
</cfquery>
<cfif rsPCid.recordcount gt 0>
	<cfset lvar = rsPCid.PCid >
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">
	select 
    		coalesce(RHLEnotajefe,0) as RHLEnotajefe, 
			coalesce(RHLEnotaauto,0) as RHLEnotaauto, 
			coalesce(RHLEpromotros,0) as RHLEpromotros,
			a.RHEEid, 
			b.DEid, 
			b.DEidentificacion, 
 			<cf_dbfunction name="concat" args="'<a href=''javascript: reporte('|#vRHEEid#|','|#vDEid#|');''><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=''0''></a>'" delimiters="|"> as imprimir,
			<cf_dbfunction name="concat" args="b.DEapellido1,'  ',b.DEapellido2, ' ', b.DEnombre"> as NombreCompleto,
			<cf_dbfunction name="concat" args="coalesce(c.RHPcodigoext,c.RHPcodigo)|' - '|c.RHPdescpuesto"delimiters="|">as RHPdescpuesto, 
			4 as SEL, 
			0 as BTNELIMINAR, 
			1 as BtnGenerarEmpl,			
			0 as BtnGenerarEmpls , 
			case when  <cf_dbfunction name="length" args="#obs#">  > 0
			then 
				<cf_dbfunction name="concat" args="'<a href=''javascript: funcObs('|#vRHEEid#|','|#vDEid#|');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" delimiters="|">
			else 
				<cf_dbfunction name="concat" args="'<a href=''javascript: funcObs('|#vRHEEid#|','|#vDEid#|');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" delimiters="|">
			end as imagen,
 			case when (select count(1) from RHNotasEvalDes where RHNotasEvalDes.RHEEid = a.RHEEid and RHNotasEvalDes.DEid = b.DEid) = 0  and #lvar# <= 0
			then 
			<cf_dbfunction name="concat" args="'<a href=''##'' onClick=''javascript:funcGenerar('|#vDEid#|');''><img alt=''|#MSG_GenerarEvaluadoresEItemsParaEsteEmpleado#|'' border=''0'' src=''/cfmx/rh/imagenes/Excl16.gif''></a>'" delimiters="|">
			else '' 
			end as cantEmpl,
			case when((select coalesce(count(z.Estado),0)
							from RHEvaluadoresDes z 
							where z.RHEEid = a.RHEEid 
							and z.DEid = a.DEid ) 
						  =
					  (select count(z.Estado)
							from RHEvaluadoresDes z 
							where z.RHEEid = a.RHEEid 
							and z.DEid = a.DEid 
								and z.Estado = 0
							))
				then '#MSG_Pendiente#'
				else
				case when (select coalesce(count(z.Estado),0)
							from RHEvaluadoresDes z 
							where z.RHEEid = a.RHEEid 
							and z.DEid = a.DEid)
						   =
						  (select count(z.Estado)
								from RHEvaluadoresDes z 
								where z.RHEEid = a.RHEEid 
								and z.DEid = a.DEid 
								and z.Estado = 1
							)
				then '#MSG_Listo#'
				else'#MSG_Parcial#'    
				end
			end as completo 
	from 	RHListaEvalDes a, DatosEmpleado  b, RHPuestos c
	where 	a.Ecodigo = #Session.Ecodigo#
			and RHEEid = #form.RHEEid#
			and a.DEid = b.DEid
			and a.Ecodigo = c.Ecodigo
			and a.RHPcodigo = c.RHPcodigo
			<cfif isdefined("form.Estado") and len(trim(form.Estado))>
				<cfif form.Estado EQ 2><!----Estado Parcial---->
						and (select count(1)
							from RHEvaluadoresDes x
							where x.RHEEid = a.RHEEid 
								and x.DEid = a.DEid		
								and a.RHEEid = #form.RHEEid#) 
							<> 
							(select count(1)
							from RHEvaluadoresDes x
							where x.RHEEid = a.RHEEid 
								and x.DEid = a.DEid		
								and a.RHEEid = #form.RHEEid#
								and x.Estado =0
							)
							and (select count(1)
							from RHEvaluadoresDes x
							where x.RHEEid = a.RHEEid 
								and x.DEid = a.DEid		
								and a.RHEEid = #form.RHEEid#
								and x.Estado = 0
							) <> 0
				<cfelse><!---Estados: Listo o Pendiente----->
					and (select count(1)
						from RHEvaluadoresDes x
						where x.RHEEid = a.RHEEid 
							and x.DEid = a.DEid		
							and a.RHEEid = #form.RHEEid#) 
						= 
						(select count(1)
						from RHEvaluadoresDes x
						where x.RHEEid = a.RHEEid 
							and x.DEid = a.DEid		
							and a.RHEEid = #form.RHEEid#
							<cfif form.Estado EQ 0>
								and x.Estado = 0
							<cfelse>
								and x.Estado = 1
							</cfif>)
				</cfif>
			</cfif>	
			#preservesinglequotes(filtro)#
	order by c.RHPcodigo, c.RHPdescpuesto, b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre
</cfquery>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Identificacion"
	default="Identificación"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_NombreCompleto"
	default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Avance"
	default="Avance"
	returnvariable="LB_Avance"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Jefe"
	default="Jefe"
	returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Auto"
	default="Auto."
	returnvariable="LB_Auto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Otros"
	default="Otros"
	returnvariable="LB_Otros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_NOSEHANAGREGADOEMPLEADOSAEVALUARPARAESTARELACION"
	default="NO SE HAN AGREGADO EMPLEADOS A EVALUAR PARA ESTA RELACION"
	returnvariable="MSG_NOSEHANAGREGADOEMPLEADOSAEVALUARPARAESTARELACION"/>
<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto,completo, RHLEnotajefe, RHLEnotaauto, RHLEpromotros, imagen #desplegar# "/>
	<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#, #LB_Avance#, #LB_Jefe#, #LB_Auto#, #LB_Otros#, #etiquetas#"/>
	<cfinvokeargument name="cortes" value="RHPdescpuesto"/>
	<cfinvokeargument name="formatos" value="S,S,S,M,M,M, #formatos#"/>
	<cfinvokeargument name="align" value="left, left, center, right, right, right,center #align#"/>
	<cfinvokeargument name="ajustar" value=""/>	
	<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
	<cfinvokeargument name="incluyeForm" value="true"/>
	<cfinvokeargument name="MaxRows" value="50"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="showLink" value="false"/>
	<cfinvokeargument name="checkboxes" value=	"S"/>
	<cfinvokeargument name="keys" value="DEid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="EmptyListMsg" value="***#MSG_NOSEHANAGREGADOEMPLEADOSAEVALUARPARAESTARELACION#***"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<!---<cfinvokeargument name="filtrar_automatico" value="true"/>
	<cfinvokeargument name="mostrar_filtro" value="true"/>
	<cfinvokeargument name="filtrar_por" value="">--->
</cfinvoke>

<script language="javascript" type="text/javascript">
	var f = document.form1;
//	f.fRHPcodigo.focus();
	
	function funcObs(id,empl){
		document.formX.RHEEid.value=id;
		document.formX.DEid.value=empl;
		document.formX.submit();

	}
	
		function funcMarcar(m)
		{
			if (m==false){
				var form = document.listaEmpleados;						
						if (form.chk.length)
							{
								for (var i=0; i<form.chk.length; i++)
									{
									form.chk[i].checked=false
									}
							}
			}
			
			if (m==true)
				{
					var form = document.listaEmpleados;
						if (form.chk.length)
							{
								for (var i=0; i<form.chk.length; i++)
									{
									form.chk[i].checked=true
									}
							}
	
					}
		
		}
	

</script>
<cfoutput>
    <form action="registro_evaluacion.cfm" method="post" name="formX">
        <input type="hidden" name="DEid" value="">
        <input type="hidden" name="RHEEid" value="">
        <input type="hidden" name="sel" value="4">
    </form>	
</cfoutput>