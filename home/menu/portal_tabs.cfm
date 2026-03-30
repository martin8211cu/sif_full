<cfparam name="session.menues.omite_pnavegacion" default="1">

<cfinclude template="portal_control.cfm">

<cfset cuando_empieza = now()>

<cfquery datasource="asp" name="ubicacionSS">
	select SScodigo, SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
</cfquery>
<cfquery datasource="asp" name="ubicacionSM">
	select SMcodigo, SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
</cfquery>
<cfquery datasource="asp" name="ubicacionSP">
	select SPcodigo, SPdescripcion
	from SProcesos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
	  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
</cfquery>

<cfif Len(session.menues.id_item)>
	<cfquery datasource="asp" name="ubicacionMenu">
		select r.profundidad, p.etiqueta_item
		from SRelacionado r
			join SMenuItem p
				on p.id_item = r.id_padre
		where r.id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.menues.id_item#">
		  and p.id_item != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.menues.id_root#">
		order by r.profundidad desc
	</cfquery>
</cfif>

	<table width="955" border="0" cellpadding="0" cellspacing="0">
      <!--DWLayoutTable-->
      <tr>
        <td valign="top" align="center" >
		<cfif session.Usucodigo>
            <!-- menu start -->
			<cfinclude template="portlets/menu-content.cfm">
            <!-- menu end -->
		<cfelse>
            <a href="../../home/public/login.cfm">Ingresar al sistema</a>
		</cfif>
        </td>
      </tr>

	  <cfif Len(Trim(ubicacionSS.SSdescripcion)) Or Len(Trim(ubicacionSM.SMdescripcion)) Or Len(Trim(ubicacionSP.SPdescripcion))>
      <tr class="navbar">
        <td height="8" colspan="3" valign="top" ><table  >
            <tr>
			<cfif IsDefined('ubicacionMenu')>
			  <cfoutput query="ubicacionMenu">
			  <td nowrap>#HTMLEditFormat(ubicacionMenu.etiqueta_item)#</td>
			  <cfif CurrentRow LT RecordCount>
	              <td>&gt;</td></cfif>
              </cfoutput>
			<cfelse>
              <td nowrap><cfoutput>#HTMLEditFormat(ubicacionSS.SSdescripcion)#</cfoutput></td><td>&gt;</td>
              <td nowrap><cfoutput>#HTMLEditFormat(ubicacionSM.SMdescripcion)#</cfoutput></td><td>&gt;</td>
              <td nowrap><cfoutput>#HTMLEditFormat(ubicacionSP.SPdescripcion)#</cfoutput></td>
			</cfif>
              <cfif IsDefined("Regresar") and Len(Regresar) Neq 0>
                <cfset Regresar2 = Replace(Regresar,'/cfmx','')>
				<cfparam name="nav__SPhomeuri" default="">
                <cfif (Regresar2 neq nav__SPhomeuri) and IsDefined('acceso_uri') And acceso_uri(Regresar2)>
                  <td nowrap>&gt;</td>
                  <td nowrap><cfoutput><a tabindex="-1" href="/cfmx#Regresar2#">Regresar</a></cfoutput></td>
                </cfif>
              </cfif>
              <td width="100%" align="right">
				<cfquery name="dataRelacionados" datasource="asp">
					select SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri
					from SProcesoRelacionado a

					inner join SProcesos b
					on a.SSdestino=b.SScodigo
					 and a.SMdestino=b.SMcodigo
					 and a.SPdestino=b.SPcodigo
					 and SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	 	 			 and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
	 				 and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">

					order by posicion
				</cfquery>
				<cfif dataRelacionados.recordCount gt 0 >
					<form name="relacionados" style="margin:0; " action="/cfmx/home/menu/portal.cfm" method="get">
						<input type="hidden" name="_nav" value="1">
						<input type="hidden" name="s" value="">
						<input type="hidden" name="m" value="">
						<input type="hidden" name="p" value="">
						<table width="100%" align="right" cellpadding="0" cellspacing="0">
							<tr>
								<td width="99%" align="right" valign="middle"><strong>Relacionados:&nbsp;</strong></td>
								<td>
									<select onChange="javascript:relacionar(this)">
									<option value="">-- seleccionar --</option>
									<cfoutput query="dataRelacionados">
										<option value="#dataRelacionados.SScodigo#/#dataRelacionados.SMcodigo#/#dataRelacionados.SPcodigo#">#dataRelacionados.SPdescripcion#</option>
									</cfoutput>
									</select>
								</td>
							</tr>
						</table>
					<script language="javascript1.2" type="text/javascript">
						function relacionar(obj){
							if ( obj.value != '' ){
								var info = obj.value.split('/')
								document.relacionados.s.value = info[0];
								document.relacionados.m.value = info[1];
								document.relacionados.p.value = info[2];
								document.relacionados.submit();
							}
						}
					</script>
					</form>
				</cfif>
			  </td>
            </tr>
        </table></td>
      </tr></cfif>
	  <cfif Len(ubicacionSP.SPdescripcion)>
      <tr  class="navbar">
        <td height="8" colspan="8" valign="top" align="left" class="tituloProceso" style="font-size:larger;text-align:left"><cfoutput>#HTMLEditFormat(ubicacionSP.SPdescripcion)#</cfoutput></td>
      </tr></cfif>
    </table>
