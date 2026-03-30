<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">
<cf_template template="#session.sitio.template#">
<!---***************************************************** --->
<cf_templatearea name="title">
	Programación de cuentas fijas
</cf_templatearea>
<!---***************************************************** --->
<cf_templatearea name="left" >
</cf_templatearea>
<cf_templatearea name="body">
<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** --->

<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
 	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
 	qFormAPI.include("*");
</SCRIPT>
<cfif IsDefined("url.IDSESSION")>
	<cflocation url="../reportes/cmn_RepCuentasFijas.cfm">
</cfif>
<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<link href="/cfmx/sif/Contaweb/css/estilos.css" rel="stylesheet" type="text/css"> 
<link href="/cfmx/sif/fondos/css/sif.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" >
	<tr>
		<td>
			<cfinclude template="cmn_formRepCuentasFijas.cfm">
		</td>
  	</tr>
		<tr>
		<td>
			<cfquery name="lista" datasource="#session.DSN#">
				select  a.CGM1IM,b.CTADES,
				case a.CGC3TPOA
					 when  1 then '1-Saldos acumulados'
					 when  2 then '2-Saldos del periodo'
					 when  3 then '3-Movimientos del mes'
					 when  4 then '4-Movimientos asiento del mes'
					 when  5 then '5-Movimientos asiento consecutivo del mes'
				 end as TIPO,CGC3TPOA
				from CGC003 a,CGM001 b
				where a.CGM1IM = b.CGM1IM
				and CGM1CD  is null 
				order by CGM1IM,CGC3TPOA
			</cfquery>
			<cfinvoke 
				 component="sif.Contaweb.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="CGM1IM ,CTADES,TIPO"/>
					<cfinvokeargument name="etiquetas" value="Cuenta,Descripción,tipo de archivo"/>
					<cfinvokeargument name="formatos" value="V, V, V"/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="cmn_RepCuentasFijas.cfm"/>
					<cfinvokeargument name="keys" value="CGM1IM,CGC3TPOA"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
			</cfinvoke>
			</td>
  	</tr>
</table>
<!---***************************************************** --->
</cf_templatearea>
</cf_template>
