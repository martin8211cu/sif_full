<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, 
		   CPPtipoPeriodo, 
		   CPPfechaDesde, 
		   CPPfechaHasta, 
		   CPPfechaUltmodif, 
		   CPPestado,
		   ((case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end) #_Cat# ': ' #_Cat# 
		   <cf_dbfunction name="to_char" args="CPPfechaDesde" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat#
		   <cf_dbfunction name="to_char" args="CPPfechaHasta" datasource="#session.dsn#"> ) as Descripcion		   		   
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	and CPPestado = 1
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>
<cfif isdefined("Url.CPPid") and Len(Trim(Url.CPPid))>
	<cfparam name="Form.CPPid" default="#Url.CPPid#">
<cfelse>
	<cfparam name="Form.CPPid" default="-1">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid)) and Form.CPPid NEQ -1>
	<cfset filtro = filtro & " and a.CPPid = " & Form.CPPid>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & Form.CPPid>
</cfif>

<cfoutput>
<script language="javascript" type="text/javascript">
	function funcNuevo() {
		document.listaLiberacion.CPDEID.value = "";
	}
</script>

<form name="filtroAcciones" method="post" action="liberacion-lista.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr> 
    <td class="fileLabel">Per&iacute;odo del Presupuesto</td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cf_cboCPPid IncluirTodos="true" value="#Form.CPPid#" CPPestado="1">
	</td>
	<td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfquery name="rsListaQRY" datasource="#Session.DSN#">
			select 
				   a.CPDEid,
				   a.CPPid, 
				   a.CPDEfecha, 
				   a.CPDEfechaDocumento, 
				   a.CPDEtipoDocumento, 
				   a.CPDEnumeroDocumento, 
				   a.CPDEdescripcion, 
				   a.Usucodigo, 
					'Período de Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat# 
						case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
						#_Cat# ' a ' #_Cat# 
						case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				  as PeriodoPres,
				  rtrim(c.CFcodigo) as CFcodigo			
			from CPDocumentoE a, CPresupuestoPeriodo b, CFuncional c
			where a.Ecodigo = #Session.Ecodigo#
				 and a.CPDEtipoDocumento = 'L'
				 and a.Ecodigo = b.Ecodigo
				 and a.CPPid = b.CPPid
				 and a.CPDEaplicado = 0
				 <cf_CPSegUsu_where Reservas="true" aliasCF="a" name="CFidOrigen" soloCFs="true">
				<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid)) and Form.CPPid NEQ -1>
					and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & Form.CPPid>
				</cfif>				 
				 and a.Ecodigo = c.Ecodigo
				 and a.CFidOrigen = c.CFid
			order by b.CPPfechaHasta desc, a.CPDEnumeroDocumento
		</cfquery>
		
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="query" value="#rsListaQRY#"/>
		  <cfinvokeargument name="cortes" value="PeriodoPres"/>
		  <cfinvokeargument name="desplegar" value="CPDEnumeroDocumento, CPDEdescripcion, CPDEfechaDocumento, CFcodigo"/>
		  <cfinvokeargument name="etiquetas" value="No. Documento, Descripci&oacute;n, Fecha, Centro Funcional"/>
		  <cfinvokeargument name="formatos" value="V,V,D,S"/>
		  <cfinvokeargument name="align" value="left, left, center, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="formName" value="listaLiberacion"/>
		  <cfinvokeargument name="keys" value="CPDEid"/>
		  <cfinvokeargument name="botones" value="Nuevo"/>
		  <cfinvokeargument name="irA" value="liberacion.cfm"/>
		  <cfinvokeargument name="navegacion" value="#navegacion#"/>
		  <cfinvokeargument name="PageIndex" value="1"/>
	  </cfinvoke>		
	</td>
  </tr>
</table>
