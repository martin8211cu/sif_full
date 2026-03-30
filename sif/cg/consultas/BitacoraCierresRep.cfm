<cfinvoke key="LB_Titulo" 			default="Consulta Bitácora de Cierres" 			returnvariable="LB_Titulo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="BitacoraCierresRep.xml"/>
<cfinvoke key="LB_Archivo" 			default="BitacoraCierres" 			returnvariable="LB_Archivo" component="sif.Componentes.Translate" 
method="Translate" xmlfile="BitacoraCierresRep.xml"/>
<cfinvoke key="LB_CierreContable" 			default="Cierre Contable" 			returnvariable="LB_CierreContable" 				component="sif.Componentes.Translate" method="Translate" xmlfile="BitacoraCierresRep.xml"/>
<cfinvoke key="LB_CierreAuxiliar" 			default="Cierre Auxiliar" 			returnvariable="LB_CierreAuxiliar" 				component="sif.Componentes.Translate" method="Translate" xmlfile="BitacoraCierresRep.xml"/>
<cfinvoke key="LB_Todos" 		default="Todos"			returnvariable="LB_Todos"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfif isdefined("Url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo>
</cfif>
<cfif isdefined("Url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes>
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo>
</cfif>

<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		case A.BCtipocierre
			when 1 then '#LB_CierreContable#'
			when 2 then '#LB_CierreAuxiliar#'
		end  as tipo,
		B.Usulogin as cedula,
		<cf_dbfunction name="concat" args="C.Pnombre,' ',C.Papellido1,' ',C.Papellido2"> as nombre,
		A.BCperiodo as periodo,
		case A.BCmes
			when 1 then '#CMB_Enero#'
			when 2 then '#CMB_Febrero#'
			when 3 then '#CMB_Marzo#'
			when 4 then '#CMB_Abril#'
			when 5 then '#CMB_Mayo#'
			when 6 then '#CMB_Junio#'
			when 7 then '#CMB_Julio#'
			when 8 then '#CMB_Agosto#'
			when 9 then '#CMB_Setiembre#'
			when 10 then '#CMB_Octubre#'
			when 11 then '#CMB_Noviembre#'
			when 12 then '#CMB_Diciembre#'
			end as mes,
		A.BCfcierre as fecha
		
	from BitacoraCierres A
		inner join Usuario B on A.Usucodigo = B.Usucodigo
		inner join DatosPersonales C on B.datos_personales = C.datos_personales
		
	where A.Ecodigo = #session.Ecodigo#
		<cfif form.periodo neq -1>
            and A.BCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
        </cfif>
    
        <cfif form.mes neq -1>
            and A.BCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
        </cfif>
    
        <cfif form.tipo neq -1>
            and A.BCtipocierre = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tipo#">
        </cfif>
	order by
		A.BCfcierre DESC
</cfquery>

<!--- Filtros --->

<cfset tipoD = "(#LB_Todos#)">
<cfset periodoD = "(#LB_Todos#)">
<cfset mesD = "(#LB_Todos#)">
<cfif form.tipo eq 1>
	<cfset tipoD = "#LB_CierreContable#">
<cfelseif form.tipo eq 2>
	<cfset tipoD = "#LB_CierreAuxiliar#">
</cfif>
<cfif form.periodo neq -1>
	<cfset periodoD = form.periodo>
</cfif>
<cfif form.mes neq -1>
	<cfswitch expression="#form.mes#">
		<cfcase value="1"><cfset mesD = "#CMB_Enero#"></cfcase>
		<cfcase value="2"><cfset mesD = "#CMB_Febrero#"></cfcase>
		<cfcase value="3"><cfset mesD = "#CMB_Marzo#"></cfcase>
		<cfcase value="4"><cfset mesD = "#CMB_Abril#"></cfcase>
		<cfcase value="5"><cfset mesD = "#CMB_Mayo#"></cfcase>
		<cfcase value="6"><cfset mesD = "#CMB_Junio#"></cfcase>
		<cfcase value="7"><cfset mesD = "#CMB_Julio#"></cfcase>
		<cfcase value="8"><cfset mesD = "#CMB_Agosto#"></cfcase>
		<cfcase value="9"><cfset mesD = "#CMB_Setiembre#"></cfcase>
		<cfcase value="10"><cfset mesD = "#CMB_Octubre#"></cfcase>
		<cfcase value="11"><cfset mesD = "#CMB_Noviembre#"></cfcase>
		<cfcase value="12"><cfset mesD = "#CMB_Diciembre#"></cfcase>
	</cfswitch>
</cfif>

<!--- Estilos --->
<style>
	H1.Corte_Pagina {
		PAGE-BREAK-AFTER: always
	}
</style>

<!--- Botones --->
<cfif not isdefined("url.toexcel")>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
		<cfoutput>
		<tr> 
			<td align="right" nowrap>
				<a href="javascript:regresar();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/back.gif"
					alt="Regresar"
					name="regresar"
					border="0" align="absmiddle">
				</a>				
				<a  href="javascript:imprimir();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/impresora.gif"
					alt="Imprimir"
					name="imprimir"
					border="0" align="absmiddle">
				</a>
				<a  id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Cfinclude.gif"
					alt="Salvar a Excel"
					name="SALVAEXCEL"
					border="0" align="absmiddle">
				</a>								
			</td>
		</tr>
		<tr><td><hr></td></tr>
		</cfoutput>
	</table>
</cfif>

<!--- Variables --->
<cfset MaxLineasReporte = 60> 	<!--- Máximo de líneas del reporte --->
<cfset nLnEncabezado = 9> 	  	<!--- Total de líneas del encabezado --->
<cfset nCols = 6> 				<!--- Total de columnas del encabezado --->

<!--- Llena el Encabezado --->
<cfsavecontent variable="encabezado">
	<cfoutput>
		<tr><td align="center" colspan="#nCols#"><H1 class=Corte_Pagina></H1></td></tr>
		<tr><td align="center" colspan="#nCols#"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="#nCols#"><font size="2"><strong><cf_translate key=LB_Titulo>Bit&aacute;cora de Cierres</cf_translate></strong></font></td></tr>
		<tr><td align="center" colspan="#nCols#"><strong><cf_translate key=LB_TipoCierre>Tipo de Cierre</cf_translate>: #tipoD#</strong></td></tr>				
		<tr><td align="center" colspan="#nCols#"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>: #periodoD#</strong></td></tr>						
		<tr><td align="center" colspan="#nCols#"><strong><cf_translate key=LB_Mes>Mes</cf_translate>: #mesD#</strong></td></tr>	
		<tr><td align="center" colspan="#nCols#"><hr></td></tr>
		<tr>
			<td width="5%" align="left" bgcolor="##CCCCCC"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong></td>			
			<td width="10%" align="left" bgcolor="##CCCCCC"><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>						
			<td width="15%" align="left" bgcolor="##CCCCCC"><strong><cf_translate key=LB_Tipo>Tipo</cf_translate></strong></td>						
			<td width="10%" align="left" bgcolor="##CCCCCC"><strong>Login</strong></td>
			<td width="35%" align="left" bgcolor="##CCCCCC"><strong><cf_translate key=LB_Nombre>Nombre</cf_translate></strong></td>			
			<td width="15%" align="left" bgcolor="##CCCCCC"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate></strong></td>	
		</tr>
		<tr><td align="center" colspan="#nCols#"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<!--- Llena el Detalle --->
<cfsavecontent variable="detalle">
	<cfoutput>
		<cfif rsReporte.recordcount gt 0>
			<cfset contador = nLnEncabezado>
			<cfloop query="rsReporte">			

				<cfif contador gte MaxLineasReporte>
					<tr class="Corte_Pagina"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
					#encabezado#
					<cfset contador = nLnEncabezado>
				</cfif>

				<tr>
					<td align="left"><font size="1">#rsReporte.periodo#</font></td>
					<td align="left"><font size="1">#rsReporte.mes#</font></td>
					<td align="left"><font size="1">#rsReporte.tipo#</font></td>
					<td align="left"><font size="1">#rsReporte.cedula#</font></td>
					<td align="left"><font size="1">#rsReporte.nombre#</font></td>
					<td align="left"><font size="1">#rsReporte.fecha#</font></td>																									
				</tr>
				<cfset contador = contador + 1>
			</cfloop>
		<cfelse>
			<tr><td align="center" colspan="#nCols#">&nbsp;</td></tr>
			<tr><td align="center" colspan="#nCols#"><strong> --- <cf_translate key=LB_Consulta>La consulta no gener&oacute; ning&uacute;n resultado</cf_translate> --- </strong></td></tr>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Forma el Reporte  --->
<cfsavecontent variable="reporte">
<cfoutput>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
		#encabezado#
		#detalle#
		<tr><td align="center" colspan="#nCols#">&nbsp;</td></tr>
		<tr><td colspan="#nCols#" nowrap align="center"><strong> --- <cf_translate  key=LB_FinConsulta>Fin de la Consulta</cf_translate> --- </strong></td></tr>
	</table>
</cfoutput>
</cfsavecontent>

<!--- Pinta el Reporte --->
<cfoutput>

<cfif isdefined("url.toexcel")>
	<cfcontent type="application/vnd.ms-excel">
	<cfheader 	name="Content-Disposition" 
				value="attachment;filename=#LB_Archivo#_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	#reporte#
</table>
</cfoutput>


<iframe src="" id="prueba" style="visibility:hidden" width="0" height="0"></iframe>

<!--- Manejo de los Botones --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		history.back();
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}

	function SALVAEXCEL() {
		<cfset params = 'toexcel=1' >

		<cfif isdefined("form.periodo")>
			<cfset params = params & "&periodo=#form.periodo#" >
		</cfif>
		<cfif isdefined("form.mes")>
			<cfset params = params & "&mes=#form.mes#" >
		</cfif>
		<cfif isdefined("form.tipo")>
			<cfset params = params & "&tipo=#form.tipo#" >	
		</cfif>

		var ira = '?<cfoutput>#jsstringformat(params)#</cfoutput>';
		document.getElementById("prueba").src="BitacoraCierresRep.cfm" + ira;


	}	

	
	
</script>