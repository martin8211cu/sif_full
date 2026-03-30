<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<!--- CONSULTA QUE BUSCA LOS DATOS PARA EL REPORTE --->
<!--- ME TRAE LOS DATOS DE LAS PERSONAS QUE NO HA SIDO AFILIADAS --->
<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="30">
	select {fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})} as DEnombre,
    DEsexo, DEdireccion,DEfechanac,
    DEdato1, DEdato6, DEinfo2, DEinfo3, DEobs1, DEobs2
	from DatosEmpleado 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
<!--- DATOS DE LA EMPRESA --->
<cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
    select {fn concat(direccion1,{fn concat(', ',direccion2)})} as direccion, estado, Pnombre
    from Empresa a
    inner join Direcciones b
          on b.id_direccion = a.id_direccion
    inner join Pais p
    	on p.Ppais = b.Ppais
    where a.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery> 
<!--- DATOS DE PARAMETROS PARA EL REPORTE --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" Ecodigo="#session.Ecodigo#" Pvalor="300" default="" returnvariable="Patrono"/>
<cfinclude template="SolicitudAfiliacionIGSS-Traduccion.cfm">

<table width="100%" border="0" align="center">
    <cfoutput>
    <tr><td colspan="3"></td></tr>
    <tr><td align="center" colspan="3"><font size="2">#LB_PLANILLADEAFILIACION#</font> </td></tr>
    <tr><td align="center" colspan="3"><font size="2">#LB_DIVISIONDEREGISTRODEPATRONOSYTRABAJADORES#</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr>
        <td width="60%"><font size="2">1.#LB_NUMEROPATRONAL#:&nbsp;<font size="2">#Patrono#</font></td>
        <td width="40%%" nowrap="nowrap"><font size="2">2.#LB_NOMBREDELPATRONOORAZONSOCIAL#:</td>
    </tr>
    <tr>
        <td width="50%" nowrap="nowrap"><font size="2">3.#LB_NOMBREDELAEMPRESA#:&nbsp;#session.Enombre#</font></td>
        <td width="50%"><font size="2">#session.Enombre#</font></td>
    </tr>
    <tr>
        <td width="50%"></td>
      <td width="50%"><font size="2">4.#LB_DIRECCIONDELAEMPRESA#</font></td>
    </tr>
    <tr>
        <td width="50%">&nbsp;</td>
      <td width="50%">&nbsp;<font size="2">#rsDatosEmpresa.direccion#</font></td>
    </tr>
    <tr>
        <td width="50%"><font size="2">5.#LB_DEPARTAMENTODELAREPUBLICADONDELABORANLOSTRABAJADORES#:</font></td>
        <td width="50%"><font size="2">6.#LB_CODIGOGEOGRAFICO#</font></td>
    </tr>
    <tr>
        <td width="50%">&nbsp;<font size="2">#rsDatosEmpresa.Estado#</font></td>
        <td width="50%" align="right">
            <table width="50%" border="1" cellspacing="0" cellpadding="0">
                <tr><td>&nbsp;</td></tr>
            </table>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    </cfoutput>
    <tr>
        <td colspan="3">
            <table width="100%" border="1" cellspacing="0" cellpadding="0" style="border-color:000000; border-width:thin;">
                <tr class="tablaconborde">
                    <td width="34%" nowrap="nowrap" ><font size="1">7. A.&nbsp;<cfoutput>#LB_APELLIDOYNOMBRECOMPLETOSDELTRABAJADOR#</cfoutput></font></td>
                    <td width="13%" nowrap="nowrap" rowspan="2" valign="top"><font size="1">8.<cfoutput>#LB_APELLIDOESPOSO#</cfoutput></font></td>
                    <td width="9%" nowrap="nowrap" colspan="2"><font size="1">9.<cfoutput>#LB_SEXO#</cfoutput></font></td>
                    <td width="11%" nowrap="nowrap" colspan="3"><font size="1">10.<cfoutput>#LB_FECHADENACIMIENTO#</cfoutput></font></td>
                    <td width="25%" nowrap="nowrap" colspan="2"><font size="1">11.<cfoutput>#LB_CEDULADEVECINDAD#</cfoutput></font></td>
                    <td width="8%" nowrap="nowrap" valign="top" rowspan="2"><font size="1">12.<cfoutput>#LB_NODEAFILIACION#</cfoutput></font></td>
                </tr>
                <tr>
                    <td valign="bottom">&nbsp;&nbsp;&nbsp;<font size="1">B.&nbsp;<cfoutput>#LB_DOMICILIODELTRABAJADOR#</cfoutput></font></td>
                  <td align="center"><font size="1"><cfoutput>#LB_M#</cfoutput></font></td>
                    <td align="center"><font size="1"><cfoutput>#LB_F#</cfoutput></font></td>
                    <td align="center"><font size="1"><cfoutput>#LB_DIA#</cfoutput></font></td>
                    <td align="center"><font size="1"><cfoutput>#LB_MES#</cfoutput></font></td>
                    <td align="center"><font size="1"><cfoutput>#LB_ANNO#</cfoutput></font></td>
                    <td nowrap="nowrap"><font size="1">A.<cfoutput>#LB_NODEORDEN# <br />B.#LB_REGISTRO#</cfoutput></font></td>
                    <td nowrap="nowrap"><font size="1">A.<cfoutput>#LB_MUNICIPIO#<br />B.#LB_DEPARTAMENTO#</cfoutput></font></td>
                </tr>
                <cfoutput query="rsREporte">
                <tr>
                    <cfset Lvar_Dia = DatePart('d',DEFechanac)>
                    <cfset Lvar_Mes = DatePart('m',DEFechanac)>
                    <cfset Lvar_Anno = DatePart('yyyy',DEFechanac)>
                    <td valign="bottom"><font size="1">A.&nbsp;#DEnombre#<br />B.&nbsp;#DEDireccion#</font></td>
                    <td width="13%" valign="top" ><font size="1"><cfif LEN(TRIM(DEdato6))>#DEdato6#<cfelse>&nbsp;</cfif></font></td>
                    <td align="center"><font size="1"><cfif DESexo EQ 'M'>X<cfelse>&nbsp;</cfif></font></td>
                    <td align="center"><font size="1"><cfif DESexo EQ 'F'>X<cfelse>&nbsp;</cfif></font></td>
                    <td align="center"><font size="1">#Lvar_Dia#</font></td>
                    <td align="center"><font size="1">#Lvar_Mes#</font></td>
                    <td align="center"><font size="1">#Lvar_Anno#</font></td>
                    <td nowrap="nowrap"><font size="1">A.&nbsp;#DEobs1# <br />B.&nbsp;#DEobs2#</font></td>
                    <td nowrap="nowrap"><font size="1">A.&nbsp;#DEinfo3#<br />B.&nbsp;#DEinfo2#</font></td>
                    <td width="8%" nowrap="nowrap" valign="top"><font size="1">&nbsp;</font></td>
                </tr>
                </cfoutput>
            </table>
        </td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr>
    	<td valign="top"><cfoutput><font size="2">#LB_LUGARYFECHA#:&nbsp;#rsDatosEmpresa.Pnombre#&nbsp;&nbsp;#LSDateFormat(Now(),'dd/mm/yyyy')#</font></cfoutput></td>
        <td>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="30%" nowrap="nowrap"><cfoutput><font size="2">#LB_FIRMAYSELLO#:</font></cfoutput></td>
                  <td width="70%" style="text-decoration:underline">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td><cfoutput><font size="1">#LB_PATRONOOREPRESENTANTE#</font></cfoutput></td>
                </tr>
            </table>

        </td>
    </tr>
</table>
