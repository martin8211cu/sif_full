<cfif NOT isdefined("session.Presupuesto.CPRDtipo")>
	<cfquery name="rsCE" datasource="asp">
		select CEaliaslogin
		  from CuentaEmpresarial
		 where CEcodigo = #session.CEcodigo#
	</cfquery>
	<cfif rsCE.CEaliaslogin EQ 'soin'>
		<cfif session.CEcodigo EQ 500000000000021>
			<cfset session.Presupuesto.CPRDtipo = 'GN'>
		<cfelse>
			<cfset session.Presupuesto.CPRDtipo = '*'>
		</cfif>
	<cfelse>
		<cfquery name="rsReportes" datasource="#session.dsn#">
			select min(CPRDtipo) as CPRDtipo
			  from CPReportes
			 where CPRDtipo like '#rsCE.CEaliaslogin#%'
		</cfquery>
		<cfset session.Presupuesto.CPRDtipo = rsReportes.CPRDtipo>
	</cfif>
</cfif>

<cfquery name="rsReportes" datasource="#session.dsn#">
	select CPRid, CPRcodigo, CPRnombre, CPRdescripcion, rtrim(CPRDtipo) as CPRDtipo
		<cfif isdefined("url.debug")>,1 as debug</cfif>
	  from CPReportes
	<cfif trim(session.Presupuesto.CPRDtipo) NEQ "*">
	 where CPRDtipo = '#session.Presupuesto.CPRDtipo#'
		OR CPRDtipo = '*'
	</cfif>
	 order by CPRcodigo
</cfquery>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
	<cfinvokeargument name="query" value="#rsReportes#">
	<cfinvokeargument name="desplegar" value="CPRcodigo, CPRnombre, CPRdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Codigo, Nombre, Descripcion"/>
	<cfinvokeargument name="formatos" value="S,S,S"/>
	<cfinvokeargument name="align" value="left,left,left"/>
	<cfinvokeargument name="ajustar" value="N,N,S"/>
	<cfinvokeargument name="irA" value="rptSaldos.cfm"/>
	<cfinvokeargument name="keys" value="CPRid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="maxrows" value="20"/>
	<cfinvokeargument name="width" value="100%"/>
	<cfinvokeargument name="LineaAzul" value="CPRDtipo EQ '*'"/>
</cfinvoke>	

<font color="blue">(*) Reportes genéricos de Presupuesto</font>
<BR>
<BR>
&nbsp;<input type="button" value="Verificar Clasificaciones de Plan de Cuentas" onClick="location.href = 'rptSaldos.cfm?Verificar=1';">
<BR><BR>
