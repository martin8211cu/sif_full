<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<!--- Consultas --->
<cf_dbfunction name='to_char' args="A.Cconcepto" returnvariable='LvarCconcepto'>
<cf_dbfunction name='concat' args=" #LvarCconcepto# + ' - '+ B.Cdescripcion" delimiters='+' returnvariable='LvardCconceptoycod'>
<cfset columnas = "
	A.Cconcepto,
	#LvardCconceptoycod# as dCconceptoycod,
	A.Ocodigoori,
	A.Ocodigodest,
	B.Cdescripcion as dCconcepto,
	C.Odescripcion as dOcodigoori,
	D.Odescripcion as dOcodigodest">

<cfset tabla = "
	CuentaBalanceOficina A
		inner join ConceptoContableE B on
			A.Ecodigo = B.Ecodigo and
			A.Cconcepto = B.Cconcepto
		inner join Oficinas C on
			A.Ecodigo = C.Ecodigo and
			A.Ocodigoori = C.Ocodigo
		inner join Oficinas D on
			A.Ecodigo = D.Ecodigo and
			A.Ocodigodest = D.Ocodigo">
			
<cfset filtro = "
	A.Ecodigo = #session.Ecodigo#
	Order by
		dCconcepto,
		dOcodigoori,
		dOcodigodest">


<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="30%" valign="top">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet"
								tabla="#tabla#"
								columnas="#columnas#"
								desplegar="dCconceptoycod,dOcodigoori,dOcodigodest"
								etiquetas="Concepto,Oficina Origen,Oficina Destino"
								formatos="S,S,S"
								filtro="#filtro#"
								align="left,left,left"
								ajustar="N,N,N"
								checkboxes="N"
								keys="Cconcepto,Ocodigoori,Ocodigodest"
								MaxRows="10"
								filtrar_automatico="true"
								mostrar_filtro="true"
								Cortes="dCconceptoycod"
								filtrar_por="B.Cdescripcion,C.Odescripcion,D.Odescripcion"
								irA="CuentasBalanceOficina.cfm"
								showEmptyListMsg="true" />
					</td>
					<td width="70%" valign="top">
						<cfinclude template="CuentasBalanceOficina-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>