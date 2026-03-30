<cfquery datasource="#session.dsn#" name="rhe">
	select EEid, Eid, ETid, RHEdefault, RHEinactiva, RHEconfigurada
	from RHEncuestadora
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
</cfquery>

<cfset EEid = rhe.EEid>
<cfset ETid = rhe.ETid>
<cfset Eid  = rhe.Eid>

<cfquery datasource="sifpublica" name="hdr">
	select EEid,EEnombre,Ppais
	from EncuestaEmpresa
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
</cfquery>
<cfquery datasource="sifpublica" name="org">
	select EEid,ETid,ETdescripcion
	from EmpresaOrganizacion
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
</cfquery>
<cfquery datasource="sifpublica" name="encu">
	select e.Eid, e.Edescripcion, e.Efecha, count(1) as cant, #EEid# as EEid, #ETid# as ETid
	from Encuesta e
	where e.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
	group by e.Eid, e.Edescripcion, e.Efecha
	order by e.Efecha desc
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Configurar encuestadora" width="450">	
	<cfoutput>
	<form action="RHEncuestadoraEdit-apply.cfm" method="post">
		<table width="450" border="0" cellspacing="6" align="center">
			<tr>
			  <td width="1">&nbsp;</td>
			  <td width="83">&nbsp;</td>
			  <td width="29">&nbsp;</td>
			  <td width="188">&nbsp;</td>
			  <td width="93">&nbsp;</td>
			  <td width="2">&nbsp;</td>
			  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td colspan="4"><strong>#hdr.EEnombre#</strong></td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td colspan="4">Seleccione las siguientes opciones para definir c&oacute;mo utilizar&aacute; las encuestas salariales de #hdr.EEnombre# en su empresa.</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td rowspan="2">&nbsp;</td>
			  <td rowspan="2" valign="top">Tipo de Organizaci&oacute;n </td>
			  <td colspan="3">
			  <select name="ETid" id="ETid">
			  <cfloop query="org">
				<option value="#org.ETid#" <cfif rhe.ETid EQ org.ETid>selected</cfif>>#HTMLEditFormat(org.ETdescripcion)#</option>
				</cfloop>
			  </select>
			  </td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="3">Seleccione el tipo de organizaci&oacute;n en que #session.Enombre# encaje mejor. Del tipo de organizaci&oacute;n que seleccione depender&aacute;n los resultados del comparativo de salarios. </td>
			  <td>&nbsp;</td>
			  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td rowspan="3" valign="top">Usar Encuesta</td>
			  <td colspan="3">
			  <select name="Eid" id="Eid">
			  <cfloop query="encu">
				<option value="#encu.Eid#" <cfif rhe.ETid EQ encu.ETid>selected</cfif>>#HTMLEditFormat(encu.Edescripcion)#</option>
				</cfloop>
			  </select>	  </td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td valign="top">&nbsp;</td>
			  <td valign="top"><input type="checkbox" id="RHEdefault" name="RHEdefault" value="1" <cfif rhe.RHEdefault IS 1>checked</cfif>> </td>
			  <td colspan="2" valign="top"><label for="RHEdefault"><strong>Preferida</strong><br>
				Esta encuestadora se utilizar&aacute; de manera predeterminada al realizar comparaciones.</label> </td>
			  <td valign="top">&nbsp;</td>
			</tr>
			<tr>
			  <td valign="top">&nbsp;</td>
			  <td valign="top"><input type="checkbox" id="RHEinactiva" name="RHEinactiva" value="1" <cfif rhe.RHEinactiva IS 1>checked</cfif>></td>
			  <td colspan="2" valign="top"><label for="RHEinactiva"><strong>Inactiva</strong><br>
				Seleccione esta casilla si desea inhabilitar esta encuestadora, pero no quiere borrar la configuraci&oacute;n de puestos que haya realizado. </label></td>
			  <td valign="top">&nbsp;</td>
			</tr>
			<tr>
			  <td valign="top">&nbsp;</td>
			  <td valign="top">&nbsp;</td>
			  <td colspan="3" valign="top">&nbsp;</td>
			  <td valign="top">&nbsp;</td>
			</tr>
			<tr>
			  <td valign="top">&nbsp;</td>
			  <td colspan="4" valign="top" align="center">
			  
				<input type="hidden" name="EEid" value="#HTMLEditFormat(EEid)#">
				<input type="button" value="Regresar" onClick="location.href='RHEncuestadora.cfm'">
				<input type="submit" value="Eliminar" name="borrar" onClick="return(confirm('¿Está seguro de que desea eliminar esta encuestadora?.  Si confirma, se eliminará toda la configuración de puestos asociada con ella.'))">
			 <!---  <input type="submit" value="Relacionar Puestos&gt;&gt;"> --->
			  </td>
			  <td valign="top">&nbsp;</td>
			</tr>
			<tr>
			<td valign="top">&nbsp;</td>
			<td colspan="4" valign="top">&nbsp;</td>
			<td valign="top">&nbsp;</td>
		  </tr>
		</table>
	</form>
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>	


