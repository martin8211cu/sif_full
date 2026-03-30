<cfsetting requesttimeout="36000">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LibroDeSalarios" default="Libro de Salarios" returnvariable="LB_LibroDeSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ReporteLibroSalarios" default="Libro de Salarios" returnvariable="LB_ReporteLibroSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NombreEmpleado" default="Empleado" returnvariable="LB_NombreEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsReporte" datasource="#session.DSN#">
select 
				de.DEid,
                de.DEidentificacion, 
                de.DEnombre + ' '+ de.DEapellido1+ ' ' + de.DEapellido2 as nombre, 
                cp.CPperiodo, 
                cp.CPmes, 
                sum(se.SEsalariobruto) as Salario_Bruto
			from CalendarioPagos cp, HRCalculoNomina c, HSalarioEmpleado se, DatosEmpleado de
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and cp.CPdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#url.fdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#url.fhasta#">
			  <cfif isdefined("url.DEid") and len(trim(url.DEid))>
			  and de.DEid = case when <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#"> is null then de.DEid else <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#"> end
</cfif>
and de.DEid = se.DEid   
  				and cp.CPid = c.RCNid
  				and c.RCNid = se.RCNid
				<cfif isdefined("url.ExcluirSalariosenCero")>
				 and se.SEsalariobruto > 0
				 </cfif>
			group by 
				de.DEid,
                de.DEidentificacion, 
                de.DEnombre + ' '+ de.DEapellido1+ ' ' + de.DEapellido2, 
                cp.CPperiodo, 
                cp.CPmes
</cfquery>
<!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
select Edescripcion
        from Empresas
        where Ecodigo =
<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>



<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:10px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.detallec {
		font-size:10px;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>
<!--- <cf_templatecss> --->
 <cfset contPag = 1>
 

<cfoutput>
<cfsavecontent variable="report">
<cf_EncReporte
			MostrarPagina="true"
			NumPagina="#contPag#"
			Titulo="#Trim(LB_ReporteLibroSalarios)#"
			Color="##E3EDEF"
			filtro1="#LB_FechaRige#: #url.Fdesde#"	
			filtro2="#LB_FechaVence#: #url.Fhasta#">				
<table width="100%" border="0" cellpadding="0" cellspacing="2" align="center" style="border-color:CCCCCC"> 
    <cfset contPag = 2>
	<cfset tempDEid = "">  
    <cfset contReg = 1>
    <cfset cantReg = 39>
  <cfloop query="rsReporte">
    <cfif tempDEid neq DEid>
      <cfset tempDeid = DEid>
      <tr style="background-color:##999999;">
        <td colspan="3" class="detalle" style="left:auto">#DEidentificacion#&nbsp;-&nbsp;#nombre#</td>
	  </tr>
       
		<cfset contReg = contReg+1>
		 <!---Pregunta si pinta el corte--->
		  <cfif contReg MOD cantReg EQ 0>
		  <cfset contReg = contReg+1>
		  <tr>
			<td  colspan="3">
			<cf_EncReporte
				MostrarPagina="true"
				NumPagina="#contPag#"
				Titulo="#Trim(LB_ReporteLibroSalarios)#"
				Color="##E3EDEF"
				filtro1="#LB_FechaRige#: #url.Fdesde#"	
				filtro2="#LB_FechaVence#: #url.Fhasta#">
			</td>
			<cfset contPag = contPag+1>
		  </tr>
		  </cfif>
	  	<!------>
	  	  <tr  class="detallec" style="background-color:##CCCCCC;">
				<td nowrap class="detallec"><cf_translate key="LB_Periodo">Periodo</cf_translate></td>
				<td nowrap class="detallec"><cf_translate key="LB_Mes">Mes</cf_translate></td>
				<td nowrap class="detaller"><cf_translate key="LB_Bruto">Bruto</cf_translate></td>
		   </tr>
			
			<cfset contReg = contReg+1>
			  <!---Pregunta si pinta el corte--->
			  <cfif contReg MOD cantReg EQ 0>
			  <cfset contReg = contReg+1>
			  <tr>
				<td  colspan="3">
				<cf_EncReporte
					MostrarPagina="true"
					NumPagina="#contPag#"
					Titulo="#Trim(LB_ReporteLibroSalarios)#"
					Color="##E3EDEF"
					filtro1="#LB_FechaRige#: #url.Fdesde#"	
					filtro2="#LB_FechaVence#: #url.Fhasta#"								
					>
				</td>
				<cfset contPag = contPag+1>
			  </tr>
			  </cfif>
			  <!------>
    </cfif>
    <tr>
      <td class="detallec" >#CPperiodo#</td>
      <td class="detallec" >#CPmes#</td>
      <td class="detaller" >#LSCurrencyFormat(Salario_Bruto,'none')#</td>
    </tr>
	
	<cfset contReg = contReg+1>
    <!---Pregunta si pinta el corte--->
	<cfif contReg MOD cantReg EQ 0>
      <cfset contReg = contReg+2>
	  <tr>
        <td  colspan="3">&nbsp;</td></tr>
	  <tr>
        <td  colspan="3">
		<cf_EncReporte
			MostrarPagina="true"
			NumPagina="#contPag#"
			Titulo="#Trim(LB_ReporteLibroSalarios)#"
			Color="##E3EDEF"
			filtro1="#LB_FechaRige#: #url.Fdesde#"	
			filtro2="#LB_FechaVence#: #url.Fhasta#"								
		>
		</td>
		<cfset contPag = contPag+1>
      </tr>
	  </cfif>
  		<!------>
  </cfloop>
  </table>
  </cfsavecontent>

	<cfoutput>
		#report#
	</cfoutput>

</cfoutput>
