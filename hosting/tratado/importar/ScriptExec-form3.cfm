<cfquery name="rsScript" datasource="sifcontrol">
	select EIid, EIcodigo, EImodulo, EIexporta, EIimporta, EIdescripcion
	from EImportador
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
	order by upper(EIcodigo)
</cfquery>

<cfquery name="rsDetalle" datasource="sifcontrol">
	select DInumero, DInombre, DIdescripcion, DItipo, DIlongitud
	from DImportador
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
	and DInumero < 0
</cfquery>

<cfif rsScript.EIimporta EQ 1>
	<cfset modo = "in">
<cfelseif rsScript.EIexporta EQ 1>
	<cfset modo = "out">
</cfif>

<cfoutput>
	<cfif isdefined("modo")>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td colspan="2" align="center">&nbsp;</td>
	      </tr>
		<tr>
		  <td align="right" style="padding-right: 10px; "><strong>Empresa:</strong></td>
		  <td>#Session.Enombre#</td>
		</tr>
		<tr> 
			<td align="right" width="30%" style="padding-right: 10px; ">
				<strong>Script a ejecutar:</strong>
			</td>
			<td> 
				#rsScript.EIcodigo# - #rsScript.EIdescripcion#
			</td>
		</tr>
		  <tr>
		  	<td align="center">&nbsp;</td>
			<td>
				<cf_sifimportar EIcodigo="#rsScript.EIcodigo#" mode="#modo#">
					<cfloop collection="#Form#" item="key">
						<cf_sifimportarparam name="#key#" value="#StructFind(Form, key)#">
					</cfloop>
				</cf_sifimportar>
			</td>
		  </tr>
		  <tr>
		    <td colspan="2" align="center">
				<form name="frmScript" action="ScriptExec.cfm" method="post">
					<input type="hidden" name="EIid" value="#Form.EIid#">
					<input type="hidden" name="paso" value="#Form.paso_ant#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td align="center">
							<input name="btnAnterior" type="submit" id="btnAnterior" value="<< Anterior">
						</td>
					  </tr>
					</table>
				</form>
			</td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center">&nbsp;</td>
	      </tr>
		</table>
	</cfif>
</cfoutput>
