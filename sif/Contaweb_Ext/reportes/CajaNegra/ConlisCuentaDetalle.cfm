<cfif isdefined("URL.PERIODO")>



	<cfset VPER = URL.PERIODO>

	<cfif VPER GTE 2006>

		<!--- APUNTA LAS CONEXIONES DE BASES DE DATOS A V6 --->

		<!--- <cfset session.dsn      		= "FONDOSWEB6"> --->

		<!--- <cfset session.Conta.dsn 		= "FONDOSWEB6"> --->

	<cfelse>
		<!--- 
		<cfset session.dsn      		= "ContaWeb">

		<cfset session.Conta.dsn 		= "ContaWeb">--->

	</cfif>



</cfif>

<!---<cfset session.dsn = "minisif"> TEMPORAL --->

<script language="JavaScript" type="text/javascript">

function Asignar(CG12ID) {

	<cfif url.origen EQ "R">	

		if (window.opener != null) {

				var obj = eval("window.opener.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>" )

				obj.value = CG12ID;

				window.close();

		}

	<cfelse>

			var obj = eval("window.parent.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>" )

			obj.value = CG12ID;

			obj.focus();

	</cfif>

}

</script>


<cftry>

<cfquery name="rsCPvigencia" datasource="#Session.DSN#">
	select 	v.Ecodigo, v.Cmayor, CPVdesdeAnoMes, CPVhastaAnoMes,
			v.CPVid, v.PCEMid, 
			m.PCEMplanCtas, m.PCEMformato as PCEMformatoF, m.PCEMformatoC, m.PCEMformatoP
	  from CPVigencia v
		left outer join PCEMascaras m
			 ON m.PCEMid = v.PCEMid
	 where v.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and v.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
	   and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(LSparseDateTime(url.CPVfecha),'YYYYMM')#"> between CPVdesdeAnoMes and CPVhastaAnoMes
</cfquery>

<cfquery name="rsMascara" datasource="#Session.DSN#">
	select PCNid, PCEcatid, PCNlongitud, PCNdep
	  from PCNivelMascara
	 where PCEMid = #rsCPvigencia.PCEMid#
	 order by PCNid
</cfquery>


<cfset cuenta=0>
<cfloop query="rsMascara">
	<cfset i=rsMascara.currentRow>
	
	<cfif URL.Nivel eq i>

		<cfif rsMascara.PCNdep NEQ "">
			<!--- Busca a quien referencia --->
			<cfset LvarDetener=0>
			<cfset LvarPCNdep = rsMascara.PCNdep>
			<cfset LvarrefID = "">
			<cfset LvarrefValor = "">
			<cfif isdefined("URL.ValNivelAnt")>
				<cfset LvarrefValor = URL.ValNivelAnt>
			</cfif>

			<cfloop condition="LvarDetener EQ 0">
				
				<cfset LvarMascara = rsCPvigencia.PCEMid>
				<cfquery name="rsReferencia" datasource="#Session.DSN#">
					Select a.PCEcatid, a.PCNdep
					from PCNivelMascara a
					where PCEMid = #LvarMascara#
					  and PCNid = #LvarPCNdep#
				</cfquery>
				
				<cfset LvarPCNdep = rsReferencia.PCNdep>
				<cfif trim(rsReferencia.PCEcatid) neq "">
					<cfset LvarDetener=1>
					<cfset LvarrefID = rsReferencia.PCEcatid>
				</cfif>

			</cfloop>
			
		</cfif>	

		<cfif rsMascara.PCNdep EQ "">
			<cflocation addtoken="no" url="MuestraDatosNiveles.cfm?Cmayor=#trim(url.CGM1IM)#&Ecodigo=#session.Ecodigo#&OFICINA=#trim(url.OFICINA)#&Nivel=#i#&nivelDepende=#rsMascara.PCNdep#&CatalogoID=#rsMascara.PCEcatid#&origen=#url.origen#">
		<cfelseif false>
			<cflocation addtoken="no" url="MuestraDatosSubNiveles.cfm?Cmayor=#trim(url.CGM1IM)#&OFICINA=#trim(url.OFICINA)#&Ecodigo=#session.Ecodigo#&Nivel=#i#&nivelDepende=#rsMascara.PCNdep#&refID=421&refValor=02&CatalogoID=#rsMascara.PCEcatid#&origen=#url.origen#">
		<cfelse>
			<cflocation addtoken="no" url="MuestraDatosSubNiveles.cfm?Cmayor=#trim(url.CGM1IM)#&OFICINA=#trim(url.OFICINA)#&Ecodigo=#session.Ecodigo#&Nivel=#i#&nivelDepende=#rsMascara.PCNdep#&CatalogoID=#rsMascara.PCEcatid#&origen=#url.origen#&refID=#LvarrefID#&refValor=#LvarrefValor#">
		</cfif>

	</cfif>
