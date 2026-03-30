<cffunction name="calificacionAgente" output="true" returntype="string" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
	<cfargument name="plazo" type="numeric" required="Yes"  displayname="plazo en días">
	
	<cfinvoke component="saci.comp.ISBprospectos" method="GetPorcentajeCalificacion" returnvariable="Porcentaje">
		<cfinvokeargument name="AGid" value="#Arguments.AGid#">
		<cfinvokeargument name="plazo" value="#Arguments.plazo#">
	</cfinvoke>
	
	
	<cfinvoke component="saci.comp.ISBprospectos" method="GetCalificacion" returnvariable="nota">
		<cfinvokeargument name="AGid" value="#Arguments.AGid#">
		<cfinvokeargument name="porcentaje" value="#Porcentaje#">
	</cfinvoke>

	<cfset resultado = nota>


	<cfreturn resultado>
</cffunction>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Resumen General de Valoraciones al Agente</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
.style2 {font-size: 16px}
.style3 {
	color: #FF0000;
	font-weight: bold;
}
.style4 {
	color:#006699;
	font-weight: bold;
	font-size:18px;
}
-->
</style>
</head>

<body>

	<cfquery datasource="#session.dsn#" name="dataAgente">
		Select p.Pid, (p.Pnombre || ' ' || p.Papellido || ' ' || p.Papellido2) as NombreAgente
		from ISBagente a
			inner join ISBpersona p
				on p.Pquien=a.Pquien
		where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGid#" null="#Len(url.AGid) Is 0#">
	</cfquery>
	<cfset puntaje = calificacionAgente(url.AGid,url.plazo)>
	
	<form name="form1" method="post" action="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center"><span class="style1">
			  Valoraciones del agente</span>
			</td>
	  	  </tr>		  
		  <tr>
			<td align="center">
				<strong>			
					<cfif isdefined('dataAgente') and dataAgente.recordCount GT 0>
						<cfoutput><span class="style2" style="">
						  	#dataAgente.Pid# - #dataAgente.NombreAgente#
						</span></cfoutput>
					<cfelse>
						!! Error, no se encontro el agente.
					</cfif>			
			    </strong>				
			</td>
		  </tr>		  
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  
		  <tr>
			<td align="center">
				
				<!--- Plazo en dias Periodo de calificación --->
				<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="LvarDiasPlazo">
					<cfinvokeargument name="Pcodigo" value="#url.plazo#">
				</cfinvoke>
				
				<cfset LvarHoy = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>


					<!--- Borra la tabla de reportes --->
					<cftry>
						<cfquery datasource="#session.DSN#">
							drop table ##isbReporte
						</cfquery>
						<cfcatch type="any">
						</cfcatch>
					</cftry>

										
				<!--- Tabla temporal de reportes --->
				<cfquery datasource="#session.DSN#">
					create table ##isbReporte (
						puntaje_positivo int null,
						puntaje_negativo int null,
						fecha varchar(8) not null)
				</cfquery>

				
				<cfquery datasource="#session.dsn#" name="dataGraph">
					Insert ##isbReporte 		
					select
						sum(coalesce(ANpuntaje,0)) as puntaje_positivo,0,
						convert(varchar,dateadd(dd,floor(datediff(dd,#LvarHoy#,ANfecha)/15)*15,#LvarHoy#),112)			
					 from ISBagenteValoracion
					where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGid#" null="#Len(url.AGid) Is 0#">
						and ANfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
						and ANvaloracion = 1	
					group by convert(varchar,dateadd(dd,floor(datediff(dd,#LvarHoy#,ANfecha)/15)*15,#LvarHoy#),112)
				</cfquery>
	
				<cfquery datasource="#session.dsn#" name="dataGraph2">
					Insert ##isbReporte
					select
						0,sum(coalesce(ANpuntaje,0)) as puntaje_negativo,
						convert(varchar,dateadd(dd,floor(datediff(dd,#LvarHoy#,ANfecha)/15)*15,#LvarHoy#),112)
					from ISBagenteValoracion
					where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGid#" null="#Len(url.AGid) Is 0#">
						and ANfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
						and ANvaloracion = -1	
					group by convert(varchar,dateadd(dd,floor(datediff(dd,#LvarHoy#,ANfecha)/15)*15,#LvarHoy#),112)
				</cfquery>
	
	
				<cfquery datasource="#session.dsn#" name="resumen">
					Select sum(puntaje_negativo) as negativas,
							sum(puntaje_positivo) as positivas,convert(varchar,convert(datetime,fecha),103) as fecha
					  from ##isbReporte
					group by fecha
				</cfquery>
	
	
					<cfif isdefined('resumen') and resumen.RecordCount EQ 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td align="center"><span class="style3">!! No existen datos disponibles para la graficaci&oacute;n.</span></td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>							  
						</table>
					<cfelse>			
					
					<cfchart show3d="yes" rotated="yes" tipbgcolor="##CCFFFF" tipstyle="mouseOver" xaxistype="category" title="Puntaje de Valoraciones obtenido por quincena en #LvarDiasPlazo# días de historia" format="png" chartwidth="380" showlegend="yes"  chartheight="300" >         			
					<cfchartseries   query="resumen"  markerstyle="diamond" paintstyle="light" seriescolor="##009900"   valuecolumn="positivas" type="line" itemcolumn="fecha" serieslabel="Valoraciones Positivas"/>
					<cfchartseries query="resumen" paintstyle="light" markerstyle="diamond"  seriescolor="##CC3300" valuecolumn="negativas" type="line" itemcolumn="fecha" serieslabel="Valoraciones Negativas"/>
       									
					</cfchart>		
						<!---<cfchart 
								tipStyle="mousedown" 
								font="arial"
								fontsize=16  
								fontBold="ye
								backgroundColor = "##CCFFFF"
								show3D="yes"
								chartWidth="350"
								chartHeight="250"
								>
								
							<cfchartseries 
								type="pie" 
								query="dataGraph" 
								valueColumn="valores" 
								itemColumn="valoraciones" 
								colorlist="##FF0000,##66FF66"
								/>
						</cfchart>--->
					</cfif>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center">
				<cfif isdefined('dataTotal') and dataTotal.recordCount GT 0>
					<strong>
						<span class="style2">Total de Valoraciones: &nbsp;&nbsp;<cfoutput>#LSNumberFormat(dataTotal.total, ',9.00')#</cfoutput></span>
					</strong>
				<cfelse>
					&nbsp;
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td align="center"><strong><span class="style4">Calificaci&oacute;n del Agente: &nbsp;&nbsp;<cfoutput>#puntaje# - (#Porcentaje#%)</cfoutput></span></strong></td>
		  </tr>		  		  
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  
		  <tr>
			<td align="center">
				<input type="button" name="Cerrar" value="Cerrar" onClick="javascript: CerrarVentana();">			
			</td>
		  </tr>
		</table>
	</form>
</body>
</html>

<script language="javascript" type="text/javascript">
	function CerrarVentana(){
		window.close();
	}
</script>
