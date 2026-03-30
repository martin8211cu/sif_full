
<table width="100%" cellpadding="0" cellspacing="0">	
	<tr>
		<td>
			<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cfinclude template="frame-infoEmpleado.cfm"></td></tr>
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			<cfoutput>
				<cfset session.DEid = rsEmpleado.DEid>
				
				<cfif not (isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)))>
					<cfquery name="puesto" datasource="#session.DSN#">
						select RHPcodigo
						from LineaTiempo
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.DEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
					</cfquery>
					<cfset session.RHPcodigo = puesto.RHPcodigo >
				<cfelse>
					<cfset session.RHPcodigo = trim(url.RHPcodigo) >
				</cfif>
				
				<center>
				  <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
					codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,0,0" width="819" height="519" id="benzinger" align="middle">
					<param name="allowScriptAccess" value="sameDomain" />
					<param name="movie" value="/cfmx/rh/expediente/consultas/comparativo_benzinger.swf?qwe" />
					<param name="quality" value="high" />
					<param name="bgcolor" value="##ffffff" />
					<embed src="/cfmx/rh/expediente/consultas/comparativo_benzinger.swf?qwe" quality="high" bgcolor="##ffffff" width="819" height="519" name="benzinger" 
					align="middle" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />  
				</object>
				</center>
			</cfoutput>
		</td>
	</tr>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<form name="form1" action="expediente-globalcons.cfm">			
				<input type="hidden" name="DEid" value="<cfif isdefined("rsEmpleado.DEid") and len(trim(rsEmpleado.DEid))><cfoutput>#rsEmpleado.DEid#</cfoutput></cfif>">
			<cfif CompareNoCase(GetFileFromPath(GetTemplatePath()), 'conlisBezinger.cfm') EQ 0>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cerrar"
					Default="Cerrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Cerrar"/>
				<input type="submit" value="<cfoutput>#BTN_Cerrar#</cfoutput>" name="Cerrar" onClick="javascript: window.close();" tabindex="1">
			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>

				<input type="submit" name="regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1"><!---onClick="javascript: location.href = 'expediente-globalcons.cfm?sel=1&o=1&DEid=#rsEmpleado.DEid#'"---->
			</cfif>
			</form>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>