</cfloop>


<cfabort>
<!--- ***************************************************** --->
<!--- ***************************************************** --->
<!--- HASTA AQUI PARA QUE VE LOS NIVELES DESDE LA VERSION 6 --->
<!--- ***************************************************** --->
<!--- ***************************************************** --->





<cfquery name="rs" datasource="#session.dsn#">

	 exec sp_Next_tipo @CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">

	, @nivel  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NIVEL#">

	<!--- 	exec sp_Next_tipo @CGM1IM = '#trim(url.CGM1IM)#'

	, @nivel  = #url.NIVEL# --->



	<cfif len(trim(url.StringNivel)) gt 0>

 		, @CGM1CD = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(url.StringNivel)#">

<!--- 	, @CGM1CD = '#trim(url.StringNivel)#' --->

	<cfelse>

		, @CGM1CD =null

	</cfif> 	

</cfquery>

<cfcatch type="any">

	<script language="JavaScript">

	   var  mensaje = '<cfoutput>#cfcatch.Detail#</cfoutput>'

	   mensaje = mensaje.substring(40,300)

	   alert(mensaje)

	</script>

	<cfabort>

</cfcatch> 

</cftry>

<cfset filtro = "">

<cfset navegacion = "">

<cfset cond = "">

<cfif isdefined("Form.CG12ID") and Len(Trim(Form.CG12ID)) NEQ 0>

	<cfset cond = " and">

	<cfset filtro = filtro & cond & " upper(CG12ID) like '%" & #UCase(Form.CG12ID)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG12ID=" & Form.CG12ID>

    



</cfif>



<cfif isdefined("Form.CG12DE") and Len(Trim(Form.CG12DE)) NEQ 0>

 	<cfset cond = " and">

	<cfset filtro = filtro & cond & " upper(CG12DE) like '%" & #UCase(Form.CG12DE)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG12DE=" & Form.CG12DE>

	

</cfif>



<html>

<head>

<title>Cuentas Contables</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="/cfmx/sif/Contaweb/css/estilos.css" rel="stylesheet" type="text/css">

</head>

<body>

<cfoutput>

	<form style="margin:0; " name="filtroEmpleado" method="post">

	

		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">

			<tr>

				<td align="center" colspan="5"><strong>nivel : #url.NIVEL# #rs.CG11DE# </strong></td>

			</tr>

			<tr>

				<td align="right"><strong>Código</strong></td>

				<td> 

					<input name="CG12ID" type="text" id="CG12ID" size="10" maxlength="10" value="<cfif isdefined("Form.CG12ID")>#Form.CG12ID#</cfif>">

				</td>

				<td align="right"><strong>Descripción</strong></td>

				<td> 

					<input name="CG12DE" type="text" id="CG12DE" size="50" maxlength="100" value="<cfif isdefined("Form.CG12DE")>#Form.CG12DE#</cfif>">

				</td>

				<td align="center">

					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">

				</td>

			</tr>

		</table>

	</form>

</cfoutput>


<cfinvoke 

 component="sif.Componentes.pListas"

 method="pLista"



 returnvariable="pListaRet">

	<cfinvokeargument name="tabla" value="CGM012"/>

 	<cfinvokeargument name="columnas" value="CG12ID,CG12DE"/>

	<cfinvokeargument name="desplegar" value="CG12ID,CG12DE"/>

	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>

	<cfinvokeargument name="formatos" value=""/>

	<cfinvokeargument name="filtro" value="CG11ID = #rs.CG11ID#  #filtro#"/>

	<cfinvokeargument name="align" value="left, left"/>

	<cfinvokeargument name="ajustar" value=""/>

	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>

	<cfinvokeargument name="formName" value="cuentas"/>

	<cfinvokeargument name="MaxRows" value="10"/>

	<cfinvokeargument name="funcion" value="Asignar"/>

	<cfinvokeargument name="fparams" value="CG12ID,CG12DE"/>

	<cfinvokeargument name="navegacion" value="#navegacion#"/>

	<cfinvokeargument name="Conexion" value="#session.dsn#"/>

</cfinvoke>

</body>

</html>


