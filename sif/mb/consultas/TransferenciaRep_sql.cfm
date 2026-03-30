<!--- Metodo Traduccion de Etiquetas --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Transferencias Bancarias (sin aplicar)" returnvariable="LB_Titulo" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaOrigen" default="Cuenta Ori." returnvariable="LB_CuentaOrigen" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaDestino" default="Cuenta Dest." returnvariable="LB_CuentaDestino" xmlfile="TransferenciaRep_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="TransferenciaRep_sql.xml"/>

<cfset LvarProcedencia ="Lista">

<cfif isdefined('form.ori') and len(trim(form.ori)) and form.ori eq 1>
	<cfset LvarProcedencia ="Lista">
<cfelseif isdefined('url.ori') and len(trim(url.ori)) and url.ori eq 1>
	<cfset LvarProcedencia ="Lista">
<cfelseif isdefined('form.chk') and len(trim(form.chk))>
	<cfset LvarProcedencia ="Lista">
<cfelse>
	<cfset LvarProcedencia ="Menu">
</cfif>

<!--- Hacia donde debe regresar --->
<cfif LvarProcedencia eq "Lista">
	<cfset LvarRegresar ="../operacion/listaTransferencias.cfm">
<cfelse>
	<cfset LvarRegresar ="TransferenciaRep.cfm">
</cfif>

<cfquery name="rsEncabezado" datasource="#session.DSN#" maxrows="1000">
	select 
		a.ETid, 
		a.Ecodigo, 
		a.ETperiodo, 
		a.ETmes, 
		a.ETdescripcion, 
		a.ETfecha, 
		a.Edocbase
	from ETraspasos a
	where a.Ecodigo = #session.Ecodigo#
	<cfif LvarProcedencia EQ "Lista" and isdefined('form.chk') and len(trim(form.chk))>
		and a.ETid in (#form.chk#)
	<cfelseif LvarProcedencia EQ "Menu">
		<cfif isdefined("form.Edocbase") and len(trim(form.Edocbase))>
		 and upper(a.Edocbase) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Edocbase)#%">
		</cfif>
		<cfif isdefined("form.ETdescripcion") and len(trim(form.ETdescripcion))>
			 and upper(a.ETdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.ETdescripcion)#%">
		</cfif>
		<cfif isdefined("form.ETperiodo") and len(trim(form.ETperiodo)) and form.ETperiodo neq 'all'>
			and ETperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETperiodo#">
		</cfif>
		<cfif isdefined("form.ETmes") and len(trim(form.ETmes)) and form.ETmes neq 'all'>
			and ETmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETmes#">
		</cfif> 
		<cfif isdefined("form.ETfecha") and len(trim(form.ETfecha))>
			and ETfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ETfecha)#">
		</cfif> 
	</cfif>
	
</cfquery>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas 
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cf_htmlreportsheaders title="Consulta de Transferencias" 
	filename="Transferencias.xls" 
	download='true'
	ira="#LvarRegresar#">

<cfflush interval="64">

<table cellpadding="0" cellspacing="1" border="0" align="center" style="width:100%">
	<tr>
		<td>&nbsp;</td>
		<td colspan="3" align="center" style="font-size:28px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3" align="center" style="font-size:20px" width="100%"><cfoutput>#LB_Titulo#</cfoutput></td>
		<td align="right" nowrap="nowrap"><cfoutput>#LB_Fecha#</cfoutput>: <cfoutput>#DateFormat(now(),'dd/mm/yyyy')#</cfoutput></td>
	</tr>
	<tr>
		<td colspan="5">&nbsp;</td>
	</tr>
	<cfoutput query="rsEncabezado" group="ETid">
		<tr>
			<td><strong><cfoutput>#LB_Documento#</cfoutput>:</strong>&nbsp;</td>
			<td colspan="2">#rsEncabezado.Edocbase#</td>
			<td align="right"><strong><cfoutput>#LB_Fecha#</cfoutput>:</strong>&nbsp;</td>
			<td colspan="1">#dateformat(lsParseDateTime(rsEncabezado.ETfecha),'dd/mm/yyyy')#</td>
		</tr>
		<tr>
			<td><strong><cfoutput>#LB_Descripcion#</cfoutput>:</strong>&nbsp;</td>
			<td colspan="4">#rsEncabezado.ETdescripcion#</td>
		</tr>
	
		<tr bgcolor="##F4F4F4">
			<td><strong><cfoutput>#LB_Documento#</cfoutput></strong></td>
			<td nowrap="nowrap"><strong><cfoutput>#LB_CuentaOrigen#</cfoutput></strong></td>
			<td align="right"><strong><cfoutput>#LB_Monto#</cfoutput></strong></td>
			<td nowrap="nowrap">&nbsp;&nbsp;<strong><cfoutput>#LB_CuentaDestino#</cfoutput></strong></td>
			<td align="right"><strong><cfoutput>#LB_Monto#</cfoutput></strong></td>
		</tr>

		<cfquery name="rsDetalle" datasource="#session.DSN#">
			select 
				a.DTdocumento,
				CBidori, 
				CBiddest, 
				BTidori, 
				a.BTiddest, 
				a.DTmontoori, 
				a.DTmontodest,
				(select b.CBcodigo from CuentasBancos b where b.CBid = a.CBidori and b.CBesTCE = 0 and Ecodigo = #session.Ecodigo#) as CBDidori,
				(select b.CBcodigo from CuentasBancos b where b.CBid = a.CBiddest and b.CBesTCE = 0 and Ecodigo = #session.Ecodigo#) as CBDiddest,
				(select d.Miso4217 from CuentasBancos b, Monedas d where b.CBid = a.CBidori and b.CBesTCE = 0 and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo#) as oriMcodigo,
				(select d.Miso4217 from CuentasBancos b, Monedas d where b.CBid = a.CBiddest and b.CBesTCE = 0 and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo#) as destMcodigo
			from DTraspasos a 
			where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.ETid#">
		</cfquery>
		<cfloop query="rsDetalle">
			<tr style="font-size:11px">
				<td>#rsDetalle.DTdocumento#</td>
				<td>#rsDetalle.CBDidori#</td>
				<td align="right">#numberformat(rsDetalle.DTmontoori,',9.00')# #oriMcodigo#</td>
				<td>&nbsp;&nbsp;#rsDetalle.CBDiddest#</td>
				<td align="right">#numberformat(rsDetalle.DTmontodest,',9.00')# #destMcodigo#</td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="5" style="border-top:solid;  border-top-color:##BEBEBE; border-width:thin ">&nbsp;</td>
		</tr>
	</cfoutput>
</table>

