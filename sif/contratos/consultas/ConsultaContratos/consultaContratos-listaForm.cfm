<!--- <cf_dump var="#form#"> ---> 

<!--- JMRV. 12/08/2014. --->

<cfinclude template="/sif/Utiles/sifConcat.cfm">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PPres" Default= "Periodo del Presupuesto" XmlFile="consultaContratos.xml" returnvariable="LB_PPres"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Status" Default= "Estatus" XmlFile="consultaContratos.xml" returnvariable="LB_Status"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_StatusN" Default= "Todos" XmlFile="consultaContratos.xml" returnvariable="LB_StatusN"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Status0" Default= "En proceso" XmlFile="consultaContratos.xml" returnvariable="LB_Status0"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Status1" Default= "Aplicado" XmlFile="consultaContratos.xml" returnvariable="LB_Status1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Status2" Default= "Cancelado" XmlFile="consultaContratos.xml" returnvariable="LB_Status2"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NumContrato" Default= "Numero de contrato" XmlFile="consultaContratos.xml" returnvariable="LB_NumContrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InVig" Default= "Fecha de inicio de vigencia" XmlFile="consultaContratos.xml" returnvariable="LB_InVig"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default= "Fecha" XmlFile="consultaContratos.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FnVig" Default= "Fecha de fin de vigencia" XmlFile="consultaContratos.xml" returnvariable="LB_FnVig"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Proveedor" Default= "Proveedor" XmlFile="consultaContratos.xml" returnvariable="LB_Proveedor"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Contrato" Default= "Contrato" XmlFile="consultaContratos.xml" returnvariable="LB_Contrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Desc" Default= "Descripci&oacute;n del Contrato" XmlFile="consultaContratos.xml" returnvariable="LB_Desc"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default= "Monto Contrato" XmlFile="consultaContratos.xml" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Saldo" Default= "Saldo Local" XmlFile="consultaContratos.xml" returnvariable="LB_Saldo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoLoc" Default= "Monto Local" XmlFile="consultaContratos.xml" returnvariable="LB_MontoLoc"/>

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


<!--- Captura los datos de la consulta si vienen por url --->

<cfif isdefined("url.CPPid") and Len(Trim(url.CPPid))>
	<cfparam name="Form.CPPid" default="#url.CPPid#">
<cfelse>
	<cfparam name="Form.CPPid" default="-1">
</cfif>

<cfset param = "">

<cfif isdefined("form.CPPid") and Len(Trim(form.CPPid)) and form.CPPid NEQ -1>
	<cfset CPPid = form.CPPid>
	<cfset param = param & "&CPPid=" & form.CPPid>
<cfelseif isdefined("url.CPPid") and Len(Trim(url.CPPid)) and url.CPPid NEQ -1>
	<cfset CPPid = url.CPPid>
	<cfset param = param & "&CPPid=" & url.CPPid>
</cfif>

<cfif isdefined("form.CTCnumContrato") and Len(Trim(form.CTCnumContrato))>
	<cfset CTCnumContrato = form.CTCnumContrato>
	<cfset param = param & "&CTCnumContrato=" & form.CTCnumContrato>
<cfelseif isdefined("url.CTCnumContrato") and Len(Trim(url.CTCnumContrato))>
	<cfset CTCnumContrato = url.CTCnumContrato>
	<cfset param = param & "&CTCnumContrato=" & url.CTCnumContrato>
</cfif>

<cfif isdefined("form.fechaInicio") and Len(Trim(form.fechaInicio))>
	<cfset fechaInicio = LSDateFormat(form.fechaInicio,'yyyy-mm-dd') & ' 00:00:00.000'>
	<cfset param = param & "&fechaInicio=" & fechaInicio>
<cfelseif isdefined("url.fechaInicio") and Len(Trim(url.fechaInicio))>
	<cfset fechaInicio = url.fechaInicio>
	<cfset param = param & "&fechaInicio=" & url.fechaInicio>
</cfif>

