<cf_templatecss>	

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 5px;
		padding-bottom: 5px;
		padding-left: 5px;
		padding-right: 5px;
	}
	.tbline {
		border-width: 1px;
		border-style: solid;
		border-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<cfif isdefined("Url.CTAcodigo") and not isdefined("Form.CTAcodigo")>
	<cfparam name="Form.CTAcodigo" default="#Url.CTAcodigo#">
</cfif> 
<cfif isdefined("Url.CTPcodigo") and not isdefined("Form.CTPcodigo")>
	<cfparam name="Form.CTPcodigo" default="#Url.CTPcodigo#">
</cfif> 
<cfif isdefined("Url.fecDesde") and not isdefined("Form.fecDesde")>
	<cfparam name="Form.fecDesde" default="#Url.fecDesde#">
</cfif> 
<cfif isdefined("Url.fecHasta") and not isdefined("Form.fecHasta")>
	<cfparam name="Form.fecHasta" default="#Url.fecHasta#">
</cfif>
<cfif isdefined("Url.Empresa") and not isdefined("Form.Empresa")>
	<cfparam name="Form.Empresa" default="#Url.Empresa#">
</cfif>
<cfif isdefined("Url.Proy") and not isdefined("Form.Proy")>
	<cfparam name="Form.Proy" default="#Url.Proy#">
</cfif>		
<cfif isdefined("Url.nombreAct") and not isdefined("Form.nombreAct")>
	<cfparam name="Form.nombreAct" default="#Url.nombreAct#">
</cfif>
<cfif isdefined("Url.cobrable") and not isdefined("Form.cobrable")>
	<cfparam name="Form.cobrable" default="#Url.cobrable#">
</cfif>	


<!--- parametros para la forma de imprimir --->
<cfset vparams = "">

<cfif isdefined("Form.CTAcodigo")>
	<cfset vparams = vparams & "&CTAcodigo=" & form.CTAcodigo>
</cfif> 
<cfif isdefined("Form.CTPcodigo")>
	<cfset vparams = vparams & "&CTPcodigo=" & form.CTPcodigo>
</cfif> 
<cfif isdefined("Form.fecDesde")>
	<cfset vparams = vparams & "&fecDesde=" & form.fecDesde>
</cfif> 
<cfif isdefined("Form.fecHasta")>
	<cfset vparams = vparams & "&fecHasta=" & form.fecHasta>
</cfif>
<cfif isdefined("Form.Empresa")>
	<cfset vparams = vparams & "&Empresa=" & form.Empresa>
</cfif>
<cfif isdefined("Form.Proy")>
	<cfset vparams = vparams & "&Proy=" & form.Proy>
</cfif>		
<cfif isdefined("Form.nombreAct")>
	<cfset vparams = vparams & "&nombreAct=" & form.nombreAct>
</cfif>		

<cfquery name="rsRecursosXActiv" datasource="#session.DSN#" >
	Select rt.Usuario, Papellido1 || ' ' || Papellido2 || ', ' || Pnombre as nombre,
		sum(b.CTThoras) horas
	from CTReporteTiempos rt, 
		CTTiempos b,
		sdc..Usuario u
	where rt.CTRcodigo = b.CTRcodigo
		and rt.CTRfecha >= 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecDesde,'YYYYMMDD')#">
		and rt.CTRfecha <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecHasta,'YYYYMMDD')#">
		and b.CTAcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTAcodigo#">
		and b.CTPcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTPcodigo#">
		and rt.Usucodigo = u.Usucodigo
		and rt.Ulocalizacion=u.Ulocalizacion
	group by rt.Usuario, Papellido1, Papellido2, Pnombre
</cfquery>		  
			
<cfquery name="rsEmpresa" datasource="#session.DSN#" >
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>			

<cfquery name="rsProyecto" datasource="#session.DSN#" >
	select CTPdescripcion from CTProyectos
 	where CTPcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTPcodigo#">
</cfquery>

<cfquery name="rsActiv" datasource="#session.DSN#" >
	select CTAdescripcion from CTActividades
 	where CTAcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTAcodigo#">
