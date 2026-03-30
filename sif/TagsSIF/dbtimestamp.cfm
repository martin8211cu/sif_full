<cfparam name="Attributes.datasource" default="">
<cfparam name="Attributes.table"      type="string">
<cfparam name="Attributes.redirect"   type="string">
<cfparam name="Attributes.timestamp"  type="string">

<cf_templatecss>

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfquery datasource="#Attributes.datasource#" name="timestamp_viejo">
select ts_rversion
from #Attributes.table#
<cfloop from="1" to="99" index="i">
	<cfif Not IsDefined('Attributes.field' & i)>
		<cfbreak>
	</cfif>
	<cfif IsDefined("Attributes.type" & i) And IsDefined("Attributes.value" & i)>
		<cfset field_name  = Attributes['field'&i]>
		<cfset field_type  = Attributes['type'&i]>
		<cfset field_value = Attributes['value'&i]>
	<cfelse>
		<cfset field_i = Attributes['field'&i]>
		<cfset p1 = Find(',',field_i)>
		<cfif p1 is 0><cf_errorCode	code = "50659"
		              				msg  = "field@errorDat_1@ invalido: @errorDat_2@"
		              				errorDat_1="#i#"
		              				errorDat_2="#field_i#"
		              ></cfif>
		<cfset p2 = Find(',',field_i,p1+1)>
		<cfif p2 is 0><cf_errorCode	code = "50659"
		              				msg  = "field@errorDat_1@ invalido: @errorDat_2@"
		              				errorDat_1="#i#"
		              				errorDat_2="#field_i#"
		              ></cfif>
		<cfset field_name = Left(field_i, p1-1)>
		<cfset field_type = Mid(field_i,p1+1,p2-p1-1)>
		<cfset field_value = Mid(field_i,p2+1,Len(field_i)-p2)>
	</cfif>
	<cfif i is 1>where <cfelse> and </cfif>
	#field_name# = <cfqueryparam cfsqltype="cf_sql_#field_type#" value="#field_value#">
</cfloop>
</cfquery>

<cfinvoke component="sif.Componentes.DButils"
	method="toTimeStamp"
	arTimeStamp="#timestamp_viejo.ts_rversion#" returnvariable="timestamp_viejo">
</cfinvoke>
<cfif timestamp_viejo neq Attributes.timestamp>
		<br>
		<cftry><cftransaction action="rollback"/><cfcatch type="any"></cfcatch></cftry>
		<cfoutput>
<table width="918" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td width="77">&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="25" bgcolor="##003366" ><font color="##FFFFFF"><img src="/cfmx/home/public/error/Stop01_T.gif" width="25" height="25"></font></td>
		<td width="722" bgcolor="##003366" ><span style="color:white;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold ">Reporte de error</span></td>
		<td width="78">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
		<td valign="top" bgcolor="##F5F5F5" class="contenido-rborder">
			<p>
			
			Reporte de error</strong>
			<br>
			<br>
			
			</p></td>
		<td>&nbsp;</td>
	</tr>
	
	<tr> 
		<td>&nbsp;</td>
		<td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder">&nbsp;</td>
		<td valign="top" bgcolor="##F5F5F5" class="contenido-rborder"  style="color:##FF3300;font-size:14px;font-weight:bold">
No se puede actualizar el registro en la base de datos, debido a que otro usuario o proceso ya
		hab&iacute;a modificado el mismo registro que usted estaba intentando modificar.
	  </td>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
	  <td>&nbsp;</td>
	  <td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder">&nbsp;</td>
	  <td valign="top" bgcolor="##F5F5F5" class="contenido-rborder">&nbsp;</td>
	  <td>&nbsp;</td>
    </tr>
	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lrborder" align="center">
			<form action="#Attributes.redirect#" method="post" name="form1">
		<cfset fields = StructKeyArray(Form)>
		<cfloop from="1" to="#ArrayLen(fields)#" index="i">
			<cfif fields[i] neq 'FIELDNAMES'>
			<input type="hidden" name="#fields[i]#" value="#form[fields[i]]#">
			</cfif>
		</cfloop>
		<input type="submit" name="reload_values_from_database" value="Editar el registro nuevamente">
		
		</form>
		
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>

	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
    </tr>

</table>		
		</cfoutput>
		
	<cfabort>
</cfif>

