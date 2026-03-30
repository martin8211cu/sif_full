<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset LvarCPformTipo = session.CPformTipo>
<cfif LvarCPformTipo EQ "registro" and isdefined("form.chkCancelados")>
	<cfset LvarCPformTipo = "cancelados">
</cfif>
<cfparam name="LvarTrasladoExterno" default="false">
<cfif LvarCPformTipo EQ "aprobacion">
	<cfset LvarTrasladoForm = ''>
	<cfset LvarWhereCPDEtipos = " in ('E','T')">
<cfelseif LvarTrasladoExterno>
	<cfset LvarTrasladoForm = 'E'>
	<cfset LvarWhereCPDEtipos = " = 'E'">
<cfelse>
	<cfset LvarTrasladoForm = ''>
	<cfset LvarWhereCPDEtipos = " = 'T'">
</cfif>

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
<cfif isdefined("Url.chkCancelados")>
	<cfset form.chkCancelados = 1>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid)) and Form.CPPid NEQ -1>
	<cfset filtro = filtro & " and a.CPPid = " & Form.CPPid>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & Form.CPPid>
</cfif>

<cfif isdefined("Form.chkCancelados")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "chkCancelados=1">
</cfif>

<cfoutput>
<script language="javascript" type="text/javascript">
	function funcNuevo() {
		document.listaTraslado.CPDEID.value = "";
		document.listaTraslado.TrasladoExterno.value = "<cfif LvarTrasladoExterno>1<cfelse>0</cfif>";
	}
</script>

<form name="filtroAcciones" method="post" action="traslado#LvarTrasladoForm#-#session.CPformTipo#-lista.cfm">
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
  <tr>
    <td>
<cfif LvarCPformTipo EQ "registro">
		<strong>Ver Cancelados:</strong><input type="checkbox" name="chkCancelados" onClick="this.form.submit();">
<cfelseif LvarCPformTipo EQ "cancelados">
		<strong>Ver Cancelados:</strong><input type="checkbox" name="chkCancelados" checked onClick="this.form.submit();">
</cfif>
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
				case 
					when a.CPDEtipoDocumento = 'T' then 'TRASLADOS DE PRESUPUESTO' 
					else 'ASIGNACION A DOCUMENTO DE AUTORIZACION EXTERNA' 
				end as tipo,
				   a.CPDEid,
				   a.CPPid, 
				   a.CPDEfecha, 
				   a.CPDEfechaDocumento, 
				   a.CPDEtipoDocumento, 
				   a.CPDEnumeroDocumento, 
				   a.CPDEdescripcion,
				   <cfif LvarTrasladoExterno>1<cfelse>0</cfif> as TrasladoExterno,
				   '<font color=''red''>' #_Cat# a.CPDEmsgRechazo #_Cat# '</font>' as CPDEmsgRechazo,
				   a.Usucodigo, 
				   (case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end) #_Cat# ': '
				   #_Cat# <cf_dbfunction name="to_char" args="b.CPPfechaDesde" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat# 
				   <cf_dbfunction name="to_char" args="b.CPPfechaHasta" datasource="#session.dsn#"> as PeriodoPres,
				   (select coalesce(sum(CPDDmonto), 0) from CPDocumentoD z where z.CPDDtipo = -1 and z.Ecodigo = a.Ecodigo and z.CPDEid = a.CPDEid) as MontoOrigen,
				   (select coalesce(sum(CPDDmonto), 0) from CPDocumentoD z where z.CPDDtipo = 1 and z.Ecodigo = a.Ecodigo and z.CPDEid = a.CPDEid) as MontoDestino
				<cfif LvarCPformTipo EQ "cancelados">
					, 1 as chkCancelados
				</cfif>
			from CPDocumentoE a, CPresupuestoPeriodo b
			where a.Ecodigo = #Session.Ecodigo#
			  and a.CPDEtipoDocumento #preserveSingleQuotes(LvarWhereCPDEtipos)#
			  and a.Ecodigo = b.Ecodigo
			  and a.CPPid = b.CPPid
			  and a.CPDEaplicado = 0
			<cfif LvarCPformTipo EQ "aprobacion">
			  and a.CPDEenAprobacion = 1
			  and a.CPDEestadoDAE = 0
			  and 
					(
						select count(1)
						  from CPDocumentoA c, CPSeguridadUsuario s
						 where c.CPDEid		= a.CPDEid
						   and c.UsucodigoAprueba is null
						   and s.Ecodigo	= #session.Ecodigo#
						   and s.CFid		= c.CFid
						   and s.Usucodigo	= #session.Usucodigo#
						   and s.CPSUaprobacion	= 1
					) > 0
			<cfelse>
				<cfif LvarCPformTipo EQ "cancelados">
				 and a.CPDErechazado = 1
				 and a.CPDEidRef is null
				<cfelse>
				 and a.CPDErechazado = 0
				 and a.CPDEenAprobacion = 0
				</cfif>
				<cf_CPSegUsu_where Traslados="true" aliasCF="a" name="CFidOrigen" soloCFs="true">
			</cfif>
			<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid)) and Form.CPPid NEQ -1>
					and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & Form.CPPid>
			</cfif>				
			order by a.CPPid, a.CPDEtipoDocumento
		</cfquery>

	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="query" value="#rsListaQRY#"/>
		  <cfinvokeargument name="cortes" value="PeriodoPres,Tipo"/>
		  <cfinvokeargument name="desplegar" value="CPDEnumeroDocumento, CPDEdescripcion, CPDEmsgRechazo, CPDEfechaDocumento, MontoOrigen, MontoDestino"/>
		<cfif isdefined("form.chkCancelados")>
			  <cfinvokeargument name="etiquetas" value="N&uacute;mero Documento, Descripci&oacute;n, Motivo Cancelación, Fecha, Total Origen, Total Destino"/>
		<cfelse>
			  <cfinvokeargument name="etiquetas" value="N&uacute;mero Documento, Descripci&oacute;n, Motivo Rechazo Anterior, Fecha, Total Origen, Total Destino"/>
		</cfif>			 
		  <cfinvokeargument name="formatos" value="V,V,V,D,M,M"/>
		  <cfinvokeargument name="align" value="left, left, left, center, right, right"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="formName" value="listaTraslado"/>
		  <cfinvokeargument name="keys" value="CPDEid"/>
		  <cfif LvarCPformTipo EQ "registro">
			  <cfinvokeargument name="botones" value="Nuevo"/>
		  </cfif>
		  <cfinvokeargument name="irA" value="traslado#LvarTrasladoForm#-#session.CPformTipo#-form.cfm"/>
		  <cfinvokeargument name="navegacion" value="#navegacion#"/>
		  <cfinvokeargument name="PageIndex" value="1"/>
	  </cfinvoke>
	</td>
  </tr>
</table>
