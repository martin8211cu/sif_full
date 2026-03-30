<cfif IsDefined('url.DEid') and not IsDefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif Not IsDefined('form.DEid')>
	<cf_errorCode	code="52137" msg="se requiere un empleado">
</cfif>
<cfparam name="form.DEid">

<cfquery datasource="#session.dsn#" name="rsRep">
	Select
	 {fn concat(RHIAcodigo,{fn concat('',RHIAnombre)})}  as inst,ec.RHCid,DEid, ec.BMfecha,
		case	RHEMestado
			when 0 then 'En progreso'
			when 10 then 'Aprobado'
			when 15 then 'Convalidado'
			when 20 then 'Perdido'
			when 30 then 'Abandonado'
			when 40 then 'Retirado'
		end RHEMestado,
		RHEMnota,ec.RHCid, RHCnombre
	from RHEmpleadoCurso ec
		inner join RHCursos c
			on c.RHCid=ec.RHCid
		inner join RHMateria m
			on c.Mcodigo = m.Mcodigo
			and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		inner join RHInstitucionesA ia
			on ia.RHIAid=c.RHIAid
	
	where ec.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	order by ec.BMfecha,RHCnombre
</cfquery>

<cfset Session.Params.ModoDespliegue = 1>
<cfinclude template="/rh/Utiles/params.cfm">
<cfinclude template="../../../expediente/consultas/consultas-frame-header.cfm">


<table width="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="font-size:22px;font-family:Georgia, 'Times New Roman', Times, serif" align="center"><cfoutput>#session.Enombre#</cfoutput></td>
  </tr>  
  <tr>
    <td style="	border-bottom: 1px solid black;	padding-bottom: 5px; font-size:17px;font-family:Georgia, 'Times New Roman', Times, serif" align="center">Base de Entrenamiento</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td>
		<cfoutput>
			<table width="100%" border="0" cellpadding="3" cellspacing="0">
			<tr>
			  <td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap><cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" width="75" height="100"> </td>
			  <td class="fileLabel" width="10%" nowrap><cf_translate key="NombreExp">Nombre Completo</cf_translate>: </td>
			  <td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate>:</td>
			  <td>#rsEmpleado.DEidentificacion#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate>:</td>
			  <td>#rsEmpleado.Sexo#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate>:</td>
			  <td>#rsEmpleado.EstadoCivil#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate>:</td>
			  <td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="DireccionExp">Direcci&oacute;n</cf_translate>:</td>
			  <td>#rsEmpleado.DEdireccion#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate>:</td>
			  <td>#rsEmpleado.DEcantdep#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate>:</td>
			  <td>#rsEmpleado.Bdescripcion#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
			  <td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
			</tr>
			</table>	
		</cfoutput>			
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		  <tr class="tituloListas">
		    <td><strong>Instituci&oacute;n</strong></td>	  
			<td><strong>Curso</strong></td>
			<td><strong>Calificaci&oacute;n</strong></td>
			<td><strong>Nota Obtenida</strong></td>
		    <td><strong>Fecha</strong></td>			
		  </tr>  
		  <cfif isdefined('rsRep') and rsRep.recordCount GT 0>
		  	<cfoutput query="rsRep">
				  <cfset LvarListaNon = (CurrentRow MOD 2)>			
				  <tr class=<cfif LvarListaNon MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				    <td>#inst#</td>
					<td>#RHCnombre#</td>
					<td>#RHEMnota#</td>
					<td>#RHEMestado#</td>
				    <td><cf_locale name="date" value="#BMfecha#"/></td>				  					
				  </tr>
			  </cfoutput>
		  </cfif>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
		</table>
	
	</td>
  </tr>    
</table>

<center><strong>--- Fin del Reporte ---</strong></center>