<cfif isdefined("form.fechaFin") and Len(Trim(form.fechaFin))>
	<cfset fechaFin = LSDateFormat(form.fechaFin,'yyyy-mm-dd') & ' 00:00:00.000'>
	<cfset param = param & "&fechaFin=" & fechaFin>
<cfelseif isdefined("url.fechaFin") and Len(Trim(url.fechaFin))>
	<cfset fechaFin = url.fechaFin>
	<cfset param = param & "&fechaFin=" & url.fechaFin>
</cfif>

<cfif isdefined("form.fecha") and Len(Trim(form.fecha))>
	<cfset fecha = LSDateFormat(form.fecha,'yyyy-mm-dd') & ' 00:00:00.000'>
	<cfset param = param & "&fecha=" & fecha>
<cfelseif isdefined("url.fecha") and Len(Trim(url.fecha))>
	<cfset fecha = url.fecha>
	<cfset param = param & "&fecha=" & url.fecha>
</cfif>

<cfif isdefined("form.SNcodigo") and Len(Trim(form.SNcodigo)) and isdefined("form.SNnumero") and Len(Trim(form.SNnumero))>
	<cfset SNcodigo = form.SNcodigo>
	<cfset SNnumero = form.SNnumero>
	<cfset param = param & "&SNcodigo=" & form.SNcodigo>
	<cfset param = param & "&SNnumero=" & form.SNnumero>
<cfelseif isdefined("url.SNcodigo") and Len(Trim(url.SNcodigo)) and isdefined("url.SNnumero") and Len(Trim(url.SNnumero))>
	<cfset SNcodigo = url.SNcodigo>
	<cfset SNnumero = url.SNnumero>
	<cfset param = param & "&SNcodigo=" & url.SNcodigo>
	<cfset param = param & "&SNnumero=" & url.SNnumero>
</cfif>

<cfif isdefined("form.CTCestatus") and Len(Trim(form.CTCestatus))>
	<cfset CTCestatus = form.CTCestatus>
	<cfset param = param & "&CTCestatus=" & form.CTCestatus>
<cfelseif isdefined("url.CTCestatus") and Len(Trim(url.CTCestatus))>
	<cfset CTCestatus = url.CTCestatus>
	<cfset param = param & "&CTCestatus=" & url.CTCestatus>
</cfif>


<!--- Trae el id del socio de negocios --->
<cfif isdefined("SNcodigo") and Len(Trim(SNcodigo)) and isdefined("SNnumero") and Len(Trim(SNnumero))>
	<cfquery name="rsProveedor" datasource="#Session.DSN#">
		select 	SNid
		from SNegocios	
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNnumero#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
	</cfquery>
</cfif>



<cfoutput>
<script language="javascript" type="text/javascript">
	function funcNuevo() {
		document.listaLiberacion.CPDEID.value = "";
	}
</script>

