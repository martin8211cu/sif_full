<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate key="LB_ObservacionesPorEmpleado">Observaciones por Empleado</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfparam name="form.DEid" default="#url.DEid#">
</cfif>
<cfif isdefined('url.RHEEid') and not isdefined('form.RHEEid')>
	<cfparam name="form.RHEEid" default="#url.RHEEid#">
</cfif>


<cfif isdefined('form.DEid') and len(trim(form.DEid)) and isdefined('form.RHEEid') and len(trim(form.RHEEid))>
	<cfif isdefined('form.btnGuardarObs')>
		<cfquery datasource="#session.dsn#">
			update RHListaEvalDes set 
				<cfif isdefined('form.RHLEobservacion') and len(trim(form.RHLEobservacion))>
					RHLEobservacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHLEobservacion#">
				<cfelse>
					RHLEobservacion=null
				</cfif>
			where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
				and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
	</cfif>
	<cfquery name="rsEmpl" datasource="#session.dsn#">
		Select a.RHEEid, RHLEobservacion,b.DEid, b.DEidentificacion, 
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat( b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as NombreCompleto
		from RHListaEvalDes a
			inner join DatosEmpleado  b
				on b.DEid = a.DEid
					and b.Ecodigo=a.Ecodigo
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>	
</cfif>

<form name="formObsEmpl" method="post" action="obsEmpleado.cfm">
	  <cfoutput>	      
		<input type="hidden" name="DEid" value="#form.DEid#">
		<input type="hidden" name="RHEEid" value="#form.RHEEid#">			

      <table width="100%"  border="0" cellpadding="0" cellspacing="0">
			  <tr bgcolor="##CCCCCC">
				<td colspan="2" align="center"><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate></strong></td>
			</tr>
			<cfif isdefined('rsEmpl')>
				<tr bgcolor="##CCCCCC">
					<td colspan="2" align="center"><strong>#rsEmpl.NombreCompleto#</strong></td>
				</tr>			
			</cfif>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td width="15%" align="right" valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones:</strong></td>
				<td width="64%">
					<textarea name="RHLEobservacion" id="RHLEobservacion" cols="40" rows="5"><cfif isdefined('rsEmpl')>#rsEmpl.RHLEobservacion#<cfelse>&nbsp;</cfif></textarea>
				</td>
			  </tr>
			  <tr>
			    <td colspan="2" align="center">&nbsp;
					
				</td>
		    </tr>			  
			<tr>
			    <td colspan="2" align="center">		
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Guardar"
						Default="Guardar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Guardar"/>						  
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Cerrar"
						Default="Cerrar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Cerrar"/>
					<cfoutput>
					<input type="submit" name="btnGuardarObs" value="#BTN_Guardar#">
					<input type="button" onClick="javascript: funcCerrar();" name="btnCerrar" value="#BTN_Cerrar#">		
					</cfoutput>
				</td>
		    </tr>
		  </table>
		</cfoutput>
</form>
</body>
</html>


<script language="javascript" type="text/javascript">
	function funcCerrar(){
		window.opener.document.form1.submit();
		window.close();
	}
</script>