</cfquery>
<form method="post" name="form1">
	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/sif/ControlTiempos/consultas/formRecursosXActiv.cfm" paramsuri="#vparams#">
					</td>
				</tr>
			</table>	
		</cfif>
	</cfoutput>
	<table width="75%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <cfif isdefined('rsEmpresa') and rsEmpresa.Edescripcion NEQ "">
		<tr> 
		  <td colspan="3" class="tituloAlterno"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		</tr>
	  </cfif>
	  <cfif isdefined('rsActiv') and rsActiv.recordCount GT 0 and isdefined('rsProyecto') and rsProyecto.recordCount GT 0>
		<tr> 
		  <td colspan="3" align="center"><strong>Horas 
			por recurso para la actividad:</strong> <cfoutput>#rsActiv.CTAdescripcion#</cfoutput> <strong>del proyecto:</strong> <cfoutput>#rsProyecto.CTPdescripcion#</cfoutput></td>
		</tr>
	  </cfif>	  
	  <cfif isdefined('form.fecDesde') and form.fecDesde NEQ "" and isdefined('form.fecHasta') and form.fecHasta NEQ "">
		  <tr> 
			<td colspan="3" align="center"><cfoutput><strong>Desde:</strong> #Form.fecDesde# <strong>Hasta:</strong> #Form.fecHasta#</cfoutput></td>
		  </tr>
	  </cfif>
	  <tr> 
		<td width="71%" colspan="2">&nbsp;</td>
		<td width="29%" align="center">&nbsp;</td>
	  </tr>
	  <tr> 
		<td width="71%" colspan="2">&nbsp;</td>
		<td width="29%" align="center">&nbsp;</td>
	  </tr>
	  <cfif isdefined('rsRecursosXActiv') and rsRecursosXActiv.recordCount GT 0>
			<tr> 
			  <td colspan="3">
				  <table width="75%" border="0" cellspacing="0" cellpadding="0" align="center" class="tbline">
					<tr> 
					  <td width="71%" colspan="2" class="encabReporte">Recurso</td>
					  <td width="29%" align="center" class="encabReporte">Horas 
						invertidas</td>
					</tr>
						<cfoutput> 
						  <cfloop query="rsRecursosXActiv">
							<tr <cfif rsRecursosXActiv.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
							  <td>&nbsp;</td>
							  <td>#rsRecursosXActiv.nombre#</td>
							  <td align="center">#rsRecursosXActiv.horas#</td>
							</tr>
						  </cfloop>
						</cfoutput> 
						<tr> 
						  <td colspan="2">&nbsp;</td>
						  <td>&nbsp;</td>
						</tr>			  
				  </table>
			  </td>
			</tr>  
			<tr>  		
			  <td colspan="3">&nbsp;</td>
			</tr>  
			<tr>  		
			  <td colspan="3">&nbsp;</td>
			</tr>  
		<cfelse>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="3" align="center">No existen recursos asignados para esta actividad 
			y este proyecto</td>
		</tr>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>
	  </cfif>
		<tr> 
		  <td colspan="3"><div align="center">------------------ Fin del Reporte ------------------</div></td>
		</tr>
		<tr> 
		  <td colspan="3">&nbsp;</td>
		</tr>
		<cfif not isdefined("url.imprimir")>
			<tr>
				<td colspan="7" align="center">
					<cfoutput>
					<input name="Regresa" value="Regresar" type="button" 
					onClick="javascript: dosubmit('#Form.fecDesde#','#Form.fecHasta#',#Form.cobrable#,'#Form.Proy#');">
					</cfoutput>
				</td>
			</tr>
		</cfif> 
		
	</table>
</form>          

<script language="javascript1.2">
	function dosubmit(Fdesde,Fhasta,cobrable,proyecto){
		location.href = "/cfmx/sif/ControlTiempos/consultas/ChartHorasXPry.cfm?fecDesde=" + Fdesde + 
					  	"&fecHasta=" + Fhasta + "&cobrable=" + cobrable + "&proyecto=" + proyecto;
	}
</script>