<form name="form1" method="post" action="ConsultaContratos-lista.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr> 
    <td class="fileLabel"><cfoutput>#LB_PPres#</cfoutput></td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cf_cboCPPid IncluirTodos="true" value="#Form.CPPid#" CPPestado="1">
	</td>
	<td align="right" nowrap><cfoutput>#LB_Status#:</cfoutput>&nbsp;</td>
	<td>
		<select name="CTCestatus" default="-1"> 
			<option value="-1">--- <cfoutput>#LB_StatusN#</cfoutput> ---</option>
			<option value="0"><cfoutput>#LB_Status0#</cfoutput></option> 
			<option value="1"><cfoutput>#LB_Status1#</cfoutput></option> 
			<option value="2"><cfoutput>#LB_Status2#</cfoutput></option> 
		</select>
	</td>
	<td></td>
	<td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
  </tr>
  
  <tr><td><p>&nbsp;</p></td></tr>
  
  <tr> 
  	<td><cfoutput>#LB_NumContrato#</cfoutput>:&nbsp;
        <input  name="CTCnumContrato" type="text" tabindex="1"  value="" size="20" maxlength="30">
		<div align="right"></div>
  	</td> 
  
  	<td align="right" nowrap><cfoutput>#LB_InVig#</cfoutput>:&nbsp;</td>
    <td>
        <cf_sifcalendario name="fechaInicio" value="" form="form1" tabindex="1">
    </td>
    
    <td align="right" nowrap>&nbsp;&nbsp;<cfoutput>#LB_Fecha#</cfoutput>:&nbsp;</td>
    <td>
        <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fecha" value="">
     </td>
  </tr>
  
  <tr>
  	<td></td>
  	<td align="right" nowrap><cfoutput>#LB_FnVig#</cfoutput>:&nbsp;</td>
    <td>
        <cf_sifcalendario name="fechaFin" value="" form="form1"  tabindex="1">
    </td>
   
   <td>&nbsp;&nbsp;<cfoutput>#LB_Proveedor#</cfoutput>:&nbsp;</td>
    <td>		  
		<cf_sifsociosnegocios2 name="proveedor" SNcontratos = 1 sntiposocio="P" tabindex="1" Ecodigo="#session.Ecodigo#" form="form1">	 
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
				   a.Ecodigo,
				   a.CPPid,
				   a.CTContid,
				   a.CTCnumContrato, 
				   a.CTCdescripcion, 
				   a.CTfecha, 
					'' #_Cat#
						case c.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat# 
						case {fn month(c.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(c.CPPfechaDesde)}">
						#_Cat# ' a ' #_Cat# 
						case {fn month(c.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(c.CPPfechaHasta)}">
				  as PeriodoPres,
				  b.SNnombre,		
				  a.CTmonto,
				  a.CTfecha,
				   (select isnull(sum(CTDCmontoTotal),0) 
				   	from CTDetContrato
				   		where Ecodigo = a.Ecodigo
						and  CTContid = a.CTContid) as montoTotal,
					(select isnull(sum(CTDCmontoConsumido),0) 
				   	from CTDetContrato
						where Ecodigo = a.Ecodigo
						and  CTContid = a.CTContid) as montoConsumido,
				 a.CTmonto * CTtipoCambio as CTMontoLoc
			from CTContrato  a
					left join SNegocios b
					on b.SNid = a.SNid
					left join CPresupuestoPeriodo c
					on c.CPPid = a.CPPid
			
			where a.Ecodigo = #Session.Ecodigo#
			
				<cfif isdefined("CPPid") and CPPid neq "" and CPPid neq -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
				 	</cfif>
				 	<cfif isdefined("CTCnumContrato") and CTCnumContrato neq "">
			and a.CTCnumContrato like '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#CTCnumContrato#"> + '%'
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
				 	<cfif isdefined("CTCestatus") and CTCestatus neq "" and CTCestatus neq -1>
			and a.CTCestatus = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CTCestatus#">
				 	</cfif>
			order by a.CTfecha desc, a.CTCnumContrato
		</cfquery>
		
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="query" value="#rsListaQRY#"/>
		  <cfinvokeargument name="desplegar" value="CTCnumContrato, CTCdescripcion, SNnombre, CTfecha, CTmonto, CTmontoLoc, montoTotal - montoConsumido"/>
		  <cfinvokeargument name="etiquetas" value="#LB_Contrato#, #LB_Desc#, #LB_Proveedor#, #LB_Fecha#, #LB_Monto#, #LB_MontoLoc#, #LB_Saldo#"/>
		  <cfinvokeargument name="formatos" value="V,V,V,D,M,M,M"/>
		  <cfinvokeargument name="align" value="left, left, left, center, right, right, right"/>
		  <cfinvokeargument name="ajustar" value="N,S,S,N,N,N,N"/>
		  <cfinvokeargument name="keys" value="CTContid, PeriodoPres"/>
		  <cfinvokeargument name="irA" value="reporteContratos.cfm"/>
		  <cfinvokeargument name="navegacion" value="#param#"/>
		  <cfinvokeargument name="PageIndex" value="1"/>
	  </cfinvoke>		
	</td>
  </tr>
</table>
