<cfinclude template="/sif/Utiles/sifConcat.cfm">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PDOC" Default = "Per&iacute;odo del Presupuesto"  XmlFile="liberacionContratos.xml" returnvariable="LB_PDOC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoCont" Default = "Numero de contrato:&nbsp;"  XmlFile="liberacionContratos.xml" returnvariable="LB_NoCont"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FINC" Default = "Fecha de inicio de vigencia:&nbsp;"  XmlFile="liberacionContratos.xml" returnvariable="LB_FINC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_F" Default = "Fecha"  XmlFile="liberacionContratos.xml" returnvariable="LB_F"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FFVig" Default = "Fecha de fin de vigencia:&nbsp;"  XmlFile="liberacionContratos.xml" returnvariable="LB_FFVig"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pvdr" Default = "Proveedor"  XmlFile="liberacionContratos.xml" returnvariable="LB_Pvdr"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cto" Default = "Contrato"  XmlFile="liberacionContratos.xml" returnvariable="LB_Cto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DCto" Default = "Descripci&oacute;n del Contrato"  XmlFile="liberacionContratos.xml" returnvariable="LB_DCto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MCto" Default = "Monto Contrato"  XmlFile="liberacionContratos.xml" returnvariable="LB_MCto"/>


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
<!--- <cf_dump var = "#rsPeriodos#"> --->
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

<form name="form1" method="post" action="LiberacionContratos.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr>
    <td class="fileLabel">#LB_PDOC#</td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cf_cboCPPid IncluirTodos="true" value="#Form.CPPid#" CPPestado="1">
	</td>
	<td></td>
	<td></td>
	<td></td>
	<td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
  </tr>

  <tr><td><p>&nbsp;</p></td></tr>

  <tr>
  	<td>#LB_NoCont#
        <input  name="CTCnumContrato" type="text" tabindex="1"  value="" size="30" maxlength="30">
		<div align="right"></div>
  	</td>

  	<td align="right" nowrap>#LB_FINC#</td>
    <td>
        <cf_sifcalendario name="fechaInicio" value="" form="form1" tabindex="1">
    </td>

    <td align="right" nowrap>&nbsp;&nbsp;#LB_F#:&nbsp;&nbsp;</td>
    <td>
        <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fecha" value="">
     </td>
  </tr>

  <tr>
  	<td></td>
  	<td align="right" nowrap>#LB_FFVig#</td>
    <td>
        <cf_sifcalendario name="fechaFin" value="" form="form1"  tabindex="1">
    </td>

   <td>&nbsp;&nbsp;#LB_Pvdr#:&nbsp;&nbsp;</td>
    <td>
		<cf_sifsociosnegocios2 name="proveedor" sntiposocio="P" tabindex="1" Ecodigo="#session.Ecodigo#" form="form1">
	</td>
  </tr>

</table>
</form>
</cfoutput>

<cfif isdefined("form.SNcodigo") and form.SNcodigo neq "">
	<cfquery name="rsProveedor" datasource="#Session.DSN#">
		select SNid
		from SNegocios
		where SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
</cfif>

<cfif isdefined("form.fecha") and form.fecha neq "">
	<cfset fecha = LSDateFormat(form.fecha,'yyyy-mm-dd') & ' 00:00:00.000'>
</cfif>

<cfif isdefined("form.fechaInicio") and form.fechaInicio neq "">
	<cfset fechaInicio = LSDateFormat(form.fechaInicio,'yyyy-mm-dd') & ' 00:00:00.000'>
</cfif>

<cfif isdefined("form.fechaFin") and form.fechaFin neq "">
	<cfset fechaFin = LSDateFormat(form.fechaFin,'yyyy-mm-dd') & ' 00:00:00.000'>
</cfif>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfquery name="rsListaQRY" datasource="#Session.DSN#">
			select
				   a.CPPid,
				   a.CTContid,
				   a.CTCnumContrato,
				   a.CTCdescripcion,
				   a.CTfecha,
					'Presupuesto ' #_Cat#
						case #rsPeriodos.CPPtipoPeriodo# when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat#
						case {fn month('#rsPeriodos.CPPfechaDesde#')} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year('#rsPeriodos.CPPfechaDesde#')}">
						#_Cat# ' a ' #_Cat#
						case {fn month('#rsPeriodos.CPPfechaHasta#')} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year('#rsPeriodos.CPPfechaHasta#')}">
				  as PeriodoPres, s.SNnombre, a.CTmonto
			from CTContrato  a
				left join CTDetContrato b
				on a.CTContid = b.CTContid
				left join SNegocios s
				on s.SNid = a.SNid
				inner join CPresupuestoPeriodo cp
				on cp.CPPid = a.CPPid
			where a.Ecodigo = #Session.Ecodigo#
			and (b.CTDCmontoTotal - b.CTDCmontoConsumido) > 0
			and CTCestatus BETWEEN 1 AND 2
				<cfif isdefined("form.btnBuscar") and form.btnBuscar eq "Filtrar">
				 	<cfif isdefined("form.CPPid") and form.CPPid neq "" and form.CPPid neq -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				 	</cfif>
				 	<cfif isdefined("form.CTCnumContrato") and form.CTCnumContrato neq "">
			and a.CTCnumContrato like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.CTCnumContrato#%">
				 	</cfif>
				 	<cfif isdefined("fechaInicio") and fechaInicio neq "">
			and a.CTfechaIniVig >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicio#">
				 	</cfif>
				 	<cfif isdefined("fechaFin") and fechaFin neq "">
			and a.CTfechaFinVig <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaFin#">
					</cfif>
				 	<cfif isdefined("fecha") and fecha neq "">
			and a.CTfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
				 	</cfif>
				 	<cfif isdefined("rsProveedor.SNid") and rsProveedor.SNid neq "">
			and a.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProveedor.SNid#">
				 	</cfif>
				 </cfif>
			group by a.CPPid,
				   a.CTContid,
				   a.CTCnumContrato,
				   a.CTCdescripcion,
				   a.CTfecha,
				   s.SNnombre, a.CTmonto
			order by a.CTfecha desc, a.CTCnumContrato
		</cfquery>

	  <cfinvoke
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="query" value="#rsListaQRY#"/>
		  <cfinvokeargument name="desplegar" value="CTCnumContrato, CTCdescripcion,SNnombre, CTfecha,CTmonto"/>
		  <cfinvokeargument name="etiquetas" value="#LB_Cto#, #LB_DCto#, #LB_Pvdr#, #LB_F#, #LB_MCto#"/>
		  <cfinvokeargument name="formatos" value="V,V,V,D,V"/>
		  <cfinvokeargument name="align" value="left, left, left, left, left"/>
		  <cfinvokeargument name="ajustar" value="N,S,S,N,N"/>
		  <cfinvokeargument name="formName" value="listaContratos"/>
		  <cfinvokeargument name="keys" value="CTContid, PeriodoPres"/>
		  <cfinvokeargument name="irA" value="liberacionConHeader.cfm"/>
		  <cfinvokeargument name="navegacion" value="#navegacion#"/>
		  <cfinvokeargument name="PageIndex" value="1"/>
	  </cfinvoke>
	</td>
  </tr>
</table>
