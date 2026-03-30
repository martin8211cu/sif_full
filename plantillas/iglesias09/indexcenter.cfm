<table width="463"  border="0" cellpadding="0" cellspacing="0">
  <tr class="right">
    <td colspan="2"><img src="imagenes/fon01.gif" width="463" height="29"></td>
  </tr>
  <tr class="right">
    <td colspan="2" class="right">
	  &nbsp;&nbsp;<b>Nuestros Servicios</b><br><br>
	  <blockquote>La siguiente es una lista de nuestros servicios, haga click en las fotograf&iacute;as al lado de cada descripci&oacute;n para ingresar a esa secci&oacute;n del sitio. Aqu&iacute; usted podr&aacute; leer la biblia en l&iacute;nea, estudiar los fundamentos de nuestra iglesia, suscribirse para recibir la palabra y mucho m&aacute;s.<br>
	  </blockquote><br>
    </td>
  </tr>
  <tr class="right">
    <td align="center" valign="middle"><a href="biblia.cfm"><img alt="" src="imagenes/Biblia4.gif" width="135" height="100" border="0"></a></td>
    <td align="left" valign="middle">Ahora es m&aacute;s f&aacute;cil leer la Biblia, lea aqu&iacute; la biblia en l&iacute;nea, podr&aacute; consultar desde un vers&iacute;culo en espec&iacute;fico hasta un cap&iacute;tulo entero. </td>
  </tr>
  <tr class="right">
    <td align="right" valign="middle">Fundamento de las Asambleas de Dios, encuentre aqu&iacute; todo acerca de nuestros fundamentos y directrices.</td>
    <td align="center" valign="middle"><a href="doctrina.cfm"><img alt="" src="imagenes/Familia2.gif" width="135" height="100" border="0"></a></td>
  </tr>
  <tr class="right">
    <td align="center" valign="middle"><a href="misiones.cfm"><img alt="" src="imagenes/Familia1.jpg" width="135" height="100" border="0"></a></td>
    <td align="left" valign="middle">"Id por el mundo y predicad el evangelio a toda criatura" Marcos 16:15</td>
  </tr>
  <tr class="right">
    <td align="right" valign="middle">Lee la palabra de Dios todos los d&iacute;as de tu vida y en ella encontraras vida eterna</td>
    <td align="center" valign="middle"><a href="palabradiaria.cfm"><img alt="" src="imagenes/biblia3.gif" width="135" height="100" border="0"></a></td>
  </tr>
  <tr class="right">
    <td align="center" valign="middle"><a href="mailto:evangelio-alta@listas.evangelizacion.org.mx"><img alt="" src="imagenes/Email4.jpg" width="135" height="100" border="0"></a></td>
    <td align="left" valign="middle">Recibe el Evangelio diariamente</td>
  </tr>
  <cfif isdefined("session.Usucodigo")>
    <cfquery name="rsSIF" datasource="asp">
    select e.Ecodigo from UsuarioProceso up, Empresa e where up.Usucodigo =
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
    and up.SScodigo = 'SIF' and e.Ereferencia =
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and e.Ecodigo = up.Ecodigo
    </cfquery>
    <cfquery name="rsRH" datasource="asp">
    select e.Ecodigo from UsuarioProceso up, Empresa e where up.Usucodigo =
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
    and up.SScodigo = 'RH' and e.Ereferencia =
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and e.Ecodigo = up.Ecodigo
    </cfquery>
    <cfoutput>
      <cfif rsSIF.RecordCount gt 0>
        <tr class="right">
          <td align="right" valign="middle">Sistema Financiero Integral</td>
          <td align="left" valign="middle"><a href="/cfmx/home/menu/sistema.cfm?e=#rsSIF.Ecodigo#&amp;s=SIF"><img alt="" src="imagenes/sif.gif" width="135" height="100" border="0"></a></td>
        </tr>
      </cfif>
      <cfif rsRH.RecordCount gt 0>
        <tr class="right">
          <td align="right" valign="middle"><a href="/cfmx/home/menu/sistema.cfm?e=#rsRH.Ecodigo#&amp;s=RH"><img alt="" src="imagenes/rh.gif" width="135" height="100" border="0"></a></td>
          <td align="left" valign="middle">Recursos Humanos</td>
        </tr>
      </cfif>
    </cfoutput>
  </cfif>
  <tr>
    <td colspan="2" align="center" background="imagenes/e02.gif" height="12"></td>
  </tr>
  <tr class="right">
    <td colspan="2" class="right">
      &nbsp;&nbsp;<strong>Otros Servicios de SoyCristiano.net</strong>
      <ul>
        <li>Servicios Financieros<br>
			Usted podr&aacute; contar con sistemas de apoyo financiero y contable, de clase mundial, y a una tarifa acorde a las necesidades de usted y su empresa. </li>
        <li>Servicios de Recursos Humanos<br>
			Cada d&iacute;a es m&aacute;s valiosa la correcta administraci&oacute;n del recurso humano en su empresa. </li>
        <li>Presentaci&oacute;n y Pago de Facturas<br>
			Haga m&aacute;s eficiente sus procesos de cobro atrav&eacute;s de una econom&iacute;a digital integrada. </li>
        <li>Educaci&oacute;n del ma&ntilde;ana<br>
			Este al tanto de la educaci&oacute;n de sus seres queridos. </li>
      </ul>
      <div align="center">En caso de que desee m&aacute;s informaci&oacute;n contactenos a:<br><a href="mailto:asp@soycristino.net">asp@soycristino.net</a></div>
	</td>
  </tr>
</table>
